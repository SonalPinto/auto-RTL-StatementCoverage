#ifndef TESTBENCH_H
#define TESTBENCH_H

// USER INPUT -----------------------------------------------------------------
#include "Vb11.h"
#include "Vb11__Syms.h"
// ----------------------------------------------------------------------------
#include <verilated.h>
#include <verilated_cov.h>
#include <ctime>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <array>
#include <algorithm>

using namespace std;


// USER INPUT -----------------------------------------------------------------
// TOP Module alias
typedef Vb11 VTOP_t;

/*==================================
=            INPUT SPEC             =
==================================*/
/**
 *
 * Define the Input Spec
 * The input vector consists of 7 bits
 * x_in : 6
 * stbi : 1
 *
 */
const unsigned int INPUTSIZE = 7;
const unsigned int INPUT_PARTS = 2;
const unsigned int INPUT_SPEC[] = {6,7};

const unsigned int NUMCOVERAGE = 33;

/*===================================
=            OUTPUT SPEC            =
===================================*/
/*
 * 
 */
const unsigned int OUTPUT_PARTS = 1;


/*======================================
=            TESTGEN CONFIG            =
======================================*/

const unsigned int MAXTESTLENGTH = 256;
const unsigned int MAXTRIALS = 1;
const unsigned int MAXPOPULATION = 100;
const unsigned int MAXGENERATION = 16;

const double P_CROSSOVER = 0.75;
const double P_MUTATION = 0.05;
// ----------------------------------------------------------------------------


/*----------  TB DATATYPES  ----------*/

typedef array<bool,INPUTSIZE> inputvector_t;
typedef array<int, NUMCOVERAGE> coveragestate_t;
typedef vector<inputvector_t> test_t;
typedef vector< test_t > testbench_t;
typedef unsigned int uint;

/*----------  TB FUNCTIONS  ----------*/

void print_inputvector(inputvector_t);
void print_coveragestate(coveragestate_t);
void read_testbench(string, testbench_t*);
void write_testbench(string filename, testbench_t);
inputvector_t rand_inputvector(int);
void read_CFGPaths(string repfile, vector < vector< vector<int> > > *tCFGPATHS);
void print_tbstats(coveragestate_t, testbench_t);


coveragestate_t run_test(VTOP_t *top,  test_t test, bool PRINT_OUTPUT=false);

#endif