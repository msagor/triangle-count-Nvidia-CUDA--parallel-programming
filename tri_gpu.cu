/*--------------------------------------------------------------------------- */
/* tri_gpu: compute the number of triangles in a graph (GPU method) */
/*--------------------------------------------------------------------------- */

// READ THIS:
// This code is way over-commented because I'm giving you lots of instruction
// on how to write a CUDA kernel and its CPU driver.  Please delete ALL C++
// style comments in this file (and only this file) that used the '//' comment
// style!  Replace them with your own that describe how you solved each part of
// this problem.  Keep the comments in the old style /* like this */, since
// those are useful.  Feel free to rewrite those /*comments*/ if you like.

#include "tri_def.h"

// I recommend using a 2D array of threads, x-by-y, since you have two nested
// for loops in the code below.  I recommend a single 1D array of threadblocks.
// Each threadblock must do only one column (or node) j at a time, since it
// needs to use the Mark array of size n to mark the neighbors of j, for use in
// the two nested loops.  I will let you figure out the dimensions to use.  If
// you are having trouble getting the code to work, try one block with a single
// thread (1-by-1 thread grid).  You won't have any synchronization problems,
// but of course your code will be exceedingly slow.

// However, if you want to use a 1D array of threads, feel free to do so.  Just
// be sure to keep things parallel.  Don't force one thread in the threadblock
// to do just one iteration of the "for (p = ...)" iteration below, for
// example.  That will painfully be slow (and points taken off for a bad
// algorithm).

// NBLOCKS needs to be large enough to keep the 13 SMs on GPU busy.  Don't make
// NBLOCKS too high, however.  Your kernel will need a Marks array of size
// NBLOCKS*n, so that each threadblock and have its own private Mark arry of
// size n.  If NBLOCKS is high you will use all the GPU memory for the Marks
// array, and you won't be able to solve the problems on the GPU.

/* -------------------------------------------------------------------------- */
/* tri_kernel: GPU kernel */
/* -------------------------------------------------------------------------- */

/* launched with <<<NBLOCKS, dim3(NX,NY)>>> */
// or modify it to launch with <<<NBLOCKS,NTHREADS>>> as you prefer
#define NBLOCKS 512 //TODO           /* gridDim.x                                */
#define NX 28	    //TODO           /* blockDim.x (# of threads in x dimension) */
#define NY 29	    //TODO           /* blockDim.y (# of threads in y dimension) */
#define NTHREADS (NY * NX)

