%macro update_rates;

/* Create a temporary dataset to manage updates */
data unadjusted_updated;
    set unadjusted_dataset;
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
