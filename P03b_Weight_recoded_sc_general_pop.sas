OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr;

** NRA and weight adjust;

%let program = P03;
%let prog = SC;

OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Child\";


/* For portal */ 
proc format; 

/* this is the most basic format, Yes = 1 and No = 0. All response should be this type */ 
/* verified range */ 
	value _1to1_short
	1 = '1'
	2 = '0'
	-9 = .
	-8 = .
	other = .; 

/* verified range */ 
	value _1to1_long
	1 = '1'
	other = '0'
	-9 = .
	-8 = .
	. = '.'; 

	value _1to2_
	1-2 = '1'
	3 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to3_short
	1-3 = '1'
	4 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to3_long
	1-3 = '1'
	4-5 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to5_long
	1-5 = '1'
	6-9 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to5_short
	1-5 = '1'
	6 = '0'
		-9 = .
	-8 = .
	other = .; 

/* verified range */ 
	value _10to11_
	9-10 = '1'
	0-8 = '0'
		-9 = .
	-8 = .
	other = .;

/* this format is for response1 and response2 set of (No, Yes) */ 
	value _2to2_
	2 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = '.' ;

	value _2to3_ 
	2-3 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _2to4_
	2-4 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

	value _2to5_
	2-5 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

	value _2to6_
	2-6 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

/* this question is for "1 or more time", resp1 is 0, and resp7 is 10 or more time */ 
/* verified range */ 
	value _2to7_
	1-6 = '1'
	0 = '0'
	-8 = .
	-9 = .
	other = .;

	value _3to5_
	3-5 = '1'
	1-2 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _3to6_
	3-6 = '1'
	1-2 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _4to4_
	4 = '1'
	1-3 = '0'
	-9 = .
	-8 = .
	other = .; 

	value _5to5_
	5 = '1'
	1-4 = '0'
		-9 = .
	-8 = .
	other = .; 
run; 



/* output the recoded dataset for CAHPS case mix */ 

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\SC_output_thlc\general_population"; 

data &program._df_&prog._merge_w_recoded; 
	set temp.&program._df_&prog._merge_w; 
run;

ods pdf file="K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\SC_question_dist_recheck.pdf";

proc freq data = &program._df_&prog._merge_w_recoded; 
	tables  intro -- cahps75 / list; 
run; 

ods pdf close; 

proc contents data=&program._df_&prog._merge_w_recoded; 
	run; 


/* import two indicator files */ 
proc import out=cahps_list
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\cahps_list_by_program.xlsx"
	dbms = xlsx replace;
	sheet = 'gen_SC_2023_CAHPS'; 
run;

proc import out=itemID_vs
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-04\THLC_Surveys - item ID table_v7_ccc_cohort_new_ID.xlsx"
	dbms = xlsx replace;
run;

data thlc_vs; 	
	set itemID_vs (keep=ItemID low_box high_box combination_box format_sas); 
run; 

proc freq data=thlc_vs; 
	tables format_sas; 
run; 

proc sql; 
	create table cahps_info as 
	select a.*, b.*
	from cahps_list as a
	inner join thlc_vs as b
	on a.itemID = b.itemID; 
quit; 

data cahps_info; 
	set cahps_info; 
	var = upcase(var); 
	outname = upcase(outname); 
run; 

/* create CCC screener questions for general population */ 
/*data df_format; */
/*	set &program._df_&prog._merge_w_recoded; */
/**/
/*	NEEDMEDS = .; */
/*	IF (cahps55 >= 1)  then NEEDMEDS= 0; */
/*	IF (cahps57   = 1)  then NEEDMEDS = 1; */
/**/
/*	NEEDSERV = .; */
/*	IF (cahps58 >= 1)  then NEEDSERV = 0; */
/*	IF (cahps60   = 1) then NEEDSERV = 1; */
/*	*/
/*	LIMITED = .; */
/*	IF (cahps61 >= 1) then LIMITED = 0; */
/*	IF (cahps63   = 1) then LIMITED = 1; */
/**/
/*	NEEDTHER = .; */
/*	IF (cahps64 >= 1) then NEEDTHER = 0; */
/*	IF (cahps66   = 1)  then NEEDTHER = 1; */
/**/
/*	NEEDCOUN = .; */
/*	IF (cahps67 >= 1)  then NEEDCOUN = 0; */
/*	IF (cahps68   = 1) then NEEDCOUN = 1; */
/*	*/
/*	SPECIALNEED = .; */
/*	IF NEEDMEDS = 1*/
/*		or NEEDSERV = 1*/
/*		or LIMITED = 1*/
/*		or NEEDTHER = 1*/
/*		or NEEDCOUN = 1*/
/*    then SPECIALNEED = 1; */
/*	else if  NEEDMEDS = 0*/
/*		AND NEEDSERV = 0*/
/*		AND LIMITED = 0*/
/*		AND NEEDTHER = 0*/
/*		AND NEEDCOUN = 0*/
/*	then SPECIALNEED = 0; */
/*	*/
/*run; */

