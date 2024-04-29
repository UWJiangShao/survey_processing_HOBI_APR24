* Encoding: UTF-8.
*************************************************************************************
*****DO NOT run this file directly************************************************
*****Copy the indicated code block to a new syntax file, then run that.*****
*************************************************************************************
*************************************************************************************.
output new  name=SuppressCodeRead  .
** This line creates a new output window when this file is read by an INSERT statement.
** Reading this file to define the macro generates a large amount of typically irrelevant output text.
** Existing output windows are not modified.
** The close statement at the end of this file closes the created output window, removing the text that would otherwise clog the user's workspace.


********INSTRUCTIONS FOR USING THIS MACRO********
/* This macro operates on a copy of the active dataset. No edits are performed on the input file itself.
** Copy the CompRatCalc (Composites and Ratings Calculator) template function call statement below to a new syntax file, then set your input parameters there.
** No edits are required to the macro DEFINE statement here.
* Clean your dataset and assign missing values before running this macro.
* The parameter InputVariables can take any number of input variables, separated by spaces or newlines. These variables will be composited (equally weighted) to create
** the output variable. Output values are formatted as a fraction with three decimals. Measure denominator is calculated as the average of the denominators of the comprising measures; non-integer values are permitted.
* The weightby and LD (Low Denominator) parameters optional.
* The output label parameter is optional but recommended. This is the label to assign to the calculated variable.
* The topbox parameter is the lowest numeric value to be counted: 4 for never-to-always variables, 1 for no=0/yes=1 variables, 9 for 1-10 rating variables.
** Use a negative number to instead treat topbox as the highest value to be counted:  -1 for 1=Yes/2=No variables,  -3 for "not-Always" variables.
** Be sure to include the INSERT FILE statement in your syntax file when running for the first time in an SPSS session. This defines the macro until SPSS is closed. */


