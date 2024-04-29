/* This program is designed for update the unadjusted survey result with case mixed result */

/* Step 1. read in case mix result */ 
* macro to import all sheets from one Excel file;
%macro import_excel(excel_address, quota_name);
 
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
					first_char = substr(&quota_name., 1, 1); 
					if first_char = '1' then new_&quota_name. = 'Amerigroup' || substr(&quota_name. , 2); 
					else if first_char = '2' then new_&quota_name. = 'Molina Healthcare of Texas' || substr(&quota_name. , 2); 
					else if first_char = '3' then new_&quota_name. = 'Superior HealthPlan' || substr(&quota_name. , 2); 
					else if first_char = '4' then new_&quota_name. = 'UnitedHealthCare Community Plan' || substr(&quota_name. , 2); 

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

%import_excel("K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\case_mix_output\df_format_all_quota_out_quota_01.xlsx", quota_01); 

* /* step 2. import spss generated tables, create a copy and update the rate */ 
* proc import out=unadj_rate
* 	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\SP_thlc_output\STARPLUS_2023_unadjusted.csv"
* 	dbms = csv replace;
* 	guessingrows= max; 
* run;

* data unadj_rate_for_match; 
* 	set unadj_rate; 
* 	quota = upcase(compress( '@qcat'n)); 
* run; 

* proc freq data=unadj_rate_for_match; 
* 	tables quota; 
* run; 


* /* step 3. import the cahps list and itemID 2 tip table for reference */ 
* /* import two indicator files */ 
* proc import out=cahps_list
* 	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\cahps_list_by_program.xlsx"
* 	dbms = xlsx replace;
* 	sheet = 'SP_2023_CAHPS'; 
* run;

* data cahps_info; 
* 	set cahps_list; 
* 	outname = upcase(outname); 
* 	keep itemID outname; 
* run; 

/* step 4. Use CAHPS_INFO, tally cahps_info, and use corresponding dataset's new_quota to update unadj_rate */ 
/* tally CAHPS_INFO line by line, serve as an indicator, then tell which dataset sas should access, then use the dataset to merge unadjusted rate */ 
%macro update_rates;

/* Create a temporary dataset to manage updates */
data unadjusted_updated;
    set unadj_rate_for_match;
    length source_dataset $32 new_rate 8;
    retain source_dataset new_rate;
    source_dataset = '';
    new_rate = .;
run;

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
        rename new_rate = new_rate_temp new_quota_01 = quota;
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

%update_rates;


/* Step 5. iterate step 1 and step 4,  import quota_02 to quota_16, then update the unadjusted_final for quota_02 until quota_16*/ 
%macro process_quotas(start, end, excel_path);
    %do q = &start %to &end;
        %let quota_suffix = %sysfunc(putn(&q, z2.));  /* Generates '01', '02', ..., '16' */

        /* Import each quota-specific dataset */
        %import_excel("&excel_path", quota_&quota_suffix.);

        /* Update rates using imported data */
        %update_rates;
    %end;
%mend process_quotas;

/* Call the macro to process quotas from 01 to 16 */
%process_quotas(
    1, 16,
    "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\case_mix_output\df_format_all_quota_out_quota_"
);








