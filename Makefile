run: tri_main
	./tri_main bcsstk01
	./tri_main tiny

# TODO add tri_gpu.cu to the list here
tri_main: tri_main.cu tri_dump.cu tri_prep.cu tri_read.cu \
	tri_simple.cu tri_warmup.cu tri_gpu.cu
	nvcc -Wno-deprecated-gpu-targets -arch=sm_35 \
	    $^ -o tri_main -lcudart -I. -Xcompiler -fopenmp

purge:
	rm -f tri_main *.o

