//This is main.cpp

#include <iostream>
#include "MainHeader.h"

#if CLUSTER
int main(int argc, char* argv[])
{
	// Get the current directory.
	char* buffer = getcwd(NULL, 0);
	dir = buffer;
	free(buffer);
	dir = dir + "/"; //Current directory path
	dirout = dir + "Outputs/"; //Outpus folder path


	para.CELL_RANGE			 = std::atoi(argv[1]);
	para.max_prosp_patch	 = std::atoi(argv[2]);
	para.para.occ_or_empty        = std::atof(argv[3]);
	


	RunModel();

	cout << "Simulations completed, YOU ROCK IT, YOU'RE THE BOSS" << endl;

	return 0;
}
#else

int _tmain(int argc, _TCHAR* argv[])
{

	char* buffer = _getcwd(NULL, 0);
	dir = buffer;
	free(buffer);
	dir = dir + "\\"; //Current directory path
	dirout = dir + "Outputs\\"; //Outpus folder path
	clock_t tStart = clock();

	RunModel();

	printf("Time taken: %.2fs\n", (double)(clock() - tStart) / CLOCKS_PER_SEC);
	cout << "Simulations completed, YOU ROCK IT, YOU'RE THE BOSS" << endl;
	system("pause");

return 0;

}	//end of main fuction
#endif

//---------------------------------------------------------------------------
string Int2Str(int x)
{
	ostringstream o;
	if (!(o << x)) return "ERROR";
	return o.str();
}
//---------------------------------------------------------------------------
string Float2Str(double x)
{
	ostringstream o;
	if (!(o << x)) return "ERROR";
	return o.str();
}


//Sorting of occupied patches based on local productivity
bool CompProd(const Patch& a, const Patch& b) {
	return a.product > b.product;
}

//Sorting of empty patches based on local environmental quality
bool CompEnvQual(const Patch& a, const Patch& b) {
	return a.env_qual > b.env_qual;

}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Main model function
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void RunModel(void) {

	for (int oc = 0; oc < 11; oc++) {

		occ_or_empty = (float) oc / 10;
		
		//generate headers in the output files
		outpop_header();
//		outind_header();


		////////REPLICATE SIMULATION
		for (rep = 0; rep < para.REP; rep++) {
			id = 0;
			row_max = 0;
			max_y_ind = 0;
			yyy = 0;

			Initialise();

		//	cout << rep << " " << years << " initialisatin OK" << endl;

			///YEARS WITHIN REPLICATES
			for (years = 0; years < para.YEARS; years++) {

				cout << "Replicate " << rep << " year " << years << " Rate " <<occ_or_empty << endl;

				Enviro_Quality();
				Reproduction();
				Mortality();
				Age_and_Recruit();
				Dispersal();
//				Get_OutInd(para);
				Settlement();
				Get_OutPop(para);

				if (Reinitialisation() == false) {
					cout << rep << " " << years << " POPULATION GOT EXTINCT, MODEL ENDED" << endl;
					break;
				}
			}	//end of years

		}	//end of replicates

		if (outpop.is_open())   outpop.close();   //Checks if the population output file is open and closes it
		if (outind.is_open())   outind.close();
		if (outparam.is_open()) outparam.close();
	}		//end of occupation rate

}		//end of running model





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Initialisation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void Initialise(void) {


	string name_param = dirout + "CellRange_" + Int2Str(para.CELL_RANGE) + "_Prosp_" + Int2Str(para.max_prosp_patch) +"_Occ_"  + Float2Str(occ_or_empty) + "_Em_"
		+ Int2Str(para.emigr) +  "_Param.txt";
	para.outpara(name_param);
	
	grid.clear();
	id = 0;
	row_max = para.row_init;

//	cout << "init yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;

//Initialisation of patches and populations 

	for (y = 0; y < para.NROW; y++) {
		for (x = 0; x < para.NCOL; x++) {
			

			//Create a vector of patches
			idpatch = (para.NCOL*y) + x;		//get patchID
			Patch backup = Patch(x, y, idpatch);		//create patch object 
			backup.init_patch_qual(para);			//initialize patch i
			backup.init_window(para);
			backup.init_prosp_vect(para);

			if (y < para.row_init) {
				backup.init_pop_onPatch(para, id);		//initialize population on the patch


			//Create a vector of individuals on each patch
				for (n = 0; n < backup.N_popsize_init; n++) {
					id++;
					Individual ind = Individual(x, y, idpatch);
					ind.init_age(para, id);
					ind.init_prospect(para, id);
					ind.init_emigr(para, id);
					backup.add_ind(ind);

					if (ind.stage == "pre-breeder") { backup.N_immat_init++; }
					else { backup.N_adults_init++; }

				}
			}

			grid.push_back(backup);

			}	//end of x
		}//end of y 
}		//end of Initialisation function



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//YEARLY VARIATION OF ENVIRONMENTAL QUALITY OVER THE WHOLE GRID
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void Enviro_Quality(void) {

//	cout << "enviro yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;

	for (p=0; p<para.N_patches;p++) {
			grid[p].enviro_quality(para);
			if (grid[p].N_popsize_init > 0) { grid[p].occupied = true;			}
			else { grid[p].occupied = false; 	}
		}
}//end of enviro_qual function



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//REPRODUCTION
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Reproduction(void) {

	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);

