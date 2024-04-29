proc import out=df_SA_survey_23
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2023\p03_df_sa_merge_final.sav"
	dbms = SAV replace;
run;

proc import out=df_SA_survey_22
	datafile = "K:\TX-EQRO\Research\Member_Surveys\CY2022\STAR Adult\Data\STAR Adult 2022_completes.sav"
	dbms = SAV replace;
run;

/* Check dental data */ 
proc import out=df_dental_23_all
	datafile = "K:\TX-EQRO\Research\Member_Surveys\CY2023\Dental Caregiver\Data\DMS23_Completes Final.sav"
	dbms = SAV replace;
run;

proc contents data = df_dental_23_all out = tem1(keep = name) noprint; 
run; 

proc import out=df_dental_21_all
	datafile = "K:\TX-EQRO\Research\Member_Surveys\CY2021\Dental Caregiver\2. Data\DMS21 1028_1100.sav"
	dbms = SAV replace;
run;

proc contents data = df_dental_21_all out = tem2(keep = name) noprint; 
run; 

proc sql; 
	create table UniqueIn23 as 
	select a.name
	from tem1 as a
	left join tem2 as b on a.name = b.name
	where b.name is null; 

	create table UniqueIn21 as 
	select b.name
	from tem2 as b
	left join tem1 as a on b.name = a.name
	where a.name is null; 
quit; 


proc print data = UniqueIn23; title "var unique in 2023 dental"; run; 
proc print data = UniqueIn21; title "var unique in 2021 dental"; run; 

libname sa_temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult"; 

data P03_sa_test; 
	set sa_temp.p03_df_sa_merge_final; 
run; 

proc freq data = P03_sa_test; 
	tables cahps7; 
run; 

proc format;
	value missing_f
	-8 = '.'
	-9 = '.';
run; 

data P03_sa_test; 
	set P03_sa_test; 
	format cahps7 missing_f.; 
run; 

proc format;
	value cahps7_f
	0 = '0'
	1-6 = '1'; 
run; 

data P03_sa_test; 
	set P03_sa_test; 
	format cahps7 cahps7_f.; 
run; 












proc contents data = df_sa_survey_23 varnum; 
run; 

proc contents data = df_SA_survey_22 varnum; 
run; 

proc import out=df_SP_survey_23
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\STAR+Plus ARC 2023_Completes.sav"
	dbms = SAV replace;
run;

proc contents data = df_SP_survey_23 varnum; 
run;


proc import out=df_SP_survey_22
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2022\STAR PLUS 2022_Completes.sav"
	dbms = SAV replace;
run;

proc contents data = df_SP_survey_22 varnum; 
run;

proc freq data = df_SP_survey_22; 
tables CAHPS35; 
run;





proc import out=df_SC_survey_21
	datafile = "K:\TX-EQRO\Research\Member_Surveys\CY2021\STAR Child\2. Data\SC21_merged.sav"
	dbms = SAV replace;
run;

proc import out=df_SC_survey_23
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\STAR Child ARC_Biennial 2023_Completes Final.sav"
	dbms = SAV replace;
run;

proc import out=df_SC_survey_21_CCC
	datafile = "K:\TX-EQRO\Research\Member_Surveys\CY2021\STAR Child\2. Data\SC21_merged_CCC.sav"
	dbms = SAV replace;
run;

proc contents data = df_SC_survey_21; 
run;

proc contents data = df_SC_survey_23; 
run;

proc contents data = df_SC_survey_21_CCC; 
run;

proc freq data = df_SC_survey_21_CCC; 
	tables cahps60 * cahps62 
		   cahps63 * cahps65
		   cahps66 * cahps68
/*		   cahps69 * cahps71*/
/*		   cahps72 * cahps73 */
		   / nopercent nocum nocol norow; 
run; 


proc freq data = df_SC_survey_21_CCC; 
	tables cahps55 * cahps56 
		   cahps58 * cahps59
		   cahps61 * cahps62
/*		   cahps69 * cahps71*/
/*		   cahps72 * cahps73 */
		   / nopercent nocum nocol norow; 
run; 

proc freq data = df_SC_survey_21_CCC; 
	tables cahps60 * cahps61
/*		   cahps58 * cahps59*/
/*		   cahps61 * cahps62*/
/*		   cahps69 * cahps71*/
/*		   cahps72 * cahps73 */
		   / nopercent nocum nocol norow; 
run; 

data ccc_cohort; 
	set df_SC_survey_21_CCC; 
	if cahps60 = 2 then needmeds = 0; 
	if cahps61 = 2 then needmeds = 0; 
	if cahps62 = 2 then needmeds = 0; 
	if cahps60=1 & cahps61=1 & cahps62=1 then needmeds = 1; 
run; 

proc freq data = df_SC_survey_21_CCC; 
	tables needmeds / nopercent nocum nocol norow; 
run; 


/* take out the CCC cohort for case mix adjustment */ 
libname cohort "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\SC_output_thlc\case_mix_output\"; 

data ccc_cohort; 
	set cohort.df_format_all_quota_sc_gnr; 
run; 

proc contents data = ccc_cohort; 
run; 

/* output ccc cohort dataset */ 
data ccc_cohort; 
	set ccc_cohort; 
	where specialneed = 1; 
run; 

data cohort.df_format_all_quota_sc_ccc; 
	set ccc_cohort; 
run; 


