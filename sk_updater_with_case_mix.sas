/* STAR Kids Case Mix Updater */ 
/* Dont mix use among programs, as programs differs in quota names */ 

/* This program is designed for update the unadjusted survey result with case mixed result */

/* Step 1. read in case mix result */ 
* macro to import all sheets from one Excel file;
%macro import_excel(excel_address, quota_name);
 
	** When this MIXED option is set to YES the SAS variables are crated as character variables, 
	*** all numeric data is converted to character data, the Excel file is read in import mode, 
	*** and no updates are allowed to the file.;
	libname ELIB excel &excel_address. mixed=yes;
 
	proc sql;
		create table excel_sheet as
		select *
		from dictionary.tables
		where libname = "ELIB"
		;
 
		select memname
		into :sheet_list separated by '*'
		from excel_sheet
		;
 
		select count(memname)
		into :sheet_n
		from excel_sheet
		;
	quit;
 
	%put &sheet_list.;
	%put &sheet_n.;
 
	%macro import_sheet;
		%do i = 1 %to &sheet_n.;
			%let var = %scan(&sheet_list., &i., *);
			%if %sysfunc(find(&var., $)) = 0 %then %do;
				%let sf = %substr(&var, 1, %length(&var.));
				data &sf.;
					set ELIB."&var."n;
					length new_&quota_name $100; 
					where &quota_name ne ' ' AND &quota_name ne 'TX';

					/* only keep quota name, rate, and denom*/
					keep  &quota_name. &var. &var._den new_&quota_name. new_rate; 
	
					/* process the quota name so that we can merge with unadjusted result */ 

/*						if MCONAME =  "Aetna Better Health" then plan_new = 'A_'; */
/*	if MCONAME =  "Amerigroup" then plan_new = 'B_'; */
/*	if MCONAME =  "Blue Cross Blue Shield" then plan_new = 'C_'; */
/*	if MCONAME =  "Community First Health Plans" then plan_new = 'D_'; */
/*	if MCONAME =  "Cook Children's Health Plan" then plan_new = 'E_'; */
/*	if MCONAME =  "Driscoll Health Plan" then plan_new = 'F_'; */
/*	if MCONAME =  "Superior" then plan_new = 'G_'; */
/*	if MCONAME =  "Texas Children's Health Plan" then plan_new = 'H_'; */
/*	if MCONAME =  "UnitedHealthcare" then plan_new = 'I_'; */

					first_char = substr(&quota_name., 1, 2); 
					if first_char = 'A_' then new_&quota_name. = 'Aetna Better Health' || substr(&quota_name. , 3); 
					else if first_char = 'B_' then new_&quota_name. = 'Amerigroup' || substr(&quota_name. , 3); 
					else if first_char = 'C_' then new_&quota_name. = 'Blue Cross Blue Shield of Texas' || substr(&quota_name. , 3); 
					else if first_char = 'D_' then new_&quota_name. = 'Community First Health Plans' || substr(&quota_name. , 3); 
					else if first_char = 'E_' then new_&quota_name. =  "Cook Children's Health Plan" || substr(&quota_name. , 3); 
					else if first_char = 'F_' then new_&quota_name. = "Driscoll Health Plan" || substr(&quota_name. , 3); 
					else if first_char = 'G_' then new_&quota_name. = "Superior HealthPlan" || substr(&quota_name. , 3); 
					else if first_char = 'H_' then new_&quota_name. = "Texas Children's Health Plan"|| substr(&quota_name. , 3); 
					else if first_char = 'I_' then new_&quota_name. = 'UnitedHealthCare Community Plan' || substr(&quota_name. , 3); 

					else if first_char = 'AL' then new_&quota_name. = 'AL' || substr(&quota_name. , 3); 

					new_&quota_name. = upcase(compress(new_&quota_name.)); 
					new_rate = &var.; 

					drop first_char; 

				run;
 
				proc contents data= &sf. varnum;
				run;
 
				proc sort data= &sf.;
					by &quota_name;
				run;
			%end;
		%end;
	%mend import_sheet;
 
	%import_sheet;
 
%mend import_excel; 



/* step 2. import spss generated tables, create a copy and update the rate */ 
proc import out=unadj_rate
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\SK_output_thlc\STARKids_2023_unadjusted.csv"
	dbms = csv replace;
	guessingrows= max; 
run;

data unadj_rate_for_match; 
	set unadj_rate; 
	quota = upcase(compress( '@qcat'n)); 
run; 

proc freq data=unadj_rate_for_match; 
	tables quota; 
run; 


/* step 3. import the cahps list and itemID 2 tip table for reference */ 
/* import two indicator files */ 
proc import out=cahps_list
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-04\cahps_list_by_program_ks_final_version.xlsx"
	dbms = xlsx replace;
	sheet = 'SK_2023_CAHPS'; 
