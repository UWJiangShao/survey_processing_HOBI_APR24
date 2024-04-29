* Encoding: UTF-8.

 * dataset name empty .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\CHIP_2015\CH15.sav" .
 * /keep= PlanName .
 * dataset name comb .
 * alter type PlanName (a99) .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\CHIP_2015.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\CHIP_2016\CH16.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\CHIP_2016.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\CHIP_2017\CH17.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\CHIP_2017.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\CHIP_2018\CH18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\CHIP_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\CHIP_2019\CH19.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\CHIP_2019.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2015\SA15.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARAdult_2015.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2016\SA16.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARAdult_2016.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2017\SA17.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARAdult_2017.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2018\SA18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARAdult_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2019\SA19.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARAdult_2019.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2015\SC15.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARChild_2015.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2016\SC16.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARChild_2016.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2017\SC17.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARChild_2017.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2018\SC18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARChild_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARChild_2019\SC19.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARChild_2019.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARHealth_2016\SH16.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARHealth_2016.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARHealth_2018\SH18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARHealth_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2018\SK18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARKids_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARKids_2019\SK19.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARKids_2019.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2015\SP15.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARPLUS_2015.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2016\SP16.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARPLUS_2016.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2017\SP17.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARPLUS_2017.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2018\SP18.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARPLUS_2018.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

get file= "K:\TX-EQRO\Research\Member_Surveys\THLC\STARPLUS_2019\SP19.sav" .
 * /keep= PlanName .
 * dataset name addme .
 * alter type PlanName (a99) .
 * dataset activate comb .
 * add files file= *
    /file= addme .
 * execute .
 * dataset close addme .
dataset name full .
SAVE TRANSLATE OUTFILE='K:\TX-EQRO\Research\Member_Surveys\THLC\for icube - survey - 0819\STARPLUS_2019.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /DROP=PlanCode
  /CELLS=VALUES .
dataset activate empty .
dataset close full .

