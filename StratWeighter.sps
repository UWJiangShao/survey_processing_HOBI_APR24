* Encoding: UTF-8.
*** Creates post-stratification weights for variable list stratQ in active dataset.
*** Assumes full sample and completes in active dataset, and FinalDisposition=1100 identifies completes.
*** Assumes sampledBY macro is defined and points to a variable in the active dataset.
*** No post-stratification weight if <=5 in quota in data.
*** Creates variable iscmp=1 if FinalDisposition=1100, $sysmis else.
*** Call this macro when setting up input dataset to create post-stratification weights.


DEFINE !StratWeighter ( stratQ = !CMDEND )
use all .
IF ( FinalDisposition = 1100 ) iscmp = 1 .
execute .
!do !qvar !in ( !eval( !qlist ) )
compute !concat( "stratw_", !qvar ) = 1 .
!doend
execute .
AGGREGATE
    /OUTFILE= * MODE= ADDVARIABLES OVERWRITE= YES
    /BREAK = !sampledBY
    /!concat("allcnt_", !sampledBY) = nu.( !sampledBY ) .
filter by iscmp .
AGGREGATE
    /OUTFILE= * MODE= ADDVARIABLES OVERWRITE= YES
    /BREAK = !sampledBY
    /!concat("cmpcnt_", !sampledBY) = nu.( !sampledBY ) .
use all .

!DO !qvar !in ( !stratQ )
AGGREGATE
    /OUTFILE= * MODE= ADDVARIABLES OVERWRITE= YES
    /BREAK = !sampledBY !qvar
    /!concat( "allcnt_", !qvar ) = nu.( !qvar ) .
compute !concat( "allpct_", !qvar) = !concat( "allcnt_", !qvar ) / !concat( "allcnt_", !sampledBY ) .
execute .

filter by iscmp .
AGGREGATE
    /OUTFILE= * MODE= ADDVARIABLES OVERWRITE= YES
    /BREAK = !sampledBY !qvar
    /!concat( "cmpcnt_", !qvar ) = nu.( !qvar ) .

if ( !concat( "cmpcnt_", !sampledBY ) = 0 ) !concat( "cmpcnt_", !sampledBY ) = 1 .
compute !concat( "cmppct_", !qvar) = !concat( "cmpcnt_", !qvar ) / !concat( "cmpcnt_", !sampledBY ) .
if ( !concat( "cmpcnt_", !qvar ) <= 5 ) !concat( "cmppct_", !qvar ) = !concat( "allpct_", !qvar ) .
compute !concat( "stratw_", !qvar ) = !concat( "allpct_", !qvar, " / ", "cmppct_", !qvar ) .
execute .
use all .
!DOEND
!ENDDEFINE .

