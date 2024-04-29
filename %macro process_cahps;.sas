%macro process_cahps;

/* Open the dataset cahps_info */
data _null_;
    set cahps_info end=last;
    call symputx('numRows', _N_);  /* Count the number of rows to loop over */
    array vars[2] $100 var format_sas;  /* Assume var and format_sas are character variables */

    /* Put values into macro variables for each row */
    do i = 1 to dim(vars);
        call symputx(cats('var', i, '_', _N_), vars[i]);
    end;
run;

/* Loop through each line of cahps_info using the number of rows */
%do j=1 %to &numRows;

    /* Retrieve the macro variables for var and format_sas */
    %let curr_var = &&var1_&j;
    %let curr_format = &&var2_&j;

    /* Split the var list and apply format to each */
    data sp_database;
        set sp_database;

        /* Dynamic format application */
        %let k = 1;
        %let var = %scan(&curr_var, &k);

        %do %while("&var" ne "");
            format &var &curr_format.;
            %let k = %eval(&k + 1);
            %let var = %scan(&curr_var, &k);
        %end;
    run;

    /* Call the %cahps macro */
    %cahps(var=&curr_var, name=&outname, pvalue=0.05);

%end;

%mend process_cahps;
