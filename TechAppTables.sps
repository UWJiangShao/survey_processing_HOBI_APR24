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
** The statement at the end of this file closes the created output window, removing the superfluous text that would otherwise clog the user's workspace.


********INSTRUCTIONS FOR USING THIS MACRO********
/* This macro operates on a copy of the active dataset. No edits are performed on the input file itself.
** Copy the TechAppTables template function call statement below to a new syntax file, then set your input parameters there.
** No edits are required to the macro DEFINE statement here.
* Clean your dataset and assign missing values before running this macro.
** All parameters except quota are optional, with the following effects:
**** /nest indicates nesting within quota; blank or omitted --> tabulation by quota with no further nesting
**** /weightby is the weighting variable (eg, CompWeight); blank or omitted --> weight is turned off and redundant counts column is suppressed
**** /filterby is the variable according to which to filter cases; blank or omitted --> all cases are used
**** /UnweightedCounts is no or false to excude unweighted counts column in each subtable (Counts, Unweighted Counts, N%, Valid N%)
**** /hidesmallcounts is the value below which to suppress the count column (e.g., <5); omit to include all counts
**** /ExcludeMissing is 1 or TRUE to suppress user missing rows
**** The parameters FrequencyVariables, MeanVariables, and MRSets can take any number of variables, including none.
****** Enter variables lists separated by spaces or newlines; do not use blank lines within the function call.
**** If OutDir or OutFile are not specified, generated tables are sent only to a new output window. File extension .xlsx may be omitted or included.
****** Enclose directory and filename in "quotation marks".
** Output order matches input order for variables: all FrequencyVariables, then all MeanVariables, then all MRSets; order within type is per the entered lists.
*** Use multiple function calls (with different output file names) if desired. Each function call will generate an output window and an output file (if specified).
** The FrequencyVariables list takes most of the survey items. These tables give number of responses (weighted and actual), percent of all responses, and percent of valid (not user missing) responses for each response option.
** The MeanVariables list takes continuous variables (e.g., age, height). These tables give mean, median, standard deviation, and unweighted counts.
** The MRSets list takes multiple-response sets already defined in the data file (Analyze->Custom Tables-> Multiple Response Sets). These tables give count (number of times
*** a response was chosen), unweighted count, % of responses (count / total number of responses), and % of respondents (count / number of participants responding to any item in the multiple-response set).
** Output tables are created in the Excel file specified by OutDir (Output Directory) and OutFile. If the specified file already exists, it will be overwritten.
*** No additional settings need to be specified - the output file will include only the formatted tables.
** Be sure to include the INSERT FILE statement in your syntax file when running for the first time in an SPSS session. This defines the macro until SPSS is closed. */


