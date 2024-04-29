/* this program is to merge the CAHPS national benchmark with the portal AHRQ benchmark list */ 
/* Year: 2023 */ 
/* program for this year: Adult Medicaid, Child Medicaid */ 
/* No Chip for this year */ 

/* import AHRQ list for portal: */ 
proc import out=portal_ahrq_bench_22
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2023-02\AHRQ national percentiles 2015-2022.xlsx"
	dbms = xlsx replace;
	sheet = 'Sheet1'; 
run;


/* import Adult Medicaid */ 
proc import out=adult_23
	datafile = "K:\IS-Resources\Resources\Benchmark\CAHPS\CAHPS Adult Medicaid 5.1_2023.xlsx"
	dbms = xlsx replace;
	sheet = 'Data'; 
run;

/* import Child Medicaid */ 
proc import out=child_23
	datafile = "K:\IS-Resources\Resources\Benchmark\CAHPS\CAHPS Child Medicaid 5.1_2023.xlsx"
	dbms = xlsx replace;
	sheet = 'Data'; 
run;

/* import the AHRQ file with noted order ID: */ 
proc import out=AdultMCD
	datafile = "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\bkup-survey\nationl_bench.xlsx"
	dbms = xlsx replace;
	sheet = 'adultMCD'; 
run;

data AdultMCD; 
	set AdultMCD; 
	keep SYear--'Composite/Item'n; 
	where SYear ne .; 
run; 

proc import out=ChildMCD
	datafile = "\\fed-ad.ufl.edu\T001\user\mydocs\jiang.shao\Desktop\bkup-survey\nationl_bench.xlsx"
	dbms = xlsx replace;
	sheet = 'childMCD'; 
run;

data ChildMCD; 
	set ChildMCD; 
	keep SYear--'Composite/Item'n; 
	where SYear ne .; 
run; 

proc sort data=AdultMCD; 
	by order; 
run; 

proc sort data=ChildMCD; 
	by order; 
run; 


/* merge datasets: */ 
data merge_adult; 
	merge AdultMCD (in=a) adult_23(in=b); 
	by order; 
	if a;
run; 

data merge_child; 
	merge ChildMCD (in=a) child_23(in=b); 
	by order; 
	if a;
run; 


proc sort data=merge_adult; 
	by sort_id; 
run; 

proc sort data=merge_child; 
	by sort_id; 
run; 

data final_2023_bench; 
	set merge_adult merge_child; 
	keep SYear Population 'Composite/Item'n 'Lowest Score'n '10th'n--'Highest Score'n; 
run; 

