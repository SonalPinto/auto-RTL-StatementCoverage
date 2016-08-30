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
	array<inputvector_t, MAXPOPULATION> my_iv;
	array<coveragestate_t, MAXPOPULATION> my_cs;
	array<double, MAXPOPULATION> my_fitness;

	uint best_individual;
	double best_fitness;
	inputvector_t best_iv;
	coveragestate_t best_cs;
	

	// Test dimension
	int K = 1;
	// A test is a list of input vectors
	test_t test;
    while(K<MAXTESTLENGTH) {
	    // printf(">>K:%d, ", K);

	    // Let each individual search for the next input vector on their own
	    for(int i=0; i<MAXPOPULATION; ++i) {
	    	// copy golden test into local
	    	test_t my_test = test;

	    	// generate local inputvector 
		    my_iv[i] = rand_inputvector(INPUTSIZE);
		    my_test.push_back(my_iv[i]);

		    // execute the test and return the coverage state
		    my_cs[i] = run_test(top,my_test);
			// print_coveragestate(cs);

			my_fitness[i] = eval_fitness(my_cs[i], target);
			// printf("[p%d] fitness: %f\n", i, my_fitness[i]);
		}


		// Now, find the best move among all individuals, and record it as golden
		auto best_fitness_index = max_element(my_fitness.begin(), my_fitness.end());
		best_fitness = (*best_fitness_index);
		best_individual = distance(my_fitness.begin(), best_fitness_index);
		best_iv = my_iv[best_individual];
		best_cs = my_cs[best_individual];

		// printf("BEST: %d, %f\n", best_individual, best_fitness);

		test.push_back(best_iv);

		// Target reached
		if(best_fitness==1) {
			printf("Target [%d] reached.\n", target);
			// Store the test
			TESTBENCH.push_back(test);
			TESTTARGETS[target] = 1;

			// Reassess targets - mark those targets reached by this test as done
			for(int i=0;i<NUMCOVERAGE;++i){
				if(best_cs[i] && !TESTTARGETS[i] && i!=target) {
					TESTTARGETS[i]=1;
					printf("Auxillary Target [%d] also reached\n", i);
				}
			}

			break;
		}

		K++;
	}
	// cout<<endl;

	return TESTTARGETS[target];
}