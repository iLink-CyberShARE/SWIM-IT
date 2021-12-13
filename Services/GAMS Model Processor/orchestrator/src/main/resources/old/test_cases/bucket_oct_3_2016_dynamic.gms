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

  Oct 2 2016

Rio Grande Basin Model: Expandable Prototype
Contains essential elements of full Upper Rio Grande Basin Model.
Sponsor:  USDA NIFA 5 year grant beginning March 2015

* Improvements from sept 25 2016 model

* introduces ag aquifer pumping as a backup for surface irrigatoin

* acreage split by diverted v pumped
* user inputs price per acre foot of gw pumping
* user inputs upper bounds on gw pumping capacity

* any positive price of gw keeps gw out of ag
* gw enters with low reservoir storage starting value

* NEEDS FOR IMPROVEMENT
* still need to add ag gw pumping from same reservoir as urb gw pumping
* also need to include both pumping into basin balance

* ---------------------------------------------------------------------------------------
* Sponsored by US Dept of Agriculture: 5 yr project 2015 - 2020
* ---------------------------------------------------------------------------------------

Model has these flow nodes:
5 river gauge nodes
1 streamgauge inflow node
5 watershed point inflow nodes from ungauged precip into river reaches
5 diversion nodes
5 consumptive use nodes
5 surface water return flow nodes
1 reservoir release node

and these stock nodes:
1 reservoir node
1 aquifer node

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

   1. Reservoir nodes,                                           res(u).

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

**************** Section 1 **************************************************************
*  The following sets are specified as indices                                          *
*  for parameters (data), variables (unknowns), and equations (algebraic relations)     *
*****************************************************************************************

$OFFTEXT

SETS

*****************************************************************************************
i     Flows -- location of important nodes in lower RG Basin -- Elephant Butte to MX
*****************************************************************************************

/     Marcial_h_f       Headwater flow nodes                        inflow(i)
      Wshed_1_h_f

      Store_out_v_f    River gage measurement nodes                river(i)
      NM_TX_line_v_f
      MX_1_v_f
      MX_2_v_f
      below_EPID_v_f

      EBID_d_f         Diversion nodes                             divert(i)
      LCMI_d_f
      EPMI_d_f
      MX_d_f
      EPID_d_f

      EBID_u_f        Consumptive use flow nodes                   use(i)
      LCMI_u_f
      EPMI_u_f
      MX_u_f
      EPID_u_f

      EBID_r_f        Surface water return flow nodes             return(i)
      LCMI_r_f
      EPMI_r_f
      MX_r_f
      EPID_r_f

      Store_rel_f     Reservoir storage-to-river release flow node  rel(i)
/
*****************************************************************************************
*     Subsets of all Flow nodes above by class (function)
*****************************************************************************************

inflow(i)            Headwater flow nodes                        inflow(i)

/     Marcial_h_f     Rio Grande headwaters CO
      Wshed_1_h_f     Watershed inflow #1
/

river(i)             River gage measurement nodes                river(i)

/     Store_out_v_f   RGR project storage outflow gauge on RG
      NM_TX_line_v_f  New Mexico Texas State Line on RG
      MX_1_v_f        Rio Grande above Mexico diversion
      MX_2_v_f        Rio Grande below Mexico diversion
      below_EPID_v_f  Gauge below EP irrigation diversion use on RG
/

divert(i)            Diversion nodes                             divert(i)

/     EBID_d_f        Elephant Butte Irrigation District diversion
      LCMI_d_f        Las Cruces MI diversions at LC
      EPMI_d_f        El Paso MI diversion at El Paso
      MX_d_f          Mexican diversion on Rio Grande
      EPID_d_f        El Paso Irrigation dversion
/

agdivert(divert)      Ag diversion nodes                         agdivert(divert)

/     EBID_d_f        EBID
      EPID_d_f        EPID
/

midivert(divert)     urban diversions nodes                    midivert(divert)

/     LCMI_d_f       las cruces urban
      EPMI_d_f       el paso urban
/

mxdivert(divert)     mexico diversion

/     MX_d_f/

use(i)               Consumptive use flow nodes = div nodes      use(i)

/     EBID_u_f       same nodes as divert(i) but functions as use
      LCMI_u_f
      EPMI_u_f
      MX_u_f
      EPID_u_f
/

aguse(use)           Ag use nodes                                aguse(use)

/     EBID_u_f       ebid nm
      EPID_u_f       EPID tx
/

miuse(use)           urban use nodes                             miuse(use)

/     LCMI_u_f       las cruces urban
      EPMI_u_f       el paso urban
/

mxuse(use)           Deliveries to Mexico in Acequia Madre at International Dam
/     MX_u_f/


return(i)            Surface water return flow nodes = div nodes      return(i)

/     EBID_r_f       same as divert(i) but return flow
      LCMI_r_f
      EPMI_r_f
      MX_r_f
      EPID_r_f
/

agreturn(return)     Ag return flow nodes                        agreturn(return)

/     EBID_r_f       elephant butte irrigation
      EPID_r_f       el paso irrigation
/

mireturn(return)     urban return flow nodes                     mireturn(return)

/    LCMI_r_f        las cruces urban
     EPMI_r_f        el paso urban
/

mxreturn(return)     mexico return flows
/    MX_r_f/

rel(i)               Reservoir to river release flow nodes       rel(i)

/    Store_rel_f     RG Project storage releas into RG
/

*display agdivert;

*****************************************************************************************
u     Stocks - location of important nodes on Rio Grande CO to MX
*****************************************************************************************

/     Store_res_s    Reservoir stock node                        res(u)

      Store_aqf_s    Aquifer node                                aqf(u)

/

*****************************************************************************************
*    Stock subsets
*****************************************************************************************

res(u)               Reservoir stock nodes                       res(u)

/     Store_res_s    Rio Grande project storage on RG

/


aqf(u)               Aquifer stock nodes

/     Store_aqf_s    southern NM - West TX aquifer

/


* aqf(u)   list the aquifers

* change in aqf storage = recharge - pumping
* need data on aquifer planning area and storage coefficient
* need data on aquifer storage capacity and starting levels
* alluvium.

* with a small number of reaches it should be pretty easy
* simple Mannings law of the river:  average stages change along each reach.
*


*****************************************************************************************
j     crop
*****************************************************************************************

/     pecans
      veges
/


*****************************************************************************************
k     technology
*****************************************************************************************

/     flood

/

*****************************************************************************************
t     time - years
*****************************************************************************************

/     0*3            base + 3 years - expandable

/

tfirst(t)            starting year
tlast(t)             terminal year
tlater(t)            all years after initial
;

tfirst(t) = yes $ (ord(t) eq 1);        // 1st year
tlast(t)  = yes $ (ord(t) eq card(t));  // GAMS language -- picks last pd
tlater(t) = yes $ (ord(t) gt 1);        // picks years after 1
;

ALIAS (river, riverp);

display tfirst, tlast, tlater, agdivert;

********************************* END OF SETS  ******************************************

**************** Section 1b **************************************************************
*  This section loads some of the parameters dynamically 
*  Currently loading only user definition type parameters                               *
*  1.  Scalars (single numbers),                                                        *
*  2.  Parameters (columns of numbers) or                                               *
*  3.  Tables (data in rows and columns)                                                *
*****************************************************************************************

parameter

pop0_p(miuse)       urban population (1000s)
rho_pop_p(miuse)     population growth rate per year
urb_cost_grow_p (miuse)   urban average cost growth rate   (prop \ year)
urb_gw_cost_grow_p(miuse)
source_p(inflow,t)
land_p(use,j,k);

