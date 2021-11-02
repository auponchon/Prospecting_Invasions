//This is individual.cpp

#include "Individuals.h"


using namespace std;

std::random_device rd3;
std::mt19937 rdgenIND(rd3());



Individual::Individual(int xx, int yy, int idpatchh) {
	ID = 0;
	age = 0;						
	age_Recruit = 0;		
	x_natal = xx;
	y_natal = yy;
	ID_natal = idpatchh;
	x = xx;							
	y = yy;
	new_x = xx;
	new_y = yy;
	patchID = idpatchh;
	new_patchID = idpatchh;
	stage = "NA";					
	nb_prosp_patch = -9999;
	BreedPerf = false;
	nb_fail = 0;
	nb_disp = 0;
	disperser = false;
	real_emigr = 0;
	emigr_fail_interc = -9999;
	emigr_suc_interc = -9999;
	alive = true;

}



//Initialize age at recruitment, age and status
void Individual::init_age(parameters para, int id) {

	ID = id++;

	std::poisson_distribution<int> pois_recruit(para.MeanRecruitAge);
	age_Recruit = pois_recruit(rdgenIND);

	std::uniform_int_distribution<> unif_age(para.min_age, para.max_age);
	age = unif_age(rdgenIND);

	if (age < age_Recruit) {
		stage = "pre-breeder";
	}
	else { stage = "adult"; }

}

//Initialize emigration parameters
void Individual::init_emigr(parameters para, int id) {


	if (para.emigr_evol==false) {		//evol==false, when emigration is fixed

		if (para.emigr == 1) {		
		emigr_fail_interc = para.fixed_disp;
	}

		if (para.emigr != 1) {
			emigr_suc_interc = para.suc_disp_rate;
			emigr_fail_interc = para.fail_disp_rate;
		}
	}


//	if (para.emigr_evol==true) {			//4=="disp_evol", when emigration is evolving along with prospecting

		std::uniform_real_distribution<float> unif_emigr(0, 1);
	

		if (para.emigr == 1) {
			emigr_fail_interc = unif_emigr(rdgenIND);
	}

		if (para.emigr > 1) {
			emigr_fail_interc = unif_emigr(rdgenIND);
			emigr_suc_interc =  unif_emigr(rdgenIND);
//		}

	}
}


//Create a new individual when an adult produce one offspring
void Individual::init_juv(parameters para, int id, int xx, int yy) {

	std::poisson_distribution<int> pois_recruit(para.MeanRecruitAge);
	
	ID = id;
	age = 0;
	x_natal = xx;
	y_natal = yy;
	age_Recruit = pois_recruit(rdgenIND);
	real_emigr = 0;
	stage = "juvenile";
	BreedPerf = false;
	nb_fail = 0;
	nb_disp = 0;
}


//Initialize nb of prospected patches
void  Individual::init_prospect(parameters para, int id) {

/*	if (para.prosp_evol) {
		std::uniform_int_distribution<> unif_patch(0, para.max_prosp_patch);
		nb_prosp_patch = unif_patch(rdgenIND);
	}
*/
	//else nb_prosp_patch = para.max_prosp_patch;
	nb_prosp_patch = para.max_prosp_patch;
}


//Mutation in the case when settlement is "evol"
void Individual::mutation_prospect(parameters para, int id) {

	if (para.prosp_evol==1) {

	std::uniform_real_distribution<float> rate_mut(0, 1);
	std::uniform_int_distribution<> change_col(0, 1);

		double mutation_rd;
		mutation_rd = rate_mut(rdgenIND);

		if (mutation_rd < para.mutation_rate) {
			int colchange = change_col(rdgenIND);			//decides if it's gonna be + or - 1 COL
			if (colchange == 0) { nb_prosp_patch = nb_prosp_patch - 1; }
			if (colchange == 1) { nb_prosp_patch = nb_prosp_patch + 1; }
			if (nb_prosp_patch > para.max_prosp_patch) { nb_prosp_patch = para.max_prosp_patch; }
			if (nb_prosp_patch < 0) { nb_prosp_patch = 0; }

		}
	}
}


