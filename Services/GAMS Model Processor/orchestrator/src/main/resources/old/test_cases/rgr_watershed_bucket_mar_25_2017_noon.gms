$EOLCOM //
$TITLE RIO GRANDE BASIN HYDROECONOMIC PROTOTYPE
$OFFSYMXREF OFFSYMLIST OnLISTING OFFUPPER

OPTION LIMROW=200, LIMCOL = 0;

$ONTEXT

* ---------------------------------------------------------------------------------------

* CONTACTS

  Frank A. Ward:
  Dept of Agr Economics/Agr Business
  New Mexico State University, Las Cruces, NM USA
  e-mail: fward@nmsu.edu

* Alex Mayer
  Michigan Technical University
  asmayer@mtu.edu

  March 9 2017

Rio Grande Basin Model: Expandable Prototype
Contains essential elements of full Upper Rio Grande Basin Model.
Sponsor:  USDA NIFA 5 year grant beginning March 2015

* ----------------------------------------------------------------------------------------
* BEGINNING OF IMPROVEMENTS
* ----------------------------------------------------------------------------------------

* Improvements from March 1 2017

* Adds a 5th scenario for which #1 is a calibrated model
* This model replicates Caballo releases and Project surface storage for all years
* 1996-2015

*---------------------------------------------------------------------------------------*

* #1 model: Calibrates storage to match historical inflow, storage, and releases from RG project storage

*    a.  Caballo (optimized) gauged releases constrained to match historical data
*    b.  Rio Grande Project (optimized) storage adjusted yearly to replicate historical measured storage
*    c.  Keeps historical starting project storage at Elephant Butte + Caballo
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

* --------------------------- end of model 1 ------------------------------------------ *

* Begin #2 model: base policy base inflows into project storage
* Removes restriction on Caballo releases
* but keeps adjustment to predicted storage volume from model 1

*    a.  Removes Caballo restriction to match historical gauged releases: reduces constraints by 1
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  Keeps historical starting project storage
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

* --------------------------- end of model 2 ------------------------------------------ *

* Begin #3 model: new policy base inflows into project storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  10% reduction starting storage for RG reservoirs
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

* --------------------------- end of model 3 ------------------------------------------ *

* Begin #4 model: base policym, new inflows into project storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  Keeps starting storage for RG reservoirs
*    d.  10% reduction for inflows into project storage at San Marcial Gauge

* --------------------------- end of model 4 ------------------------------------------ *

* Begin #5 model: new policy, new inflows into storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  10% reduction in starting storage for RG reservoirs
*    d.  10% reduction for inflows into project storage at San Marcial Gauge

* --------------------------- end of model 5 ------------------------------------------ *


* still need to be sure that these 5 models formatted write correctly to spreadsheet
* Formatting has errors as of March 6, 2017

* --------------------------------------------------------------------------------------*


* ---------------------------------------------------------------------------------------
* END OF IMPROVEMENTS
* ---------------------------------------------------------------------------------------

* ---------------------------------------------------------------------------------------
* Sponsored by US Dept of Agriculture: 5 yr project 2015 - 2020
* ---------------------------------------------------------------------------------------

Model has these flow nodes:
5 river gauge nodes
1 streamgauge inflow node San Marcial above Elephant Butte
5 watershed point inflow nodes from ungauged precip into river reaches
5 diversion nodes
5 consumptive use nodes
5 surface water return flow nodes
2 groundwater pumping nodes
1 reservoir storage release node

and these stock nodes:
1 reservoir node
2 aquifer nodes

* ---------------------------------------------------------------------------------------
FLOWS:  Spatial unit for FLOWS is set (index) i.
Each element in the set i is assigned to one water use subset (category)
Subset categories include:

   1. Inflow nodes to the system,                                inflow(i);

   2. Nodes on a river or tributary                              river(i);

   3  Diversion nodes                                            divert(i);

   4. Consumptive uses                                           use(i);

   5. Return flow nodes directly to the river,                   return(i);

   6. NET reservoir releases from storage, outflow - inflow      rel(i);

STOCKS: Spatial unit for STOCKS is the set index u.
Each element of the set u is assigned to one water use subset (category).
Subset categories are:

   1. Reservoir nodes,                                           res(u)
   2. Aquifer nodes                                              aqf(u).

* ---------------------------------------------------------------------------------------

TABLE OF CONTENTS

   Section 1. Sets
   Section 2. Data
   Section 3. Variables
   Section 4. Equations
   Section 5. Models
   Section 6. Solves
   Section 7. Displays
* ---------------------------------------------------------------------------------------

*--------------- Section 1 -------------------------------------------------------------*
*  The following sets are specified as indices                                          *
*  for parameters (data), variables (unknowns), and equations (algebraic relations)     *
*---------------------------------------------------------------------------------------*

$OFFTEXT

SETS

*---------------------------------------------------------------------------------------*
i     Flows -- location of important nodes in middle RG Basin -- Elephant Butte to MX
*---------------------------------------------------------------------------------------*

/     Marcial_h_f      Headwater flow nodes                                 inflow(i)
      Wshed_1_h_f

      RG_Caballo_out_v_f Rio Grande at Caballo outflow                      river(i)        //  https://www.ibwc.gov/Water_Data/histflo1.htm
      RG_El_Paso_v_f     Rio Grande at el paso above am dam divert
      RG_above_MX_v_f    Rio Grande below am dam above mx divert
      RG_below_MX_v_f    Rio Grande below MX turnout (calc not gauged)
      RG_below_EPID_v_f  rio Grande at Fort Quitman

      EBID_d_f         Diversion nodes                                      divert(i)
      LCMI_d_f
      EPMI_d_f
      MX_d_f
      EPID_d_f

      EBID_u_f        Consumptive use flow nodes                            use(i)
      LCMI_u_f
      EPMI_u_f
      MX_u_f
      EPID_u_f

      EBID_rr_f        River return flow nodes                              r_return(i)
      LCMI_rr_f
      EPMI_rr_f
      MX_rr_f
      EPID_rr_f


      EBID_ar_f        Aquifer return flow nodes                            a_return(i)
      LCMI_ar_f
      EPMI_ar_f
      MX_ar_f
      EPID_ar_f

      Store_rel_f     Res storage-to-river release node (outflow - inflow)  rel(i)
/
*---------------------------------------------------------------------------------------*
*     Subsets of all Flow nodes above by class (function)
*---------------------------------------------------------------------------------------*

inflow(i)             Headwater flow nodes                        inflow(i)

/     Marcial_h_f     Rio Grande headwaters CO
      Wshed_1_h_f     Watershed inflow #1
/

river(i)              River gage measurement nodes                river(i)

/     RG_Caballo_out_v_f RGR project storage outflow gauge on RG
      RG_El_Paso_v_f     New Mexico Texas State Line on RG
      RG_above_MX_v_f    Rio Grande above Mexico diversion
      RG_below_MX_v_f    Rio Grande below Mexico diversion
      RG_below_EPID_v_f  Gauge below EP irrigation diversion use on RG
/

divert(i)             Diversion nodes                             divert(i)

/     EBID_d_f        Elephant Butte Irrigation District diversion
      LCMI_d_f        Las Cruces MI diversions at LC
      EPMI_d_f        El Paso MI diversion at El Paso
      MX_d_f          Mexican diversion on Rio Grande
      EPID_d_f        El Paso Irrigation dversion
/

agdivert(divert)      Ag diversion nodes                         agdivert(divert)

/     EBID_d_f        EBID diversions
      EPID_d_f        EPID diversions
/

midivert(divert)     urban diversions nodes                    midivert(divert)

/     LCMI_d_f       las cruces urban diversions
      EPMI_d_f       el paso urban diversions
/

mxdivert(divert)     mexico diversion

/     MX_d_f/

use(i)               Consumptive use flow nodes = div nodes      use(i)

/     EBID_u_f       same nodes as divert(i) but shows use
      LCMI_u_f
      EPMI_u_f
      MX_u_f
      EPID_u_f
/

r_return(i)           River return flow nodes - return to river

/     EBID_rr_f
      LCMI_rr_f
      EPMI_rr_f
      MX_rr_f
      EPID_rr_f
/

a_return(i)           Aquifer return flow nodes - return to aquifer

/     EBID_ar_f
      LCMI_ar_f
      EPMI_ar_f
      MX_ar_f
      EPID_ar_f
/

aguse(use)           Ag use nodes                           aguse(use)

/     EBID_u_f       ebid nm
      EPID_u_f       epid tx
/

miuse(use)           urban use nodes                        miuse(use)

/     LCMI_u_f       las cruces urban
      EPMI_u_f       el paso urban
/


agr_return(r_return)  Ag river return flow nodes            agr_return(r_return)

/     EBID_rr_f       elephant butte irrigation
      EPID_rr_f       el paso irrigation
/

aga_return(a_return)                                        aga_return(a_return)

/    EBID_ar_f
     EPID_ar_f
/

mir_return(r_return)  urban to river return flow nodes      mir_return(r_return)

/    LCMI_rr_f        las cruces urban
     EPMI_rr_f        el paso urban
/

mia_return(a_return)  urban to aquifer return flow nodes    mia_return(a_return)

/    LCMI_ar_f        las cruces urban recharge to aquifer
     EPMI_ar_f        el paso urban recharge to aquifer
/

mxuse(use)            Deliveries to Mexico in Acequia Madre at International Dam
/     MX_u_f          Mexico use
/

mxr_return(r_return)  mexico river return flows
/    MX_rr_f          Mexico return flow to river
/


mxa_return(a_return)  mexico aquifer return flows
/    MX_ar_f          Mexico return flow to aquifer
/


rel(i)                Reservoir to river release flow nodes       rel(i)

/    Store_rel_f      RG Project storage releas into RG
/

*display agdivert;

*---------------------------------------------------------------------------------------*
u     Stocks - location of important nodes on Rio Grande CO to MX
*---------------------------------------------------------------------------------------*

/     Store_res_s    Reservoir stock node                        res(u)

      Mesilla_aqf_s  Mesilla Aquifer                             aqf(u)
      Hueco_aqf_s    Hueco Bolson                                aqf(u)
/

*---------------------------------------------------------------------------------------*
*    Stock subsets
*---------------------------------------------------------------------------------------*

res(u)               Reservoir stock nodes                       res(u)

/     Store_res_s    Rio Grande project storage on RG

/


aqf(u)               Aquifer stock nodes

/     Mesilla_aqf_s  Mesilla aquifer southern  NM and MX
      Hueco_aqf_s    Hueco   aquifer southwest TX and MX
/


*---------------------------------------------------------------------------------------*
j     crop
*---------------------------------------------------------------------------------------*

/     pecans
      veges
      forage
/


*----------------------------------------------------------------------------------------
k     technology
*----------------------------------------------------------------------------------------

/     flood

/

*----------------------------------------------------------------------------------------
t     time - years
*----------------------------------------------------------------------------------------

/     1996*2015        20 years - expandable

/

tfirst(t)            starting year
tlast(t)             terminal year
tlater(t)            all years after initial
tmid(t)              mid years
;

tfirst(t) = yes $ (ord(t) eq 1);        // 1st year
tlast(t)  = yes $ (ord(t) eq card(t));  // GAMS language -- picks last pd
tlater(t) = yes $ (ord(t) gt 1);        // picks years after 1
tmid(t)   = yes $ (ord(t) gt 1) and ord(t) le card(t) ;
;

set p    policy

/1-policy_hist, 2-policy_base, 3-policy_new/

set w    water supply

/1-w_supl_base,  2-w_supl_new/


ALIAS (river, riverp);  // river nodes wear multiple hats

display tfirst, tlast, tlater, agdivert;

parameters

ID_adu_p(agdivert,   aguse)   identity matrix connects divert nodes to ag use nodes
ID_arr_p(agr_return, aguse)   identity matrix connects river return nodes to ag use nodes
ID_ara_p(aga_return, aguse)   identity matrix connects aquifer return nodes to ag use nodes

ID_adara_p(agdivert, aga_return)  identity matrix connects ag divert to ag aquifer return nodes

ID_adau_p (agdivert,aguse)        identity matrix connects ag divert to agr use nodes
ID_adarr_p(agdivert,agr_return)   identity matrix connects ag divert to ag river return nodes
ID_adaar_p(agdivert,aga_return)   identity matrix connects ag divert ao ag aquifer return nodes

ID_mdu_p(midivert,   miuse)   identity matrix connects urban divert nodes to use nodes
ID_mrru_p(mir_return,miuse)   identity matrix connects urban riv return nodes to use nodes
ID_mrau_p(mia_return,miuse)   identity matrix connects urban aqf return nodes to use nodes
;

ID_adu_p(agdivert,   aguse) $ (ord(agdivert)   eq ord(aguse)) = 1;
ID_arr_p(agr_return, aguse) $ (ord(agr_return) eq ord(aguse)) = 1;
ID_ara_p(aga_return, aguse) $ (ord(aga_return) eq ord(aguse)) = 1;

ID_adara_p(agdivert,aga_return) $ (ord(agdivert) eq ord(aga_return)) = 1;

ID_mdu_p(midivert,   miuse) $ (ord(midivert)   eq ord(miuse)) = 1;
ID_mrru_p(mir_return,miuse) $ (ord(mir_return) eq ord(miuse)) = 1;
ID_mrau_p(mia_return,miuse) $ (ord(mia_return) eq ord(miuse)) = 1;