//	cout << "reprod yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:"<< max_y_ind  << endl;

	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {
			
			p = (para.NCOL*y) + x;

			if (grid[p].N_popsize_init > 0) {
				for (n = 0; n < grid[p].N_popsize_init; n++) {

					if (grid[p].pop_init_vec[n].stage == "adult") {
						id = grid[p].reproduction(years, n, id, para);
					} //end of if ind is adult
				}	//end of n in individuals

				grid[p].N_adults = grid[p].N_succ + grid[p].N_fail;

				grid[p].N_popsize = grid[p].N_adults + grid[p].N_immat_init + grid[p].N_juv_surv;
			

			}		//end of if pop is empty
		}		//end of y
	}	//end of x

}//end of reproduction



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MORTALITY
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Mortality(void) {

	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);

//	cout << "mort yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;

	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {

			p = (para.NCOL*y) + x;

				if (grid[p].N_popsize > 0) {


					for (n = 0; n < grid[p].N_popsize; n++) {

						if (grid[p].pop_init_vec[n].stage != "juvenile") {
							grid[p].mortality(para, n);
						}

						if (grid[p].pop_init_vec[n].alive == true) {
							grid[p].N_popsize_surv++;
							grid[p].pop_vec.push_back(grid[p].pop_init_vec[n]);
						}


					} //end of looping over individuals

					grid[p].N_adult_surv = grid[p].N_adults - grid[p].N_dead_adults;
					grid[p].N_immat_surv = grid[p].N_immat_init - grid[p].N_dead_immat;

				}	//end of if pop not empty

//				cout << " y:" << y << " x:" << x << " p:" << p << endl;
//		  	cout << " a " <<  grid[p].N_adults << " " << grid[p].N_dead_adults << " " << grid[p].N_adults - grid[p].N_dead_adults << " " << grid[p].N_adult_surv <<  endl;
//				cout << years << " i " <<  grid[p].N_immat_init << " " << grid[p].N_dead_immat << " " << grid[p].N_immat_init - grid[p].N_dead_immat << " " << grid[p].N_immat_surv << endl;
//				cout << years << " j " <<  grid[p].N_juvs << " " << grid[p].N_dead_juv << " " << grid[p].N_juvs - grid[p].N_dead_juv << " "<< grid[p].N_juv_surv << endl;
//				cout << years << " pop: " << grid[p].N_popsize << " " << grid[p].N_dead_adults + grid[p].N_dead_immat +  grid[p].N_dead_juv << " " << grid[p].pop_vec.size() << " " << grid[p].N_popsize_surv << endl;

				grid[p].pop_init_vec.clear();


		//	system("pause");
		}		//end of x
	}	//end of y

}	//end of mortality


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//AGING AND RECRUITMENT
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Age_and_Recruit(void) {

	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);