$if not set gdxincname $abort 'no include file name for data file provided'
$gdxin %gdxincname%
$loaddc pop0_p rho_pop_p urb_cost_grow_p urb_gw_cost_grow_p source_p land_p
$gdxin


**************** Section 2 **************************************************************
*  This section defines all data in 3 formats                                           *
*  1.  Scalars (single numbers),                                                        *
*  2.  Parameters (columns of numbers) or                                               *
*  3.  Tables (data in rows and columns)                                                *
*****************************************************************************************

*  Below follow several maps summarizing the RG Basin's geometry
*  By geometry we mean location of mainstems, tributaries, confluence,
*  source nodes, use nodes, return flow nodes, reservoir nodes, etc.
*  Basin geometry is summarized through judicious use of numbers 1, -1, and 0 (blank)

*****************************************************************************************
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
*****************************************************************************************

TABLE Bv_p(i,river)    Hydrologic Balance Table    (unitless 0 - 1 dummy)

****************************   Column Heads are River Gauges    *************************

                  Store_out_v_f    NM_TX_line_v_f   MX_1_v_f   MX_2_v_f   below_EPID_v_f
* ---------------- headwater inflow node rows (+) ---------------------------------------
Marcial_h_f             1
Wshed_1_h_f
* ---------------- river gauge node rows (+) --------------------------------------------
Store_out_v_f                          1
NM_TX_line_v_f                                          1
MX_1_v_f                                                           1
MX_2_v_f                                                                       1
below_EPID_v_f
* --------------- diversion nodes rows  (-)  --------------------------------------------
EBID_d_f                              -1
LCMI_d_f                              -1
EPMI_d_f                                               -1
MX_d_f                                                            -1
EPID_d_f                                                                      -1
* -------------- return flow node rows (+) ----------------------------------------------
EBID_r_f                               1
LCMI_r_f                               1
EPMI_r_f                                                1
MX_r_f                                                             1
EPID_r_f                                                                       1
* ------------- reservoir release (outflow) to river -- stock-to-flow rows (+) ----------
Store_rel_f            1
;

*****************************************************************************************
* agriculture parameters
*****************************************************************************************
* Map #3:

* Defines use (simplistically) as a percentage of diversion
* X(use) = Bdu * X(divert)
* These B coeffs are shown below as the matrix, Bu

****************************************************************************************

Table   Yield_p(use,j,k)   Crop Yield (tons per acre)

                  Pecans.flood     Veges.flood
*-------------------------- use node rows (+) ---------------
EBID_u_f            0.58            17.00
EPID_u_f            0.58            17.00
*------------------------------------------------------------

Parameter   Price_p(j)    Crop Prices ($ per ton)

/Pecans    4560
 Veges      300
/

table Bau_p(i,j,k)   water per acre nmsu extension budgets  (feet depth)

                    Pecans.flood   Veges.flood
*------------------------ apply node rows (+) ------------------------
EBID_d_f              5.5             3.0
EPID_d_f              5.5             3.0
*-------------------------- use node rows (+) ------------------------
EBID_u_f              5.5             3.0
EPID_u_f              5.5             3.0
*----------------------- return flow node rows (+)--------------------
EBID_r_f              0.0             0.0
EPID_r_f              0.0             0.0
*---------------------------------------------------------------------

table Ba_divert_p(divert,j,k)  diversions                 (feet depth)
                   Pecans.flood     Veges.flood
* -------------------------- apply node rows -------------------------
EBID_d_f              5.5              3.0
EPID_d_f              5.5              3.0
* --------------------------------------------------------------------

table Ba_use_p(use,j,k)    use                           (feet depth)
                   Pecans.flood     Veges.flood
* -------------------------- use node rows ---------------------------
EBID_u_f              5.5              3.0
EPID_u_f              5.5              3.0
* --------------------------------------------------------------------

table Ba_return_p(return,j,k)  return flows              (feet depth)
                    Pecans.flood    Veges.flood
* --------------------------------------------------------------------
EBID_r_f              0.0              0.0
EPID_r_f              0.0              0.0
* --------------------------------------------------------------------

Table  Cost_p(aguse,j,k)     Crop Production Costs       ($ per acre)
                      Pecans.flood   Veges.flood
*-------------------------- use node rows (+) ------------------------
EBID_u_f               1700            4200
EPID_u_f               1700            4200
*---------------------------------------------------------------------
;

parameter ag_gw_pump_capacity_p(aguse)   ag pumping capacity
;
ag_gw_pump_capacity_p(aguse) = 5;


parameter

ag_av_gw_cost_p(aguse)   agricultural average costs of pumping gw ($ per a-f)
;
ag_av_gw_cost_p(aguse)   =  100; // $90 per af everywhere pumped
;

Parameter Netrev_acre_p(aguse,j,k)  net revenue per unit land observed in base year  ($ per acre)
;

Netrev_acre_p(aguse,j,k) = Price_p(j) * Yield_p(aguse,j,k) - Cost_p(aguse,j,k);

Display price_p, yield_p, cost_p, Netrev_acre_p;

******************************************************************************************************
*                           Positive Mathematical Programming Parameters                             *
******************************************************************************************************
* Positive Mathematical Programming (PMP) parameters derived below.
* Based on 2 articles:
*   Richard Howitt Positive Mathematical Programming Am J Agricultural Economics 1995

*   F. Ward and Macarena Dagnino IJWRD 2012 Agricultural Water Conservation
*   International Journal of Water Resources Development Volume 28,  Issue 4, 2012
*   Economics of Agricultural Water Conservation: Empirical Analysis and Policy Implications
******************************************************************************************************

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
B0_p(aguse,j,k)     intercept term in crop-water prodn fn forces vmp of water = water price     (tons per acre)
B1_p(aguse,j,k)     linear term does the same (<0) Greater land in production reduces ave yield (tons per 1000 acres)
;

B1_p(aguse,j,k)   =  -Netrev_acre_p(aguse,j,k) / [Price_p(j) * Land_p(aguse,j,k)]; // Under profit max, higher observed net rev per ac causes increased acreage to reduce yields
B0_p(aguse,j,k)   =   Yield_p(aguse,j,k) - B1_p(aguse,j,k)   * Land_p(aguse,j,k);

display B1_p, B0_p;

************************ end of ag **************************************************
*************** urban water use parameters ******************************************


parameter pop_p(miuse,t)    population by year
;

pop_p(miuse,t) $ (ord(t) eq 1) = pop0_p(miuse);
pop_p(miuse,t) $ (ord(t) ge 2) = pop0_p(miuse) * (1 + rho_pop_p(miuse)) ** (ord(t) - 2);

display pop0_p, rho_pop_p, pop_p;

parameter

elast_p         (miuse)   urban price elasticity of demand (unitless)
urb_price_p     (miuse)   urban base price of water        ($1000   \ 1000 af)
urb_use_p       (miuse)   urban base water use             (1000 af \ yr)
urb_Av_cost0_p  (miuse)   urban average cost of supply     ($      \  af)


elast_p(miuse)

/LCMI_u_f   -0.32
 epmi_u_f   -0.32/         // el paso water study (fullerton) source:  http://www.waterrf.org/resources/Lists/ProjectPapers/Attachments/61/4501_ProjectPaper.pdf

urb_price_p(miuse)

