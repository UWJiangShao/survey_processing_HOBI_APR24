OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr;

** NRA and weight adjust;

%let program = P03;
%let prog = SK;

OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Kids\";


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
	1-6 = '0'
	0 = '1'
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

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk"; 

data &program._df_&prog._merge_w_recoded; 
	set temp.&program._df_&prog._merge_w; 
run;

ods pdf file="K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\SK_question_dist.pdf";

proc freq data = &program._df_&prog._merge_w_recoded; 
	tables  intro -- cahps75 / list; 
run; 

ods pdf close; 


/* import two indicator files */ 
proc import out=cahps_list
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\cahps_list_by_program.xlsx"
	dbms = xlsx replace;
	sheet = 'SK_2023_CAHPS'; 
run;

proc import out=itemID_vs
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\THLC_Surveys - item ID table_v6.xlsx"
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


data df_format; 
	set &program._df_&prog._merge_w_recoded; 
				CAHPS3 =  input(put(CAHPS3 , _1to1_short.), 1.); 
				CAHPS4 =  input(put(CAHPS4 , _4to4_.), 1.); 
				CAHPS5 =  input(put(CAHPS5 , _1to1_short.), 1.); 
				CAHPS6 =  input(put(CAHPS6 , _4to4_.), 1.); 
				CAHPS7 =  input(put(CAHPS7 , _2to7_.), 1.); 
				CAHPS8 =  input(put(CAHPS8 , _4to4_.), 1.); 
				CAHPS10 =  input(put(CAHPS10 , _4to4_.), 1.); 
				CAHPS14 =  input(put(CAHPS14 , _1to1_short.), 1.); 
				CAHPS15 =  input(put(CAHPS15 , _4to4_.), 1.); 
				CAHPS17 =  input(put(CAHPS17 , _1to1_short.), 1.); 
				CAHPS18 =  input(put(CAHPS18 , _4to4_.), 1.); 
				CAHPS20 =  input(put(CAHPS20 , _1to1_short.), 1.); 
				CAHPS21 =  input(put(CAHPS21 , _4to4_.), 1.); 
				CAHPS23 =  input(put(CAHPS23 , _1to1_short.), 1.); 
				CAHPS24 =  input(put(CAHPS24 , _1to1_short.), 1.); 
				CAHPS25 =  input(put(CAHPS25 , _1to1_short.), 1.); 
				CAHPS26 =  input(put(CAHPS26 , _2to7_.), 1.); 
				CAHPS33 =  input(put(CAHPS33 , _1to1_short.), 1.); 
				CAHPS38 =  input(put(CAHPS38 , _1to1_short.), 1.); 
				CAHPS39 =  input(put(CAHPS39 , _1to1_short.), 1.); 
				CAHPS40 =  input(put(CAHPS40 , _1to1_short.), 1.); 
				CAHPS41 =  input(put(CAHPS41 , _4to4_.), 1.); 
				CAHPS49 =  input(put(CAHPS49 , _10to11_.), 1.); 
				CAHPS50 =  input(put(CAHPS50 , _1to1_short.), 1.); 
				CAHPS51 =  input(put(CAHPS51 , _4to4_.), 1.); 
				CAHPS53 =  input(put(CAHPS53 , _1to1_long.), 1.); 
				TRTCHLD =  input(put(TRTCHLD , _1to1_short.), 1.); 
				TRTADLT =  input(put(TRTADLT , _1to1_short.), 1.); 
				K5Q20R =  input(put(K5Q20R , _1to1_short.), 1.); 
				CAHPS75 =  input(put(CAHPS75 , _3to6_.), 1.); 
run; 

proc freq data = df_format; 
	tables  
CAHPS3 
CAHPS4 
CAHPS5 
CAHPS6 
CAHPS7 
CAHPS8 
CAHPS10
CAHPS14
CAHPS15
CAHPS17
CAHPS18
CAHPS20
CAHPS21
CAHPS23
CAHPS24
CAHPS25
CAHPS26
CAHPS33
CAHPS38
CAHPS39
CAHPS40
CAHPS41
CAHPS49
CAHPS50
CAHPS51
CAHPS53
TRTCHLD
TRTADLT
K5Q20R 
CAHPS75
			/ list; 
