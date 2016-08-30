#ifndef TESTBENCH_H
#define TESTBENCH_H

// USER INPUT -----------------------------------------------------------------
#include "Vuart.h"
#include "Vuart__Syms.h"
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
typedef Vuart VTOP_t;

/*==================================
=            INPUT SPEC             =
==================================*/
/**
 *
 * Define the Input Spec
 * The input vector consists of 13 bits
 * ld_tx_data : 1
 * tx_data : 8
 * tx_enable: 1
 * uld_rx_data: 1
 * rx_enable: 1
 * rx_in: 1
 *
 */
const unsigned int INPUTSIZE = 13;
const unsigned int INPUT_PARTS = 6;
const unsigned int INPUT_SPEC[] = {1,9,10,11,12,13};

const unsigned int NUMCOVERAGE = 24;

/*===================================
=            OUTPUT SPEC            =
===================================*/
/*
 * tx_out : 1
 * tx_empty : 1
 * rx_data : 8
 * rx_empty : 1
 */
const unsigned int OUTPUT_PARTS = 4;


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