**************************************************************************************************************************************************************************************************************************
*****/Copy this template to a new syntax file, then uncomment, enter your parameters, and run all.
* INSERT  FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\CompositesRatings.sps"  .
* OUTPUT NEW  CompositesAndRatings  .
COMMENT
/*!CompRatCalc
*    quota                =  
    /weightby            =  
    /LD                    =  
    /OutputVariable   =  
    /OutputLabel       =  
    /topbox              =  
    /InputVariables    =  
.
/*****End copy this block*****/
/**************************************************************************************************************************************************************************************************************************

*****************************
****Example macro calls:
/** !CompRatCalc  quota=plancode  /weightby=finalweight  /OutputVariable=HWDC  /OutputLabel="How Well Doctors Communicate"  /topbox=4  /InputVariables = cahps32 cahps33 cahps34 cahps36 cahps37  .
/** !CompRatCalc  quota=PHI_Plan_Code  /OutputVariable=HPrat  /OutputLabel="Health Plan Rating 9-10"  /topbox=9  /InputVariables = cahps41  .
/** !CompRatCalc  quota=quotnumb  /weightby=CompWeight  /OutputVariable=FCC_PD  /OutputLabel="Family-Centered Care--Personal Doctor Who Knows Child"  /topbox= -1  /InputVariables = cahps38 cahps43 cahps44  .
******************************

******************************
*/*  Parameter definitions:
COMMENT
/*!CompRatCalc
*    quota                =     calculate composite or rating by plan, plan code, &c; must be a numeric variable
    /weightby            =     final weighting variable (optional); unweighted counts of responses are always included in the output
    /LD                     =    smallest number of (unweighted) responses to be reported; quotas with fewer than LD responses set to missing
    /OutputVariable   =     name for variable to be created; if variable name already exists, it will be overwritten
    /OutputLabel       =     label for variable to be created
    /topbox               =     lowest numeric value to be counted (e.g., 4 for "Always" or 9 for 9+10); enter a negative number to instead return fractions up to topbox (e.g., -3 yields "not-Always" percentages)
    /InputVariables    =     one or more variables to be composited or summarized; separate variable names with spaces or newlines
.    ***Terminate command (macro call) with a period
** The solidus character ("/") before each variable after the first is required.
******************************.



************************************************************************************************************************************.
*****  Please do not edit below this line without discussion.                                              ****************************.
*****  Create a new syntax file for your analysis and copy the macro call statement above.  ***************************.
************************************************************************************************************************************.
** Uncomment next line to enable verbose output for troubleshooting.
 * SET MPRINT = ON  .
DEFINE !CompRatCalc(quota= !CHAREND("/") /weightby= !CHAREND("/") /LD= !DEFAULT(0) !CHAREND("/") /OutputVariable= !CHAREND("/") /OutputLabel= !DEFAULT("") !CHAREND("/") /topbox= !CHAREND("/") /InputVariables= !CMDEND)  .
SET  leadzero=YES  .
preserve  .
SET  tvars=LABELS  .
SET  tnumbers=BOTH  .
DATASET NAME  input_db  .
DATASET COPY  CompRat_wrk window=hidden  .
DATASET ACTIVATE  CompRat_wrk  .
compute nobreak = 1 .
execute .
!LET !wt = (!weightby = !NULL)
!IF (!wt=1) !then
WEIGHT OFF  .
!ELSE
WEIGHT BY !weightby  .
!IFEND
!LET !no_ld = (!LD = !NULL)
!if (!no_ld = 1) !then
!let !LDval = 0
!ELSE
!let !LDval = !LD
!IFEND
!LET !revcod = (!topbox < 0)
!if  (!revcod = 1) !then
!let !mult = -1
!else
!let !mult = 1
!IFEND


***calculate topbox proportions and mark cases with at least one non-missing response.
DATASET ACTIVATE  CompRat_wrk  .
!DO !var !IN (!InputVariables)
IF (~MISSING(!var))  !concat(!OutputVariable, "_nonmissing")= 1 .
!DOEND
!DO !var !IN (!InputVariables)
DATASET ACTIVATE  CompRat_wrk  .
compute !var = !mult * !var  .
compute  varplus = !var + 0.5  .
recode  varplus   (lo thru !topbox  =  0) (missing = sysmis) (else=copy)  into vardich  .
compute  vardich = !mult * vardich  .
execute  .

DATASET DECLARE !concat(!var,"_agg")  WINDOW=HIDDEN  .
DATASET ACTIVATE  CompRat_wrk  .
AGGREGATE
    /OUTFILE=  !concat(!var,"_agg")
    /BREAK  =  !unquote( !quota )
    /!concat(!var,"_fgt")  =  first(!var)
    /fgtval = fgt(vardich, 0)
    /!concat(!var,"_cnt") = first(!var)
    /nuvar = nu.(!var)  .
DATASET ACTIVATE !concat(!var,"_agg") .
compute !concat(!var,"_fgt")  =  fgtval .
compute !concat(!var,"_cnt") = nuvar .
execute .
delete variables fgtval nuvar .

DATASET DECLARE !concat(!var,"_TX")  WINDOW=HIDDEN  .
DATASET ACTIVATE  CompRat_wrk  .
AGGREGATE
    /OUTFILE=  !concat(!var,"_TX")
    /BREAK  =   nobreak
    /!concat(!var,"_fgt")  =  fgt(vardich, 0)
    /!concat(!var,"_cnt") = nu.(!var)  .
DATASET ACTIVATE  !concat(!var,"_agg")  .
ADD FILES  /FILE= *
    /FILE= !concat(!var,"_TX") .
execute .
delete variables  nobreak  .
DATASET CLOSE  !concat(!var,"_TX")  .
DATASET ACTIVATE  !concat(!var,"_agg")  .
SORT CASES BY !quota  .
execute  .
!DOEND

***count cases with at least one non-missing response.
DATASET DECLARE  output_counts  WINDOW=HIDDEN  .
DATASET ACTIVATE  CompRat_wrk  .
AGGREGATE
    /OUTFILE=  output_counts
    /BREAK= !quota
    /!concat(!OutputVariable, "_count") = nu.(!concat(!OutputVariable, "_nonmissing"))  .
DATASET DECLARE  output_TX_counts  WINDOW=HIDDEN  .
DATASET ACTIVATE  CompRat_wrk  .
AGGREGATE
    /OUTFILE=  output_TX_counts
    /BREAK=      nobreak
    /!concat(!OutputVariable, "_count") = nu.(!concat(!OutputVariable, "_nonmissing"))  .
DATASET ACTIVATE  output_counts  .
ADD FILES  /FILE=  *
    /FILE= output_TX_counts  .
execute  .
delete variables  nobreak  .
DATASET CLOSE  output_TX_counts  .
DATASET ACTIVATE  output_counts  .
SORT CASES BY !quota  .
execute  .

***create dataset for merging  .
DATASET ACTIVATE  !concat(!head(!InputVariables),"_agg")  .
DATASET COPY  !concat("out_",!OutputVariable)  WINDOW=front  .
DATASET ACTIVATE  !concat("out_",!OutputVariable)  .
compute  numvar=0  . 
compute  CompCalc_sumcomponents=0  .
compute  CompCalc_dencomponents =0  .
execute .

***merge individual aggregated datasets sequentially  .
!DO !var !IN (!InputVariables)
DATASET ACTIVATE  !concat("out_",!OutputVariable)  .
MATCH FILES  FILE= *
    /FILE= !concat(!var,"_agg")
    /BY !quota  .
compute  numvar = numvar + 1  .
compute  CompCalc_sumcomponents = CompCalc_sumcomponents + !concat(!var,"_fgt")  .
compute  CompCalc_dencomponents  = CompCalc_dencomponents  + !concat(!var,"_cnt")  .
execute  .
DATASET CLOSE  !concat(!var,"_agg")  .
!DOEND
execute  .

***totals  .
DATASET ACTIVATE  !concat("out_",!OutputVariable)  .
compute  !OutputVariable = CompCalc_sumcomponents / numvar  .
compute  !concat(!OutputVariable,"_avgden") = CompCalc_dencomponents / numvar  .
recode     !OutputVariable  (0=SYSMIS)  .
VARIABLE LABELS  !OutputVariable  !OutputLabel  .
FORMATS  !OutputVariable (f9.3)  .
execute  .
DATASET ACTIVATE  !concat("out_",!OutputVariable)  .
MATCH FILES  FILE= *
    /FILE= output_counts
    /BY= !quota  .
DATASET ACTIVATE  !concat("out_",!OutputVariable)  .
VARIABLE LABELS  !concat(!OutputVariable, "_count")  !quote(!concat(!unquote(!OutputLabel), " count of records used (AHRQ)"))  .
VARIABLE LABELS  !concat(!OutputVariable,"_avgden")  !quote(!concat(!unquote(!OutputLabel), " average of component denominators (NCQA)"))  .
FORMATS  !concat(!OutputVariable, "_count") !concat(!OutputVariable,"_avgden")  (f9.0)  .
DATASET CLOSE output_counts  .

***rm LD (default 0 if no value passed)  .
if (!concat(!OutputVariable,"_count") < !LDval)  !OutputVariable = $sysmis  .
execute  .

**Cleanup  .
DELETE VARIABLES  numvar  CompCalc_sumcomponents  CompCalc_dencomponents  .
!IF ((!head(!InputVariables)) = (!InputVariables)) !THEN
DELETE VARIABLES !concat(!InputVariables,"_fgt")  !concat(!InputVariables,"_cnt")  !concat(!OutputVariable,"_avgden")  .
!IFEND
DATASET ACTIVATE  input_db  .
DATASET CLOSE  CompRat_wrk  .
restore  .

!ENDDEFINE  .

output close  SuppressCodeRead  .  



