* Encoding: UTF-8.
** Syntax semi-automatically generated at 2021-04-07 13:11:52 using <V:\TEXAS\TexasReports\Contract_Deliverables\Member_Surveys\Survey Tools\Syntax\Excel macros\Surveys (member+caregiver)\thlc syntax generator.xlsm>.
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\CompositesRatings - qlist.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\QuotaPermuter.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\MergeSaveClose.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\StratWeighter.sps"  .
INSERT FILE= "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\updaters (dashboards to portal).sps" .
GET FILE = "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\STAR+Plus ARC 2023_Completes.sav" .
dataset name data_file WINDOW= FRONT.

DEFINE  !qlist()  PlanName  ServiceArea  Sex  Race  !ENDDEFINE .
DEFINE  !SYear()  2023  !ENDDEFINE .
DEFINE  !surveyPopulation()  "STARPLUS"  !ENDDEFINE .
DEFINE  !weightby()  CompWeight  !ENDDEFINE .
DEFINE  !sampledBy()  PlanCode  !ENDDEFINE .
DEFINE  !LD() 30 !ENDDEFINE .
DEFINE  !OutDir()  "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2023\SP_thlc_output"  !ENDDEFINE .
RENAME VARIABLES ( PHI_Plan_Code PHI_Plan_Name PHI_SA_Name = PlanCode PlanName ServiceArea ) .
alter type Race (f1.0) .
alter type PlanName (a44) ServiceArea (a14) Sex Race (a3) .
compute Race = LTRIM(Race) .
execute .

** recode variables . 
DATASET ACTIVATE data_file .
SORT CASES BY Survey_ID .
GET DATA 
   /TYPE= XLSX
   /FILE= "K:\TX-EQRO\Research\Member_Surveys\CY2023\STAR+PLUS ARC\Sample\Orignal (do not modify)\STAR_PLUS_23_2303.xlsx"
   /SHEET= INDEX 1
   /CELLRANGE= RANGE "A1:V57336" .
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
RENAME VARIABLES ( PHI_Plan_Code PHI_Plan_Name PHI_SA_Name = PlanCode PlanName ServiceArea ) .
alter type Race (f1.0) .
ALTER TYPE PlanName (a44) ServiceArea (a14) Sex Race (a3) .
MATCH FILES FILE= *
   /FILE= data_file
   /BY Survey_ID .
DATASET CLOSE data_file .
DATASET ACTIVATE sample_file .
DATASET NAME input_db .
COMPUTE Race = LTRIM(Race) .
ALTER TYPE FinalDisposition (f4.0) .
EXECUTE .

*** create blank dataset for merging output .
DEFINE !dsName() !concat( !unquote(!eval(!surveyPopulation)), "_", !eval(!SYear) ) !ENDDEFINE .
DATA LIST /@qcat (a555)
                 PlanName (a44) ServiceArea (a14) Sex (a3) Race (a3) ItemID (f5.0) 
                 Rate (f6.1) isLD (f1.0) Denom (f5.0) resp_1 resp_2 resp_3 resp_4 resp_5 resp_6 resp_7 resp_8 resp_9 resp_10 resp_11 (11f6.1) .
BEGIN DATA
END DATA .
DATASET NAME  !dsName  .


*** begin calculation blocks .
dataset activate input_db .
DEFINE !iiD() 50181 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps18 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps18 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50183 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps28 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahps28 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50184 !ENDDEFINE .
DEFINE !OutputVariable() GCQ !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 cahps6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50185 !ENDDEFINE .
DEFINE !OutputVariable() GNC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps9 cahps20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50186 !ENDDEFINE .
DEFINE !OutputVariable() HWDC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps12 cahps13 cahps14 cahps15 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50532 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps4 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50533 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps6 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50508 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps9 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50531 !ENDDEFINE .
DEFINE !OutputVariable() out_cahps20 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50318 !ENDDEFINE .
DEFINE !OutputVariable() AtC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahps4 cahps6 cahps9 cahps20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50190 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS3 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS3 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50191 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS4 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50192 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS5 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS5 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50193 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS6 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50196 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS7 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS7 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50203 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS9 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50215 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS10 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS10 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50217 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS11 !ENDDEFINE .
DEFINE !topbox() 1 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS11 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50218 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS12 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS12 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50220 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS13 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS13 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50222 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS14 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS14 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50223 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS15 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS15 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50237 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS18 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS18 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50240 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS19 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() CAHPS19 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50241 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS20 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() CAHPS20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50253 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS28 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() CAHPS28 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50258 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS29 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() CAHPS29 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50500 !ENDDEFINE .
DEFINE !OutputVariable() out_CAHPS38 !ENDDEFINE .
DEFINE !topbox() 3 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 6 !ENDDEFINE .
DEFINE !InputVariables() CAHPS38 !ENDDEFINE .
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