run;

data cahps_info; 
	set cahps_list; 
	outname = upcase(outname); 
	keep itemID outname; 
run; 

/* step 4. Use CAHPS_INFO, tally cahps_info, and use corresponding dataset's new_quota to update unadj_rate */ 
/* tally CAHPS_INFO line by line, serve as an indicator, then tell which dataset sas should access, then use the dataset to merge unadjusted rate */ 

/* initialize the unadjusted_updated dataset only once, since we are going to update it */
data unadjusted_updated;
    set unadj_rate_for_match;
    length source_dataset $32 new_rate 8;
    retain source_dataset new_rate;
    source_dataset = '';
    new_rate = .;
run;


%macro update_rates (quota_num);


/* Retrieve the data from cahps_info and iterate through */
data _null_;
    set cahps_info end=last;
    call symputx(cats('outcome', _n_), trim(outname));
    call symputx(cats('itemid', _n_), itemID);
    if last then call symputx('numrows', _n_);
run;

%do i=1 %to &numrows;
    %let current_outcome = &&outcome&i;
    %let current_itemID = &&itemid&i;

    /* Access the dataset corresponding to the outcome */
    %let dataset_name = work.&current_outcome;

    /* Temporary dataset to hold the new rates and quotas */
    data temp_rates;
        set &dataset_name;
        rename new_rate = new_rate_temp new_&quota_num. = quota;
    run;

    /* Update the unadjusted dataset with new rates where itemID and quota match */
    proc sql;
        update unadjusted_updated
        set new_rate = (select new_rate_temp from temp_rates where temp_rates.quota = unadjusted_updated.quota)
        where itemID = &current_itemID and exists (
            select * from temp_rates where temp_rates.quota = unadjusted_updated.quota
        );
    quit;
%end;

/* Cleanup: Replace old rates with new rates if updated */
data unadjusted_final;
    set unadjusted_updated;
    if new_rate ne . then Rate = new_rate; /* Apply the new rate */
    drop source_dataset new_rate;
run;

%mend update_rates;

/*%update_rates (quota_01);*/

/* great! we have checked that same cahps has been served for same rates for different itemID */ 
/*data check_for_dup_cahps; */
/*	set unadjusted_updated; */
/*	where (ItemID = 50532 or ItemID = 50191) */
/*			AND new_rate ne . */
/*			AND quota = 'AMERIGROUPBEXARF1'; */
/*run; */


/* iterate step 1 and step 4 */ 
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_01.xlsx", quota_01); 
%update_rates (quota_01);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_02.xlsx", quota_02); 
%update_rates(quota_02);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_03.xlsx", quota_03); 
%update_rates(quota_03);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_04.xlsx", quota_04); 
%update_rates(quota_04);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_05.xlsx", quota_05); 
%update_rates(quota_05);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_06.xlsx", quota_06); 
%update_rates(quota_06);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_07.xlsx", quota_07); 
%update_rates(quota_07);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_08.xlsx", quota_08); 
%update_rates(quota_08);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_09.xlsx", quota_09); 
%update_rates(quota_09);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_10.xlsx", quota_10); 
%update_rates(quota_10);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_11.xlsx", quota_11); 
%update_rates(quota_11);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_12.xlsx", quota_12); 
%update_rates(quota_12);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_13.xlsx", quota_13); 
%update_rates(quota_13);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_14.xlsx", quota_14); 
%update_rates(quota_14);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_15.xlsx", quota_15); 
%update_rates(quota_15);
%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk_out_quota_16.xlsx", quota_16); 
%update_rates(quota_16);

/* no not-matching - checkedon Apr 28 */ 
data check_for_whether_updated; 
	set unadjusted_final; 
	where Rate >= 2 AND isLD ne 1 ;
run; 

proc freq data=unadjusted_final; 
	tables Rate; 
run; 
/**/
/*proc freq data=check_for_whether_updated; */
/*	tables '@qcat'n PlanName ServiceArea Race Sex ItemID isLD Denom; */
/*run; */

/* solved, seems that only Denom = 1 or 2 Rate are not updated, because cahps cannot generate result for them. */ 

/* with the substituion function confirm to be worked, set the updated rate to be * 100 (same as portal format) */ 
data adjusted_final; 	
	set unadjusted_final; 
	if Rate < 0 then adjusted_rate = 0; 
	else if 0 <= Rate <= 1 then adjusted_rate = round(Rate * 100, 0.01); 
	else if 1< Rate < 2 then adjusted_rate = 100; 
	else if 2 <= Rate <= 100 then adjusted_rate = round(Rate, 0.01); 
run; 

proc export data=work.adjusted_final
	outfile= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\STARKids_2023_adjusted.xlsx"
	dbms=xlsx replace; 
run; 






