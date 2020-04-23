$EOLCOM //
$TITLE RIO GRANDE BASIN HYDROECONOMIC PROTOTYPE
$OFFSYMXREF OFFSYMLIST OnLISTING OFFUPPER

OPTION LIMROW=200, LIMCOL = 0;
*option  ITERLIM = 5000000;


$ONTEXT

* ----------------------------------------------------------------------------------------------------------------------------------------------------------

Jan 23 2019.  Trying to choke all use to zero with no SM inflows, protect terminal aquifer, starting with almost no storage.

Issues

1. still some urban use (consumer surplus and net urban benefits should be zero at a finite price)
2. EPMI seems to be the problem.
3. Some residual ag use and benefits remaining.


Improvements made since October 24:

1.  keep crop yields constant, not rising with water shortages
2.  keep net revenue per acre foot consumed close: but still ranked:  pecans, veges, forage

Simple calibration comes from:

set gw and backstop price at $1000 per acre to be sure income falls with surface water stress.

Acreage and farm income fall ok to about 60% of base water levels

This model sets aquifer recharge from ag river diversions to zero.

urban pumping slightly higher with reduced river flow for EPWU, as it's the only city using surface water

Try limiting urban pumping and backstop use to base levels and see if urban prices for EPWU uniformly rise when surface supplies fall.  They now do

Fixes sice Sat, Dec 15 2018

1.  (Dec 15, 2018)  delete the upper bounds on urban pumping and urban backstop use appearing near looped solve with stress compared to non-stressed.  Result should raise urban pumping and backstop use with stress


2.   (Dec 16, 2018) Re-introduce aquifer recharge from ag diversions, then check water balance and economic impacts.

     a.  check that farm income and urban benefit impacts from surface shortages still reasonmable.
     Also limit ag + urban groundwater pumping with stress to not exceed it without stress.

     b.  check that aquifer recharge is lower with surface stress than without it, since surface irrigation will recharge less to the aquifer as surface irrigation must fall with no
     offsetting growth in aquifer pumping.

3.   (Dec 16, 2018):  Model name:  rgr_watershed_bucket_dec_16_2018_6pm

     Reduce pumping cost to plausible levels, but allow no pumping growth with stress compared to without. Economic benefits, esp to ag should grow lots,
     as pump costs fall.  Costs of protecting aquifers should also rise, since base pumping is now much higher.

     reducing pump costs below surface costs still not making pumped acreage or use larger than surface.  Checking to see if net revenue per acre foot (variable) is correctly
     ranked for the 3 crop types.   net revenue per acre foot seem wrong...need to check

4.   (Dec 19 2018):  Model name:   rgr_watershed_bucket_dec_19_2018_10am

      Checked acreages to be sure that ranking was still pecans, veges, forage, by making net revenue per acre and per acre foot close, but still ranked
      pecans, veges, forage:  This should cause forage to drop our first when surface water stress occurs:

      WORKS:  Results is 0.74 income earned when surface water falls to 50% of base levels when gw pumping still cannot exceed base levels.
      gw balance is maintained (a_table_00_predictions_hydro) and sw too (a_table_00_graphics_hydro)


5.  fixed: upper bounds pecans/veges no larger under reduced surface water than under base surface water (rgr_watershed_bucket_dec_19_2018_10pm)

6.   Dec 20 230 pm Allowed gw pumping to increase to offset surface water shortages.  REsults are good, as farm income losses are mititgated
     but groundwater balance seems lost. Now fixed

7.   Dec 21 pm:   rgr_watershed_bucket_dec_31_2018_9pm.  Now have aquifer protection shadow prices working for average and terminal periods
     Try enforcing both as well as neither.  Done and working

8.  Dec 22 pm:  shadow prices from 1st unit of cheap bt acreage is zero when water is priced at zero is sometimes negative in early years.
                Investigation turned up no real suspects

                Investigated capacity to pay for backstop water by setting is price at 0 and supply at a small upper bound.  New
                Shadow price of backstop tech acreage is about 200 per acre when basckstop water is free, and is 800-1200 per acre foot for urban use

                added: shad_price_urb_back_use_p(miuse,    t,p,w,s1,s2,s3,s4)    =  urb_back_use_v.m(miuse,    t,p,w,s1,s2,s3,s4)
                added: shad_price_ag_back_use_p (aguse,j,k,t,p,w,s1,s2,s3,s4)    =  ag_back_use_v.m (aguse,j,k,t,p,w,s1,s2,s3,s4)

9.  Dec 23 pm:  added detail on farm income eocnomics as improved sensor detail

10. Dec 24 am:  inserted lower bound of -1000 acres on backstop technology ag use to avoid forcing shadow price of free backstop use at 0

11. Dec 24 pm:  Added max capacity to pay for backstop water for both urban and farm use including spreadsheet worksheets
                a.  opt_shad_p_urb_b_use_p
                b.  opt_shad_p_ag_b_use_p

12  Dec 26 pm:  Increased hot start code to speed up model runs, since model now has 40 runs
                Increased from 2 to 5 water supply inflow scenarios.

13  Dec 28:     Inserted real inflow scenarios from Dave and Nolan's work

14  Dec 29 am:  Added capacity to import surface water above the Caballo gauge at a user-set cost per acre foot with an infinite upper bound on quantity avaailable
                model is rgr_watershed_bucket_dec_29_10pm_5_climates.gms

15. Jan 2 pm:   fixed up placeholder ag net revenue data that had been used to trap errors.  Also split urban price elasticity of demand out by city:
                model name is rgr_watershed_bucket_jan_2_6pm.gms

15  Jan 2-6 pm: Model name is rgr_watershed_bucket_jan_5_2019_7pm_wi_hyp_evap.gms

                Used Alex Mayer's improved data on evap and rainfall: still not varying by year
                Still need to add waterhsed inflows at 5 gauges.

16  Jan 5-19    Model name is rgr_watershed_bucket_jan_19_2019_1132pm_wi_climate_imp_exp.gms

                Main addition is to allow both imports and exports at Caballo, El Paso, and all other gauges
                to handle severe shortages and surplies.  Imports at a cost per af, exports at a lower cost per af
                also now reads Dave Gutzler's and Nolan Townsend's latest (Jan 1) San Marcial Inflow climate scenarios

17  Jan 21      Model name is rgr_bucket_jan_21_2019_230pm

                Replaced old San Marcial Inflow scenarios with the latest from Dave Gutzler and Nolan Townsend.
                Also has actual evap, precip, and watershed inflows provided by Alex Mayer
                Still waiting for Alex Mayer's hypsographics for Elephant Butte and Caballo reflecting
                total surface area as a function of total storage.  Current model has only linear approximation

18  Jan 27 2019  Model name is rgr_watershed_bucket_Jan_27_2019_830pm

                Several smoothing little changes, including putting upper and lower bounds on 4 dimensions of 2008
                Project Operating Agreement, rather than equalities.

                Also simplfied aquifer stresses in terms of (1) overall recharge and (2) overall discharge.
                change in storage now equals base storage + recharge - discharge = simple water balance

* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------


* CONTACTS

  Frank A. Ward:
  Dept of Agr Economics/Agr Business
  New Mexico State University, Las Cruces, NM USA
  e-mail: fward@nmsu.edu

* Alex Mayer
  Michigan Technical University
  asmayer@mtu.edu

  Jan 2019

Rio Grande Basin Model: Expandable Prototype
Contains essential elements of full Upper Rio Grande Basin Model.
Sponsor:  USDA NIFA 5 year grant beginning March 2015


* ----------------------------------------------------------------------------------------
* STATUS AND PLANS FOR IMPROVEMENTS
* ----------------------------------------------------------------------------------------

* Improvements since March 24, 2017

* Adds historical data on irrigated acreage in EBID, EPID   (March 25, 2017)
* Adds MX treaty flows                                      (March 26, 2017)
* Treats MX ag as part of the overall ag subset             (March 30, 2017)
* Deletes MX as a separate node                             (March 30, 2017)
* adds tables for irrigated acreage (tables 8)              (March 31, 2017)
* renames excel tabs splitting sw v gw ag water use         (March 31, 2017)
* adjusted tables 7b 8a 8b 8c to account for MX ag          (March 31, 2017)
* requested MX irrigated acreage data                       (March 31, 2017)
* received from Alfredo                                     (April 3,  2017)
* Adds MX irrigated acreage as real data (Alfredo G)        (April 4,  2017)
* MX irrigated ag uses surface water but shifts to pumping  (April 4,  2017)
* coded in MX ag pumping capacity (all Hueco) 75 Kaf/yr     (April 4,  2017)
* in short surface years (< 60K AF/yr)

* coded in backstop (high cost) tech urban                  (April 14, 2017)
* coded in backstop (high cost) tech aqf rech for urb       (April 15, 2017)

* Worked with Alex Mayer on Mesilla Aquifer Regression simulation   (April 16, 2017 - June 1, 2017)

GAMS MODEL UPDATES                                          (June 1 - July 19, 2017)
* Worked with Alex Mayer to get simulation of Mesilla aquifer working, to complement optimization
* Upgraded GAMS optimization model for several improvements

*  Altered years to read 1993 - 2015
*  Introduced 8 article-ready table templates (July 4)
*  Ran very low (10% of historic) San Marcial inflows through the model to test for feasibility and plausibility
*  Model now reads historical gauged flows at Caballo, EP and Ft Quitman, set as constraints for historical policy and historical flows,
*           but not for alternative policies alternative (drought) inflows
*  Introduced approximately accurate Mexico ag data into the model.  Thanks to Alfredo Granados and team
*  Introduced Mexican ag benefits as part of the basin economic objective
*  Model switches into backstop urban when surface inflows fall too low or pump costs rise too high

*  update from August 1 2017 to August 7 2017:  Cleaned up a few typos and Introduced upper bound on MX urban + ag surface use (US - MX treaty)
*  currently August 2017 there is no urban surface treatment in Mexico

*  update beginning October 7, 2017: Introduce equations to account for historical rules governing water release and delivery
*    1.  Caballo releases as a function of starting storage and inflow: substituted lower bounds on Caballo releases under base history with formula for
*               Caballo releases based on SM inflows
*               Also widened bounds on El Paso flows for base history to keep model feasible.
*    2.  (not done yet) Annual allocation to EBID, EP1, and MX based on inflows described in 2008 operating agreement

* update for November 11 2017

* set caballo releases to regression historical level, as a fn of storage and san marcial inflows if beginning of year storage is below 900 000 acre feet
* also need to set release at 890 000 otherwise
* also need to give Mexico the D1 formula in place of Mexico actual data

* need to fix line 2029 constraint on project operation without being infeasible

* update for Nov 18 2017

* releases at least equal to linear regression as fn of inflows and storage
* inserted simple US MX treaty delieries to MX based on Caballo releases with an upper bound of 60KAF
* problem with and without operating agreement produced same answer

* Major improvement for Nov 20 2017

* reduced policy to 2 choices from 3: now, with and without project operating agreement
* kept water supply scenarios at 2: historical and user changeable inflow reductions...runs at 0% historical inflows

* with 2008 project operating: simple regression without intercept.  Requires Caballo release as fn of inflow only not of project storage
* caballo releases approximately fixed to linear regression caballo release rule.  Very low caballo releases with very low inflow, makes up with ag pump
* Caballo releases never more than 820 KAF per year
* return TX delivies to at least 43% of Caballo releases
* Mexico gets 60 KAF or 12% of Caballo releases
* result: with project operating agreement always has lower benefits as it has tighter constraints for actual or potential SM inflows


Improvements Nov 26 2017

Add a sensitivity set to allow multiple sets of assumptions for each set of runs, e.g., varying the cost of the urban backstop technology.
This permits a sensitivity analysis of impacts of changing assumptions.  Sensitivities are (1) reducing cost of backstop technology, (2)
raising cost per unit depth of pumping, (3) increasing surface inflows, (4) raising discount rate

Improvements Nov 30 2017

Added code for pumping cost to be a function of pumping depth...reduces DNPV and increases sensitivity of reduced backstop technology costs on DNVP
See lines 1884-1887

Improvements Dec 12 2017

  Added code for detail on ag costs
  Completed assumptions, results (4 scenarios) and sensitivities tables

Improvements Dec 13-28 2017

  Needs backstop technology for irrigated agriculture
  Needs aquifer pump cost to increase with depth, self-limiting pumping for ag.
  Needs to calibrate aquifer pump depth to calibrate to approximately historical record 1994-2013
  Added output table showing impact of backstop technology cost reduction
  Added code to alphabetically arrange worksheets left to right
  Added code to list all worksheets alphabetically for easy clickable access
  Fixed ag costs, with net revenue closer to history
  Streamlined code to account uniquely for all aquifers for both urban and ag pumping
  Added code for backstop technology use by agriculture if price is sufficiently low.  Typically too expensive at 1500/af for normal use in agriculture

Improvements Dec 30-31 2017

Improved sustainability code:

returns to 90% of full with both asuifers in terminal period
returns to 2.5% of full with reservoir storage in terminal period
tracks shadow prices of terminal aquifer and reservoir conditions

Jan 1 - Jan 7 2018

* exactly 52% of Caballo releases makes it to El Paso Gauge in every year under 2008 operating agreement (moved from bounds to equations); based on hist regression
* exactly 34% of el paso gauge flows makes it to below epid every year under 2008 operating policy, based on historical regressions
* Caballo releases as a fn of SM inflows and project storage moved from bounds to equations,based on historical regressions
* climate stressed surface water supply raised from 0% of historical to 30% of historical
* urban economic variables moved from free to positive variables.  Prices were sometimes negative (nonsensical)
* With these changes, model takes about twice as long to run, about 1200 iterations per run, 20 minutes for a 64 model run
* Results tables look more plausible

Jan 8 - Jan 14 2018

* GAMS model now hot starts: each new optimization starts at the optimized solution of previous optimization.  Speeds up run time by a factor of about 5. Causes fewer false infeasibilities
* Reduces 1200 iterations for typical model run to about 250 per typical model run
* Introduced worksheet showing number of iterations per model run,
* Setting epsilon levels to near zero to assigns very small changes for 4 parameters that change with sensitivity levels
* 4 parameters varied in sensitivity analysis are
*   (1) price of urban backstop technology, with small change
*   (2) cost per foot depth per acre foot pumped, with small change
*   (3) starting project reservoir storage, with small change
*   (4) reservoir evaporation rate, with small change
* Caught and fixed large number of little errors so that sensitivity table 07 results produce more plausible results
* Complete suite of 64 optimization models now run in clock time of just under 2 minutes


summer early fall 2018

* paper under review at J of Hydrology
* asks for revisions with more policy measures and more realistic climate stress scenarios

* as of October 14 2018 now have
* 2 climate stress sceanarios
* 8 policy options 2 x 2 x 2 (all dealing with presence of absence of groundwater protection measures)

IMPROVEMENTS NEEDED

*  Need to get MX urban data right
*  Needs low surface inflows to reduce MX ag lands in production

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
i     Flows -- important nodes middle RG Basin -- Elephant Butte NM to Fort Quitman TX
*---------------------------------------------------------------------------------------*

/     Marcial_h_f        Headwater flow nodes                                 inflow(i)
      WS_Caballo_h_f     watershed inflow to RG above Caballo outflow
      WS_El_Paso_h_f     watershed inflow to RG at El Paso
      WS_above_MX_h_f    watershed inflow to RG above MX diversion
      WS_below_MX_h_f    watershed inflow to RG belos MX diversion
      WS_below_EPID_h_f  watershed inflow to RG below El Paso

      RG_Caballo_out_v_f Rio Grande at Caballo outflow                      river(i)
      RG_El_Paso_v_f     Rio Grande at el paso above am dam divert
      RG_above_MX_v_f    Rio Grande below am dam above mx divert
      RG_below_MX_v_f    Rio Grande below MX turnout (calc not gauged)
      RG_below_EPID_v_f  rio Grande at Fort Quitman

      IMP_Caballo_m_f    imported inflows to RG above Caballo gauge at a cost imports(i)

      EXP_Caballo_x_f     exported outflows above Caballo gauge at a cost      exports(i)
      EXP_El_Paso_x_f     exported outflows above El Paso Gauge at a cost      exports(i)
      EXP_above_MX_x_f    exported outflows above Caballo gauge at a cost      exports(i)
      EXP_below_MX_x_f    exported outflows above El Paso Gauge at a cost      exports(i)
      EXP_below_EPID_x_f  exported outflows above Caballo gauge at a cost      exports(i)


      EBID_d_f        Diversion nodes                                      divert(i)
      LCMI_d_f
      EPID_d_f
      EPMI_d_f
      MXID_d_f
      MXMI_d_f


      EBID_u_f        Consumptive use flow nodes                            use(i)
      LCMI_u_f
      EPID_u_f
      EPMI_u_f
      MXID_u_f
      MXMI_u_f


      EBID_rr_f        river return flow to river nodes                    r_return(i)
      LCMI_rr_f
      EPID_rr_f
      EPMI_rr_f
      MXID_rr_f
      MXMI_rr_f


      EBID_ra_f        river Return flow to aquifer nodes                  a_return(i)
      LCMI_ra_f
      EPID_ra_f
      EPMI_ra_f
      MXID_ra_f
      MXMI_ra_f

      Store_rel_f     Res storage-to-river release node (outflow - inflow)  rel(i)
/
*---------------------------------------------------------------------------------------*
*     Subsets of all Flow nodes above by class (function)
*---------------------------------------------------------------------------------------*

inflow(i)             Headwater flow nodes                        inflow(i)

/     Marcial_h_f           Rio Grande headwaters CO
      WS_Caballo_h_f        Watershed inflow above Caballo Reservoir
      WS_El_Paso_h_f        Watershed inflow between Caballo and EP Gauge
      WS_above_MX_h_f       Watershed inflow between EP Gauge and MX
      WS_below_MX_h_f       Watershed inflow below Mexico outtake
      WS_below_EPID_h_f     Watershed inflow below EP Irrigation 1 District
/

river(i)              River gage measurement nodes                river(i)

/     RG_Caballo_out_v_f RGR project storage outflow gauge on RG
      RG_El_Paso_v_f     New Mexico Texas State Line on RG
      RG_above_MX_v_f    Rio Grande above Mexico diversion
      RG_below_MX_v_f    Rio Grande below Mexico diversion
      RG_below_EPID_v_f  Gauge below EP irrigation diversion use on RG
/

imports(i)            River import nodes                          imports(i)

/    IMP_Caballo_m_f    imported inflows to RG below Caballo and above Caballo outflow gauge
/

exports(i)               River export nodes                          exports(i)
/    EXP_Caballo_x_f     export flows above Caballo Gauge
     EXP_El_Paso_x_f     exported flows above El paso gauge
     EXP_above_MX_x_f    export flows above Mexico gauge
     EXP_below_MX_x_f    exported flows below Mexico gauge
     EXP_below_EPID_x_f  export flows below EPID
/



divert(i)             Diversion nodes                             divert(i)

/     EBID_d_f        Elephant Butte Irrigation District diversion
      LCMI_d_f        Las Cruces MI diversions at LC
      EPID_d_f        El Paso Irrigation dversion
      EPMI_d_f        El Paso MI diversion at El Paso
      MXID_d_f        Mexican diversion on Rio Grande
      MXMI_d_f        City of Juarez MX river diversions

/

agdivert(divert)      Ag diversion nodes                         agdivert(divert)

/     EBID_d_f        EBID diversions
      EPID_d_f        EPID diversions
      MXID_d_f        MX diversions
/

midivert(divert)     urban diversions nodes                      midivert(divert)

/     LCMI_d_f       las cruces urban diversions
      EPMI_d_f       el paso urban diversions
      MXMI_d_f       Juarez MX urban diversions
/

use(i)               Consumptive use flow nodes = div nodes      use(i)

/     EBID_u_f       same nodes as divert(i) but shows use instead
      LCMI_u_f
      EPID_u_f
      EPMI_u_f
      MXID_u_f
      MXMI_u_f
/

r_return(i)           River return river nodes

/     EBID_rr_f       EBID (NM irrigation) return to river node
      LCMI_rr_f       Las Cruces return to river node
      EPID_rr_f       EPID (TX irrigation) return to river node
      EPMI_rr_f       el paso return to river node
      MXID_rr_f       MX return to river node
      MXMI_rr_f       Juarez MX return to river node
/

a_return(i)           river return to aquifer nodes

/     EBID_ra_f       EBID (NM irrigation) return to aquifer
      LCMI_ra_f       Las Cruces NM urban  return to aquifer
      EPID_ra_f       EPID (TX irrigation) return to aquifer
      EPMI_ra_f       El Paso (MI) return to aquifer
      MXID_ra_f       MX return to aquifer
      MXMI_ra_f       Juarez MX return to aquifer

/

aguse(use)           Ag use nodes                           aguse(use)

/     EBID_u_f       ebid nm
      EPID_u_f       epid tx
      MXID_u_f       MX use
/

miuse(use)           urban use nodes                        miuse(use)

/     LCMI_u_f       las cruces urban          (LCMI)
      EPMI_u_f       el paso urban             (EPMI)
      MXMI_u_f       Juarez MX urban           (MXMI)
/

agr_return(r_return)  Ag river return flow nodes            agr_return(r_return)

/     EBID_rr_f       elephant butte irrigation (EBID)
      EPID_rr_f       el paso irrigation        (EPID)
      MXID_rr_f       MX irrigation             (MXID)
/

aga_return(a_return)  Ag river to aquifer return nodes      aga_return(a_return)

/    EBID_ra_f        elephant butte irrigation district
     EPID_ra_f        el paso irrigation
     MXID_ra_f        MX irrigation
/

mir_return(r_return)  urban river to river return nodes      mir_return(r_return)

/    LCMI_rr_f        las cruces urban
     EPMI_rr_f        el paso urban
     MXMI_rr_f        Juarez MX urban
/

mia_return(a_return)  urban to aquifer return flow nodes    mia_return(a_return)

/    LCMI_ra_f        Las Cruces NM USA urban recharge to respective aquifer
     EPMI_ra_f        El Paso TX    USA urban recharge to respective aquifer
     MXMI_ra_f        Juarez Chih    MX urban recharge to respective aquifer
/

rel(i)                Reservoir to river release flow nodes       rel(i)

/    Store_rel_f      RG Project storage release into Rio Grande mainstem downstream of Caballo
/

*display agdivert;

*---------------------------------------------------------------------------------------*
u     Stocks - location of important nodes on Rio Grande CO to MX
*---------------------------------------------------------------------------------------*

/     Store_res_s    Reservoir stock node EB + CAB combined      res(u)

      Mesilla_aqf_s  Mesilla Aquifer                             aqf(u)
      Hueco_aqf_s    Hueco Bolson                                aqf(u)
/

*---------------------------------------------------------------------------------------*
*    Stock subsets
*---------------------------------------------------------------------------------------*

res(u)               Reservoir stock nodes                       res(u)

/     Store_res_s    Rio Grande project storage on RG Elephant Butte and Caballo combined

/

aqf(u)               Aquifer stock nodes

/     Mesilla_aqf_s  Mesilla aquifer southern  NM and MX
      Hueco_aqf_s    Hueco   aquifer southwest TX and MX
/

*---------------------------------------------------------------------------------------*
j     crop - only 3 for now but can accept as many as needed - needs data for each
*---------------------------------------------------------------------------------------*

/     pecans
      veges
      forage
/


*----------------------------------------------------------------------------------------
k     irrigation technology - one for now - but opens slot for several
*----------------------------------------------------------------------------------------

/     flood

/

*----------------------------------------------------------------------------------------
t     time - years
*----------------------------------------------------------------------------------------

/     1994 * 2033 // 1994 * 2033       20 years - expandable
/


tfirst(t)            starting year
tlast(t)             terminal year
tlater(t)            all years after initial
tpost2008(t)         years after 2008
lagtlater(t)         lagged years after first

;

tfirst(t)    = yes $ (ord(t) eq 1);
tlast(t)     = yes $ (ord(t) eq card(t));
tlater(t)    = yes $ (ord(t) gt 1);
tpost2008(t) = yes $ (ord(t) gt 13);
lagtlater(t) = yes $ (ord(t) gt 0);

alias (tfirst, ttfirst);

display lagtlater, tlast;

set p    policy implementations of 2008 operating agreement

/ 1-policy_wi_2008_po,
  2-policy_wo_2008_po
/

*-------------------------------------------------------------------------------------------
*
* 1-policy_wi_2008_po; hist, constrained opt that requires 2008 operating agreement in place
*   with up to 60KAF per yr to MX

* 2-policy_wo_2008_po: the same without that operating agreement but still requires up to 60K AF/ yr to
*   with up to 60 KAF per yr to MX
*
*-------------------------------------------------------------------------------------------


sets w    water supply climate stress scenarios


/ 1_Obs+Extend_Drought
  2____access1_0_rcp85
  3___hadgem2_es_rcp85
  4___hadgem2_es_rcp26
  5_miroc_rcp26_r1i1p1
  6_Zero_Flow_SMarcial
/



$ontext

/
  6_Zero_Flow_SMarcial
/

$offtext

$ontext

1.        1_Obs+Extend Drought:  Average annual observed  (combined-gauge)
          streamflow at San Marcial for 1950-2013.  Annual values from
          2014 to 2099 represent a repeated sequence of observed drought
          years (2011-2013).

2.        2____access1_0_rcp85: Newest iteration of normalization in which
          we normalize by the mean and variance, using a lognormal distribution.
          It uses a 1964-2013 baseline period to calculate normalization.
          It also accounts for trans-mountain diversions by subtracting imported
          water upstream from San Marcial in the baseline period before normalizing,
          then adding back the imported water (estimated from a separate analysis of
          trans-mountain importation) to obtain the values shown.
          Three variations on this basic theme are shown below.

3.        3___hadgem2_es_rcp85   This is what we consider our "baseline" model, which we
          have been using since November 2017.  Normalized flows in this model exhibit
          depletions on the order of -205 kAF/year later this century.
          Need to define depletions

4.        4___hadgem2_es_rcp26 This represents a more optimistic, or closer to the
          ensemble mean condition of -30.2 kAF/year for all 31 CMIP5 (defined as)
          simulations, regarding depletion of flows later this century.  The The Access1
          model above (#2) exhibits extreme depletions (of about -366 kAF/year out of the
          31 CMIP5 simulations) of normalized flows for the late 21st century.


5.        5_miroc_rcp26_r1i1p1 This represents a wetter scenario (of about + 276 kAF/year
          out of the 31 CMIP5 simulations) within the normalized flow regime.


6.        6_Zero_Flow_SMarcial:  Zero flow at San Marcial Gauges in all Years.  This a
          lower bound designed as the most pessimistic possible set of inflows which
          are intended to maximize pressure on groundwater pumping as long as the aquifer
          is economically viable after which use turns to imports.

$offtext


set s1  alternative terminal period aquifer protection policies

/1_wo_terminal_aqf_protection,  2_wi_terminal_aqf_protection/

set s2 substitute surface water cost if brought in from another source - e.g. inland brackish desal\reuse\seawater desal ($ per acre foot)

/1_low_surface_import_cost, 2_high_surface_import_cost/

set s3 sensitivity parameter 3 - 2 available


*1-sens3_base, 2-sens3_new


/1_model_base/

set s4 sensitivity parameter 4  - only one this time but is slot for more

/1-sens4_base/


ALIAS (river, riverp);  // river nodes wear multiple hats

display tfirst, tlast, tlater, agdivert;

parameters

ID_adu_p  (agdivert,   aguse)   identity matrix connects divert nodes to ag use nodes
ID_arr_p  (agr_return, aguse)   identity matrix connects river return nodes to ag use nodes
ID_ara_p  (aga_return, aguse)   identity matrix connects aquifer return nodes to ag use nodes

ID_adara_p(agdivert,aga_return) identity matrix connects ag divert to ag aquifer return nodes

ID_adau_p (agdivert,aguse)      identity matrix connects ag divert to agr use nodes
ID_adarr_p(agdivert,agr_return) identity matrix connects ag divert to ag river return nodes
ID_adaar_p(agdivert,aga_return) identity matrix connects ag divert ao ag aquifer return nodes

ID_mdu_p  (midivert,   miuse)   identity matrix connects urban divert nodes to use nodes
ID_mrru_p (mir_return,miuse)    identity matrix connects urban riv return nodes to use nodes
ID_mrau_p (mia_return,miuse)    identity matrix connects urban aqf return nodes to use nodes
;

ID_adu_p  (agdivert,   aguse)   $ (ord(agdivert)   eq ord(aguse)) = 1;
ID_arr_p  (agr_return, aguse)   $ (ord(agr_return) eq ord(aguse)) = 1;
ID_ara_p  (aga_return, aguse)   $ (ord(aga_return) eq ord(aguse)) = 1;

ID_adara_p(agdivert,aga_return) $ (ord(agdivert) eq ord(aga_return)) = 1;

