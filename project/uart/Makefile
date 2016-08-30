# top module to be simulated
TOP_MODULE = Vuart
MODULE_DIR = obj_dir

# Verilog
VMOD = uart
VMOD_SRC = uart.v

# testbench deps
TESTBENCH = testbench.cpp

# verilator deps
VERILATOR_DEPS =  ${VERILATOR_ROOT}/include/verilated.cpp
VERILATOR_DEPS += ${MODULE_DIR}/${TOP_MODULE}.cpp
VERILATOR_DEPS += ${MODULE_DIR}/${TOP_MODULE}__Syms.cpp
VERILATOR_DEPS += ${VERILATOR_ROOT}/include/verilated_cov.cpp 
VERILATOR_INC = -I${VERILATOR_ROOT}/include 
VERILATOR_INC += -I${VERILATOR_ROOT}/include/vltstd
VERILATOR_INC += -I${MODULE_DIR}

CC = g++
CFLAGS = -std=c++11

buildModel:
	verilator -Wall --cc -Wno-lint --coverage-line -dump-tree --top-module ${VMOD} ${VMOD_SRC}
	ls ./obj_dir/*990_final.tree | xargs ../src/parseCFG_simple.pl

buildTestModel:
	verilator -Wall --cc -Wno-lint --coverage-line --Mdir ${MODULE_DIR} --top-module ${VMOD} ${VMOD_SRC}

build1:
	${CC} ${CFLAGS} testgen1.cpp ${TESTBENCH} ${VERILATOR_DEPS} ${VERILATOR_INC} -o test1

build2:
	${CC} ${CFLAGS} testgen2.cpp ${TESTBENCH} ${VERILATOR_DEPS} ${VERILATOR_INC} -o test2

build3:
	${CC} ${CFLAGS} testgen3.cpp ${TESTBENCH} ${VERILATOR_DEPS} ${VERILATOR_INC} -o test3

buildtester:
	${CC} ${CFLAGS} runTest.cpp ${TESTBENCH} ${VERILATOR_DEPS} ${VERILATOR_INC} -o runtest




build: clean buildModel build1 build2 build3 buildtester




run1:
	./test1 CFGPaths.rep tests/${TOP_MODULE}_tb1.test

run2:
	./test2 CFGPaths.rep tests/${TOP_MODULE}_tb2.test

run3:
	./test3 CFGPaths.rep tests/${TOP_MODULE}_tb3.test

runMutationTesting:
	../src/genMutants.pl ${VMOD_SRC}
	../src/analyzeMutants.pl ${VMOD_SRC}



.PHONY: clean
clean:
	rm -f test1 test2 test3 runtest
	mkdir -p tests