/* output two version for raw data unadjusted - spss running */ 
/* one for general population, one for CCC group */ 
/* import general population SPSS code */ 
/*proc import out=df_sc_sav_gnr*/
/*	datafile = "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\STARChild_2023\STAR Child ARC_Biennial 2023_Completes Final.sav"*/
/*	dbms = SAV replace;*/
/*run;*/
/**/
/*data df_sc_sav_ccc; */
/*	set df_sc_sav_gnr; */
/*	where SPECIALNEEDs = 1; */
/*run; */


proc export data= df_sc_sav_ccc
	outfile="\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\CCC_cohort.sav"
	dbms=spss replace;
run;


/* In 2023 STAR Child Survey, there is no UT1A, PAS _all_, ICHP6 */ 

data df_format; 
	set df_format; 
			CAHPS3  = input(put(	CAHPS3  	,  _1to1_short.), 1.); 
			CAHPS4  = input(put(	CAHPS4  	,  _4to4_.), 1.); 
			CAHPS5  = input(put(	CAHPS5  	,  _1to1_short.), 1.); 
			CAHPS6  = input(put(	CAHPS6  	,  _4to4_.), 1.); 
			AR1   	= input(put(	AR1   		, _1to5_long.), 1.); 
			AR2   	= input(put(	AR2   		, _1to1_long.), 1.); 
			UT1   	= input(put(	UT1   		, _2to7_.), 1.); 