ID_mdu_p  (midivert,  miuse)    $ (ord(midivert)   eq ord(miuse)) = 1;
ID_mrru_p (mir_return,miuse)    $ (ord(mir_return) eq ord(miuse)) = 1;
ID_mrau_p (mia_return,miuse)    $ (ord(mia_return) eq ord(miuse)) = 1;

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

* ---------------- river gauge rows (+) -------------------------------------------------------------------
RG_Caballo_out_v_f                           1
RG_El_Paso_v_f                                                  1
RG_above_MX_v_f                                                                  1
RG_below_MX_v_f                                                                                    1
RG_below_EPID_v_f
* ---------------- river flow imports ---------------------------------------------------------------------
IMP_Caballo_m_f         1
* ---------------- river flow exports ---------------------------------------------------------------------
EXP_Caballo_x_f        -1
EXP_El_Paso_x_f                            -1
EXP_above_MX_x_f                                               -1
EXP_below_MX_x_f                                                                -1
EXP_below_EPID_x_f                                                                                -1
* ------------------ watershed inflows --------------------------------------------------------------------
WS_Caballo_h_f          1
WS_El_Paso_h_f                              1
WS_above_MX_h_f                                                1
WS_below_MX_h_f                                                                  1
WS_below_EPID_h_f                                                                                  1
* --------------- river diversion nodes  (-)  -------------------------------------------------------------
EBID_d_f                                    -1
LCMI_d_f                                    -1
EPID_d_f                                                                                          -1
EPMI_d_f                                                       -1
MXID_d_f                                                                         -1
MXMI_d_f                                                       -1
* -------------- river diversions returning to river (+) --------------------------------------------------
EBID_rr_f                                    1
LCMI_rr_f                                    1
EPID_rr_f                                                                                          1
EPMI_rr_f                                                       1
MXID_rr_f                                                                         1
MXMI_rr_f                                                       1
*---------------- river diversions returning to aquifer  (+) ----------------------------------------------
EBID_ra_f
LCMI_ra_f
EPID_ra_f
EPMI_ra_f
MXID_ra_f
MXMI_ra_f
* ------------- reservoir release (outflow) to river -- stock-to-flow rows (+) ----------------------------
Store_rel_f             1
;

*----------------------------------------------------------------------------------------
* generic parameters
*----------------------------------------------------------------------------------------
parameter rho_p(s4) discount rate

/1-sens4_base   0.05/

disc_factr_p(s4,t)  discount factor
;
disc_factr_p(s4,t) = 1/[(1+rho_p(s4)) ** (ord(t) - 1)];

display disc_factr_p;


*----------------------------------------------------------------------------------------
* agriculture parameters
*----------------------------------------------------------------------------------------
* Map #3:

* Defines use (simplistically) as a percentage of diversion
* X(use) = Bdu * X(divert)
* These B coeffs are shown below as the matrix, Bu

*---------------------------------------------------------------------------------------


parameter backstop_cost_p(s2)  cost of backstop technology  ($US per a-f)

/1_low_surface_import_cost          1444
 2_high_surface_import_cost         4000/


Table   Yield_p(aguse,j,k)   Crop Yield (tons per acre)

                  Pecans.flood    Veges.flood  forage.flood
*-------------------------- use node rows (+) ---------------
EBID_u_f            1.00            17.00        8.00
EPID_u_f            0.98            16.85        7.90
MXID_u_f            0.95            16.20        7.85
*------------------------------------------------------------
;

Table   Price_p(aguse,j)    Crop Prices ($ per ton)

*$ontext
                   Pecans          Veges        forage
EBID_u_f            4960            250           120
EPID_u_f            4960            250           120
MXID_u_f            4960            250           120
*$offtext
;

*Price_p(aguse,'veges') = price_p(aguse,'pecans');


table lan_p(t,j,k,aguse)  ag land in prodn (1000 acres) over all observed historical years

