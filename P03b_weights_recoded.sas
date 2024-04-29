/* Update on Apr 15, 2024 - Recode CAHPS question as either 0 or 1 based on THLC value set */ 
/* for this step, the result of P03 will have a new version for CASE-MIX, since ICHP's CAHPS5.0 version */ 
/* has been modified for generating 0% - 100% rate score, then everything will need to be recoded */

OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** NRA and weight adjust;

%let program = P03;
%let prog = SP;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR+Plus\";

libname myfmtsks 'E:\jiang.shao\format_lib_kira'; 

/* Step 1. Recode for missing. Based on reviewing all questionares, -8 and -9 are the only two types */ 

/* Step 2: recode for CAHPS. Based on the THLC value set, different CAHPS will have different dichotemous pattern*/ 
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

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\case_mix_output"; 

data &program._df_&prog._merge_w_recoded; 
	set temp.&program._df_&prog._merge_w; 
run;

/*ods pdf file="K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\SP_question_dist.pdf";*/
/**/
/*proc freq data = &program._df_&prog._merge_w_recoded; */
/*	tables  intro -- EXITCB1C / list; */
/*run; */
/**/
/*ods pdf close; */


/* import two indicator files */ 
proc import out=cahps_list
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\cahps_list_by_program.xlsx"
	dbms = xlsx replace;
	sheet = 'SP_2023_CAHPS'; 
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
					cahps4 = input(put(cahps4,  	_4to4_.), 1.); 
					cahps6 = input(put(cahps6,       _4to4_.), 1.); 
					cahps9 =  input( put(cahps9,   _4to4_.), 1.); 
					cahps20 =  input( put(cahps20,       _4to4_.), 1.); 
					cahps12 =  input( put(cahps12,    _4to4_. ), 1.); 
					cahps13 =  input( put(cahps13,    _4to4_. ), 1.); 
					cahps14 =  input( put(cahps14,    _4to4_. ), 1.); 
					cahps15 =  input( put(cahps15,       _4to4_.), 1.); 
					cahps3 =  input( put(cahps3,       _1to1_short.), 1.); 
					cahps5 =  input( put(cahps5,       _1to1_short.), 1.); 
					cahps7 =  input( put(cahps7,       _2to7_.), 1.); 

					cahps10 =  input( put(cahps10,       _1to1_short.), 1.); 
					cahps11 =  input( put(cahps11,       _2to7_.), 1.); 

					cahps18 =  input( put(cahps18,       _10to11_.), 1.); 
					cahps19 =  input( put(cahps19,       _1to1_short.), 1.); 

					cahps28 =  input( put(cahps28,       _10to11_.), 1.); 
					cahps29 =  input( put(cahps29,       _1to1_long.), 1.); 
					cahps38 =  input( put(cahps38,       _3to6_.), 1.); 
	
run; 
proc freq data = df_format; 
	tables cahps9 
cahps20
cahps12
cahps13
cahps14
cahps15
cahps3 
cahps5 
cahps7 
cahps10
cahps11
cahps18
cahps19
cahps28
cahps29
cahps38 
			/ list; 
run; 

proc freq data=df_format; 
tables PHI_Plan_Name PHI_SA_Name Race Sex;
run; 

data df_format_all_quota; 
	set df_format;

	word1 = compress(scan(PHI_Plan_Name, 1), , 'ka'); 
	word2 = compress(scan(PHI_Plan_Name, 2), , 'ka'); 

	plan_new = catx('', word1, word2);
	plan_new = compress(plan_new); 

	if plan_new = "UnitedHealthCareCommunity" then plan_new = "UHC"; 
	if plan_new = "Amerigroup" then plan_new = "AME"; 
	if plan_new = "SuperiorHealthPlan" then plan_new = "SUP"; 
	if plan_new = "MolinaHealthcare" then plan_new = "MOL"; 

	word1 = compress(scan(PHI_SA_Name, 1), , 'ka'); 
	word2 = compress(scan(PHI_SA_Name, 2), , 'ka'); 
	sa_new = catx('_', word1, word2); 

	if sa_new = "MRSA_Central" then sa_new = "MRSA_C"; 
	if sa_new = "MRSA_Northeast" then sa_new = "MRSA_NE"; 
	if sa_new = "MRSA_West" then sa_new = "MRSA_W"; 

	word1 = compress(scan(Race, 1), , 'ka'); 
	word2 = compress(scan(Race, 2), , 'ka'); 
	race_new = catx('_', word1, word2); 

run; 


