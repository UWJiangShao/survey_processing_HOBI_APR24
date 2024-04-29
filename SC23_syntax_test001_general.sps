* Encoding: UTF-8.
** Syntax semi-automatically generated at 2021-09-22 08:51:09 using <V:\TEXAS\TexasReports\Contract_Deliverables\Member_Surveys\Survey Tools\Syntax\Excel macros\Surveys (member+caregiver)\thlc syntax generator.xlsm>.
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\CompositesRatings - qlist.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\QuotaPermuter.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\MergeSaveClose.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\StratWeighter.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\updaters (dashboards to portal).sps" .
GET FILE = "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\STARChild_2023\STAR Child ARC_Biennial 2023_Completes Final.sav" .
dataset name data_file WINDOW= FRONT.

DEFINE  !qlist()  PHI_Plan_Name  PHI_SA_Name  Sex  Race  !ENDDEFINE .
DEFINE  !SYear()  2023  !ENDDEFINE .
DEFINE  !surveyPopulation()  "STARChild_gnr"  !ENDDEFINE .
DEFINE  !weightby()  1  !ENDDEFINE .
DEFINE  !sampledBy()  PHI_Plan_Code  !ENDDEFINE .
DEFINE  !LD() 30 !ENDDEFINE .
DEFINE  !OutDir()  "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\STARChild_2023\SC_output_thlc"  !ENDDEFINE .

alter type Race (f1.0) .
alter type PHI_Plan_Name (a44) PHI_SA_Name (a14) Sex Race (a3) .
compute Race = LTRIM(Race) .
execute .

** create post-stratification weights .
DATASET ACTIVATE data_file .
SORT CASES BY Survey_ID .
GET DATA 
    /type = xlsx
    /file= "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\STARChild_2023\STAR_Child_23_2303.xlsx"
    /sheet= index 1
    /cellrange= range "A1:Z97185" .
DATASET NAME sample_file WINDOW= FRONT.
SORT CASES BY Survey_ID .
MATCH FILES FILE= *
   /FILE= sample_file
   /KEEP= Survey_ID Sex Race PHI_Plan_Code PHI_Plan_Name PHI_SA_Name .
rename variables ( Race = Race_str ) .
recode Race_str
( "White, Non-Hispanic" = 1 )
( "Black, Non-Hispanic" = 2 )
( "Hispanic" = 3 )
( "American Indian or Alaskan" = 4 )
( "Asian, Pacific Islander" = 5 )
( "Unknown / Other" = 6 )
into Race .
execute .
variable labels Race "Race (numeric)" .
alter type Race (f1.0) .
ALTER TYPE PHI_Plan_Name (a44) PHI_SA_Name (a14) Sex Race (a3) .
MATCH FILES FILE= *
   /FILE= data_file
   /BY Survey_ID .
DATASET CLOSE data_file .
DATASET ACTIVATE sample_file .
DATASET NAME input_db .
COMPUTE Race = LTRIM(Race) .

EXECUTE .


*** create blank dataset for merging output .
DEFINE !dsName() !concat( !unquote(!eval(!surveyPopulation)), "_", !eval(!SYear) ) !ENDDEFINE .
DATA LIST /@qcat (a555)
                 PHI_Plan_Name (a44) PHI_SA_Name (a14) Sex (a3) Race (a3) ItemID (f5.0) 
                 Rate (f6.1) isLD (f1.0) Denom (f5.0) resp_1 resp_2 resp_3 resp_4 resp_5 resp_6 resp_7 resp_8 resp_9 resp_10 resp_11 (11f6.1) .
BEGIN DATA
END DATA .
DATASET NAME  !dsName  .


*** begin calculation blocks .
dataset activate input_db .
DEFINE !iiD() 50317 !ENDDEFINE .
DEFINE !OutputVariable() AtC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 cahps6 cahps10 cahps41 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50001 !ENDDEFINE .
DEFINE !OutputVariable() GCQ !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 cahps6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50003 !ENDDEFINE .
DEFINE !OutputVariable() GNC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps10 cahps41 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50004 !ENDDEFINE .
DEFINE !OutputVariable() HWDC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps27 cahps28 cahps29 cahps31 cahps32 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50002 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps9 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50006 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps36 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps36 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50007 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps43 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps43 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50010 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps49 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps49 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50005 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps35 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps35 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50008 !ENDDEFINE .
DEFINE !OutputVariable() Custserv !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps45 cahps46 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50009 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps48 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps48 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50523 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps4 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50524 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps6 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50507 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps10 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps10 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50522 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps41 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps41 !ENDDEFINE .
!QuotaPermuter !qlist .


dataset activate input_db .
DEFINE !iiD() 50546 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps8 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps8 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50547 !ENDDEFINE .
DEFINE !OutputVariable() CoC_CCC !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps13 cahps24 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50548 !ENDDEFINE .
DEFINE !OutputVariable() GSS !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps15 cahps18 cahps21 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50549 !ENDDEFINE .
DEFINE !OutputVariable() FCCPD !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps33 cahps38 cahps39 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50550 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps51 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps51 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50551 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps16 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps16 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50552 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps19 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps19 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50553 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps22 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps22 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50554 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps52 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahps52 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50561 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps18 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps18 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50562 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps21 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps21 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50569 !ENDDEFINE .
DEFINE !OutputVariable() out_TRTADLT !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() TRTADLT !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50020 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS3 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS3 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50021 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS4 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50022 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS5 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS5 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50023 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS6 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50024 !ENDDEFINE .
DEFINE !OutputVariable() out_AR1 !ENDDEFINE .
DEFINE !topbox() -5 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 9 !ENDDEFINE .
DEFINE !InputVariables() AR1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50025 !ENDDEFINE .
DEFINE !OutputVariable() out_AR2 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() AR2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50026 !ENDDEFINE .
DEFINE !OutputVariable() out_UT1 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() UT1 !ENDDEFINE .
!QuotaPermuter !qlist .