ID_adau_p (agdivert,aguse)      $ (ord(agdivert) eq ord(aguse))      = 1;
ID_adarr_p(agdivert,agr_return) $ (ord(agdivert) eq ord(agr_return)) = 1;
ID_adaar_p(agdivert,aga_return) $ (ord(agdivert) eq ord(aga_return)) = 1;

display ID_adu_p, ID_arr_p, ID_ara_p, ID_mdu_p, ID_mrru_p, ID_mrau_p, ID_adara_p
        ID_adau_p, ID_adarr_p, ID_adaar_p;

*-------------------------------- END OF SETS  -----------------------------------------*

*--------------- Section 2 --------------------------------------------------------------
*  This section defines all data in 3 formats                                           *
*  1.  Scalars (single numbers),                                                        *
*  2.  Parameters (columns of numbers) or                                               *
*  3.  Tables (data in rows and columns)                                                *
*---------------------------------------------------------------------------------------*

*  Below follow several maps summarizing the RG Basin's geometry
*  By geometry we mean location of mainstems, tributaries, confluence,
*  source nodes, use nodes, return flow nodes, reservoir nodes, etc.
*  Basin geometry is summarized through judicious use of numbers 1, -1, and 0 (blank)

* --------------------------------------------------------------------------------------
*  Map #1:

*  Each column below is a streamgage.  Each row is a source or use of water.
*  Flow at ea gauge (column) directly influenced by at least 1 upstream row.
*  SOURCE adds to columns flow             (+1)
*  USE deplete from col flow               (-1)
*  BLANK has no effect on col flow         (  )
*  Geometry accounts for all sources (supplies) and uses (demands) in basin

*  Map is used to produce coefficients in equations below to define:
*  X(river) = Bhv * X(inflow) + Bvv * X(river)   + Bdv * X(divert)
*           + Brv * X(return) + BLv * X(rel)
*
*  These B coeff vectors are stacked below as a single matrix, Bv
*----------------------------------------------------------------------------------------------------------

TABLE Bv_p(i,river)    Hydrologic Balance Table    (unitless 0 - 1 dummy)

*----------------------   Column Heads are River Gauges    ------------------------------------------------

                  RG_Caballo_out_v_f   RG_El_Paso_v_f   RG_above_MX_v_f   RG_below_MX_v_f   RG_below_EPID_v_f
* ---------------- headwater inflow node rows (+) ---------------------------------------------------------
Marcial_h_f             1
Wshed_1_h_f             1
* ---------------- river gauge node rows (+) --------------------------------------------------------------
RG_Caballo_out_v_f                           1
RG_El_Paso_v_f                                                  1
RG_above_MX_v_f                                                                   1
RG_below_MX_v_f                                                                                     1
RG_below_EPID_v_f
* --------------- diversion nodes rows  (-)  --------------------------------------------------------------
EBID_d_f                                    -1
LCMI_d_f                                    -1
EPMI_d_f                                                       -1
MX_d_f                                                                           -1
EPID_d_f                                                                                           -1
* -------------- river return flow node rows (+) ----------------------------------------------------------
EBID_rr_f                                    1
LCMI_rr_f                                    1
EPMI_rr_f                                                       1
MX_rr_f                                                                           1
EPID_rr_f                                                                                           1
*---------------- returns to aquifer nodes  (+) ------------------------------------------------------------
EBID_ar_f
LCMI_ar_f
EPMI_ar_f
MX_ar_f
EPID_ar_f
* ------------- reservoir release (outflow) to river -- stock-to-flow rows (+) ----------------------------
Store_rel_f             1
;


*----------------------------------------------------------------------------------------
* agriculture parameters
*----------------------------------------------------------------------------------------
* Map #3:

* Defines use (simplistically) as a percentage of diversion
* X(use) = Bdu * X(divert)
* These B coeffs are shown below as the matrix, Bu

*---------------------------------------------------------------------------------------

Table   Yield_p(aguse,j,k)   Crop Yield (tons per acre)

                  Pecans.flood     Veges.flood  forage.flood
*-------------------------- use node rows (+) ---------------
EBID_u_f            0.58            17.00        8.00
EPID_u_f            0.58            17.00        8.00
*------------------------------------------------------------

Table   Price_p(aguse,j)    Crop Prices ($ per ton)

                   Pecans          Veges        forage
EBID_u_f            4560            300           160
EPID_u_f            4560            300           160


table lan_p(t,j,k,aguse)  land in prodn over all observed historical years (US Bureau of Reclamation Data Zhuping Sheng TAMU El Paso March 6 2017)

         pecans.flood.ebid_u_f  veges.flood.ebid_u_f   forage.flood.ebid_u_f    pecans.flood.epid_u_f    veges.flood.epid_u_f  forage.flood.epid_u_f
1996        18.546                  37.126                  22.026                        8.252                  34.303          11.205
1997        18.759                  36.480                  25.512                        8.390                  33.805          11.232
1998        19.680                  32.851                  26.839                        8.565                  34.006           9.947
1999        20.172                  29.464                  27.209                        8.913                  30.033           8.167
2000        20.324                  31.665                  26.126                       10.673                  27.712          10.239
2001        20.446                  27.097                  24.722                       11.484                  27.362          10.439
2002        20.860                  26.365                  26.692                       11.262                  25.680          13.076
2003        19.494                  21.278                  21.698                       11.466                  21.526           5.119
2004        20.190                  22.299                  16.821                       10.893                  22.323           4.837
2005        20.886                  27.350                  22.511                       10.089                  23.871           4.239
2006        20.263                  23.112                  19.627                       10.829                  21.783           4.490
2007        21.624                  22.850                  23.320                       11.039                  19.088           5.383
2008        23.293                  21.162                  23.933                       11.249                  16.422           5.485
2009        24.060                  17.677                  24.769                       11.611                  29.361           6.215
2010        21.847                  17.629                  20.435                       11.213                  20.256           5.591
2011        24.763                   9.692                   9.638                       12.281                  28.370           6.555
2012        20.567                  11.231                  14.910                       13.477                  26.096           6.110
2013        21.393                  16.623                   9.411                       10.108                  19.572           4.583
2014        31.293                  24.656                  16.668                       10.108                  19.572           4.583
2015        31.391                  25.503                  16.493                       10.108                  19.572           4.583
;

* 2013 epid veges 26.096

parameter land_p(aguse,j,k,t)  land in prodn over all observed historical years (US Bureau of Reclamation Data Zhuping Sheng TAMU El Paso March 6 2017)
;
land_p(aguse,j,k,t)  = lan_p(t,j,k,aguse);
land_p(aguse,j,k,'1996') = eps;  // no acreage in base year

display land_p;

table Bau_p(i,j,k)   water per acre nmsu extension budgets (feet depth) all ag data source FA Ward  J Hydrology 2014 vol 508: pp 114-127

                    Pecans.flood   Veges.flood      forage.flood
*------------------------ apply node rows (+) ------------------------
EBID_d_f              5.5             3.0             3.0
EPID_d_f              5.5             3.0             3.0
*-------------------------- use node rows (+) ------------------------
EBID_u_f              5.5             3.0             3.0
EPID_u_f              5.5             3.0             3.0
*----------------------- return flow node rows (+)--------------------
EBID_rr_f             0.0             0.0             0.0
EPID_rr_f             0.0             0.0             0.0
*------------------------aquifer return flow node rows (+) -----------
EBID_ar_f             0.0             0.0             0.0
EPID_ar_f             0.0             0.0             0.0
*---------------------------------------------------------------------
;

Bau_p(aguse,     j,k)   =     1.00 *  sum(agdivert, ID_adu_p  (agdivert,     aguse) * Bau_p(agdivert, j,k));      // 100% of diversions used - not returned to river
Bau_p(agr_return,j,k)   =     0.00 *  sum(agdivert, ID_adarr_p(agdivert,agr_return) * Bau_p(agdivert, j,k)) ;     //  0% of surface diversions applied return to river
Bau_p(aga_return,j,k)   =     0.00 *  sum(agdivert, ID_adara_p(agdivert,aga_return) * Bau_p(agdivert, j,k)) ;     //  0% of surface diversions applied return to aquifer


table Ba_divert_p(agdivert,j,k)  diversions     (feet depth)

                   Pecans.flood     Veges.flood      forage.flood
* -------------------------- apply node rows -------------------------
EBID_d_f              5.5              3.0             5.0
EPID_d_f              5.5              3.0             5.0
* --------------------------------------------------------------------
;
*$ontext

table Ba_use_p(use,j,k)        use            (feet depth)

                   Pecans.flood     Veges.flood     forage.flood
* -------------------------- use node rows ---------------------------
EBID_u_f              5.5              3.0             5.0
EPID_u_f              5.5              3.0             5.0
* --------------------------------------------------------------------

table Bar_return_p(r_return,j,k) river return flows    (feet depth)

                    Pecans.flood    Veges.flood      forage.flood
* --------------------------------------------------------------------
EBID_rr_f              0.0              0.0             0.0
EPID_rr_f              0.0              0.0             0.0
* --------------------------------------------------------------------

table  Baa_return_p(aga_return,j,k) aquifer return flows  (feet depth)

                    Pecans.flood    Veges.flood      forage.flood
* --------------------------------------------------------------------
EBID_ar_f              0.0              0.0             0.0
EPID_ar_f              0.0              0.0             0.0
* --------------------------------------------------------------------
;

*overrides above coefficients quickly

Ba_use_p    (aguse,     j,k) =   0.75 * sum(agdivert, ID_adau_p (agdivert,aguse)      * Ba_divert_p(agdivert,j,k));    // 75% of diversions applied are consumed by crop (ET)
Bar_return_p(agr_return,j,k) =   0.00 * sum(agdivert, ID_adarr_p(agdivert,agr_return) * Ba_divert_p(agdivert,j,k));    //  0% of surface diversions applied return to river
Baa_return_p(aga_return,j,k) =   0.25 * sum(agdivert, ID_adaar_p(agdivert,aga_return) * Ba_divert_p(agdivert,j,k));    // 25% of surface diversions applied return to aquifer


table Bag_pump_aqf_return_p(aguse,j,k)   proportion of ag water pumped recharging aquifer (proportion)

                    Pecans.flood    Veges.flood     forage.flood
EBID_u_f               0.20           0.20            0.20
EPID_u_f               0.20           0.20            0.20
;


Table  Cost_p(aguse,j,k)     Crop Production Costs  ($ per acre)

                      Pecans.flood   Veges.flood     forage.flood
*-------------------------- use node rows (+) ------------------------
EBID_u_f               1700            4200            820
EPID_u_f               1700            4200            820
*---------------------------------------------------------------------
;

table ag_gw_pump_capacity_p(aqf,aguse)  ag pumping capacity in acre feet per year by aquifer

                  ebid_u_f       epid_u_f
Mesilla_aqf_s       150             0
Hueco_aqf_s           0            50

// annual pump capacity ebid growers citation: xxxxx
// annual pump capacity epid growers citation: xxxxx

parameter

ag_av_gw_cost_p(aguse)   average irrigation costs of pumping gw ($ per a-f)
;
ag_av_gw_cost_p(aguse)   =  90; // Source EBID consultant Phil King, NMSU March 2013
;

Parameter Netrev_acre_p(aguse,j,k)  net revenue per acre obs in base year price x yield - cost  ($ per acre)
;

Netrev_acre_p(aguse,j,k) = Price_p(aguse,j) * Yield_p(aguse,j,k) - Cost_p(aguse,j,k);

Display price_p, yield_p, cost_p, Netrev_acre_p;

*-----------------------------------------------------------------------------------------------------
*                           Positive Mathematical Programming Parameters                             *
*-----------------------------------------------------------------------------------------------------
* Positive Mathematical Programming (PMP) parameters derived below.
* Based on 2 articles:
*   Richard Howitt Positive Mathematical Programming Am J Agricultural Economics 1995

*   F. Ward and Macarena Dagnino IJWRD 2012 Agricultural Water Conservation
*   International Journal of Water Resources Development Volume 28,  Issue 4, 2012
*   Economics of Agricultural Water Conservation: Empirical Analysis and Policy Implications
*-----------------------------------------------------------------------------------------------------

* Model has 2 parameters that force (calibrate) optimized acreage and yields to match historical baseline
* This calibration sets the foundation for a quadratic programming model in which all constraints
* to the observed crop mix are removed...known as smooth pasting
*
*  1.   price of land/water equals declining value of marginal product under assumed profit max
*  2.   base land and water constraints are respected
*  3.   Historical data on average profitability, land in production, crop mix, and yield are reproduced
*
* PMP ensures smooth adjustments to future water supply or policy changes

parameter
B0_p(aguse,j,k,t)     intercept term in crop-water prodn fn forces vmp of water = water price     (tons per acre)
B1_p(aguse,j,k,t)     linear term does the same (<0) Greater land in production reduces ave yield (tons per 1000 acres)
;

B1_p(aguse,j,k,tlater)   =  -Netrev_acre_p(aguse,j,k) / [Price_p(aguse,j) * Land_p(aguse,j,k,tlater)]; // For profit max, higher obs net rev per ac brings more acreage to reduce yields
B0_p(aguse,j,k,tlater)   =   Yield_p(aguse,j,k) - B1_p(aguse,j,k,tlater)  * Land_p(aguse,j,k,tlater);

display B1_p, B0_p;

*----------------------- end of ag --------------------------------------------------
*-------------- urban water use parameters ------------------------------------------

parameter

