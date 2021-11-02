//This is parameters.cpp

#include "Parameters.h"


parameters::parameters() {
	YEARS = 301;				//number of years of simulations
	REP = 10;				//number of replicates
	BURNING = 200;			//number of first years during which individuals are not allowed to disperse

	emigr = 3;		// Emigration strategy: can be 1 =random, 2 ="pers" or "3" =pers_social
	prosp_evol = 0;
	emigr_evol = 0;
	

	//Parameters for the grid
	NROW = 300;					//Number of cells on x
	NCOL = 20;					// Number of cells in y
	row_init = 3;
	N_patches = NROW * NCOL;				//Total number of patches
	CELL_RANGE = 2;
	max_prosp_patch = 12;		//Maximum number of prospected patches

//Parameters for the stochastic but auto-correlated environment
	SD_enviro = 1;		// SD of environmental quality
	ac = 0.8;
								
	//Carrying capacity
	N_init = 20;			//Number of initial number of individuals in a patch
	K_baseline = 20;		//Number of individuals in a medium environment
	K_max = 1000;			//maximum number of individuals in a patch
	b = 1;

	//Mutation in evolutionary model

	if (emigr_evol==1 || prosp_evol==1) {
		mutation_rate = 0.01;	}
	else { mutation_rate = 0; }

	prosp_cost = 0;		//Cost of prospecting per patch


	//Settings for ouput files
	seq_out_pop = 1;			//Output file for populations written every *** years
	seq_out_ind = 1000;			//Output file for individuals written every *** years

	
	//////////////////////////
	// DEMOGRAPHIC PARAMETERS
	//Life history traits
	min_age = 1;				//minimum age for individuals at initialization
	max_age = 15;				//maximum age for individuals at initialization
	MeanRecruitAge = 5;			//Mean age at recruitment
	survJuv = 0.6;	//Survival of juveniles
	survImmat = 0.7;	//Survival of pre-breeders
	survAdult = 0.85;	//Survival of adults


	///////////////////////////
	//DISPERSAL RATES
	fixed_disp = 0.5;			// Emigr proba when emigr="random"
	fail_disp_rate = 0.85;		//Emigr proba for failed breeders when emigr=3
	suc_disp_rate = 0;		//Emigr proba for successful breeders when emigr=3
	

	//Constants for density-dependant breeding success 
	lambda = 2; // Mean number of offspring

}


//Parameters to write in the individuals output file
void parameters::outpara(std::string name) { //This defines what parameters are going to be output from the model
	std::ofstream out_param;
	out_param.open(name.c_str());

	out_param << "sim " << REP << std::endl;
	out_param << "gen " << YEARS << std::endl;
	out_param << "NROW " << NROW << std::endl;
	out_param << "NCOL " << NCOL << std::endl;
	out_param << "BURNING" << BURNING << std::endl;
	out_param << "Initial K " << K_baseline << std::endl;
	out_param << "Enviro_SD_enviro " << SD1_enviro << std::endl;
	out_param << "Emigr " << emigr << std::endl;
	out_param << "Prosp_evol " << prosp_evol << std::endl;
	out_param << "Emigr_evol " << emigr_evol << std::endl;
	out_param << "Mutation rate " << mutation_rate << std::endl;
	out_param << "Prospecting cost " << prosp_cost << std::endl;
	out_param << "Cell Range " << CELL_RANGE << std::endl;
	out_param << "MaxProspPatch " << max_prosp_patch << std::endl;
	if (emigr == 1)
	{  out_param << "Random emigration proba " << fixed_disp << std::endl;}
	else {
		out_param << "Failed emigration rate " << fail_disp_rate << std::endl;
		out_param << "Successful emigration proba " << suc_disp_rate << std::endl;
	}

	out_param.close();
}

parameters::~parameters()
{
}
