%macro update_rates;

/* Create a temporary dataset to manage updates */
data unadjusted_updated;
    set unadjusted_dataset;
    length source_dataset $32 new_rate 8;
    retain source_dataset new_rate;
    source_dataset = '';
    new_rate = .;
run;

/* Step through each entry in cahps_info */
proc sql noprint;
    select count(*) into :numrows from cahps_info;
quit;

%do i=1 %to &numrows;
    /* Get the outcome and itemID for each row in cahps_info */
    data _null_;
        set cahps_info point=&i;
        call symputx('current_outcome', trim(Outcome));
        call symputx('current_itemID', itemID);
    run;

    /* Access the dataset corresponding to the outcome */
    %let dataset_name = work.&current_outcome;

    /* Temporary dataset to hold the new rates and quotas */
    data temp_rates;
        set &dataset_name;
        rename new_rate = new_rate_temp quota_new = quota;
    run;

    /* Update the unadjusted dataset with new rates where itemID and quota match */
    proc sql;
        update unadjusted_updated
        set new_rate = (select new_rate_temp from temp_rates where temp_rates.quota = unadjusted_updated.quota)
        where itemID = &current_itemID and exists (
            select * from temp_rates where temp_rates.quota = unadjusted_updated.quota
        );
    endrun;
%end;

/* Cleanup: Replace old rates with new rates if updated */
data unadjusted_final;
    set unadjusted_updated;
    if new_rate ne . then Rate = new_rate; /* Apply the new rate */
    drop source_dataset new_rate;
run;

%mend update_rates;

%update_rates;