__global__ void tri_kernel
(
    /* inputs, not modified: */
    const int *Ap,              /* column pointers, size n+1        */
    const int *Ai,              /* row indices                      */
    const int n,                /* A has n ndoes                    */
    /* workspace */
    bool *Marks,                /* size NBLOCKS*n so each threadblock has */
                                /* its own array of size n                */
    /* output: */
    int64_t Ntri_result [NBLOCKS] /* # triangles found by each threadblock */
)
{

    //POINTING THE Mark VARIABLE TO THE RIGHT POSITIONING OF THE MARKS ARRAY FOR THAT PARTICULAR BLOCKID
    bool *Mark = Marks + (n*blockIdx.x);	//TODO

    
	//CREATING A GLOBAL ID FOR EACH THREAD IN A BLOCK. WE ARE GOING TO ASSIGIN
	//THE FOR LOOP GOES FROM 0 TO n AND INCREMENTS BY NTHREADS.
	//ITS NOT THAT ALL THE THREADS IN A BLOCK WORK IN SEQUENCE, RATHER EACH THREAD WILL GRAB HIS OWN ID AND DO ITS JOB
	//HERE, WE ARE EMPTYING OUT THE MARK ARRAY FOR THAT SPECIFIC BLOCKID
    int id =  threadIdx.y * blockDim.x + threadIdx.x ; 	 //TODO
    for (int i = id ; i < n ; i+=NTHREADS)   //TODO
    {
        Mark [i] = 0 ;
    }


    /* ensure all threads have cleared the Mark array */
    // What happens if some threads in this threadblock finish clearing their
    // part of Mark, and then they start the work below before some other
    // threads have finished clearing their part of Mark?  Race condition!  I
    // put this sync threads here for you.  You will need more elsewhere in
    // this kernel.  I will let you figure out where.  When in doubt, extra
    // syncthreads are not usually harmful to code correctness (too many can
    // slow your code down however).
    __syncthreads ( ) ;

    /* each thread counts its own triangles in nt */
    // This variable is local to each thread.
    int64_t nt = 0 ;

    /* count the triangles for node j, aka A(:,j) of the adjacency matrix */
    //ASSIGINING EACH BLOCKS JOB FOR EACH COLUMN OF MATRIX TO DO THE JOB 
	//IF THE BLOCK NUMBER IS SMALLER THAN COLUMN NUMBER THEN SOME BLOCK(FULL OF THREADS) JUST NEVER WORK
	//ALSO EACH BLOCK DOES WORK ON EVERY NBLOCKS-th BLOCK AND INCREMENTS BY THE NUMBER OF BLOCKS
    for (int j = blockIdx.x  ; j < n; j+=NBLOCKS)  //TODO
    {

        /* All threads in a threadblock are working on this node j, */
        /* equivalently, column A(:,j) of the adjacency matrix A */

       
        /* scatter A(:,j) into Mark, marking all nodes adjacent to node j */
		//THIS FOR LOOP, JUST PICKS UP THE INDEX REGION IT NEEDS TO ITERATE OVER
		//FOR EACH J, WE GO TO THE SPECIFIC INDEX OF ARRAY Ap[] AND GO UNTIL THE NEXT INDEX OF THE ARRAY
		//WE PUT 1 TO THE INDEX OF MARK ARRAY WHERE WE FIND AN EDGE SO THAT WE CAN COUNT THE EDGES NEXT
		//USDE THE id VARIABLE BECAUSE id VARIABLE CONTAINS blockidx.x, threadidx.x, threadidx.y SO THAT EACH THREAD IS DOING INDIVIDUAL REGION OF EACH COLUMN
        for (int p = Ap[j]+id  ; p< Ap[j+1] ; p=p+NTHREADS)  //TODO
        {
            int i = Ai [p] ;
            /* edge (i,j) exists in the graph, mark node i */
            Mark [i] = 1 ;
        }
        __syncthreads( );
        /* compute sum(C(:,j)) where C=(A*A(:,j))*.(A(:,j)) */

        //THESE TWO FOR LOOPS ARE THE MEAT OF THE PROJECT
		//THE OUTER FOR LOOP GOING X DIRECTION AND THE INNER FOR LOOP GOING Y DIRECTION OF THE MATRIX
		//FOR EACH NODE FOUND IN THE COLUMN(OUTER LOOP), WE SEE HOW MANY MANY FRIEND THIS NODE HAS
		//FOR EACH FRIENDS, WE SEE IF THAT FRIEND IS ALSO THE CURRENT NODE'S FRIEND(INNER LOOP)
		//IF A FRIEND OF FRIEND IS ALSO MY FRIENDS, THAT MAKES A TRIANGLE, WE INCREMENT nt VARIABLE IF WE DETECT SUCH PHENOMENON
        for (int p = Ap[j]+threadIdx.x  ; p< Ap[j+1] ; p=p+NX)   //TODO
        {
            int k = Ai [p] ;
            /* edge (k,j) exists in the graph */
            for (int pa = Ap[k]+threadIdx.y ; pa < Ap[k+1] ; pa=pa+NY)  //TODO
            {
                int i = Ai [pa] ;
                /* edge (i,k) exists, count a triangle if (i,j) also exists */
                nt += Mark [i] ;
            }
        }

		__syncthreads ( ) ;
		
        /* clear Mark for the next iteration */
		//WE CLEAR THE Mark[] ARRAY SAME WAY WE FILLED IT UP 
		//THIS FOR LOOP IS EXACTLY THE SAME AS ABOVE
        for (int p = Ap[j]+id  ; p< Ap[j+1] ; p=p+NTHREADS)  //TODO
        {
            int i = Ai [p] ;
            /* edge (i,j) exists in the graph, mark node i */
            Mark [i] = 0 ;
        }

		__syncthreads ( ) ;
		
        /* now all of Mark[0..n-1] is all zero again */
        
        // only a few of the entries in Mark have been used in this jth
        // iteration.
    }
	
    /* each thread copies its result, nt, into a shared array, Ntri */
    // Ntri is a shared array of size Ntri[blockDim.y][blockDim.x] ; but size
    // must be constant so NY and NX are used.  Every thread saves its triangle
    // count in this __shared__ array so the results can be summed up for this
    // threadblock.  This part is done for you:
    __shared__ int Ntri [NY][NX] ;
    Ntri [threadIdx.y][threadIdx.x] = nt ;
    __syncthreads ( ) ;

    /* sum up all of Ntri and then one thread writes result to */
    /* Ntri_result [blockIdx.x] */
    // Now sum up all the triangles found by this threadblock,
    // Ntri_result [blockIdx.x] = sum (Ntri).  In your first attempt,
    // I recommend using thread (0,0) to do this work all by itself.
    // But don't stop there, do this reduction in parallel.
    // Figure this out yourself.
    //TODO
	//THIS REUCTION IS DONE IN PARALLEL ONLY BY THREAD 0,0
	//THIS TAKES ALL THE COUNTED TRIANGLE BY EACH NODE AND PUTS THEM IN Ntr_result[] WHICH KEEPS COUNT FOR EACH BLOCK
	if(id==0){
		Ntri_result[blockIdx.x] = 0;
		for(int y =0 ;y < NY; y++){
			for(int x =0; x < NX ; x++ ){
				Ntri_result [blockIdx.x]+= Ntri [y][x];
			}
		}
		
		__syncthreads ( ) ;
	//printf("-----The Ntri_result[] for block %d is %i \n",blockIdx.x , Ntri_result[blockIdx.x]);
	}

	
}


