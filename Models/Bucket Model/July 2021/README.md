# Revision 18
 Date: July  2nd 2021
 
 Updates:
 + Merge of environmmental crop mechanism on irrigation districts.

 Notes:
 + final acreage var_tacres on excel file.
 + hardcoded san marcial inflows on line 1749 onward.
 + environmental crop added to the mix on all districts and crop tables.
 + line 1867 binary list of when crop schedule is applied yearle.
 + lines 3451-3453 required lower bound, thousands of acres of env crop on irrigation districts according to schedule table.
 + Currently using observed inflows at san marcial up to 2013 and extreme climate scenario projected to the future after 2013.

 Issues:
 + elasticity value of cd juarez should be revised.
 + precipitation and evaporation timeseries on average value after 2015 (these should be calculated according to climate scenario).
 + model breaks with active operating agreement on wet climate scenario.
