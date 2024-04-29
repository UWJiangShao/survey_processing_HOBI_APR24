Draft for import excel to cahps list, using SAS macro to generate sas code 

proc sql; 
create table xxx as 
select survey_ID
	,put(cahps1, _1to1_.) as cahps1
	, ... all ...
	from dataset ;

quit;




** macro for selecting variables from a table for PROC SQL, with exclusion, avoid reference to each variable;

proc sql;
	select distinct var into: varList from excel; 
	select disntinct 
qui; 


%macro selectVars(table, varList);
    %local i varName ;
    %let i = 1;
    %do %while(%scan(&varList, &i) ne );
        %let varName = %scan(&varList, &i);

    	put(&varName, &format) as &varname %if (%scan(&varList, %eval(&i + 1)) ne ) %then ,;
        %let i = %eval(&i + 1);
    %end;
%mend selectVars;







