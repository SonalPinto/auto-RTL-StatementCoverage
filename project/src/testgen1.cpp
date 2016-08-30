#include "testbench.h"

/*==============================
=            GLOBAL            =
==============================*/

vector < vector< vector<int> > > CFGPATHS;
coveragestate_t TESTTARGETS;
testbench_t TESTBENCH;


/*=================================
=            FUNCTIONS            =
=================================*/

double eval_fitness(coveragestate_t, int);
bool buildTest(VTOP_t*, int);


/*============================
=            MAIN            =
============================*/

int main(int argc, char* argv[]) {

	if (argc != 3){
		cerr << "Usage: test CFGPaths.rep outputTB.test\n";
		exit(1);
	}

	string cfgpaths_repfile = argv[1];
	string otestfile = argv[2];


	/*----------  INIT  ----------*/
	// Sim Object
	VTOP_t *top = new VTOP_t();
	// init the RNG
	srand((uint) time(NULL));
	// Read CFGPaths
	read_CFGPaths(cfgpaths_repfile, &CFGPATHS);
    if(NUMCOVERAGE != (int) CFGPATHS.size()){
    	printf("[ERROR] Could not read %d coverage points from %s.\n",NUMCOVERAGE,cfgpaths_repfile.c_str());
    	exit(1);
    };
    printf("Coverage Points read: %d\n", NUMCOVERAGE);
    fill(TESTTARGETS.begin(), TESTTARGETS.end(), 0);
    printf("Init Complete\n\n");
    

    /*----------  WORK  ----------*/
    
    // Goal: Reach each Coverage Point
    for(int target=0; target<NUMCOVERAGE; target++){
    	// Only aim for those that have not been reach in previous tests
    	if(TESTTARGETS[target]) continue;

	    // Coverage Point target
	    printf("\nCurrent Target: [%d]\n", target);

	    // generate a test for this target
	    for(int trial=0; trial<MAXTRIALS; ++trial){
	    	printf("TRIAL-%d\n", trial);
	    	if(buildTest(top, target)) break;
		}
	}



	/*----------  REPORT  ----------*/
	print_tbstats(TESTTARGETS, TESTBENCH);

	// Dump testbench
	write_testbench(otestfile, TESTBENCH);

    cout<<endl<<endl;
	return 0;
}






/*============================================
=            FUNCTION DEFINITIONS            =
============================================*/
// Calculates the fitness of a test against the intended target
double eval_fitness(coveragestate_t cs, int target){
	// Add immideate victory condition
	// return fitness of 1
	if(cs[target]>0) return 1;

	// List of paths that traverse through the target
	// The goal of the Test is to traverse across any of these
	vector< vector<int> > targetpaths = CFGPATHS[target];
	uint np = targetpaths.size();

	// Commonality Score : Represents which nodes on the coverage state are common with each path
	vector<int> commonality_score(np);
	fill(commonality_score.begin(), commonality_score.end(), 0);

	// Iterate through every path and build score for common nodes
	// At the same time pick the shortest path that gave the best score
	vector<int> path, best_path;
	int pnode, best_pathlen, best_comscore;

	for(int i=0; i<np; ++i){
		path = targetpaths[i];

		for(int j=0; j<path.size(); ++j){
			pnode = path[j];
			// cout<<pnode<<", ";
			if(cs[pnode]>0) commonality_score[i]++;
		}
		// printf("      [%d]\n", commonality_score[i]);

		if(i==0){
			best_path = path;
			best_pathlen = path.size();
			best_comscore = commonality_score[i];
		} else{
			// only replace if the current path has a better score or if it has the same score, but a shorter length
			if(commonality_score[i]>best_comscore
				|| (commonality_score[i]==best_comscore && path.size()<best_pathlen) ){
					best_path = path;
					best_pathlen = path.size();
					best_comscore = commonality_score[i];
			}
		}
	}

	// printf(">>best\n");
	// for(int i=0; i<best_pathlen; ++i){
	// 	cout<<best_path[i]<<", ";
	// }
	// printf("      [%d]\n", best_comscore);


	// The fitness will be based off comparing against the best path
	double fitness=0;
	fitness = best_comscore/double(best_pathlen);

	return fitness;
}


// Attempt to build a test within a max length to reach the target
bool buildTest(VTOP_t *top, int target){
	// Test dimension
	int K = 1;
	// A test is a list of input vectors
	test_t test;
    while(K<MAXTESTLENGTH) {
	    // printf(">>K:%d, ", K);
	    inputvector_t iv = rand_inputvector(INPUTSIZE);
	    test.push_back(iv);

	    coveragestate_t cs = run_test(top,test);
		// print_coveragestate(cs);

		double fitness = eval_fitness(cs, target);
		// printf("fitness: %f\n", fitness);

		// Target reached
		if(fitness==1){
			printf("Target [%d] reached in %d dimensions.\n", target, K);
			// Store the test
			TESTBENCH.push_back(test);
			TESTTARGETS[target] = 1;

			// Reassess targets - mark those targets reached by this test as done
			for(int i=0;i<NUMCOVERAGE;++i){
				if(cs[i] && !TESTTARGETS[i] && i!=target) {
					TESTTARGETS[i]=1;
					printf("Auxillary Target [%d] also reached\n", i);
				}

			}

			break;
		}

		K++;
	}

	return TESTTARGETS[target];
}
