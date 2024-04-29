OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr;

%let Full_Path_And_File_Name 	= K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\df_format_all_quota_sk.sas7bdat;
%let QuotaVariable 			 			  =  &quota_name;
%let Suffix					 			  =  _&quota_name;
%let OutputFolder 			 			  =  K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2023\case_mix_output_sk\all_quota\;
%let pvalue = 0.05; 
%let adjuster = rage health_exc health_vgd health_gd health_fair health_poor edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll; 
%let wgtmean         = CompWeight; 
%let low_denominator = 3; 

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;

* %cahps(name = OUT_CAHPS18 , outname = OUT_CAHPS18	, var = CAHPS18 ,pvalue = &pvalue,
* wgtmean = &wgtmean,
* wgtdata	= ,
* low_denominator = &low_denominator,
* adjuster = &adjuster,excludeQuotas= ,
* recode = 0,
* vartype = 1);

%cahps(name = GCQ, outname = GCQ, var = CAHPS4 CAHPS6, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = GNC, outname = GNC, var = CAHPS10 CAHPS41, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS49, outname = OUT_CAHPS49, var = CAHPS49, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS8, outname = OUT_CAHPS8, var = CAHPS8, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = GSS, outname = GSS, var = CAHPS15 CAHPS18 CAHPS21, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = FCCPD, outname = FCCPD, var = CAHPS33 CAHPS38 CAHPS39, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS51, outname = OUT_CAHPS51, var = CAHPS51, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS3, outname = OUT_CAHPS3, var = CAHPS3, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS4, outname = OUT_CAHPS4, var = CAHPS4, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS5, outname = OUT_CAHPS5, var = CAHPS5, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS6, outname = OUT_CAHPS6, var = CAHPS6, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS7, outname = OUT_CAHPS7, var = CAHPS7, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS8, outname = OUT_CAHPS8, var = CAHPS8, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS10, outname = OUT_CAHPS10, var = CAHPS10, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS14, outname = OUT_CAHPS14, var = CAHPS14, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS15, outname = OUT_CAHPS15, var = CAHPS15, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS17, outname = OUT_CAHPS17, var = CAHPS17, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS18, outname = OUT_CAHPS18, var = CAHPS18, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS20, outname = OUT_CAHPS20, var = CAHPS20, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS21, outname = OUT_CAHPS21, var = CAHPS21, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS23, outname = OUT_CAHPS23, var = CAHPS23, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS24, outname = OUT_CAHPS24, var = CAHPS24, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS25, outname = OUT_CAHPS25, var = CAHPS25, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS26, outname = OUT_CAHPS26, var = CAHPS26, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS33, outname = OUT_CAHPS33, var = CAHPS33, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS38, outname = OUT_CAHPS38, var = CAHPS38, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS39, outname = OUT_CAHPS39, var = CAHPS39, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS40, outname = OUT_CAHPS40, var = CAHPS40, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS41, outname = OUT_CAHPS41, var = CAHPS41, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS49, outname = OUT_CAHPS49, var = CAHPS49, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS50, outname = OUT_CAHPS50, var = CAHPS50, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS51, outname = OUT_CAHPS51, var = CAHPS51, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS53, outname = OUT_CAHPS53, var = CAHPS53, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_TRTCHLD, outname = OUT_TRTCHLD, var = TRTCHLD, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_TRTADLT, outname = OUT_TRTADLT, var = TRTADLT, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_K5Q20R, outname = OUT_K5Q20R, var = K5Q20R, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = ATC, outname = ATC, var = CAHPS4 CAHPS6 CAHPS10 CAHPS41, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS75, outname = OUT_CAHPS75, var = CAHPS75, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS10, outname = OUT_CAHPS10, var = CAHPS10, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS18, outname = OUT_CAHPS18, var = CAHPS18, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS21, outname = OUT_CAHPS21, var = CAHPS21, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_K5Q20R, outname = OUT_K5Q20R, var = K5Q20R, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_TRTADLT, outname = OUT_TRTADLT, var = TRTADLT, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS41, outname = OUT_CAHPS41, var = CAHPS41, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS4, outname = OUT_CAHPS4, var = CAHPS4, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 
%cahps(name = OUT_CAHPS6, outname = OUT_CAHPS6, var = CAHPS6, pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1); 