elast_p         (miuse)   urban price elasticity of demand     (unitless)
urb_price_p     (miuse)   urban base price of water            ($1000   \ 1000 af)
urb_use_p       (miuse)   urban base water customer deliveries (1000 af \ yr)
urb_Av_cost0_p  (miuse)   urban average cost of supply         ($      \  af)
urb_cost_grow_p (miuse)   urban average cost growth rate       (prop \ year)

elast_p(miuse)

/LCMI_u_f   -0.32
 epmi_u_f   -0.32/         // el paso water study (fullerton) source:  http://www.waterrf.org/resources/Lists/ProjectPapers/Attachments/61/4501_ProjectPaper.pdf
                           // no las cruces elasticity estimates available to date
urb_price_p(miuse)

/LCMI_u_f   851.14
 epmi_u_f   851.14/       // el paso water utilities pricing source Dec 28 2015:  http://www.epwu.org/whatsnew/pdf/Survey.pdf

urb_use_p(miuse)

/LCMI_u_f   19.71
 epmi_u_f  118.50/
;                         //  Source:  demouche landfair ward nmwrri tech completion report 256 2010 page 11 demands for year 2009 las cruces water utility
                          //  http://www.wrri.nmsu.edu/publish/techrpt/tr356/tr356.pdf
                          //  published in the international journal of water resources development
                          //  Water Resources Development, Vol. 27, No. 2, 291?314, June 2011
                          //  118,500 acre feet supplied from Rio Grande, Hueco Bolson, Mesilla Aquifer, and Kay Baily Hutchinson Desal Plant
                          //  source is http://www.epwu.org/water/water_resources.html


parameter pop0_p(miuse)     urban water buying households (1000s)

/LCMI_u_f     32.303
 epmi_u_f    194.212/
                          //  el paso water production source dec 28 2015:  http://www.epwu.org/water/water_resources.html
                          //  http://www.epwu.org/water/water_stats.html  194,274 customer household customers: 2012

;

parameter use_per_cap_obs_p(miuse)   observed per capita use in base year
;

use_per_cap_obs_p(miuse) = urb_use_p(miuse) / pop0_p(miuse)

display use_per_cap_obs_p;


parameter rho_pop_p(miuse)    population growth rate per year data source EP water utilities web page
                             // http://www.epwu.org/water/water_resources.html
                             // las cruces 40 year water plan March 2017 http://www.wrri.nmsu.edu/publish/techrpt/tr356/tr356.pdf
/LCMI_u_f   0.0190
 epmi_u_f   0.0101/
;

parameter pop_p(miuse,t)    population by year
;

pop_p(miuse,t) $ (ord(t) eq 1) = pop0_p(miuse);
pop_p(miuse,t) $ (ord(t) ge 2) = pop0_p(miuse) * (1 + rho_pop_p(miuse)) ** (ord(t) - 2);

display pop0_p, rho_pop_p, pop_p;


parameter

urb_av_cost0_p(miuse)

/LCMI_u_f  851.14
 epmi_u_f  851.14/        // el paso water utilities pricing source Dec 28 2015:  http://www.epwu.org/whatsnew/pdf/Survey.pdf

urb_cost_grow_p(miuse)

/LCMI_u_f  0.02
 epmi_u_f  0.02/          // 2% per year growth in urban average cost of supply

urb_av_gw_cost0_p(miuse)   // av cost of aquifer pumping urban excluding treatment

/LCMI_u_f  30.00
 epmi_u_f  30.00/

urb_gw_cost_grow_p(miuse)

/LCMI_u_f  0.00
 epmi_u_f  0.00/
;

table urb_gw_pump_capacity_p(aqf, miuse)   approximate pumping capacity by urban area

                 LCMI_u_f    epmi_u_f
mesilla_aqf_s       40         12
hueco_aqf_s         eps        60
;


* LC 2015 pumping 30-40 KAF per year from LC Water Plan sent by Bill Hargrove March 20 2017

* ep rgr surface treatment capacity  = 60K af per year
* ep pumping capacity (hueco) approx = 60K af per year
* ep pumping capacity (mesilla) approx 12K af per year
* both data sources are at http://www.epwu.org/water/water_resources.html

parameter

urb_av_cost_p   (miuse,t) future urban ave cost
urb_av_gw_cost_p(miuse,t) future urban ave gw pump cost
;

