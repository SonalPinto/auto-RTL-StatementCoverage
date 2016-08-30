Before all, VERILATOR\_ROOT needs to be declared in the environment
for example, in bash:

```bash
export VERILATOR_ROOT=$HOME/Downloads/programs/verilator-3.882
export PATH=$VERILATOR_ROOT/bin:$PATH
```


Six circuits from the ITC'99 benchmark are stored in each directory: uart, b07, b10, b11, b12, b14
Common source code and Perl scripts are stored in the "src" directory
Note that files testgen1.cpp, testgen2.cpp, testgen3.cpp and runTest.cpp are absolutely identical in all directories, as the model parameters and functions are abstracted out, and entirely encoles in each model's testbench.h and testbench.cpp

For any new model, the use only needs to modify small marked sections in the testbench.h and testbench.cpp



Clean Build and Run
===================

1. Make the perl scripts execuatble
```bash
chmod +x src/*pl
```

2. enter model directory (uart, b07, b10, b11, b12, b14)

3. Run:
```
make build
```

This builds all required prerequisities (Verilator model, CFGPaths.rep, each testgen method and an executable for running testbenches)

| File | Description |
| --- | --- |
| ./obj_dir | compiled Verilator model |
| ./obj_dir | compiled Verilator model |
| CFGPaths.rep | enumarated paths from the CovFG |
| test1| executable for rand1 |
| test2 | executable for rand2 |
| test3| executable for saga |
| runtest | executable that runs testbenches on the model and prints primary outputs at each cycle |


4. To generate testbenches (the tests will be stored in ./tests directory)

| Target | Algorithm |
| --- | --- |
| `make run1` | rand1 |
| `make run2` | rand2 |
| `make run3` | saga |


5. Mutation Analysis
```
	make runMutationTesting
```

Intermediate results (mutants, mutated models, mutated output) will be stored in `./mutation_testing` directory

The output of each stage is printed on the terminal



---------------------------------------------------------------------------------------------------

File: CFGPaths.rep
===================
Coverage path report for a Verilator model. Stores enumerated paths from the CovFG.

Format:
```
<node>
<#paths>
<path_lenght> <path_node1> <path_node2> ... 

eg: 

9
4
5 13 11 10 9 3
7 13 11 10 9 8 7 5
7 13 11 10 9 8 7 6
6 13 11 10 9 8 4
```

Indicates, that for Node-9, there are 4 paths. Each of the paths are stored, space delimited, with the first number being the leght of the path.



File: tests/*.test   - Any TestBench file
=========================================

Format:
```
<inputvector length>
<number of tests>
<length of the test>
<iv_1>
<iv_2>
...


eg:

13
4
7
1000101111110
0101000100001
1100110111000
1100001011011
0011100100101
0011000000010
0111011100110
```



EXTRA: parseCFG.pl
==================

For the above execution src/parse_CFG_simple.pl is used. There is another version parse_CFG.pl which does the same as the former, but also, dumps the CFG in svg format


Acknowledgement
===
Dr. Michael Hsiao - Graduate Advisor

Verilator - Wilson Snyder <wsnyder@wsnyder.org>, with Duane Galbi and Paul Wasson <pmwasson@gmail.com>
