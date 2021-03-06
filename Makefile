.phony: all run clean test

CC=gcc
SOURCES=main.c sys_info.c SuperKernel_host.c QueueJobs.c OpenCL_compiler.c OpenCL_launcher.c OpenCL_debugger.c
objects=main.o sys_info.o SuperKernel_host.o QueueJobs.o OpenCL_compiler.o OpenCL_launcher.o OpenCL_debugger.o
params=-I/usr/local/cuda/include -L/usr/lib64 -lOpenCL -lrt

all: MG
	echo all: make complete
run: all
	echo run: MG
	./MG

MG: $(objects)
	$(CC) -o $@ $+ $(params)

clean:
	rm $(objects)
	rm MG
	rm *.h.gch
	rm MG

%.o:%.c
	$(CC) -c $+ $(params)

#
# The following list will list out all objects
# which are generated while compiling.
# We firstly compile the objects is to make
# sure each part of the program is okey to use
# for the main program.
# It is easier to debug the code.
# 
main.o: main.c headers.h

sys_info.o: sys_info.c sys_info.h

SuperKernel_host.o: SuperKernel_host.c SuperKernel_host.h

OpenCL_compiler.o: OpenCL_compiler.c OpenCL_compiler.h

OpenCL_launcher.o: OpenCL_launcher.c OpenCL_launcher.h

test_add:
	gcc -o test_vector_add.out test_vector_add.c $(params)
	./test_vector_add.out
test:
	###############################################
	##### Compiler must be gcc-4.4 or g++-4.4 #####
	###############################################
	##### Now "make all" has the same effect  #####
	###############################################
	gcc -o MG $(SOURCES) -I/usr/local/cuda/include -L/usr/lib64/ -lOpenCL
	
	
cuda:
	nvcc -g -I/usr/include -G -arch=sm_11 -lpthread cuda_cu.cu -o CU
cleancuda:
	rm CU