urb_av_cost_p   (miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_cost0_p(miuse);
urb_av_cost_p   (miuse,t) $ (ord(t) ge 2) =        urb_av_cost0_p(miuse)    * (1 + urb_cost_grow_p(miuse))   ** (ord(t) - 2);

urb_av_gw_cost_p(miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_gw_cost0_p(miuse);
urb_av_gw_cost_p(miuse,t) $ (ord(t) ge 2) =        urb_av_gw_cost0_p(miuse) * (1 + urb_gw_cost_grow_p(miuse)) ** (ord(t) - 2);

display urb_av_cost0_p, urb_av_cost_p, urb_av_gw_cost0_p, urb_av_gw_cost_p;


parameter
BB1_base_p (miuse  )     Slope of observed urban demand function based on observed use and externally estimated price elasticity of demand
BB1_p      (miuse,t)     flattening slope of price-dependent urban demand function with growing population
BB0_p      (miuse  )     Intercept for urban price-dependent demand function
;

BB1_base_p(miuse  )   =  urb_price_p (miuse)  /  [elast_p (miuse) * urb_use_p(miuse)];  // intercept parameter to run base price-dependent demand function through observed price and use
BB0_p     (miuse  )   =  urb_price_p (miuse) - BB1_base_p (miuse) * urb_use_p(miuse);   // intercept parameter for the same thing
BB1_p     (miuse,t)   =  BB1_base_p  (miuse) * [pop_p (miuse,'1996') / pop_p(miuse,t)];  // higher urb population has lower price slope - future demand pivots out with higher pop


display urb_price_p, elast_p, BB0_p, BB1_p, bb1_base_p ;

*--------------------- END OF URBAN WATER SUPPLY PARAMETERS -----------------------------

* ------------------------------- RESERVOIR BASED RECREATION PARAMETERS -----------------

PARAMETER

B0_rec_ben_p(res)  interecept in rec benefits power benefits function

/store_res_s   1500/

B1_rec_ben_p(res)  exponent in rec benefits power benefits function

/store_res_s    0.5/


* ------------------------------- END RESERVOIR BASED RECREATION PARAMETERS -------------


* ------------------------------- ENVIRONMENTAL FLOW PARAMETERS ------------------------

B0_env_flow_ben_p(river)  intercept in env flow benefits power function

/ RG_below_EPID_v_f      1000/

B1_env_flow_ben_p(river)  exponent in env flow benefits power function

/ RG_below_EPID_v_f      0.1/

* ------------------------------- END OF ENVIRONMENTAL FLOW PARAMETERS ------------------


*------------------- INSTITUTIONAL CONSTRAINTS FOLLOW  ----------------------------------

scalar us_mx_1906_p   US MX 1906 treaty flows (1000 af pr year)                   / 60  /  //  https://en.wikipedia.org/wiki/International_Diversion_Dam
scalar tx_proj_op_p   RGR project operation: TX proportion of SAN MARCIAL FLOWS  / 0.43/   //  Burec project operating history 1953 - 1977

// announced jan 2017 http://www.houstonchronicle.com/news/texas/article/Feds-issue-decision-on-operating-plan-for-Rio-10839313.php

scalar sw_sustain_p   terminal sustainability proportion of starting sw storage  / 0.25/

parameter gw_sustain_p(aqf) proportion of aquifer capacity required for terminal year

/Mesilla_aqf_s    1.00
 Hueco_aqf_s      1.00/

display gw_sustain_p;

*----------------------------------------------------------------------------------------
* Map #4:

* Table defines relation between diversions and return flow nodes
* for urban and Mexico use
*
* Tabled entries = proportion return flow by diversion column nodes
*    (+)  means the row diversion contributes to column's ret flow
*    ( )  means the column diversion makes no cont to row's ret flow

*X(return) = Br * X(divert)
*----------------------------------------------------------------------------------------

TABLE Bmdu_p(midivert, miuse)    urban water use as a proportion of diversions

                LCMI_u_f       EPMI_u_f
LCMI_d_f          1.0
EPMI_d_f                        1.0

TABLE Bmdr_p(midivert, mir_return)    urban return to river as a proportion of divert

                LCMI_rr_f       EPMI_rr_f
LCMI_d_f          0.0
EPMI_d_f                         0.0

TABLE Bmda_p(midivert, mia_return)    urban return to river as a proportion of divert

                LCMI_ar_f       EPMI_ar_f
LCMI_d_f          0.0
EPMI_d_f                         0.0

TABLE Bmxdu_p(mxdivert, mxuse)     MX use as a proportion of MX diversion

              MX_u_f
MX_d_f         1.0


TABLE Bmxdr_p(mxdivert, mxr_return)  MX return to river system as a proportion of MX diversions

              MX_rr_f
MX_d_f         0.0

TABLE Bmxda_p(mxdivert, mxa_return)  MX return to aquifer system as a proportion of MX diversions

              MX_ar_f
MX_d_f         0.0
;

*----------------------------------------------------------------------------------------
* Map #5:

* Table relates reservoir stocks in a period to its prev periods' stocks minus releases.
* For any reservoir stock node at the column head
*   (+1) :added water at flow node -- thru releases -- takes from column's res stock (-)
*   (-1) :added water at flow node adds to column's reservoir stock
*   (  ) :added water at flow node has no effect on column's reservoir stock

* Z(res(t)) = Z(res(t-1)) + BLv * X(rel(t))
*---------------------------------------------------------------------------------------*

TABLE BLv_p(rel, u)         Links reservoir releases to downstream flows

*-------- Column Heads are Reservoir Stocks -- rows are release flows  ------------------
*-------- Table = diagonal matrix for > 1 reservoir--only 1 for now    ------------------

                     Store_res_s
      Store_rel_f        1
;
*----------------------------------------------------------------------------------------
*  END OF BASIN GEOMETRY MAPS                                                           *
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------------------
* NEXT ARE BASIN INFLOWS, OTHER FLOWS, FLOW RELATIONSHIPS, AND                          *
* RESERVOIR STARTING VOLUMES, SIMPLE ECONOMIC VALUES PER AC FT WATER USE                *
*----------------------------------------------------------------------------------------

* all water flows  measured in 1000s acre feet per yer
* all water stocks measured in 1000s acre feet instantaneous volume

TABLE sourc_p(inflow,t)  annual basin inflows at headwaters -- snowpack or rain (1000 af \ year)

*----------------------------------------------------------------------------------------
*----     Data are from historical or forecast headwater node flows    ------------------
*----------------------------------------------------------------------------------------

* observed annual water supply from usgs gauging station - 1000 af per year at San Marcial Gauge
* (floodway)              https://waterdata.usgs.gov/usa/nwis/inventory/?site_no=08358400&agency_cd=USGS
* (conveyance channel)    https://waterdata.usgs.gov/nm/nwis/uv?site_no=08358300

                  1996    1997    1998    1999    2000    2001    2002    2003    2004    2005    2006    2007    2008    2009    2010    2011    2012    2013    2014    2015
Marcial_h_f        524     943     919     871     461     482     260     206     377     959     485     648     911     701     550     302     316     253     339     402
Wshed_1_h_f
;

Sourc_p('Wshed_1_h_f',t) = eps;   // placeholder data set to zero until estimated watershed inflows at several points from the watershed inflow team (D. Gutzler and A Mayer)

display sourc_p;


parameter source_p(inflow,t,w) annual basin inflows at headwaters with water supply scenario added
;
source_p(inflow,t,'1-w_supl_base') = 1.00 * sourc_p(inflow,t);   // base inflow scenario
source_p(inflow,t,'2-w_supl_new')  = 0.90 * sourc_p(inflow,t);   // new inflow scenario

display source_p;


TABLE gaugeflow_p(river,t)  annual historical gauged streamflows (1000 af \ year)

* source is http://www.ibwc.state.gov/water_data/histflo1.htm
* https://waterdata.usgs.gov/nwis/annual?referred_module=sw&search_site_no=08362500&format=sites_selection_links    march 6 2017

                     1996    1997   1998    1999    2000    2001    2002    2003    2004    2005    2006    2007     2008    2009    2010    2011    2012    2013    2014     2015
RG_Caballo_out_v_f    820    763    817     728     756     791     802     389     398     654     444     611      670     725     665     403     371     168      400     400
;

*2013 168

*1961       1962       1963       1964       1965       1966       1967       1968       1969       1970       1971       1972       1973       1974       1975       1976       1977
*562        652        517        206        506        610        457        504        668        661        499        260        617        641        580        678        418

*1978       1979       1980       1981       1982       1983       1984       1985       1986       1987       1988       1989       1990       1991       1992       1993       1994    1995
*356        569        657        608        644        647        649        660        1066       1692       856        750        680        604        722        828        869     1094

*1996       1997       1998       1999       2000       2001       2002       2003       2004       2005       2006       2007        2008       2009       2010       2011       2012       2013
*820        763        817        728        756        791        802        389        398        654        444        611         670        725        665        403        371        168


table z_p(u,t)     Rio Grande project storage on RG

             1996        1997        1998        1999        2000        2001        2002       2003        2004        2005        2006        2007        2008        2009        2010        2011        2012        2013        2014        2015
Store_res_s  2204.700    1761.210    1972.060    1740.620    1751.550    1307.240    923.740    388.740     223.150     217.870     446.060     558.630     433.570     658.800     550.423     453.620     308.997     169.662     294.713     271.933
;


table residdd_p(u,t)    residual from observed storage

                 1996    1997      1998      1999       2000       2001       2002      2003      2004      2005
store_res_s      0.00   -446.17   307.40    -199.20     482.28    -3.70      251.50   -312.86   -122.12    -288.35

+
                 2006     2007     2008     2009    2010      2011      2012     2013       2014      2015
store_res_s      232.10   131.81  -322.40   315.55  62.04     49.87    -58.51   -207.26     215.73    2.60
;


parameter residd_p(u,t,p)    residual from constrained optimization model
;
residd_p(u,t,'1-policy_hist')  = residdd_p(u,t);  // historical policy replicates historical data by adding adjustments to constrained optimizaiton
residd_p(u,t,'2-policy_base')  = residdd_p(u,t);  // 0 residual for non historical runs;
residd_p(u,t,'3-policy_new')   = residdd_p(u,t);  // ditto

parameter

Xv_lb_p(t)  lower bound on caballo stream gauge flow compared to historical
Xv_ub_p(t)  upper bound on caballo stream gauge flow compared to historical

;

Xv_lb_p(t) = 1.00;   // lower bound 1.0 matches history
Xv_ub_p(t) = 1.00;   // upper bound 1.0 matches history

PARAMETER

* reservoir stocks

z0_p  (res,p)   initial reservoir levels at reservoir stock nodes  (1000 af)
zmax_p(res)     maximum reservoir storage capacity                 (1000 af)
;

z0_p  ('Store_res_s','1-policy_hist')   = 1.00 * 2204.7;   // historical starting level
z0_p  ('Store_res_s','2-policy_base')   = 1.00 * 2204.7;   // base starting level water surface stock usgs data 1996
z0_p  ('Store_res_s','3-policy_new')    = 0.90 * 2204.7;   // alternative starting level  water surface stock

* Starting storage for elephant butte plus caballo usgs data source january 1 1996
* https://pubs.usgs.gov/wdr/1996/nm-96-1/report.pdf
* ebutte   2043100 af
* caballo   161600 af

display Z0_p;

zmax_p('store_res_s')   = 2544;    // max project storage

parameter

* aquifer stocks

q0_p      (aqf  )  initial aquifer level at aquifer stock nodes in yr 1       (1000 af)
qmax_p    (aqf  )  max aquifer storage cpacity                                (1000 af)
aq_area_p (aqf  )  area overlying aquifer                                     (1000 ac)
recharge_P(aqf,t)  annual aquifer recharge                                    (1000 af \ yr)
porosity_p(aqf  )  average porosity (void ratio)                              (unitless)
;
porosity_p('mesilla_aqf_s') = 0.10;    // Hawley below, page 85
porosity_p('Hueco_aqf_s'  ) = 0.178;   // Heywood citation below page 28

aq_area_p('mesilla_aqf_s')  = 7040;   // land area over Mesilla Bolson 1000 acres - NM WRRI report 332 page 7, equals 11,100 sq miles
aq_area_p('Hueco_aqf_s')    = 2668;   // land area over Hueco Transboundary Aquifers and Binational Ground Water Database For the City of El Paso / Ciudad Juarez Area
                                      // http://www.ibwc.state.gov/water_data/binational_waters.htm  10,800 square km cited in IBWC study January 1998

q0_p     ('Mesilla_aqf_s') = 45000;   // starting storage Mesilla Aquifer in 1996 based on historical pumping
q0_p     ('Hueco_aqf_s')   =  7000;   // starting storage Hueco    Bolson in 1996 based on historical pumping

qmax_p('Mesilla_aqf_s')    = 50000;    // max useable freshwater storage capacity Mesilla Aquifer: Source is Hawley and Kennedy, page 85

* 1.  John Hawley invited seminar NMSU Water Science and management Graduate Student Organizaiton: NMSU Corbett Center November 2016
* 2.  Bob Creel June 6 2007: Groundwater Resources of the las Cruces Dona Ana County region: slideshow on the web at
*       http://www.las-cruces.org/~/media/lcpublicwebdev2/site%20documents/article%20documents/utilities/water%20resources/groundwater%20resources%20wrri%20presentation.ashx?la=en

qmax_p('Hueco_aqf_s')     =  9000;    //  max storage capacity TX Hueco Bolson: data source  http://www.epwu.org/water/hueco_bolson/ReviewTeamReport.pdf
                                      //  Bredhoeft et al March 2004 page 4
                                      //  Review Interpretation of the Hueco Bolson Groundwater Model

recharge_p('mesilla_aqf_s',t) =  10.80;  // 10K af-year recharge Mountain Front recharge data source: Hawley and Kennedy:  Source Below
recharge_p('hueco_aqf_s',  t) =  10.94;  // 10.94 K af / yr recharge Mountain Front + artificial recharge:                 Source below

* MESILLA:
* John W Hawley and John F Kennedy
* Creation of a Digital Hydrogeological Framework Model of the Mesilla Basin and Southern Jorndaa Del Muerto Basin
* June 2004 NM WRRI report 332
* pp 69-70
* http://www.wrri.nmsu.edu/publish/techrpt/abstracts/abs332.html    web posted address as of Jan 21 2017

* HUECO:
* Charles E. Heywood and Richard M. Yager
* Simulated Ground-Water Flow in the Hueco  Bolson, an Alluvial-Basin Aquifer System   near El Paso, Texas
* Prepared in cooperation with  EL PASO WATER UTILITIES and the U.S. ARMY - FORT BLISS
* Albuquerque, NM 2003
* https://pubs.usgs.gov/wri/wri02-4108/pdf/wrir02-4108.pdf         web posted address as of Jan 21 2017

display recharge_p;

scalars

precip_rat_p     reservoir precip (feet gained per exposed acre per year)                               /0.97/       // data source historic precip data near Truth or Consequences NM
Evap_rat_p       reservoir evaporation  (feet loss per exposed acre per year)                           /7.682/       // data source selected New Mexico water reports
B1_area_vol_p    impact of changes in volume on changes in area (acres per 1000 ac feet)                /0.015/      // data source linear regression on area capacity relations
B2_area_volsq_p  impact of changes in volume squared on changes in area (acres per 1000 ac ft squared)  / eps/

parameters

evap_rate_p(t)    evaportation rate by year
precip_rate_p(t)  precip rate by year
;
evap_rate_p(t)        = evap_rat_p;
*evap_rate_p('1997')   = evap_rat_p + 16 + 0.889;     // model calibration for overprediction of storage

precip_rate_p(t)      = precip_rat_p;
*precip_rate_p('1998') = precip_rat_p + 11 - 1 + 0.392;         // model calibration for underprediction of storage


*----------------------------------------------------------------------------------------
*  Land  Block
*----------------------------------------------------------------------------------------

parameters

LANDRHS_p(aguse)           land available by irrigation district        (1000 acres)

/
  EBID_u_f              90
  EPID_u_f              55
/

*----------------------------------------------------------------------------------------
*  Surface Water Block
*----------------------------------------------------------------------------------------

SW_Treat_capac_p(miuse)    surface water treatment capacity for urban use  (1000 acre feet)

/
  LCMI_u_f              0
  EPMI_u_f              60
/

*  EP urban = 60,000 AF per year surface treatment capacity
*  LC urban = 0                  surface treatment  capacity
// data http://www.epwu.org/water/hueco_bolson/2.0ElPasoWaterSupply.pdf

;

display LANDRHS_p;

*--------------- Section 3 --------------------------------------------------------------
*  These endogenous (unknown) variables are defined                                     *
*  Their numerical values are not known til GAMS finds optimal soln                     *
*----------------------------------------------------------------------------------------

POSITIVE VARIABLES

Z1_v           (u,        t,p,w)     water stocks -- reservoirs                       (L3 \ yr)   (1000 af by yr)

Z_v            (u,        t,p,w)     modified water stocks


Q_v            (aqf,      t,p,w)     aquifer storage volume                           (L3 \ yr)   (1000 af by yr)

Aquifer_depth_v(aqf,      t,p,w)     aquifer depth                                    (L  \ yr    (feet by year)

Evaporation_v  (res,      t,p,w)     reservoir surface evaporation                    (L3 \ yr)   (1000 af \ yr)
Precip_v       (res,      t,p,w)     reservoir surface precipation                    (L3 \ yr)   (1000 af \ yr)
surf_area_v    (res,      t,p,w)     reservoir surface area                           (L2 \ yr)   (1000 ac \ yr)

SWacres_v      (aguse,j,k,t,p,w)     acres land in prodn                              (L2 \ yr)   (1000 ac \ yr)
GWAcres_v      (aguse,j,k,t,p,w)     groundwater land in prodn                        (L2 \ yr)   (1000 ac \ yr)
Tacres_v       (aguse,j,k,t,p,w)     total acres (sw + gw)                            (L2 \ yr)   (1000 ac \ yr)
tot_acres_v    (aguse,    t,p,w)     total acres land over crops                      (L2 \ yr)   (1000 ac \ yr)

Ag_use_v       (aguse,    t,p,w)     irrigation surface water use                     (L3 \ yr)   (1000 af \ yr)
ag_pump_v  (aqf,aguse,j,k,t,p,w)     agricultural pumping                             (L3 \ yr)   (1000 af \ yr)
tot_ag_pump_v(aqf,aguse,  t,p,w)     total ag pumping over crops and techs            (L3 \ yr)   (1000 af \ yr)

Ag_pump_aq_rch_v(aqf,aguse,t,p,w)     ag pumping that contributes to aqf recharge      (L3 \ yr)   (1000 af \ yr)

Aga_returns_v (aga_return,t,p,w)     ag return flows to aquifer                       (L3 \ yr)   (1000 af \ hr)


tot_ebid_pump_v(          t,p,w)     total ag pumping ebid nm                         (L3 \ yr)   (1000 af \ yr)
tot_epid_pump_v(          t,p,w)     total ag pumping epid tx                         (L3 \ yr)   (1000 af \ yr)

urb_use_v      (miuse,    t,p,w)     urban water use                                  (L3 \ yr)   (1000 af \ yr)
urb_pump_v     (aqf,miuse,t,p,w)     urban water pumping                              (L3 \ yr)   (1000 af \ yr)

yield_v        (aguse,j,k,t,p,w)     crop yield                                                   (tons    \ ac)

VARIABLES

*hydrology block

X_v            (i,        t,p,w)     flows -- all kinds                               (L3 \ yr)   (1000 af \ yr)

* urban economics block

urb_price_v    (miuse,    t,p,w)     urban price                                      ($US per af)
urb_con_surp_v (miuse,    t,p,w)     urban consumer surplus                           ($US 1000 per year)
urb_use_p_cap_v(miuse,    t,p,w)     urban use per customer                           (af \ yr)
urb_revenue_v  (miuse,    t,p,w)     urban gross revenues from water sales            ($US 1000 per year)
urb_gross_ben_v(miuse,    t,p,w)     urban gross benefits from water sales            ($US 1000 per year)
urb_costs_v    (miuse,    t,p,w)     urban costs of water supply                      ($US 1000 per year)
urb_value_v    (miuse,    t,p,w)     urban net economic benefits                      ($US 1000 per year)

Urb_value_af_v (miuse,    t,p,w)     urban economic benefits per acre foot            ($US per acre foot)
urb_m_value_v  (miuse,    t,p,w)     urban marginal benefits per acre foot            ($US per acre foot)

* ag economics block

Ag_costs_v     (aguse,j,k,t,p,w)     ag production costs (sw + gw)                    ($US 1000 \ yr)
Ag_value_v     (aguse,j,k,t,p,w)     ag net economic value (sw + gw)                  ($US 1000 \ yr)

* economics block all uses

Netrev_acre_v  (aguse,j,k,t,p,w)     ag net revenue per acre                          ($1000 \ yr)
Ag_Ben_v       (use,      t,p,w)     net income over crops by node and yr             ($1000 \ yr)
T_ag_ben_v     (            p,w)     Net income over crops nodes and yrs              ($1000 \ yr)

Env_ben_v      (river,    t,p,w)     enviornmental benefits by year                   ($1000 \ yr)
rec_ben_v      (res,      t,p,w)     reservoir recreation benefits by year            ($1000 \ yr)

Tot_ag_ben_v     (        t,p,w)     Total ag benefits by year                        ($1000 \ yr)
Tot_urb_ben_v    (        t,p,w)     Total urban benefits by year                     ($1000 \ yr)
Tot_env_riv_ben_v(        t,p,w)     Total river environmental benefits by year       ($1000 \ yr)
Tot_rec_res_ben_v(        t,p,w)     Total recreation reservoir benefits by year      ($1000 \ yr)

Tot_ben_v        (        t,p,w)     total benefits over uses by year                 ($1000 \ yr)

DNPV_ben_v       (          p,w)     discounted NPV over uses and years               ($1000)

DNPV_ben_phist_wbase_v               dnpv historical policy base water supply         ($1000)
DNPV_ben_phist_wnew_v                dnpv historical policy new water supply          ($1000)

DNPV_ben_pbase_wbase_v               dnpv base policy base water supply               ($1000)
DNPV_ben_pbase_wnew_v                dnpv base policy new  water supply               ($1000)

DNPV_ben_pnew_wbase_v                dnpv new  policy base water supply               ($1000)
DNPV_ben_pnew_wnew_v                 dnpv new  policy new  water supply               ($1000)

*marginal values
Ag_m_value_v   (aguse,j,k,t,p,w)     ag marginal benefit                              ($US \ ac-ft)
;

*--------------- Section 4 -------------------------------------------------------------*
*  The following equations state relationships among a basin's                          *
*  hydrology, institutions, and economics                                               *
*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*----

EQUATIONS

*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*----
* Equations named
*-----*-----*----------------------------------------------------------------------------

* Land Block

Land_e         (aguse,    t,p,w)       Acres land                                    (L2 \ t)       (1000 ac \ yr)
Tacres_e       (aguse,j,k,t,p,w)       total acres in prodn (sw + gw)                (L2 \ t)       (1000 ac \ yr)
acres_pump_e   (aguse,j,k,t,p,w)       acres pumped (gw only)                        (L2 \ T)       (1000 ac \ yr)

* crop yield block

Yield0_e       (aguse,j,k,t,p,w)       Crop yield initial period                                       (tons \ ac)
Yield_e        (aguse,j,k,t,p,w)       Crop yield later periods                                        (tons \ ac)

* Hydrology Block

Inflows_e      (inflow,   t,p,w)       Flows: set source nodes                       (L3 \ T)       (1000 af \ yr)
Rivers_e       (i,        t,p,w)       Flows: mass balance by node                   (L3 \ T)       (1000 af \ yr)

Evaporation_e  (res,      t,p,w)       Flows: Evaporation by reservoir               (L3 \ T)       (1000 af \ yr)
Precip_e       (res,      t,p,w)       Flows: precip by reservoir                    (L3 \ T)       (1000 af \ yr)

Surf_area_e    (res,      t,p,w)       Flow: surface area by reservoir               (L2 \ T)       (1000 ac \ yr)

Agdiverts_e    (agdivert,  t,p,w)      Flows: defines ag diverted water from acres   (L3 \ T)       (1000 af \ yr)
Agr_Returns_e  (agr_return,t,p,w)      Flows: defines ag riv return flows from acres (L3 \ T)       (1000 af \ yr)
Aga_Returns_e  (aga_return,t,p,w)      Flows: defines ag aq return flows from acres  (L3 \ T)       (1000 af \ yr)
AgUses_e       (aguse,     t,p,w)      Flows: defines use flows based on acreage     (L3 \ T)       (1000 af \ yr)
Ag_use_e       (aguse,     t,p,w)      Flows: ag water use in readable format        (L3 \ T)       (1000 af \ yr)

MIr_Returns_e  (mir_return,t,p,w)      Flows: defines mi return flows based on acres (L3 \ T)       (1000 af \ yr)
MIUses_e       (miuse,    t,p,w)       Flows: defines mi use flows based on urb pop  (L3 \ T)       (1000 af \ yr)

MXUses_e       (mxuse,    t,p,w)       Flows: defines mexico return flows from acres (L3 \ T)       (1000 af \ yr)
MXr_Returns_e  (mxr_return,t,p,w)      Flows: defines mexico use  based on urb pop   (L3 \ T)       (1000 af \ yr)

reservoirs0_e  (res,      t,p,w)       Stock: starting reservoir level in base year  (L3 \ T)       (1000 af)
reservoirs_e   (res,      t,p,w)       Stock:  modified

aquifers0_e    (aqf,      t,p,w)       Stock: starting aquifer level in base yr      (L3 \ T)       (1000 af)

aquifer_storage_m_e(      t,p,w)       Stock: mesilla aquifer                        (L3 \ T)       (1000 af \ yr)
aquifer_storage_h_e(      t,p,w)       Stock: Hueco bolson                           (L3 \ T)       (1000 af \ yr)

*aquifer_stock_e(aqf,      t,p,w)

aquifer_depth_e(aqf,      t,p,w)       State: aquifer depth by aquifer               (L  \ T)       (feet \ yr)
tot_ag_pump_e  (aqf,aguse,t,p,w)       Flows: total ag pumping by node and year      (L3 \ T)       (1000 af \ yr)

Ag_m_pump_aq_rch_e(       t,p,w)       Flows: ag pumping that recharges aqf mesilla  (L3 \ T)       (1000 af \ yr)
Ag_h_pump_aq_rch_e(       t,p,w)       Flows: ag pumping that recharges aqf hueco    (L3 \ T)       (1000 af \ yr)

*aquifer_storage_e(aqf,    t,p,w)       Stocks: aquifer storage                       (L3 \ T)       (1000 af \ yr)

*urban use block

urb_price_e    (miuse,    t,p,w)       urban water price                                            ($US      \ af)
urb_con_surp_e (miuse,    t,p,w)       urban consumer surplus                                       ($US 1000 \ yr)
urb_use_p_cap_e(miuse,    t,p,w)       urban use per customer                        (L3 \ T)       (af\ yr)
urb_revenue_e  (miuse,    t,p,w)       urban gross revenues from water sales                        ($US 1000 \ yr)
urb_gross_ben_e(miuse,    t,p,w)       urban gross benefits from water sales                        ($US 1000 \ yr)
urb_costs_e    (miuse,    t,p,w)       urban costs of water supply                                  ($US 1000 \ yr)
urb_value_e    (miuse,    t,p,w)       Urban net economic benefits                                  ($US 1000 \ yr)
urb_use_e      (miuse,    t,p,w)       urban use                                     (L3 \ T)       (1000 af \ yr)

Urb_value_af_e (miuse,    t,p,w)       urban average net economic benefits per ac ft                ($US \ ac-ft)
urb_m_value_e  (miuse,    t,p,w)       urban marginal net benefits per ac-ftt                       ($US \ ac-ft)

*Institutions Block (all handled in bounds below so shadow prices can be found)

* Ag Economics Block

Ag_costs_e     (aguse,j,k,t,p,w)       Agricultural production costs (sw + gw)       ($US   \ yr)
Ag_value_e     (aguse,j,k,t,p,w)       Agricultural net benefits     (sw + gw)       ($US   \ yr)

Netrev_acre_e  (aguse,j,k,t,p,w)       Net farm income per acre                      ($US   \ yr)
Ag_ben_e       (aguse,    t,p,w)       net farm income over crops and over acres     ($1000 \ yr)
T_ag_ben_e                             net farm income over crops nodes and yr       ($1000 \ yr)

Ag_m_value_e   (aguse,j,k,t,p,w)       ag average value per unit water               ($US   \ af)

* environmental benefits

Env_ben_e      (river,    t,p,w)       environmental benefits from surface storage   ($1000 \ yr)

* reservoir recreation benefits

Rec_ben_e      (res,      t,p,w)       storage reservoir recreation benefits         ($1000 \ yr)

Tot_ag_ben_e     (        t, p,w)      Total ag benefits by year                     ($1000 \ yr)
Tot_urb_ben_e    (        t, p,w)      Total urban benefits by year                  ($1000 \ yr)
Tot_env_riv_ben_e(        t, p,w)      Total river environmental benefits by year    ($1000 \ yr)
Tot_rec_res_ben_e(        t, p,w)      Total recreation reservoir benefits by yeaer  ($1000 \ yr)

Tot_ben_e        (        t, p,w)      total benefits over uses                      ($1000 \ yr)

DNPV_ben_e       (           p,w)      discounted net present value over users       ($1000)

DNPV_ben_phist_wbase_e                 DNPV historical policy base water             ($1000)
DNPV_ben_phist_wnew_e                  DNPV historical policy new water              ($1000)

DNPV_ben_pbase_wbase_e                 DNPV base policy base water                   ($1000)
DNPV_ben_pbase_wnew_e                  DNPV base policy new water                    ($1000)

DNPV_ben_pnew_wbase_e                  DNPV base policy base water                   ($1000)
DNPV_ben_pnew_wnew_e                   DNPV base policy new water                    ($1000)
;

*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
* EQUATIONS DEFINED ALGEBRAICALLY USING EQUATION NAMES
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*


*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
*  Land  Block
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*

Land_e(aguse,  t,p,w)..  sum((j,k), Tacres_v(aguse,  j,k,t,p,w)) =e= tot_acres_v(aguse,t,p,w);

*--------------*---------*---------*---------*---------*---------*---------*------------*
* Hydrology  Block (in water units)
*---------*---------*---------*---------*---------*---------*---------*-----------------*

Inflows_e(inflow,t,p,w)..   X_v(inflow,t,p,w) =E= source_p(inflow,t,w);

Rivers_e(river,t,p,w)..     X_v(river,t,p,w)  =E= sum(inflow,    Bv_p(inflow,  river)  * source_p(inflow,  t,  w)) +
                                                  sum(riverp,    Bv_p(riverp,  river)  *      X_v(riverp,  t,p,w)) +
                                                  sum(divert,    Bv_p(divert,  river)  *      X_v(divert,  t,p,w)) +
                                                  sum(r_return,  Bv_p(r_return,river)  *      X_v(r_return,t,p,w)) +
                                                  sum(rel,       Bv_p(rel,     river)  *      X_v(rel,     t,p,w)) ;

AgDiverts_e  (agdivert,  tlater,p,w)..  X_v(agdivert,tlater,p,w)   =e= sum((j,k), Ba_divert_p (agdivert,  j,k)  * sum(aguse, ID_adu_p(agdivert,aguse   ) * SWacres_v(aguse,j,k,tlater,p,w)));  // diversions prop to acreage
AgUses_e     (aguse,     tlater,p,w)..  X_v(aguse,   tlater,p,w)   =e= sum((j,k), Ba_use_p    (aguse,     j,k)  *    (1                                ) * SWacres_v(aguse,j,k,tlater,p,w)) ;  // use prop to acreage
Agr_Returns_e(agr_return,tlater,p,w)..  X_v(agr_return,tlater,p,w) =e= sum((j,k), Bar_return_p(agr_return,j,k)  * sum(aguse, ID_arr_p(agr_return,aguse ) * SWacres_v(aguse,j,k,tlater,p,w)));  // return flows prop to acreage
// ag river water applied returned to river

Aga_Returns_e(aga_return,t,p,w)..  Aga_returns_v(aga_return,t,p,w)=e= sum((j,k), Baa_return_p(aga_return,j,k) * sum(aguse, ID_ara_p(aga_return,aguse) * SWacres_v(aguse,j,k,t,p,w)));  // return flow to aquifer from ag application
// ag river water applied returned to aquifer


Ag_m_pump_aq_rch_e(      t,p,w)..  Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,p,w) =e= sum((j,k), Bag_pump_aqf_return_p('ebid_u_f',j,k) * ag_pump_v('mesilla_aqf_s','ebid_u_f',j,k,t,p,w));
Ag_h_pump_aq_rch_e(      t,p,w)..  Ag_pump_aq_rch_v('hueco_aqf_s'  ,'epid_u_f',t,p,w) =e= sum((j,k), Bag_pump_aqf_return_p('epid_u_f',j,k) * ag_pump_v('hueco_aqf_s',  'epid_u_f',j,k,t,p,w));

MIUses_e     (miuse,       t,p,w)..  X_v(miuse,     t,p,w) =e=  sum(midivert, Bmdu_p(midivert,     miuse) *  X_v(midivert,t,p,w));
MIr_Returns_e(mir_return,  t,p,w)..  X_v(mir_return,t,p,w) =e=  sum(midivert, Bmdr_p(midivert,mir_return) *  X_v(midivert,t,p,w));

MXUses_e      (mxuse,     t,p,w).. X_v(mxuse,      t,p,w) =e=  sum(mxdivert, Bmxdu_p(mxdivert,     mxuse) *  X_v(mxdivert,t,p,w));
MXr_Returns_e (mxr_return,t,p,w).. X_v(mxr_return, t,p,w) =e=  sum(mxdivert, Bmxdr_p(mxdivert,mxr_return) *  X_v(mxdivert,t,p,w));

reservoirs0_e(res,t,p,w)  $ (ord(t) eq 1)..   Z_v(res,t,p,w) =e= Z0_p(res,p);

reservoirs_e (res,t,p,w) $ (ord(t) gt 1)..   Z_v(res,t,p,w)        =E= Z_v(res,t-1,p,w)
                                        -  SUM(rel, BLv_p(rel,res)   * X_v(rel,t,  p,w))
                                        -                    evaporation_v(res,t,  p,w)
                                        +                     precip_v    (res,t,  p,w)
                                        +                      residd_p   (res,t,  p  );


Evaporation_e(res,t,p,w)..  Evaporation_v(res,t,p,w)  =e= Evap_rate_p(t)   * surf_area_v(res,t,p,w);
Precip_e     (res,t,p,w)..  Precip_v     (res,t,p,w)  =e= Precip_rate_p(t) * surf_area_v(res,t,p,w);

Surf_area_e  (res,t,p,w)..    surf_area_v(res,t,p,w)  =e= B1_area_vol_p * Z_v(res,t,p,w) + B2_area_volsq_p * Z_v(res,t,p,w) ** 2;

aquifers0_e  (aqf,t,p,w) $ (ord(t) eq 1)..   Q_v(aqf,t,p,w)  =e= Q0_p(aqf);   //aquifer starting values



* aquifer storage by aquifer and year

aquifer_storage_m_e(                t,p,w) $ (ord(t) gt 1)..     Q_v('mesilla_aqf_s',t,p,w)   =e=        Q_v('mesilla_aqf_s', t-1,p,w)
                                                                     +                recharge_p('mesilla_aqf_s',      t    )

                                                                     -  sum(miuse,    urb_pump_v('mesilla_aqf_s',miuse,t,p,w))        // urban pumping from aquifer
                                                                     -  sum(aguse, tot_ag_pump_v('mesilla_aqf_s',aguse,t,p,w))        // ag pumping from aquifer
                                                                     +      1 *    Aga_returns_v('ebid_ar_f',          t,p,w)         // river ag divert return to aqf
                                                                     + 1 * Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,p,w);        // ag pumping return to aquifer


aquifer_storage_h_e(              t,p,w) $ (ord(t) gt 1)..     Q_v('hueco_aqf_s',t,p,w)   =e=        Q_v('hueco_aqf_s', t-1,p,w)
                                                                     +                recharge_p('hueco_aqf_s',      t    )

                                                                     -  sum(miuse,    urb_pump_v('hueco_aqf_s',miuse,t,p,w))         // urban pumping from aquifer
                                                                     -  sum(aguse, tot_ag_pump_v('hueco_aqf_s',aguse,t,p,w))         // ag pumping from aquifer
                                                                     +      1 *    Aga_returns_v('epid_ar_f',        t,p,w)      // river ag div return to aqf
                                                                     +     1 *  Ag_pump_aq_rch_v('hueco_aqf_s','epid_u_f',t,p,w);     // ag pumping return to aquifer

* total ag pumping over crops by aquifer
tot_ag_pump_e(aqf,aguse,t,p,w)..  tot_ag_pump_v(aqf,aguse,t,p,w) =e= sum((j,k), ag_pump_v(aqf,aguse,j,k,t,p,w));  // total ag pumping by district

* aquifer depth by aquifer
aquifer_depth_e(aqf,t,p,w)..     Aquifer_depth_v(aqf,t,p,w)  =e= [qmax_p(aqf) - Q_v(aqf,t,p,w)] / [porosity_p(aqf) * aq_area_p(aqf)];   // simple cube bathub shaped aquifer


*---------------------------------------------------------------------------------------
* Institutions Block --water laws, compacts, treaties, etc constrains use (rules)
* defined in bounds below so allow display of shadow values (marginals)
*---------------------------------------------------------------------------------------

* Agriculture Block

Yield0_e    (aguse,j,k,t,p,w)  $ (ord(t) eq 0)..       yield_v(aguse,j,k,t,p,w)   =e= yield_p(aguse,j,k);
Yield_e     (aguse,j,k,t,p,w)  $ (ord(t) ge 1)..       Yield_v(aguse,j,k,t,p,w)   =e=  B0_p(aguse,j,k,t)  + B1_p(aguse,j,k,t) * SWacres_v(aguse,j,k,t,p,w);  // postive mathematical programming if needed
*Yield_e     (aguse,j,k,t,p,w)  $ (ord(t) gt 1)..        Yield_v(aguse,j,k,t,p,w)   =e= yield_p(aguse,j,k);

*---------------------------------------------------------------------------------------
* Economics Block -- money units $ US
*---------------------------------------------------------------------------------------

* urban econ block: approach documented by booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/

urb_price_e    (miuse,t,p,w)..      urb_price_v(miuse,t,p,w) =e=           BB0_p(miuse)  +         [bb1_p(miuse,t)      * urb_use_v(miuse,t,p,w)];    // urban demand price flattens as urban customer numbers grow.
urb_con_surp_e (miuse,t,p,w)..   urb_con_surp_v(miuse,t,p,w) =e=   0.5 * {[BB0_p(miuse) -   urb_price_v  (miuse,t,p,w)] * urb_use_v(miuse,t,p,w)};    // urban price is not known until model runs (dependent variable)
urb_use_p_cap_e(miuse,t,p,w)..  urb_use_p_cap_v(miuse,t,p,w) =e=       urb_use_v(miuse,t,p,w) /         pop_p(miuse,t);                               // per household urban water use typically about 0.5 acre feet/yr
urb_revenue_e  (miuse,t,p,w)..    urb_revenue_v(miuse,t,p,w) =e=     urb_price_v(miuse,t,p,w) *     urb_use_v(miuse,t,p,w);                           // urban gross tariff revenue
urb_gross_ben_e(miuse,t,p,w)..  urb_gross_ben_v(miuse,t,p,w) =e=  urb_con_surp_v(miuse,t,p,w) + urb_revenue_v(miuse,t,p,w);                           // tariff revenue + consumer surplus

urb_costs_e    (miuse,t,p,w)..    urb_costs_v  (miuse,t,p,w) =e=    urb_Av_cost_p(miuse,t)  *               X_v(miuse,t,p,w)                          // surface cost + pump cost
                                                              +    [urb_Av_cost_p(miuse,t)  +  urb_av_gw_cost_p(miuse,t)]  * [sum(aqf, urb_pump_v(aqf,miuse,t,p,w))];

urb_value_e    (miuse,t,p,w)..   urb_value_v   (miuse,t,p,w) =e=            urb_gross_ben_v(miuse,t,p,w) - urb_costs_v(miuse,t,p,w);                  // urban value - net benefits = gross benefits minus urban costs (cs + ps)
urb_use_e      (miuse,t,p,w)..   urb_use_v     (miuse,t,p,w) =e=   sum(aqf, urb_pump_v(aqf, miuse,t,p,w))  +       X_v(miuse,t,p,w);                  // urban use = divert + pump

Urb_value_af_e (miuse,t,p,w)..   Urb_value_af_v(miuse,t,p,w) =e=    urb_value_v(miuse,t,p,w) /     (urb_use_v(miuse,t,p,w) + 0.01);                   // [wat_use_urb_v(miuse,t) + 0.01]);  // urban economic value per acre foot - includes consumer surplus
urb_m_value_e  (miuse,t,p,w)..  urb_m_value_v  (miuse,t,p,w) =e=    urb_price_v(miuse,t,p,w) - (urb_av_cost_p(miuse,t    ) + urb_av_gw_cost_p(miuse,t));

* ag econ block:       approach documented by booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/

Tacres_e     (aguse,j,k,t,p,w)..     Tacres_v  (aguse,j,k,t,p,w)  =e=    SWacres_v(aguse,j,k,t,p,w) +  gwacres_v(aguse,j,k,t,p,w); // total land supplied by sw + gw
acres_pump_e (aguse,j,k,t,p,w)..      gwacres_v(aguse,j,k,t,p,w)  =e=    sum(aqf, ag_pump_v(aqf,aguse,j,k,t,p,w)) / Ba_use_p  (aguse,j,k  ); // land supplied by gw

Ag_costs_e   (aguse,j,k,t,p,w)..     Ag_costs_v(aguse,j,k,t,p,w)  =e=   Tacres_v(aguse,j,k,t,p,w) *     cost_p(aguse,j,k  )
                                                                   +   gwacres_v(aguse,j,k,t,p,w) *   Ba_use_p(aguse,j,k  ) * ag_av_gw_cost_p(aguse);  // tot cost of sw + gw

Ag_value_e   (aguse,j,k,t,p,w)..     Ag_value_v(aguse,j,k,t,p,w)  =e=    price_p(aguse,j        ) *    yield_v(aguse,j,k,t,p,w) *  Tacres_v(aguse,j,k,t,p,w)
                                                                                                  - Ag_costs_v(aguse,j,k,t,p,w);  // farm net income from sw + gw

Netrev_acre_e(aguse,j,k,t,p,w)..  Netrev_acre_v(aguse,j,k,t,p,w)  =e=  ag_value_v(aguse,j,k,t,p,w) / (.01 + Tacres_v(aguse,j,k,t,p,w));   // net farm income per acre

Ag_use_e     (aguse,    t,p,w)..       ag_use_v(aguse,    t,p,w)  =e=       X_v(aguse,t,p,w) +  sum((j,k,aqf), ag_pump_v(aqf,aguse,j,k,t,p,w));  // total sw + gw ag water use
*Ag_app_e     (aguse,    t,p,s)..       ag_app_v(aguse,    t,p,w)  =e=       X_v(aguse,t,p,w) * (apply / use)

Ag_ben_e     (aguse,    t,p,w)..    Ag_Ben_v   (aguse,    t,p,w)  =E=             sum((j,k  ),         Ag_value_v(aguse,   j,k,t,p,w));
T_ag_ben_e   (            p,w)..    T_ag_ben_v (            p,w)  =E=      sum((aguse, t    ),           Ag_Ben_v(aguse,       t,p,w));

Ag_m_value_e(aguse,j,k,t,p,w)..    Ag_m_value_v(aguse,j,k,t,p,w)   =e=  [price_p(aguse,j) *   Yield_v(aguse,j,k,t,p,w)      - Cost_p(aguse,j,k)] * (1/Bau_p(aguse,j,k)) +
                                                                         price_p(aguse,j) * SWacres_v(aguse,j,k,t,p,w) *        B1_p(aguse,j,k,t)  * (1/Bau_p(aguse,j,k));
* environmental economics benefit block

Env_ben_e(river,t,p,w) $ (ord(river) = card(river))..    env_ben_v('RG_below_EPID_v_f',t,p,w)  =e=   B0_env_flow_ben_p('RG_below_EPID_v_f') * (1+X_v('RG_below_EPID_v_f',t,p,w))** B1_env_flow_ben_p('RG_below_EPID_v_f');  // env flow benefit inc at falling rate synth data

* reservoir recreation benefit block

Rec_ben_e(res,t,p,w)..                  rec_ben_v(res,t,p,w)  =e=   B0_rec_ben_p(res) * surf_area_v(res,t,p,w)** B1_rec_ben_p(res);  // simple square root function synthetic data

* total economic welfare

Tot_ben_e (       t,p,w)..  Tot_ben_v         (t,p,w)   =e=  sum(aguse, ag_ben_v       (aguse,           t,p,w))
                                                           + sum(miuse, urb_value_v    (miuse,           t,p,w))
                                                           + sum(res,   rec_ben_v      (res,             t,p,w))
                                                           +            env_ben_v      ('RG_below_EPID_v_f',t,p,w);  // small benefit from instream flow in forgotton reach below el paso

Tot_ag_ben_e     (t,p,w)..   Tot_ag_ben_v     (t,p,w)   =e=  sum(aguse, ag_ben_v      (aguse,            t,p,w));
Tot_urb_ben_e    (t,p,w)..   Tot_urb_ben_v    (t,p,w)   =e=  sum(miuse, urb_value_v   (miuse,            t,p,w));
Tot_env_riv_ben_e(t,p,w)..   Tot_env_riv_ben_v(t,p,w)   =e=             env_ben_v     ('RG_below_EPID_v_f', t,p,w) ;
Tot_rec_res_ben_e(t,p,w)..   Tot_rec_res_ben_v(t,p,w)   =e=  sum(res,   rec_ben_v     (res,              t,p,w)); // recreation benefit from storage at elephant Butte and Caballo


DNPV_ben_e        (p,w)              ..  DNPV_ben_v (p,w) =e=  sum(tlater,         tot_ag_ben_v(tlater,p,w))
                                                           +   sum(tlater,        tot_urb_ben_v(tlater,p,w))
                                                           +   sum(tlater,    tot_env_riv_ben_v(tlater,p,w))
                                                           +   sum(t     ,    tot_rec_res_ben_v(t     ,p,w));   // assumes zero discount rate

DNPV_ben_phist_wbase_e               ..  DNPV_ben_phist_wbase_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'1-policy_hist','1-w_supl_base'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'1-policy_hist','1-w_supl_base'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'1-policy_hist','1-w_supl_base'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'1-policy_hist','1-w_supl_base'));

