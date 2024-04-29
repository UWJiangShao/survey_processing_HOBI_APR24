* Encoding: UTF-8.
*** Updated item numbers for 2020 CAHPS 5.0H ~ncc.

*** Screener set to identify Children with Special Health Care Needs (CSHCN) / Children with Chronic Conditions (CCC)  .
IF (cahps55 >= 1)  needmeds= 0  .
IF (cahps57   = 1)  needmeds= 1  .
VARIABLE LABELS needmeds "CCC Screener: Use of or Need for Prescription Medicines" .

IF (cahps58 >= 1)  needserv= 0  .
IF (cahps60   = 1)  needserv= 1  .
VARIABLE LABELS needserv "CCC Screener: Above-Average Use or Need for Medical, Mental Health or Education Services" .

IF (cahps61 >= 1)  limited= 0  .
IF (cahps63   = 1)  limited= 1  .
VARIABLE LABELS limited "CCC Screener: Functional Limitations Compared With Others of Same Age" .

IF (cahps64 >= 1)  needther= 0  .
IF (cahps66   = 1)  needther= 1  .
VARIABLE LABELS needther "CCC Screener: Use or of Need for Specialized Therapies" .

IF (cahps67 >= 1)  needcoun= 0  .
IF (cahps68   = 1)  needcoun= 1  .
VARIABLE LABELS needcoun "CCC Screener: Treatment or Counseling for Emotional or Developmental Problems" .
EXECUTE  .

VALUE LABELS  needmeds needserv limited needther needcoun  1 "Yes" 0 "No" .
VARIABLE LEVEL needmeds needserv limited needther needcoun  (NOMINAL).
FORMATS  needmeds needserv limited needther needcoun  (f2.0)  .


*** The next line works, but multiple response sets assume the same denominator for all variables in the set .
*** The counts (weighted and unweighted) will be fine, but the percentages (responses and respondents) will not .
 * MRSETS
    /MDGROUP NAME= $CCC_MRSet  LABEL= "CCC screener items as a multiple response set"
    CATEGORYLABELS = VARLABELS
    VARIABLES= needmeds TO needcoun
    VALUE = 1
    /DISPLAY NAME = [$CCC_MRSet]
.


** Sum of five screening criteria, for comparison with national data (Matern Child Health J 2008 12:1-14).
COMPUTE Fivescreen_total = SUM( needmeds, needserv, limited, needther, needcoun ) .
VARIABLE LABELS Fivescreen_total "Number of five screening criteria met".
VARIABLE LEVEL Fivescreen_total (NOMINAL)  .
FORMATS Fivescreen_total (f2.0)  .
EXECUTE  .

** Special needs variable, dichotomized.
RECODE
  Fivescreen_total
  (0=0)  (1 thru 5=1)  INTO  Specialneeds .
VARIABLE LABELS Specialneeds "CCC Screener: Child Identified as Having One or More Chronic Conditions"  .
VALUE LABELS Specialneeds 0 "No" 1 "Yes"  .
VARIABLE LEVEL Specialneeds (NOMINAL).
FORMATS  Specialneeds (f2.0)  .

EXECUTE .

