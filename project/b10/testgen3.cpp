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
inputvector_t ga_selection_rand(array<inputvector_t, MAXPOPULATION>, array<double, MAXPOPULATION>);
inputvector_t ga_selection_roulette(array<inputvector_t, MAXPOPULATION>, array<double, MAXPOPULATION>);
void ga_crossover_1p(inputvector_t, inputvector_t, inputvector_t*, inputvector_t*);
void ga_mutation_rand(inputvector_t*);

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
	array<inputvector_t, MAXPOPULATION> my_iv;  // population!
	array<coveragestate_t, MAXPOPULATION> my_cs;
	array<double, MAXPOPULATION> my_fitness;

	uint best_individual;
	int current_generation;
	double best_fitness;
	inputvector_t best_iv;
	coveragestate_t best_cs;
	
	inputvector_t parent1, parent2, child1, child2;

	// Test dimension
	int K = 1;
	// A test is a list of input vectors
	test_t test;
    while(K<MAXTESTLENGTH) {


		/*----------  Genetic Aglgorithm Search  ----------*/
		// INITIALIZE
		// Each individual is initialized to a random test of dimension 1
		for(int i=0; i<MAXPOPULATION; ++i) {
			my_iv[i] = rand_inputvector(INPUTSIZE);
		}

		current_generation=0;


		while(current_generation<MAXGENERATION){
			// EVAL FITNESS
			// Evaluate the fitness of each individual
			for(int i=0; i<MAXPOPULATION; ++i) {
				test_t my_test = test;
				my_test.push_back(my_iv[i]);
				my_cs[i] = run_test(top,my_test);
				my_fitness[i] = eval_fitness(my_cs[i], target);
			}


			// OBSERVE POPULATION
			// See if any individual has converged
			auto best_fitness_index = max_element(my_fitness.begin(), my_fitness.end());
			best_fitness = (*best_fitness_index);
			best_individual = distance(my_fitness.begin(), best_fitness_index);
			best_iv = my_iv[best_individual];
			best_cs = my_cs[best_individual];

			// printf("[G:%d] BEST: %d, %f\n", current_generation, best_individual, best_fitness);

			// Victory
			if(best_fitness==1) break;


			// Else, we continue to evolve towards a solution
			// Build the next generation
			array<inputvector_t, MAXPOPULATION> next_iv; // next population
			for(int i=0; i<MAXPOPULATION; i+=2){
				// SELECTION - Roulette
				parent1 = ga_selection_roulette(my_iv, my_fitness);
				parent2 = ga_selection_roulette(my_iv, my_fitness);

				// CROSSOVER - One point
				ga_crossover_1p(parent1, parent2, &child1, &child2);

				// MUTATION - Rand
				ga_mutation_rand(&child1);
				ga_mutation_rand(&child2);

				next_iv[i] = child1;
				next_iv[i+1] = child2;
			}

			for(int i=0; i<MAXPOPULATION; ++i){
				my_iv[i] = next_iv[i];
			}

			current_generation++;
		}


		/*-------------------------------------------------*/
	

		

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


/*----------  GA FUNCTIONS  ----------*/

// Random Selction
inputvector_t ga_selection_rand(array<inputvector_t, MAXPOPULATION> myiv, array<double, MAXPOPULATION> myfitness){
	int n = rand()%MAXPOPULATION;
	return myiv[n];
}

// Roulette Selection
inputvector_t ga_selection_roulette(array<inputvector_t, MAXPOPULATION> myiv, array<double, MAXPOPULATION> myfitness){
	int n;
	double total_fitness = accumulate(myfitness.begin(), myfitness.end(), 0);

	// declare a pivot
	double pivot = ((double)rand()/RAND_MAX) * total_fitness;

	// Pick the first individual that empties the pivot
	for(n=0; n<MAXPOPULATION; n++){
		pivot -= myfitness[n];
		if(pivot<0) break;
	}

	// correction for rounding errors
	if(n==MAXPOPULATION) --n;

	return myiv[n];
}

// One point crossover
void ga_crossover_1p(inputvector_t p1, inputvector_t p2, inputvector_t* c1, inputvector_t* c2){
	// Pick a crossover point
	int p = rand()%INPUTSIZE + 1;

	double f = ((double)rand()/RAND_MAX);
	if(f>P_CROSSOVER) p = INPUTSIZE; // no crossover

	// Copy accordingly
	// First child gets  { p1(start->p),p2(p->end) }
	// Second child gets { p2(start->p),p1(p->end) }
	for(int i=0; i<INPUTSIZE; i++){
		(*c1)[i] = (i<p) ? p1[i] : p2[i];
		(*c2)[i] = (i<p) ? p2[i] : p1[i];
	}
}


// Mutation - randomly flip one bit
void ga_mutation_rand(inputvector_t* iv){
	int p;

	double f = ((double)rand()/RAND_MAX);
	if(f<P_MUTATION){
		p = rand()%INPUTSIZE;
		(*iv)[p] = !(*iv)[p];
	}
}