//	cout << "age yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;
	
	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {

			p = (para.NCOL*y) + x;

			if (grid[p].N_popsize_surv > 0) {
				for (n = 0; n < grid[p].N_popsize_surv; n++) {

					grid[p].pop_vec[n].age_ind();
					grid[p].recruitment(n);
				}

				grid[p].N_adults_predisp = grid[p].N_NewAdults + grid[p].N_adult_surv;
				grid[p].N_immat_final = grid[p].N_immat_surv + grid[p].N_juv_surv - grid[p].N_NewAdults;


		//				cout << years <<" p:" << p <<  " 2a "  << grid[p].N_adult_surv << " " << grid[p].N_NewAdults << " " << grid[p].N_adults_predisp << endl;
		//				cout << years << " 2i "  << grid[p].N_immat_final << " " << grid[p].N_immat_surv << " " << grid[p].N_juv_surv << " " <<  grid[p].N_NewAdults
		//					<< " " << grid[p].N_immat_surv + grid[p].N_juv_surv - grid[p].N_NewAdults << endl;

			}
		}
	}
}

	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DISPERSAL
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Dispersal(void) {
	int  zzz;
	int new_id, new_xx, new_yy;
	std::uniform_real_distribution<float> rate_rd(0, 1);

	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);

//	cout << "disp yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;


	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {
			p = (para.NCOL*y) + x;

			if (grid[p].N_popsize_surv > 0) {

			
				for (n = 0; n < grid[p].N_popsize_surv; n++) {

					new_xx = -999;
					new_yy = -999;
					new_id = -999;

					//Individuals decide to disperse or not

					if (grid[p].pop_vec[n].stage == "adult") {

						grid[p].dispersal(para, n, years);

					}

					//IF INDIVIDUALS DISPERSE
					if (grid[p].pop_vec[n].disperser == true) {



						// 1) PROSPECTING
						if (grid[p].pop_vec[n].nb_prosp_patch > 1) {

							//Shuffle the vector of all potential patches
							shuffle(grid[p].patchID_potential.begin(), grid[p].patchID_potential.end(), rdgen);

							int sizy_oc, sizy_empty, size_vect, prosp_patch_size;

							//Select the right number of prospected patches
							prosp_patch_size = grid[p].patchID_potential.size();

							if (prosp_patch_size < grid[p].pop_vec[n].nb_prosp_patch)	{
								size_vect = prosp_patch_size;			
							}
							else { size_vect = grid[p].pop_vec[n].nb_prosp_patch; }

					//get whether prospected patches are empty or occupied
							for (int k = 0; k < size_vect; k++) {					// k = Number of prospected colonies

								zzz = grid[p].patchID_potential[k];

								if (grid[zzz].occupied) {
									patch_prosp_occ.push_back(grid[zzz]);

//				cout << endl << " k:" << k <<  " OCCUPIED" << " ID:"<< grid[zzz].IDPatch << " x:" <<grid[zzz].x << " y:" 
//				<< grid[zzz].y << " product:" << grid[zzz].product << " N:" << grid[zzz].N_popsize_surv << endl;

								}

								else {
//									cout << "k:" << k << " EMPTY" << " ID:" << grid[zzz].IDPatch << " x:" << grid[zzz].x << " y:"
// 									<< grid[zzz].y << " env_qual:" << grid[zzz].env_qual << " N:" << grid[zzz].N_popsize_surv << endl;

									patch_prosp_empty.push_back(grid[zzz]);
								}
							}		//end of k over prospecting vector


							std::sort(patch_prosp_occ.begin(), patch_prosp_occ.end(), CompProd);
							std::sort(patch_prosp_empty.begin(), patch_prosp_empty.end(), CompEnvQual);

							sizy_oc = patch_prosp_occ.size();
							sizy_empty = patch_prosp_empty.size();


							double rd_choice = rate_rd(rdgen);

//							cout << x << " " << y << " " << n << " SORTED PATCHES OC: " << sizy_oc << " EMPTY: " << sizy_empty << endl; ;

															// iF ONLY OCCUPIED or EMPTY PATCHES ARE PROSPECTED
							if (sizy_oc == 0 && rd_choice <= occ_or_empty) {
								new_xx = grid[p].x;
								new_yy = grid[p].y;
								new_id = grid[p].IDPatch;

//								cout << " STAY HOME NO OCCUPIED" << " new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id << endl;

							}

							if (sizy_oc == 0 && rd_choice > occ_or_empty) {
								new_xx = patch_prosp_empty[0].x;
								new_yy = patch_prosp_empty[0].y;
								new_id = patch_prosp_empty[0].IDPatch;

//								cout << " EMPTY FAVOURED NO OCCUPIED" << " new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id  << endl;

							}

							if (sizy_empty == 0 && rd_choice <= occ_or_empty) {
								new_xx = patch_prosp_occ[0].x;
								new_yy = patch_prosp_occ[0].y;
								new_id = patch_prosp_occ[0].IDPatch;

//						cout << " OCCUPIED FAVOURED NO EMPTY" << " new_x:" << new_xx << " new_y:" << new_yy <<  " patchID:" << new_id <<endl;
							}

							if (sizy_empty == 0 && rd_choice > occ_or_empty) {
								new_xx = grid[p].x;
								new_yy = grid[p].y;
								new_id = grid[p].IDPatch;

//								cout << " STAY HOME NO EMPTY" << " new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id  << endl;
							}


							//if both empty and occupied patches are prospected
							if (sizy_oc > 0 && sizy_empty > 0) {

								//if rd_choice is lower than the threshold, individuals choose occupied patches
								if (rd_choice <= occ_or_empty) {
									new_xx = patch_prosp_occ[0].x;
									new_yy = patch_prosp_occ[0].y;
									new_id = patch_prosp_occ[0].IDPatch;

//									cout << " OCCUPIED FAVOURED" << " new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id << endl;
								}
								else {
									new_xx = patch_prosp_empty[0].x;
									new_yy = patch_prosp_empty[0].y;
									new_id = patch_prosp_empty[0].IDPatch;

//									cout << " EMPTY FAVOURED" << " new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id << endl;
								}
							}


							//Clearance of vectors
							patch_prosp_empty.clear();
							patch_prosp_occ.clear();

							//If prospecting entails some mortality cost
							grid[p].pop_vec[n].prospect_cost(para, n);

						
							// 2) Getting the new coordinates of the patch selected
							grid[p].pop_vec[n].new_patchID = new_id;
							grid[p].pop_vec[n].new_x = new_xx;
							grid[p].pop_vec[n].new_y = new_yy;
						}	//end of if individuals prospect 

						//4) if individuals do not prospect, they disperse randomly to a new breeding patch other than their current one		

						if (grid[p].pop_vec[n].nb_prosp_patch < 2) {
							
							//Identify the window of prospecting around the focal cell

							std::uniform_int_distribution<> unif_ncol_bound(grid[p].x_win_min, grid[p].x_win_max);				//random pick of x in the dispersal range
							std::uniform_int_distribution<> unif_nrow_bound(grid[p].y_win_min, grid[p].y_win_max);				//random pick of y in the dispersal range

							do {
								new_xx = unif_ncol_bound(rdgen);
								new_yy = unif_nrow_bound(rdgen);
							} while (new_xx == x && new_yy == y);

							new_id = (para.NCOL*new_yy) + new_xx;

//						cout << "x:" << x << " y:" << y << " RANDOM  new_x:" << new_xx << " new_y:" << new_yy << " patchID:" << new_id << endl;
							

							//Put anew coordinates in individual object
							grid[p].pop_vec[n].new_x = new_xx;
							grid[p].pop_vec[n].new_y = new_yy;
							grid[p].pop_vec[n].new_patchID = new_id;
						}	//end of random dispersal

						if (grid[p].pop_vec[n].new_y > max_y_ind) { max_y_ind = grid[p].pop_vec[n].new_y; }


					}		//end of if individuals disperse

					//If individuals remain in their patch
					if (grid[p].pop_vec[n].disperser == false) {
						grid[p].pop_vec[n].real_emigr = 0;
						grid[p].pop_vec[n].new_patchID = grid[p].IDPatch;
						grid[p].pop_vec[n].new_x = grid[p].x;
						grid[p].pop_vec[n].new_y = grid[p].y;

//						cout << p << " " << n << " FAITHFUL " << grid[p].pop_vec[n].stage << endl;





					}

				}	//end of n in individuals

//				if (years >= para.BURNING)	system("pause");
			}	
			//end of if pop empty

		}	//end of y
	}	//end of x