DNPV_ben_phist_wnew_e               ..  DNPV_ben_phist_wnew_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'1-policy_hist','2-w_supl_new'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'1-policy_hist','2-w_supl_new'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'1-policy_hist','2-w_supl_new'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'1-policy_hist','2-w_supl_new'));

DNPV_ben_pbase_wbase_e               ..  DNPV_ben_pbase_wbase_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'2-policy_base','1-w_supl_base'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'2-policy_base','1-w_supl_base'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'2-policy_base','1-w_supl_base'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'2-policy_base','1-w_supl_base'));

DNPV_ben_pbase_wnew_e                ..  DNPV_ben_pbase_wnew_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'2-policy_base','2-w_supl_new'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'2-policy_base','2-w_supl_new'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'2-policy_base','2-w_supl_new'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'2-policy_base','2-w_supl_new'));

DNPV_ben_pnew_wbase_e                ..  DNPV_ben_pnew_wbase_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'3-policy_new','1-w_supl_base'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'3-policy_new','1-w_supl_base'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'3-policy_new','1-w_supl_base'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'3-policy_new','1-w_supl_base'));

DNPV_ben_pnew_wnew_e                 ..  DNPV_ben_pnew_wnew_v   =e=
                                                               sum(tlater,         tot_ag_ben_v(tlater,'3-policy_new','2-w_supl_new'))
                                                            +   sum(tlater,        tot_urb_ben_v(tlater,'3-policy_new','2-w_supl_new'))
                                                            +   sum(tlater,    tot_env_riv_ben_v(tlater,'3-policy_new','2-w_supl_new'))
                                                            +   sum(t     ,    tot_rec_res_ben_v(t     ,'3-policy_new','2-w_supl_new'));