* (USBR - Data Zhuping Sheng TAMU El Paso March 6 2017 - Alfredo Granados from MX growers still waiting for MX acreage before 2001 (july 3 2017)

         pecans.flood.ebid_u_f  veges.flood.ebid_u_f   forage.flood.ebid_u_f
1994        18.546                  37.126                  22.026
1995        18.546                  37.126                  22.026
1996        18.546                  37.126                  22.026
1997        18.759                  36.480                  25.512

*$ontext
1998        19.680                  32.851                  26.839
1999        20.172                  29.464                  27.209

2000        20.324                  31.665                  26.126
2001        20.446                  27.097                  24.722
2002        20.860                  26.365                  26.692
2003        19.494                  21.278                  21.698
2004        20.190                  22.299                  16.821
2005        20.886                  27.350                  22.511
2006        20.263                  23.112                  19.627
2007        21.624                  22.850                  23.320
2008        23.293                  21.162                  23.933
2009        24.060                  17.677                  24.769
2010        21.847                  17.629                  20.435
2011        24.763                   9.692                   9.638
2012        20.567                  11.231                  14.910
2013        21.393                  16.623                   9.411
2014        31.293                  24.656                  16.668
2015        31.391                  25.503                  16.493

*$ontext
2016        20.324                  31.665                  26.126
2017        20.446                  27.097                  24.722
2018        20.860                  26.365                  26.692
2019        19.494                  21.278                  21.698
2020        20.190                  22.299                  16.821
2021        20.886                  27.350                  22.511
2022        20.263                  23.112                  19.627
2023        21.624                  22.850                  23.320
2024        23.293                  21.162                  23.933
2025        24.060                  17.677                  24.769
2026        21.847                  17.629                  20.435
2027        24.763                   9.692                   9.638
2028        20.567                  11.231                  14.910
2029        21.393                  16.623                   9.411
2030        31.293                  24.656                  16.668
2031        31.391                  25.503                  16.493
2032        20.324                  31.665                  26.126
2033        20.446                  27.097                  24.722


*$offtext

+



        pecans.flood.epid_u_f  veges.flood.epid_u_f  forage.flood.epid_u_f
1994           8.252                  34.303          11.205
1995           8.252                  34.303          11.205
1996           8.252                  34.303          11.205
1997           8.390                  33.805          11.232

*$ontext
1998           8.565                  34.006           9.947
1999           8.913                  30.033           8.167

2000          10.673                  27.712          10.239
2001          11.484                  27.362          10.439
2002          11.262                  25.680          13.076
2003          11.466                  21.526           5.119
2004          10.893                  22.323           4.837
2005          10.089                  23.871           4.239
2006          10.829                  21.783           4.490
2007          11.039                  19.088           5.383
2008          11.249                  16.422           5.485
2009          11.611                  29.361           6.215
2010          11.213                  20.256           5.591
2011          12.281                  28.370           6.555
2012          13.477                  26.096           6.110
2013          10.108                  19.572           4.583
2014          10.108                  19.572           4.583
2015          10.108                  19.572           4.583

*$ontext
2016          10.673                  27.712          10.239
2017          11.484                  27.362          10.439
2018          11.262                  25.680          13.076
2019          11.466                  21.526           5.119
2020          10.893                  22.323           4.837
2021          10.089                  23.871           4.239
2022          10.829                  21.783           4.490
2023          11.039                  19.088           5.383
2024          11.249                  16.422           5.485
2025          11.611                  29.361           6.215
2026          11.213                  20.256           5.591
2027          12.281                  28.370           6.555
2028          13.477                  26.096           6.110
2029          10.108                  19.572           4.583
2030          10.108                  19.572           4.583
2031          10.108                  19.572           4.583
2032          10.673                  27.712          10.239
2033          11.484                  27.362          10.439

*$offtext

+

        pecans.flood.mxid_u_f    veges.flood.mxid_u_f  forage.flood.mxid_u_f
1994       0.250                        4.319                 24.303
1995       0.250                        4.319                 24.303
1996       0.250                        4.319                 24.303
1997       0.250                        4.319                 24.303

*$ontext
1998       0.250                        4.319                 24.303
1999       0.250                        4.319                 24.303

2000       0.250                        4.319                 24.303
2001       0.250                        4.319                 24.303
2002       0.225                        3.888                 21.879
2003       0.233                        4.033                 22.694
2004       0.261                        4.514                 25.400
2005       0.275                        4.745                 26.699
2006       0.291                        5.028                 28.295
2007       0.306                        5.280                 29.709
2008       0.357                        6.170                 34.718
2009       0.332                        5.734                 32.266
2010       0.330                        5.702                 32.089
2011       0.300                        5.182                 29.158
2012       0.295                        5.106                 28.734
2013       0.275                        4.746                 26.705
2014       0.250                        4.313                 26.705
2015       0.250                        4.313                 24.269

*$ontext

2016       0.250                        4.319                 24.303
2017       0.250                        4.319                 24.303
2018       0.250                        4.319                 24.303
2019       0.225                        3.888                 21.879
2020       0.233                        4.033                 22.694
2021       0.261                        4.514                 25.400
2022       0.275                        4.745                 26.699
2023       0.291                        5.028                 28.295
2024       0.306                        5.280                 29.709
2025       0.357                        6.170                 34.718
2026       0.332                        5.734                 32.266
2027       0.330                        5.702                 32.089
2028       0.300                        5.182                 29.158
2029       0.295                        5.106                 28.734
2030       0.275                        4.746                 26.705
2031       0.250                        4.313                 26.705
2032       0.250                        4.313                 24.269
2033       0.250                        4.319                 24.303

*$offtext

;

parameter land_p(aguse,j,k,t)  land in prodn over all observed historical years (US Bureau of Reclamation Data Zhuping Sheng TAMU El Paso March 6 2017)
;

land_p(aguse,j,k,t)  = lan_p(t,j,k,aguse);

display land_p;


table Ba_divert_p(agdivert,j,k)  diversions     (feet depth)

                   Pecans.flood     Veges.flood      forage.flood
* -------------------------- apply node rows -------------------------
EBID_d_f              5.5              4.0             5.0
EPID_d_f              5.5              4.0             5.0
MXID_d_f              5.5              4.0             3.0
* --------------------------------------------------------------------
;

table Ba_use_p(aguse,j,k)        use            (feet depth)

                   Pecans.flood     Veges.flood     forage.flood
* -------------------------- use node rows ---------------------------
EBID_u_f              5.5              4.0             5.0
EPID_u_f              5.5              4.0             5.0
MXID_u_f              5.5              4.0             3.0
* --------------------------------------------------------------------


table Bar_return_p(r_return,j,k) river return flows    (feet depth)

                    Pecans.flood    Veges.flood      forage.flood
* --------------------------------------------------------------------
EBID_rr_f              0.0              0.0             0.0
EPID_rr_f              0.0              0.0             0.0
MXID_rr_f              0.0              0.0             0.0

* --------------------------------------------------------------------

table  Baa_return_p(aga_return,j,k) aquifer return flows  (feet depth)

                    Pecans.flood    Veges.flood      forage.flood
* --------------------------------------------------------------------
EBID_ra_f              0.0              0.0             0.0
EPID_ra_f              0.0              0.0             0.0
MXID_ra_f              0.0              0.0             0.0
* --------------------------------------------------------------------
;

*overrides above coefficients quickly

Ba_use_p    (aguse,     j,k) =   0.75 * sum(agdivert, ID_adau_p (agdivert,aguse)      * Ba_divert_p(agdivert,j,k));    // 75% of river diversions applied consumed by crop (ET)
Bar_return_p(agr_return,j,k) =   0.00 * sum(agdivert, ID_adarr_p(agdivert,agr_return) * Ba_divert_p(agdivert,j,k));    //  0% of river diversions applied return to river
Baa_return_p(aga_return,j,k) =   0.25 * sum(agdivert, ID_adaar_p(agdivert,aga_return) * Ba_divert_p(agdivert,j,k));    // 25% of river diversions applied return to aquifer


table Bag_pump_aqf_return_p(aguse,j,k)   proportion of ag water pumped recharging pumped aquifer (unitless)

                    Pecans.flood    Veges.flood     forage.flood
EBID_u_f               0.20           0.20            0.20
EPID_u_f               0.20           0.20            0.20
MXID_u_f               0.20           0.20            0.20
;

Table  Cost_p(aguse,j,k)     Crop Production Costs  ($ per acre)

*$ontext
                      Pecans.flood   Veges.flood     forage.flood
*-------------------------- use node rows (+) ------------------------
EBID_u_f               2700            3600            820
EPID_u_f               2710            3620            825
MXID_u_f               2700            3620            620
*---------------------------------------------------------------------
;

table ag_gw_pump_capacity_p(aqf,aguse)  ag pumping capacity in acre feet per year by aquifer

                  ebid_u_f  epid_u_f    mxid_u_f
Mesilla_aqf_s       250       eps         eps
Hueco_aqf_s         eps       57.4        35.2


//  annual pump capacity ebid nm office of state engineer report: 2010
//  http://www.ose.state.nm.us/Pub/TechnicalReports/TechReport%2054NM%20Water%20Use%20by%20Categories%20.pdf

//  epid  https://www.twdb.texas.gov/waterplanning/rwp/climate/doc/13-Reyes.pdf 130 mgd pump capacity x 120 day growing season
//  mexico:  zheng:  "Impacts of groundwater pumping and climate variability on groundwater availability in the Rio Grande Basin"


parameter

ag_av_gw_cost_p(aguse,s4)   average irrigation costs of pumping gw ($ per a-f) at 2013 Mesilla Aquifer depth level incl capital and operations
;
ag_av_gw_cost_p(aguse,'1-sens4_base')   =  120;   // Source EBID consultant Phil King, NMSU March 2013   also see https://www.ksre.k-state.edu/irrigate/oow/p11/Kranz11a.pdf

scalar cost_af_unit_depth_p  average energy cost per foot depth per acre foot of pumping

/0.235/

// data, assumptions: 50% pumping plant efficiency, and $US 0.10 per kwh
// source is https://www.engineeringtoolbox.com/water-pumping-costs-d_1527.html

;

* calculations from Shane Walker: Jan 9 2018

*Q: What is the marginal cost of a decline of one foot of head in a well that pumps one acre- foot?
*A: dh = 1 foot
*d = 62.4 ft-lbs/ ft 3
*dp = d * dh = 0.433 ft-lbs/in 2 = 2.988 Pa = 1.024 kw x hr/ac-ft
*for pumping efficiency np = 50%
*dp =   ?p/np = 2.047 kw x hr / acre feet
*For a cost of energy c = 0.10/ kw x hr
*C = c dp = .205 per acre foot


display cost_af_unit_depth_p;

$ontext
Potential of membrane distillation in seawater desalination: Thermal efficiency, sensitivity study and cost estimation
By:Al-Obaidani, S (Al-Obaidani, Sulaiman)
JOURNAL OF MEMBRANE SCIENCE
Volume: 323
Issue: 1
Pages: 85-98
DOI: 10.1016/j.memsci.2008.06.006
Published: OCT 1 2008
1.17 per cubic meter or 1444 per acre foot as of 2008
$offtext


parameter ag_av_back_cost0_p(aguse,s2)  average ag backstop technology water supply if available ($ per acre foot)
;
ag_av_back_cost0_p(aguse,s2) = backstop_cost_p(s2);


$ontext

            1_low_surface_import_cost     2_high_surface_import_cost
 ebid_u_f      1444                              100500
 epid_u_f      1444                              100500
 mxid_u_f      1444                              100500
;

$offtext

*2500

ag_av_back_cost0_p(aguse,s2) = ag_av_back_cost0_p(aguse,s2) - 75;   // $75 per acre foot cheaper for ag desal than urban less purification required

parameter  cost_af_flow_import_p(s2)  average cost of flow imports per acre foot ($ per acre foot)
;

cost_af_flow_import_p(s2) = ag_av_back_cost0_p('ebid_u_f',s2);
;

scalar cost_af_flow_export_p  ave cost flow exports -- dump flood flows to desert ($ per acre foot)  /5/

* nominal cost to reduce obj fn for ea unit 'exported'

parameter ag_back_cost_grow_p(aguse)  prop growth per year in ag backstop cost

/ebid_u_f       0.00
 epid_u_f       0.00
 mxid_u_f       0.00
/

scalarr  prop_base_back_cost_p   proportion of backstop technology cost for new scenario if needed

/ 1-sens1_base 1.00/


parameter

ag_av_back_cost_p(aguse,j,k,t,s2)   future ave ag backstop tech cost
;

ag_av_back_cost_p(aguse,j,k,t,s2) $ (ord(t) eq 1) = 1.00 * ag_av_back_cost0_p(aguse,s2);
ag_av_back_cost_p(aguse,j,k,t,s2) $ (ord(t) ge 2) =        ag_av_back_cost0_p(aguse,s2) * (1 + ag_back_cost_grow_p(aguse)) ** (ord(t) - 2);

*ag_av_back_cost_p(aguse,j,k,t,'2-sens1_new') = prop_base_back_cost_p('2-sens1_new') * ag_av_back_cost_p(aguse,j,k,t,'1-sens1_base') + eps;

* backstop technology typically uneconomical for irrigated agriculture under base (1-sens1_base) conditions

display ag_av_back_cost_p;

Parameter Netrev_acre_p(aguse,j,k)  net revenue per acre in base year price x yield - cost                          ($ per acre)
          Netrev_af_p  (aguse,j,k)  net revenue per acre foot of crop water use depleted from system (ET)           ($ per acre foot ET)
;



$ontext
* test code: used to keep net income per acre foot about equal with this ranking for testing: pecans, veges, forage

Price_p(aguse,'veges')    = Price_p(aguse,'pecans') * (Ba_use_p(aguse,'veges', 'flood') / Ba_use_p(aguse,'pecans', 'flood')); //  - 25.0;
Price_p(aguse,'forage')   = Price_p(aguse,'pecans') * (Ba_use_p(aguse,'forage','flood') / Ba_use_p(aguse,'pecans', 'flood')); //  - 500;

Yield_p(aguse,'veges', k) = Yield_p(aguse,'pecans',k);
Yield_p(aguse,'forage',k) = Yield_p(aguse,'pecans',k);

Cost_p(aguse, 'veges', k) = (Cost_p(aguse,'pecans',k)) * (Ba_use_p(aguse,'veges', 'flood') / Ba_use_p(aguse,'pecans','flood')); //  +  50.0;
Cost_p(aguse, 'forage',k) = (Cost_p(aguse,'pecans',k)) * (Ba_use_p(aguse,'forage','flood') / Ba_use_p(aguse,'pecans','flood')); //  + 100.0;
$offtext

Netrev_acre_p(aguse,j,k) =                            Price_p(aguse,j) * Yield_p(aguse,j,k) - Cost_p(aguse,j,k);
Netrev_af_p  (aguse,j,k) = (1/Ba_use_p(aguse,j,k)) * [Price_p(aguse,j) * Yield_p(aguse,j,k) - Cost_p(aguse,j,k)];

Display price_p, yield_p, cost_p, Netrev_acre_p, Netrev_af_p;


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

*----------------------- end of ag parameters -------------------------------------------

*-------------- begin urban water use parameters ----------------------------------------

parameter

elas_p          (miuse)   urban price elasticity of demand     (unitless)
urb_price_p     (miuse)   urban base price of water            ($ af)
urb_use_p       (miuse)   urban base water customer deliveries (1000 af \ yr)
urb_Av_cost0_p  (miuse)   urban average cost of supply         ($      \  af)
urb_cost_grow_p (miuse)   urban average cost growth rate       (prop \ year)
;

parameter

elas_p(miuse)  price elasticity

/LCMI_u_f   -0.23
 epmi_u_f   -0.37
 MXMI_u_f   -0.05/

* -0.23 -0.37 -0.05
* -0.15 for all
parameter elast_p(miuse,s3)  price elasticity with sensitivity if needed
;
elast_p(miuse,'1_model_base') = 1.00 * elas_p(miuse);
*elast_p(miuse,'2_model_cons') = 1.00 * elas_p(miuse);

display elast_p;


*JOURNAL OF THE AMERICAN WATER RESOURCES ASSOCIATION
*VOL. 35, NO.3
*AMERICAN WATER RESOURCES ASSOCIATION
*JUNE 1999
*NONPRICE WATER CONSERVATION PROGRAMS
*AS A DEMAND MANAGEMENT TOOL'
*An M. Michelsen, J. Thomas McGuckin, and Donna Stump


* Mexico: Econometric model for industrial and urban groundwater consumption in Guanajuato, Mexico: 1980-2011
* TECNOLOGIA Y CIENCIAS DEL AGUA
* Guzman-Soria, E, de la Garza-Carranza, MT; Rebollar-Rebollar, S; Hernandez-Martinez, J; Terrones-Cordero, A
* Volume: 4
* Issue: 3
* Pages: 187-193
* Published: JUL-AUG 2013


*$ontext

parameter
urb_price_p(miuse)            // starting 1994 base prices

/LCMI_u_f   880.00
 epmi_u_f   850.00
 MXMI_u_f   820.00/
                            // el paso water utilities pricing source Dec 28 2015:  http://www.epwu.org/whatsnew/pdf/Survey.pdf

urb_use_p(miuse)            // observed urban use in base year 1995 1000 acre feet

/LCMI_u_f   19.71
 epmi_u_f  118.50
 MXMI_u_f   75.00/

*$offtext

;                         //  Source:  demouche landfair ward nmwrri tech completion report 256 2010 page 11 demands for year 2009 las cruces water utility
                          //  http://www.wrri.nmsu.edu/publish/techrpt/tr356/tr356.pdf
                          //  published in the international journal of water resources development
                          //  Water Resources Development, Vol. 27, No. 2, 291–314, June 2011
                          //  118,500 acre feet supplied from Rio Grande, Hueco Bolson, Mesilla Aquifer, and Kay Baily Hutchinson Desal Plant
                          //  source is http://www.epwu.org/water/water_resources.html

parameter pop0_p(miuse)     urban water buying households (1000s)


/LCMI_u_f     32.303
 epmi_u_f    194.274
 MXMI_u_f    140.082/
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
 epmi_u_f   0.0172
 MXMI_u_f   0.0200/
;

*.0190, .0172, .0200

parameter pop_p(miuse,t)    population by year
;

pop_p(miuse,t)                 = pop0_p(miuse) * (1 + rho_pop_p(miuse)) ** (ord(t) - 1);

display pop0_p, rho_pop_p, pop_p;


parameter

urb_av_cost0_p(miuse)       // el paso water utilities pricing source Dec 28 2015: http://www.epwu.org/whatsnew/pdf/Survey.pdf
*
/LCMI_u_f  851.14
 epmi_u_f  851.14
 MXMI_u_f  851.14/

urb_cost_grow_p(miuse)       2% per year growth in urban average cost of supply

/LCMI_u_f  0.02
 epmi_u_f  0.02
 MXMI_u_f  0.02/

urb_av_gw_cost0_p(miuse)     av EXTRA cost of aquifer pumping beyond regular treatment (from added depth)

/LCMI_u_f  30.00
 epmi_u_f  30.00
 MXMI_u_f  30.00/

urb_gw_cost_grow_p(miuse)    0% per year growth in urban groundwater pump costs

/LCMI_u_f  0.00
 epmi_u_f  0.00
 MXMI_u_f  0.00/
;

parameter urb_av_back_cost0_p(miuse,s2)    urban ave backstop technology costs INCLUDING treatment approximate cost of desal or imported water as of 2017 ($ per af)
;
urb_av_back_cost0_p(miuse,s2) = backstop_cost_p(s2);


$ontext


            1_low_surface_import_cost    2_high_surface_import_cost
 LCMI_u_f      1444                          2500
 epmi_u_f      1444                          2500
 MXMI_u_f      1444                          2500
;

$offtext


*urb_av_back_cost0_p(miuse) =  1444;

* Univ of AZ WRRI: Desal study:  posted at https://wrrc.arizona.edu/awr/s11/financing.
* Imported water to EP estimated at approximately 1444 per af as of 2008

* A comprehensive economic evaluation of integrated
* desalination systems using fossil fuelled and nuclear energies
* and including their environmental costs
* Desalination 2008
* S. Nisana, N. Benzartib
* average brackish water desal costs = 1.00 per m3

* Las Cruces 2468 per a-f.  = 2.00 per cubic meter (60% subsidy required, mixture of solar + petroleum based)
* source: "Evaluation of technologies for a desalination operation and disposal in the Tularosa Basin, New Mexico"
* Desalination December 2009
* Volume 249, Issue 3, 25 December 2009, Pages 983-990
* Authors:  Diego Téllez, Horacio Lom, Pablo Chargoy, Luís Rosas, María Mendoza, Monserrat Coatl, Nuria Macías, René Reyes

* El Paso:  Used cost estimates for Kay Bailey Hutchinson Plant: $1717 per acre foot
* Source: "Cost of Brackish Groundwater Desalination in Texas"
* consultant report September 2012
* Authors:  Jorge Arroyo and Saqib Shirazi

* Cd. Juarez:  Desal costs unknown:  used El Paso data for Kay Bailey Hutchinson desal plant

parameter  urb_back_cost_grow_p(miuse)   0% per year growth in urban ave backstop technology costs (may fall i.e. < 0)

/ LCMI_u_f    0.00
  epmi_u_f    0.00
  mxmi_u_f    0.00
/
;

table urb_gw_pump_capacity_p(aqf, miuse)   approximate pumping capacity by urban area

                 LCMI_u_f    epmi_u_f   MXMI_u_f
mesilla_aqf_s       40         26         25
hueco_aqf_s         eps        78        165
;

* LC 2015 pumping 30-40 KAF per year from LC Water Plan sent by Bill Hargrove March 20 2017

* ep rgr surface treatment capacity  = 60K af per year
* ep pumping capacity (hueco) approx = 78K af per year
* ep pumping capacity (mesilla) approx 26K af per year
* both data sources are at http://www.epwu.org/water/water_resources.html
* http://www.epwu.org/water/hueco_bolson/2.0ElPasoWaterSupply.pdf

* mexico pumping citation 34 million cubic meters in 1995
* Impacts of groundwater pumping and climate variability
* on groundwater availability in the Rio Grande Basin
* ZHUPING SHENG Texas A&M AgriLife Research Center at El Paso, Texas A&M University, 1380 A&M Circle, El Paso, Texas 79927 USA


parameter

urb_av_cost_p     (miuse,t)    future urban ave cost
urb_av_gw_cost_p  (miuse,t)    future urban ave gw pump cost
urb_av_back_cost_p(miuse,t,s2) future urban ave backstop technology cost
;

urb_av_cost_p     (miuse,t) $ (ord(t) eq 1)    = 1.00 * urb_av_cost0_p(miuse);
urb_av_cost_p     (miuse,t) $ (ord(t) ge 2)    =        urb_av_cost0_p(miuse)      * (1 + urb_cost_grow_p(miuse))      ** (ord(t) - 2);

urb_av_gw_cost_p  (miuse,t) $ (ord(t) eq 1)    = 1.00 * urb_av_gw_cost0_p(miuse);
urb_av_gw_cost_p  (miuse,t) $ (ord(t) ge 2)    =        urb_av_gw_cost0_p(miuse)   * (1 + urb_gw_cost_grow_p(miuse))   ** (ord(t) - 2);

urb_av_back_cost_p(miuse,t,s2) $ (ord(t) eq 1) = 1.00 * urb_av_back_cost0_p(miuse,s2);
urb_av_back_cost_p(miuse,t,s2) $ (ord(t) ge 2) =        urb_av_back_cost0_p(miuse,s2) * (1 + urb_back_cost_grow_p(miuse)) ** (ord(t) - 2);

* below allows where needed overriding equality of urban backstop tecyhnology for both sens1 scenarios
* urb_av_back_cost_p(miuse,t,'2-sens1_new') = prop_base_back_cost_p('2-sens1_new') * urb_av_back_cost_p(miuse,t,'1-sens1_base') + eps;


display urb_av_back_cost_p;

parameter Burb_back_aqf_rch_p(miuse)   proportion of urb water from backstop technology recharging aquifer

/lcmi_u_f     0.00
 epmi_u_f     0.00/


display urb_av_cost0_p, urb_av_cost_p, urb_av_gw_cost0_p, urb_av_gw_cost_p, urb_av_back_cost0_p, urb_av_back_cost_p;


parameter
BB1_base_p (miuse,s3)     Slope of observed urban demand function based on observed use and externally estimated price elasticity of demand
BB1_p      (miuse,t,s3)     flattening slope of price-dependent urban demand function with growing population
BB0_p      (miuse,s3  )     Intercept for urban price-dependent demand function
;

BB1_base_p(miuse,s3  )   =  urb_price_p (miuse)  /  [elast_p (miuse,s3) * urb_use_p(miuse)];   // intercept parameter to run base price-dependent demand function through observed price and use
BB0_p     (miuse,s3  )   =  urb_price_p (miuse) - BB1_base_p (miuse,s3) * urb_use_p(miuse);    // intercept parameter for same thing
BB1_p     (miuse,t,s3)   =  BB1_base_p  (miuse,s3) *    [pop0_p (miuse) /     pop_p(miuse,t)]; // higher urb population has lower price slope - future demand pivots out with higher pop

display urb_price_p, elast_p, BB0_p, BB1_p, bb1_base_p ;

*--------------------- END OF URBAN WATER SUPPLY PARAMETERS -----------------------------

* ------------------------------- RESERVOIR BASED RECREATION PARAMETERS -----------------


PARAMETER

B0_rec_ben_intercept_p(res) intercvept in rec benefits power function

/store_res_s   5000/

B0_rec_ben_p(res)  interecept in rec benefits power benefits function

/store_res_s   225/

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

scalar us_mexico_1906_p   US MX 1906 treaty flows (1000 af pr year)                   / 60  /   //  https://en.wikipedia.org/wiki/International_Diversion_Dam
scalar tx_proj_op_p   RGR project operation: TX proportion of SAN MARCIAL FLOWS    / 0.55230/   //  Burec project operating history 1953 - 1977
*0.43

// announced jan 2017 http://www.houstonchronicle.com/news/texas/article/Feds-issue-decision-on-operating-plan-for-Rio-10839313.php

scalar sw_sustain_p   terminal sustainability proportion of starting sw storage  / 1.00/

parameter gw_sustain_p(aqf) terminal sustainability proportion of starting gw storage

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

                LCMI_u_f       EPMI_u_f     MXMI_u_f
LCMI_d_f          1.00
EPMI_d_f                        1.00
MXMI_d_f                                       1.00

TABLE Bmdr_p(midivert, mir_return)    urban return to river as a proportion of divert

                LCMI_rr_f       EPMI_rr_f    MXMI_rr_f
LCMI_d_f          0.00
EPMI_d_f                         0.00
MXMI_d_f                                       0.00

TABLE Bmda_p(midivert, mia_return)    urban return to aquifer as a proportion of divert

                LCMI_ra_f       EPMI_ra_f    MXMI_ra_f
LCMI_d_f          0.0
EPMI_d_f                         0.0
MXMI_d_f                                         0.0


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

*parameter source_p(inflow,t,w)  annual basin inflows at headwaters -- snowpack or rain (1000 af \ year)
table     source_p(inflow,t,w)  annual basin inflows at headwaters -- snowpack or rain (1000 af \ year)

*----------------------------------------------------------------------------------------
*----     Data are from historical or forecast headwater node flows    ------------------
*----------------------------------------------------------------------------------------

* observed annual water supply from usgs gauging station - 1000 af per year at San Marcial Gauge
* (floodway)              https://waterdata.usgs.gov/usa/nwis/inventory/?site_no=08358400&agency_cd=USGS
* (conveyance channel)    https://waterdata.usgs.gov/nm/nwis/uv?site_no=08358300
* alternatives to base come from works by Dr. Dave Gutzler and Nolan Townsend,
* both at the University of New Mexico, Department of Earth and Planetary Sciences,
* zero inflow at San Marcial is a hypothetical extreme

* Jan 2019

*$ontext

                  1_Obs+Extend_Drought 2____access1_0_rcp85  3___hadgem2_es_rcp85  4___hadgem2_es_rcp26  5_miroc_rcp26_r1i1p1   6_Zero_Flow_SMarcial
Marcial_h_f.1994       1144.70           434.97                     284.98               300.15                    596.91
Marcial_h_f.1995       1394.51           357.09                     445.05               408.96                    1953.54
Marcial_h_f.1996        447.98           454.85                     407.44               432.09                    1846.95
Marcial_h_f.1997       1142.56           399.37                    1235.47               1153.82                   1252.85
Marcial_h_f.1998        767.35           555.56                     431.02               407.20                    882.17
Marcial_h_f.1999        863.91           1060.19                     657.98              681.67                    1224.03
Marcial_h_f.2000        432.66           2661.90                     471.75              489.09                    1077.96
Marcial_h_f.2001        441.39           940.31                     302.43               344.17                    1037.25
Marcial_h_f.2002        241.65           412.51                     442.93               408.92                    1252.92
Marcial_h_f.2003        202.78           323.83                     345.92               376.69                    655.58
Marcial_h_f.2004        406.81           1711.69                    250.37               285.57                    407.41
Marcial_h_f.2005        968.26           793.55                     431.28               427.86                    550.85
Marcial_h_f.2006        593.11           379.43                     391.85               234.22                    1436.71
Marcial_h_f.2007        514.09           622.62                     523.61               444.77                    742.84
Marcial_h_f.2008        932.22           2319.58                     286.38              1011.95                   763.08
Marcial_h_f.2009        694.05           1128.37                     405.75              2533.69                   457.37
Marcial_h_f.2010        541.36           780.33                     897.77               535.87                    484.77
Marcial_h_f.2011        308.92           463.30                    1284.17               289.95                    399.87
Marcial_h_f.2012        288.43           778.65                     424.90               376.92                    395.70
Marcial_h_f.2013        303.07           575.68                     608.10               425.78                    589.36
Marcial_h_f.2014        308.92           297.16                     781.65               335.71                    568.56
Marcial_h_f.2015        288.43           443.22                     709.84               318.13                    813.68
Marcial_h_f.2016        303.07           894.79                     545.99               441.56                    1019.61
Marcial_h_f.2017        308.92           1109.36                    1806.67              430.15                    692.80
Marcial_h_f.2018        288.43           855.31                     468.44               275.66                    1031.82
Marcial_h_f.2019        303.07           359.82                     408.81               233.72                    587.43
Marcial_h_f.2020        308.92           319.41                     256.22               412.80                    869.29
Marcial_h_f.2021        288.43           400.07                    1647.10               511.18                    2020.33
Marcial_h_f.2022        303.07           357.81                     613.25               3522.01                   1140.26
Marcial_h_f.2023        308.92           510.64                    1188.03               664.50                    1751.94
Marcial_h_f.2024        288.43           455.24                     925.30               441.34                    1503.74
Marcial_h_f.2025        303.07           238.91                     711.47               576.09                    928.92
Marcial_h_f.2026        308.92           448.64                    1264.89               429.39                    806.09
Marcial_h_f.2027        288.43           453.56                     957.49               259.82                    564.95
Marcial_h_f.2028        303.07           596.48                     384.42               273.41                    962.02
Marcial_h_f.2029        308.92           477.10                     507.70               379.42                    1262.74
Marcial_h_f.2030        288.43           390.14                     646.23               475.78                    881.08
Marcial_h_f.2031        303.07           474.60                     251.85               652.98                    553.86
Marcial_h_f.2032        308.92           461.16                     250.75               663.13                    724.71
Marcial_h_f.2033        288.43           351.58                     447.15               2016.35                   1089.85

*$offtext
;

*Source_p('Marcial_h_f',tlater,w) = Source_p('Marcial_h_f',tlater,w);

*parameter

Source_p('WS_Caballo_h_f',   t,w) = 87; // Alex Mayer data: weather station rainfall over watershed area times assumed 5.7% making it to channel published work
Source_p('WS_El_Paso_h_f',   t,w) = 66; //    "
Source_p('WS_above_MX_h_f',  t,w) = 43; //    "
Source_p('WS_below_MX_h_f',  t,w) =  0; //    "
Source_p('WS_below_EPID_h_f',t,w) =  0; //    "


Source_p(inflow,t,'6_Zero_Flow_SMarcial')  =  eps;  // no san marcial gauges flow extreme scenario

* 87, 66, 43

* 0.713 is stressed. Source is:
* authors: hurd and coonrod
* journal:  climate research
* year 2012
* volume 53 pp 103-118;
* title "Hydro-economic consequences of climate change  in the upper Rio Grande,"
* page of data = of 71.3 percent of base inflow occurs on page 113


display source_p;


table us_mx_1906_p(t,w)  actual deliveries at Acequia Madre gauge -- data source Rector Dr. Alfredo Granados

*          6_zero_flow_SMarcial

         1_Obs+Extend_Drought
 1994      60.188
 1995      63.641
 1996      60.085
 1997      59.463

*$ontext
 1998      60.650
 1999      58.329
 2000      60.633
 2001      61.059
 2002      60.346
 2003      26.958
 2004      27.623
 2005      58.111
 2006      27.127
 2007      51.263
 2008      53.703
 2009      57.746
 2010      56.404
 2011      25.735
 2012      23.079
 2013       3.766
 2014      12.948
 2015      33.413

*$ontext
 2016      60.633
 2017      61.059
 2018      60.346
 2019      26.958
 2020      27.623
 2021      58.111
 2022      27.127
 2023      51.263
 2024      53.703
 2025      57.746
 2026      56.404
 2027      25.735
 2028      23.079
 2029       3.766
 2030      12.948
 2031      33.413
 2032      60.633
 2033      61.059
*$offtext
;

*us_mx_1906_p(t,w)                 =  1.00 * us_mx_1906_P(t,'1_Obs+Extend_Drought');
us_mx_1906_p(t,w)                 =  1.00 * us_mx_1906_P(t,'6_zero_flow_SMarcial');


display US_MX_1906_p;

TABLE gaugeflow_p(river,t)  annual historical gauged streamflows (1000 af \ year)


* source is http://www.ibwc.state.gov/water_data/histflo1.htm
* https://waterdata.usgs.gov/nwis/annual?referred_module=sw&search_site_no=08362500&format=sites_selection_links    march 6 2017

$ontext

                       1994     1995    1996    1997
RG_Caballo_out_v_f      820     820     820     763
RG_El_Paso_v_f          509     702     447     483
RG_above_MX_v_f         820     820     820     763
RG_below_EPID_v_f       205     410     168     177

$offtext


*$ontext
                       1994     1995    1996    1997   1998    1999    2000    2001     2002    2003    2004    2005    2006    2007     2008    2009    2010    2011    2012    2013     2014    2015
RG_Caballo_out_v_f      820     820     820     763     817     728     756     791      802     389     398     654     444     611      670     725     665     403     371     168      400     400
RG_El_Paso_v_f          509     702     447     483     457     457     433     453      474     172     187     330     279     338      378     382     364     230     133      57      105     171
RG_above_MX_v_f         820     820     820     763     817     728     756     791      802     389     398     654     444     611      670     725     665     403     371     168      400     400
RG_below_MX_v_f         820     820     820     763     817     728     756     791      802     389     398     654     444     611      670     725     665     403     371     168      400     400
RG_below_EPID_v_f       205     410     168     177     174     189     140     138      161      33      63     111     151     125      139     110     123      31       8       6       11      12


*$ontext
+
                       2016    2017    2018    2019    2020    2021    2022    2023     2024    2025    2026    2027    2028    2029     2030    2031    2032    2033
RG_Caballo_out_v_f      756     791     802     389     398     654     444     611      670     725     665     403     371     168      400     400     756     791
RG_El_Paso_v_f          433     453     474     172     187     330     279     338      378     382     364     230     133      57      105     171     433     453
RG_above_MX_v_f         756     791     802     389     398     654     444     611      670     725     665     403     371     168      400     400     756     791
RG_below_MX_v_f         756     791     802     389     398     654     444     611      670     725     665     403     371     168      400     400     756     791
RG_below_EPID_v_f       140     138     161      33      63     111     151     125      139     110     123      31       8       6       11      12     140     138

*$offtext
;

*Caballo, EP and below EPID (Ft Quitman) are actual gauges not virtual;

table z_p(u,t)     Rio Grande project storage on RG observed


$ontext
              1994      1995       1996       1997
Store_res_s   2107.430  2123.070   2201.490   1759.868
$offtext


*$ontext
              1994      1995       1996       1997        1998        1999        2000        2001        2002       2003        2004        2005        2006        2007        2008        2009         2010        2011        2012        2013        2014        2015
Store_res_s   2107.430  2123.070   2201.490   1759.868    1970.196    1739.597    1750.483    1327.898    923.123    387.541     221.660     216.630     444.310     557.170     432.540      670.160     549.164     459.219     297.584     168.601     318.805     288.798


*$ontext
+
             2016        2017      2018       2019        2020        2021        2022        2023        2024         2025      2026        2027        2028        2029        2030        2031        2032        2033
Store_res_s  1750.483    1327.898  923.123    387.541     221.660     216.630     444.310     557.170     432.540      670.160   549.164     459.219     297.584     168.601     318.805     288.798     1750.483    1327.898

*$offtext


table residdd_p(u,t)    residual from observed storage

*$ontext
                 1994   1995   1996    1997      1998      1999       2000       2001       2002      2003      2004      2005     2006     2007     2008     2009    2010      2011      2012     2013       2014      2015
store_res_s       0.00  0.00   0.00   -446.17   307.40    -199.20     482.28    -3.70      251.50   -312.86   -122.12    -288.35   232.10   131.81  -322.40   315.55  62.04     49.87    -58.51   -207.26     215.73    2.60


*$ontext
+
                 2016        2017      2018      2019     2020        2021        2022     2023        2024     2025     2026      2027      2028     2029        2030     2031        2032        2033
store_res_s      482.28     -3.70      251.50   -312.86   -122.12    -288.35      232.10   131.81     -322.40   315.55    62.04     49.87    -58.51   -207.26     215.73    2.60       482.28       -3.70
;

*$offtext

$ontext
                 1994   1995   1996    1997
store_res_s       0.00  0.00   0.00   -446.17
;

$offtext


parameter residd_p(u,t,p,w)    residual from constrained optimization model
;

*$ontext

residd_p(u,t,'1-policy_wi_2008_po',w)  =  residdd_p(u,t);  // historical policy replicates historical data by adding adjustments to constrained optimizaiton
residd_p(u,t,'2-policy_wo_2008_po',w)  =  residdd_p(u,t);  // no change residual for non historical runs;

display residd_p;

*$offtext

parameter

Xv_lb_p(t)  lower bound on strean gauge flows compared to historical
Xv_ub_p(t)  upper bound on stream gauge flows compared to historical
;

Xv_lb_p(t) = 0.99;   // lower bound 0.99 approx matches history
Xv_ub_p(t) = 1.01;   // upper bound 1.01 approx matches history

PARAMETER

* reservoir stocks

z0_p  (res,p,s3)   initial reservoir levels at reservoir stock nodes  (1000 af)
zmax_p(res)        maximum reservoir storage capacity                 (1000 af)
;

z0_p  ('Store_res_s',p,'1_model_base')   = (1.000 * 2204.7);   // historical starting level
*z0_p  ('Store_res_s',p,'2_model_cons')   = (0.000 * 2204.7) + .75;   // historical starting level


* base is 1.00
*z0_p  ('Store_res_s',p,'2-sens3_new')    = 0.999  * 2204.7;   // base starting level water surface stock usgs data 1996

* Starting storage for elephant butte plus caballo usgs data source january 1 1996
* https://pubs.usgs.gov/wdr/1996/nm-96-1/report.pdf
* ebutte   2043100 af
* caballo   161600 af

display Z0_p;

zmax_p('store_res_s')   = 2544;    // max project storage

scalar  gap_operate_2008_p  permitted gap 1000 ac ft \ yr in operating agreement Caballo Releases /100/


parameter

* aquifer stocks

q0_p      (aqf  )  initial aquifer level at aquifer stock nodes in yr 1       (1000 af)
qmax_p    (aqf  )  max aquifer storage cpacity                                (1000 af)
pct_return_aqf_p   percentage starting storage aquifer must return to         (0 - 1.00)

aq_area_p (aqf  )  area overlying aquifer                                     (1000 ac)
recharge_P(aqf,t)  annual aquifer recharge                                    (1000 af \ yr)
porosity_p(aqf  )  average porosity (void ratio)                              (unitless)
depth0_p  (aqf  )  starting depth                                             (feet)
;
porosity_p('mesilla_aqf_s') = 0.10;    // Hawley below, page 85
porosity_p('Hueco_aqf_s'  ) = 0.178;   // Heywood citation below page 28

aq_area_p('mesilla_aqf_s')  =  704;    // land area over Mesilla Bolson 1000 acres - NM WRRI report 332 page 7, equals 1100 sq miles
aq_area_p('Hueco_aqf_s')    = 1600;    // land area over Hueco Transboundary Aquifers and Binational Ground Water Database For the City of El Paso / Ciudad Juarez Area
                                       // 1600 1600000 acres = 2500 square miles cited in EPWU report from 2004 chapter 3 overview of the Hueco bolson http://www.epwu.org/water/hueco_bolson/3.0Overview.pdf

depth0_p('mesilla_aqf_s') =  20;        //    10 Z. Zheng  Impacts of Pumping border region figure 4  http://onlinelibrary.wiley.com/doi/10.1890/ES12-00270.1/full
depth0_p('hueco_aqf_s')   =  50;        //    http://utminers.utep.edu/omwilliamson/hueco_bolson.htm depth to pumping near el paso 250 to 400 feet
*10                                    //    The Hueco Bolson: An Aquifer at the Crossroads Zheng et al       325
*50                                    //    http://utminers.utep.edu/omwilliamson/hueco_bolson.htm

qmax_p('Mesilla_aqf_s')    = 50000;    // max useable freshwater storage capacity Mesilla Aquifer: Source is Hawley and Kennedy, page 85

* 1.  John Hawley invited seminar NMSU Water Science and management Graduate Student Organizaiton: NMSU Corbett Center November 2016
* 2.  Bob Creel June 6 2007: Groundwater Resources of the las Cruces Dona Ana County region: slideshow on the web at
*       http://www.las-cruces.org/~/media/lcpublicwebdev2/site%20documents/article%20documents/utilities/water%20resources/groundwater%20resources%20wrri%20presentation.ashx?la=en

qmax_p('Hueco_aqf_s')     =  35000;    //  max storage capacity TX Hueco Bolson: data source  http://www.epwu.org/water/hueco_bolson/ReviewTeamReport.pdf
                                       //  Bredhoeft et al March 2004 page 4
                                       //  Review Interpretation of the Hueco Bolson Groundwater Model
                                       //  capacity 9 million AF

*20000

recharge_p('mesilla_aqf_s',t) =  10.80;  // 10K af-year recharge Mountain Front recharge data source: Hawley and Kennedy:  Source Below
recharge_p('hueco_aqf_s',  t) =  30.00;  // 10.94 K af / yr recharge Mountain Front + artificial recharge:                 Source below


*recharge_p(aqf,t) = 0;

pct_return_aqf_p = 1.00;   // percentage of starting storage aquifer should return to.

q0_p(aqf) = qmax_p(aqf) - depth0_p(aqf) * porosity_p(aqf) * aq_area_p(aqf);     // starting storage by calculation

display q0_p;


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

*precip_rat_p     reservoir precip (feet gained per exposed acre per year)                               /0.97/       // data source historic precip data near Truth or Consequences NM
*Evap_rat_p       reservoir evaporation  (feet loss per exposed acre per year)                           /7.682/       // data source selected New Mexico water reports
B1_area_vol_p    impact of changes in volume on changes in area (acres per 1000 ac feet)                /0.015/      // data source linear regression on area capacity relations
B2_area_volsq_p  impact of changes in volume squared on changes in area (acres per 1000 ac ft squared)  / eps/

parameters

evap_rate_p(t,s4)              evaportation rate by year and scenario
parameter precip_rate_p(t)     precip rate by year

parameter

evap_rat_p(t)      evaporation rate feet per year observed at ebutte station from A Mayer - MTU - averages after 2015

/1994           10.08
 1995           10.43
 1996           10.55
 1997           9.45
 1998           10.86
 1999           10.64
 2000           10.05
 2001           10.15
 2002           11.56
 2003           11.45
 2004           10.10
 2005           10.11
 2006           10.28
 2007           9.60
 2008           10.71
 2009           10.43
 2010           10.54
 2011           12.15
 2012           11.61
 2013           10.28
 2014           10.11
 2015           9.76
 2016           10.49
 2017           10.49
 2018           10.49
 2019           10.49
 2020           10.49
 2021           10.49
 2022           10.49
 2023           10.49
 2024           10.49
 2025           10.49
 2026           10.49
 2027           10.49
 2028           10.49
 2029           10.49
 2030           10.49
 2031           10.49
 2032           10.49
 2033           10.49
/

;

evap_rate_p(t,s4)  = 1.00 * evap_rat_p(t);   // overrides data with averages


parameter precip_rate_p(t)     precip rate by year data from weather station near Elephant Butte (Alex Mayer)

/1994              0.79
 1995              0.55
 1996              0.86
 1997              0.93
 1998              0.74
 1999              1.14
 2000              1.11
 2001              0.67
 2002              0.49
 2003              0.55
 2004              0.79
 2005              0.74
 2006              1.18
 2007              0.68
 2008              1.02
 2009              0.72
 2010              0.87
 2011              0.89
 2012              0.38
 2013              0.79
 2014              0.77
 2015              0.84
 2016              0.79
 2017              0.79
 2018              0.79
 2019              0.79
 2020              0.79
 2021              0.79
 2022              0.79
 2023              0.79
 2024              0.79
 2025              0.79
 2026              0.79
 2027              0.79
 2028              0.79
 2029              0.79
 2030              0.79
 2031              0.79
 2032              0.79
 2033              0.79
/

;
precip_rate_p(t) = 0 * precip_rate_p(t);  // overrides data with averages


*----------------------------------------------------------------------------------------
*  Land  Block
*----------------------------------------------------------------------------------------

parameters

LANDRHS_p(aguse)           land available by irrigation district        (1000 acres)

/
  EBID_u_f              90
  EPID_u_f              55
  MXID_u_f              50

/

*----------------------------------------------------------------------------------------
*  Surface Water Block
*----------------------------------------------------------------------------------------

SW_Treat_capac_p(miuse)    surface water treatment capacity for urban use  (1000 acre feet)

/
  LCMI_u_f              eps
  EPMI_u_f              60
  MXMI_u_f              eps
/

*  EP urban = 60,000 AF per year surface treatment capacity
*  LC urban = 0                  surface treatment  capacity
// data http://www.epwu.org/water/hueco_bolson/2.0ElPasoWaterSupply.pdf

;

display LANDRHS_p;

* ---------------------------------------------------------------------------------------
*  END OF ALL PARAMETERS (DATA READ BY MODEL)
* ---------------------------------------------------------------------------------------

*--------------- Section 3 --------------------------------------------------------------
*  These endogenous (unknown) variables are defined                                     *
*  Their numerical values are not known til GAMS finds optimal soln                     *
*----------------------------------------------------------------------------------------

* pp, ww are subsets of original sets...allows efficient scenario analysis below

set pp(p);    // policy responses
set ww(w);    // water/climate scenarios sharing rule
set ss1(s1);    // scenario of choice
set ss2(s2);
set ss3(s3);
set ss4(s4);

pp(p)   = no;   // switches subsests off for now
ww(w)   = no;   // ditto
ss1(s1) = no;   // ditto
ss2(s2) = no;
ss3(s3) = no;
ss4(s4) = no;


POSITIVE VARIABLES

*Hydrology block

Z_v            (u,        t,p,w,s1,s2,s3,s4)     water stocks -- surface reservoir storage        (L3 \ yr)   (1000 af by yr)
Q_v            (aqf,      t,p,w,s1,s2,s3,s4)     water stocks -- aquifer storage                  (L3 \ yr)   (1000 af by yr)


*Q_ave_v        (aqf,        p,w,s1,s2,s3,s4)     average aquifer storage                          (L3 \ yr)   (1000 af)
*Q_term_v       (aqf,      t,p,w,s1,s2,s3,s4)     terminanl aquifer storage                        (L3 \ yr)   (1000 af)

Q_term_v       (aqf,t,      p,w,   s2,s3,s4)    terminal aqf storage                               (L3 \ yr)   (1000 af)
*Q_ave_v        (aqf,        p,w,s1,   s3,s4)    average  aqf storage                               (L3 \ yr)   (1000 af)

aquifer_recharge_m_v(     t,p,w,s1,s2,s3,s4)     Flow: Mesilla aquifer recharge by year          (L3 \ T)       (1000 af \ yr)
aquifer_recharge_h_v(     t,p,w,s1,s2,s3,s4)     Flow: Hueco  aquifer recharge by year          (L3 \ T)       (1000 af \ yr)

aquifer_discharge_m_v(    t,p,w,s1,s2,s3,s4)     Flow: Mesilla aquifer discharge by year         (L3 \ T)       (1000 af \ yr)
aquifer_discharge_h_v(    t,p,w,s1,s2,s3,s4)     Flow: Hueco  aquifer discharge by year          (L3 \ T)       (1000 af \ yr)

Aquifer_depth_v(aqf,      t,p,w,s1,s2,s3,s4)     aquifer depth                                    (L  \ yr)   (feet by year)

Evaporation_v  (res,      t,p,w,s1,s2,s3,s4)     reservoir surface evaporation                    (L3 \ yr)   (1000 af \ yr)
Precip_v       (res,      t,p,w,s1,s2,s3,s4)     reservoir surface precipation                    (L3 \ yr)   (1000 af \ yr)
surf_area_v    (res,      t,p,w,s1,s2,s3,s4)     reservoir surface area                           (L2 \ yr)   (1000 ac \ yr)

Ag_use_v       (aguse,    t,p,w,s1,s2,s3,s4)     irrigation total water use (sw + gw + backstop)  (L3 \ yr)   (1000 af \ yr)

Ag_use_jk_v    (aguse,j,k,t,p,w,s1,s2,s3,s4)     ag water use by crop (sw + gw + backstop)        (L3 \ yr)   (1000 af \ yr)

Ag_sw_use_jk_v (aguse,j,k,t,p,w,s1,s2,s3,s4)     ag surface water                                 (L3 \ yr)   (1000 af \ yr)

Ag_use_crop_v  (aguse,j,k,t,p,w,s1,s2,s3,s4)     irrigation water use by crop (all sources)       (L3 \ yr)   (1000 af \ yr)

ag_back_use_v  (aguse,j,k,t,p,w,s1,s2,s3,s4)     irrigation total water use backstop tech         (L3 \ yr)   (1000 af \ yr)

ag_pump_v  (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4)     irrigation water pumped                          (L3 \ yr)   (1000 af \ yr)
tot_ag_pump_v(aqf,aguse,  t,p,w,s1,s2,s3,s4)     irrigation water pumped over crops and techs     (L3 \ yr)   (1000 af \ yr)

sum_ag_pump_v  (          t,p,w,s1,s2,s3,s4)     ag pumping over districts                        (L3 \ yr)   (1000 af \ yr)
sum_urb_pump_v (          t,p,w,s1,s2,s3,s4)     urban pumping over cities                        (L3 \ yr)   (1000 af \ yr)

MX_sw_divert_v (          t,p,w,s1,s2,s3,s4)     1906 US Mexico treaty surface wat deliveries     (L3 \ yr)   (1000 af \ yr)

Ag_pump_aq_rch_v(aqf,aguse,t,p,w,s1,s2,s3,s4)    ag pumping contributing to aqf recharge          (L3 \ yr)   (1000 af \ yr)

*ag backstop water use that recharges aquifers -- in progress -- little of this under current (2019) prices
*ag_back_aq_rch_v(aqf,aguse,t,p,w,s1,s2,s3,s4)    Ag backstop use contributing to aqf recharge    (L3 \ yr)   (1000 af \ yr)

Aga_returns_v (aga_return,t,p,w,s1,s2,s3,s4)     ag surface return flows to aquifer               (L3 \ yr)   (1000 af \ hr)

urb_pump_v     (aqf,miuse,t,p,w,s1,s2,s3,s4)     urban groundwater pumping                        (L3 \ yr)   (1000 af \ yr)
urb_use_v      (miuse,    t,p,w,s1,s2,s3,s4)     urban water use summed over sources              (L3 \ yr)   (1000 af \ yr)

urb_sw_use_v   (miuse,    t,p,w,s1,s2,s3,s4)     urban surface water use                            (L3 \ yr)   (1000 af \ yr)
urb_gw_use_v   (miuse,    t,p,w,s1,s2,s3,s4)     urban groundwater use                              (L3 \ yr)   (1000 af \ yr)
urb_back_use_v (miuse,    t,p,w,s1,s2,s3,s4)     urban backstop technology water use                (L3 \ yr)   (1000 af \ yr)

urb_back_aq_rch_v(aqf,miuse,t,p,w,s1,s2,s3,s4)   urban water use from backstop recharge aqf         (L3 \ yr)   (1000 af \ yr)

*land

SWacres_v        (aguse,j,k,t,p,w,s1,s2,s3,s4)     surface irrigated land in prodn                  (L2 \ yr)   (1000 ac \ yr)
GWAcres_v        (aguse,j,k,t,p,w,s1,s2,s3,s4)     groundwater irrigated land in prodn              (L2 \ yr)   (1000 ac \ yr)
BTacres_v        (aguse,j,k,t,p,w,s1,s2,s3,s4)     backstop tech irrigated land                     (L2 \ yr)   (1000 ac \ yr)
gw_aq_acres_v(aqf,aguse,j,k,t,p,w,s1,s2,s3,s4)     groundwater acres irrigated by aquifer           (L2 \ yr)   (1000 ac \ yr)


Tacres_v       (aguse,j,k,t,p,w,s1,s2,s3,s4)     total land (sw + gw  + backstop)                 (L2 \ yr)   (1000 ac \ yr)
tot_acres_v    (aguse,    t,p,w,s1,s2,s3,s4)     total irrigated land over crops                  (L2 \ yr)   (1000 ac \ yr)

yield_v        (aguse,j,k,t,p,w,s1,s2,s3,s4)     crop yield                                                   (tons    \ ac)


* urban economics block

urb_price_v    (miuse,    t,p,w,s1,s2,s3,s4)     urban price                                      ($US \ af)
urb_con_surp_v (miuse,    t,p,w,s1,s2,s3,s4)     urban consumer surplus                           ($US 1000 per year)
urb_use_p_cap_v(miuse,    t,p,w,s1,s2,s3,s4)     urban use per customer                           (af \ yr)
urb_revenue_v  (miuse,    t,p,w,s1,s2,s3,s4)     urban gross revenues from water sales            ($US 1000 per year)
urb_gross_ben_v(miuse,    t,p,w,s1,s2,s3,s4)     urban gross benefits from water sales            ($US 1000 per year)

urb_av_gw_cost_v(miuse,   t,p,w,s1,s2,s3,s4)     urban average pump costs                         ($US per acre foot)
urb_costs_v    (miuse,    t,p,w,s1,s2,s3,s4)     urban costs of water supply                      ($US 1000 per year)

urb_costs_x_bs_v(miuse,   t,p,w,s1,s2,s3,s4)     urban ave costs of water excl backstop tech      ($US 1000 per year)
urb_av_tot_cost_v(miuse,  t,p,w,s1,s2,s3,s4)     urban ave costs of water supply                  ($US per acre foot)

*urb_value_v    (miuse,    t,p,w,s1,s2,s3,s4)     urban net economic benefits                      ($US 1000 per year)

* sw import costs block

Flow_import_cost_v(imports,t,p,w,s1,s2,s3,s4)     import flow augmentation costs                   ($US 1000 per year)
Flow_export_cost_v(exports,t,p,w,s1,s2,s3,s4)     export flow reduction costs to avoid spills      ($US 1000 per year)

Tot_imp_costs_v    (t,p,w,s1,s2,s3,s4)            total cost of flow augmentation imports          ($US 1000 \ yr)
Tot_exp_costs_v    (t,p,w,s1,s2,s3,s4)            total cost of flow reductions to avoid spills    (US  1000 \ yr)

DNPV_import_costs_v(  p,w,s1,s2,s3,s4)            dnpv total surface flow import costs             ($US 1000)
DNPV_export_costs_v(  p,w,s1,s2,s3,s4)            dnpv total surface flow export (spill avert) cst ($US 1000)

* ag economics block

*ag_value_v    (aguse,  j,k,t,p,w,s1,s2,s3,s4)       ag net economic benefits                      ($US 1000 per year)

*Ag_costs_v      (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag production costs (sw + gw + bs)               ($US 1000 \ yr)
*Ag_av_gw_costs_v(aguse,j,k,t,p,w,s1,s2,s3,s4)    ag average pump costs  (gw)                      ($US \ af)


VARIABLES

*hydrology block

X_v            (i,        t,p,w,s1,s2,s3,s4)     flows -- all kinds                               (L3 \ yr)   (1000 af \ yr)

D1_v           (          t,p,w,s1,s2,s3,s4)     D1 = deliveries                                  (L3 \ yr)   (1000 af \ yr)
D2_v           (          t,p,w,s1,s2,s3,s4)     D2 = diversions                                  (L3 \ yr)   (1000 af \ yr)

D1_LB_v        (          t,p,w,s1,s2,s3,s4)     D1 lower bound = deliveries                      (L3 \ yr)   (1000 af \ yr)
D1_UB_v        (          t,p,w,s1,s2,s3,s4)     D1 upper bound = deliveries                      (L3 \ yr)   (1000 af \ yr)


D2_LB_v        (          t,p,w,s1,s2,s3,s4)     D2 = lower bound diversions                      (L3 \ yr)   (1000 af \ yr)
D2_UB_v        (          t,p,w,s1,s2,s3,s4)     D2 = upper bound diversions                      (L3 \ yr)   (1000 af \ yr)

* urban economics block

*urb_price_v    (miuse,    t,p,w,s1,s2,s3,s4)     urban price                                      ($US \ af)

urb_value_v    (miuse,    t,p,w,s1,s2,s3,s4)     urban net economic benefits                      ($US 1000 per year)

Urb_value_af_v (miuse,    t,p,w,s1,s2,s3,s4)     urban economic benefits per acre foot            ($US per acre foot)
urb_m_value_v  (miuse,    t,p,w,s1,s2,s3,s4)     urban marginal benefits per acre foot            ($US per acre foot)

* ag economics block

Ag_costs_v       (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag production costs (sw + gw + bs)               ($US 1000 \ yr)
Ag_av_costs_v   (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag average total costs of water                  ($US \ acre)

Ag_av_gw_costs_v (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag average pump costs  (gw)                      ($US \ acre)
ag_tot_gw_costs_v(aguse,j,k,t,p,w,s1,s2,s3,s4)    ag tot total groundwater pump costs              ($US 1000 \ yr)

ag_tot_sw_costs_v(aguse,j,k,t,p,w,s1,s2,s3,s4)    ag total surf water costs                        ($US 1000 \ yr)
ag_av_sw_costs_v(aguse, j,k,t,p,w,s1,s2,s3,s4)    ag ave surf water costs                          ($US \ acre)

ag_tot_bt_costs_v(aguse,j,k,t,p,w,s1,s2,s3,s4)    ag total backstop technology prodn costs         (US 1000 \ yr)
ag_av_bt_costs_v (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag ave backstop tech prodn costs                 ($US \ acre)

Ag_av_rev_v      (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag average rev per acre                          ($US \yr)

Ag_value_v      (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag net economic value (sw + gw + bs)             ($US 1000 \ yr)

* economics block all uses

Netrev_acre_v  (aguse,j,k,t,p,w,s1,s2,s3,s4)     ag net revenue per acre                          ($ \ ac)
Netrev_af_v    (aguse,j,k,t,p,w,s1,s2,s3,s4)     ag net revenue per acre foot                     ($ \ af)

*ebid
NR_ac_sw_eb_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre eb surf wat                     ($ \ ac)
NR_ac_gw_eb_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre eb groundwater                  ($ \ ac)
NR_ac_bt_eb_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre eb backstop tech                ($ \ ac)
TNR_eb_v       (      j,k,t,p,w,s1,s2,s3,s4)     total net rev elephant butte irr district        ($1000)

*epid
NR_ac_sw_ep_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep surf wat                     ($ \ ac)
NR_ac_gw_ep_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep groundwater                  ($ \ ac)
NR_ac_bt_ep_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep backstop tech                ($ \ ac)
TNR_ep_v       (      j,k,t,p,w,s1,s2,s3,s4)     total net rev el paso irr district               ($1000)

*mxid
NR_ac_sw_mx_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx surf wat                     ($ \ ac)
NR_ac_gw_mx_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx groundwater                  ($ \ ac)
NR_ac_bt_mx_v  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx backstop tech                ($ \ ac)
TNR_mx_v       (      j,k,t,p,w,s1,s2,s3,s4)     total net rev mexico irr district                ($1000)


Ag_Ben_v       (use,      t,p,w,s1,s2,s3,s4)     net income over crops by node and yr             ($1000 \ yr)
T_ag_ben_v     (            p,w,s1,s2,s3,s4)     Net income over crops nodes and yrs              ($1000 \ yr)

Env_ben_v      (river,    t,p,w,s1,s2,s3,s4)     environmental benefits by year                   ($1000 \ yr)
rec_ben_v      (res,      t,p,w,s1,s2,s3,s4)     reservoir recreation benefits by year            ($1000 \ yr)

Tot_ag_ben_v     (        t,p,w,s1,s2,s3,s4)     Total ag benefits by year                        ($1000 \ yr)
Tot_urb_ben_v    (        t,p,w,s1,s2,s3,s4)     Total urban benefits by year                     ($1000 \ yr)
Tot_env_riv_ben_v(        t,p,w,s1,s2,s3,s4)     Total river environmental benefits by year       ($1000 \ yr)
Tot_rec_res_ben_v(        t,p,w,s1,s2,s3,s4)     Total recreation reservoir benefits by year      ($1000 \ yr)

Tot_ben_v        (        t,p,w,s1,s2,s3,s4)     total benefits over uses by year                 ($1000 \ yr)

DNPV_ag_ben_v     (         p,w,s1,s2,s3,s4)     DNPV ag benefits                                 ($1000)
DNPV_urb_ben_v    (         p,w,s1,s2,s3,s4)     DNPV urban benefits                              ($1000)
DNPV_env_riv_ben_v(         p,w,s1,s2,s3,s4)     DNPV environmental river benefits                ($1000)
DNPV_rec_res_ben_v(         p,w,s1,s2,s3,s4)     DNPV reservoir recreation benefits               ($1000)

DNPV_ben_v       (          p,w,s1,s2,s3,s4)     discounted NPV over uses and years               ($1000)
DNPV_v                                           DNPV looped over sets                            ($1000)

*marginal values
Ag_m_value_v   (aguse,j,k,t,p,w,s1,s2,s3,s4)     ag marginal benefit                              ($US \ ac-ft)
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

Land_e         (aguse,        t,p,w,s1,s2,s3,s4)      Acres land                                    (L2 \ T)       (1000 ac \ yr)
Tacres_e       (aguse,    j,k,t,p,w,s1,s2,s3,s4)      total acres in prodn (sw + gw)                (L2 \ T)       (1000 ac \ yr)
acres_pump_e   (aguse,    j,k,t,p,w,s1,s2,s3,s4)      acres pumped (gw only)                        (L2 \ T)       (1000 ac \ yr)
BTacres_e      (aguse,    j,k,t,p,w,s1,s2,s3,s4)      acres BT irrigated                            (L2 \ T)       (1000 ac \ yr)
gw_aq_acres_e  (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4)      groundwater acres by aquifer                  (L2 \ T)       (1000 ac \ yr)

* crop yield block

Yield0_e       (aguse,j,k, t,p,w,s1,s2,s3,s4)      Crop yield initial period                                       (tons \ ac)
Yield_e        (aguse,j,k, t,p,w,s1,s2,s3,s4)      Crop yield later periods                                        (tons \ ac)

* Hydrology Block

Inflows_e      (inflow,    t,p,w,s1,s2,s3,s4)      Flows: source nodes                           (L3 \ T)       (1000 af \ yr)
Rivers_e       (i,         t,p,w,s1,s2,s3,s4)      Flows: mass balance by node                   (L3 \ T)       (1000 af \ yr)

Evaporation_e  (res,       t,p,w,s1,s2,s3,s4)      Flows: Reservoir evaporation                  (L3 \ T)       (1000 af \ yr)
Precip_e       (res,       t,p,w,s1,s2,s3,s4)      Flows: reservoir precip                       (L3 \ T)       (1000 af \ yr)

Surf_area_e    (res,       t,p,w,s1,s2,s3,s4)      Flow:  surface area by reservoir              (L2 \ T)       (1000 ac \ yr)
MX_sw_divert_e (           t,p,w,s1,s2,s3,s4)      Flow:  Mexican surface treaty deliveries      (L3 \ T)       (1000 af \ yr)

Agdiverts_e    (agdivert,  t,p,w,s1,s2,s3,s4)      Flows: ag diverted water from acres           (L3 \ T)       (1000 af \ yr)
Agr_Returns_e  (agr_return,t,p,w,s1,s2,s3,s4)      Flows: ag riv return flows from acres         (L3 \ T)       (1000 af \ yr)
Aga_Returns_e  (aga_return,t,p,w,s1,s2,s3,s4)      Flows: ag aq return flows from acres          (L3 \ T)       (1000 af \ yr)

AgUses_e       (aguse,     t,p,w,s1,s2,s3,s4)      Flows: ag use based on acreage                (L3 \ T)       (1000 af \ yr)

Ag_sw_use_jk_e (aguse,j,k, t,p,w,s1,s2,s3,s4)      Flows: ag surface water use                   (L3 \ T)       (1000 af \ yr)
Ag_use_e       (aguse,     t,p,w,s1,s2,s3,s4)      Flows: ag use -- readable                     (L3 \ T)       (1000 af \ yr)
Ag_Use_jk_e    (aguse,j,k, t,p,w,s1,s2,s3,s4)      Flows: ag use by jk                           (L3 \ T)       (1000 af \ yr)

Ag_use_crop_e  (aguse,j,k, t,p,w,s1,s2,s3,s4)      Flows: ag use by crop                         (L3 \ T)       (1000 af \ yr)

*ag_pump_bound_e(aqf,aguse,j,k,t,p,  s1,s2,s3,s4)   Flows: ag pumping bound (experimental)

sum_ag_pump_e  (           t,p,w,s1,s2,s3,s4)      Flows: sum ag pumping all nodes               (L3 \ T)       (1000 af \ yr)
sum_urb_pump_e (           t,p,w,s1,s2,s3,s4)      Flows: sum urban pumping all nodes            (L3 \ T)       (1000 af \ yr)

MIr_Returns_e  (mir_return,t,p,w,s1,s2,s3,s4)      Flows: urban return flows based on urb pop    (L3 \ T)       (1000 af \ yr)
MIa_Returns_e  (mia_return,t,p,w,s1,s2,s3,s4)      Flows: urban riv divert ret to aquiver        (L3 \ T)       (1000 af \ yr)

MIUses_e       (miuse,     t,p,w,s1,s2,s3,s4)      Flows: urban use  based on urb pop            (L3 \ T)       (1000 af \ yr)

reservoirs0_e  (res,       t,p,w,s1,s2,s3,s4)      Stock: starting reservoir level               (L3    )       (1000 af)
reservoirs_e   (res,       t,p,w,s1,s2,s3,s4)      Stock: over time                              (L3    )       (1000 af)

Net_release_e  (           t,p,w,s1,s2,s3,s4)      Flow:  net rel drawdown on res excl dstm imports (L3\T)       (1000 af \ yr)

aquifers0_e    (aqf,       t,p,w,s1,s2,s3,s4)      Stock: starting aquifer storage               (L3 \ T)       (1000 af)

aquifer_discharge_h_e(     t,p,w,s1,s2,s3,s4)      Flow: Mesilla aquifer dischrage by year       (L3 \ T)       (1000 af \ yr)
aquifer_discharge_m_e(     t,p,w,s1,s2,s3,s4)      Flow: Hueco aquifer discharge by year         (L3 \ T)       (1000 af \ yr)

aquifer_recharge_m0_e(     t,p,w,s1,s2,s3,s4)      Stock: initial mesilla recharge
aquifer_recharge_m_e(      t,p,w,s1,s2,s3,s4)      Stock: Mesilla aquifer recharge over time     (L3 \ T)       (1000 af \ yr)

aquifer_recharge_h0_e(     t,p,w,s1,s2,s3,s4)      Flow:  Hueco rechg in 1st period
aquifer_recharge_h_e(      t,p,w,s1,s2,s3,s4)      Stock: Hueco  aquifer recharge over time      (L3 \ T)       (1000 af \ yr)

aquifer_storage_m_e(       t,p,w,s1,s2,s3,s4)      Stock: Mesilla aquifer over time              (L3 \ T)       (1000 af \ yr)
aquifer_storage_h_e(       t,p,w,s1,s2,s3,s4)      Stock: Hueco bolson over time                 (L3 \ T)       (1000 af \ yr)

aquifer_depth_e(aqf,      t,p,w,s1,s2,s3,s4)       State: aquifer depth by aquifer               (L  \ T)       (feet \ yr)
tot_ag_pump_e  (aqf,aguse,t,p,w,s1,s2,s3,s4)       Flows: total ag pumping by aqf node and yr    (L3 \ T)       (1000 af \ yr)

Ag_pump_aq_rch1_e(        t,p,w,s1,s2,s3,s4)       Flows: ag pump EBID NM recharge Mesilla aqf   (L3 \ T)       (1000 af \ yr)
Ag_pump_aq_rch2_e(        t,p,w,s1,s2,s3,s4)       Flows: ag pump EPID TX recharge Hueco bolson  (L3 \ T)       (1000 af \ yr)
Ag_pump_aq_rch3_e(        t,p,w,s1,s2,s3,s4)       Flows: ag pump MXID MX recharge Hueco bolson  (L3 \ T)       (1000 af \ yr)

* ag backstop aquifer recharge slot here
*ag_back_aq_rch1_e(        t,p,w,s1,s2,s3,s4)       Flows: ag back use EBID NM recharge Mesilla aqf   (L3 \ T)   (1000 af \ yr)
*ag_back_aq_rch2_e(        t,p,w,s1,s2,s3,s4)       Flows: ag back use EPID TX recharge Hueco bolson  (L3 \ T)   (1000 af \ yr)
*ag_back_aq_rch3_e(        t,p,w,s1,s2,s3,s4)       Flows: ag back use MXID MX recharge Hueco bolson  (L3 \ T)   (1000 af \ yr)

*urban use block

urb_price_e    (miuse,    t,p,w,s1,s2,s3,s4)       urban water price                                            ($US      \ af)
urb_con_surp_e (miuse,    t,p,w,s1,s2,s3,s4)       urban consumer surplus                                       ($US 1000 \ yr)
urb_use_p_cap_e(miuse,    t,p,w,s1,s2,s3,s4)       urban use per customer                        (L3 \ T)       (af\ yr)
urb_revenue_e  (miuse,    t,p,w,s1,s2,s3,s4)       urban gross revenues from water sales                        ($US 1000 \ yr)
urb_gross_ben_e(miuse,    t,p,w,s1,s2,s3,s4)       urban gross benefits from water sales                        ($US 1000 \ yr)

urb_costs_e     (miuse,   t,p,w,s1,s2,s3,s4)       urban costs of water supply                                  ($US 1000 \ yr)
urb_av_gw_cost_e(miuse,   t,p,w,s1,s2,s3,s4)       urban ave groundwater pump costs                             ($US per ac-ft)
urb_av_tot_cost_e(miuse,  t,p,w,s1,s2,s3,s4)       urban average costs of water supply                          ($US per ac-ft)
urb_costs_x_bs_e(miuse,   t,p,w,s1,s2,s3,s4)       urban costs of water supply exclcluding backstop tech        ($US 1000 \ yr)

urb_value_e    (miuse,    t,p,w,s1,s2,s3,s4)       Urban net economic benefits                                  ($US 1000 \ yr)

urb_sw_use_e   (miuse,    t,p,w,s1,s2,s3,s4)       urban surface water use                       (L3 \ T)       (1000 af \ yr)
urb_gw_use_e   (miuse,    t,p,w,s1,s2,s3,s4)       urban groundwater use                         (L3 \ T)       (1000 af \ yr)
urb_use_e      (miuse,    t,p,w,s1,s2,s3,s4)       urban total use                               (L3 \ T)       (1000 af \ yr)

Urb_back_aq_rch1_e(       t,p,w,s1,s2,s3,s4)       urban use from backstop tech rech mesilla aqf (L3 \ T)       (1000 af \ yr)
Urb_back_aq_rch12_e(      t,p,w,s1,s2,s3,s4)
Urb_back_aq_rch13_e(      t,p,w,s1,s2,s3,s4)

Urb_back_aq_rch21_e(      t,p,w,s1,s2,s3,s4)
Urb_back_aq_rch2_e(       t,p,w,s1,s2,s3,s4)       urban use from backstop tech rech epmi - hueco(L3 \ T)       (1000 af \ yr)
Urb_back_aq_rch3_e(       t,p,w,s1,s2,s3,s4)       urban use from backstop tech rech mxmi - hueco(L3 \ T)       (1000 af \ yr)

Urb_value_af_e (miuse,    t,p,w,s1,s2,s3,s4)       urban average net economic benefits                          ($US \ ac-ft)
urb_m_value_e  (miuse,    t,p,w,s1,s2,s3,s4)       urban marginal net benefits per                              ($US \ ac-ft)

*Institutions Block (all handled in bounds below so shadow prices can be found)


* Ag Economics Block

Ag_costs_eb_e       (      j,k,t,p,w,s1,s2,s3,s4)      Agricultural production costs (sw + gw + bs)  ($US 1000\ yr)
Ag_costs_ep_e       (      j,k,t,p,w,s1,s2,s3,s4)      Agricultural production costs (sw + gw + bs)  ($US 1000\ yr)
Ag_costs_mx_e       (      j,k,t,p,w,s1,s2,s3,s4)      Mx

Ag_av_costs_e    (aguse,j,k,t,p,w,s1,s2,s3,s4)      Ag ave total costs                            ($US \ acre)

ag_tot_sw_costs_e(aguse,j,k,t,p,w,s1,s2,s3,s4)      Ag tot surf water costs                       ($US 1000 \ yr)
Ag_av_sw_costs_e (aguse,j,k,t,p,w,s1,s2,s3,s4)      Ag ave surf water costs                       ($US 1000 \ acre)

ag_tot_gw_costs_e(aguse,j,k,t,p,w,s1,s2,s3,s4)      ag tot total groundwater pump costs           ($US 1000 \ yr)
ag_av_gw_costs_e (aguse,j,k,t,p,w,s1,s2,s3,s4)      ag ag groundwater pump costs                  ($  \ acre)
ag_av_gw_costs_eb_e(    j,k,t,p,w,s1,s2,s3,s4)      ag av ebid gw pump costs                      ($  \ acre)
ag_av_sw_costs_eb_e(    j,k,t,p,w,s1,s2,s3,s4)      ag av ebid sw costs                      ($  \ acre)
ag_av_bt_costs_eb_e(    j,k,t,p,w,s1,s2,s3,s4)      ag av ebid bt costs                      ($  \ acre)

ag_av_bt_costs_e (aguse,j,k,t,p,w,s1,s2,s3,s4)      ag_av_bt_costs_                               ($  \ acre)

ag_tot_bt_costs_e(aguse,j,k,t,p,w,s1,s2,s3,s4)      ag total backstop technology prodn costs      ($US 1000 \ yr)

Ag_value_e     (aguse,j,k,t,p,w,s1,s2,s3,s4)       Agricultural net benefits     (sw + gw)       ($US 1000\ yr)

Ag_av_rev_e    (aguse,j,k,t,p,w,s1,s2,s3,s4)       ag average gross rev per acre                 ($US \ acre)

Netrev_acre_e  (aguse,j,k,t,p,w,s1,s2,s3,s4)       Net farm income per acre                      ($US   \ ac)
Netrev_af_e    (aguse,j,k,t,p,w,s1,s2,s3,s4)       Net farm income per acre foot                 ($US   \ af)

*ebid
NR_ac_sw_eb_e(        j,k,t,p,w,s1,s2,s3,s4)       net rev per acre eb sw                        ($ \ ac)
NR_ac_gw_eb_e(        j,k,t,p,w,s1,s2,s3,s4)       net rev per acre eb gw                        ($ \ ac)
NR_ac_bt_eb_e(        j,k,t,p,w,s1,s2,s3,s4)       net rev per acre eb bt                        ($ \ ac)
TNR_eb_e     (        j,k,t,p,w,s1,s2,s3,s4)       total net revenue el butte irr district       ($1000)

*epid
NR_ac_sw_ep_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep surf wat                     ($ \ ac)
NR_ac_gw_ep_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep groundwater                  ($ \ ac)
NR_ac_bt_ep_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre ep backstop tech                ($ \ ac)
TNR_ep_e       (      j,k,t,p,w,s1,s2,s3,s4)     total net rev el paso irr district               ($1000)

*mxid
NR_ac_sw_mx_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx surf wat                     ($ \ ac)
NR_ac_gw_mx_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx groundwater                  ($ \ ac)
NR_ac_bt_mx_e  (      j,k,t,p,w,s1,s2,s3,s4)     net rev per acre mx backstop tech                ($ \ ac)
TNR_mx_e       (      j,k,t,p,w,s1,s2,s3,s4)     total net rev mexico irr district                ($1000)



Ag_ben_e       (aguse,    t,p,w,s1,s2,s3,s4)       net farm income over crops and over acres     ($1000 \ yr)
T_ag_ben_e                                         net farm income over crops nodes and yr       ($1000 \ yr)


*Ag_val_bal_e   (aguse,j,k,t,p,  s1,s2,s3,s4)       net farm income balance check

Ag_m_value_e   (aguse,j,k,t,p,w,s1,s2,s3,s4)       ag marginal value per unit water              ($US   \ af)

* environmental benefits block

Env_ben_e      (river,    t,p,w,s1,s2,s3,s4)       environmental benefits from surface storage   ($1000 \ yr)

* reservoir recreation benefits block

Rec_ben_e       (res,      t,p,w,s1,s2,s3,s4)       storage reservoir recreation benefits         ($1000 \ yr)

* flow augmentation costs

Flow_import_cost_e(imports,t,p,w,s1,s2,s3,s4)       flow augmentation costs                       ($1000 \ yr)
Flow_export_cost_e(exports,t,p,w,s1,s2,s3,s4)       flow export costs                             ($1000 \ yr)

* total economics added block

Tot_ag_ben_e     (        t, p,w,s1,s2,s3,s4)      Total ag benefits by year                     ($1000 \ yr)
Tot_urb_ben_e    (        t, p,w,s1,s2,s3,s4)      Total urban benefits by year                  ($1000 \ yr)
Tot_env_riv_ben_e(        t, p,w,s1,s2,s3,s4)      Total river environmental benefits by year    ($1000 \ yr)
Tot_rec_res_ben_e(        t, p,w,s1,s2,s3,s4)      Total recreation reservoir benefits by yeaer  ($1000 \ yr)

Tot_imp_costs_e  (        t, p,w,s1,s2,s3,s4)      total surface water import costs              ($1000 \ yr)
Tot_exp_costs_e  (        t, p,w,s1,s2,s3,s4)      tot surf water export costs - avert spill     ($1000 \ yr)

Tot_ben_e        (        t, p,w,s1,s2,s3,s4)      total benefits over uses                      ($1000 \ yr)

DNPV_ag_ben_e     (          p,w,s1,s2,s3,s4)      DNPV ag benefits                              ($1000)
DNPV_urb_ben_e    (          p,w,s1,s2,s3,s4)      DNPV urban benefits                           ($1000)
DNPV_env_riv_ben_e(          p,w,s1,s2,s3,s4)      DNPV environmental river benefits             ($1000)
DNPV_rec_res_ben_e(          p,w,s1,s2,s3,s4)      DNPV reservoir recreation benefits            ($1000)

DNPV_import_costs_e (        p,w,s1,s2,s3,s4)      DNPV surface import costs                     ($1000)
DNPV_export_costs_e(         p,w,s1,s2,s3,s4)      DNPV surfae export costs                      ($1000)

DNPV_ben_e       (           p,w,s1,s2,s3,s4)      discounted net present value over users       ($1000)
DNPV_e                                             discounted npv looped over sets               ($1000)

*matching history

*nm_tx_e          (         t,p,w,s1,s2,s3,s4)      nm deliveries at nm-tx stateline              (1000 af \ yr)

nm_tx_LB_e       (         t,p,w,s1,s2,s3,s4)       lower bound nm tx deliveries
nm_tx_UB_e       (         t,p,w,s1,s2,s3,s4)       upper bound nm tx deliveries

up_bnd_EPID_e    (         t,p,w,s1,s2,s3,s4)      upper bnd on deliveries to nm-tx stateline    (1000 af \ yr)


*below_epid_e     (         t,p,w,s1,s2,s3,s4)      below project region                         (1000 af \ yr)

*proj_operate_2008_e(      t,p,w,s1,s2,s3,s4)      2008 project operating constraint cab releases (1000 af \ yr)

proj_operate_2008_LB_e(        t,p,w,s1,s2,s3,s4)      2008 project operating constraint cab releases (1000 af \ yr)
proj_operate_2008_UB_e(        t,p,w,s1,s2,s3,s4)      2008 project operating constraint cab releases (1000 af \ yr)


*D1_e               (        t,p,w,s1,s2,s3,s4)      D1 term in operating agreement - deliveries    (1000 af \ yr)
*D2_e               (        t,p,w,s1,s2,s3,s4)      D2 term in operating agreement - diversions    (1000 af \ yr)

D1_LB_e             (        t,p,w,s1,s2,s3,s4)      D1 lower bound term in 2008 Op agreement
D1_UB_e             (        t,p,w,s1,s2,s3,s4)      D1 upper bound

D2_LB_e             (        t,p,w,s1,s2,s3,s4)      D2 Lower bound in 2008 op agreement
D2_Ub_e             (        t,p,w,s1,s2,s3,s4)      D2 upper bound

*US_MX_1906_e       (        t,p,w,s1,s2,s3,s4)      US MX 1906 treaty flows impl by 2008 po

US_MX_1906_LB_e     (        t,p,w,s1,s2,s3,s4)      lower bound US Mexico Treaty flow deliveries
US_MX_1906_UB_e     (        t,p,w,s1,s2,s3,s4)      upper bound US Mexico Treaty flow deliveries


tacres_base_l_e   (aguse,j,k,t,w,    s1,s2,s3,s4)   historical acres in prodn                     (1000 acres \ yr)
*tacres_base_2_e   (aguse,j,k,t,    s1,s2,s3,s4)   historical acres in prodn                     (1000 acres \ yr)

*ag_use_crop_bound_e(aguse,j,k,t,     s1,s2,s3,s4)   historical water use                          (1000 af \ yr)

*aquifers_terminal_1_e(aqf,   t,p,w,     s2,s3,s4)      Stock: terminal aquifer storage               (L3 \ T)  (1000 af)
*aquifers_terminal_2_e(aqf,   t,p,w,     s2,s3,s4)      Stock: terminal aquifer storage               (L3 \ T)  (1000 af)

*aquifers_average1_e (aqf,      p,w,s1,     s3,s4)      Stock: average aquifer storage                (L3 \ T)  (1000 af)
*aquifers_average2_e (aqf,      p,w,s1,     s3,s4)      Stock: average aquifer storage                (L3 \ T)  (1000 af)

*Q_ave_e              (aqf,  p,w,s1,s2,s3,s4)          average aquifer storage                       (1000 af)
*Q_term_e             (aqf,t,p,w,s1,s2,s3,s4)          terminal aquifer storage                      (1000 af)

Q_term_e             (aqf,t,      p,w,   s2,s3,s4)    terminal aqf storage                          (1000 af)
*Q_ave_e              (aqf,        p,w,s1,   s3,s4)    ave aquifer storage                           (1000 af)


;

*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
* EQUATIONS DEFINED ALGEBRAICALLY USING EQUATION NAMES
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*


*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
*  Agricultural Land  Block
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*


Land_e(aguse,  t,pp,ww,ss1,ss2,ss3,ss4)..  sum((j,k), Tacres_v(aguse,  j,k,t,pp,ww,ss1,ss2,ss3,ss4)) =e= tot_acres_v(aguse,t,pp,ww,ss1,ss2,ss3,ss4);

Yield0_e    (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  $ (ord(t) eq 1)..       yield_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =e= yield_p(aguse,j,k);
*Yield_e     (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  $ (ord(t) gt 1)..       Yield_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =e=  B0_p(aguse,j,k,t)  + B1_p(aguse,j,k,t) * Tacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);  // postive math programming calibration if needed
Yield_e     (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  $ (ord(t) gt 1)..        Yield_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =e= yield_p(aguse,j,k);

Tacres_e     (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                             Tacres_v (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                       =e=     SWacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                            +  GWacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                            +  BTacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);

gw_aq_acres_e(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..       gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                  =e=            ag_pump_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) / Ba_use_p(aguse,j,k);
                                                                                                                             ; // total land supplied by sw + gw
acres_pump_e (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                gwacres_v(aguse,    j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                  =e=    sum(aqf, ag_pump_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)) / Ba_use_p  (aguse,j,k); // land supplied by gw

BTacres_e    (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                BTacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                  =e=         ag_back_use_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) / Ba_use_p(aguse,j,k);  // acreage irrigated by BT technology


*--------------*---------*---------*---------*---------*---------*---------*------------*
* Hydrology  Block
*---------*---------*---------*---------*---------*---------*---------*-----------------*


* --------------------------------------------------------------------------------------*
*                                    surface water begins
* --------------------------------------------------------------------------------------*

* inflows start

Inflows_e(inflow,t,pp,ww,ss1,ss2,ss3,ss4)..      X_v(inflow,  t,pp,ww,ss1,ss2,ss3,ss4) =E= source_p(inflow,t,ww);

Rivers_e  (river,t,pp,ww,ss1,ss2,ss3,ss4)..      X_v(river,   t,pp,ww,ss1,ss2,ss3,ss4 ) =E=

     sum(inflow,    Bv_p(inflow,  river)  * source_p(inflow,  t,   ww                )) +
     sum(imports,   Bv_p(imports, river)  *      X_v(imports, t,pp,ww,ss1,ss2,ss3,ss4)) +
     sum(exports,   Bv_p(exports, river)  *      X_v(exports, t,pp,ww,ss1,ss2,ss3,ss4)) +
     sum(riverp,    Bv_p(riverp,  river)  *      X_v(riverp,  t,pp,ww,ss1,ss2,ss3,ss4)) +
     sum(divert,    Bv_p(divert,  river)  *      X_v(divert,  t,pp,ww,ss1,ss2,ss3,ss4)) +
     sum(r_return,  Bv_p(r_return,river)  *      X_v(r_return,t,pp,ww,ss1,ss2,ss3,ss4)) +
     sum(rel,       Bv_p(rel,     river)  *      X_v(rel,     t,pp,ww,ss1,ss2,ss3,ss4)) ;



reservoirs0_e(res,t,pp,ww,ss1,ss2,ss3,ss4)  $ (ord(t) eq 1)..   Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) =e= Z0_p(res,pp,ss3);

reservoirs_e (res,t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..   Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4)        =E= Z_v(res,t-1,pp,ww,ss1,ss2,ss3,ss4)

                            -  SUM(rel, BLv_p(rel,res)       * X_v(rel,t,pp,ww,ss1,ss2,ss3,ss4))
                            -                        evaporation_v(res,t,pp,ww,ss1,ss2,ss3,ss4)
                            +                         precip_v    (res,t,pp,ww,ss1,ss2,ss3,ss4);


* net releases are defined exclusive of imports since entering downstream of the dam don't add to reservoir storage/;

Net_release_e(t,pp,ww,ss1,ss2,ss3,ss4).. X_v('store_rel_f',t,pp,ww,ss1,ss2,ss3,ss4) =n= X_v('RG_Caballo_out_v_f',t,pp,ww,ss1,ss2,ss3,ss4)
*                                                                                      - X_v('Imp_Caballo_m_f',   t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                 - source_p('Marcial_h_f',       t,   ww                );  // works for caballo needs adjusting for more reservoirs

*inflows end

* reservoirs start

// reservoir storage tracking

Evaporation_e(res,t,pp,ww,ss1,ss2,ss3,ss4)..  Evaporation_v(res,t,pp,ww,ss1,ss2,ss3,ss4)  =e= Evap_rate_p(t,ss4)   * surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4);
Precip_e     (res,t,pp,ww,ss1,ss2,ss3,ss4)..  Precip_v     (res,t,pp,ww,ss1,ss2,ss3,ss4)  =e= Precip_rate_p(t)     * surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4);

*Surf_area_e  (res,t,pp,ww,ss1,ss2,ss3,ss4)..    surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4)  =e= B1_area_vol_p * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) + B2_area_volsq_p * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 2;


$ontext

Surf_area_e  (res,t,pp,ww,ss1,ss2,ss3,ss4)..           surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4)  =e=

                                    4.301     * [1/ (10**2)] * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 1
                                 -  4.095     * [1/ (10**5)] * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 2
                                 +  2.421634  * [1/ (10**8)] * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 3
                                 -  4.9841    * [1/(10**12)] * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 4;
$offtext

Surf_area_e  (res,t,pp,ww,ss1,ss2,ss3,ss4)..    surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4)  =e= B1_area_vol_p   * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                            + B2_area_volsq_p * Z_v(res,t,pp,ww,ss1,ss2,ss3,ss4) ** 2;

*reservoirs end


AgDiverts_e  (agdivert,  tlater,pp,ww,ss1,ss2,ss3,ss4)..  X_v(agdivert,           tlater,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Ba_divert_p (agdivert,  j,k)  * sum(aguse, ID_adu_p(agdivert,aguse   ) * SWacres_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4)));  // diversions prop to acreage
AgUses_e     (aguse,     tlater,pp,ww,ss1,ss2,ss3,ss4)..  X_v(          aguse,    tlater,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Ba_use_p    (aguse,     j,k)  *    (1                                ) * SWacres_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4)) ;  // use prop to acreage
Ag_Use_crop_e(aguse,j,k, tlater,pp,ww,ss1,ss2,ss3,ss4)..  Ag_Use_crop_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4) =e=            Ba_use_p    (aguse,     j,k)  *    (1                                ) * SWacres_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4) ;  // use prop to acreage

Agr_Returns_e(agr_return,tlater,pp,ww,ss1,ss2,ss3,ss4)..  X_v(agr_return,tlater,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bar_return_p(agr_return,j,k)  * sum(aguse, ID_arr_p(agr_return,aguse ) * SWacres_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4)));  // return flows prop to acreage
// ag river diversions applied returned to river

Aga_Returns_e(aga_return,tlater,pp,ww,ss1,ss2,ss3,ss4)..  Aga_returns_v(aga_return,tlater,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Baa_return_p(aga_return,j,k)  * sum(aguse, ID_ara_p(aga_return,aguse ) * SWacres_v(aguse,j,k,tlater,pp,ww,ss1,ss2,ss3,ss4)));  // return flow to aquifer from ag application
// ag river diversions applied returned to aquifer
//Agp_Returns_e (ag pumping returns to river)

MIUses_e     (miuse,       t,pp,ww,ss1,ss2,ss3,ss4)..  X_v(miuse,     t,pp,ww,ss1,ss2,ss3,ss4) =e=  sum(midivert, Bmdu_p(midivert,     miuse) *  X_v(midivert,t,pp,ww,ss1,ss2,ss3,ss4));
MIr_Returns_e(mir_return,  t,pp,ww,ss1,ss2,ss3,ss4)..  X_v(mir_return,t,pp,ww,ss1,ss2,ss3,ss4) =e=  sum(midivert, Bmdr_p(midivert,mir_return) *  X_v(midivert,t,pp,ww,ss1,ss2,ss3,ss4));
* urban river diversions returned to river

MIa_Returns_e(mia_return,  t,pp,ww,ss1,ss2,ss3,ss4)..  X_v(mia_return,t,pp,ww,ss1,ss2,ss3,ss4) =e=  sum(midivert, Bmda_p(midivert,mia_return) *  X_v(midivert,t,pp,ww,ss1,ss2,ss3,ss4));
* urban river diversions returned to aquifer



* ---------------------------------- surface water ends ---------------------------------------------------

* ---------------------------------------------------------------------------------------------------------
* ----------------------------------    Aquifer Water Begins ----------------------------------------------
*----------------------------------------------------------------------------------------------------------

Ag_pump_aq_rch1_e(t,pp,ww,ss1,ss2,ss3,ss4)..  Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_pump_aqf_return_p('ebid_u_f',j,k) * ag_pump_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));     // ebid pump mesilla aq
Ag_pump_aq_rch2_e(t,pp,ww,ss1,ss2,ss3,ss4)..  Ag_pump_aq_rch_v('hueco_aqf_s'  ,'epid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_pump_aqf_return_p('epid_u_f',j,k) * ag_pump_v('hueco_aqf_s',  'epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));  // epid ag pump hueco aq
Ag_pump_aq_rch3_e(t,pp,ww,ss1,ss2,ss3,ss4)..  Ag_pump_aq_rch_v('hueco_aqf_s'  ,'mxid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_pump_aqf_return_p('mxid_u_f',j,k) * ag_pump_v('hueco_aqf_s',  'mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));  // mx ag pump mesilla aq

