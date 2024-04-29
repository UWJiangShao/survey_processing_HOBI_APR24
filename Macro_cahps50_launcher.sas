***** This file exists to simplify UseMe.sas by separating out a number of display and  *****
***** other parameters that will not typically need to be edited.						***** ;
*--------------------------------------------------------------------------*;
%let Version     = 4.1 ;
%let Created     = 22Sept 2006 ;
%let Author      = Matthew J. Cioffi ;
%let Type        = Program ;
%let Updated     = 2021-05-28 ;
%let By_Whom     = ncc ;
*--------------------------------------------------------------------------*
|* Reason for Update *
|	Simplify this file by removing options we at present expect not to use.
|	Instructions for using said options are given in the instructions file 
|	in this directory.
|	Add descriptions of values to change in this file before running
|   analysis on your dataset.
|	Add subroutine to create working dataset from full path+filename: 
|	.sas7bdat or .sav, in "" or without, \ or / separating directory tree.
|	Update for version 5.0 of the analysis macro.
*--------------------------------------------------------------------------*;

*---------------------------------------------------------------------------*
| Assign working dataset. Any manipulations should be performed before		|
| invoking your analysis file (copy of UseMe.sas).							|
*---------------------------------------------------------------------------*;
%macro dsAssign (df = &Full_Path_And_File_Name, outf = &OutputFolder) ;
	%global DataFolder InputDataset Extension outfolder ;
	%let df = %sysfunc(translate(%sysfunc(dequote(&df)), "/", "\")) ;
	%let outf = %sysfunc(translate(%sysfunc(dequote(&outf)), "/", "\")) ;
	%let lastslash = %sysfunc(find(&df, /, -%length(&df))) ;
	%let InputDataset = %sysfunc(translate(%substr(&df, &lastslash+1), "_", " ")) ;
	%let DataFolder = %substr(&df, 1, &lastslash-1) ;

	libname out_here "&outf./" ;
	%if &syslibrc ~= 0 %then %do ;
		libname out_here "&DataFolder./" ;
		%if &syslibrc ~= 0 %then %do ;
			%put Could not find output folder: &outf nor &DataFolder. ;
			%ABORT CANCEL ;
		%end ;
		%else %do ;
			%let outfolder = %sysfunc(dequote(&DataFolder)) ;
		%end ;
	%end ;
	%else %do ;
		%let outfolder = %sysfunc(dequote(&outf)) ;
	%end ;
	libname out_here CLEAR ;

	%if %index(%upcase(&InputDataset), .SAS7BDAT) %then %do ;
		%if %sysfunc(fileexist(&df.)) %then %do ;
			%let InputDataset = %substr(&InputDataset, 1, %sysfunc(min(%index(%upcase(&InputDataset), .SAS7BDAT)-1, 30))) ;
			data &InputDataset ;
				set %quote("&DataFolder./&InputDataset.") ;
			run ;
			%let Extension = sas7bdat ;
			%return ;
		%end ;
	%end ;
	%else %if %sysfunc(fileexist(&DataFolder./&InputDataset..sas7bdat)) %then %do ;
		%let InputDataset = %substr(&InputDataset, 1, %sysfunc(min(%length(&InputDataset), 30))) ;
		data &InputDataset ;
			set %quote("&DataFolder./&InputDataset..sas7bdat") ;
		run ;
		%let Extension = sas7bdat ;
		%return ;
	%end ;
	%else %if %index(%upcase(&InputDataset), .SAV) %then %do ;
		%if %sysfunc(fileexist(&df.)) %then %do ;
			%let InputDataset = %substr(&InputDataset, 1, %sysfunc(min(%index(%upcase(&InputDataset), .SAV)-1, 30))) ;
			proc import out= &InputDataset
				datafile= "&df."
				dbms= SAV replace ;
			run ;
			%let Extension = sav ;
			%return ;
		%end ;
	%end ;
	%else %if %sysfunc(fileexist(&df..sav)) %then %do ;
		%let InputDataset = %substr(&InputDataset, 1, %sysfunc(min(%length(&InputDataset), 30))) ;
		proc import out= &InputDataset
			datafile= "&df..sav"
			dbms= SAV replace ;
		run ;
		%let Extension = sav ;
		%return ;
	%end ;

	%put "Could not locate &DataFolder./&InputDataset.." ;
	%ABORT CANCEL ;
%mend dsAssign ;

%dsAssign ;

* rename quota variable to PLAN (required for CAHPS macro), dropping any existing PLAN variable ;
data planlist (rename= (&QuotaVariable = PLAN)) ;
	set &InputDataset (keep= &QuotaVariable) ;
run ;

data &InputDataset (drop= i PLAN &QuotaVariable) ;
	set &InputDataset ;
run ;

data &InputDataset;
	set   &InputDataset ;
	merge planlist &InputDataset ;
run ;
proc datasets library = work
              nolist ;
			  delete  planlist ;
run ;


options dlcreatedir ;		*instructs SAS to create library directories and folders if they do not yet exist.
*--------------------------------------------------------------------------*
|  Library and Filename References                                         |
|     in       -  SAS data set to be used as input.                        |
|     out      -  Permanent SAS data sets created by Macro stored here.    |
|                   ** OUT is required by the CAHPS macro **               |
|     library  -  Location of the library for using permanent formats.     |
|                                                                          |
|     logfile  -  Path and filename for the SAS log file.                  |
|     outfile  -  Path and filename for storing SAS procedure output.      |
|	  launch   -  Path and filename to SAS file storing parameters the 	   |
|					user will typically not need to edit.				   |
|     cahps    -  Path and filename for the CAHPS macro.                   |
|     plan_dat -  Path and filename for the plan detail information.       |
*--------------------------------------------------------------------------*;
libname in        "&DataFolder./" ;
libname out       "&outfolder./sasdata/" ;
libname library   "&outfolder./sascatalog/" ;
libname outlog	  ("&outfolder./output/", "&outfolder./output/logs/", "&outfolder./data_other/") ;

filename _all_ clear ;
filename logfile   "&outfolder./output/logs/&InputDataset..log" ;
filename outfile   "&outfolder./output/&InputDataset..txt" ;
%let ProgramPath = K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS ;
filename cahps     "&programpath./Macro_cahps50 (modified).sas" ;

*--------------------------------------------------------------------------*
| Redirect output and logs to the file referenced by outfile and logfile.  |
*--------------------------------------------------------------------------*;

proc printto print = outfile new 
             log   = logfile new
             ;
run;

*--------------------------------------------------------------------------*
|   Clear all titles and footnotes                                         |
*--------------------------------------------------------------------------*;
title ;
footnote ;
run ;
*--------------------------------------------------------------------------*
|  Macro Name : nowbox                                                     |
|  Usage      : %nowbox (logtext = Your text here)                         |
|  Purpose    :                                                            |
|     Assign the local variable &now the current system date and time      |
|     and place a time stamp line into the current log.                    |
*--------------------------------------------------------------------------*;
%macro nowbox (logtext= ** Time Stamp **) ;
   %local now ;
   %let now = %sysfunc(date(),worddatx32.) at %sysfunc(time(),time9.) ;
   %put ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
   %put &logtext &now ;
   %put ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
%mend nowbox ;
%nowbox (logtext= Begin &Full_Path_And_File_Name version &Version ) ;
*--------------------------------------------------------------------------*
| Global Options Assigned Below                                            |
*--------------------------------------------------------------------------*;
options pagesize = 65
        linesize = 90
        pageno   = 1
        noovp
        nonumber
        nodate
        ;
        /* nomprint
        nomlogic */
run ;


%include cahps ;
