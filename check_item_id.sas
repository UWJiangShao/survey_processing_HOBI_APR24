/* Check SA: */ 
proc import out=sa_data
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARAdult_2023.csv"
	dbms = csv replace;
run;

proc import out=sa_item
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARAdultItemOrder_2015-2023.xlsx"
	dbms = xlsx replace;
	sheet = 'STARAdult'; 
run;

data sa_item; 
	set sa_item; 
	where SYear = 2023; 
run; 

proc sql; 
	create table Mismatches as 
	select 
	coalesce(a.itemID, b.itemID) as itemID, 
	case 
		when  a.itemID is null then 'only in OrderList'
		when b.itemID is null then 'only in data'
	end as Status
	from sa_data as a 
		full join sa_item as b 
		on a.itemID = b.itemID
	where a.itemID is null or b.itemID is null; 
quit; 

proc sort data=Mismatches out=Mismatches_dedup nodupkey; 
	by itemID; 
run; 

/*50191	only in data*/
/*50193	only in data*/
/*50203	only in data*/
/*50237	only in data*/
/*50241	only in data*/
/*50253	only in data*/



/* Check SP: */ 
proc import out=sp_data
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARPlus_2023.csv"
	dbms = csv replace;
run;

proc import out=sp_item
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARPlusItemOrder_2015-2023.xlsx"
	dbms = xlsx replace;
	sheet = 'STARPLUS'; 
run;

data sp_item; 
	set sp_item; 
	where SYear = 2023; 
run; 

proc sql; 
	create table Mismatches_sp as 
	select 
	coalesce(a.itemID, b.itemID) as itemID, 
	case 
		when  a.itemID is null then 'only in OrderList'
		when b.itemID is null then 'only in data'
	end as Status
	from sp_data as a 
		full join sp_item as b 
		on a.itemID = b.itemID
	where a.itemID is null or b.itemID is null; 
quit; 

proc sort data=Mismatches_sp out=Mismatches_sp_dedup nodupkey; 
	by itemID; 
run; 

/*50191	only in data*/
/*50193	only in data*/
/*50203	only in data*/
/*50237	only in data*/
/*50241	only in data*/
/*50253	only in data*/


/* Check SK: */ 
proc import out=sk_data
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-04\STARKids_2023_adjusted_final_version.xlsx"
	dbms = xlsx replace;
run;

proc import out=sk_item
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARKidsItemOrder_2018-2023.xlsx"
	dbms = xlsx replace;
	sheet = 'Sheet1'; 
run;

data sk_item; 
	set sk_item; 
	where SYear = 2023; 
run; 

proc sql; 
	create table Mismatches_sk as 
	select 
	coalesce(a.itemID, b.itemID) as itemID, 
	case 
		when  a.itemID is null then 'only in OrderList'
		when b.itemID is null then 'only in data'
	end as Status
	from sk_data as a 
		full join sk_item as b 
		on a.itemID = b.itemID
	where a.itemID is null or b.itemID is null; 
quit; 

proc sort data=Mismatches_sk out=Mismatches_sk_dedup nodupkey; 
	by itemID; 
run; 







/* Check SC: */ 
proc import out=sc_data
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-04\data in Excel format\STARChild_2023.xlsx"
	dbms = xlsx replace;
run;

proc import out=sc_item
	datafile = "K:\TX-EQRO\Research\Member_Surveys\THLC\_for ICUBE 2024-05\STARChildItemOrder_2015-2023.xlsx"
	dbms = xlsx replace;
	sheet = 'STARChild'; 
run;

data sc_item; 
	set sc_item; 
	where SYear = 2023; 
run; 

proc sql; 
	create table Mismatches_sc as 
	select 
	coalesce(a.itemID, b.itemID) as itemID, 
	case 
		when  a.itemID is null then 'only in OrderList'
		when b.itemID is null then 'only in data'
	end as Status
	from sc_data as a 
		full join sc_item as b 
		on a.itemID = b.itemID
	where a.itemID is null or b.itemID is null; 
quit; 

proc sort data=Mismatches_sc out=Mismatches_sc_dedup nodupkey; 
	by itemID; 
run; 

data not_in_itemID; 
	set Mismatches_sc_dedup; 
	where Status = 'only in OrderList'; 
run; 





