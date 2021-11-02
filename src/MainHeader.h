#pragma once

#define CLUSTER 0

#include <stdio.h>
#include <stdlib.h>
#if CLUSTER 
#include <unistd.h>
#else
#include <tchar.h> 
#include <direct.h>
#include <io.h>
#endif
#include <vector>
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <math.h>
#include <numeric>
#include <time.h>
#include <random>
#include <iterator>

#include "Patch.h"
#include "Parameters.h"
#include "Individuals.h"

using namespace std;

//Functions for random processes
std::random_device rd;
std::mt19937 rdgen(rd());

//names for output files
std::ofstream outparam, outpop,outind;
std::ifstream in; //output names


//Creation of objects
parameters para;
vector<Patch> grid;
vector<Patch>patch_prosp_occ,patch_prosp_empty;
string dir, dirout;
int rep,years,SimN, x,y,p,n, id, idpatch, ExpOff,yyy,row_max, max_y_ind;
float occ_or_empty;

//Main functions
string Int2Str(int x);
string Float2Str(double x);
void outpop_header(void);
void outind_header(void);
void RunModel(void);
//void Get_OutInd(parameters para);
void Get_OutPop(parameters para); 
void Initialise(void);
void Enviro_Quality(void);
void Reproduction(void);
void Mortality(void);
void Age_and_Recruit(void);
void Dispersal(void);
void Settlement(void);
bool Reinitialisation(void);


/*
//Sorting of occupied patches based on local productivity
bool CompProd(const Patch &a, const Patch &b) {
	return a.product > b.product;
}

//Sorting of empty patches based on local environmental quality
bool CompEnvQual(const Patch &a, const Patch &b) {
	return a.env_qual > b.env_qual;
}
*/