run; 

proc freq data=df_format_all_quota; 
	tables program county Race; 
run; 

* Transfer the plan-code to MCO and SA, dont use county and program, having duplicating issue;
* Since SK dataset doesnt have plan_sa_name and plan_prog_name, we add it thru plancode.xlsx;

proc import datafile = "K:\TX-EQRO\Inbound\MCO_report_cards_2023\plancode.xlsx"
	dbms = xlsx
	out = plancode_ref
	;
run;

*sort these two datasets before merging;
proc sort data = plancode_ref;
	by plancode;
run;

proc sort data = df_format_all_quota;
	by PHI_Plan_Code;
run;

data df_format_all_quota;
	merge df_format_all_quota (in = a) plancode_ref (rename = (plancode = PHI_Plan_Code));
	by PHI_Plan_Code;
	if a;
run;

proc freq data=df_format_all_quota; 
	tables  MCONAME Servicearea Sex Race; 
run; 

data df_format_all_quota;
	set df_format_all_quota;

	if Race =  "White, Non-Hispanic" then race_new = 1; 
	if Race =  "Black, Non-Hispanic" then race_new = 2; 
	if Race =  "Hispanic" then race_new = 3; 
	if Race =  "American Indian or Alaskan" then race_new = 4; 
	if Race =  "Asian, Pacific Islander" then race_new = 5; 
	if Race =  "Unknown / Other" then race_new = 6; 

	if MCONAME =  "Aetna Better Health" then plan_new = 'A_'; 
	if MCONAME =  "Amerigroup" then plan_new = 'B_'; 
	if MCONAME =  "Blue Cross Blue Shield" then plan_new = 'C_'; 
	if MCONAME =  "Community First Health Plans" then plan_new = 'D_'; 
	if MCONAME =  "Cook Children's Health Plan" then plan_new = 'E_'; 
	if MCONAME =  "Driscoll Health Plan" then plan_new = 'F_'; 
	if MCONAME =  "Superior" then plan_new = 'G_'; 
	if MCONAME =  "Texas Children's Health Plan" then plan_new = 'H_'; 
	if MCONAME =  "UnitedHealthcare" then plan_new = 'I_'; 

	quota_01 = cats("", plan_new, Servicearea, Sex, race_new); 

	quota_02 = cats("", 'ALL', Servicearea, Sex, race_new); 
	quota_03 = cats("", plan_new, 'ALL', Sex, race_new); 
	quota_04 = cats("", plan_new, Servicearea, 'ALL', race_new); 
	quota_05 = cats("", plan_new, Servicearea, Sex, 'ALL'); 

	quota_06 = cats("", 'ALL', 'ALL', Sex, race_new); 
	quota_07 = cats("", 'ALL', Servicearea, 'ALL', race_new); 
	quota_08 = cats("", 'ALL', Servicearea, Sex, 'ALL'); 
	quota_09 = cats("", plan_new, 'ALL', 'ALL', race_new); 
	quota_10 = cats("", plan_new, 'ALL', Sex, 'ALL'); 
	quota_11 = cats("", plan_new, Servicearea, 'ALL', 'ALL'); 

	quota_12 = cats("", 'ALL', 'ALL', 'ALL', race_new); 
	quota_13 = cats("", 'ALL', 'ALL', Sex, 'ALL'); 
	quota_14 = cats("", 'ALL', Servicearea, 'ALL', 'ALL'); 
	quota_15 = cats("", plan_new, 'ALL', 'ALL', 'ALL'); 
	quota_16 = cats("", 'ALL', 'ALL', 'ALL', 'ALL'); 
run;

proc freq data=df_format_all_quota; 
tables quota_01 quota_16;
run; 

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk"; 

/* save the recoded data */ 
data thlc.df_format_all_quota_sk; 
	set df_format_all_quota; 
run; 

proc freq data=thlc.df_format_all_quota_sk; 
tables quota_01 quota_16;
run; 