/* call a cuda method and check its error code */
// This is written for you already.
#define OK(method)                                          \
{                                                           \
    err = method ;                                          \
    if (err != cudaSuccess)                                 \
    {                                                       \
        printf ("ERROR: line %d\n%s\n", __LINE__,           \
            cudaGetErrorString (err)) ;                     \
        exit (1) ;                                          \
    }                                                       \
}

/* -------------------------------------------------------------------------- */
/* tri_gpu: driver function that runs on the host CPU */
/* -------------------------------------------------------------------------- */

int64_t tri_gpu         /* # of triangles                       */
(
    const int *Ap,      /* node pointers, size n+1              */
    const int *Ai,      /* adjacency lists, size ne = Ap [n]    */
    const int n         /* number of nodes in the graph         */
)
{
    cudaError_t err = cudaSuccess ;

    /* allocate the graph on the GPU */
    // This is written for you already.
    int ne = Ap [n] ;
    int *d_Ap, *d_Ai ;
    OK (cudaMalloc (&d_Ap, (n+1) * sizeof (int))) ;
    OK (cudaMalloc (&d_Ai, (ne ) * sizeof (int))) ;

    /* copy the graph to the GPU */
    //COPYING THE GRAPH FORM THE CPU TO THE GPU
    OK (cudaMemcpy (d_Ap,   Ap,   (n+1) * sizeof(int),   cudaMemcpyHostToDevice));  //TODO
    OK (cudaMemcpy (d_Ai,   Ai,   (ne ) * sizeof(int),   cudaMemcpyHostToDevice));	//TODO

    /* allocate workspace on the GPU */
    /* Marks array of size NBLOCKS * n * sizeof (bool), so each */
    /* threadblock has its own bool Mark array of size n.       */
    bool *d_Marks ;
    // CREATING d_Marks ARRAY OF SIZE NBLOKS*n*sizeof(bool) IN THE GPU
    OK (cudaMalloc (&d_Marks, (NBLOCKS * n * sizeof (bool)))) ;	//TODO

    /* allocate the result on the GPU */
    int64_t *d_ntri ;
    // USING CUDAMALLOC TO ALLOCATE THE D_NTRI RESULT ON THE GPU, OF SIZE NBLOCKS
    OK (cudaMalloc (&d_ntri, (NBLOCKS*sizeof(int64_t))));	//TODO

    // start the timer (optional, if you want to time just the kernel):
    // cudaEvent_t start, stop ;
    // OK (cudaEventCreate (&start)) ;
    // OK (cudaEventCreate (&stop)) ;
    // OK (cudaEventRecord (start)) ;

    /* launch the kernel */
    // this is written for you
    tri_kernel <<<NBLOCKS, dim3(NX,NY)>>> (d_Ap, d_Ai, n, d_Marks, d_ntri) ;
    OK (cudaGetLastError ( )) ;

    // stop the timer (optional, if you want to time just the kernel)
    // OK (cudaEventRecord (stop)) ;
    // OK (cudaEventSynchronize (stop)) ;
    // float milliseconds = 0;
    // OK (cudaEventElapsedTime (&milliseconds, start, stop)) ;
    // printf ("GPU kernel time: %g sec\n", milliseconds / 1000) ;

    /* get the result from the GPU: one value for each threadblock */
    int64_t ntri = 0, ntris [NBLOCKS] ;
    // GETTING THE D_NTRI ARRAY OF SIZE NBLOCKS FROM THE GPU
    OK (cudaMemcpy (ntris, d_ntri, (NBLOCKS*sizeof(int64_t)), cudaMemcpyDeviceToHost ));	//TODO

    /* free space on the GPU */
    // use cudaFree to free all the things you cudaMalloc'd.
    // if you fail to do this some problems will run out of memory
	//FREEING ALL THE MEMORY I HAVE ALLOCATED
	//NOTE: I DIDNT FREE d_ntri AND d_Marks ARRAY HERE COZ THERE WERE NO "TODO" TO DO THAT
    OK (cudaFree (d_Ap)) ;
    OK (cudaFree (d_Ai ));	//TODO

    /* sum up the results for all threadblocks */
    // the host has the result of each threadblock in ntris[NBLOCKS].
    // sum them up here into ntri.
    //TODO
	//FINAL REDUCTION OF ALL TRIANGLE COUNT FOR ALL BLOCKS
	ntri = 0;	
	for(int x = 0 ; x < NBLOCKS ; x++){
		ntri+= ntris[x];
	}

    /* return the result */
    return (ntri) ;
}