* ---------------------------------------------------------------------------------------------------------
* ag backstop technology recharge here -- in progress

*ag_back_aq_rch1_e(t,pp,ww,ss1,ss2,ss3,ss4)..  ag_back_aq_rch_v('mesilla_aqf_s', 'ebid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_back_aqf_return_p('ebid_u_f') * ag_back_use_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));
*ag_back_aq_rch2_e(t,pp,ww,ss1,ss2,ss3,ss4)..  ag_back_aq_rch_v('hueco_aqf_s'  , 'epid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_back_aqf_return_p('epmi_u_f') * ag_back_use_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));
*ag_back_aq_rch3_e(t,pp,ww,ss1,ss2,ss3,ss4)..  ag_back_aq_rch_v('hueco_aqf_s'  , 'mxid_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), Bag_back_aqf_return_p('mxmi_u_f') * ag_back_use_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4));

* end of ag backstop technology recharge

* ---------------------------------------------------------------------------------------------------------

** urban aquifer recharge from backstop technology by aquifer and city

Urb_back_aq_rch1_e (t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('mesilla_aqf_s', 'lcmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  Burb_back_aqf_rch_p('lcmi_u_f') * urb_back_use_v('lcmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4);
Urb_back_aq_rch12_e(t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('mesilla_aqf_s', 'epmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  0;
Urb_back_aq_rch13_e(t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('mesilla_aqf_s', 'mxmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  0;

Urb_back_aq_rch21_e(t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'lcmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  0;
Urb_back_aq_rch2_e (t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'epmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  Burb_back_aqf_rch_p('epmi_u_f') * urb_back_use_v('epmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4);
Urb_back_aq_rch3_e (t,pp,ww,ss1,ss2,ss3,ss4)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'mxmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4) =e=  Burb_back_aqf_rch_p('mxmi_u_f') * urb_back_use_v('mxmi_u_f',t,pp,ww,ss1,ss2,ss3,ss4);

* ------------------------------------------------------------------------------ aquifer recharge and discharge --------------------------------------------------------------------------------------------------------

*mesilla aquifer recharge follows

aquifer_recharge_m0_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) eq 1)..                    aquifer_recharge_m_v(t,pp,ww,ss1,ss2,ss3,ss4) =e= recharge_p('mesilla_aqf_s',t);


aquifer_recharge_m_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..                     aquifer_recharge_m_v(t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                                                      recharge_p('mesilla_aqf_s',           t                      )     // mesilla aq mountain recharge in t

                                                                     +             Aga_returns_v('ebid_ra_f',               t,pp,ww,ss1,ss2,ss3,ss4)     // ag ebid river divert return to aqf

                                                                     +          Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)     // ag ebid pumping return to mesilla

*                                                                     +          ag_back_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)     // ag back technology recharge to Mesilla

                                                                   + sum(miuse, urb_back_aq_rch_v('mesilla_aqf_s', miuse,   t,pp,ww,ss1,ss2,ss3,ss4));   // urban back technology recharge to Mesilla
                                                                                                                                                         // open future slot:  urban pumping return to mesilla aqf
                                                                                                                                                         // open future slot urban river return to mesilla


*hueco aquifer recharge follows

aquifer_recharge_h0_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) eq 1)..                    aquifer_recharge_h_v(t,pp,ww,ss1,ss2,ss3,ss4) =e= recharge_p('hueco_aqf_s',t);

aquifer_recharge_h_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..                     aquifer_recharge_h_v(t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                                                      recharge_p('hueco_aqf_s',           t                      )        // hueco aq mountain recharge in t

                                                                     +             Aga_returns_v('epid_ra_f',             t,pp,ww,ss1,ss2,ss3,ss4)        // ag epid river divert return to aqf
                                                                     +             Aga_returns_v('mxid_ra_f',             t,pp,ww,ss1,ss2,ss3,ss4)        // ag mxid river divert return to aqf

                                                                     +          Ag_pump_aq_rch_v('hueco_aqf_s','epid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)        // ag epid pumping return to hueco
                                                                     +          Ag_pump_aq_rch_v('hueco_aqf_s','mxid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)        // ag mxid pumping return to hueco

*                                                                     +          ag_back_aq_rch_v('hueco_aqf_s','epid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)        // ag back technology from epid recharge to Hueco
*                                                                     +          ag_back_aq_rch_v('hueco_aqf_s','mxid_u_f',t,pp,ww,ss1,ss2,ss3,ss4)        // ag back technology from mxid recharge to Hueco

                                                                  + sum(miuse, urb_back_aq_rch_v('hueco_aqf_s', miuse,    t,pp,ww,ss1,ss2,ss3,ss4));      // urban back technology recharge to Hueco
                                                                                                                                                          // open future slot: urban pumping return to Hueco aqf
                                                                                                                                                          // open future slot urban river return to Hueco aqf


aquifer_discharge_m_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 0)..                   aquifer_discharge_m_v(t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                                         sum(miuse,    urb_pump_v('mesilla_aqf_s',miuse,  t,pp,ww,ss1,ss2,ss3,ss4))   // urban pumping from mesilla aquifer
                                                                      +  sum(aguse, tot_ag_pump_v('mesilla_aqf_s',aguse,  t,pp,ww,ss1,ss2,ss3,ss4));  // ag pumping from mesilla aquifer


aquifer_discharge_h_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 0)..                   aquifer_discharge_h_v(t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                                         sum(miuse,    urb_pump_v('hueco_aqf_s',miuse,    t,pp,ww,ss1,ss2,ss3,ss4))   // urban pumping from hueco aquifer
                                                                      +  sum(aguse, tot_ag_pump_v('hueco_aqf_s',aguse,    t,pp,ww,ss1,ss2,ss3,ss4));   // ag pumping from hueco aquifer

aquifers0_e  (aqf,t,pp,ww,ss1,ss2,ss3,ss4)   $ (ord(t) eq 1)..     Q_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4)  =e= Q0_p(aqf);   //aquifer starting values


aquifer_storage_m_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..     Q_v('mesilla_aqf_s',t,  pp,ww,ss1,ss2,ss3,ss4) =e=   // mesilla aq storage t
                                                                   Q_v('mesilla_aqf_s',t-1,pp,ww,ss1,ss2,ss3,ss4)       // mesilla aq storage t-1
                                                           +      aquifer_recharge_m_v(t,  pp,ww,ss1,ss2,ss3,ss4)       // mesilla recharge   t
                                                           -     aquifer_discharge_m_v(t,  pp,ww,ss1,ss2,ss3,ss4)  ;    // mesilla discharge  t


aquifer_storage_h_e(t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..       Q_v('hueco_aqf_s',t,  pp,ww,ss1,ss2,ss3,ss4) =e=   // hueco aq storage t
                                                                     Q_v('hueco_aqf_s',t-1,pp,ww,ss1,ss2,ss3,ss4)       // hueco aq storage t-1
                                                           +      aquifer_recharge_h_v(t,  pp,ww,ss1,ss2,ss3,ss4)       // hueco aq recharge   t
                                                           -     aquifer_discharge_h_v(t,  pp,ww,ss1,ss2,ss3,ss4)  ;    // hueco aq discharge  t

* total ag pumping over crops by aquifer
tot_ag_pump_e(aqf,aguse,t,pp,ww,ss1,ss2,ss3,ss4)..  tot_ag_pump_v(aqf,aguse,t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((j,k), ag_pump_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));  // total ag pumping by district

* total ag pumping
sum_ag_pump_e  (t,pp,ww,ss1,ss2,ss3,ss4)..     sum_ag_pump_v(t,pp,ww,ss1,ss2,ss3,ss4) =e= sum((aqf,aguse), tot_ag_pump_v(aqf,aguse,t,pp,ww,ss1,ss2,ss3,ss4));

* total urban pumping
sum_urb_pump_e (t,pp,ww,ss1,ss2,ss3,ss4)..    sum_urb_pump_v(t,pp,ww,ss1,ss2,ss3,ss4) =e= sum(miuse, urb_gw_use_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4));

* aquifer depth by aquifer
aquifer_depth_e(aqf,t,pp,ww,ss1,ss2,ss3,ss4)..     Aquifer_depth_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4)  =e= [qmax_p(aqf) - Q_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4)] / [porosity_p(aqf) * aq_area_p(aqf)]; // simple rectangle bathub shaped aquifer


* --------------------------------------------------------------------------------------
* ----------------------------- End Aquifer Tracking -----------------------------------
* --------------------------------------------------------------------------------------


* --------------------------------------------------------------------------------------
* --------------------------- Backstop Technology Water documentation ------------------
* --------------------------------------------------------------------------------------

* backstop technology water is available in infinite quantities at the specified price.
* There are no quantity limitations
* It reflects the least cost combination of brackish water, desal, and imported water
* It can be inserted at a user-specified price per acre foot.
* It's included in several equations above

* --------------------------------------------------------------------------------------
* ---------------------------- Backstop Technology Water documentation ends ------------
* --------------------------------------------------------------------------------------


*---------------------------------------------------------------------------------------
* Institutions Block
* water laws, compacts, treaties, etc constrains use
* all are defined in bounds below so allow display of shadow values (marginals)
*---------------------------------------------------------------------------------------



* --------------------------------------------------------------------------------------
* Total Mexican Surface Water Diversions
* --------------------------------------------------------------------------------------

* tracks total mexican surface diversion over ag and urban.  For dec 2017 all MX surface use is for agriculture.  Urban is all pumped

MX_sw_divert_e(t,pp,ww,ss1,ss2,ss3,ss4)..   MX_sw_divert_v(t,pp,ww,ss1,ss2,ss3,ss4) =e= X_v('MXMI_d_f', t, pp, ww,ss1,ss2,ss3,ss4) + X_v('MXID_d_f', t, pp, ww,ss1,ss2,ss3,ss4);


*---------------------------------------------------------------------------------------
* Economics Block as connected to urban and ag use -- money units $ US
*---------------------------------------------------------------------------------------

* urban econ block: document. Booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/

urb_sw_use_e   (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..     urb_sw_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=                        X_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);
urb_gw_use_e   (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..   urb_gw_use_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=     sum(aqf,urb_pump_v(aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4));

urb_use_e      (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..                                 urb_use_v     (miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                                                   urb_sw_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                               +   urb_gw_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                               + urb_back_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4); // urban use = urb divert + urb pump + urb backstop use

urb_price_e    (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..      urb_price_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=           BB0_p(miuse,ss3)  +         [bb1_p(miuse,t,ss3)                    * urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)];   // urban demand price flattens as urban customer numbers grow.
urb_con_surp_e (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..   urb_con_surp_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=   0.5 * {[BB0_p(miuse,ss3) -   urb_price_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4)] * urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)};   // urban price is not known until model runs (dependent variable)
urb_use_p_cap_e(

*BB1_base_p (miuse,s3)
*BB1_p      (miuse,t,s3)
*BB0_p      (miuse,s3  )


miuse,t,pp,ww,ss1,ss2,ss3,ss4)..  urb_use_p_cap_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=       urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) /         pop_p(miuse,t);                                // per household urban water use typically about 0.5 acre feet/yr
urb_revenue_e  (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..    urb_revenue_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=     urb_price_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) *     urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);                          // urban gross tariff revenue
urb_gross_ben_e(miuse,t,pp,ww,ss1,ss2,ss3,ss4)..  urb_gross_ben_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=  urb_con_surp_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) + urb_revenue_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);                          // tariff revenue + consumer surplus

urb_costs_e    (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..    urb_costs_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=

                              urb_Av_cost_p(miuse,t)                                                               *   urb_sw_use_v(              miuse,t,pp,ww,ss1,ss2,ss3,ss4)
*                 + sum{aqf,  [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p(ss2) * aquifer_depth_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4)] * urb_pump_v(aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4)}

           + [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)] * urb_pump_v('mesilla_aqf_s',miuse,t,pp,ww,ss1,ss2,ss3,ss4)
           + [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',  t,pp,ww,ss1,ss2,ss3,ss4)] * urb_pump_v('hueco_aqf_s',  miuse,t,pp,ww,ss1,ss2,ss3,ss4)

           +  urb_av_back_cost_p(miuse,t,ss2)                   * urb_back_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);

urb_av_tot_cost_e(miuse,t,pp,ww,ss1,ss2,ss3,ss4)..  urb_av_tot_cost_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e= urb_costs_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) /
                                                                                                   (.001 + urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4));