void Individual::mutation_emigr(parameters para, int id) {
	
	if (para.emigr_evol==1) {

		std::uniform_real_distribution<float> rate_mut(0, 1);
		std::normal_distribution<float> float_normal(0, 0.1);

		float mutation_rd1, mutation_rd2;
		mutation_rd1 = rate_mut(rdgenIND);
		mutation_rd2 = rate_mut(rdgenIND);
		

		if (mutation_rd1 < para.mutation_rate) {
			float rd_disp1 = float_normal(rdgenIND);
			emigr_fail_interc += rd_disp1;
		}

		if (para.emigr != 1) {
			if (mutation_rd2 < para.mutation_rate) {
				float rd_disp2 = float_normal(rdgenIND);
				emigr_suc_interc += rd_disp2;

			}
		}
	}
}


//Mortality depending on individual stage
bool Individual::ind_death(parameters para) {
	uniform_real_distribution<double> unif_rates(0, 1);

	double rdmSurv = unif_rates(rdgenIND);
	double survstage=0;

	if (stage == "juvenile") { survstage = para.survJuv; }
	else if (stage == "pre-breeder") { survstage = para.survImmat; }
	else if (stage == "adult") { survstage = para.survAdult; }

	if (rdmSurv > survstage) {   // if adults survive
		alive = false;
	}

	return alive;
}

//Aging of individual
void Individual::age_ind(void) {
	age++;

	if (age == 1) {
		stage = "pre-breeder";
	}
	if (age == age_Recruit) {
		stage = "adult";
	}
	if (age > 100) {
		alive = false;
	}

}


//Dispersal probability depending on emigration scenario
void Individual::disperse(parameters para, float patch_LBS, int YEAR) {
	float rd_dispers;

	//Define value for dispersal
	

		if (para.emigr == 1) {
			real_emigr = para.fixed_disp;
		}

		if (para.emigr == 2) {
			if (BreedPerf == true) {
				real_emigr = para.suc_disp_rate;
			}
			else { real_emigr = para.fail_disp_rate; }
		}

		if (para.emigr == 3) {
			if (BreedPerf == false) {
				real_emigr = para.fail_disp_rate + (para.suc_disp_rate - para.fail_disp_rate)*patch_LBS;
			}
			else { real_emigr = para.suc_disp_rate; }
		}
	
		//Disperser or not?
	uniform_real_distribution<float> proba(0, 1);


	//No movement during burn-in
	if (YEAR < para.BURNING) { rd_dispers = 1; }

	//If individuals are allowed to disperse
	else { rd_dispers = proba(rdgenIND); }

	//Disperser
		if (rd_dispers < real_emigr ) {
			disperser = true;
			nb_disp++;
			new_x = -999;
			new_y = -999;
			new_patchID = -999;

		}

	//Non-disperser
		if (rd_dispers >= real_emigr) {
			disperser = false;
			real_emigr = 0.0;
			new_x = x;
			new_y = y;
			new_patchID = patchID;

	}
}

/*
//Create a vector of patches which are prospected
void Individual::prospecting(parameters para, int X, int Y) {
	
}
*/


//Additional mortality cost due to prospecting
void Individual::prospect_cost(parameters para, int j) {
	if (para.prosp_cost > 0) {

	uniform_real_distribution<double> unif_rates(0, 1);

	double	rdm_prosp_cost = unif_rates(rdgenIND);	
		if (rdm_prosp_cost < para.prosp_cost * nb_prosp_patch) {
			alive = false;
			disperser = false;
			new_patchID = -999;
			new_x = -999;
			new_y = -999;
		}
	}

}	

//reinitialization of individual featuress at the end of the year
void Individual::reinit_ind(int a, int b, int c) {
	patchID = a;
	x = b;
	y = c;
	new_patchID = a;
	new_x = b;
	new_y = c;
	real_emigr = -999;
	disperser = false;
	BreedPerf = false;
}



//Parameters to write in the output file
void Individual::OutInd(int rep, int years, std::ofstream *outind) {
	if (alive == true && stage=="adult") {

		*outind << rep << " "
			<< years << " "
			<< ID << " "
			<< age << " "
			<< x_natal << " "
			<< y_natal << " "
			<< x << " "
			<< y << " "
			<< new_x << " " 
			<< new_y << " "
			<< disperser << " "
			<< nb_disp << " "
			<< BreedPerf << " "
			<< nb_fail << " "
			<< real_emigr << std::endl;
	}
}