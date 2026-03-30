EXECS=mpi_hello_world
MPICC?=${ONEAPI_ROOT}/mpi/2021.17/bin/mpicc
INC=-I${ONEAPI_ROOT}/mpi/2021.17/include
LIB=-L${ONEAPI_ROOT}/mpi/2021.17/lib

all: ${EXECS}

mpi_hello_world: mpi_hello_world.c
	${MPICC} $(LIB) $(INC)  -o mpi_hello_world mpi_hello_world.c

clean:
	rm -f ${EXECS}