/*			UT1A   	= input(put(	UT1A   		, _1to1_short.), 1.); */
			ICHP2   = input(put(	ICHP2   	, _1to1_short.), 1.); 
			ICHP3   = input(put(	ICHP3   	, _10to11_.), 1.); 
			CAHPS7  = input(put(	CAHPS7  	,  _2to7_.), 1.); 
			CAHPS8  = input(put(	CAHPS8  	,  _4to4_.), 1.); 
			CAHPS9  = input(put(	CAHPS9  	,  _10to11_.), 1.); 
			AH1   	= input(put(	AH1   		, _1to1_short.), 1.); 
			AH2   	= input(put(	AH2   		, _4to4_.), 1.); 
			CAHPS10  = input(put(	CAHPS10  	,  _4to4_.), 1.); 
			CAHPS11  = input(put(	CAHPS11  	,  _1to1_short.), 1.); 
			CAHPS12  = input(put(	CAHPS12  	,  _1to1_short.), 1.); 
			CAHPS13  = input(put(	CAHPS13  	,  _1to1_short.), 1.); 
			FREW1   = input(put(	FREW1   	, _1to1_short.), 1.); 
			FREW4   = input(put(	FREW4   	, _1to1_long.), 1.); 
			CAHPS14   = input(put(	CAHPS14   	, _1to1_short.), 1.); 
			CAHPS15   = input(put(	CAHPS15   	, _4to4_.), 1.); 
			CAHPS16   = input(put(	CAHPS16   	, _1to1_short.), 1.); 
			CAHPS17   = input(put(	CAHPS17   	, _1to1_short.), 1.); 
			CAHPS18   = input(put(	CAHPS18   	, _4to4_.), 1.); 
			CAHPS19   = input(put(	CAHPS19   	, _1to1_short.), 1.); 
			CAHPS20   = input(put(	CAHPS20   	, _1to1_short.), 1.); 
			CAHPS21   = input(put(	CAHPS21   	, _4to4_.), 1.); 
			CAHPS22   = input(put(	CAHPS22   	, _1to1_short.), 1.); 
			CAHPS23   = input(put(	CAHPS23   	, _1to1_short.), 1.); 
			CAHPS24   = input(put(	CAHPS24   	, _1to1_short.), 1.); 
			CAHPS25   = input(put(	CAHPS25   	, _1to1_short.), 1.); 
			CAHPS26   = input(put(	CAHPS26   	, _2to7_.), 1.); 
			CAHPS27   = input(put(	CAHPS27   	, _4to4_.), 1.); 
			C1   	= input(put(	C1   		, _1to1_long.), 1.); 
			CAHPS28   = input(put(	CAHPS28   	, _4to4_.), 1.); 
			CAHPS29   = input(put(	CAHPS29   	, _4to4_.), 1.); 
			CAHPS30   = input(put(	CAHPS30   	, _1to1_short.), 1.); 
			CAHPS31   = input(put(	CAHPS31   	, _4to4_.), 1.); 
			C2   	= input(put(	C2   		, _1to1_long.), 1.); 
			CAHPS32   = input(put(	CAHPS32   	, _4to4_.), 1.); 
			CAHPS33   = input(put(	CAHPS33   	, _1to1_short.), 1.); 
			CU14  	= input(put(	CU14  		, _1to1_long.), 1.); 
			CU15  	= input(put(	CU15  		, _1to1_long.), 1.); 
			CU23  	= input(put(	CU23  		, _1to1_long.), 1.); 
			CU24  	= input(put(	CU24  		, _1to1_long.), 1.); 
			CAHPS34  = input(put(	CAHPS34  	, _1to1_short.), 1.); 
			CAHPS35  = input(put(	CAHPS35  	, _4to4_.), 1.); 
			CAHPS36  = input(put(	CAHPS36  	, _10to11_.), 1.); 
			PD1   	= input(put(	PD1   		, _1to1_short.), 1.); 
			PD2   	= input(put(	PD2   		, _4to4_.), 1.); 
			CAHPS37  = input(put(	CAHPS37  	, _1to1_short.), 1.); 
			CAHPS38  = input(put(	CAHPS38  	, _1to1_short.), 1.); 
			CAHPS39  = input(put(	CAHPS39  	, _1to1_short.), 1.); 
			CAHPS40  = input(put(	CAHPS40  	, _1to1_short.), 1.); 
			CAHPS41  = input(put(	CAHPS41  	, _4to4_.), 1.); 
/*			PAS1_A  = input(put(	PAS1_A  	, _2to2_.), 1.); */
/*			PAS1_B  = input(put(	PAS1_B  	, _2to2_.), 1.); */
/*			PAS1_D  = input(put(	PAS1_D  	, _2to2_.), 1.); */
/*			PAS1_E  = input(put(	PAS1_E  	, _2to2_.), 1.); */
/*			PAS1_F  = input(put(	PAS1_F  	, _2to2_.), 1.); */
/*			PAS1_G  = input(put(	PAS1_G  	, _2to2_.), 1.); */
/*			PAS1_H  = input(put(	PAS1_H  	, _2to2_.), 1.); */
			CAHPS42  = input(put(	CAHPS42  	, _2to7_.), 1.); 
			CAHPS43  = input(put(	CAHPS43  	, _10to11_.), 1.); 
			ICHP4   = input(put(	ICHP4   	, _1to1_short.), 1.); 
			CAHPS44   = input(put(	CAHPS44   	, _1to1_short.), 1.); 
			CAHPS45   = input(put(	CAHPS45   	, _4to4_.), 1.); 
			CAHPS46   = input(put(	CAHPS46   	, _4to4_.), 1.); 
			CAHPS47   = input(put(	CAHPS47   	, _1to1_short.), 1.); 
			CAHPS48   = input(put(	CAHPS48   	, _4to4_.), 1.); 
			CAHPS49   = input(put(	CAHPS49   	, _10to11_.), 1.); 
			T1   	= input(put(	T1   		, _1to1_short.), 1.); 
			T2   	= input(put(	T2   		, _4to4_.), 1.); 
			T3   	= input(put(	T3   		, _4to4_.), 1.); 