dataset activate input_db .
DEFINE !iiD() 50028 !ENDDEFINE .
DEFINE !OutputVariable() out_ICHP2 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() ICHP2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50029 !ENDDEFINE .
DEFINE !OutputVariable() out_ICHP3 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() ICHP3 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50030 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS7 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS7 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50032 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS8 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS8 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50037 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS9 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50038 !ENDDEFINE .
DEFINE !OutputVariable() out_AH1 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() AH1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50039 !ENDDEFINE .
DEFINE !OutputVariable() out_AH2 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() AH2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50040 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS10 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS10 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50041 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS11 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS11 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50042 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS12 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS12 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50555 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS13 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS13 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50044 !ENDDEFINE .
DEFINE !OutputVariable() out_FREW1 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() FREW1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50045 !ENDDEFINE .
DEFINE !OutputVariable() out_FREW4 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() FREW4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50048 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS14 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS14 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50556 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS15 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS15 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50050 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS16 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS16 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50051 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS17 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS17 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50052 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS18 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS18 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50053 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS19 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS19 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50054 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS20 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50055 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS21 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS21 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50056 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS22 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS22 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50057 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS23 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS23 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50557 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS24 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS24 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50059 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS25 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS25 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50060 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS26 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS26 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50061 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS27 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS27 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50062 !ENDDEFINE .
DEFINE !OutputVariable() out_C1 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() C1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50063 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS28 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS28 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50064 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS29 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS29 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50065 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS30 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS30 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50066 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS31 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS31 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50067 !ENDDEFINE .
DEFINE !OutputVariable() out_C2 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() C2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50068 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS32 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS32 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50558 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS33 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS33 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50070 !ENDDEFINE .
DEFINE !OutputVariable() out_CU14 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CU14 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50071 !ENDDEFINE .
DEFINE !OutputVariable() out_CU15 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CU15 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50072 !ENDDEFINE .
DEFINE !OutputVariable() out_CU23 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CU23 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50073 !ENDDEFINE .
DEFINE !OutputVariable() out_CU24 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CU24 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50074 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS34 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS34 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50075 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS35 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS35 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50076 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS36 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS36 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50077 !ENDDEFINE .
DEFINE !OutputVariable() out_PD1 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() PD1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50078 !ENDDEFINE .
DEFINE !OutputVariable() out_PD2 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() PD2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50079 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS37 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS37 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50559 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS38 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS38 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50560 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS39 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS39 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50082 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS40 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS40 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50083 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS41 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS41 !ENDDEFINE .
!QuotaPermuter !qlist .


dataset activate input_db .
DEFINE !iiD() 50091 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS42 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS42 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50092 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS43 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS43 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50093 !ENDDEFINE .
DEFINE !OutputVariable() out_ICHP4 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() ICHP4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50534 !ENDDEFINE .
DEFINE !OutputVariable() out_ICHP9 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() ICHP9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50095 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS44 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS44 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50096 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS45 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS45 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50097 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS46 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS46 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50098 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS47 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS47 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50099 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS48 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS48 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50100 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS49 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS49 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50104 !ENDDEFINE .
DEFINE !OutputVariable() out_T1 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() T1 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50105 !ENDDEFINE .
DEFINE !OutputVariable() out_T2 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() T2 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50106 !ENDDEFINE .
DEFINE !OutputVariable() out_T3 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() T3 !ENDDEFINE .
!QuotaPermuter !qlist .


dataset activate input_db .
DEFINE !iiD() 50108 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS50 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS50 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50109 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS51 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS51 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50110 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS52 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS52 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50111 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS53 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() CAHPS53 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50112 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS54 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() CAHPS54 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50113 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS55 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS55 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50114 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS56 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS56 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50115 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS57 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS57 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50116 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS58 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS58 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50117 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS59 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS59 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50118 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS60 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS60 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50119 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS61 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS61 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50120 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS62 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS62 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50121 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS63 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS63 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50122 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS64 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS64 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50123 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS65 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS65 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50124 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS66 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS66 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50125 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS67 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS67 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50126 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS68 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS68 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50127 !ENDDEFINE .
DEFINE !OutputVariable() out_TRTCHLD !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() TRTCHLD !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50128 !ENDDEFINE .
DEFINE !OutputVariable() out_TRTADLT !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() TRTADLT !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50131 !ENDDEFINE .
DEFINE !OutputVariable() out_chngage !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() chngage !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50500 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS75 !ENDDEFINE .
DEFINE !topbox() 3 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS75 !ENDDEFINE .
!QuotaPermuter !qlist .


*** cleanup and save/export .
dataset activate !dsName .
compute SYear = !SYear .
formats SYear (F5.0) .
string surveyPopulation (a33) .
compute surveyPopulation = !surveyPopulation .
sort cases by ItemID @qcat .
execute .

** dashboards .

DEFINE !ResponseOptionLabeler()
variable labels Rate "reported rate" .
variable labels Denom "denominator" .
!DO !rval= 1 !to 11
variable labels !concat( "resp_", !rval )  !quote( !concat( "response option ", !rval ) ) .
value labels !concat( "resp_", !rval ) .
missing values !concat( "resp_", !rval ) () .
!doend
!ENDDEFINE .
!ResponseOptionLabeler .

!MergeSaveClose
   quota = ItemID
    /outdataname= !dsName
    /OutDir= !OutDir
    /datasetlist= outdata
.
