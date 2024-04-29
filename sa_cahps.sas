
%let Full_Path_And_File_Name 	= K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2023\case_mix_output\df_format_all_quota_sa.sas7bdat;
%let QuotaVariable 			 			  =  &quota_name;
%let Suffix					 			  =  _&quota_name;
%let OutputFolder 			 			  =  K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2023\case_mix_output\all_quota_result\;
%let pvalue = 0.05; 
%let adjuster = rage health_exc health_vgd health_gd health_fair health_poor edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll; 
%let wgtmean         = CompWeight; 
%let low_denominator = 3; 

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;

%cahps(name = OUT_CAHPS18 , outname = OUT_CAHPS18	, var = CAHPS18 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS28 , outname = OUT_CAHPS28	, var = CAHPS28 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = GCQ		 , outname = GCQ			, var = CAHPS4 CAHPS6 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = GNC		 , outname = GNC			, var = CAHPS9 CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = HWDC		 , outname = HWDC			, var = CAHPS12 CAHPS13 CAHPS14 CAHPS15 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS3 , outname = OUT_CAHPS3	, var = CAHPS3 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS4 , outname = OUT_CAHPS4	, var = CAHPS4 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS5 , outname = OUT_CAHPS5	, var = CAHPS5 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS6 , outname = OUT_CAHPS6	, var = CAHPS6 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS7 , outname = OUT_CAHPS7	, var = CAHPS7 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS9 , outname = OUT_CAHPS9	, var = CAHPS9 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS10 , outname = OUT_CAHPS10	, var = CAHPS10 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS11 , outname = OUT_CAHPS11	, var = CAHPS11 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS12 , outname = OUT_CAHPS12	, var = CAHPS12 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS13 , outname = OUT_CAHPS13	, var = CAHPS13 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS14 , outname = OUT_CAHPS14	, var = CAHPS14 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS15 , outname = OUT_CAHPS15	, var = CAHPS15 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS18 , outname = OUT_CAHPS18	, var = CAHPS18 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS19 , outname = OUT_CAHPS19	, var = CAHPS19 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS20 , outname = OUT_CAHPS20	, var = CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS28 , outname = OUT_CAHPS28	, var = CAHPS28 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS29 , outname = OUT_CAHPS29	, var = CAHPS29 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = ATC		 , outname = ATC			, var = CAHPS4 CAHPS6 CAHPS9 CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS38 , outname = OUT_CAHPS38	, var = CAHPS38 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS9 , outname = OUT_CAHPS9	, var = CAHPS9 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS20 , outname = OUT_CAHPS20	, var = CAHPS20 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS4 , outname = OUT_CAHPS4	, var = CAHPS4 ,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);

%cahps(name = OUT_CAHPS6 , outname = OUT_CAHPS6	, var = CAHPS6,pvalue = &pvalue,
wgtmean = &wgtmean,
wgtdata	= ,
low_denominator = &low_denominator,
adjuster = &adjuster,excludeQuotas= ,
recode = 0,
vartype = 1);
