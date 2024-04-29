OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr;

%let Full_Path_And_File_Name 	= K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\updater_for_wrong_format\case_mix_output\ccc\df_format_all_quota_sc_ccc.sas7bdat;
%let QuotaVariable 			 			  =  &quota_name;
%let Suffix					 			  =  _&quota_name;
%let OutputFolder 			 			  =  K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2023\SC_output_thlc\case_mix_output\ccc\;
%let pvalue = 0.05; 
%let adjuster = rage health_exc health_vgd health_gd health_fair health_poor edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll; 
%let wgtmean         = CompWeight; 
%let low_denominator = 3; 

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;

%cahps(outname=out_cahps8, name = out_cahps8, var = cahps8,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=CoC_CCC, name = CoC_CCC, var = cahps13 cahps24,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=GSS, name = GSS, var = cahps15 cahps18 cahps21,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=FCCPD, name = FCCPD, var = cahps33 cahps38 cahps39,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps51, name = out_cahps51, var = cahps51,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps16, name = out_cahps16, var = cahps16,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps19, name = out_cahps19, var = cahps19,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps22, name = out_cahps22, var = cahps22,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps52, name = out_cahps52, var = cahps52,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps13, name = out_cahps13, var = cahps13,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps15, name = out_cahps15, var = cahps15,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps24, name = out_cahps24, var = cahps24,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps33, name = out_cahps33, var = cahps33,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps38, name = out_cahps38, var = cahps38,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps39, name = out_cahps39, var = cahps39,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps18, name = out_cahps18, var = cahps18,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_cahps21, name = out_cahps21, var = cahps21,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_needmeds, name = out_needmeds, var = needmeds,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_needserv, name = out_needserv, var = needserv,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_limited, name = out_limited, var = limited,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_needther, name = out_needther, var = needther,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_needcoun, name = out_needcoun, var = needcoun,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_specialneed, name = out_specialneed, var = specialneed,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
%cahps(outname=out_trtadlt, name = out_trtadlt, var = trtadlt,pvalue = &pvalue, wgtmean = &wgtmean, wgtdata = , low_denominator = &low_denominator, adjuster = &adjuster, excludeQuotas = , recode = 0, vartype = 1);
