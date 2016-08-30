#include "testbench.h"

/*==============================
=            GLOBAL            =
==============================*/
coveragestate_t TESTTARGETS;
vector<coveragestate_t> TBCOVSTATE;
testbench_t TESTBENCH;


/*============================
=            MAIN            =
============================*/

int main(int argc, char* argv[]) {

	// Sim Object
	VTOP_t *top = new VTOP_t();
	coveragestate_t cs;
	fill(TESTTARGETS.begin(), TESTTARGETS.end(), 0);


	if (argc != 2){
		cerr << "Usage: runTest testFileName.test\n";
		exit(1);
	}

	// Read tests from file
	string tbfile = argv[1];
	read_testbench(tbfile, &TESTBENCH);

	printf("\n\n");
	int nTests = TESTBENCH.size();

	// Run each test and store the coverage state
	printf("OUTPUT\n");
	for(int i=0; i<nTests; ++i)
		TBCOVSTATE.push_back(run_test(top, TESTBENCH[i], true));

	printf("\n\n");
	for(int i=0; i<nTests; ++i){
		printf("TEST[%d]: ",i);
		cs = TBCOVSTATE[i];
		print_coveragestate(cs);

		for(int j=0; j<NUMCOVERAGE; ++j)
			TESTTARGETS[j] = (cs[j]) ? 1 : TESTTARGETS[j];
	}

	// Get coverage stats
	printf("\nOverall Coverage State:\n");
	print_coveragestate(TESTTARGETS);

	print_tbstats(TESTTARGETS, TESTBENCH);

	printf("\n\n");
	return 0;
}