//	if (years >= para.BURNING) system("pause");
}	//end of dispersal function



void Settlement(void) {

	if (max_y_ind >= row_max) { row_max = (max_y_ind)+1; }


	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);

//	cout << "settl yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;

	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {
			p = (para.NCOL*y) + x;

			for (n = 0; n < grid[p].N_popsize_surv; n++) {
				if (grid[p].pop_vec[n].alive == true) {

					if (grid[p].pop_vec[n].stage == "adult") {

						//SETTLEMENT IN NEW SITE
						if (grid[p].pop_vec[n].disperser == true) {

//							cout << rep << " " << years << " x:" << x << " y:" << y << " new_x:" << grid[p].pop_vec[n].new_x << " new_y:" << grid[p].pop_vec[n].new_y << endl;

							grid[grid[p].pop_vec[n].new_patchID].pop_init_vec.push_back(grid[p].pop_vec[n]);
							grid[grid[p].pop_vec[n].new_patchID].N_immigr++;
							grid[grid[p].pop_vec[n].new_patchID].N_adults_postdisp++;

						}		//end of if individuals disperse

						else {
							grid[p].pop_init_vec.push_back(grid[p].pop_vec[n]);
							grid[p].N_adults_postdisp++;
						}
					}		//end of looping on adults

					//Keep pre-breeders in the same patch
					else {
						grid[p].pop_init_vec.push_back(grid[p].pop_vec[n]);
					}

				}	//end of if individuals alive

				//Removal of individuals which died prospecting
				if (grid[p].pop_vec[n].alive == false && grid[p].pop_vec[n].stage == "adult") { grid[p].N_Disp_dead++; }

			}		//end of individuals

			
		}		//end of y
	}//end of x
}	//end of function



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//REINITIALIZATION
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool Reinitialisation(void) {

	if (years < para.BURNING) yyy = para.row_init;
	else (yyy = row_max);


//	cout << "reinit yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;


	int TOTAL_POP_SIZE = 0;

	for (y = 0; y < yyy; y++) {
		for (x = 0; x < para.NCOL; x++) {
			p = (para.NCOL*y) + x;

//			cout << p << " ad: " << grid[p].N_adults_postdisp << " im: " << grid[p].N_immat_final;

			grid[p].N_popsize_final = grid[p].N_immat_final + grid[p].N_adults_postdisp;

//			cout << " pop:" << grid[p].N_popsize_final << endl;


			for (n = 0; n < grid[p].N_popsize_final; n++) {
				grid[p].pop_init_vec[n].reinit_ind(grid[p].IDPatch, grid[p].x, grid[p].y);
			}


			TOTAL_POP_SIZE += grid[p].N_popsize_final;

			grid[p].reinit();
			grid[p].clear_pop();

		}
	}
//	if (years > para.BURNING) { system("pause"); }

	if (TOTAL_POP_SIZE < 1) {
		return false;
	}
	else { return true; }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Outputs
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Write headers in population output file
void outpop_header(void) {
	std::string name_pop;
	name_pop = dirout + "CellRange_" + Int2Str(para.CELL_RANGE) + "_Prosp_" + Int2Str(para.max_prosp_patch) + "_Occ_" + Float2Str(occ_or_empty) + "_Em_"
		+ Int2Str(para.emigr) +"_pop.txt";
	outpop.open(name_pop.c_str());
	outpop << "sim gen x y PatchID env.qual succrate ExpOff Nadult NDisp Nstay Nimmigr" << endl;
}

//Write headers in individual output file
void outind_header(void) {
	std::string name_ind;
	name_ind = dirout + "CellRange_" + Int2Str(para.CELL_RANGE) + "_Prosp_" + Int2Str(para.max_prosp_patch) + "_Occ_" + Float2Str(occ_or_empty) + "_Em_"
		+ Int2Str(para.emigr) + "_ind.txt";
	outind.open(name_ind.c_str());
	outind << "sim gen ID age x_natal y_natal x y new_x new_y Disp nb_disp BreedPerf nb_fail DispProba" << endl;
}


//Write population counters in population output file
void Get_OutPop(parameters para) {

//	cout << "reinit yyy: " << yyy << " rowmax:" << row_max << " y_max_ind:" << max_y_ind << endl;


	for (int q = 0; q < para.YEARS; q += para.seq_out_pop) {
		if (years == q && years >= para.BURNING) {
			for (int p = 0; p < para.N_patches; p++) {
				if (grid[p].y < yyy) {
					grid[p].OutPop(rep, years, &outpop);
				}
			}
		}
	
	}


}


//Write individual features in individual output file
/*void Get_OutInd(parameters para) {

	for (int q = 0; q < para.YEARS; q += para.seq_out_ind) {
		if (years == q && years > para.BURNING) {
			//				if(years>para.YEARS-5){
			for (int p = 0; p < para.N_patches; p++) {
				if (grid[p].y < yyy) {

					for (int n = 0; n < grid[p].N_popsize_surv; n++) {

						grid[p].pop_vec[n].OutInd(rep, years, &outind);
					}
				}
			}

		}
	}
}
*/