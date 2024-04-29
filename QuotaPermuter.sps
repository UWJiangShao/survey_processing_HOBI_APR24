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
** This is a helper file for calculating xtabs for permutations of three or four quotas .
/** Before calling this file, define !PortalTables (INSERT the file) and its arguments (as macros to be expanded in the calling file),
/**** as well as !OutDir (for saving a *.sav and a *.csv for this !OutputVariable). Additionally, the dataset ***!dsName*** should be open 
/**** and available. The macro operates on the active dataset, which must be named ***input_db*** .
** This file generates all combinations of quota values (up to four quota variables) for a single item or composite .
** SPSS may generate a warning for each combination of quotas that it is recoding string variables
**** of different lengths. This is fine. String width of all quota variables shoud be at least five (ALTER TYPE if not)
**** to accommodate "_ALL_" in the output for rows where that quota is not varied .
** This file comprises two macros: QuotaPermuter and QP_PT. The first calls the second, which calls the PortalTables macro (separate file).
**** Your analysis file should call the QuotaPermuter macro with a list of up to four break variables; sort precedence is determined by order
**** in the function call. The positional parameters are defined by position in the function call.


DEFINE !QuotaPermuter ( !POSITIONAL !TOKENS(1) 
                                      /!POSITIONAL !DEFAULT("") !TOKENS(1) 
                                      /!POSITIONAL !DEFAULT("") !TOKENS(1) 
                                      /!POSITIONAL !DEFAULT("") !TOKENS(1) 
                                      )

DATASET COPY  QP_wrk  window=hidden  .
DATASET ACTIVATE QP_wrk  .
!let !has4 = ( !4 ~= !NULL )

*** all==ALL (n=1) .
!QP_PT isFirst= 1 /thisDataset= QP_wrk /notqlist = !* .

*** 3==ALL (n=4) .
!if ( !has4 = 1 ) !then
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !2 !3 /qlist= !4 .
!ifend
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !2 !4 /qlist= !3 .
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !3 !4 /qlist= !2 .
!QP_PT thisDataset= QP_wrk  /notqlist= !2 !3 !4 /qlist= !1 .

*** 2==ALL (n=6) .
!if ( !has4 = 1 ) !then
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !2 /qlist= !3 !4 .
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !3 /qlist= !2 !4 .
!QP_PT thisDataset= QP_wrk  /notqlist= !1 !4 /qlist= !2 !3 .
!QP_PT thisDataset= QP_wrk  /notqlist= !2 !3 /qlist= !1 !4 .
!QP_PT thisDataset= QP_wrk  /notqlist= !2 !4 /qlist= !1 !3 .
!QP_PT thisDataset= QP_wrk  /notqlist= !3 !4 /qlist= !1 !2 .
!ifend

*** 1==ALL (n=4) .
!if ( !has4 = 1 ) !then
!QP_PT thisDataset= QP_wrk  /notqlist= !4 /qlist= !1 !2 !3 .
!ifend
!QP_PT thisDataset= QP_wrk  /notqlist= !3 /qlist= !1 !2 !4 .
!QP_PT thisDataset= QP_wrk  /notqlist= !2 /qlist= !1 !3 !4 .
!QP_PT thisDataset= QP_wrk  /notqlist= !1 /qlist= !2 !3 !4 .

*** none==ALL (n=1) .
!QP_PT thisDataset= QP_wrk /qlist = !* .


dataset activate input_db .
dataset close !concat( "all_", !OutputVariable )  .
dataset close QP_wrk .
execute .
!ENDDEFINE .


DEFINE !QP_PT ( isFirst= !CHAREND("/") /thisDataset= !CHAREND("/")  /notqlist= !CHAREND("/")  /qlist= !CMDEND )
**This macro gets called by QuotaPermuter. You should not need to call it directly.

*** determine target dataset .
!let !nods = ( !thisDataset = !NULL )
!if (!nods ~= 1) !then
DATASET ACTIVATE  !thisDataset  .
!ifend

DATASET COPY tmp_data window=hidden .
DATASET ACTIVATE tmp_data  .

*** recode quotas to be held constant this iteration (skip if none) .
!let !nonotq = ( !notqlist = !NULL )
!if ( !nonotq ~= 1 ) !then
!do !nq !in (!notqlist)
recode !nq (else="ALL") .
!doend
!ifend
execute .

*** apply post-stratification weights (if any) .
!let !noq = ( !qlist = !NULL )
!if ( !noq ~= 1 ) !then
!do !qt !in (!qlist)
compute !eval( !weightby ) = !concat( "stratw_", !qt ) * !eval( !weightby ) .
!doend
!ifend
execute .

*** create an output dataset .
!PortalTables
    qlist = !concat( !notqlist, " ", !qlist )
    /weightby  =  !eval( !weightby )
    /LD = !eval( !LD )
    /iid = !eval( !iiD )
    /OutputVariable  =  !eval( !OutputVariable )
    /topbox = !eval( !topbox )
    /minresp = !eval( !minresp )
    /maxresp = !eval( !maxresp )
    /InputVariables  =  !eval( !InputVariables )  
 .

*** merge with dataset created by previous invocation of this macro (if any) .
!let !doMerge = ( !isFirst = !NULL )
!if ( !doMerge = 1 ) !then
DATASET ACTIVATE  !concat( "all_", !OutputVariable )  .
MATCH FILES FILE= *
    /FILE= !concat( "out_", !OutputVariable )
    /BY  = @qcat  .
DATASET CLOSE !concat( "out_", !OutputVariable )  .
!else
DATASET ACTIVATE  !concat( "out_", !OutputVariable )  .
DATASET NAME  !concat( "all_", !OutputVariable )  .
!ifend
DATASET ACTIVATE  !concat( "all_", !OutputVariable )  .
DATASET CLOSE tmp_data  .
!ENDDEFINE .


output close  SuppressCodeRead  .  

