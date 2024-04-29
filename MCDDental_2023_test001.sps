* Encoding: UTF-8.
** Syntax semi-automatically generated at 2021-09-22 13:35:02 using <V:\TEXAS\TexasReports\Contract_Deliverables\Member_Surveys\Survey Tools\Syntax\Excel macros\Surveys (member+caregiver)\thlc syntax generator.xlsm>.
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\CompositesRatings - qlist.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\QuotaPermuter.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\MergeSaveClose.sps"  .
INSERT FILE = "K:\TX-EQRO\Research\Member_Surveys\Syntax\SPSS macros\StratWeighter.sps"  .
GET FILE = "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\dental_survey\dental_23\md_2023.sav" .
dataset name data_file WINDOW= FRONT.

DEFINE  !qlist()  planname  Sex  Race  !ENDDEFINE .
DEFINE  !SYear()  2023  !ENDDEFINE .
DEFINE  !surveyPopulation()  "MCDDental"  !ENDDEFINE .
DEFINE  !weightby()  BWeight  !ENDDEFINE .
DEFINE  !sampledBy()  d_PlanName  !ENDDEFINE .
DEFINE  !LD() 30 !ENDDEFINE .
DEFINE  !OutDir()  "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\dental_survey\dental_23\output_23"  !ENDDEFINE .
delete variables planname .

** create post-stratification weights .
DATASET ACTIVATE data_file .
SORT CASES BY Survey_ID .
get data
    /type = xlsx
    /file= "K:\TX-EQRO\Research\Member_Surveys\CY2023\Dental Caregiver\Sample\Orignal (do not modify)\Dental_Survey_23_2305.xlsx"
    /sheet= index 1
    /cellrange= range "A1:Y16788" .
DATASET NAME sample_file WINDOW= FRONT.
SORT CASES BY Survey_ID .
MATCH FILES FILE= *
   /FILE= sample_file
   /KEEP= Survey_ID Quota Dental_Plan Sex Race .
MATCH FILES FILE= *
   /FILE= data_file
   /BY Survey_ID
    /DROP= DMO_Plan_Code .
DATASET CLOSE data_file .
DATASET ACTIVATE sample_file .
DATASET NAME input_db .
STRING DMO_Plan_Code (A8).
RECODE Quota 
('CHIP DentaQuest'='1K') 
('CHIP MCNA Dental'='1H') 
('CHIP UnitedHealthCare '+ 'Dental'='1S') 
('Medicaid DentaQuest'='1M') 
('Medicaid MCNA Dental'='1J') 
('Medicaid '+ 'UnitedHealthCare Dental'='1R') 
INTO DMO_Plan_Code .
VARIABLE LABELS  DMO_Plan_Code 'Dental Plan Code'.
EXECUTE.
rename variables ( Dental_Plan DMO_Plan_Code = planname plancode ) .
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
alter type race (f3.0) .
alter type planname (a44) Sex Race (a3) FinalDisposition (f4.0) .
COMPUTE Race = LTRIM(Race) .
string d_PlanName (a44) .
compute d_PlanName = planname .
EXECUTE .


*** create blank dataset for merging output .
DEFINE !dsName() !concat( !unquote(!eval(!surveyPopulation)), "_", !eval(!SYear) ) !ENDDEFINE .
DATA LIST /@qcat (a555)
                 planname (a44) Sex (a3) Race (a3) ItemID (f5.0) 
                 Rate (f6.1) isLD (f1.0) Denom (f5.0) resp_1 resp_2 resp_3 resp_4 resp_5 resp_6 resp_7 resp_8 resp_9 resp_10 resp_11 (11f6.1) .
BEGIN DATA
END DATA .
DATASET NAME  !dsName  .


*** begin calculation blocks .
dataset activate input_db .
DEFINE !iiD() 50535 !ENDDEFINE .
DEFINE !OutputVariable() CfDS !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd6 cahpsd7 cahpsd8 cahpsd9 cahpsd11 cahpsd12 !ENDDEFINE .
!QuotaPermuter !qlist .

compute cahpsD14r = 5 - cahpsD14 .
execute .
dataset activate input_db .
DEFINE !iiD() 50536 !ENDDEFINE .
DEFINE !OutputVariable() ADC !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd13 cahpsd15 cahpsd16 cahpsd17 cahpsd14r !ENDDEFINE .
!QuotaPermuter !qlist .

compute cahpsD24r = 5 - cahpsD24 .
execute .
dataset activate input_db .
DEFINE !iiD() 50537 !ENDDEFINE .
DEFINE !OutputVariable() DPIS !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd19 cahpsd22 cahpsd27 cahpsd28 cahpsd20 cahpsd24r !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50538 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd10 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahpsd10 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50539 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd18 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahpsd18 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50540 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd25 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahpsd25 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50541 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd29 !ENDDEFINE .
DEFINE !topbox() 9 !ENDDEFINE .
DEFINE !minresp() 0 !ENDDEFINE .
DEFINE !maxresp() 10 !ENDDEFINE .
DEFINE !InputVariables() cahpsd29 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50319 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd3 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd3 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50320 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd4 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd4 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50321 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd5 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd5 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50322 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd6 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd6 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50323 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd7 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd7 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50324 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd8 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd8 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50325 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd9 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd9 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50327 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd11 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd11 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50328 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd12 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd12 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50329 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd13 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd13 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50330 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd14 !ENDDEFINE .
DEFINE !topbox() -2 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() cahpsd14 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50331 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd15 !ENDDEFINE .
DEFINE !topbox() 5 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() cahpsd15 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50332 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd16 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd16 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50333 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd17 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd17 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50335 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd19 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd19 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50336 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd20 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd20 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50337 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd21 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd21 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50338 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd22 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd22 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50339 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd23 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd23 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50340 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd24 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd24 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50342 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd26 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 2 !ENDDEFINE .
DEFINE !InputVariables() cahpsd26 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50343 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd27 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd27 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50344 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd28 !ENDDEFINE .
DEFINE !topbox() 4 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd28 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50346 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd30 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd30 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50347 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd31 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 4 !ENDDEFINE .
DEFINE !InputVariables() cahpsd31 !ENDDEFINE .
!QuotaPermuter !qlist .

dataset activate input_db .
DEFINE !iiD() 50348 !ENDDEFINE .
DEFINE !OutputVariable() out_cahpsd32 !ENDDEFINE .
DEFINE !topbox() -1 !ENDDEFINE .
DEFINE !minresp() 1 !ENDDEFINE .
DEFINE !maxresp() 5 !ENDDEFINE .
DEFINE !InputVariables() cahpsd32 !ENDDEFINE .
!QuotaPermuter !qlist .


*** cleanup and save/export .
dataset activate !dsName .
compute SYear = !SYear .
formats SYear (F5.0) .
string surveyPopulation (a33) .
compute surveyPopulation = !surveyPopulation .
sort cases by ItemID @qcat .
execute .
match files file= *
    /by ItemID @qcat
    /last= PrimaryLast
    /keep= SYear, surveyPopulation, ALL .
dataset name outdata .
select if ( PrimaryLast = 1 ) .
execute .
delete variables @qcat !sampledBy PrimaryLast .
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