urb_av_gw_cost_e(miuse,t,pp,ww,ss1,ss2,ss3,ss4).. urb_av_gw_cost_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                 [
         sum(aqf,   [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v(aqf, t,pp,ww,ss1,ss2,ss3,ss4)] * urb_pump_v(aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4))
                 ]
                 /
            [.001 +         urb_gw_use_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4)];

* below is urban costs exclusive of backstop technology

urb_costs_x_bs_e(miuse,t,pp,ww,ss1,ss2,ss3,ss4).. urb_costs_x_bs_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                       urb_costs_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)
                    - urb_av_back_cost_p(miuse,t,ss2) * urb_back_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);

urb_value_e    (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..   urb_value_v   (miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=    urb_gross_ben_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) - urb_costs_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4);                      // urban value - net benefits = gross benefits minus urban costs (cs + ps)

Urb_value_af_e (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..   Urb_value_af_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=    urb_value_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) /     (urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) + 0.01);                      // [wat_use_urb_v(miuse,t) + 0.01]);  // urban economic value per acre foot - includes consumer surplus
urb_m_value_e  (miuse,t,pp,ww,ss1,ss2,ss3,ss4)..  urb_m_value_v  (miuse,t,pp,ww,ss1,ss2,ss3,ss4) =e=    urb_price_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) - (urb_costs_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4) / (.001 + urb_use_v(miuse,t,pp,ww,ss1,ss2,ss3,ss4)));    // urb marg value: has errors

* --------------------------------------------------------------------------------------
* end of urban economics block
* --------------------------------------------------------------------------------------

* --------------------------------------------------------------------------------------
* begin irrigation economics block:  see booker, michelsen, ward, Water Resources Research 2006 https://water-research.nmsu.edu/
* --------------------------------------------------------------------------------------


* costs start


ag_costs_eb_e (           j,k,t,pp,ww,ss1,ss2,ss3,ss4)..

 ag_costs_v   ('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)           =e=
             [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * 50                                                                                    ] *     swacres_v('ebid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)}] * gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
*       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * ag_av_back_cost_p('ebid_u_f',j,k,t,ss2)                                               ] *     btacres_v('ebid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4);


ag_costs_ep_e (           j,k,t,pp,ww,ss1,ss2,ss3,ss4)..

 ag_costs_v ('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)           =e=
             [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * 50                                                                                    ] *     swacres_v('epid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)}]   * gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
*       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * ag_av_back_cost_p('epid_u_f',j,k,t,ss2)                                                   ] *     btacres_v('epid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4);


ag_costs_mx_e (           j,k,t,pp,ww,ss1,ss2,ss3,ss4)..

 ag_costs_v ('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)           =e=
             [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * 50                                                                                    ] *     swacres_v('mxid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)}]   * gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
*       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * ag_av_back_cost_p('mxid_u_f',j,k,t,ss2)                                                   ] *     btacres_v('mxid_u_f',              j,k,t,pp,ww,ss1,ss2,ss3,ss4);

ag_tot_sw_costs_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..            ag_tot_sw_costs_v( aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
            (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *   50                                                                                                        ])  *          swacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);

ag_tot_gw_costs_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..            ag_tot_gw_costs_v( aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
  + sum(aqf, (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *  {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)}                      ])  *  gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

ag_tot_bt_costs_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..            ag_tot_bt_costs_v( aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
             (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *       ag_av_back_cost_p(aguse,j,k,t,ss2)                                                                       ])  *        btacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);

*  + sum(aqf, (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) * {ag_av_gw_cost_p(aguse,ss4) + (cost_af_unit_depth_p      * aquifer_depth_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4))}]) *  gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

Ag_av_sw_costs_e(aguse, j,k,t,pp,ww,ss1,ss2,ss3,ss4)..   ag_av_sw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                   =n=  ag_tot_sw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) / (.001 + swacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

ag_av_gw_costs_e(aguse, j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  ag_av_gw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                   =n= ag_tot_gw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) / (.001 + sum(aqf, gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)));


ag_av_sw_costs_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  ag_av_sw_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * (50) ;

ag_av_gw_costs_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  ag_av_gw_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww,ss1,ss2,ss3,ss4)} ;

ag_av_bt_costs_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  ag_av_bt_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * {ag_av_back_cost_p('ebid_u_f',j,k,t,ss2)};

ag_av_bt_costs_e(aguse, j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  ag_av_bt_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                   =n= ag_tot_bt_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) / (.001 + btacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

Ag_av_costs_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..        Ag_av_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                   =e=       ag_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  / (.001 + ag_use_v(aguse,t,pp,ww,ss1,ss2,ss3,ss4));

* costs end

Ag_av_rev_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..    Ag_av_rev_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=
                                                        price_p(aguse,j                          )
                                                 *      yield_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);  // gross rev per acre

Ag_value_e   (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..     Ag_value_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  =e=
                                                      Ag_av_rev_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                   *     Tacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)

                                              - Ag_tot_sw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                              - Ag_tot_gw_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                              - Ag_tot_bt_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);
*                                                     - Ag_costs_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) ; // farm net income from all water sources

Ag_ben_e     (aguse,    t,pp,ww,ss1,ss2,ss3,ss4)..    Ag_Ben_v   (aguse,    t,pp,ww,ss1,ss2,ss3,ss4)  =E=      sum((j,k), Ag_value_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

Netrev_acre_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  Netrev_acre_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  =e=     ag_value_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                    / (.01 +    Tacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));   // net farm income per acre

*ebid

