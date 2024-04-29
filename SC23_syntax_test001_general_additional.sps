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
DEFINE  !OutDir()  "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\star_child\STARChild_2023\SC_output_thlc\additional_gnr\"  !ENDDEFINE .

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
DEFINE !iiD() 50563 !ENDDEFINE .
DEFINE !OutputVariable() out_needmeds !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() needmeds !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50564 !ENDDEFINE .
DEFINE !OutputVariable() out_needserv !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() needserv !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50565 !ENDDEFINE .
DEFINE !OutputVariable() out_limited !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() limited !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50566 !ENDDEFINE .
DEFINE !OutputVariable() out_needther !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() needther !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50567 !ENDDEFINE .
DEFINE !OutputVariable() out_needcoun !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() needcoun !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50568 !ENDDEFINE .
DEFINE !OutputVariable() out_Specialneeds !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 1 !ENDDEFINE .
DEFINE !InputVariables() Specialneeds !ENDDEFINE .
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