*--------------------------  End of equations ------------------------------------------*

*--------------- Section 5 -------------------------------------------------------------*
*  The following section defines models.                                                *
*  Each model is defined by a set of equations used                                     *
*  for which one single variable is optimized (min or max)                              *
*---------------------------------------------------------------------------------------*

* This simple prototype model uses ALL equations defined above.  Some larger models
* may exclude some equations. For example, each institution could be defined
* by one equation.  And each of several models might conduct a single policy experiment
* in which that model tries out a single institution.  This would require deleting all
* institutional equations except the one analyzed.
* If you need to EXclude some equations, list INcluded equations where ALL appears below

MODEL RIO_PROTOTYPE /ALL/;

*--------------- Section 6 -------------------------------------------------------------*
*  The following section defines all solves requested,
*  Each solve states a single model for which an optimum is requested.
*
*  Upper, lower and fixed bounds on certain variables are included here
*  Bounding variables here gives that variable a non-zero shadow price where the optimal
*  solution appears at that boundary.  If the bound doesn't constrain the model
*  the variable's shadow price is zero (complementary slackness)
*---------------------------------------------------------------------------------------*

* bounds follow

Z_v.lo        (res,                t,p,w)   = 0.1;    // bounds storage volume away from 0
surf_area_v.lo(res,                t,p,w)   = 0.1;    // bounds surface area away from 0
X_v.lo        ('RG_below_EPID_v_f',t,p,w)   = 0.1;    // bounds instream flows below EP away from 0
SWacres_v.lo  (aguse,j,k,          t,p,w)   = 0.00;   // bounds total acres away from 0

