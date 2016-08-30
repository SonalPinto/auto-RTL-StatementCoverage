#ifndef TESTBENCH_H
#define TESTBENCH_H

// USER INPUT -----------------------------------------------------------------
#include "Vb10.h"
#include "Vb10__Syms.h"
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
typedef Vb10 VTOP_t;

/*==================================
=            INPUT SEC             =
==================================*/
/**
 *
 * Define the Input Spec
 * The input vector consists of 11 bits
 * r_button : 1
 * g_button : 1
 * key : 1
 * start : 1
 * test : 1
 * rts : 1
 * rtr: 1
 * v_in : 4
 */
const unsigned int INPUTSIZE = 11;
const int INPUT_PARTS = 8;
const int INPUT_SPEC[] = {1,2,3,4,5,6,7,11};

const unsigned int NUMCOVERAGE = 32;

/*===================================
=            OUTPUT SPEC            =
===================================*/
/*
 * cts: 1
 * ctr: 1
 * v_out: 4
 */
const unsigned int OUTPUT_PARTS = 3;


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