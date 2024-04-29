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
/* This macro merges a list of datasets, saves the merged dataset as *.sav and as *.csv, and closes all inputs.
** All input datasets must use the same key variable (quota, in the function call).
** The dataset name is the text in [square brackets] in the title bar of the dataset window (e.g., DataSet1).
** Copy the MergeSaveClose template function call template statement below to a new syntax file, then set your input parameters there.
** No edits are required to the macro DEFINE statement here.
** Be sure to include the INSERT FILE statement in your syntax file when running for the first time in an SPSS session. This defines the macro until SPSS is closed. */

**************************************************************************************************************************************************************************************************************************
*****/Copy this template to a new syntax file, then uncomment, enter your parameters, and run all.
* INSERT  FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\MergeSaveClose.sps"  .
COMMENT
/*!MergeSaveClose 
*    quota              =  
    /outdataname  =  
    /outdir             =  
    /datasetlist      =  
.
/*****End copy this block*****/
/**************************************************************************************************************************************************************************************************************************

******************************
*/*  Parameter definitions:
COMMENT
/*!MergeSaveClose 
*    quota              =      key variable with the same name and type in all datasets
    /outdataname  =      name for the output dataset and files
    /outdir             =      folder where output will be saved (optional)
    /datasetlist      =      dataset names, separated by spaces or newlines
.    ***Terminate command (macro call) with a period
** The solidus character ("/") before each variable after the first is required.
******************************.

*****************************
****Example macro call:
COMMENT
/*!MergeSaveClose 
*    quota=PHI_Plan_Name 
    /outdataname=SP18 
    /outdir= K:\TX-EQRO\Research\Member_Surveys\CY2018\STAR+PLUS\Output 
    /datasetlist= out_GCQ out_GNC out_HWDC 
.
*****************************


************************************************************************************************************************************.
*****  Please do not edit below this line without discussion.                                              ****************************.
*****  Create a new syntax file for your analysis and copy the macro call statement above.  ***************************.
************************************************************************************************************************************.
** Uncomment next line to enable verbose output for troubleshooting
SET MPRINT = OFF  .
DEFINE !MergeSaveClose(quota= !CHAREND("/") /outdataname= !DEFAULT("merged_dataset") !CHAREND("/") /OutDir= !CHAREND("/") /datasetlist= !CMDEND)
!LET !noOutDir = (!OutDir = !NULL)
DATASET ACTIVATE  !head(!datasetlist)  .
DATASET COPY  !outdataname  .
DATASET ACTIVATE !outdataname  .
!DO !ds !IN (!tail(!datasetlist))
STAR JOIN
    /SELECT *
    /FROM !outdataname AS t0
    /JOIN !ds AS t1
    ON !concat("t0.", !quota) = !concat("t1.", !quota)
    /OUTFILE FILE = *  .
!DOEND

!IF (!noOutDir=0) !then
SAVE OUTFILE= !quote(!concat(!UNQUOTE(!OutDir), "/" ,!outdataname, ".sav")) .
SAVE TRANSLATE OUTFILE= !quote(!concat(!UNQUOTE(!OutDir), "/", !outdataname, ".csv"))
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /FIELDNAMES
  /CELLS=VALUES
  /REPLACE  .
!IFEND

!DO !ds !IN (!datasetlist)
DATASET CLOSE !ds .
!DOEND
DATASET ACTIVATE !outdataname  .
!ENDDEFINE  .

output close  SuppressCodeRead  .  

