#include "testbench.h"

// USER INPUT -----------------------------------------------------------------
// Function the runs the test, and returns the coverage state
coveragestate_t run_test(VTOP_t *top, test_t test, bool PRINT_OUTPUT){
	vluint64_t main_time = 0;

	// RESET
	for(int i=0; i<NUMCOVERAGE; i++) top->__VlSymsp->__Vcoverage[i]=0;
	// sync reset
	top->clock = 0;
	top->reset = 0;
    top->eval();
    top->reset = 1;
    top->clock = ~top->clock;
    top->eval();
    top->reset = 0;
    top->clock = ~top->clock;

    
	// APPLY input vector
	int i,j;
	uint t;
	vluint64_t data;

	for(t=0;t<test.size();t++){
		inputvector_t iv = test[t];

		if(!Verilated::gotFinish()){

	    	for(j=0;j<INPUT_PARTS;j++){
	    		i = (j==0) ? 0 : INPUT_SPEC[j-1];
	    		data=0;
	    		for(;i<INPUT_SPEC[j];i++){
	    			data = (data<<1)|iv[i]; 
	    		}
	    		// printf ("[%d] %d,   ",j,data);
	    		switch(j){
	    			case 0: top->start = data; break;
	    		}
	    	}

	    	// clocks
	    	top->clock = ~top->clock;

	    	// eval model
	    	top->eval();

			// print ouptput of the test if requested
	    	if(PRINT_OUTPUT){
	    		for(j=0;j<OUTPUT_PARTS;j++){
		    		switch(j){
		    			case 0: printf("%X",top->punti_retta); break;
		    		}
	    		}
	    		cout<<endl;
	    	}

	    	// continue time
	    	main_time++;
    	}
	}

	// Collect the coverage state and return it
	coveragestate_t cs;
	for(int i=0; i<NUMCOVERAGE; i++) cs[i] = top->__VlSymsp->__Vcoverage[i];

	return cs;
}
// ----------------------------------------------------------------------------




/*====================================
=            TB FUNCTIONS            =
====================================*/


// Prints the input vector as per its spec
void print_inputvector(inputvector_t iv){
	int j=0;
    for(int i=0;i<INPUTSIZE;i++){
    	cout<<iv[i];
    	if(i==INPUT_SPEC[j]-1 && i!=INPUTSIZE-1){
    		cout<<",";
    		j++;
    	}
    }
    printf("\n");
}

// Prints the coverage state
void print_coveragestate(coveragestate_t cs){
	for(int i=0; i<NUMCOVERAGE; i++) 
		printf("%d| ", cs[i]);
    printf("\n");
}

// read the tests and store them in TESTBENCH
void read_testbench(string tbfilename, testbench_t *tb){
	ifstream file;
	file.open(tbfilename.c_str(), ios::in);

	int n, ntests, testlen;
	bool b;
	inputvector_t iv;

	file >> n;
	file >> ntests;
	// printf("Number of Tests to read: %d\n", ntests);

	for(int i=0; i<ntests; ++i){
		file >> testlen;
		// printf("\nTest[%d]\n", i);
		test_t test(testlen);
		for(int j=0; j<testlen; ++j){
			file.get();
			for(int k=0; k<INPUTSIZE; ++k)
				iv[k] = ('1' == file.get()) ? 1 : 0;
			// print_inputvector(iv);
			test[j] = iv;
		}
		tb->push_back(test);
	}

	file.close();

	// printf("\n\n\n");
	// test_t test;
	// for(int i=0; i<ntests; ++i){
	// 	printf("\nTest[%d]\n", i);
	// 	test = (*tb)[i];
	// 	for(int j=0; j<test.size(); ++j){
	// 		iv = test[j];
	// 		print_inputvector(iv);
	// 	}
	// }

}

// Generates a random input vector
inputvector_t rand_inputvector(int l){
	inputvector_t iv;

	for(int i=0;i<INPUTSIZE;i++){
		iv[i] = rand()%2;
	}

	return iv;
}

// Read in the CFGPath report dumped by parse_CFG.pl
// allocate them as vectors and store them as a group of paths per coverage point
void read_CFGPaths(string repfile, vector < vector< vector<int> > > *tCFGPATHS){
	ifstream FILE;
	FILE.open(repfile.c_str(), ios::in);
	int a, cp, npaths, l;
	// coverage point ID (CP)
    while (FILE >> cp) {
    	// Numper of CFGPaths for this CP
    	FILE >> npaths;
        printf("Read CP[%d] for %d paths\n", cp, npaths);

        vector< vector<int> > paths;
        // parse each path
        for(int i=0;i<npaths;i++){
        	vector<int> v;
        	// length of the path
        	FILE >> l;
        	for(int j=0;j<l;j++){
        		FILE >> a;
        		v.push_back(a);
        	}
        	paths.push_back(v);
        }

        // Finally add the path list for this CP into the list
        tCFGPATHS->push_back(paths);
    }
    FILE.close();
}


// Print the tests onto a file
void write_testbench(string filename, testbench_t tb){
	ofstream ofile;
  	ofile.open (filename.c_str());

  	// first line represents the input vector size
  	ofile << INPUTSIZE << endl;
  	// second line represents the testbench size
  	ofile << tb.size() << endl;

  	// Now, we can write each test into the file
  	test_t test;
  	inputvector_t iv;
  	for(int i=0; i<tb.size(); ++i){
  		test = tb[i];
  		// write the size of the test
  		ofile << test.size() << endl;
  		for(int j=0; j<test.size(); ++j){
  			iv = test[j];
  			for(int k=0; k<INPUTSIZE; ++k){
  				ofile << iv[k];
  			}
  			ofile << endl;
  		}
  	}

  	ofile.close();
}


// print coverage stats
void print_tbstats(coveragestate_t testTargets, testbench_t tb){
	double coverage = (double) accumulate(testTargets.begin(), testTargets.end(), 0);
	coverage = coverage/NUMCOVERAGE;

	int min_tsize, max_tsize;
	int sum=0;
	double avg_tsize;

	uint tsize;
	for(int i=0; i<tb.size();i++){
		tsize = (tb[i]).size();
		sum+=tsize;
		if(i==0){
			min_tsize = tsize;
			max_tsize = tsize;
		} else {
			min_tsize = (tsize < min_tsize) ? tsize : min_tsize;
			max_tsize = (tsize > max_tsize) ? tsize : max_tsize;
		}
	}

	avg_tsize = sum/(double)tb.size();

	printf("\n\n\nRESULT\n");
	printf("Test Count: %lu\n", tb.size());
	printf("Test Size (min/max/avg): { %d, %d, %.2f }\n", min_tsize, max_tsize, avg_tsize);
	printf("Total input vectors: %d\n", sum);
	printf("Coverage: %f\n", coverage);
}