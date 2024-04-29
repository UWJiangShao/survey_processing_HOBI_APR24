* Encoding: UTF-8.

/* Call these functions from a portal syntax file, near the end. These functions
/* will overwrite the !dsName values with the case-mix adjusted values
/* output by SAS. The output file will need to be prepared with the expected 
/* variable names and health plan and service area names.

/* Variables in the dataset !dsName:
/*    @qcat (a555) -- concatenation of quota variables (plan, sda, sex, race)
/*    itemID (f5.0)   -- five digit id for measure to be overwritten
/*    PlanName, ServiceArea, Rate, Denom

/* Variables in file!sheetnum:
/*    planname stderr                        -- as output by SAS (_plan_out.xlsx)
/*    PHI_Plan_Code stderr sig          -- as output by SAS (_out.xlsx)
/*    PHI_Plan_Name PHI_SA_Name -- added manually
/*    Rate, Denom, stderr, sig            -- manually remove variable prefix so all sheets have the same field names


DEFINE !UpdateValuesHP ( file= !CHAREND("/") /sheetnum= !CHAREND("/") /id= !CMDEND )
GET DATA 
   /TYPE= XLSX
   /FILE= !file
   /SHEET= INDEX !sheetnum .
DATASET NAME cmix WINDOW= FRONT .
string @qcat (a555) .
compute @qcat = CONCAT( planname, "ALLALLALL" ) .
    compute ItemID = !id .
execute .
compute Rate = 100 * Rate .
execute .
alter type ItemID (f5.0) .
sort cases by ItemID @qcat .
delete variables planname .
execute .

dataset activate !dsName .
update file= *
    /file= cmix
    /by ItemID @qcat 
    /drop= stderr .
execute .
dataset close cmix .
!ENDDEFINE .

DEFINE !UpdateValuesPC ( file= !CHAREND("/") /sheetnum= !CHAREND("/") /id= !CMDEND )
GET DATA 
   /TYPE= XLSX
   /FILE= !file
   /SHEET= INDEX !sheetnum .
DATASET NAME cmix WINDOW= FRONT .
string @qcat (a555) .
compute @qcat = CONCAT( PHI_Plan_Name, PHI_SA_Name, "ALLALL" ) .
compute ItemID = !id .
execute .
compute Rate = 100 * Rate .
execute .
alter type ItemID (f5.0) .
sort cases by ItemID @qcat .
execute .

dataset activate !dsName .
update file= *
    /file= cmix
    /by ItemID @qcat 
    /drop= PHI_Plan_Code PHI_Plan_Name PHI_SA_Name stderr sig .
execute .
dataset close cmix .
!ENDDEFINE .