NR_ac_sw_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_sw_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=    price_p('ebid_u_f',j                          )
                                                                                                        *  yield_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                               -  ag_av_sw_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_gw_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_gw_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=      price_p('ebid_u_f',j                        )
                                                                                                        *    yield_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                -   ag_av_gw_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_bt_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_bt_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=      price_p('ebid_u_f',j                         )
                                                                                                        *    yield_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                -   ag_av_bt_costs_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

TNR_eb_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                          TNR_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                 NR_ac_sw_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                      swacres_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_gw_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *  gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_bt_eb_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                      btacres_v('ebid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

*epid


NR_ac_sw_ep_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_sw_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=    price_p('epid_u_f',j                          )
                                                                                                        *  yield_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                               -  ag_av_sw_costs_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_gw_ep_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_gw_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=      price_p('epid_u_f',j                        )
                                                                                                        *    yield_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                -   ag_av_gw_costs_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_bt_ep_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_bt_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=     price_p('epid_u_f',j                         )
                                                                                                       *    yield_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                               -   ag_av_bt_costs_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

TNR_ep_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                         TNR_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                 NR_ac_sw_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                    swacres_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_gw_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *  gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_bt_ep_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                    btacres_v('epid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

*mxid
NR_ac_sw_mx_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_sw_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=    price_p('mxid_u_f',j                          )
                                                                                                        *  yield_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                               -  ag_av_sw_costs_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_gw_mx_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_gw_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=      price_p('mxid_u_f',j                        )
                                                                                                        *    yield_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                -   ag_av_gw_costs_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);


NR_ac_bt_mx_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..  NR_ac_bt_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=     price_p('mxid_u_f',j                         )
                                                                                                       *    yield_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                               -   ag_av_bt_costs_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

TNR_mx_e(j,k,t,pp,ww,ss1,ss2,ss3,ss4)..                          TNR_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=

                                                 NR_ac_sw_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                    swacres_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_gw_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *  gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                          +      NR_ac_bt_mx_v(j,k,t,pp,ww,ss1,ss2,ss3,ss4) *                    btacres_v('mxid_u_f',j,k,t,pp,ww,ss1,ss2,ss3,ss4);

Netrev_af_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..      Netrev_af_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  =e=     ag_value_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)
                                                                                                    / (.01 + Ag_use_jk_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));   // net farm income per acre foot water used (ET)

Ag_use_e     (aguse,    t,pp,ww,ss1,ss2,ss3,ss4)..       ag_use_v(aguse,    t,pp,ww,ss1,ss2,ss3,ss4)  =e=
                                                              X_v(aguse,    t,pp,ww,ss1,ss2,ss3,ss4)
                                  +  sum((j,k,aqf), ag_pump_v(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4))
                                  +  sum((j,k),     ag_back_use_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4));

Ag_sw_use_jk_e  (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..   Ag_sw_use_jk_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) =e=  Ba_use_p  (aguse,j,k) * SWacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) ;  // use prop to acreage

Ag_use_jk_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..           ag_use_jk_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)  =e=
                                                        Ag_sw_Use_jk_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)              // river use
                                            +  sum(aqf, ag_pump_v(aqf, aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4))             // pumping
                                            +            ag_back_use_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4);            // backstop technology.  total use is sw + gw + backstop ag water use

T_ag_ben_e   (            pp,ww,ss1,ss2,ss3,ss4)..    T_ag_ben_v (            pp,ww,ss1,ss2,ss3,ss4)  =E=      sum((aguse,t),   Ag_Ben_v(aguse,  t,pp,ww,ss1,ss2,ss3,ss4));

Ag_m_value_e(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)..    Ag_m_value_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =e=  [price_p(aguse,j) *   Yield_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)      - Cost_p(aguse,j,k)] * (1/Ba_use_p(aguse,j,k)) +
                                                                             price_p(aguse,j) * SWacres_v(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4) *      B1_p(aguse,j,k,t)  * (1/Ba_use_p(aguse,j,k));
* --------------------------------------------------------------------------------------
* end irrigation economics block
* --------------------------------------------------------------------------------------

* environmental economics benefit block

Env_ben_e(river,t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(river) = card(river))..    env_ben_v('RG_below_EPID_v_f',t,pp,ww,ss1,ss2,ss3,ss4)  =e=   B0_env_flow_ben_p('RG_below_EPID_v_f') * (1+X_v('RG_below_EPID_v_f',t,pp,ww,ss1,ss2,ss3,ss4))** B1_env_flow_ben_p('RG_below_EPID_v_f');  // env flow benefit inc at falling rate synth data

* reservoir recreation benefit block

Rec_ben_e(res,t,pp,ww,ss1,ss2,ss3,ss4)..                  rec_ben_v(res,t,pp,ww,ss1,ss2,ss3,ss4)  =e=   B0_rec_ben_intercept_p(res) + B0_rec_ben_p(res) * surf_area_v(res,t,pp,ww,ss1,ss2,ss3,ss4)** B1_rec_ben_p(res);  // simple square root function synthetic data

* ---------------------------------------------------------------------------------------
* surface water streamflow augmentation import/export cost block
* ---------------------------------------------------------------------------------------

Flow_import_cost_e(imports,t,pp,ww,ss1,ss2,ss3,ss4)..   Flow_import_cost_v(imports,t,pp,ww,ss1,ss2,ss3,ss4) =e= 1.0 * cost_af_flow_import_p(ss2) * X_v(imports,t,pp,ww,ss1,ss2,ss3,ss4);
Flow_export_cost_e(exports,t,pp,ww,ss1,ss2,ss3,ss4)..   Flow_export_cost_v(exports,t,pp,ww,ss1,ss2,ss3,ss4) =e= 1.0 * cost_af_flow_export_p      * X_v(exports,t,pp,ww,ss1,ss2,ss3,ss4);

* --------------------------------------------------------------------------------------
* total economic welfare block
* --------------------------------------------------------------------------------------

Tot_ben_e (       t,pp,ww,ss1,ss2,ss3,ss4) $ (ord(t) gt 1)..         Tot_ben_v          (                    t,pp,ww,ss1,ss2,ss3,ss4)   =e=
                                                                 sum(aguse, ag_ben_v    (   aguse,           t,pp,ww,ss1,ss2,ss3,ss4))
                                                               + sum(miuse, urb_value_v (   miuse,           t,pp,ww,ss1,ss2,ss3,ss4))
                                                               + sum(res,   rec_ben_v   (   res,             t,pp,ww,ss1,ss2,ss3,ss4))
                                                               +            env_ben_v   ('RG_below_EPID_v_f',t,pp,ww,ss1,ss2,ss3,ss4)  // small benefit from instream flow in forgotton reach below el paso
                                                               - sum(imports, flow_import_cost_v(imports,    t,pp,ww,ss1,ss2,ss3,ss4))
                                                               - sum(exports, flow_export_cost_v(exports,    t,pp,ww,ss1,ss2,ss3,ss4));