/LCMI_u_f   851.14
 epmi_u_f   851.14/       // el paso water utilities pricing source Dec 28 2015:  http://www.epwu.org/whatsnew/pdf/Survey.pdf

urb_use_p(miuse)

/LCMI_u_f   15.000
 epmi_u_f  120.597/       // 135.597/        // 67.9785 67.9785/       // el paso water production source dec 28 2015:  http://www.epwu.org/water/water_resources.html

urb_av_cost0_p(miuse)

/LCMI_u_f  851.14
 epmi_u_f  851.14/        // el paso water utilities pricing source Dec 28 2015:  http://www.epwu.org/whatsnew/pdf/Survey.pdf


urb_av_gw_cost0_p(miuse)   // av cost of aquifer pumping urban

/LCMI_u_f  801.14
 epmi_u_f  801.14/

* 901.14
* 901.14


urb_gw_pump_capacity_p(miuse)  // educated guess acre feet

/LCMI_u_f  15
 epmi_u_f  65/

;

parameter
urb_av_cost_p   (miuse,t) urban average cost in future years
urb_av_gw_cost_p(miuse,t) urban ave gw pump cost in future years
;

urb_av_cost_p   (miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_cost0_p(miuse);
urb_av_cost_p   (miuse,t) $ (ord(t) ge 2) =        urb_av_cost0_p(miuse)    * (1 + urb_cost_grow_p(miuse))   ** (ord(t) - 2);

urb_av_gw_cost_p(miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_gw_cost0_p(miuse);
urb_av_gw_cost_p(miuse,t) $ (ord(t) ge 2) =        urb_av_gw_cost0_p(miuse) * (1 + urb_gw_cost_grow_p(miuse)) ** (ord(t) - 2);

display urb_av_cost0_p, urb_av_cost_p
        urb_av_gw_cost0_p, urb_av_gw_cost_p;




parameter
BB1_base_p (miuse  )     Slope of urban demand function
BB1_p      (miuse,t)     flattening slope of price-dependent urban demand function with growing population
BB0_p      (miuse  )     Intercept for urban price-dependent demand function
;

BB1_base_p(miuse  )   =  urb_price_p (miuse)  /  [elast_p (miuse) * urb_use_p(miuse)];
BB0_p     (miuse  )   =  urb_price_p (miuse) - BB1_base_p (miuse) * urb_use_p(miuse);
BB1_p     (miuse,t)   =  BB1_base_p  (miuse) * [pop_p (miuse,'0') / pop_p(miuse,t)];  // higher population has lower price slope - demand pivots out with higher pop


display urb_price_p, elast_p, BB0_p, BB1_p, bb1_base_p ;

********************** END OF MI PARAMETERS *********************************************

******************** INSTITUTIONAL CONSTRAINTS ******************************************

scalar us_mx_1906_p   us mexico 1906 treaty flows                                 /60   /  //  https://en.wikipedia.org/wiki/International_Diversion_Dam
scalar tx_proj_op_p   project operation tx proportion of nm tx water sharing      / 0.43/
scalar sw_sustain_p   terminal sustainability proportion of starting sw storage   / 0.50/
scalar gw_sustain_p   terminal sustainability proportion of starting gw storage   / 0.95/

*****************************************************************************************
* Map #4:

* Table defines relation between diversions and return flow nodes
*
* Tabled entries = proportion return flow by diversion column nodes
*    (+)  means the row diversion contributes to column's ret flow
*    ( )  means the column diversion makes no cont to row's ret flow

*X(return) = Br * X(divert)
*****************************************************************************************

TABLE Br_p(agdivert, agreturn)    Defines surface return flow as a percent of diversion

*********************  Column Heads are Return Flow Nodes *******************************

              EBID_r_f        EPID_r_f
EBID_d_f         0.0
EPID_d_f                        0.0
;

TABLE Bmdu_p(midivert, miuse)    Defines MI use as a fn of diversions
*********************  Column Heads are use and return nodes
                LCMI_u_f       EPMI_u_f
LCMI_d_f          1.0
EPMI_d_f                        1.0

TABLE Bmdr_p(midivert, mireturn)  MI return as fn of midivert
                LCMI_r_f       EPMI_r_f
LCMI_d_f          0.0
EPMI_d_f                        0.0
;

TABLE Bmxdr_p(mxdivert, mxreturn)    Defines MX return as a fn of MX diversions
*********************  Column Heads are use and return nodes
              MX_r_f
MX_d_f         0.0

TABLE Bmxdu_p(mxdivert, mxuse)
              MX_u_f
MX_d_f         1.0
;

*****************************************************************************************
* Map #5:

* Table relates reservoir stocks in a period to its prev periods' stocks minus releases.
* For any reservoir stock node at the column head
*   (+1) :added water at flow node -- thru releases -- takes from column's res stock (-)
*   (-1) :added water at flow node adds to column's reservoir stock
*   (  ) :added water at flow node has no effect on column's reservoir stock

* Z(res(t)) = Z(res(t-1)) + BLv * X(rel(t))
*****************************************************************************************

TABLE BLv_p(rel, u)         Links reservoir releases to downstream flows

********* Column Heads are Reservoir Stocks -- rows are release flows  ******************
********* Table = diagonal matrix for > 1 reservoir--only 1 for now    ******************

                     Store_res_s
      Store_rel_f        1
;
*****************************************************************************************
*  END OF BASIN GEOMETRY MAPS                                                           *
*****************************************************************************************

*****************************************************************************************
* NEXT APPEAR BASIN INFLOWS, OTHER FLOWS, FLOW RELATIONSHIPS, AND                       *
* RESERVOIR STARTING VOLUMES, SIMPLE ECONOMIC VALUES PER AC FT WATER USE                *
*****************************************************************************************

* all water flows are measured in 1000s acre feet per yer
* all water stocks are measured in 1000s acre feet instantaneous volume

PARAMETER

* reservoir stocks

z0_p  (res)     initial reservoir levels at reservoir stock nodes  (1000 af)
zmax_p(res)     maximum reservoir storage capacity                 (1000 af)
;

z0_p  ('Store_res_s')   =   292;    // project storage starting vol
                          //292
zmax_p('store_res_s')   = 2544;    // max project storage


parameter

* aquifer stocks

q0_p  (aqf)     initial aquifer level at aquifer stock nodes       (1000 af)
qmax_p(aqf)     max aquifer storage cpacity                        (1000 af)
;

q0_p  ('store_aqf_s')     = 60000;  //  starting storage
qmax_p('store_aqf_s')     = 70000;  //  max storage capacity
;


scalar  BC_p                Proportion downstream delivery under Rio Grande Compact        (proportion)

/0.80/


scalars

Evap_rate_p    reservoir evaporation  (feet loss per exposed acre)  /10/


B1_area_vol_p  impact of changes in volume on changes in area (acres per 1000 ac feet)  /0.015/


B2_area_volsq_p  impact of changes in volume squared on changes in area (acres per 1000 ac ft squared)  / eps/


parameters

ID_adu_p(agdivert,   aguse)     identity matrix connects divert nodes to use nodes
ID_aru_p(agreturn,   aguse)     identity matrix connects return nodes to use nodes

ID_mdu_p(midivert,   miuse)     identity matrix connects divert nodes to use nodes
ID_mru_p(mireturn,   miuse)     identity matrix connects return nodes to use nodes
;

ID_adu_p(agdivert,   aguse) $ (ord(agdivert) eq ord(aguse   )) = 1;
ID_aru_p(agreturn,   aguse) $ (ord(agreturn) eq ord(aguse   )) = 1;

ID_mdu_p(midivert,   miuse) $ (ord(midivert) eq ord(miuse   )) = 1;
ID_mru_p(mireturn,   miuse) $ (ord(mireturn) eq ord(miuse   )) = 1;

display ID_adu_p, ID_aru_p, ID_mdu_p, ID_mru_p;

parameters

*****************************************************************************************
*  Land  Block
*****************************************************************************************

LANDRHS_p(aguse)           land available by irrigation district        (1000 acres)

/
  EBID_u_f              90
  EPID_u_f              50
/


display LANDRHS_p;
**************** Section 3 **************************************************************
*  These endogenous (unknown) variables are defined                                     *
*  Their numerical values are not known til GAMS finds optimal soln                     *
*****************************************************************************************

positive variables

Z_v            (u,        t)     water stocks -- reservoirs                       (L3 \ yr)   (1000 af by yr)
Q_v            (aqf,      t)     aquifer storage volume                           (L3 \ yr)   (1000 af by yrr)

Evaporation_v  (res,      t)     reservoir surface evaporation                    (L3 \ yr)   (1000 af \ yr)
surf_area_v    (res,      t)     reservoir surface area                           (L2 \ yr)   (1000 ac \ yr)

SWacres_v        (aguse,j,k,t)     acres land in prodn                              (L2 \ yr)   (1000 ac \ yr)
GWAcres_v      (aguse,j,k,t)     groundwater land in prodn                        (L2 \ yr)   (1000 ac \ yr)
Tacres_v       (aguse,j,k,t)     total acres (sw + gw)                            (L2 \ yr)   (1000 ac \ yr)
tot_acres_v    (aguse,    t)     total acres land over crops                      (L2 \ yr)   (1000 ac \ yr)

Ag_use_v       (aguse,    t)     irrigation surface water use                     (L3 \ yr)   (1000 af \ yr)
ag_pump_v      (aguse,j,k,t)     agricultural pumping                             (L3 \ yr)   (1000 af \ yr)
tot_ag_pump_v  (aguse,    t)     total ag pumping over crops and technologies     (L3 \ yr)   (1000 af \ yr)

urb_use_v      (miuse,    t)     urban water use                                  (L3 \ yr)   (1000 af \ yr)
urb_pump_v     (miuse,    t)     urban water pumping                              (L3 \ yr)   (1000 af \ yr)

yield_v        (aguse,j,k,t)     crop yield                                                   (tons    \ ac)

VARIABLES

*hydrology block

X_v            (i,        t)     flows -- all kinds                               (L3 \ yr)   (1000 af \ yr)

* urban block economics

urb_price_v    (miuse,    t)     urban price                                      ($US per af)
urb_con_surp_v (miuse,    t)     urban consumer surplus                           ($US 1000 per year)
urb_use_p_cap_v(miuse,    t)     urban use per customer                           (af \ yr)
urb_revenue_v  (miuse,    t)     urban gross revenues from water sales            ($US 1000 per year)
urb_gross_ben_v(miuse,    t)     urban gross benefits from water sales            ($US 1000 per year)
urb_costs_v    (miuse,    t)     urban costs of water supply                      ($US 1000 per year)
urb_value_v    (miuse,    t)     urban net economic benefits                      ($US 1000 per year)

Urb_value_af_v (miuse,    t)     urban economic benefits per acre foot            ($US per acre foot)
urb_m_value_v  (miuse,    t)     urban marginal benefits per acre foot            ($US per acre foot)

* economics block

Ag_costs_v     (aguse,j,k,t)     ag production costs (sw + gw)                    ($US 1000 \ yr)
Ag_value_v     (aguse,j,k,t)     ag net economic value (sw + gw)                  ($US 1000 \ yr)

Netrev_acre_v  (aguse,j,k,t)     ag net revenue per acre                          ($1000 \ yr)
Ag_Ben_v       (use,      t)     net income over crops by node and yr             ($1000 \ yr)
T_ag_ben_v                       Net income over crops nodes and yrs              ($1000 \ yr)

Ag_m_value_v   (aguse,j,k,t)     ag marginal (average) benefit                    ($US \ ac-ft)

MI_ben_v       (miuse,    t)     urban benefits by city and year                  ($1000 \ yr)

Env_ben_v      (river,    t)     enviornmental benefits by year                   ($1000 \ yr)

rec_ben_v      (res,      t)     reservoir recreation benefits by year            ($1000 \ yr)

Tot_ag_ben_v   (          t)     Total ag benefits by year                        ($1000 \ yr)
Tot_urb_ben_v  (          t)     Total urban benefits by year                     ($1000 \ yr)
Tot_env_riv_ben_v(        t)     Total river environmental benefits by year       ($1000 \ yr)
Tot_rec_res_ben_v(        t)     Total recreation reservoir benefits by yeaer     ($1000 \ yr)

Tot_ben_v      (          t)     total benefits over uses by year                 ($1000 \ yr)
DNPV_ben_v                       discounted NPV over uses and years               ($1000)
;

**************** Section 4 **************************************************************
*  The following equations state relationships among a basin's                          *
*  hydrology, institutions, and economics                                               *
*****************************************************************************************

EQUATIONS

*****************************************************************************************
* Equations named
*****************************************************************************************

* Land Block

Land_e         (aguse,    t)       Acres land                                    (L2 \ T)       (1000 ac \ yr)
Tacres_e       (aguse,j,k,t)       total acres in prodn (sw + gw)                (L2 \ T)       (1000 ac \ yr)
acres_pump_e   (aguse,j,k,t)       acres pumped (gw only)                        (L2 \ T)       (1000 ac \ yr)

* crop yield block

Yield0_e       (aguse,j,k,t)       Crop yield initial period                                       (tons \ ac)
Yield_e        (aguse,j,k,t)       Crop yield later periods                                        (tons \ ac)

* Hydrology Block

Inflows_e      (inflow,   t)       Flows: set source nodes                       (L3 \ T)       (1000 af \ yr)
Rivers_e       (i,        t)       Flows: mass balance by node                   (L3 \ T)       (1000 af \ yr)
Evaporation_e  (res,      t)       Flows: Evaporation by reservoir               (L3 \ T)       (1000 af \ yr)
Surf_area_e    (res,      t)       Flow: surface area by reservoir               (L2 \ T)       (1000 ac \ yr)

Agdiverts_e    (agdivert, t)       Flows: defines ag diverted water from acres   (L3 \ T)       (1000 af \ yr)
AgReturns_e    (agreturn, t)       Flows: defines return flows based on acrese   (L3 \ T)       (1000 af \ yr)
AgUses_e       (aguse,    t)       Flows: defines use flows based on acreage     (L3 \ T)       (1000 af \ yr)
Ag_use_e       (aguse,    t)       Flows: ag water use in readable format        (L3 \ T)       (1000 af \ yr)

MIReturns_e    (mireturn, t)       Flows: defines mi return flows based on acres (L3 \ T)       (1000 af \ yr)
MIUses_e       (miuse,    t)       Flows: defines mi use flows based on urb pop  (L3 \ T)       (1000 af \ yr)

MXUses_e       (mxuse,    t)       Flows: defines mexico return flows from acres (L3 \ T)       (1000 af \ yr)
MXReturns_e    (mxreturn, t)       Flows: defines mexico use  based on urb pop   (L3 \ T)       (1000 af \ yr)

reservoirs0_e  (res,      t)       Stock: starting reservoir level in base year  (L3 \ T)       (1000 af)
reservoirs_e   (res,      t)       Stock: reservoir mass balance accounting      (L3 \ T)       (1000 af \ yr)

aquifers0_e    (aqf,      t)       Stock: starting aquifer level in base yr      (L3 \ T)       (1000 af)
aquifers_e     (aqf,      t)       Stock: aquifer mass balance accounting        (L3 \ T)       (1000 af \ yr)

tot_ag_pump_e  (aguse,    t)       Flows: total ag pumping by node and year      (L3 \ T)       (1000 af \ yr)

*urban use block

urb_price_e    (miuse,    t)       urban water price                             ($US      \ af)
urb_con_surp_e (miuse,    t)       urban consumer surplus                        ($US 1000 \ yr)
urb_use_p_cap_e(miuse,    t)       urban use per customer                        (L3 \ T)        (af\ yr)
urb_revenue_e  (miuse,    t)       urban gross revenues from water sales         ($US 1000 \ yr)
urb_gross_ben_e(miuse,    t)       urban gross benefits from water sales         ($US 1000 \ yr)
urb_costs_e    (miuse,    t)       urban costs of water supply                   ($US 1000 \ yr)
urb_value_e    (miuse,    t)       Urban net economic benefits                   ($US 1000 \ yr)
urb_use_e      (miuse,    t)       urban use                                     (L3 \ T)        (1000 af \ yr)

Urb_value_af_e (miuse,    t)       urban average net economic benefits per ac ft ($US \ ac-ft)
urb_m_value_e  (miuse,    t)       urban marginal net benefits per ac-ftt        ($US \ ac-ft)

*Institutions Block (empty)

*RG_Compact_e(i,     t)        Rio Grande Compact Divides the Waters          (unitless)     (proportion 0 - 1)

* Ag Economics Block


Ag_costs_e     (aguse,j,k,t)       Agricultural production costs (sw + gw)       ($US   \ yr)
Ag_value_e     (aguse,j,k,t)       Agricultural net benefits     (sw + gw)       ($US   \ yr)

Netrev_acre_e  (aguse,j,k,t)       Net farm income per acre                      ($US   \ yr)
Ag_ben_e       (aguse,    t)       net farm income over crops and over acres     ($1000 \ yr)
T_ag_ben_e                         net farm income over crops nodes and yr       ($1000 \ yr)

Ag_m_value_e   (aguse,j,k,t)       ag average value per unit water               ($US   \ af)

* environmental benefits

Env_ben_e      (river,    t)       environmental benefits from surface storage   ($1000 \ yr)

* reservoir recreation benefits

Rec_ben_e      (res,      t)       storage reservoir recreation benefits         ($1000 \ yr)

Tot_ag_ben_e     (   t     )       Total ag benefits by year                     ($1000 \ yr)
Tot_urb_ben_e    (   t     )       Total urban benefits by year                  ($1000 \ yr)
Tot_env_riv_ben_e(   t     )       Total river environmental benefits by year    ($1000 \ yr)
Tot_rec_res_ben_e(   t     )       Total recreation reservoir benefits by yeaer  ($1000 \ yr)

Tot_ben_e        (   t     )       total benefits over uses                      ($1000 \ yr)

DNPV_ben_e                         discounted net present value over users       ($1000)
;

*****************************************************************************************
* Equations defined algebraically using equation names
*****************************************************************************************


*****************************************************************************************
*  Land  Block
*****************************************************************************************

Land_e(aguse,  t)..         sum((j,k), Tacres_v(aguse,  j,k,t))   =e= tot_acres_v(aguse,t);

*****************************************************************************************
* Hydrology  Block (in water units)
*****************************************************************************************

Inflows_e(inflow,t)..   X_v(inflow,t) =E= source_p(inflow,t);

Rivers_e(river,t)..     X_v(river,t)  =E= sum(inflow,    Bv_p(inflow, river)  * source_p(inflow, t)) +
                                          sum(riverp,    Bv_p(riverp, river)  *      X_v(riverp, t)) +
                                          sum(divert,    Bv_p(divert, river)  *      X_v(divert, t)) +
                                          sum(return,    Bv_p(return, river)  *      X_v(return, t)) +
                                          sum(rel,       Bv_p(rel,    river)  *      X_v(rel,    t)) ;

AgDiverts_e (agdivert,t)..  X_v(agdivert,t) =e= sum((j,k), Ba_divert_p(agdivert, j,k)  * sum(aguse, ID_adu_p(agdivert,aguse) * SWacres_v(aguse,j,k,t)));  // diversions prop to acreage
AgUses_e    (aguse,   t)..     X_v(aguse,t) =e= sum((j,k), Ba_use_p   (aguse,    j,k)  *    (1                             ) * SWacres_v(aguse,j,k,t)) ;  // use prop to acreage
AgReturns_e (agreturn,t)..  X_v(agreturn,t) =e= sum((j,k), Ba_return_p(agreturn, j,k)  * sum(aguse, ID_aru_p(agreturn,aguse) * SWacres_v(aguse,j,k,t)));  // return flows prop to acreage

MIUses_e    (miuse,   t)..  X_v(miuse,   t) =e=  sum(midivert, Bmdu_p(midivert,   miuse) *  X_v(midivert,t));
MIReturns_e (mireturn,t)..  X_v(mireturn,t) =e=  sum(midivert, Bmdr_p(midivert,mireturn) *  X_v(midivert,t));

MXUses_e    (mxuse,   t).. X_v(mxuse,    t) =e=  sum(mxdivert, Bmxdu_p(mxdivert,  mxuse) *  X_v(mxdivert,t));
MXReturns_e (mxreturn,t).. X_v(mxreturn, t) =e=  sum(mxdivert, Bmxdr_p(mxdivert,mxreturn)*  X_v(mxdivert,t));

reservoirs0_e(res,t) $ (ord(t) eq 1)..   Z_v(res,t) =e= Z0_p(res);

reservoirs_e (res,t) $ (ord(t) gt 1)..   Z_v(res,t)    =E=            Z_v(res,t-1)
                                        -  SUM(rel, BLv_p(rel,res)  * X_v(rel,t  ))
                                        -                   evaporation_v(res,t  );

Evaporation_e(res,t)..  Evaporation_v(res,t)  =e= Evap_rate_p   * surf_area_v(res,t);
Surf_area_e  (res,t)..    surf_area_v(res,t)  =e= B1_area_vol_p * Z_v(res,t) + B2_area_volsq_p * Z_v(res,t) ** 2;


aquifers0_e  (aqf,t) $ (ord(t) eq 1)..   Q_v(aqf,t)  =e= Q0_p(aqf);

aquifers_e   (aqf,t) $ (ord(t) gt 1)..   Q_v(aqf,t)  =e=  Q_v(aqf,t-1)
                                                          -sum(miuse,    urb_pump_v(miuse,t))
                                                          -sum(aguse, tot_ag_pump_v(aguse,t));

* accounting for pumping

tot_ag_pump_e(aguse,t)..  tot_ag_pump_v(aguse,t)  =e= sum((j,k), ag_pump_v(aguse,j,k,t));  // summed ag pumping by node and year

****************************************************************************************
* Institutions Block --water laws, compacts, treaties, etc constrains use (rules)
* defined in bounds below
****************************************************************************************

* Agriculture Block

Yield0_e    (aguse,j,k,t)  $ (ord(t) eq 0)..       yield_v(aguse,j,k,t)   =e= yield_p(aguse,j,k);
*Yield_e     (aguse,j,k,t)  $ (ord(t) gt 1)..       Yield_v(aguse,j,k,t)   =e=    B0_p(aguse,j,k)  + B1_p(aguse,j,k) * SWacres_v(aguse,j,k,t);
Yield_e     (aguse,j,k,t)  $ (ord(t) gt 1)..       Yield_v(aguse,j,k,t)   =e= yield_p(aguse,j,k);
****************************************************************************************
* Economics Block -- money units
****************************************************************************************

* urban econ block: approach documented by booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/

urb_price_e    (miuse,t)..      urb_price_v(miuse,t) =e=           BB0_p(miuse)  +         [bb1_p(miuse,t)  * urb_use_v(miuse,t)];    // urban demand price flattens as urban customer numbers grow.
urb_con_surp_e (miuse,t)..   urb_con_surp_v(miuse,t) =e=   0.5 * {[BB0_p(miuse) -   urb_price_v  (miuse,t)] * urb_use_v(miuse,t)};    // urban price is not known until model runs (dependent variable)
urb_use_p_cap_e(miuse,t)..  urb_use_p_cap_v(miuse,t) =e=       urb_use_v(miuse,t) /         pop_p(miuse,t);                           // per household urban water use typically about 0.5 acre feet/yr
urb_revenue_e  (miuse,t)..    urb_revenue_v(miuse,t) =e=     urb_price_v(miuse,t) *     urb_use_v(miuse,t);                           // urban gross tariff revenue
urb_gross_ben_e(miuse,t)..  urb_gross_ben_v(miuse,t) =e=  urb_con_surp_v(miuse,t) + urb_revenue_v(miuse,t);                           // tariff revenue + consumer surplus

urb_costs_e    (miuse,t)..    urb_costs_v  (miuse,t) =e=  (urb_Av_cost_p(miuse,t) *  X_v(miuse,t))  + (urb_av_gw_cost_p(miuse,t) * urb_pump_v(miuse,t));  // urb divert + pump costs of supply
urb_value_e    (miuse,t)..   urb_value_v   (miuse,t) =e= urb_gross_ben_v(miuse,t) -   urb_costs_v(miuse,t);                           // urban value - net benefits = gross benefits minus urban costs (cs + ps)
urb_use_e      (miuse,t)..   urb_use_v     (miuse,t) =e=     urb_pump_v(miuse,t) +        X_v(miuse,t);                               // urban use = divert + pump

Urb_value_af_e (miuse,t)..   Urb_value_af_v(miuse,t) =e=   (urb_value_v(miuse,t) / [urb_use_v(miuse,t) + 0.01]);  // [wat_use_urb_v(miuse,t) + 0.01]);                     // urban economic value per acre foot - includes consumer surplus
urb_m_value_e  (miuse,t)..  urb_m_value_v  (miuse,t) =e=    urb_price_v(miuse,t) - urb_av_cost_p(miuse,t) ;                              // urban marginal value per acre foot

* ag econ block:       approach documented by booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/



Tacres_e     (aguse,j,k,t)..     Tacres_v  (aguse,j,k,t)  =e=    SWacres_v(aguse,j,k,t) +  gwacres_v(aguse,j,k,t); // ac supplied by sw + gw
acres_pump_e (aguse,j,k,t)..      gwacres_v(aguse,j,k,t)  =e=  ag_pump_v(aguse,j,k,t) / Ba_use_p  (aguse,j,k  ); // ac supplied by gw

Ag_costs_e   (aguse,j,k,t)..     Ag_costs_v(aguse,j,k,t)  =e=   Tacres_v(aguse,j,k,t) *     cost_p(aguse,j,k  )
                                                           +   gwacres_v(aguse,j,k,t) *   Ba_use_p(aguse,j,k  ) * ag_av_gw_cost_p(aguse);

Ag_value_e   (aguse,j,k,t)..     Ag_value_v(aguse,j,k,t)  =e=    price_p(      j    ) * yield_v(aguse,j,k,t) *  Tacres_v(aguse,j,k,t)
                                                                                   - Ag_costs_v(aguse,j,k,t);  // farm income sw + gw

Netrev_acre_e(aguse,j,k,t)..  Netrev_acre_v(aguse,j,k,t)  =e=  ag_value_v(aguse,j,k,t) / (.01 + Tacres_v(aguse,j,k,t));   // Price_p(j) * Yield_v(aguse,j,k,t) - cost_p(aguse,j,k);

Ag_use_e     (aguse,    t)..       ag_use_v(aguse,    t)  =e=  X_v(aguse,t) +  sum((j,k), ag_pump_v(aguse,j,k,t));  // total sw + gw ag use

Ag_ben_e  (aguse,    t)..       Ag_Ben_v   (aguse,    t)   =E=                   sum((j,k  ),    Ag_value_v(aguse,   j,k,t));
T_ag_ben_e             ..       T_ag_ben_v                 =E=            sum((aguse,     t),      Ag_Ben_v(aguse,       t));

Ag_m_value_e(aguse,j,k,t)..    Ag_m_value_v(aguse,j,k,t)   =e=  [price_p(j) * Yield_v(aguse,j,k,t) - Cost_p(aguse,j,k)] * (1/Bau_p(aguse,j,k)) +
                                                             SWacres_v(aguse,j,k,t) * price_p(j) *       B1_p(aguse,j,k)  * (1/Bau_p(aguse,j,k));
* environmental benefit

Env_ben_e(river,t) $ (ord(river) = card(river))..    env_ben_v('below_EPID_v_f',t)  =e=   1000 * X_v('below_EPID_v_f',t)** 0.1;

* reservoir recreation benefit at surface reservoir storage

Rec_ben_e(res,t)..                                   rec_ben_v(res,t)  =e=   1500  * surf_area_v(res,t)** 0.5;  // simple square root function synthetic data
* total economic welfare                                                     //1500

Tot_ben_e (          t)..  Tot_ben_v       (          t)   =e=  sum(aguse, ag_ben_v       (aguse,     t))
                                                              + sum(miuse, urb_value_v    (miuse,     t))
                                                              + sum(res,   rec_ben_v      (res,       t))
                                                              +            env_ben_v('below_EPID_v_f',t);  // small benefit from instream flow ds of el paso


Tot_ag_ben_e     (t     )..   Tot_ag_ben_v     (t     )   =e=  sum(aguse, ag_ben_v      (aguse,            t     ));
Tot_urb_ben_e    (t     )..   Tot_urb_ben_v    (t     )   =e=  sum(miuse, urb_value_v   (miuse,            t     ));
Tot_env_riv_ben_e(t     )..   Tot_env_riv_ben_v(t     )   =e=             env_ben_v     ('below_epid_v_f', t     ) ;
Tot_rec_res_ben_e(t     )..   Tot_rec_res_ben_v(t     )   =e=  sum(res,   rec_ben_v     (res,              t     ));


DNPV_ben_e               ..  DNPV_ben_v                   =e=  sum(tlater,         tot_ag_ben_v(tlater))
                                                           +   sum(tlater,        tot_urb_ben_v(tlater))
                                                           +   sum(tlater,    tot_env_riv_ben_v(tlater))
                                                           +   sum(t     ,    tot_rec_res_ben_v(t     ));

***************************  End of equations *******************************************

**************** Section 5 **************************************************************
*  The following section defines models.                                                *
*  Each model is defined by a set of equations used                                     *
*  for which one single variable is optimized (min or max)                              *
*****************************************************************************************

* This simple prototype model uses ALL equations defined above.  Some larger models
* may exclude some equations. For example, each institution could be defined
* by one equation.  And each of several models might conduct a single policy experiment
* in which that model tries out a single institution.  This would require deleting all
* institutional equations except the one analyzed.
* If you need to EXclude some equations, list INcluded equations where ALL appears below

MODEL RIO_PROTOTYPE /ALL/;

**************** Section 6 **************************************************************
*  The following section defines all solves requested,
*  Each solve states a single model for which an optimum is requested.
*
*  Upper, lower and fixed bounds on certain variables are included here
*  Bounding variables here gives that variable a non-zero shadow price where the optimal
*  solution appears at that boundary.  If the bound doesn't constrain the model
*  the variable's shadow price is zero (see complementary slackness)
*****************************************************************************************

* bounds follow

tot_acres_v.up(aguse,    t) = LANDRHS_p(aguse);
tacres_v.up   (aguse,j,k,t) =   land_p(aguse,j,k);  // observed acreage by crop

X_v.up('store_out_v_f', tfirst) = 0;    // no storage outflow in starting period
X_v.up(divert,          tfirst) = eps;  // no diversions or use in starting period

urb_pump_v.up(miuse,t)      =  urb_gw_pump_capacity_p(miuse);   // upper bound on urban pumping capacity by city
tot_ag_pump_v.up(aguse,t)   =   ag_gw_pump_capacity_p(aguse);   // upper bound on ag pumping by farming area

Q_v.lo('store_aqf_s',tlast)  = gw_sustain_p * Q0_p('store_aqf_s');  // aquifer must return to starting conditions in last period

* positive required variables for all of the following flow variables

X_v.lo(inflow,t)   = 0;
X_v.lo(river, t)   = 0;
X_v.lo(divert,t)   = 0;
X_v.lo(use,   t)   = 0;
X_v.lo(return,t)   = 0;

Z_v.up(res, t    ) = Zmax_p(res);                                   // storage cannot exceed max storage capacity
*Z_v.lo(res, tlast) = sw_sustain_p * Z0_p(res);                      // elephant butte reservoir vol > 0.5 * starting value

X_v.lo('NM_TX_line_v_f',tlater)  = tx_proj_op_p * source_p('Marcial_h_f',tlater); // NM-TX water sharing agreement - TX gets at least 43% of flows
X_v.lo('MX_d_f',        tlater)  = us_mx_1906_p;                                  // US-MX treaty of 1906

SOLVE RIO_PROTOTYPE USING NLP MAXIMIZING DNPV_ben_v;                              // urban and later ag benefits are both quadratic functions

***************** post optimiality display of data and results **************************

parameter

*land
SWacres_p        (use,j,k,t)    sw acreage                       (1000 ac)
GWacres_p        (use,j,k,t)    gw acreage                       (1000 ac)

* crops

Yield_opt_p    (aguse,j,k,t)  crop yield                         (tons \ ac)

* water stocks
wat_stocks_p   (res,    t)    stocks by pd                       (1000 af \ yr)
wat_stock0_p   (res      )    starting value                     (1000 af \ yr)


gw_stocks_p   (aqf,     t)    gw aquifer stocks by pd            (1000 af by year)
gw_stocks0_p  (aqf       )    gw aquifer starting stocks         (1000 af)

* water flows

Evaporation_p  (res,    t)    total evap by period               (1000 af \ yr)
surf_area_p    (res,    t)    total surf area by period          (1000 ac \ yr)

inflows_p      (inflow, t)    inflows by pd                      (1000 af \ yr)
wat_flows_p    (i,      t)    flows by pd                        (1000 af \ yr)
river_flows_p  (river,  t)    river flows by pd                  (1000 af \ yr)
diversions_p   (divert, t)    diversions                         (1000 af \ yr)
use_p          (use,    t)    use                                (1000 af \ yr)
return_p       (return, t)    return flows                       (1000 af \ yr)

Ag_use_pp      (aguse,  t)    ag use                             (1000 af \ yr)
tot_ag_pump_p  (aguse,  t)    total ag pumping                   (1000 af \ yr)
urb_use_pp     (miuse,  t)    urban water use                    (1000 af \ yr)
urb_sw_use_p   (miuse,  t)    urban surface water use            (1000 af \ yr)
urb_pump_p     (miuse,  t)    urban water pumpoing               (1000 af \ yr)

* econ
urb_price_pp   (miuse,  t)    urban price                        ($ per af)
urb_con_surp_p (miuse,  t)    urban consumer surplus             ($1000 \ yr)
urb_use_p_cap_p(miuse,  t)    urban use per capita               (af \ person)
urb_revenue_p  (miuse,  t)    urban revenue                      ($1000 \ yr)
urb_gross_ben_p(miuse,  t)    urban gross econ benefit           ($1000 \ yr)
urb_costs_p    (miuse,  t)    urban costs of prodn               ($1000 \ yr)
urb_value_p    (miuse,  t)    urban total net benefit            ($1000 \ yr)

urb_value_af_p (miuse,  t)    urban net value per unit water     ($ \ af)

urb_m_value_p  (miuse,  t)    urban marginal value               ($ per af)

Ag_value_p     (aguse,j,k,t)  ag net benefits by crop            ($1000 \ yr)
*Ag_Ben_j_p     (aguse,j,k,t)  ag benefits by crop                ($1000 \ yr)
Ag_Ben_p       (aguse,    t)  ag benefits                        ($1000 \ yr)
Ag_m_value_p   (aguse,j,k,t)  ag marginal value of water         ($ \ af    )

rec_ben_p      (res,      t)  recreation benefit                 ($1000 \ yr)
env_ben_p      (river,    t)  environmental benefit from flows   ($1000 \ yr)

T_ag_ben_p                    total benefits                     ($1000)
Env_ben_p      (river,    t)  Env benefits at stream gauges      ($1000 \ yr)
Tot_ben_p      (          t)  total benefits over uses           ($1000 \ yr)

DNPV_ben_p                    disc net present value of benefit  ($1000)
;

*stocks
*surface reservoir storage
wat_stocks_p  (res,      t)   =          Z_v.l    (res,      t)  + eps;
wat_stock0_p  (res        )   =          Z0_p     (res        )  + eps;

*groundwater aquifer storage
gw_stocks_p   (aqf,      t)   =          Q_v.l    (aqf,      t)  + eps;
gw_stocks0_p  (aqf        )   =          Q0_p     (aqf        )  + eps;

*flows
inflows_p     (inflow,   t)   =          X_v.l    (inflow,   t)  + eps;
river_flows_p (river,    t)   =          X_v.l    (river,    t)  + eps;
diversions_p  (divert,   t)   =          X_v.l    (divert,   t)  + eps;
use_p         (use,      t)   =          X_v.l    (use,      t)  + eps;
return_p      (return,   t)   =          X_v.l    (return,   t)  + eps;

wat_flows_p   (i,        t)   =          X_v.l    (i,        t)  + eps;

urb_use_pp    (miuse,    t)   =     urb_use_v.l   (miuse,    t)  + eps;
urb_sw_use_p  (miuse,    t)   =           X_v.l   (miuse,    t)  + eps;
urb_pump_p    (miuse,    t)   =    urb_pump_v.l   (miuse,    t)  + eps;

ag_use_pp     (aguse,    t)   =           X_v.l   (aguse,    t)  + eps;

tot_ag_pump_p (aguse,    t)   = tot_ag_pump_v.l   (aguse,    t)  + eps;

Evaporation_p (res,     t)    =    Evaporation_v.l(res,      t)  + eps;


surf_area_p   (res,     t)    =     surf_area_v.l (res,      t)  + eps;

* land
SWacres_p     (aguse,j,k,t)   =    SWacres_v.l    (aguse,j,k,t)  + eps;
GWacres_p     (aguse,j,k,t)   =    GWacres_v.l    (aguse,j,k,t)  + eps;

* crops
Yield_opt_p   (aguse,j,k,t)   =         Yield_v.l (aguse,j,k,t)  + eps;

* urban benefits and related

urb_price_pp   (miuse,   t)   =    urb_price_v.l    (miuse,  t)  + eps;
urb_con_surp_p (miuse,   t)   =    urb_con_surp_v.l (miuse,  t)  + eps;
urb_use_p_cap_p(miuse,   t)   =    urb_use_p_cap_v.l(miuse,  t)  + eps;
urb_revenue_p  (miuse,   t)   =    urb_revenue_v.l  (miuse,  t)  + eps;
urb_gross_ben_p(miuse,   t)   =    urb_gross_ben_v.l(miuse,  t)  + eps;
urb_costs_p    (miuse,   t)   =    urb_costs_v.l    (miuse,  t)  + eps;
urb_value_p    (miuse,   t)   =    urb_value_v.l    (miuse,  t)  + eps;

urb_value_af_p (miuse,   t)   =    urb_value_af_v.l (miuse,  t)  + eps;

urb_m_value_p  (miuse,   t)   =  urb_m_value_v.l    (miuse,  t)  + eps;


* ag benefits and related

Ag_value_p  (aguse,j,k,t)   =        Ag_value_v.l(aguse, j,k,t)  + eps;
Ag_Ben_p    (aguse,    t)   =        Ag_Ben_v.l  (aguse,     t)  + eps;
t_ag_ben_p                  =        t_ag_ben_v.l                + eps;
Ag_m_value_p(aguse,j,k,t)   =      Ag_m_value_v.l(aguse, j,k,t)  + eps;

* environmental benefits from streamflow

Env_ben_p   ('below_epid_v_f',t)= Env_ben_v.l('below_epid_v_f',  t)  + eps;

*  rec benefits from reservoir storage

rec_ben_p   (res,      t)   =          rec_ben_v.l(res,      t)  + eps;

* total benefits

Tot_ben_p   (          t)   =           Tot_ben_v.l(          t) + eps;
DNPV_ben_p                  =           DNPV_ben_v.l             + eps;

execute_unload "rio_proto_watershed_bucket_oct3_2016.gdx"

Evap_rate_p,  B1_area_vol_p, Z0_p
wat_flows_p,  wat_stocks_p,  wat_stock0_p,    river_flows_p,  inflows_p, t_ag_ben_p,
diversions_p, SWacres_p,     GWacres_p,       use_p, return_p, pop_p,          price_p, cost_p, netrev_acre_p,
yield_p,      land_p,        urb_price_pp,    urb_con_surp_p, urb_use_p_cap_p, ag_value_p,
ag_ben_p,     ag_m_value_p,  t_ag_ben_p,      yield_opt_p,    Ba_use_p
urb_av_cost_p, elast_p,      tx_proj_op_p     ag_use_pp       urb_pump_p,  urb_sw_use_p

urb_revenue_p, urb_gross_ben_p, urb_costs_p, urb_value_p, urb_value_af_p,
urb_use_pp, urb_m_value_p, zmax_p Evaporation_p, surf_area_p
env_ben_p, tot_ben_p, dnpv_ben_p,us_mx_1906_p, sw_sustain_p, gw_sustain_p
rec_ben_p, env_ben_p, tot_ag_pump_p,
gw_stocks_p, gw_stocks0_p urb_gw_pump_capacity_p gw_stocks0_p qmax_p
urb_av_gw_cost_p ag_av_gw_cost_p urb_gw_pump_capacity_p  ag_gw_pump_capacity_p

;

$onecho > gdxxrwout.txt

i=rio_proto_watershed_bucket_oct3_2016.gdx
* o=rio_proto_watershed_bucket_oct3_2016.xls

epsout = 0

************************************************************************
* DATA READ AND USED BY RIO GRANDE BASIN MODEL
************************************************************************

* institutional constraints

par = us_mx_1906_p           rng = data_us_mx_1906_flows!c4    cdim = 0
par = tx_proj_op_p           rng = data_tx_project_op!c4       cdim = 0
par = sw_sustain_p           rng = data_sw_sustainability!c4   cdim = 0
par = gw_sustain_p           rng = data_gw_sustainability!c4   cdim = 0

* technical constraints

par = urb_gw_pump_capacity_p rng = data_urb_pump_capacity!c4   cdim = 0
par = ag_gw_pump_capacity_p  rng = data_ag_pump_capacity!c4    cdim = 0

* hydrology data

par = inflows_p              rng =  data_basin_inflows!c4      cdim = 0
par = wat_stock0_p           rng =  data_start_storage!c4      cdim = 0
par = gw_stocks0_p           rng =  data_start_gw_stocks!c4    cdim = 0
par = qmax_p                 rng =  data_max_aqf_capac!c4      cdim = 0

par = Evap_rate_p            rng =  data_evap_rate_ft_yr!c4    cdim = 0
par = B1_area_vol_p          rng =  data_acre_per_af!c4        cdim = 0
par = Zmax_p                 rng =  data_store_capacity!c4     cdim = 0

* crop data
par = yield_p                rng =  data_yield!c4              cdim = 0
par = land_p                 rng =  data_land!c4               cdim = 0

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

******************* END OF DATA READ BY MODEL ***************************

*************************************************************************
* MODEL OPTIMIZED RESULTS FROM RIO GRANDE BASIN MODEL
*************************************************************************

* land block

par = SWacres_p              rng =  opt_sw_acreage!c4          cdim = 0
par = GWacres_p              rng =  opt_gw_acreage!c4          cdim = 0

* crop block

par = yield_opt_p            rng = opt_yield!c4                cdim = 0

*hydrology block

par = Evaporation_p          rng = opt_evaporation!c4          cdim = 0
par = surf_area_p            rng = opt_surf_area!c4            cdim = 0

par = wat_flows_p            rng =  opt_water_flows!c4         cdim = 0
par = river_flows_p          rng =  opt_river_flows!c4         cdim = 0
par = diversions_p           rng =  opt_diversions!c4          cdim = 0
par = use_p                  rng =  opt_use!c4                 cdim = 0
par = return_p               rng =  opt_return!c4              cdim = 0

par = ag_use_pp              rng =  opt_ag_use!c4              cdim = 0
par = urb_use_pp             rng =  opt_urban_tot_use!c4       cdim = 0
par = urb_sw_use_p           rng =  opt_urb_sw_use!c4          cdim = 0

par = urb_pump_p             rng =  opt_urban_pumping!c4       cdim = 0
par = tot_ag_pump_p          rng =  opt_ag_pumping!c4          cdim = 0

par = wat_stocks_p           rng =  opt_water_stocks!c4        cdim = 0
par = gw_stocks_p            rng =  opt_gw_stocks!c4           cdim = 0

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

************************ end of model optimized results ******************

$offecho
* execute 'gdxxrw.exe @gdxxrwout.txt trace=2';

***********************  the end *****************************************