/*			ICHP6   = input(put(	ICHP6   	, _1to1_long.), 1.); */
			CAHPS50  = input(put(	CAHPS50  	, _1to1_short.), 1.); 
			CAHPS51  = input(put(	CAHPS51  	, _4to4_.), 1.); 
			CAHPS52  = input(put(	CAHPS52  	, _1to1_short.), 1.); 
			CAHPS53  = input(put(	CAHPS53  	, _1to1_long.), 1.); 
			CAHPS54  = input(put(	CAHPS54  	, _1to1_long.), 1.); 
			CAHPS55  = input(put(	CAHPS55  	, _1to1_short.), 1.); 
			CAHPS56  = input(put(	CAHPS56  	, _1to1_short.), 1.); 
			CAHPS57  = input(put(	CAHPS57  	, _1to1_short.), 1.); 
			CAHPS58  = input(put(	CAHPS58  	, _1to1_short.), 1.); 
			CAHPS59  = input(put(	CAHPS59  	, _1to1_short.), 1.); 
			CAHPS60  = input(put(	CAHPS60  	, _1to1_short.), 1.); 
			CAHPS61  = input(put(	CAHPS61  	, _1to1_short.), 1.); 
			CAHPS62  = input(put(	CAHPS62  	, _1to1_short.), 1.); 
			CAHPS63  = input(put(	CAHPS63  	, _1to1_short.), 1.); 
			CAHPS64  = input(put(	CAHPS64  	, _1to1_short.), 1.); 
			CAHPS65  = input(put(	CAHPS65  	, _1to1_short.), 1.); 
			CAHPS66  = input(put(	CAHPS66  	, _1to1_short.), 1.); 
			CAHPS67  = input(put(	CAHPS67  	, _1to1_short.), 1.); 
			CAHPS68  = input(put(	CAHPS68  	, _1to1_short.), 1.); 
			TRTCHLD  = input(put(	TRTCHLD  	, _1to1_short.), 1.); 
			TRTADLT  = input(put(	TRTADLT  	, _1to1_short.), 1.); 
			CHNGAGE  = input(put(	CHNGAGE  	, _1to1_short.), 1.); 
			CAHPS75   = input(put(	CAHPS75   	, _3to6_.), 1.); 
			NEEDMEDS   = input(put(	NEEDMEDS   	, _2to2_.), 1.); 
			NEEDSERV   = input(put(	NEEDSERV   	, _2to2_.), 1.); 
			LIMITED   = input(put(	LIMITED   	, _2to2_.), 1.); 
			NEEDTHER   = input(put(	NEEDTHER   	, _2to2_.), 1.); 
			NEEDCOUN   = input(put(	NEEDCOUN   	, _2to2_.), 1.); 
			SPECIALNEED= input(put(	SPECIALNEEDS,    _2to2_.), 1.); 
			ICHP9   = input(put(	ICHP9   	, _2to2_.), 1.); 
run; 

proc freq data = df_format; 
	tables  
CAHPS3  
CAHPS4  
CAHPS5  
CAHPS6  
AR1   	
AR2   	
UT1   	
 	