Tot_ag_ben_e     (t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_ag_ben_v     (t,pp,ww,ss1,ss2,ss3,ss4)   =e=  sum(aguse, ag_ben_v      (aguse,               t,pp,ww,ss1,ss2,ss3,ss4));
Tot_urb_ben_e    (t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_urb_ben_v    (t,pp,ww,ss1,ss2,ss3,ss4)   =e=  sum(miuse, urb_value_v   (miuse,               t,pp,ww,ss1,ss2,ss3,ss4));
Tot_env_riv_ben_e(t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_env_riv_ben_v(t,pp,ww,ss1,ss2,ss3,ss4)   =e=             env_ben_v     ('RG_below_EPID_v_f', t,pp,ww,ss1,ss2,ss3,ss4) ;
Tot_rec_res_ben_e(t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_rec_res_ben_v(t,pp,ww,ss1,ss2,ss3,ss4)   =e=  sum(res,rec_ben_v        (res,                 t,pp,ww,ss1,ss2,ss3,ss4)); // recreation benefit from storage at elephant Butte and Caballo

Tot_imp_costs_e  (t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_imp_costs_v  (t,pp,ww,ss1,ss2,ss3,ss4)   =e=  sum(imports, flow_import_cost_v(imports,       t,pp,ww,ss1,ss2,ss3,ss4));
Tot_exp_costs_e  (t,pp,ww,ss1,ss2,ss3,ss4)..   Tot_exp_costs_v  (t,pp,ww,ss1,ss2,ss3,ss4)   =e=  sum(exports, flow_export_cost_v(exports,       t,pp,ww,ss1,ss2,ss3,ss4));

DNPV_ag_ben_e      (pp,ww,ss1,ss2,ss3,ss4)..   DNPV_ag_ben_v      (pp,ww,ss1,ss2,ss3,ss4)   =e= sum(tlater, disc_factr_p(ss4,tlater) *  tot_ag_ben_v     (tlater,pp,ww,ss1,ss2,ss3,ss4));
DNPV_urb_ben_e     (pp,ww,ss1,ss2,ss3,ss4)..   DNPV_urb_ben_v     (pp,ww,ss1,ss2,ss3,ss4)   =e= sum(tlater, disc_factr_p(ss4,tlater) *  tot_urb_ben_v    (tlater,pp,ww,ss1,ss2,ss3,ss4));
DNPV_env_riv_ben_e (pp,ww,ss1,ss2,ss3,ss4)..   DNPV_env_riv_ben_v (pp,ww,ss1,ss2,ss3,ss4)   =e= sum(tlater, disc_factr_p(ss4,tlater) *  tot_env_riv_ben_v(tlater,pp,ww,ss1,ss2,ss3,ss4));
DNPV_rec_res_ben_e (pp,ww,ss1,ss2,ss3,ss4)..   DNPV_rec_res_ben_v (pp,ww,ss1,ss2,ss3,ss4)   =e= sum(tlater, disc_factr_p(ss4,tlater) *  tot_rec_res_ben_v(tlater,pp,ww,ss1,ss2,ss3,ss4));

DNPV_import_costs_e(pp,ww,ss1,ss2,ss3,ss4)..   DNPV_import_costs_v(pp,ww,ss1,ss2,ss3,ss4)   =e= sum(t     , disc_factr_p(ss4,t     ) *  tot_imp_costs_v  (t     ,pp,ww,ss1,ss2,ss3,ss4));
DNPV_export_costs_e(pp,ww,ss1,ss2,ss3,ss4)..   DNPV_export_costs_v(pp,ww,ss1,ss2,ss3,ss4)   =e= sum(t     , disc_factr_p(ss4,t     ) *  tot_exp_costs_v  (t     ,pp,ww,ss1,ss2,ss3,ss4));


DNPV_ben_e         (pp,ww,ss1,ss2,ss3,ss4)..      DNPV_ben_v        (pp,ww,ss1,ss2,ss3,ss4) =e=

                                                   DNPV_ag_ben_v     (pp,ww,ss1,ss2,ss3,ss4)
                                               +   DNPV_urb_ben_v    (pp,ww,ss1,ss2,ss3,ss4)
                                               +   DNPV_env_riv_ben_v(pp,ww,ss1,ss2,ss3,ss4)
                                               +   DNPV_rec_res_ben_v(pp,ww,ss1,ss2,ss3,ss4)
                                               -  DNPV_import_costs_v(pp,ww,ss1,ss2,ss3,ss4)
                                               -  DNPV_export_costs_v(pp,ww,ss1,ss2,ss3,ss4);

DNPV_e                                    ..      DNPV_v  =e= sum((pp,ww,ss1,ss2,ss3,ss4), DNPV_ben_v(pp,ww,ss1,ss2,ss3,ss4));




* --------------------------------------------------------------------------------------
* End of total economic welfare block
* --------------------------------------------------------------------------------------


*************************************************************************************************************************************************************************
* code below constrains model to approximately replicate historical flows at 3 important basin gauges
*************************************************************************************************************************************************************************


* caballo outflow fn of San Marcial inflow and project surface storage -- regression historical gauged flows approximates project operating - 1997 - 2015
                                                                                     //pp
proj_operate_2008_LB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..  X_v('RG_Caballo_out_v_f',tlater, '1-policy_wi_2008_po',      ww,ss1,ss2,ss3,ss4)
*                                                                                     '1-policy_wi_2008_po'

                              =G=   min{875,      [0.56 * source_p('marcial_h_f',tlater,                       ww                )]     // .56708
                                                 + 0.46 *     (Z_v('store_res_s',tlater, '1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4))     // .46873
                                       };

proj_operate_2008_UB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..  X_v('RG_Caballo_out_v_f',tlater, '1-policy_wi_2008_po',      ww,ss1,ss2,ss3,ss4)
*                                                                                     '1-policy_wi_2008_po'

                              =L=   min{875,      [0.58 * source_p('marcial_h_f',tlater,                       ww                )]     // .56708
                                                 + 0.48 *     (Z_v('store_res_s',tlater, '1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4))     // .46873
                                       };

D1_LB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..   D1_v(tlater,pp,ww,ss1,ss2,ss3,ss4)  =G= [X_v('RG_caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4) - 124.0] * 0.82;    // 0.826 project deliveries
D1_UB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..   D1_v(tlater,pp,ww,ss1,ss2,ss3,ss4)  =L= [X_v('RG_caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4) - 124.0] * 0.83;    // project deliveries

D2_LB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..   D2_v(tlater,pp,ww,ss1,ss2,ss3,ss4)  =G= [X_v('RG_Caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4) -  69.0] * 1.3;    // 1.34 divertable to project users
D2_UB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..   D2_v(tlater,pp,ww,ss1,ss2,ss3,ss4)  =L= [X_v('RG_Caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4) -  69.0] * 1.4;    // 1.34 divertable to project users


US_MX_1906_LB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..                                      MX_sw_divert_v(tlater,'1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4)
                                                                      =G= min{60,       0.11 * D1_v(tlater,'1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4)
                                                                             };   // 0.113  US Mexico Treaty holds both with and without 2008 operating agreement, i.e. all values of the set p

US_MX_1906_UB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..                                      MX_sw_divert_v(tlater,'1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4)
                                                                      =L= min{60,       0.12 * D1_v(tlater,'1-policy_wi_2008_po',ww,ss1,ss2,ss3,ss4)
                                                                             };   // 0.113  US Mexico Treaty holds both with and without 2008 operating agreement, i.e. all values of the set p


* Rio Grande at El Paso is a fn of Caballo releases.  Regression coefficient matches historical actual for 1997-2015 -- with operating agreement only

nm_tx_LB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..                          X_v('RG_El_Paso_v_f',   tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)
                                                                         =G=          [D2_v(tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)
                                                                          -  MX_sw_divert_v(tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)] * 0.42;       // 0.43


nm_tx_UB_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..                          X_v('RG_El_Paso_v_f',   tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)
                                                                         =L=          [D2_v(tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)
                                                                          -  MX_sw_divert_v(tlater,'1-policy_wi_2008_po', ww,ss1,ss2,ss3,ss4)] * 0.44;       // 0.43


up_bnd_EPID_e(tlater,pp,ww,ss1,ss2,ss3,ss4)..                    X_v('RG_El_Paso_v_f',   tlater,pp,                    ww,ss1,ss2,ss3,ss4) =n=
                                                                          300;  // 300 000 af/yr is upper bound on EPID's use
*1_wo_stress
*1_wo_stress

tacres_base_l_e(aguse,j,k,tlater,ww, ss1,ss2,ss3,ss4)..         tacres_v(aguse,j,k,tlater,'1-policy_wi_2008_po',  ww,         ss1,ss2,ss3,ss4) =n= land_p(aguse,j,k,tlater);   // bounds irrigated acreage near historical observed ebid


* terminal then average aquifer protection set to original storage volume

Q_term_e(aqf,tlast,pp,ww,    ss2,ss3,ss4)..        Q_v(aqf,tlast,pp,ww,'2_wi_terminal_aqf_protection',ss2,ss3,ss4)                  =e=      Q_term_v(aqf,tlast,pp,ww,    ss2,ss3,ss4);
*Q_ave_e (aqf,      pp,ww,ss1,    ss3,ss4).. sum(t, Q_v(aqf,t,    pp,ww,ss1,'2_wi_average_aqf_protection', ss3,ss4))/card(t)         =e=      Q_ave_v (aqf,      pp,ww,ss1,    ss3,ss4);  // defines aquifer storage levels averaged over years

*************************************************************************************************************************************************************************
* end of flow constaints for historical (base) policy
*************************************************************************************************************************************************************************

* end of all equations

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

*option dnlp = minos;

*RIO_PROTOTYPE.ScaleOpt = 1;

*--------------- Section 6 -------------------------------------------------------------*
*  The following section defines all solves requested,
*  Each solve states a single model for which an optimum is requested.
*
*  Upper, lower and fixed bounds on certain variables are included here
*  Bounding variables here gives that variable a non-zero shadow price where the optimal
*  solution appears at that boundary.  If the bound doesn't constrain the model
*  the variable's shadow price is zero (complementary slackness)
*---------------------------------------------------------------------------------------*

* bounds follow.  These reflect technical, policy, or institutional requirements the limit choices of various kinds

Z_v.lo        (res,                t,p,w,s1,s2,s3,s4)   = 0.01;    // bounds storage volume away from 0. gradients are infinite at zero for nonlinear terms
surf_area_v.lo(res,                t,p,w,s1,s2,s3,s4)   = 0.01;    // bounds surface area away from 0
SWacres_v.lo  (aguse,j,k,          t,p,w,s1,s2,s3,s4)   = eps;     // bounds total surface water acres away from 0
tacres_v.lo   (aguse,j,k,          t,p,w,s1,s2,s3,s4)   = eps;     // bounds total               acres away from 0

tot_acres_v.up(aguse,              t,p,w,s1,s2,s3,s4)   = LANDRHS_p(aguse);  // upper bound on irrigable area in irrigation regions

*tacres_v.up   (aguse,'pecans',k,tlater,p,w,s1,s2,s3,s4) = 1 * land_p(aguse,'pecans',k,tlater)   + 5; // upper bound on pecan acreage
*tacres_v.lo   (aguse,'pecans',k,tlater,p,w,s1,s2,s3,s4) = 1 * land_p(aguse,'pecans',k,tlater)  * 0.50; // protect most pecan acreage regardless of cost

tacres_v.up (aguse,'pecans',k,tlater,p,w,s1,s2,s3,s4)  =  land_p(aguse,'pecans',k,tlater);    // cannot exceed historical land in prodn for any crop with falling water supplies
tacres_v.up (aguse,'veges', k,tlater,p,w,s1,s2,s3,s4)  =  land_p(aguse,'veges', k,tlater);

* end of acreage bounds

X_v.up('RG_Caballo_out_v_f', tfirst,p,w,s1,s2,s3,s4) = eps;    // no storage outflow in starting period
X_v.up(divert,               tfirst,p,w,s1,s2,s3,s4) = eps;    // no diversions or use from project storage in starting period


* pumping capacity by aquifer and use

urb_pump_v.up   (aqf,miuse,t,p,w,s1,s2,s3,s4)   =     urb_gw_pump_capacity_p(aqf,miuse);   // upper bound on urban pumping capacity by city

tot_ag_pump_v.up(aqf,aguse,t,p,w,s1,s2,s3,s4)   =      ag_gw_pump_capacity_p(aqf,aguse);   // upper bound on ag pumping by aquifer and farming area


* urban diversion treatment capacity

X_v.up          (miuse,t,p,w,s1,s2,s3,s4)       =      SW_Treat_capac_p(miuse);              // upper bound on all urban river water use from surface treatment:
                                                                                              // none for Las Cruces and Juarez, MX as of 2017.

* positive values required for all following flow variables since all are potentially nonlinear with infinite derivatives if set to zero

X_v.lo(inflow,  t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(imports, t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(exports, t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(river,   t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(divert,  t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(use,     t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(r_return,t,p,w,s1,s2,s3,s4)   = eps;
X_v.lo(a_return,t,p,w,s1,s2,s3,s4)   = eps;

D1_v.lo(        t,p,w,s1,s2,s3,s4)   = eps;
D2_v.lo(        t,p,w,s1,s2,s3,s4)   = eps;


Z_v.up(res,     t,p,w,s1,s2,s3,s4)   = 1.0                 * Zmax_p(res  );     // surface storage cannot exceed max storage capacity

Q_v.up(aqf,     t,p,w,s1,s2,s3,s4)   = 1.0                 * Qmax_p(aqf)  ;     // aquifer storage cannot exceed max storage capacity

Q_term_v.lo(aqf,tlast,p,w,  s2,s3,s4)  = pct_return_aqf_p * Q0_p(aqf);  // enforced lower bnd wo ave aqf protect


ag_back_use_v.up(aguse,j,k,t,p,w,s1,s2,s3,s4) =  20000;
ag_back_use_v.lo(aguse,j,k,t,p,w,s1,s2,s3,s4) =  0;

urb_back_use_v.up(miuse,    t,p,w,s1,s2,s3,s4) =   20000;   //  used to calc max capacity teo pay for urban backstop use when upriced
urb_back_use_v.lo(miuse,    t,p,w,s1,s2,s3,s4) =  0;   //  used to give freedom to produce at 0

Netrev_af_v.up(aguse,j,k,t,p,w,s1,s2,s3,s4) = 10000000;

Ag_av_costs_v.up(aguse, j,k,t,p,w,s1,s2,s3,s4) = 100000;


parameter

shad_price_res_p(     res,t,p,w,s1,s2,s3,s4)  defines reservoir terminal condition shadow price
shad_price_aqf_p(     aqf,t,p,w,s1,s2,s3,s4)  defines aquifers terminal condition shadow price

shad_price_aqf_ave_p( aqf,   p,w,s1,     s3,s4)  defines shadow price of protecting ave      aquifer conditions
shad_price_aqf_term_p(aqf,t, p,w,     s2,s3,s4)  defines shadow price of protecting terminal aquifer conditions

shad_price_urb_back_use_p(miuse,    t,p,w,s1,s2,s3,s4)  shad price urban backstop use
shad_price_ag_back_use_p (aguse,j,k,t,p,w,s1,s2,s3,s4)  shad price ag    backstop use

* ------------------------------ SECTION 7 ---------------------------------------------*
*                              Model Solves Follow                                      *
* --------------------------------------------------------------------------------------*

parameter mod_stat_p  (p,w,s1,s2,s3,s4);  // model optimality status
PARAMETER Iterations_p(p,w,s1,s2,s3,s4);  // iterations

* prepare to solve inside loops

*** below solves a dummy model to start hot start code

$onempty

singleton set  lpp(p)   / / , lww(w)   / /,  lss1(s1) / / ,
               lss2(s2) / / , lss3(s3) / /,  lss4(s4) / / ;

ss4(s4) = no;
ss3(s3) = no;
ss2(s2) = no;
ss1(s1) = no;
ww(w)   = no;
pp(p)   = no;

* dummy solve to get .l initialized
Solve rio_prototype using  dnlp maximizing dnpv_v ;

$offempty

*** end of dummy model

loop (p,
 loop (w,
  loop (s1,
   loop (s2,
    loop (s3,
     loop (s4,


  ss4(s4) = yes;
  ss3(s3) = yes;
  ss2(s2) = yes;
  ss1(s1) = yes;

  ww(w)   = yes;
  pp(p)   = yes;


*$ontext
************************** lists all variables ****************************************************************************



*start over


X_v.l              (i,        t,pp,ww,ss1,ss2,ss3,ss4)   =                  X_v.l            (i,        t,lpp,lww,lss1,lss2,lss3,lss4);
D1_v.l             (          t,pp,ww,ss1,ss2,ss3,ss4)   =                  D1_v.l           (          t,lpp,lww,lss1,lss2,lss3,lss4);
D2_v.l             (          t,pp,ww,ss1,ss2,ss3,ss4)   =                  D2_v.l           (          t,lpp,lww,lss1,lss2,lss3,lss4);
urb_value_v.l      (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)   =                  urb_value_v.l    (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
Urb_value_af_v.l   (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)   =                  Urb_value_af_v.l (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_m_value_v.l    (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)   =                  urb_m_value_v.l  (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_costs_v.l       (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                  Ag_costs_v.l     (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_av_costs_v.l    (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                  Ag_av_costs_v.l  (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_av_gw_costs_v.l (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                Ag_av_gw_costs_v.l (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_tot_gw_costs_v.l(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                ag_tot_gw_costs_v.l(aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_tot_sw_costs_v.l(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                ag_tot_sw_costs_v.l(aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_av_sw_costs_v.l(aguse, j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                ag_av_sw_costs_v.l(aguse, j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_tot_bt_costs_v.l(aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                ag_tot_bt_costs_v.l(aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_av_bt_costs_v.l (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                ag_av_bt_costs_v.l (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_av_rev_v.l      (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                Ag_av_rev_v.l      (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_value_v.l       (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                 Ag_value_v.l      (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Netrev_acre_v.l    (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                  Netrev_acre_v.l  (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Netrev_af_v.l      (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                  Netrev_af_v.l    (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_sw_eb_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_sw_eb_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_gw_eb_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_gw_eb_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_bt_eb_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_bt_eb_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
TNR_eb_v.l         (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 TNR_eb_v.l       (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_sw_ep_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_sw_ep_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_gw_ep_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_gw_ep_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_bt_ep_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_bt_ep_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
TNR_ep_v.l         (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 TNR_ep_v.l       (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_sw_mx_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_sw_mx_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_gw_mx_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_gw_mx_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
NR_ac_bt_mx_v.l    (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 NR_ac_bt_mx_v.l  (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
TNR_mx_v.l         (      j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 TNR_mx_v.l       (      j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_Ben_v.l       (use,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_Ben_v.l       (use,      t,lpp,lww,lss1,lss2,lss3,lss4);
T_ag_ben_v.l     (            pp,ww,ss1,ss2,ss3,ss4)      =                T_ag_ben_v.l     (            lpp,lww,lss1,lss2,lss3,lss4);
Env_ben_v.l      (river,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 Env_ben_v.l      (river,    t,lpp,lww,lss1,lss2,lss3,lss4);
rec_ben_v.l      (res,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 rec_ben_v.l      (res,      t,lpp,lww,lss1,lss2,lss3,lss4);
Tot_ag_ben_v.l     (        t,pp,ww,ss1,ss2,ss3,ss4)     =                 Tot_ag_ben_v.l     (        t,lpp,lww,lss1,lss2,lss3,lss4);
Tot_urb_ben_v.l    (        t,pp,ww,ss1,ss2,ss3,ss4)     =                 Tot_urb_ben_v.l    (        t,lpp,lww,lss1,lss2,lss3,lss4);
Tot_env_riv_ben_v.l(        t,pp,ww,ss1,ss2,ss3,ss4)     =                 Tot_env_riv_ben_v.l(        t,lpp,lww,lss1,lss2,lss3,lss4);
Tot_ben_v.l        (        t,pp,ww,ss1,ss2,ss3,ss4)     =                 Tot_ben_v.l        (        t,lpp,lww,lss1,lss2,lss3,lss4);
DNPV_ag_ben_v.l     (         pp,ww,ss1,ss2,ss3,ss4)      =                DNPV_ag_ben_v.l     (         lpp,lww,lss1,lss2,lss3,lss4);
DNPV_urb_ben_v.l    (         pp,ww,ss1,ss2,ss3,ss4)      =                DNPV_urb_ben_v.l    (         lpp,lww,lss1,lss2,lss3,lss4);
DNPV_env_riv_ben_v.l(         pp,ww,ss1,ss2,ss3,ss4)      =                DNPV_env_riv_ben_v.l(         lpp,lww,lss1,lss2,lss3,lss4);
DNPV_rec_res_ben_v.l(         pp,ww,ss1,ss2,ss3,ss4)      =                DNPV_rec_res_ben_v.l(         lpp,lww,lss1,lss2,lss3,lss4);
DNPV_ben_v.l       (          pp,ww,ss1,ss2,ss3,ss4)      =                DNPV_ben_v.l       (          lpp,lww,lss1,lss2,lss3,lss4);
Ag_m_value_v.l   (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_m_value_v.l   (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Z_v.l            (u,        t,pp,ww,ss1,ss2,ss3,ss4)     =                 Z_v.l            (u,        t,lpp,lww,lss1,lss2,lss3,lss4);
Q_v.l            (aqf,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 Q_v.l            (aqf,      t,lpp,lww,lss1,lss2,lss3,lss4);
Q_term_v.l       (aqf,t,      pp,ww,    ss2,ss3,ss4)       =               Q_term_v.l       (aqf,t,      lpp,lww,     lss2,lss3,lss4);
*Q_ave_v.l        (aqf,        pp,ww,ss1,    ss3,ss4)      =                 Q_ave_v.l        (aqf,        lpp,lww,lss1,    lss3,lss4);
aquifer_recharge_m_v.l(     t,pp,ww,ss1,ss2,ss3,ss4)     =                 aquifer_recharge_m_v.l(     t,lpp,lww,lss1,lss2,lss3,lss4);
aquifer_recharge_h_v.l(     t,pp,ww,ss1,ss2,ss3,ss4)     =                 aquifer_recharge_h_v.l(     t,lpp,lww,lss1,lss2,lss3,lss4);
Aquifer_depth_v.l(aqf,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 Aquifer_depth_v.l(aqf,      t,lpp,lww,lss1,lss2,lss3,lss4);
Evaporation_v.l  (res,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 Evaporation_v.l  (res,      t,lpp,lww,lss1,lss2,lss3,lss4);
Precip_v.l       (res,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 Precip_v.l       (res,      t,lpp,lww,lss1,lss2,lss3,lss4);
surf_area_v.l    (res,      t,pp,ww,ss1,ss2,ss3,ss4)     =                 surf_area_v.l    (res,      t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_use_v.l       (aguse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_use_v.l       (aguse,    t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_use_jk_v.l    (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_use_jk_v.l    (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_sw_use_jk_v.l (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_sw_use_jk_v.l (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_use_crop_v.l  (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 Ag_use_crop_v.l  (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_back_use_v.l  (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 ag_back_use_v.l  (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
ag_pump_v.l  (aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 ag_pump_v.l  (aqf,aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
tot_ag_pump_v.l(aqf,aguse,  t,pp,ww,ss1,ss2,ss3,ss4)     =                 tot_ag_pump_v.l(aqf,aguse,  t,lpp,lww,lss1,lss2,lss3,lss4);
sum_ag_pump_v.l  (          t,pp,ww,ss1,ss2,ss3,ss4)     =                 sum_ag_pump_v.l  (          t,lpp,lww,lss1,lss2,lss3,lss4);
sum_urb_pump_v.l (          t,pp,ww,ss1,ss2,ss3,ss4)     =                 sum_urb_pump_v.l (          t,lpp,lww,lss1,lss2,lss3,lss4);
MX_sw_divert_v.l (          t,pp,ww,ss1,ss2,ss3,ss4)     =                 MX_sw_divert_v.l (          t,lpp,lww,lss1,lss2,lss3,lss4);
Ag_pump_aq_rch_v.l(aqf,aguse,t,pp,ww,ss1,ss2,ss3,ss4)    =                Ag_pump_aq_rch_v.l(aqf,aguse,t,lpp,lww,lss1,lss2,lss3,lss4);
Aga_returns_v.l (aga_return,t,pp,ww,ss1,ss2,ss3,ss4)     =                 Aga_returns_v.l (aga_return,t,lpp,lww,lss1,lss2,lss3,lss4);
urb_pump_v.l     (aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4)    =                  urb_pump_v.l     (aqf,miuse,t,lpp,lww,lss1,lss2,lss3,lss4);
urb_use_v.l      (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)    =                  urb_use_v.l      (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_sw_use_v.l   (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)    =                  urb_sw_use_v.l   (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_gw_use_v.l   (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)    =                  urb_gw_use_v.l   (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_back_use_v.l (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)    =                  urb_back_use_v.l (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_back_aq_rch_v.l(aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4)   =               urb_back_aq_rch_v.l(aqf,miuse,t,lpp,lww,lss1,lss2,lss3,lss4);
SWacres_v.l      (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                 SWacres_v.l        (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
GWAcres_v.l      (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                 GWAcres_v.l        (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
BTacres_v.l      (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =                 BTacres_v.l        (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
gw_aq_acres_v.l(aqf,aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)   =               gw_aq_acres_v.l(aqf,aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
Tacres_v.l       (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =               Tacres_v.l         (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
tot_acres_v.l    (aguse,    t,pp,ww,ss1,ss2,ss3,ss4)     =               tot_acres_v.l    (aguse,      t,lpp,lww,lss1,lss2,lss3,lss4);
yield_v.l        (aguse,j,k,t,pp,ww,ss1,ss2,ss3,ss4)     =                 yield_v.l        (aguse,j,k,t,lpp,lww,lss1,lss2,lss3,lss4);
urb_price_v.l    (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_price_v.l    (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_con_surp_v.l (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_con_surp_v.l (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_use_p_cap_v.l(miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_use_p_cap_v.l(miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_revenue_v.l  (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_revenue_v.l  (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_gross_ben_v.l(miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_gross_ben_v.l(miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_av_gw_cost_v.l(miuse,   t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_av_gw_cost_v.l(miuse,   t,lpp,lww,lss1,lss2,lss3,lss4);
urb_costs_v.l    (miuse,    t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_costs_v.l    (miuse,    t,lpp,lww,lss1,lss2,lss3,lss4);
urb_costs_x_bs_v.l(miuse,   t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_costs_x_bs_v.l(miuse,   t,lpp,lww,lss1,lss2,lss3,lss4);
urb_av_tot_cost_v.l(miuse,  t,pp,ww,ss1,ss2,ss3,ss4)     =                 urb_av_tot_cost_v.l(miuse,  t,lpp,lww,lss1,lss2,lss3,lss4);
DNPV_v.l                                                 =                 DNPV_v.l                                                  ;


*$offtext
*****************************************************  end of variable list **********************************************

solve RIO_PROTOTYPE using dnlp maximizing DNPV_v;


mod_stat_p (p,w,s1,s2,s3,s4)   = RIO_PROTOTYPE.Modelstat + eps;

Iterations_p(p,w,s1,s2,s3,s4)  = RIO_PROTOTYPE.iterusd  + EPS;



* 1_Hist_Obs_inflows
* 2_Moderate_CStress
* 3_2011-13_Drought
* 4_Moderate_CC_Burec

*tacres_v.up     (aguse,'pecans',k,tlater,p,w,s1,s2,s3,s4)     =  tacres_v.l(aguse,'pecans',k,tlater,p,'1_Obs+Extend_Drought',s1,s2,s3,s4);
*tacres_v.up     (aguse,'veges', k,tlater,p,w,s1,s2,s3,s4)     =  tacres_v.l(aguse,'veges', k,tlater,p,'1_Obs+Extend_Drought',s1,s2,s3,s4);

tacres_v.up     (aguse,'pecans',k,tlater,p,w,s1,s2,s3,s4)     =  tacres_v.l(aguse,'pecans',k,tlater,p,'6_Zero_Flow_SMarcial',s1,s2,s3,s4);
tacres_v.up     (aguse,'veges', k,tlater,p,w,s1,s2,s3,s4)     =  tacres_v.l(aguse,'veges', k,tlater,p,'6_Zero_Flow_SMarcial',s1,s2,s3,s4);



*tacres_v.up     (aguse,'pecans',k,tlater,p,'3_wi_med_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'pecans',k,tlater,p,'1_wo_stress',s1,s2,s3,s4);
*tacres_v.up     (aguse,'veges', k,tlater,p,'3_wi_med_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'veges', k,tlater,p,'1_wo_stress',s1,s2,s3,s4);

*tacres_v.up     (aguse,'pecans',k,tlater,p,'4_wi_high_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'pecans',k,tlater,p,'1_wo_stress',s1,s2,s3,s4);
*tacres_v.up     (aguse,'veges', k,tlater,p,'4_wi_high_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'veges', k,tlater,p,'1_wo_stress',s1,s2,s3,s4);

*tacres_v.up     (aguse,'pecans',k,tlater,p,'5_wi_vhigh_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'pecans',k,tlater,p,'1_wo_stress',s1,s2,s3,s4);
*tacres_v.up     (aguse,'veges', k,tlater,p,'5_wi_vhigh_stress',s1,s2,s3,s4)     =  tacres_v.l(aguse,'veges', k,tlater,p,'1_wo_stress',s1,s2,s3,s4);




*Q_v.lo(aqf,tlast,p,w,'2_wi_terminal_aqf_protection',s2,s3,s4) = 0.98 * Q0_p(aqf);  // lower bound on terminal aquifer level

shad_price_res_p(res,tlast,p,w,s1,s2,s3,s4)                 =    Z_v.m  (res,tlast, p,w,s1,s2,s3,s4)  + eps;   // shadow prices lower bound terminal condition reservoir storage all conditions
*shad_price_aqf_p(aqf,tlast,p,w,s1,s2,s3,s4)       =    Q_v.m  (aqf,tlast, p,w,s1,s2,s3,s4)  + eps;   // shadow prices lower bound terminal condition aquifer storage all conditions

*shad_price_aqf_ave_p( aqf,      p,w,s1,    s3,s4)           =  Q_ave_v.m( aqf,      p,w,s1,   s3,s4)  + eps;
shad_price_aqf_term_p(aqf,tlast,p,w,    s2,s3,s4)           =  Q_term_v.m(aqf,tlast,p,w,   s2,s3,s4)  + eps;

shad_price_urb_back_use_p(miuse,    t,p,w,s1,s2,s3,s4)      =  urb_back_use_v.m(miuse,    t,p,w,s1,s2,s3,s4) + eps;
shad_price_ag_back_use_p (aguse,j,k,t,p,w,s1,s2,s3,s4)      =  ag_back_use_v.m (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;


lss4(s4) = yes;
lss3(s3) = yes;
lss2(s2) = yes;

lss1(s1) = yes;
lww(w)   = yes;
lpp(p)   = yes;


  pp(p)   = no;
  ww(w)   = no;

  ss1(s1) = no;
  ss2(s2) = no;
  ss3(s3) = no;
  ss4(s4) = no;

      );
     );
    );
   );
  );
 );



* ---------------------------------  section 8 ----------------------------- *
*                      post-optimality writes to spreadsheet                 *
* -------------------------------------------------------------------------- *

parameter

* land

SWacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)      surface water acreage by crop      (1000 ac \ yr)
GWacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)      groundwater acreage   by crop      (1000 ac \ yr)
BTacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)      backstop technology use            (1000 ac \ yr)
tacres_p      (aguse,j,k,t,p,w,s1,s2,s3,s4)      total acreage         by crop      (1000 ac \ yr)

gw_aq_acres_p (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4)  total groundwater acres by c a     (1000 ac \ yr)

TSWacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)      Total SW acreage                   (1000 ac \ yr)
TGWacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)      Total GW acreage                   (1000 ac \ yr)
TBTacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)      Total BT acreage                   (1000 ac \ yr)
Ttacres_p     (aguse,  k,t,p,w,s1,s2,s3,s4)      Total total acreage                (1000 ac \ yr)
tacres_err_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)      error in predicting tot acreage    (1000 ac \ yr)


* crops
Yield_opt_p    (aguse,j,k,t,p,w,s1,s2,s3,s4)     crop yield                         (tons \ ac)
yield_err_p    (aguse,j,k,t,p,w,s1,s2,s3,s4)     error in predicted crop yield      (tons \ ac)

* water stocks
wat_stocks_p     (res,    t,p,w,s1,s2,s3,s4)     stocks by pd                       (1000 af \ yr)
wat_stock0_p     (res,      p,w,s1,s2,s3,s4)     starting value                     (1000 af \ yr)
model_resid_p    (res,    t,    s1,s2,s3,s4)     model residual                     (1000 af \ yr)

gw_stocks_p     (aqf,     t,p,w,s1,s2,s3,s4)     gw aquifer stocks by pd            (1000 af by year)
gw_stocks0_p    (aqf,       p,w,s1,s2,s3,s4)     gw aquifer starting stocks         (1000 af)
Aquifer_depth_p (aqf,     t,p,w,s1,s2,s3,s4)     gw aquifer depth                   (feet by year)

aquifer_recharge_m_p(     t,p,w,s1,s2,s3,s4)     Stock: Mesilla aq rech over time   (1000 af \ yr)
aquifer_recharge_h_p(     t,p,w,s1,s2,s3,s4)     Stock: Hueco  aq rech over time    (1000 af \ yr)

* water flows

Evaporation_p   (res,      t,p,w,s1,s2,s3,s4)    total evap by period               (1000 af \ yr)
precip_p        (res,      t,p,w,s1,s2,s3,s4)    total precip by period             (1000 af \ yr)
surf_area_p     (res,      t,p,w,s1,s2,s3,s4)    total surf area by period          (1000 ac \ yr)

inflows_p       (inflow,   t,p,w,s1,s2,s3,s4)    inflows by pd                      (1000 af \ yr)
tot_inflows_p   (          t,p,w,s1,s2,s3,s4)    total inflows over nodes by pd     (1000 af \ yr)

wat_flows_p     (i,        t,p,w,s1,s2,s3,s4)    flows by pd                        (1000 af \ yr)

MX_flows_p      (divert,   t,p,w,s1,s2,s3,s4)    us mexico treaty flows             (1000 af \ yr)
river_flows_p   (river,    t,p,w,s1,s2,s3,s4)    river flows by pd                  (1000 af \ yr)
diversions_p    (divert,   t,p,w,s1,s2,s3,s4)    surface diversions                 (1000 af \ yr)
use_p           (use,      t,p,w,s1,s2,s3,s4)    surface water use                  (1000 af \ yr)
r_return_p      (r_return, t,p,w,s1,s2,s3,s4)    return flows from riv to river     (1000 af \ yr)
outflows_p      (          t,p,w,s1,s2,s3,s4)    river system outflows              (1000 af \ yr)

Ag_sw_use_jk_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag surface water use jk            (1000 af \ yr)
ag_use_jk_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)

Ag_sw_use_pp    (aguse,    t,p,w,s1,s2,s3,s4)    ag surface water use               (1000 af \ yr)
ag_sw_divert_p  (agdivert, t,p,w,s1,s2,s3,s4)    ag surface water diversions        (1000 af \ yr)

tot_ag_pump_p   (aqf,aguse,    t,p,w,s1,s2,s3,s4) total ag pumping                  (1000 af \ yr)
ag_pump_p       (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4) ag pumping                        (1000 af \ yr)

tot_ag_bt_use_p (          t,p,w,s1,s2,s3,s4)    total ag bt water use              (1000 af \ yr)
ag_bt_use_p     (aguse,    t,p,w,s1,s2,s3,s4)    ag backstop wate ruse              (1000 af \ yr)

a_div_riv_ret_p(agr_return,t,p,w,s1,s2,s3,s4)    ag river divert ret to river       (1000 af \ yr)

ag_use_p        (aguse,    t,p,w,s1,s2,s3,s4)    total ag use                       (1000 af \ yr)
ag_use_crop_p   (aguse,j,  t,p,w,s1,s2,s3,s4)    ag use by crop                     (1000 af \ yr)

sum_ag_pump_p   (          t,p,w,s1,s2,s3,s4)    sum of ag pumping over nodes       (1000 af \ yr)
sum_urb_pump_p  (          t,p,w,s1,s2,s3,s4)    sum of urban pumping over nodes    (1000 af \ yr)

a_return_p       (a_return, t,p,w,s1,s2,s3,s4)   ag return flows from riv to aq     (1000 af \ yr)

Ag_pump_aq_rch_p (aqf,aguse,t,p,w,s1,s2,s3,s4)    ag return from pumping to aquifer (1000 af \ yr)
urb_back_aq_rch_p(aqf,miuse,t,p,w,s1,s2,s3,s4)    urb return to aq from backstop t  (1000 af \ yr)

urb_use_pp      (miuse,    t,p,w,s1,s2,s3,s4)    urban water use                    (1000 af \ yr)
urb_sw_use_p    (miuse,    t,p,w,s1,s2,s3,s4)    urban surface water use            (1000 af \ yr)
urb_sw_divert_p (midivert, t,p,w,s1,s2,s3,s4)    urban surfacve water divertions    (1000 af \ yr)

urb_sw_a_ret_p (mia_return,t,p,w,s1,s2,s3,s4)    urban sw diversions return to aq   (1000 af \ yr)
urb_sw_r_ret_p( mir_return,t,p,w,s1,s2,s3,s4)    urban sw diversions return to rv   (1000 af \ yr)

urb_pump_p      (aqf,miuse,t,p,w,s1,s2,s3,s4)    urban water pumping                (1000 af \ yr)
urb_back_use_p  (miuse,    t,p,w,s1,s2,s3,s4)    urban backstop technology use      (1000 af \ yr)

tot_pumping_p   (aqf,      t,p,w,s1,s2,s3,s4)    total pumping by aquifer           (1000 af \ yr)

* economics
urb_price_pp    (miuse,    t,p,w,s1,s2,s3,s4)    urban price                        ($ per af)
urb_con_surp_p  (miuse,    t,p,w,s1,s2,s3,s4)    urban consumer surplus             ($1000 \ yr)
urb_use_p_cap_p (miuse,    t,p,w,s1,s2,s3,s4)    urban use per capita               (af \ person)
urb_revenue_p   (miuse,    t,p,w,s1,s2,s3,s4)    urban revenue                      ($1000 \ yr)
urb_gross_ben_p (miuse,    t,p,w,s1,s2,s3,s4)    urban gross econ benefit           ($1000 \ yr)
urb_costs_p     (miuse,    t,p,w,s1,s2,s3,s4)    urban costs of prodn               ($1000 \ yr)
urb_av_tot_cost_p(miuse,   t,p,w,s1,s2,s3,s4)    urban ave costs of prodn           ($ per af)

urb_costs_x_bs_p (miuse,  t,p,w,s1,s2,s3,s4)     urban total costs excl backstop    ($1000 \ yr)
urb_use_x_bs_p  (miuse,   t,p,w,s1,s2,s3,s4)     urban water use excl backstop      (1000 af \ yr
urb_av_costs_x_bs_p(miuse,t,p,w,s1,s2,s3,s4)     urban ave cost excl backstop       ($ \ af)

urb_value_p     (miuse,    t,p,w,s1,s2,s3,s4)    urban total net benefit            ($1000 \ yr)
urb_value_af_p  (miuse,    t,p,w,s1,s2,s3,s4)    urban net value per unit water     ($ \ af)
urb_m_value_p   (miuse,    t,p,w,s1,s2,s3,s4)    urban marginal value               ($ per af)

Ag_value_p        (aguse,j,k,t,p,w,s1,s2,s3,s4)  ag net benefits by crop            ($1000 \ yr)
Ag_av_gw_costs_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)  ag ave gw pump costs               ($US   \ acre)
Ag_av_sw_costs_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)  ag ave sw delivery costs           ($US   \ acre)

ag_tot_sw_costs_p (aguse,j,k,t,p,w,s1,s2,s3,s4)  ag tot sw delivery costs           ($US 1000 \ yr)
ag_tot_gw_costs_p (aguse,j,k,t,p,w,s1,s2,s3,s4)  ag tot gw pump costs               ($1000 \  yr)

Ag_av_costs_p   (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag ave costs per af                ($ \ af)
ag_costs_p      (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag total costs                     ($1000 \ yr)

Tot_ag_ben_p    (          t,p,w,s1,s2,s3,s4)    total ag benefits over districts   ($1000 \ yr)

Farm_income_sw_p(aguse,j,k,t,p,w,s1,s2,s3,s4)    farm income from surface water     ($1000 \ yr)
Farm_income_gw_p(aguse,j,k,t,p,w,s1,s2,s3,s4)    farm income from groundwater       ($1000 \ yr)
Farm_income_bt_p(aguse,j,k,t,p,w,s1,s2,s3,s4)    farm income from backstop tech     ($1000 \ yr)

Netrev_acre_pp  (aguse,j,k,t,p,w,s1,s2,s3,s4)    endogenous net ag rev per acre     ($ \ acre  )
Netrev_af_pp    (aguse,j,k,t,p,w,s1,s2,s3,s4)    endogenous net ag rev per ac-ft    ($ \ af   )

Ag_m_value_p    (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag marginal value of water         ($ \ af    )

rec_ben_p       (res,      t,p,w,s1,s2,s3,s4)    recreation benefit                 ($1000 \ yr)
env_ben_p       (river,    t,p,w,s1,s2,s3,s4)    environmental benefit from flows   ($1000 \ yr)

T_ag_ben_p      (            p,w,s1,s2,s3,s4)    total age benefits                 ($1000)
Env_ben_p       (river,    t,p,w,s1,s2,s3,s4)    Env benefits at stream gauges      ($1000 \ yr)
Tot_ben_p       (          t,p,w,s1,s2,s3,s4)    total benefits over uses           ($1000 \ yr)

Tot_urb_ben_p    (         t,p,w,s1,s2,s3,s4)    total urban net benefits           ($1000 \ yr)
Tot_env_riv_ben_p(         t,p,w,s1,s2,s3,s4)    total envir river benefits         ($1000 \ yr)
Tot_rec_res_ben_p(         t,p,w,s1,s2,s3,s4)    total rec reservoir benefits       ($1000 \ yr)

DNPV_import_costs_p(         p,w,s1,s2,s3,s4)    DNPV import costs                  ($1000 \ yr)
DNPV_export_costs_p(         p,w,s1,s2,s3,s4)    DNPV export costs                  ($1000 \ yr)

DNPV_ag_ben_p     (          p,w,s1,s2,s3,s4)    DNPV ag benefits                   ($1000)
DNPV_urb_ben_p    (          p,w,s1,s2,s3,s4)    DNPV urban benefits                ($1000)
DNPV_env_riv_ben_p(          p,w,s1,s2,s3,s4)    DNPV environmental river benefits  ($1000)
DNPV_rec_res_ben_p(          p,w,s1,s2,s3,s4)    DNPV reservoir recreation benefits ($1000)

DNPV_ben_p      (            p,w,s1,s2,s3,s4)    disc net present value of benefits ($1000)

Ag_Ben_p        (aguse,    t,p,w,s1,s2,s3,s4)    ag benefits                        ($1000 \ yr)
Ag_value_p      (aguse,j,k,t,p,w,s1,s2,s3,s4)    ag benefits by crop                ($1000 \ yr)

Q_term_shad_pr_p(aqf,      t,p,w,   s2,s3,s4)     shad price terminal aquifer level  (1000 af)
;

*stocks

*surface reservoir storage
wat_stocks_p  (res,      t,p,w,s1,s2,s3,s4)   =          Z_v.l    (res,      t,p,w,s1,s2,s3,s4)  + eps;

wat_stock0_p  (res,        p,w,s1,s2,s3,s4)   =          Z0_p     (res,        p,        s3   )  + eps;

*groundwater aquifer storage treated like a simple underground reservoir
gw_stocks_p   (aqf,      t,p,w,s1,s2,s3,s4)   =          Q_v.l    (aqf,       t,p,w,s1,s2,s3,s4)  + eps;
gw_stocks0_p  (aqf,        p,w,s1,s2,s3,s4)   =          Q0_p     (aqf                         )  + eps;



aquifer_recharge_m_p(    t,p,w,s1,s2,s3,s4)   =  aquifer_recharge_m_v.l(      t,p,w,s1,s2,s3,s4)  + eps;
aquifer_recharge_h_p(    t,p,w,s1,s2,s3,s4)   =  aquifer_recharge_h_v.l(      t,p,w,s1,s2,s3,s4)  + eps;

Aquifer_depth_p(aqf,     t,p,w,s1,s2,s3,s4)   =  Aquifer_depth_v.l(aqf,       t,p,w,s1,s2,s3,s4)  + eps;

*flows
inflows_p     (inflow,   t,p,w,s1,s2,s3,s4)   =          X_v.l    (inflow,    t,p,w,s1,s2,s3,s4)  + eps;
tot_inflows_p (          t,p,w,s1,s2,s3,s4)   =   sum(inflow, source_p(inflow,t,  w           ))  + eps;

river_flows_p (river,    t,p,w,s1,s2,s3,s4)   =          X_v.l    (river,     t,p,w,s1,s2,s3,s4)  + eps;
diversions_p  (divert,   t,p,w,s1,s2,s3,s4)   =          X_v.l    (divert,    t,p,w,s1,s2,s3,s4)  + eps;
use_p         (use,      t,p,w,s1,s2,s3,s4)   =          X_v.l    (use,       t,p,w,s1,s2,s3,s4)  + eps;
r_return_p    (r_return, t,p,w,s1,s2,s3,s4)   =          X_v.l    (r_return,  t,p,w,s1,s2,s3,s4)  + eps;

wat_flows_p   (i,        t,p,w,s1,s2,s3,s4)   =          X_v.l    (i,         t,p,w,s1,s2,s3,s4)  + eps;
MX_flows_p    ('MXID_d_f',t,p,w,s1,s2,s3,s4)  =          X_v.l   ('MXID_d_f', t,p,w,s1,s2,s3,s4)  + eps;

outflows_p    (          t,p,w,s1,s2,s3,s4)   = X_v.l   ('RG_below_EPID_v_f', t,p,w,s1,s2,s3,s4)  + eps;

urb_use_pp    (miuse,    t,p,w,s1,s2,s3,s4)   =     urb_use_v.l   (miuse,     t,p,w,s1,s2,s3,s4)  + eps;
urb_sw_use_p  (miuse,    t,p,w,s1,s2,s3,s4)   =           X_v.l   (miuse,     t,p,w,s1,s2,s3,s4)  + eps;
urb_sw_divert_p(midivert,t,p,w,s1,s2,s3,s4)   =           X_v.l   (midivert,  t,p,w,s1,s2,s3,s4)  + eps;

urb_sw_a_ret_p(mia_return,t,p,w,s1,s2,s3,s4)  =           X_v.l   (mia_return,t,p,w,s1,s2,s3,s4)  + eps;
urb_sw_r_ret_p(mir_return,t,p,w,s1,s2,s3,s4)  =           X_v.l   (mir_return,t,p,w,s1,s2,s3,s4)  + eps;

urb_pump_p    (aqf,miuse,t,p,w,s1,s2,s3,s4)   =    urb_pump_v.l   (aqf,miuse, t,p,w,s1,s2,s3,s4)  + eps;
urb_back_use_p(miuse,    t,p,w,s1,s2,s3,s4)   = urb_back_use_v.l  (miuse,     t,p,w,s1,s2,s3,s4)  + eps;   // urb use of backstop technology

ag_sw_use_pp  (aguse,    t,p,w,s1,s2,s3,s4)   =           X_v.l   (aguse,     t,p,w,s1,s2,s3,s4)  + eps;

ag_sw_divert_p(agdivert,t,p,w,s1,s2,s3,s4)   =            X_v.l   (agdivert,  t,p,w,s1,s2,s3,s4)  + eps;

tot_ag_pump_p (aqf,aguse,t,p,w,s1,s2,s3,s4)   = tot_ag_pump_v.l   (aqf,aguse, t,p,w,s1,s2,s3,s4)  + eps;

ag_pump_p     (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4) =  ag_pump_v.l    (aqf,aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

ag_use_p      (aguse,    t,p,w,s1,s2,s3,s4)   =      ag_use_v.l   (aguse,     t,p,w,s1,s2,s3,s4)  + eps;  // total ag use
ag_use_crop_p (aguse,j,  t,p,w,s1,s2,s3,s4)   =   sum(k, ag_use_crop_v.l (aguse,j,k, t,p,w,s1,s2,s3,s4))  + eps;

Ag_sw_use_jk_p(aguse,j,k,t,p,w,s1,s2,s3,s4)  = Ag_sw_use_jk_v.l(aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;
ag_use_jk_p   (aguse,j,k,t,p,w,s1,s2,s3,s4)  = ag_use_jk_v.l   (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

tot_ag_bt_use_p(         t,p,w,s1,s2,s3,s4) = sum((j,k,aguse), ag_back_use_v.l(aguse,j,k,t,p,w,s1,s2,s3,s4)) + eps;

ag_bt_use_p    (aguse,   t,p,w,s1,s2,s3,s4) = sum((j,k),       ag_back_use_v.l(aguse,j,k,t,p,w,s1,s2,s3,s4)) + eps;

sum_ag_pump_p (          t,p,w,s1,s2,s3,s4)   =  sum_ag_pump_v.l  (           t,p,w,s1,s2,s3,s4)  + eps;
sum_urb_pump_p(          t,p,w,s1,s2,s3,s4)   = sum_urb_pump_v.l  (           t,p,w,s1,s2,s3,s4)  + eps;

a_return_p     (aga_return,t,p,w,s1,s2,s3,s4)  = aga_returns_v.l   (aga_return,t,p,w,s1,s2,s3,s4) + eps;
a_div_riv_ret_p(agr_return,t,p,w,s1,s2,s3,s4)  = X_v.l             (agr_return,t,p,w,s1,s2,s3,s4) + eps;

Ag_pump_aq_rch_p( aqf,aguse,t,p,w,s1,s2,s3,s4)  = Ag_pump_aq_rch_v.l(aqf,aguse, t,p,w,s1,s2,s3,s4) + eps;
urb_back_aq_rch_p(aqf,miuse,t,p,w,s1,s2,s3,s4) = urb_back_aq_rch_v.l(aqf,miuse,t,p,w,s1,s2,s3,s4) + eps;

Tot_pumping_p(aqf,      t,p,w,s1,s2,s3,s4) = sum(aguse, tot_ag_pump_v.l(aqf,aguse,t,p,w,s1,s2,s3,s4))
                                           + sum(miuse,    urb_pump_v.l(aqf,miuse,t,p,w,s1,s2,s3,s4)) + eps;

Evaporation_p (res,     t,p,w,s1,s2,s3,s4)    =    Evaporation_v.l(res,       t,p,w,s1,s2,s3,s4)  + eps;
Precip_p      (res,     t,p,w,s1,s2,s3,s4)    =         Precip_v.l(res,       t,p,w,s1,s2,s3,s4)  + eps;

surf_area_p   (res,     t,p,w,s1,s2,s3,s4)    =     surf_area_v.l (res,       t,p,w,s1,s2,s3,s4)  + eps;

* land
SWacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)   =    SWacres_v.l    (aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;
GWacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)   =    GWacres_v.l    (aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;
BTacres_p     (aguse,j,k,t,p,w,s1,s2,s3,s4)   =    BTacres_v.l    (aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;

gw_aq_acres_p(aqf,aguse,j,k,t,p,w,s1,s2,s3,s4) =  gw_aq_acres_v.l(aqf,aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;


tacres_p      (aguse,j,k,t,p,w,s1,s2,s3,s4)   =    tacres_v.l     (aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;
tacres_err_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)   =    tacres_v.l     (aguse, j,k,t,p,w,s1,s2,s3,s4)
                                                -  land_p         (aguse, j,k,t                )  + eps;    // error in baseline predicted acreage

TSWacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)   =   sum(j, SWacres_p(aguse, j,k,t,p,w,s1,s2,s3,s4)) + eps;
TGWacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)   =   sum(j, GWacres_p(aguse, j,k,t,p,w,s1,s2,s3,s4)) + eps;
TBTacres_p    (aguse,  k,t,p,w,s1,s2,s3,s4)   =   sum(j, BTacres_p(aguse, j,k,t,p,w,s1,s2,s3,s4)) + eps;

Ttacres_p     (aguse,  k,t,p,w,s1,s2,s3,s4)   =   sum(j,  tacres_p(aguse, j,k,t,p,w,s1,s2,s3,s4)) + eps;

* crops
Yield_opt_p   (aguse,j,k,t,p,w,s1,s2,s3,s4)   =         Yield_v.l (aguse,j,k,t,p, w,s1,s2,s3,s4)  + eps;
yield_err_p   (aguse,j,k,t,p,w,s1,s2,s3,s4)   =         Yield_v.l (aguse,j,k,t,p, w,s1,s2,s3,s4)
                                                      - yield_p   (aguse,j,k                   )  + eps;

* urban benefits and related

urb_price_pp   (miuse,   tlater,p,w,s1,s2,s3,s4) =  urb_price_v.l   (miuse,  tlater,p,w,s1,s2,s3,s4)  + eps;
urb_con_surp_p (miuse,   t,p,w,s1,s2,s3,s4)   =    urb_con_surp_v.l (miuse,  t,p,w,s1,s2,s3,s4)  + eps;
urb_use_p_cap_p(miuse,   t,p,w,s1,s2,s3,s4)   =    urb_use_p_cap_v.l(miuse,  t,p,w,s1,s2,s3,s4)  + eps;
urb_revenue_p  (miuse,   t,p,w,s1,s2,s3,s4)   =    urb_revenue_v.l  (miuse,  t,p,w,s1,s2,s3,s4)  + eps;
urb_gross_ben_p(miuse,   t,p,w,s1,s2,s3,s4)   =    urb_gross_ben_v.l(miuse,  t,p,w,s1,s2,s3,s4)  + eps;
urb_costs_p    (miuse,   t,p,w,s1,s2,s3,s4)   =    urb_costs_v.l    (miuse,  t,p,w,s1,s2,s3,s4)  + eps;
urb_av_tot_cost_p(miuse, t,p,w,s1,s2,s3,s4)   =  urb_av_tot_cost_v.l(miuse,  t,p,w,s1,s2,s3,s4)  + eps;

urb_use_x_bs_p (miuse,   t,p,w,s1,s2,s3,s4)   =  urb_use_v.l     (miuse,t,p,w,s1,s2,s3,s4)
                                               - urb_back_use_v.l(miuse,t,p,w,s1,s2,s3,s4)       + eps;

urb_costs_x_bs_p(miuse,  t,p,w,s1,s2,s3,s4)   =   urb_costs_x_bs_v.l(miuse,  t,p,w,s1,s2,s3,s4) + eps;

urb_av_costs_x_bs_p(miuse,t,p,w,s1,s2,s3,s4)  =   (.001 + urb_costs_x_bs_p(miuse,t,p,w,s1,s2,s3,s4)) /
                                                  (.001 +   urb_use_x_bs_p(miuse,t,p,w,s1,s2,s3,s4)) + eps;

urb_value_p    (miuse,   t,p,w,s1,s2,s3,s4)   =    urb_value_v.l    (miuse,  t,p,w,s1,s2,s3,s4)  + eps;

urb_value_af_p (miuse,   t,p,w,s1,s2,s3,s4)   =    urb_value_af_v.l (miuse,  t,p,w,s1,s2,s3,s4)  + eps;

urb_m_value_p  (miuse,   t,p,w,s1,s2,s3,s4)   =  urb_m_value_v.l    (miuse,  t,p,w,s1,s2,s3,s4)  + eps;

* ag benefits and related

ag_costs_p        (aguse,j,k,t,p,w,s1,s2,s3,s4) =      ag_costs_v.l  (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;
Ag_av_costs_p     (aguse,j,k,t,p,w,s1,s2,s3,s4) =   Ag_av_costs_v.l  (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

ag_av_sw_costs_p  (aguse,j,k,t,p,w,s1,s2,s3,s4) =    Ag_av_sw_costs_v.l  (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;
Ag_av_gw_costs_p  (aguse,j,k,t,p,w,s1,s2,s3,s4) =    Ag_av_gw_costs_v.l  (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

ag_tot_sw_costs_p (aguse,j,k,t,p,w,s1,s2,s3,s4) =   ag_tot_sw_costs_v.l (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;
ag_tot_gw_costs_p (aguse,j,k,t,p,w,s1,s2,s3,s4) =   ag_tot_gw_costs_v.l (aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

Netrev_acre_pp(aguse,j,k,t,p,w,s1,s2,s3,s4)  =    Netrev_acre_v.l(aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;

Netrev_af_pp  (aguse,j,k,t,p,w,s1,s2,s3,s4)  =    Netrev_af_v.l  (aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;

Ag_Ben_p    (aguse,    t,p,w,s1,s2,s3,s4)   =        Ag_Ben_v.l  (aguse,     t,p,w,s1,s2,s3,s4)  + eps;

t_ag_ben_p  (            p,w,s1,s2,s3,s4)   =        t_ag_ben_v.l(             p,w,s1,s2,s3,s4)  + eps;

Tot_ag_ben_p(          t,p,w,s1,s2,s3,s4)   =       Tot_ag_ben_v.l(          t,p,w,s1,s2,s3,s4)  + eps;

Ag_m_value_p(aguse,j,k,t,p,w,s1,s2,s3,s4)   =      Ag_m_value_v.l(aguse, j,k,t,p,w,s1,s2,s3,s4)  + eps;

* environmental benefits from streamflow

Env_ben_p('RG_below_EPID_v_f',t,p,w,s1,s2,s3,s4) = Env_ben_v.l('RG_below_EPID_v_f', t,p,w,s1,s2,s3,s4)  + eps;

*  rec benefits from reservoir storage

rec_ben_p   (res,      t,p,w,s1,s2,s3,s4)   =          rec_ben_v.l(res,      t,p,w,s1,s2,s3,s4)  + eps;

* total benefits by use category

Tot_ag_ben_p     (t,p,w,s1,s2,s3,s4)        =        Tot_ag_ben_v.l     (t,p,w,s1,s2,s3,s4)      + eps;
Tot_urb_ben_p    (t,p,w,s1,s2,s3,s4)        =        Tot_urb_ben_v.l    (t,p,w,s1,s2,s3,s4)      + eps;
Tot_env_riv_ben_p(t,p,w,s1,s2,s3,s4)        =        Tot_env_riv_ben_v.l(t,p,w,s1,s2,s3,s4)      + eps;
Tot_rec_res_ben_p(t,p,w,s1,s2,s3,s4)        =        Tot_rec_res_ben_v.l(t,p,w,s1,s2,s3,s4)      + eps;

Tot_ben_p        (t,p,w,s1,s2,s3,s4)        =                Tot_ben_v.l(t,p,w,s1,s2,s3,s4)      + eps;

DNPV_import_costs_p(p,w,s1,s2,s3,s4)        =        DNPV_import_costs_v.l(p,w,s1,s2,s3,s4)      + eps;
DNPV_export_costs_p(p,w,s1,s2,s3,s4)        =        DNPV_export_costs_v.l(p,w,s1,s2,s3,s4)      + eps;

DNPV_ag_ben_p     ( p,w,s1,s2,s3,s4)        =            DNPV_ag_ben_v.l(  p,w,s1,s2,s3,s4)       + eps;
DNPV_urb_ben_p    ( p,w,s1,s2,s3,s4)        =           DNPV_urb_ben_v.l(  p,w,s1,s2,s3,s4)       + eps;
DNPV_env_riv_ben_p( p,w,s1,s2,s3,s4)        =       DNPV_env_riv_ben_v.l(  p,w,s1,s2,s3,s4)       + eps;
DNPV_rec_res_ben_p( p,w,s1,s2,s3,s4)        =       DNPV_rec_res_ben_v.l(  p,w,s1,s2,s3,s4)       + eps;

DNPV_ben_p        ( p,w,s1,s2,s3,s4)        =               DNPV_ben_v.l(  p,w,s1,s2,s3,s4)       + eps;


Ag_value_p  (aguse,j,k,t,p,w,s1,s2,s3,s4)   =        Ag_value_v.l(aguse, j,k,t,p,w,s1,s2,s3,s4)   + eps;
Ag_Ben_p    (aguse,    t,p,w,s1,s2,s3,s4)   =          Ag_Ben_v.l(aguse,     t,p,w,s1,s2,s3,s4)   + eps;


*ag income from various water sources


Farm_income_sw_p(aguse,j,k,t,p,w,s1,s2,s3,s4) =
                                                          price_p     (aguse,j)
                                                        * Yield_v.l   (aguse,j,k,t,p,w,s1,s2,s3,s4)
                                                        * SWacres_v.l (aguse,j,k,t,p,w,s1,s2,s3,s4)

                                                 - ag_tot_sw_costs_v.l(aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

Farm_income_gw_p(aguse,j,k,t,p,w,s1,s2,s3,s4)  =
                                                          price_p     (aguse,j)
                                                        * Yield_v.l   (aguse,j,k,t,p,w,s1,s2,s3,s4)
                                                        * GWacres_v.l (aguse,j,k,t,p,w,s1,s2,s3,s4)

                                                - ag_tot_gw_costs_v.l( aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;

Farm_income_bt_p(aguse,j,k,t,p,w,s1,s2,s3,s4) =
                                                          price_p     (aguse,j)
                                                         * Yield_v.l  (aguse,j,k,t,p,w,s1,s2,s3,s4)
                                                         * BTacres_v.l(aguse,j,k,t,p,w,s1,s2,s3,s4)

                                                 - ag_tot_bt_costs_v.l( aguse,j,k,t,p,w,s1,s2,s3,s4) + eps;


Q_term_shad_pr_p (aqf,  tlast,p,w,   s2,s3,s4)   =  Q_term_v.m       (aqf,  tlast,p,w,   s2,s3,s4)   + eps;


execute_unload "rgr_watershed_bucket_jan_27_2019_830pm.gdx"

Evap_rate_p,  B1_area_vol_p,     Z0_p
wat_flows_p,  wat_stocks_p,      wat_stock0_p,             river_flows_p,   inflows_p,       t_ag_ben_p,
diversions_p, SWacres_p,         GWacres_p,                use_p, r_return_p, pop_p,        price_p, cost_p, netrev_acre_p,
yield_p,      land_p,            urb_price_pp,             urb_con_surp_p,  urb_use_p_cap_p, ag_value_p,
ag_ben_p,     ag_m_value_p,      t_ag_ben_p,               yield_opt_p,     Ba_use_p
urb_av_cost_p, elast_p,          tx_proj_op_p              ag_sw_use_pp     urb_pump_p,      urb_sw_use_p,
recharge_p,   urb_revenue_p,     urb_gross_ben_p,          urb_costs_p,     urb_value_p,     urb_value_af_p,
urb_use_pp,   urb_m_value_p,     zmax_p Evaporation_p,     surf_area_p
env_ben_p,    tot_ben_p,         dnpv_ben_p, us_mx_1906_p, sw_sustain_p,    gw_sustain_p,    rec_ben_p, env_ben_p, tot_ag_pump_p,
gw_stocks_p,  gw_stocks0_p       urb_gw_pump_capacity_p    gw_stocks0_p     qmax_p
urb_av_gw_cost_p ag_av_gw_cost_p urb_gw_pump_capacity_p    ag_gw_pump_capacity_p
landrhs_p     aquifer_depth_p    porosity_p,     qmax_p,   q0_p,            aq_area_p,       a_return_p, Ag_pump_aq_rch_p,
z_p           xv_lb_p,           xv_ub_p, gaugeflow_p,     model_resid_p,   precip_p
residdd_p     tacres_p           TSWacres_p                TGWacres_p       Ttacres_p        precip_rate_p
source_p      rho_pop_p          urb_back_use_p            urb_back_aq_rch_p  sum_ag_pump_p  sum_urb_pump_p     MX_flows_p    tot_inflows_p
tot_ag_ben_p  tot_urb_ben_p      tot_env_riv_ben_p         tot_rec_res_ben_p                urb_av_back_cost_p
cost_af_unit_depth_p             mod_stat_p                disc_factr_p     rho_p
Ag_av_gw_costs_p                 Netrev_acre_pp            land_p           yield_err_p      tacres_err_p
ag_sw_divert_p                   urb_sw_divert_p           SW_Treat_capac_p urb_av_tot_cost_p
BTacres_p       TBTacres_p       tot_ag_bt_use_p           Ag_av_costs_p
urb_use_x_bs_p  urb_costs_x_bs_p urb_av_costs_x_bs_p       shad_price_res_p shad_price_aqf_p
Tot_pumping_p   outflows_p       Iterations_p              ag_use_p         ag_bt_use_p     ag_av_back_cost_p
DNPV_ag_ben_p   DNPV_urb_ben_p   DNPV_env_riv_ben_p        DNPV_rec_res_ben_p               a_div_riv_ret_p
urb_sw_a_ret_p  urb_sw_r_ret_p   ag_pump_p                 ag_use_crop_p                    ag_costs_p
gw_aq_acres_p   Ag_av_gw_costs_p  ag_tot_gw_costs_p        ag_av_sw_costs_p                 ag_tot_sw_costs_p
aquifer_recharge_m_p              aquifer_recharge_h_p
Farm_income_sw_p Farm_income_gw_p Farm_income_bt_p         Ag_sw_use_jk_p    ag_use_jk_p    Netrev_af_pp     netrev_af_p    Q_term_shad_pr_p
shad_price_urb_back_use_p  shad_price_ag_back_use_p        DNPV_import_costs_p  DNPV_export_costs_p

$onecho > gdxxrwout.txt

i=rgr_watershed_bucket_jan_27_2019_830pm.gdx
o=rgr_watershed_bucket_jan_27_2019_830pm.xlsx

epsout = 0

*----------------------------------------------------------------------*
* DATA READ AND USED BY RIO GRANDE BASIN MODEL
*----------------------------------------------------------------------*

par = mod_stat_p             rng = model_stat!c4               cdim = 0
par = Iterations_p           rng = iterations!c4               cdim = 0

* institutional constraints

par = us_mx_1906_p           rng = data_us_mx_1906_flows!c4    cdim = 0
par = tx_proj_op_p           rng = data_tx_project_op!c4       cdim = 0
par = sw_sustain_p           rng = data_sw_sustainability!c4   cdim = 0
par = gw_sustain_p           rng = data_gw_sustainability!c4   cdim = 0

* technical constraints

par = urb_gw_pump_capacity_p rng = data_urb_pump_capacity!c4   cdim = 0
par = ag_gw_pump_capacity_p  rng = data_ag_pump_capacity!c4    cdim = 0

* hydrology data

par = source_p               rng =  data_sources!c4             cdim = 0
par = evap_rate_p            rng =  data_evaporation_flux!c4    cdim = 0
par = porosity_p             rng =  data_aq_porosity!c4         cdim = 0
par = qmax_p                 rng =  data_max_aq_capacity!c4     cdim = 0
par = q0_p                   rng =  data_starting_aq_store!c4   cdim = 0
par = aq_area_p              rng =  data_aquifer_area!c4        cdim = 0

par = recharge_p             rng =  data_aquifer_recharge!c4   cdim = 0
par = inflows_p              rng =  data_basin_inflows!c4      cdim = 0

par = z_p                    rng =  data_res_storage!c4        cdim = 0
par = gaugeflow_p            rng =  data_gauged_flows!c4       cdim = 0

par = tot_inflows_p          rng =  data_total_inflows!c4      cdim = 0

par = xv_lb_p                rng =  data_cab_flow_lo_bound!c4  cdim = 0
par = xv_ub_p                rng =  data_cab_flow_up_bound!c4  cdim = 0

par = wat_stock0_p           rng =  data_start__storage!c4     cdim = 0

par = gw_stocks0_p           rng =  data_start_gw_stocks!c4    cdim = 0
par = qmax_p                 rng =  data_max_aqf_capac!c4      cdim = 0

par = Evap_rate_p            rng =  data_evap_rate_ft_yr!c4    cdim = 0
par = precip_rate_p          rng =  data_precip_rate_ft_yr!c4  cdim = 0
par = B1_area_vol_p          rng =  data_acre_per_af!c4        cdim = 0
par = Zmax_p                 rng =  data_store_capacity!c4     cdim = 0

* crop data
par = yield_p                rng =  data_yield!c4              cdim = 0
par = landrhs_p              rng =  data_ag_land_limit!c4      cdim = 0
par = land_p                 rng =  data_ag_land!c4            cdim = 0

* crop water data

par = Ba_use_p               rng =  data_wat_use_acre!c4       cdim = 0

* urban data
par = pop_p                  rng =  data_population!c4         cdim = 0
par = rho_pop_p              rng =  data_pop_growth_rate!c4    cdim = 0
par = SW_Treat_capac_p       rng =  data_sw_treat_capacity!c4  cdim = 0

* economic data
par = Price_p                rng =  data_price!c4              cdim = 0
par = cost_p                 rng =  data_cost!c4               cdim = 0

par = netrev_acre_p          rng =  data_netrev_acre!c4        cdim = 0
par = netrev_af_p            rng =  data_netrev_af!c4          cdim = 0

par = urb_av_cost_p          rng =  data_urb_av_cost!c4        cdim = 0
par = urb_av_gw_cost_p       rng =  data_urb_av_gw_cost!c4     cdim = 0
par = ag_av_gw_cost_p        rng =  data_ag_av_gw_cost!c4      cdim = 0
par = cost_af_unit_depth_p   rng =  data_cost_af_un_depth!c4   cdim = 0

par = urb_av_back_cost_p     rng =  data_urb_av_back_cost!c4   cdim = 0
par = ag_av_back_cost_p      rng =  data_ag_av_back_cost!c4    cdim = 0

par = disc_factr_p           rng =  data_discount_factor!c4    cdim = 0

par = rho_p                  rng =  data_discount_rate!c4      cdim = 0

par = elast_p                rng =  data_urb_price_elast!c4    cdim = 0


*------------------ END OF DATA READ BY MODEL --------------------------*

*-----------------------------------------------------------------------*
* MODEL-OPTIMIZED RESULTS FROM RIO GRANDE BASIN MODEL
*------------------------------------------------------------------------

* land block

par = SWacres_p              rng =  opt_sw_acreage!c4          cdim = 0
par = GWacres_p              rng =  opt_gw_acreage!c4          cdim = 0
par = BTacres_p              rng =  opt_bt_acreage!c4          cdim = 0
par = gw_aq_acres_p          rng =  opt_gw_ac_by_cr_aq!c4      cdim = 0

par = tacres_p               rng =  opt_tot_acreage!c4         cdim = 0
par = tacres_err_p           rng =  opt_acreage_error!c4       cdim = 0

par = TSWacres_p             rng =  opt_tot_sw_acreage!c4      cdim = 0
par = TGWacres_p             rng =  opt_tot_gw_acreage!c4      cdim = 0
par = TBTacres_p             rng =  opt_tot_bt_acreage!c4      cdim = 0

par = Ttacres_p              rng =  opt_tot_t_acreage!c4       cdim = 0

* crop block

par = yield_opt_p            rng = opt_yield!c4                cdim = 0
par = yield_err_p            rng = opt_yield_error!c4          cdim = 0

*hydrology block

par = Evaporation_p          rng  = opt_evaporation!c4         cdim = 0
par = precip_p               rng  = opt_precip!c4              cdim = 0
par = surf_area_p            rng  = opt_surf_area!c4           cdim = 0

*par = model_resid_p          rng  = residual!c4                cdim = 0
*par = residdd_p              rng  = residual1!c4               cdim = 0

par = wat_flows_p            rng =  opt_water_flows!c4         cdim = 0
par = river_flows_p          rng =  opt_river_flows!c4         cdim = 0
par = outflows_p             rng =  opt_outflows!c4            cdim = 0
par = MX_flows_p             rng =  opt_US_MX_treaty!c4        cdim = 0

par = diversions_p           rng =  opt_diversions!c4          cdim = 0
par = use_p                  rng =  opt_use!c4                 cdim = 0
par = r_return_p             rng =  opt_riv_return!c4          cdim = 0

par = Ag_sw_use_jk_p         rng =  opt_ag_jk_sw_use!c4        cdim = 0
par = ag_use_jk_p            rng =  opt_ag_jk_total_use!c4     cdim = 0

par = ag_sw_use_pp           rng =  opt_ag_sw_use!c4           cdim = 0
par = ag_sw_divert_p         rng =  opt_ag_sw_divert!c4        cdim = 0

par = a_div_riv_ret_p        rng =  opt_ag_sw_div_r_ret!c4     cdim = 0

par = urb_use_pp             rng =  opt_urban_tot_use!c4       cdim = 0
par = urb_sw_use_p           rng =  opt_urb_sw_use!c4          cdim = 0
par = urb_sw_divert_p        rng =  opt_urb_sw_divert!c4       cdim = 0

par = urb_sw_a_ret_p         rng =  opt_urb_div_aqf_ret!c4     cdim = 0
par = urb_sw_r_ret_p         rng =  opt_urb_div_riv_ret!c4     cdim = 0

par = urb_pump_p             rng =  opt_urban_pumping!c4       cdim = 0
par = urb_back_use_p         rng =  opt_urban_back_use!c4      cdim = 0

par = tot_ag_pump_p          rng =  opt_ag_pumping!c4          cdim = 0

par = tot_ag_bt_use_p        rng =  opt_ag_bt_use!c4           cdim = 0
par = ag_bt_use_p            rng =  opt_ag_backstop_use!c4     cdim = 0

par = ag_use_p               rng =  opt_ag_use!c4              cdim = 0
par = ag_use_crop_p          rng =  opt_ag_use_crop!c4         cdim = 0

par = ag_pump_p              rng =  opt_ag_pump_crop!c4        cdim = 0
par = sum_ag_pump_p          rng =  opt_sum_ag_pumping!c4      cdim = 0
par = sum_urb_pump_p         rng =  opt_sum_urb_pumping!c4     cdim = 0

par = Ag_pump_aq_rch_p       rng =  opt_ag_pump_aq_rch!c4      cdim = 0
par = a_return_p             rng =  opt_ag_riv_aq_rch!c4       cdim = 0
par = urb_back_aq_rch_p      rng =  opt_urb_back_aq_rch!c4     cdim = 0

par = wat_stocks_p           rng =  opt_water_stocks!c4        cdim = 0
par = gw_stocks_p            rng =  opt_gw_stocks!c4           cdim = 0

par = Q_term_shad_pr_p       rng =  opt_shad_pr_term_aqf!c4    cdim = 0

par = aquifer_recharge_m_p   rng =  opt_mesl_aqf_rech!c4       cdim = 0
par = aquifer_recharge_h_p   rng =  opt_huec_aqf_rech!c4       cdim = 0

par = aquifer_depth_p        rng =  opt_aquifer_depth!c4       cdim = 0
par = tot_pumping_p          rng =  opt_tot_pumping!c4         cdim = 0


* urban water use and related block

par = urb_price_pp           rng =  opt_urban_price!c4         cdim = 0
par = urb_con_surp_p         rng =  opt_urban_cons_surp!c4     cdim = 0
par = urb_use_p_cap_p        rng =  opt_urb_use_per_cap!c4     cdim = 0
par = urb_revenue_p          rng =  opt_urb_gross_revenue!c4   cdim = 0
par = urb_gross_ben_p        rng =  opt_urb_tot_gross_ben!c4   cdim = 0
par = urb_costs_p            rng =  opt_urban_tot_costs!c4     cdim = 0
par = urb_av_tot_cost_p      rng =  opt_urb_av_tot_cost!c4     cdim = 0

par = urb_av_costs_x_bs_p    rng =  opt_urb_av_costs_x_bs!c4   cdim = 0

par = urb_value_p            rng =  opt_urban_tot_net_ben!c4   cdim = 0

par = urb_value_af_p         rng =  opt_urban_net_ben_af!c4    cdim = 0

par = urb_m_value_p          rng =  opt_urban_marg_benefit!c4  cdim = 0

* economic benefits block


par = ag_costs_p            rng  =  opt_ag_costs_by_crop!c4    cdim = 0

par = Ag_av_costs_p         rng  = opt_ag_av_cs_by_crop!c4     cdim = 0

par = Ag_m_value_p          rng  =  opt_ag_marg_value!c4       cdim = 0
par = Netrev_acre_pp        rng  =  opt_net_rev_acre!c4        cdim = 0
par = Netrev_af_pp          rng  =  opt_net_rev_af!c4          cdim = 0

*par = t_ag_ben_p           rng  =  opt_tot_ag_benefits!c4     cdim = 0

par = env_ben_p             rng  =  opt_env_river_benefit!c4   cdim = 0
par = rec_ben_p             rng  =  opt_rec_benefit!c4         cdim = 0

par = Ag_av_gw_costs_p      rng  =  opt_ag_av_gw_costs!c4      cdim = 0
par = ag_tot_gw_costs_p     rng  =  opt_ag_tot_gw_costs!c4     cdim = 0

par = ag_av_sw_costs_p      rng  =  opt_ag_av_sw_costs!c4      cdim = 0
par = ag_tot_sw_costs_p     rng  =  opt_ag_tot_sw_costs!c4     cdim = 0

par = Tot_ag_ben_p          rng  =  opt_sum_ag_benefits!c4     cdim = 0
par = Tot_urb_ben_p         rng  =  opt_tot_urb_ben!c4         cdim = 0
par = Tot_env_riv_ben_p     rng  =  opt_tot_env_riv_ben!c4     cdim = 0
par = Tot_rec_res_ben_p     rng  =  opt_tot_rec_res_ben!c4     cdim = 0

par = tot_ben_p             rng  =  opt_tot_benefit!c4         cdim = 0

par = DNPV_import_costs_p   rng  =  opt_DNPV_imp_costs!c4      cdim = 0
par = DNPV_export_costs_p   rng  =  opt_DNPV_exp_costs!c4      cdim = 0

par = DNPV_ag_ben_p         rng  =  opt_DNPV_ag_ben!c4         cdim = 0
par = DNPV_urb_ben_p        rng  =  opt_DNPV_urb_ben!c4        cdim = 0
par = DNPV_env_riv_ben_p    rng  =  opt_DNPV_env_riv_ben!c4    cdim = 0
par = DNPV_rec_res_ben_p    rng  =  opt_DNPV_rec_res_ben!c4    cdim = 0

par = dnpv_ben_p            rng  =  opt_dnpv_benefit!c4        cdim = 0

par = Ag_value_p            rng  =  opt_ag_ben_by_crop!c4      cdim = 0

par = shad_price_urb_back_use_p rng = opt_shad_p_urb_b_use!c4  cdim = 0
par = shad_price_ag_back_use_p  rng = opt_shad_p_ag_b_use!c4   cdim = 0

par = Farm_income_sw_p      rng  =  opt_farm_inc_sw!c4         cdim = 0
par = Farm_income_gw_p      rng  =  opt_farm_inc_gw!c4         cdim = 0
par = Farm_income_bt_p      rng  =  opt_farm_inc_bt!c4         cdim = 0

par = Ag_Ben_p              rng  =  opt_ag_ben!c4              cdim = 0

*shadow prices

par = Q_term_shad_pr_p      rng  = opt_term_aqf_shad_price!c4    cdim = 0
par = shad_price_res_p      rng  = opt_res_term_shad_price!c4  cdim = 0


*----------------------* end of model optimized results *----------------*

$offecho
execute 'gdxxrw.exe @gdxxrwout.txt trace=2';

*------------------------The End ----------------------------------------*