tot_acres_v.up(aguse,              t,p,w)   = LANDRHS_p(aguse);

tacres_v.up   (aguse,'pecans',k,tlater,p,w) = land_p(aguse,'pecans',k,tlater);      // upper bound on pecan acreage
tacres_v.lo   (aguse,'pecans',k,tlater,p,w) = land_p(aguse,'pecans',k,tlater) - 5;  // protects pecan acreage

*SWacres_v.lo('ebid_u_f','veges','flood','1997','1-policy_hist','1-w_supl_base') = 70.00;  // sets historical acreage at this level

tacres_v.lo   ('ebid_u_f',j,k,tlater,'1-policy_hist','1-w_supl_base') = 0.9999 * land_p('ebid_u_f',j,k,tlater);
tacres_v.up   ('ebid_u_f',j,k,tlater,'1-policy_hist','1-w_supl_base') = 1.0001 * land_p('ebid_u_f',j,k,tlater);

tacres_v.lo   ('epid_u_f',j,k,tlater,'1-policy_hist','1-w_supl_base') = 0.9999 * land_p('epid_u_f',j,k,tlater);
tacres_v.up   ('epid_u_f',j,k,tlater,'1-policy_hist','1-w_supl_base') = 1.0001 * land_p('epid_u_f',j,k,tlater);


X_v.up('RG_Caballo_out_v_f', tfirst,p,w) = 0;    // no storage outflow in starting period
X_v.up(divert,               tfirst,p,w) = eps;  // no diversions or use in starting period

urb_pump_v.up   (aqf,miuse,t,p,w)   =   1.0 *  urb_gw_pump_capacity_p(aqf,miuse);   // upper bound on urban pumping capacity by city

tot_ag_pump_v.up(aqf,aguse,t,p,w)   =   1.0 *   ag_gw_pump_capacity_p(aqf,aguse);   // upper bound on ag pumping by each aquifer and farming area
                                                                                    // needs more reliable data source

X_v.up          (miuse,t,p,w)       =   1.0 * SW_Treat_capac_p(miuse);              // upper bound on El Paso urban surface use:

                                                                                    // data el paso water utilty web page

* positive required values for all following flow variables since all are potentially nonlinear with infinite derivatives defined at zero

X_v.lo(inflow,  t,p,w)   = 0;
X_v.lo(river,   t,p,w)   = 0;
X_v.lo(divert,  t,p,w)   = 0;
X_v.lo(use,     t,p,w)   = 0;
X_v.lo(r_return,t,p,w)   = 0;
X_v.lo(a_return,t,p,w)   = 0;

Z_v.up(res,     t,p,w)   = 1.0                     * Zmax_p(res  );     // storage cannot exceed max storage capacity


Z_v.lo(res,tlast, p,w)   = 1.0 * sw_sustain_p      *   Z0_p(res,p);     // terminal period surface reservoir storage requirements must get to set percent of max capacity
Z_v.lo(res,tlast,'1-policy_hist','1-w_supl_base') = z_p('store_res_s',tlast);



Q_v.up(aqf,     t,p,w)   = 1.0                     * Qmax_p(aqf)  ;     // aquifer storage cannot exceed max storage capacity
Q_v.lo(aqf,tlast, p,w)   = 1.0 * gw_sustain_p(aqf) *   Q0_p(aqf)  ;     // terminal period aquifer storage requirements must get to set percent of starting storage

X_v.lo('RG_El_Paso_v_f',   tlater,p,w)  = tx_proj_op_p * source_p('Marcial_h_f',tlater,w); // NM-TX water sharing agreement - TX gets at least 43% of flows
X_v.lo('MX_d_f',           tlater,p,w)  = us_mx_1906_p;                                    // US-MX treaty of 1906

X_v.lo(aguse,tlater,p,w) = 1.0;  //  forces some surface irrigation into the model

* base historical model requires Caballo outflows to match actual history for base and alternative inflows into Project Storage

X_v.lo('RG_Caballo_out_v_f',tmid,'1-policy_hist', '1-w_supl_base') = Xv_lb_p(tmid) * gaugeflow_p('RG_Caballo_out_v_f',tmid);
X_v.up('RG_Caballo_out_v_f',tmid,'1-policy_hist', '1-w_supl_base') = Xv_ub_p(tmid) * gaugeflow_p('RG_Caballo_out_v_f',tmid);


*------------------------------- SECTION 7 ---------------------------------------------*
*                              Model Solves Follow                                      *
*---------------------------------------------------------------------------------------*

* Begin #1 model: Calibrates storage to match historical inflow, storage, and releases from RG project storage

*    a.  Caballo (optimized) gauged releases constrained to match historical data
*    b.  Rio Grande Project (optimized) storage adjusted yearly to replicate historical measured storage
*    c.  Keeps historical starting project storage at Elephant Butte + Caballo
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_phist_wbase_v;

* --------------------------- end of model 1 ------------------------------------------ *

* Begin #2 model: base policy base inflows into project storage
* Removes restriction on Caballo releases
* but keeps adjustment to predicted storage volume from model 1

*    a.  Removes Caballo restriction to match historical gauged releases: reduces constraints by 1
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  Keeps historical starting project storage
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_pbase_wbase_v;

* --------------------------- end of model 2 ------------------------------------------ *

* Begin #3 model: new policy base inflows into project storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  10% reduction starting storage for RG reservoirs
*    d.  Keeps historical inflows into project storage at San Marcial Gauge

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_pnew_wbase_v;

* --------------------------- end of model 3 ------------------------------------------ *

* Begin #4 model: base policym, new inflows into project storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  Keeps starting storage for RG reservoirs
*    d.  10% reduction for inflows into project storage at San Marcial Gauge

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_pbase_wnew_v;

* --------------------------- end of model 4 ------------------------------------------ *

* Begin #5 model: new policy, new inflows into storage

*    a.  Removes Caballo restriction to match historical gauged releases
*    b.  Keeps Rio Grande Project (optimized) storage yearly adjustment from model 1 above
*    c.  10% reduction in starting storage for RG reservoirs
*    d.  10% reduction for inflows into project storage at San Marcial Gauge

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_pnew_wnew_v;

* --------------------------- end of model 5 ------------------------------------------ *



* ---------------------------------  section 8 ----------------------------- *
*                      post-optimality writes to spreadsheet                 *
* -------------------------------------------------------------------------- *

parameter

* land

SWacres_p     (aguse,j,k,t,p,w)      surface water acreage by crop      (1000 ac \ yr)
GWacres_p     (aguse,j,k,t,p,w)      groundwater acreage   by crop      (1000 ac \ yr)
tacres_p      (aguse,j,k,t,p,w)      total acreage         by crop      (1000 ac \ yr)

TSWacres_p    (aguse,  k,t,p,w)      Total SW acreage                   (1000 ac \ yr)
TGWacres_p    (aguse,  k,t,p,w)      Total GW acreage                   (1000 ac \ yr)
Ttacres_p     (aguse,  k,t,p,w)      Total total acreage                (1000 ac \ yr)

* crops
Yield_opt_p    (aguse,j,k,t,p,w)     crop yield                         (tons \ ac)

* water stocks
wat_stocks_p     (res,    t,p,w)     stocks by pd                       (1000 af \ yr)
wat_stock0_p     (res,      p,w)     starting value                     (1000 af \ yr)
model_resid_p    (res,    t    )     model residual                     (1000 af \ yr)

gw_stocks_p     (aqf,     t,p,w)     gw aquifer stocks by pd            (1000 af by year)
gw_stocks0_p    (aqf,       p,w)     gw aquifer starting stocks         (1000 af)
Aquifer_depth_p (aqf,     t,p,w)     gw aquifer depth                   (feet by year)

* water flows

Evaporation_p   (res,      t,p,w)    total evap by period               (1000 af \ yr)
precip_p        (res,      t,p,w)    total precip by period             (1000 af \ yr)
surf_area_p     (res,      t,p,w)    total surf area by period          (1000 ac \ yr)

inflows_p       (inflow,   t,p,w)    inflows by pd                      (1000 af \ yr)
wat_flows_p     (i,        t,p,w)    flows by pd                        (1000 af \ yr)
river_flows_p   (river,    t,p,w)    river flows by pd                  (1000 af \ yr)
diversions_p    (divert,   t,p,w)    diversions                         (1000 af \ yr)
use_p           (use,      t,p,w)    use                                (1000 af \ yr)
r_return_p      (r_return, t,p,w)    return flows from riv to river     (1000 af \ yr)
a_return_p      (a_return, t,p,w)    return flows from riv to aquifer   (1000 af \ yr)

Ag_use_pp       (aguse,    t,p,w)    ag use                             (1000 af \ yr)
tot_ag_pump_p   (aqf,aguse,t,p,w)    total ag pumping                   (1000 af \ yr)

Ag_pump_aq_rch_p(aqf,aguse,t,p,w)    ag return from pumping to aquifer  (1000 af \ yr)

urb_use_pp      (miuse,    t,p,w)    urban water use                    (1000 af \ yr)
urb_sw_use_p    (miuse,    t,p,w)    urban surface water use            (1000 af \ yr)
urb_pump_p      (aqf,miuse,t,p,w)    urban water pumpoing               (1000 af \ yr)

* economics
urb_price_pp    (miuse,    t,p,w)    urban price                        ($ per af)
urb_con_surp_p  (miuse,    t,p,w)    urban consumer surplus             ($1000 \ yr)
urb_use_p_cap_p (miuse,    t,p,w)    urban use per capita               (af \ person)
urb_revenue_p   (miuse,    t,p,w)    urban revenue                      ($1000 \ yr)
urb_gross_ben_p (miuse,    t,p,w)    urban gross econ benefit           ($1000 \ yr)
urb_costs_p     (miuse,    t,p,w)    urban costs of prodn               ($1000 \ yr)
urb_value_p     (miuse,    t,p,w)    urban total net benefit            ($1000 \ yr)

urb_value_af_p  (miuse,    t,p,w)    urban net value per unit water     ($ \ af)

urb_m_value_p   (miuse,    t,p,w)    urban marginal value               ($ per af)

Ag_value_p      (aguse,j,k,t,p,w)    ag net benefits by crop            ($1000 \ yr)
Ag_Ben_p        (aguse,    t,p,w)    ag benefits                        ($1000 \ yr)
Ag_m_value_p    (aguse,j,k,t,p,w)    ag marginal value of water         ($ \ af    )

rec_ben_p       (res,      t,p,w)    recreation benefit                 ($1000 \ yr)
env_ben_p       (river,    t,p,w)    environmental benefit from flows   ($1000 \ yr)

T_ag_ben_p      (            p,w)    total age benefits                     ($1000)
Env_ben_p       (river,    t,p,w)    Env benefits at stream gauges      ($1000 \ yr)
Tot_ben_p       (          t,p,w)    total benefits over uses           ($1000 \ yr)

DNPV_ben_p                           disc net present value of benefit  ($1000)
;

*stocks
*surface reservoir storage
wat_stocks_p  (res,      t,p,w)   =          Z_v.l    (res,      t,p,w)  + eps;
wat_stock0_p  (res,        p,w)   =          Z0_p     (res,        p  )  + eps;
model_resid_p (res,      t    )   =          z_p      (res,      t    )
                                           - Z_v.l    (res, t,'1-policy_hist','1-w_supl_base') + eps;


*groundwater aquifer storage treated like a simple underground reservoir
gw_stocks_p   (aqf,      t,p,w)   =          Q_v.l    (aqf,      t,p,w)  + eps;
gw_stocks0_p  (aqf,        p,w)   =          Q0_p     (aqf            )  + eps;
Aquifer_depth_p(aqf,     t,p,w)   =  Aquifer_depth_v.l(aqf,      t,p,w)  + eps;

*flows
inflows_p     (inflow,   t,p,w)   =          X_v.l    (inflow,   t,p,w)  + eps;
river_flows_p (river,    t,p,w)   =          X_v.l    (river,    t,p,w)  + eps;
diversions_p  (divert,   t,p,w)   =          X_v.l    (divert,   t,p,w)  + eps;
use_p         (use,      t,p,w)   =          X_v.l    (use,      t,p,w)  + eps;
r_return_p    (r_return, t,p,w)   =          X_v.l    (r_return, t,p,w)  + eps;
a_return_p    (aga_return,t,p,w)  = aga_returns_v.l   (aga_return,t,p,w)  + eps;

wat_flows_p   (i,        t,p,w)   =          X_v.l    (i,        t,p,w)  + eps;