**************************************************************************************************************************************************************************************************************************
*****/Copy this template to a new syntax file, then uncomment, enter your parameters, and run all.
* INSERT  FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\TechAppTables.sps"  .
COMMENT
/*!TechAppTables
*    quota          =  
    /nest            =  
    /weightby     =  
    /filterby        = 
    /UnweightedCounts     =
    /HideSmallCounts         =
    /ExcludeMissing         =
    /FrequencyVariables    =  
    /MeanVariables           =  
    /MRSets        =  
    /OutDir          =  ""
    /OutFile        =  ""
.
/*****End copy this block*****/
/**************************************************************************************************************************************************************************************************************************

******************************
*/*  Parameter definitions:
COMMENT
/*!TechAppTables 
*    quota          =  generate tables by plan, plan code, &c
    /nest            =  nested variable; tables are generated by quota, then subdivided by nest within quota
    /weightby     =  final weighting variable; leave blank to generate UNweighted tables
    /filterby        =  filter variable (cases where filterby=0, user missing, or sysmis are not used)
    /UnweightedCounts      =  enter no or false (case insensitive) to exclude unweighted counts in each subtable
    /HideSmallCounts         =  cells with count smaller than this value will appear as e.g., <5 instead
    /ExcludeMissing          = if 1 or TRUE, user missing values will not appear in the output
    /FrequencyVariables    =  fvar1 fvar2 fvar3 fvar4        *tables of count, %all, and %valid will be generated for fvar1 through fvar4
    /MeanVariables           =  mvar1 mvar2 mvar3    *tables of mean, median, and standard deviation will be generated for mvar1 through mvar3
    /MRSets        =   already-defined multiple response sets (MRSETS)
    /OutDir         =    "full path" to folder for saving output; leave blank to send output to viewer only
    /OutFile        =    "filename" for output tables; leave blank to send output only to viewer; if this file already exists, it will be overwritten
.    ***Terminate command (macro call) with a period
** The solidus character ("/") separates the parameters in the function call: each parameter (except the final) is defined as taking input up to the next "/"
******************************.



************************************************************************************************************************************.
*****  Please do not edit below this line without discussion.                                               ***************************.
*****  Create a new syntax file for your analysis and copy the macro call statement above.  ***************************.
************************************************************************************************************************************.
** Uncomment next line to enable verbose output for troubleshooting.
 * SET MPRINT = ON  .
DEFINE !TechAppTables(quota= !CHAREND("/")  /nest= !CHAREND("/")  
                                    /weightby= !CHAREND("/")  /filterby= !CHAREND("/")  /UnweightedCounts= !CHAREND("/") /HideSmallCounts= !CHAREND("/") 
                                    /ExcludeMissing= !CHAREND("/") /FrequencyVariables= !CHAREND("/")  /MeanVariables= !CHAREND("/")  /MRSets= !CHAREND("/")  
                                    /OutDir= !CHAREND("/")  /OutFile= !CMDEND)
preserve  .
SET  leadzero=YES  .
SET  tvars=LABELS  .
SET  tnumbers=BOTH  .
DATASET NAME  input_db  .
DATASET COPY  techapp_wrk  .
DATASET ACTIVATE  techapp_wrk  .
OUTPUT NEW NAME = TablesMacroViewerOutput  .
OUTPUT ACTIVATE TablesMacroViewerOutput .
!LET !OutToFile  =  ( !OutDir ~= !NULL  !AND  !OutFile ~= !NULL )
!IF ( !OutToFile = 1 ) !then
!let !cln_file_name = !concat(!unquote(!OutFile), ".xlsx")
!if ( !index(!cln_file_name, ".xlsx.xlsx") ~= 0 ) !then
!let !cln_file_name = !unquote(!OutFile)
!ifend
OMS 
    /SELECT TABLES
    /IF COMMANDS = ["CTABLES"  "CROSSTABS" ]
    /EXCEPTIF  SUBTYPES = ["Notes"  "Case Processing Summary"]
    /DESTINATION VIEWER = YES  FORMAT = XLSX  OUTFILE = !quote( !concat( !unquote(!OutDir), "\", !cln_file_name ) )
    /TAG  =  "outTables"   .
!IFEND

OMS 
    /SELECT ALL
    /EXCEPTIF COMMANDS = [ "CTABLES" ]  SUBTYPES = [ "Custom Table" ]
    /DESTINATION VIEWER = NO
    /TAG  =  "noOut"   .


!LET !do_wt = (!weightby ~= !NULL)
!IF (!do_wt=1) !then
WEIGHT BY !weightby  .
!ELSE
WEIGHT OFF  .
!IFEND
!LET !do_nest = (!nest ~= !NULL)
!IF (!do_nest=1) !then
!let !quota_label = !concat(!quota," ",!nest)
!let !quota_by = !concat(!quota," > ",!nest)
!ELSE
!let !quota_label = !quota
!let !quota_by = !quota
!IFEND
!LET !do_filter = (!filterby ~= !NULL)
!IF (!do_filter=1) !then
FILTER BY !filterby  .
!ELSE
USE ALL  .
!IFEND
!LET !exclude_missing = (!excludemissing ~= !NULL)
!IF (!exclude_missing=1) !then
!IF (!excludemissing = 1 !OR !UPCASE(!excludemissing) = "TRUE") !then
!LET !includemissing = ""
!ELSE
!LET !includemissing = ", MISSING"
!IFEND
!ELSE
!LET !includemissing = ", MISSING"
!IFEND
!IF ( !UPCASE(!UNQUOTE(!UnweightedCounts))= "NO"  !OR  !UPCASE(!UNQUOTE(!UnweightedCounts))= "FALSE" !OR !do_wt ~= 1 ) !THEN
!LET !freqfunc= "[COUNT COMMA9.0, COLPCT.COUNT 'N%' PCT4.1, COLPCT.VALIDN 'Valid N%' PCT4.1]"
!LET !mnfunc= "[MEAN, MEDIAN, STDDEV]"
!LET !mrfunc=  "[COUNT COMMA9.0, COLPCT.VALIDN 'Respondents N%' PCT4.1, COLPCT.RESPONSES 'Responses N%' PCT4.1]"
!ELSE
!LET !freqfunc= "[COUNT COMMA9.0, UCOUNT COMMA9.0, COLPCT.COUNT 'N%' PCT4.1, COLPCT.VALIDN 'Valid N%' PCT4.1]"
!LET !mnfunc= "[MEAN, MEDIAN, STDDEV, UVALIDN 'Unweighted Count']"
!LET !mrfunc=  "[COUNT COMMA9.0, UCOUNT COMMA9.0, COLPCT.VALIDN 'Respondents N%' PCT4.1, COLPCT.RESPONSES 'Responses N%' PCT4.1]"
!IFEND

!LET !do_hideLD = (!hidesmallcounts ~= !NULL)
!if (!do_hideLD) !then
!LET !hideLD = !concat("/HIDESMALLCOUNTS COUNT= ", !hidesmallcounts)
!else
!LET !hideLD = ""
!IFEND

!DO !fv !IN (!FrequencyVariables)
CTABLES
  /VLABLES VARIABLES = !fv  display=both
  /VLABLES VARIABLES = !quota_label  display=label   !hideLD
  /TABLE !fv BY !quota_by !freqfunc
  /CATEGORIES VARIABLES = !quota TOTAL=YES POSITION=BEFORE  EMPTY=INCLUDE
 	/CATEGORIES VARIABLES = !fv [OTHERNM !includemissing]  TOTAL=YES  POSITION=AFTER  EMPTY=INCLUDE  .
!DOEND  


!DO !mv !IN(!MeanVariables)
CTABLES
  /VLABLES VARIABLES = !mv  display=both
  /VLABLES VARIABLES = !quota_label  display=label   !hideLD
  /TABLE !mv !mnfunc BY !quota_by
  /CATEGORIES VARIABLES = !quota TOTAL=YES POSITION=BEFORE  EMPTY=INCLUDE  .
!DOEND


!DO !mst !IN(!MRSets)
CTABLES
    /VLABELS VARIABLES= !mst display=both
    /VLABELS VARIABLES= !quota_label display=label   !hideLD
    /TABLE !mst !mrfunc  BY !quota_by
    /CATEGORIES VARIABLES = !quota  TOTAL=YES POSITION=BEFORE EMPTY=INCLUDE
    /CATEGORIES VARIABLES= !mst TOTAL=YES  POSITION=AFTER  EMPTY=INCLUDE  .
!DOEND


DATASET ACTIVATE  input_db  .
DATASET CLOSE  techapp_wrk  .

!if (!OutToFile = 1) !then
OUTPUT NEW  NAME = Processing_Please_Wait  .
OUTPUT ACTIVATE Processing_Please_Wait .
OUTPUT ACTIVATE TablesMacroViewerOutput .
OMSEND  TAG = [  "outTables"  ]  .
OMSEND  TAG = [  "noOut"  ]  .
OUTPUT CLOSE  NAME = Processing_Please_Wait  .
OUTPUT ACTIVATE  TablesMacroViewerOutput  .
!else
OMSEND  TAG = [  "noOut"  ]  .
OUTPUT ACTIVATE  TablesMacroViewerOutput  .
!ifend
restore  .
!ENDDEFINE  .


output close  SuppressCodeRead  .

