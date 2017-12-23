//------------------------------------------------------------------------------
// tri_simple: compute the number of triangles in a graph (simple method)
//------------------------------------------------------------------------------

// READ THIS: this is the CPU method and is fully written.  No need to modify
// it.  However, read it carefully since this is the algorithm you are writing
// on the GPU.

// Computes the sum(sum((A*A).*A)), in MATLAB notation, where A is binary (only
// the pattern is present).  Or, in GraphBLAS notation, C<A>=A*A followed by
// reduce(C) to scalar.  To get the correct count, A must be a strictly lower
// or upper triangular matrix, or a symmetric permutation of such a matrix.

#include "tri_def.h"

int tri_simple          // # of triangles, or -1 if out of memory
(
    const int *Ap,      // column pointers, size n+1
    const int *Ai,      // row indices, size ne = Ap [n]
    const int n         // A has n nodes
)
{

    // get a workspace Mark [0..n-1] and set it to zero
    bool *Mark = (bool *) calloc (n, sizeof (bool)) ;
    if (Mark == NULL) return (-1) ;

    int ntri = 0 ;

    for (int j = 0 ; j < n ; j++)
    {
        // scatter A(:,j) into Mark
        for (int p = Ap [j] ; p < Ap [j+1] ; p++)
        {
            int i = Ai [p] ;
            // edge (i,j) exists in the graph, mark node i
            Mark [i] = 1 ;
        }
        // compute sum(C(:,j)) where C=(L*L(:,j))*.(L(:,j))
        for (int p = Ap [j] ; p < Ap [j+1] ; p++)
        {
            int k = Ai [p] ;
            // edge (k,j) exists in the graph
            for (int pa = Ap [k] ; pa < Ap [k+1] ; pa++)
            {
                int i = Ai [pa] ;
                // C(i,j) += A (i,k) * A (k,j)
                // Edge (i,k) exists, so the wedge (i,k)-(k,j) exists.  If
                // (i,j) also exists (that is, Mark[i]=1), then this is a
                // triangle with nodes (i,j,k).  Count it.  If Mark [i] is zero
                // then (i,j) does not exist and this is not a triangle; so
                // don't count it.  Both cases are just ntri+=Mark[i].
                ntri += Mark [i] ;
            }
        }
        // clear Mark for next iteration
        for (int p = Ap [j] ; p < Ap [j+1] ; p++)
        {
            int i = Ai [p] ;
            // edge (i,j) exists in the graph, clear the mark on node i
            Mark [i] = 0 ;
        }
        // Mark is now all zero again
    }

    // free workspace and return result
    free (Mark) ;
    return (ntri) ;
}