ICHP2   
ICHP3   
CAHPS7  
CAHPS8  
CAHPS9  
AH1   	
AH2   	
CAHPS10 
CAHPS11 
CAHPS12 
CAHPS13 
FREW1   
FREW4   
CAHPS14 
CAHPS15 
CAHPS16 
CAHPS17 
CAHPS18 
CAHPS19 
CAHPS20 
CAHPS21 
CAHPS22 
CAHPS23 
CAHPS24 
CAHPS25 
CAHPS26 
CAHPS27 
C1   	
CAHPS28 
CAHPS29 
CAHPS30 
CAHPS31 
C2   	
CAHPS32 
CAHPS33 
CU14  	
CU15  	
CU23  	
CU24  	
CAHPS34 
CAHPS35 
CAHPS36 
PD1   	
PD2   	
CAHPS37 
CAHPS38 
CAHPS39 
CAHPS40 
CAHPS41 
/*PAS1_A  */
/*PAS1_B  */
/*PAS1_D  */
/*PAS1_E  */
/*PAS1_F  */
/*PAS1_G  */
/*PAS1_H  */
CAHPS42 
CAHPS43 
ICHP4   
CAHPS44 
CAHPS45 
CAHPS46 
CAHPS47 
CAHPS48 
CAHPS49 
T1   	
T2   	
T3   	
/*ICHP6   */
CAHPS50 
CAHPS51 
CAHPS52 
CAHPS53 
CAHPS54 
CAHPS55 
CAHPS56 
CAHPS57 
CAHPS58 
CAHPS59 
CAHPS60 
CAHPS61 
CAHPS62 
CAHPS63 
CAHPS64 
CAHPS65 
CAHPS66 
CAHPS67 
CAHPS68 
TRTCHLD 
TRTADLT 
CHNGAGE 
CAHPS75 
NEEDMEDS 
NEEDSERV 
LIMITED 
NEEDTHER 
NEEDCOUN 
SPECIALNEED
ICHP9   
			/ list; 
run; 

proc freq data=df_format; 
	tables PHI_Plan_Name PHI_SA_Name Sex Race; 
run; 

/** Transfer the plan-code to MCO and SA, dont use county and program, having duplicating issue;*/
/** Since SK dataset doesnt have plan_sa_name and plan_prog_name, we add it thru plancode.xlsx;*/
/**/
/*proc import datafile = "K:\TX-EQRO\Inbound\MCO_report_cards_2023\plancode.xlsx"*/
/*	dbms = xlsx*/
/*	out = plancode_ref*/
/*	;*/
/*run;*/
/**/
/**sort these two datasets before merging;*/
/*proc sort data = plancode_ref;*/
/*	by plancode;*/
/*run;*/
/**/
/*proc sort data = df_format_all_quota;*/
/*	by PHI_Plan_Code;*/
/*run;*/
/**/
/*data df_format_all_quota;*/
/*	merge df_format_all_quota (in = a) plancode_ref (rename = (plancode = PHI_Plan_Code));*/
/*	by PHI_Plan_Code;*/
/*	if a;*/
/*run;*/
/**/
/*proc freq data=df_format_all_quota; */
/*	tables  MCONAME Servicearea Sex Race; */
/*run; */

data df_format_all_quota;
	set df_format;

	if Race =  "White, Non-Hispanic" then race_new = 1; 
	if Race =  "Black, Non-Hispanic" then race_new = 2; 
	if Race =  "Hispanic" then race_new = 3; 
	if Race =  "American Indian or Alaskan" then race_new = 4; 
	if Race =  "Asian, Pacific Islander" then race_new = 5; 
	if Race =  "Unknown / Other" then race_new = 6; 

	if PHI_Plan_Name =  "Aetna Better Health" then plan_new = 'A_'; 
	if PHI_Plan_Name =  "Amerigroup" then plan_new = 'B_'; 
	if PHI_Plan_Name =  "Blue Cross Blue Shield of Texas" then plan_new = 'C_'; 
	if PHI_Plan_Name =  "Community First Health Plans" then plan_new = 'D_'; 
	if PHI_Plan_Name =  "Community Health Choice" then plan_new = 'E_'; 
	if PHI_Plan_Name =  "Cook Children's Health Plan" then plan_new = 'F_'; 
	if PHI_Plan_Name =  "Dell Children's Health Plan (formerly Seton)" then plan_new = 'G_'; 
	if PHI_Plan_Name =  "Driscoll Health Plan" then plan_new = 'H_'; 
	if PHI_Plan_Name =  "El Paso Health" then plan_new = 'I_'; 
	if PHI_Plan_Name =  "FirstCare Health Plans" then plan_new = 'J_'; 
	if PHI_Plan_Name =  "Molina Healthcare of Texas" then plan_new = 'K_'; 
	if PHI_Plan_Name =  "Parkland Community Health Plan" then plan_new = 'L_'; 
	if PHI_Plan_Name =  "RightCare from Scott & White Health Plan" then plan_new = 'M_'; 
	if PHI_Plan_Name =  "Superior HealthPlan" then plan_new = 'N_'; 
	if PHI_Plan_Name =  "Texas Children's Health Plan" then plan_new = 'O_'; 
	if PHI_Plan_Name =  "UnitedHealthCare Community Plan" then plan_new = 'P_'; 

	quota_01 = cats("", plan_new, PHI_SA_Name, Sex, race_new); 

	quota_02 = cats("", 'ALL', PHI_SA_Name, Sex, race_new); 
	quota_03 = cats("", plan_new, 'ALL', Sex, race_new); 
	quota_04 = cats("", plan_new, PHI_SA_Name, 'ALL', race_new); 
	quota_05 = cats("", plan_new, PHI_SA_Name, Sex, 'ALL'); 

	quota_06 = cats("", 'ALL', 'ALL', Sex, race_new); 
	quota_07 = cats("", 'ALL', PHI_SA_Name, 'ALL', race_new); 
	quota_08 = cats("", 'ALL', PHI_SA_Name, Sex, 'ALL'); 
	quota_09 = cats("", plan_new, 'ALL', 'ALL', race_new); 
	quota_10 = cats("", plan_new, 'ALL', Sex, 'ALL'); 
	quota_11 = cats("", plan_new, PHI_SA_Name, 'ALL', 'ALL'); 

	quota_12 = cats("", 'ALL', 'ALL', 'ALL', race_new); 
	quota_13 = cats("", 'ALL', 'ALL', Sex, 'ALL'); 
	quota_14 = cats("", 'ALL', PHI_SA_Name, 'ALL', 'ALL'); 
	quota_15 = cats("", plan_new, 'ALL', 'ALL', 'ALL'); 
	quota_16 = cats("", 'ALL', 'ALL', 'ALL', 'ALL'); 
