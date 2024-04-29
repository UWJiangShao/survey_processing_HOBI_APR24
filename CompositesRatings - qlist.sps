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
** This file is intended to be called by a quota permuter file -- this one calculates the aggregated results, that one determines the break groups and saves the output files.
**** If you need to call this function directly, copy the annotated parameters definition below and fill as needed.
/** In addition to the input parameters, this macro expects to find an open dataset !dsName to which some output will be appended.
/**** This dataset should make sense with: !concat( "ItemID @qcat ", !qlist, " Rate isLD resp_1 resp_2 resp_3 resp_4 resp_5 resp_6 resp_7 resp_8 resp_9 resp_10 resp_11" )  .
** No edits are required to the macro DEFINE statement here.
** Clean your dataset and assign missing values before running this macro.

******************************
*/*  Parameter definitions:
COMMENT
/* !PortalTables
*    qlist                     =    list of quota variables, separated by spaces or newlines
    /weightby               =    final weighting variable (default: unweighted)
    /LD                       =    smallest number of (unweighted) responses to be reported; used to set the isLD flag (1 indicates low denominator) in output
    /iiD                        =    item ID for OutputVariable (copied to output dataset)
    /OutputVariable      =    a name for the variable to be created; usual SPSS variable naming restrictions apply
    /topbox                  =    lowest numeric value to be counted (e.g., 4 for "Always" or 9 for 9+10); enter a negative number to instead return fractions up to topbox (e.g., -1 for 1=Yes/2=No)
    /minresp                =    lowest nominal value for this variable (default: 1)
    /maxresp               =    highest nominal value for this variable (default: topbox)
    /InputVariables       =    one or more variables to be composited or summarized; separate variable names with spaces or newlines
.    ***Terminate command (macro call) with a period .
** The solidus character ("/") before each parameter after the first is required (similar to SPSS native functions) .
****************************** .


************************************************************************************************************************************.
*****  Please do not edit below this line without discussion.                                              ****************************.
*****  Create a new syntax file for your analysis and copy the macro call statement above.  ***************************.
************************************************************************************************************************************.
** Uncomment next line to enable verbose output for troubleshooting .
** SET MPRINT = ON  .
DEFINE !PortalTables( qlist= !CHAREND("/") /weightby= !CHAREND("/") /LD= !DEFAULT(0) !CHAREND("/") 
                                /iiD= !CHAREND("/") /OutputVariable= !CHAREND("/") 
                                /topbox= !CHAREND("/") /minresp= !CHAREND("/") /maxresp= !CHAREND("/") 
                                /InputVariables= !CMDEND )
SET  leadzero=YES  .
preserve  .
SET  tvars=LABELS  .
SET  tnumbers=BOTH  .
DATASET COPY  CompRat_wrk window=hidden .
dataset activate CompRat_wrk .
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
!let !notopbox = ( !topbox = !NULL )
!if ( !notopbox = 0 ) !then
!LET !revcod = (!topbox <= 0)
!IF (!revcod = 1) !then
!let !mult = -1
!else
!let !mult = 1
!IFEND
!ifend
!let !nomin= ( !minresp = !NULL )
!if (!nomin = 1) !then
!let !usemin = 1
!else
!let !usemin = !minresp
!ifend
!let !nomax= ( !maxresp = !NULL )
!if (!nomax = 1) !then
!let !usemax = !topbox
!else
!let !usemax = !maxresp
!ifend
!let !qcatter = !head( !qlist )
!do !qv !in ( !tail( !qlist ) )
!let !qcatter = !concat( !qcatter, ", ", !qv )
!doend


***calculate topbox and by response option proportions and mark cases with at least one non-missing response .
*** lists to: carry over labeling information; hold reported rates; hold unweighted counts; hold Fraction In each response value .
!let !firstlist = ""
!let !ratevarlist = ""
!let !ratedichlist = ""
!let !cntlist = ""
DATASET ACTIVATE  CompRat_wrk  .
sort cases by !qcatter .
!DO !var !IN (!InputVariables)
IF (~MISSING(!var))  !concat(!OutputVariable, "_nonmissing")= 1 .
!let !firstlist = !concat( !firstlist, " ", !concat( !var, "_first" ) )
!let !ratevarlist = !concat( !ratevarlist, " ", !concat( !var, "_rate" ) )
!let !ratedichlist = !concat( !ratedichlist, " ", !concat( !var, "_dich" ) )
!let !cntlist = !concat( !cntlist, " ", !concat( !var, "_cnt" ) )
!if ( !notopbox = 1 ) !then
compute !concat( !var, "_dich" ) = $sysmis .
!else
compute #svar = ( !mult * !var ) + 0.5  .
recode  #svar (lo thru !topbox = 0) (missing = sysmis) (else=1) into !concat( !var, "_dich" )  .
!ifend
execute  .
!doend
!let !resplist = ""
!DO !thisresp = !usemin !TO !usemax
!let !resplist = !concat( !resplist, " /" )
!DO !var !IN ( !InputVariables )
!let !resplist = !concat( !resplist, " ", !concat( !var, "_resp_", !thisresp )  )
!DOEND
!let !resplist = !concat( !resplist, " = fin(", !InputVariables, ", ", !thisresp, ", ", !thisresp, ") " )
!DOEND

DATASET DECLARE  !concat( "out_", !OutputVariable )  WINDOW=HIDDEN  .
DATASET ACTIVATE  CompRat_wrk  .
AGGREGATE
    /OUTFILE=  !concat( "out_", !OutputVariable )
    /PRESORTED
    /BREAK  =  !qcatter
    /!ratevarlist = first( !InputVariables )
    /!firstlist = fgt( !ratedichlist, 0 )
    /!cntlist = nu.( !InputVariables )
!if ( !index(!qlist, !sampledBY) = 0 ) !then
    /!eval(!sampledBY) = first(!eval(!sampledBY))
!ifend
    !resplist
    /!concat(!OutputVariable, "_count") = nu.(!concat(!OutputVariable, "_nonmissing"))
.
DATASET ACTIVATE !concat( "out_", !OutputVariable ) .
string @qcat (a555) .
compute  @qcat = concat( !qcatter ) .
!do !var !in ( !InputVariables )
compute !concat( !var, "_rate" ) = !concat( !var, "_first" ) .
!doend
execute .
!do !var !in ( !InputVariables )
delete variables  !concat( !var, "_first" )  .
formats !concat(!var,"_resp_",!thisresp) (f7.1) .
!doend
execute .
VARIABLE LABELS  !concat(!OutputVariable, "_count")  !quote(!concat(!unquote(!OutputVariable), " count of records used (AHRQ)"))  .


***totals  .
!let !meanvarcalc = ""
!let !meandencalc = ""
!DO !var !IN (!InputVariables)
!let !meanvarcalc = !concat( !meanvarcalc, ", ", !concat(!var,"_rate") )
!let !meandencalc = !concat( !meandencalc, ", ", !concat(!var,"_cnt") )
!DOEND
!let !meanvarcalc = !substr( !meanvarcalc, 3 )
!let !meandencalc = !substr( !meandencalc, 3 )
compute !concat( !OutputVariable, "_rate" ) = mean( !meanvarcalc )  .
compute !concat( !OutputVariable, "_avgden" ) = mean( !meandencalc )  .
execute .
VARIABLE LABELS  !concat(!OutputVariable,"_avgden")  !quote(!concat(!unquote(!OutputVariable), " average of component denominators (NCQA)"))  .
FORMATS  !concat(!OutputVariable, "_count") !concat(!OutputVariable,"_avgden")  (f9.0)  .

!DO !thisresp = !usemin !TO !usemax
!IF ((!head(!InputVariables)) = (!InputVariables)) !THEN
rename variables ( !concat(!InputVariables,"_resp_",!thisresp) = !concat( !OutputVariable, "_resp_", !thisresp ) ) .
!ELSE
!let !meancalc = ""
!DO !var !IN (!InputVariables)
!let !meancalc = !concat( !meancalc, ", ", !concat(!var,"_resp_",!thisresp) )
!DOEND
!let !meancalc = !substr( !meancalc, 3 )
compute  !concat( !OutputVariable, "_resp_", !thisresp ) = mean( !meancalc )  .
execute .
!IFEND
variable labels !concat( !OutputVariable, "_resp_", !thisresp )  !quote( !concat( !OutputVariable, " response ", !thisresp ) ) .
!DOEND


*** add item ID; format rates as pseudo-pct; rm LD (default 0 if no value passed)  .
sort cases by @qcat .
compute ItemID = !iiD .
formats ItemID (f5.0) .
compute isLD = 1 .
execute .
variable labels isLD !quote( !concat( "low denominator criterion: less than ", !LDval ) ) .
value labels isLD 0 !quote( !concat("denominator is at least ", !LDval) ) 1 "low denominator, interpret with caution" .
formats isLD (f1.0) .
!IF ((!head(!InputVariables)) = (!InputVariables)) !THEN
!IF ( !InputVariables ~= !OutputVariable ) !THEN
delete variables !concat( !InputVariables, "_rate" ) .
!IFEND
!ELSE
!DO !var !IN ( !InputVariables )
compute !concat( !var, "_rate" ) = 100 * !concat( !var, "_rate" )  .
execute .
formats !concat( !var, "_rate" ) (f7.1) .
!DO !thisresp = !usemin !TO !usemax
compute !concat(!var,"_resp_",!thisresp) = 100 * !concat(!var,"_resp_",!thisresp) .
execute .
formats !concat(!var,"_resp_",!thisresp) (f7.1) .
!DOEND
!DOEND
!IFEND

IF (!concat( !OutputVariable,"_count" ) >= !LDval)  isLD = 0  .
compute !concat( !OutputVariable, "_rate" ) = 100 * !concat( !OutputVariable, "_rate" )  .
!DO !thisresp = !usemin !TO !usemax
compute !concat( !OutputVariable, "_resp_", !thisresp ) = 100 * !concat( !OutputVariable, "_resp_", !thisresp )  .
formats !concat( !OutputVariable, "_resp_", !thisresp ) (f7.1) .
!DOEND
formats !concat( !OutputVariable, "_rate" ) (f7.1)  .

!let !keeplist= !concat( "ItemID @qcat ", " ", !qlist, " ", !concat( !OutputVariable, "_rate" ), " isLD ", " ", !concat( !OutputVariable,"_count" ) )
!let !droplist= ""
!DO !thisresp = !usemin !TO !usemax
!let !keeplist= !concat( !keeplist, " ", !concat( !OutputVariable, "_resp_", !thisresp ) )
!DOEND
!DO !var !IN ( !InputVariables )
!let !droplist= !concat( !droplist, " ", !concat( !var,"_cnt" ) )
!DOEND
!IF ( !head(!InputVariables) = !InputVariables ) !THEN
**nothing .
!ELSE
!DO !var !IN ( !InputVariables )
!let !keeplist= !concat( !keeplist, " ", !concat( !var, "_rate" ) )
!DO !thisresp = !usemin !TO !usemax
!let !keeplist= !concat( !keeplist, " ", !concat(!var,"_resp_",!thisresp) )
!DOEND
!DOEND
!IFEND

!let !resplist = "resp_1 resp_2 resp_3 resp_4 resp_5 resp_6 resp_7 resp_8 resp_9 resp_10 resp_11"
!let !respiter = !resplist
!let !renamelist = !concat( !OutputVariable, "_rate", ", ", !concat( !OutputVariable, "_count") )
!let !rnewlist = "Rate, Denom"
!DO !thisresp = !usemin !TO !usemax
!let !renamelist = !concat( !renamelist, ", ", !concat( !OutputVariable, "_resp_", !thisresp ) )
!let !rnewlist     = !concat( !rnewlist, ", ", !head( !respiter ) )
!let !respiter     = !tail( !respiter )
!DOEND


*** merge with existing dsName; prune variable list
execute .
dataset activate !dsName .
compute  @qcat = concat( !qcatter ) .
execute .
sort cases by ItemID @qcat .
add files file= *
    /file= !concat( "out_", !OutputVariable )
    /rename ( !renamelist = !rnewlist )
    /keep = !concat( "@qcat ", !eval(!sampledBY), " ", !qlist, " ItemID Rate isLD Denom ", !resplist )  .
SORT CASES BY ItemID @qcat  .
execute .
variable labels resp_11 !quote( !concat( !eval( !InputVariables ), " -- ", !eval( !iiD ) ) ) .

DATASET ACTIVATE  !concat( "out_", !OutputVariable )  .
match files file= *
    /keep= !keeplist  .


**Cleanup  .
DATASET ACTIVATE  !concat( "out_", !OutputVariable )  .
DATASET CLOSE  CompRat_wrk  .
restore  .

!ENDDEFINE  .

output close  SuppressCodeRead  .  