data df_format_all_quota;
	set df_format_all_quota;
	quota_01 = catx('_', plan_new, sa_new, Sex, race_new); 

	quota_02 = catx('_', 'ALL', sa_new, Sex, race_new); 
	quota_03 = catx('_', plan_new, 'ALL', Sex, race_new); 
	quota_04 = catx('_', plan_new, sa_new, 'ALL', race_new); 
	quota_05 = catx('_', plan_new, sa_new, Sex, 'ALL'); 

	quota_06 = catx('_', 'ALL', 'ALL', Sex, race_new); 
	quota_07 = catx('_', 'ALL', sa_new, 'ALL', race_new); 
	quota_08 = catx('_', 'ALL', sa_new, Sex, 'ALL'); 
	quota_09 = catx('_', plan_new, 'ALL', 'ALL', race_new); 
	quota_10 = catx('_', plan_new, 'ALL', Sex, 'ALL'); 
	quota_11 = catx('_', plan_new, sa_new, 'ALL', 'ALL'); 

	quota_12 = catx('_', 'ALL', 'ALL', 'ALL', race_new); 
	quota_13 = catx('_', 'ALL', 'ALL', Sex, 'ALL'); 
	quota_14 = catx('_', 'ALL', sa_new, 'ALL', 'ALL'); 
	quota_15 = catx('_', plan_new, 'ALL', 'ALL', 'ALL'); 
	quota_16 = catx('_', 'ALL', 'ALL', 'ALL', 'ALL'); 

run;

proc freq data=df_format_all_quota; 
tables quota_01;
run; 



/* save the recoded data */ 
data thlc.df_format_all_quota; 
	set df_format_all_quota; 
run; 

proc contents data=df_format_all_quota; 
run; 


%let Full_Path_And_File_Name 	= K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\case_mix_output\df_format_all_quota.sas7bdat;
%let QuotaVariable 			 			  =  quota_02;
%let Suffix					 			     	  =  _quota_02;
%let OutputFolder 			 			  =  K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\case_mix_output\result\quota_01\;
%let pvalue = 0.05; 
%let adjuster = rage health_exc health_vgd health_gd health_fair health_poor edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll; 
%let wgtmean         = CompWeight; 
%let low_denominator = 30; 


%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;


%cahps(name = OUT_CAHPS18 , outname = OUT_CAHPS18	, var = CAHPS18 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS28 , outname = OUT_CAHPS28	, var = CAHPS28 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = GCQ		 , outname = GCQ			, var = CAHPS4 CAHPS6 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = GNC		 , outname = GNC			, var = CAHPS9 CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = HWDC		 , outname = HWDC			, var = CAHPS12 CAHPS13 CAHPS14 CAHPS15 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS3 , outname = OUT_CAHPS3	, var = CAHPS3 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS4 , outname = OUT_CAHPS4	, var = CAHPS4 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS5 , outname = OUT_CAHPS5	, var = CAHPS5 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS6 , outname = OUT_CAHPS6	, var = CAHPS6 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS7 , outname = OUT_CAHPS7	, var = CAHPS7 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS9 , outname = OUT_CAHPS9	, var = CAHPS9 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS10 , outname = OUT_CAHPS10	, var = CAHPS10 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS11 , outname = OUT_CAHPS11	, var = CAHPS11 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS12 , outname = OUT_CAHPS12	, var = CAHPS12 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS13 , outname = OUT_CAHPS13	, var = CAHPS13 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS14 , outname = OUT_CAHPS14	, var = CAHPS14 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS15 , outname = OUT_CAHPS15	, var = CAHPS15 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS18 , outname = OUT_CAHPS18	, var = CAHPS18 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS19 , outname = OUT_CAHPS19	, var = CAHPS19 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS20 , outname = OUT_CAHPS20	, var = CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS28 , outname = OUT_CAHPS28	, var = CAHPS28 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS29 , outname = OUT_CAHPS29	, var = CAHPS29 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = ATC		 , outname = ATC			, var = CAHPS4 CAHPS6 CAHPS9 CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS38 , outname = OUT_CAHPS38	, var = CAHPS38 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS9 , outname = OUT_CAHPS9	, var = CAHPS9 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS20 , outname = OUT_CAHPS20	, var = CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS4 , outname = OUT_CAHPS4	, var = CAHPS4 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS6 , outname = OUT_CAHPS6	, var = CAHPS6,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);
 


/*%macro process_cahps;*/
/**/
/*/* Open the dataset cahps_info */*/
/*data _null_;*/
/*    set work.cahps_info end=last;*/
/*    call symputx('numRows', _N_);  /* Count the number of rows to loop over */*/
/*	call symputx(cats('var', _N_), var);*/
/*    call symputx(cats('outname', _N_), outname);*/
/*run;*/
/**/
/*/* Loop through each line of cahps_info using the number of rows */*/
/*		%do i=1 %to &numRows;*/
/*		%cahps( var		        = &&var&i,*/
/*						name            = &&outname&i,*/
/*				        pvalue          = 0.05 ,*/
/*					    wgtmean         = CompWeight,*/
/*					    wgtdata			= ,*/
/*					    low_denominator = 30 ,*/
/*						adjuster        = rage health_exc health_vgd health_gd health_fair health_poor */
/*									edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,*/
/*					    excludeQuotas   = ,*/
/*				        outname         =  &&outname&i,*/
/*				        recode = 0,*/
/*				        vartype = 1 */
/*					   ) ;*/
/*		%end;*/
/**/
/*%mend process_cahps;*/
/**/
/*%process_cahps; */; 