run;

proc freq data=df_format_all_quota; 
tables quota_01 quota_16;
run; 

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\SC_output_thlc\case_mix_output"; 

/* save the recoded data */ 
data thlc.df_format_all_quota_sc_gnr; 
	set df_format_all_quota; 
run; 

proc freq data=thlc.df_format_all_quota_sc_gnr; 
tables CAHPS3  
CAHPS4  
CAHPS5  
CAHPS6  
AR1   	
AR2   	
UT1   	
/*UT1A   	*/
ICHP2   
ICHP3   
CAHPS7  
CAHPS8  
CAHPS9  
AH1   	
AH2   	
CAHPS10 
CAHPS11 
CAHPS12 
CAHPS13 
FREW1   
FREW4   
CAHPS14 
CAHPS15 
CAHPS16 
CAHPS17 
CAHPS18 
CAHPS19 
CAHPS20 
CAHPS21 
CAHPS22 
CAHPS23 
CAHPS24 
CAHPS25 
CAHPS26 
CAHPS27 
C1   	
CAHPS28 
CAHPS29 
CAHPS30 
CAHPS31 
C2   	
CAHPS32 
CAHPS33 
CU14  	
CU15  	
CU23  	
CU24  	
CAHPS34 
CAHPS35 
CAHPS36 
PD1   	
PD2   	
CAHPS37 
CAHPS38 
CAHPS39 
CAHPS40 
CAHPS41 
/*PAS1_A  */
/*PAS1_B  */
/*PAS1_D  */
/*PAS1_E  */
/*PAS1_F  */
/*PAS1_G  */
/*PAS1_H  */
CAHPS42 
CAHPS43 
ICHP4   
CAHPS44 
CAHPS45 
CAHPS46 
CAHPS47 
CAHPS48 
CAHPS49 
T1   	
T2   	
T3   	
/*ICHP6   */
CAHPS50 
CAHPS51 
CAHPS52 
CAHPS53 
CAHPS54 
CAHPS55 
CAHPS56 
CAHPS57 
CAHPS58 
CAHPS59 
CAHPS60 
CAHPS61 
CAHPS62 
CAHPS63 
CAHPS64 
CAHPS65 
CAHPS66 
CAHPS67 
CAHPS68 
TRTCHLD 
TRTADLT 
CHNGAGE 
CAHPS75 
NEEDMEDS 
NEEDSERV 
LIMITED 
NEEDTHER 
NEEDCOUN 
SPECIALNEED
ICHP9   ;
run; 

