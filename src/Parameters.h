//his is Parameters.h

#pragma once

#include <fstream>
#include <string>
#include <stdio.h>
#include <math.h>
#include <random>

using namespace std;

class parameters {
public:
	parameters();
	~parameters();

	//Simulation parameters
	int YEARS;				//number of years in the simulation
	int REP;				//number of replicates
	int emigr;			//emigration scenario
	int prosp_evol;			//evolution of prospecting 
	int emigr_evol;		//evolution of emigration 
	int BURNING;		//number of years beofre dispersal is allowed

	//Parameters for the grid
	int NROW;					//Number of cells on x
	int NCOL;					// Number of cells in y
	int row_init;				//Number of rows on which the population is initiliazed and runing during burnin
	int N_patches;				//Total number of patches
	int max_prosp_patch;			//Max number of patches that can prospected
	int CELL_RANGE;					//Number of adjacent cells an individual can perceive

//Parameters for the stochastic but auto-correlated environment
	float SD_enviro;		// SD of environmental quality
	double ac;						//temporal auto-correlation coefficent

	//////////////////////////
	// DEMOGRAPHIC PARAMETERS
	//Life history traits
	int min_age;				// min age for initialization
	int max_age;				//max age for initialization
	int MeanRecruitAge;		// Average age of recruitment to become adults
	float fixed_disp;			// Dispersal rate when emigration is random
	float fail_disp_rate;		//Dispersal rate for failed breeders (higher than successful breeders)
	float suc_disp_rate;		//Dispersal rate for successful breeders
	

	//Mutation in evolutionary model (settl="evol")
	float mutation_rate;		//Mutation rate in the evol scenario		
	float prosp_cost;			//Costs when individuals are prospecting (also proprotional to the number of prospected patches)


	//Constants for density-dependant breeding success 
	double lambda; // Mean number of offspring produced by individuals

	//Survival rates
	double survJuv;	//Survival of first year ind
	double survImmat;	//Survival of pre-breeders
	double survAdult;	//Survival of adults
	

	//Carrying capacity
	int N_init;				//Number of initial individuals on each cell
	float K_baseline;		//Number of initial individuals on each cell
	int K_max;				//Maxmimum number of individuals in a patch
	int b;					//Density-dependence coefficient


//Parameters for the stochastic but auto-correlated environment
	float SD0_enviro;		// SD of environmental quality
	float SD1_enviro;		// SD of environmental quality

///////////////
//OUTPUT files
//Generation intervals in output files
int seq_out_pop ;			//Number of years for which parameters are written in the output file
int seq_out_ind ;			//Number of years for which parameters are written in the output file

void outpara(std::string);		//Output function for individuals

};