urb_use_pp    (miuse,    t,p,w)   =     urb_use_v.l   (miuse,    t,p,w)  + eps;
urb_sw_use_p  (miuse,    t,p,w)   =           X_v.l   (miuse,    t,p,w)  + eps;
urb_pump_p    (aqf,miuse,t,p,w)   =    urb_pump_v.l   (aqf,miuse,t,p,w)  + eps;

ag_use_pp     (aguse,    t,p,w)   =           X_v.l   (aguse,    t,p,w)  + eps;

tot_ag_pump_p (aqf,aguse,t,p,w)   = tot_ag_pump_v.l   (aqf,aguse,t,p,w)  + eps;

Ag_pump_aq_rch_p(aqf,aguse,t,p,w) = Ag_pump_aq_rch_v.l(aqf,aguse,t,p,w)  + eps;

Evaporation_p (res,     t,p,w)    =    Evaporation_v.l(res,      t,p,w)  + eps;
Precip_p      (res,     t,p,w)    =         Precip_v.l(res,      t,p,w)  + eps;

surf_area_p   (res,     t,p,w)    =     surf_area_v.l (res,      t,p,w)  + eps;

* land
SWacres_p     (aguse,j,k,t,p,w)   =    SWacres_v.l    (aguse,j,k,t,p,w)  + eps;
GWacres_p     (aguse,j,k,t,p,w)   =    GWacres_v.l    (aguse,j,k,t,p,w)  + eps;
tacres_p      (aguse,j,k,t,p,w)   =    tacres_v.l     (aguse,j,k,t,p,w)  + eps;

TSWacres_p    (aguse,  k,t,p,w)   =   sum(j, SWacres_p(aguse,j,k,t,p,w)) + eps;
TGWacres_p    (aguse,  k,t,p,w)   =   sum(j, GWacres_p(aguse,j,k,t,p,w)) + eps;
Ttacres_p     (aguse,  k,t,p,w)   =   sum(j,  tacres_p(aguse,j,k,t,p,w)) + eps;

* crops
Yield_opt_p   (aguse,j,k,t,p,w)   =         Yield_v.l (aguse,j,k,t,p,w)  + eps;

* urban benefits and related

urb_price_pp   (miuse,   t,p,w)   =    urb_price_v.l    (miuse,  t,p,w)  + eps;
urb_con_surp_p (miuse,   t,p,w)   =    urb_con_surp_v.l (miuse,  t,p,w)  + eps;
urb_use_p_cap_p(miuse,   t,p,w)   =    urb_use_p_cap_v.l(miuse,  t,p,w)  + eps;
urb_revenue_p  (miuse,   t,p,w)   =    urb_revenue_v.l  (miuse,  t,p,w)  + eps;
urb_gross_ben_p(miuse,   t,p,w)   =    urb_gross_ben_v.l(miuse,  t,p,w)  + eps;
urb_costs_p    (miuse,   t,p,w)   =    urb_costs_v.l    (miuse,  t,p,w)  + eps;
urb_value_p    (miuse,   t,p,w)   =    urb_value_v.l    (miuse,  t,p,w)  + eps;

urb_value_af_p (miuse,   t,p,w)   =    urb_value_af_v.l (miuse,  t,p,w)  + eps;

urb_m_value_p  (miuse,   t,p,w)   =  urb_m_value_v.l    (miuse,  t,p,w)  + eps;

* ag benefits and related

Ag_value_p  (aguse,j,k,t,p,w)   =        Ag_value_v.l(aguse, j,k,t,p,w)  + eps;
Ag_Ben_p    (aguse,    t,p,w)   =        Ag_Ben_v.l  (aguse,     t,p,w)  + eps;
t_ag_ben_p  (            p,w)   =        t_ag_ben_v.l(             p,w)  + eps;
Ag_m_value_p(aguse,j,k,t,p,w)   =      Ag_m_value_v.l(aguse, j,k,t,p,w)  + eps;

* environmental benefits from streamflow

Env_ben_p('RG_below_EPID_v_f',t,p,w) = Env_ben_v.l('RG_below_EPID_v_f', t,p,w)  + eps;

*  rec benefits from reservoir storage

rec_ben_p   (res,      t,p,w)   =          rec_ben_v.l(res,      t,p,w)  + eps;

* total benefits

Tot_ben_p   (          t,p,w)   =           Tot_ben_v.l(         t,p,w)  + eps;

DNPV_ben_p             (p,w)    =            DNPV_ben_v.l         (p,w)  + eps;

execute_unload "rgr_watershed_bucket_mar_25_2017_noon.gdx"

Evap_rate_p,  B1_area_vol_p,     Z0_p
wat_flows_p,  wat_stocks_p,      wat_stock0_p,             river_flows_p,  inflows_p, t_ag_ben_p,
diversions_p, SWacres_p,         GWacres_p,                use_p, r_return_p, pop_p,          price_p, cost_p, netrev_acre_p,
yield_p,      land_p,            urb_price_pp,             urb_con_surp_p, urb_use_p_cap_p, ag_value_p,
ag_ben_p,     ag_m_value_p,      t_ag_ben_p,               yield_opt_p,    Ba_use_p
urb_av_cost_p, elast_p,          tx_proj_op_p              ag_use_pp       urb_pump_p,  urb_sw_use_p,
recharge_p,   urb_revenue_p,     urb_gross_ben_p,          urb_costs_p,    urb_value_p, urb_value_af_p,
urb_use_pp,   urb_m_value_p,     zmax_p Evaporation_p,     surf_area_p
env_ben_p,    tot_ben_p,         dnpv_ben_p, us_mx_1906_p, sw_sustain_p,   gw_sustain_p, rec_ben_p, env_ben_p, tot_ag_pump_p,
gw_stocks_p,  gw_stocks0_p       urb_gw_pump_capacity_p    gw_stocks0_p    qmax_p
urb_av_gw_cost_p ag_av_gw_cost_p urb_gw_pump_capacity_p    ag_gw_pump_capacity_p
landrhs_p     aquifer_depth_p    porosity_p,     qmax_p,   q0_p,           aq_area_p, a_return_p, Ag_pump_aq_rch_p,
z_p           xv_lb_p,           xv_ub_p, gaugeflow_p,     model_resid_p,  precip_p
residdd_p     tacres_p           TSWacres_p                TGWacres_p      Ttacres_p
;

$onecho > gdxxrwout.txt

i=rgr_watershed_bucket_mar_25_2017_noon.gdx
o=rgr_watershed_bucket_mar_25_2017_noon.xls

epsout = 0

*----------------------------------------------------------------------*
* DATA READ AND USED BY RIO GRANDE BASIN MODEL
*----------------------------------------------------------------------*

* institutional constraints

par = us_mx_1906_p           rng = data_us_mx_1906_flows!c4    cdim = 0
par = tx_proj_op_p           rng = data_tx_project_op!c4       cdim = 0
par = sw_sustain_p           rng = data_sw_sustainability!c4   cdim = 0
par = gw_sustain_p           rng = data_gw_sustainability!c4   cdim = 0

* technical constraints

par = urb_gw_pump_capacity_p rng = data_urb_pump_capacity!c4   cdim = 0
par = ag_gw_pump_capacity_p  rng = data_ag_pump_capacity!c4    cdim = 0

* hydrology data

par = porosity_p             rng = data_aq_porosity!c4         cdim = 0
par = qmax_p                 rng = data_max_aq_capacity!c4     cdim = 0
par = q0_p                   rng = data_starting_aq_store!c4   cdim = 0
par = aq_area_p              rng = data_aquifer_area!c4        cdim = 0

par = recharge_p             rng =  data_aquifer_recharge!c4   cdim = 0
par = inflows_p              rng =  data_basin_inflows!c4      cdim = 0

par = z_p                    rng =  data_res_storage!c4        cdim = 0
par = gaugeflow_p            rng =  data_gauged_flows!c4       cdim = 0

par = xv_lb_p                rng =  data_cab_flow_lo_bound!c4  cdim = 0
par = xv_ub_p                rng =  data_cab_flow_up_bound!c4  cdim = 0

par = wat_stock0_p           rng =  data_start_storage!c4      cdim = 0
par = gw_stocks0_p           rng =  data_start_gw_stocks!c4    cdim = 0
par = qmax_p                 rng =  data_max_aqf_capac!c4      cdim = 0

par = Evap_rate_p            rng =  data_evap_rate_ft_yr!c4    cdim = 0
par = B1_area_vol_p          rng =  data_acre_per_af!c4        cdim = 0
par = Zmax_p                 rng =  data_store_capacity!c4     cdim = 0

* crop data
par = yield_p                rng =  data_yield!c4              cdim = 0
par = landrhs_p              rng =  data_ag_land_limit!c4      cdim = 0

* crop water data

par = Ba_use_p               rng =  data_wat_use_acre!c4       cdim = 0

* urban data
par = pop_p                  rng =  data_population!c4         cdim = 0

* economic data
par = Price_p                rng =  data_price!c4              cdim = 0
par = cost_p                 rng =  data_cost!c4               cdim = 0
par = netrev_acre_p          rng =  data_netrev_acre!c4        cdim = 0

par = urb_av_cost_p          rng =  data_urb_av_cost!c4        cdim = 0
par = urb_av_gw_cost_p       rng =  data_urb_av_gw_cost!c4     cdim = 0

par = ag_av_gw_cost_p        rng =  data_ag_av_gw_cost!c4      cdim = 0

par = elast_p                rng =  data_urb_price_elast!c4    cdim = 0

*------------------ END OF DATA READ BY MODEL --------------------------*

*-----------------------------------------------------------------------*
* MODEL-OPTIMIZED RESULTS FROM RIO GRANDE BASIN MODEL
*------------------------------------------------------------------------

* land block

par = SWacres_p              rng =  opt_sw_acreage!c4          cdim = 0
par = GWacres_p              rng =  opt_gw_acreage!c4          cdim = 0
par = tacres_p               rng =  opt_tot_acreage!c4         cdim = 0

par = TSWacres_p             rng =  opt_tot_sw_acreage!c4      cdim = 0
par = TGWacres_p             rng =  opt_tot_gw_acreage!c4      cdim = 0
par = Ttacres_p              rng =  opt_tot_t_acreage!c4       cdim = 0

* crop block

par = yield_opt_p            rng = opt_yield!c4                cdim = 0

*hydrology block

par = Evaporation_p          rng  = opt_evaporation!c4         cdim = 0
par = precip_p               rng  = opt_precip!c4              cdim = 0
par = surf_area_p            rng  = opt_surf_area!c4           cdim = 0

par = model_resid_p          rng  = residual!c4                cdim = 0
par = residdd_p              rng  = residual1!c4               cdim = 0

par = wat_flows_p            rng =  opt_water_flows!c4         cdim = 0
par = river_flows_p          rng =  opt_river_flows!c4         cdim = 0
par = diversions_p           rng =  opt_diversions!c4          cdim = 0
par = use_p                  rng =  opt_use!c4                 cdim = 0
par = r_return_p             rng =  opt_riv_return!c4          cdim = 0
par = a_return_p             rng =  opt_aqf_return!c4          cdim = 0

par = ag_use_pp              rng =  opt_ag_use!c4              cdim = 0
par = urb_use_pp             rng =  opt_urban_tot_use!c4       cdim = 0
par = urb_sw_use_p           rng =  opt_urb_sw_use!c4          cdim = 0

par = urb_pump_p             rng =  opt_urban_pumping!c4       cdim = 0
par = tot_ag_pump_p          rng =  opt_ag_pumping!c4          cdim = 0
par = Ag_pump_aq_rch_p       rng =  opt_ag_pump_aq_rch!c4      cdim = 0

par = wat_stocks_p           rng =  opt_water_stocks!c4        cdim = 0
par = gw_stocks_p            rng =  opt_gw_stocks!c4           cdim = 0
par = aquifer_depth_p        rng =  opt_aquifer_depth!c4       cdim = 0

* urban water use and related block

par = urb_price_pp           rng =  opt_urban_price!c4         cdim = 0
par = urb_con_surp_p         rng =  opt_urban_cons_surp!c4     cdim = 0
par = urb_use_p_cap_p        rng =  opt_urb_use_per_cap!c4     cdim = 0
par = urb_revenue_p          rng =  opt_urb_gross_revenue!c4   cdim = 0
par = urb_gross_ben_p        rng =  opt_urb_tot_gross_ben!c4   cdim = 0
par = urb_costs_p            rng =  opt_urban_tot_costs!c4     cdim = 0
par = urb_value_p            rng =  opt_urban_tot_net_ben!c4   cdim = 0

par = urb_value_af_p         rng =  opt_urban_net_ben_af!c4    cdim = 0

par = urb_m_value_p          rng =  opt_urban_marg_benefit!c4  cdim = 0

* economic benefits block

par = Ag_value_p            rng  =  opt_ag_ben_by_crop!c4      cdim = 0
par = Ag_Ben_p              rng  =  opt_ag_ben!c4              cdim = 0
par = Ag_m_value_p          rng  =  opt_ag_marg_value!c4       cdim = 0
par = t_ag_ben_p            rng  =  opt_tot_ag_benefits!c4     cdim = 0

par = env_ben_p             rng  =  opt_env_river_benefit!c4   cdim = 0
par = rec_ben_p             rng  =  opt_rec_benefit!c4         cdim = 0

par = tot_ben_p             rng  =  opt_tot_benefit!c4         cdim = 0
par = dnpv_ben_p            rng  =  opt_dnpv_benefit!c4        cdim = 0

*----------------------* end of model optimized results *----------------*

$offecho
execute 'gdxxrw.exe @gdxxrwout.txt trace=2';

*------------------------The End ----------------------------------------*
