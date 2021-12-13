$EOLCOM //
$TITLE RIO GRANDE BASIN HYDROECONOMIC PROTOTYPE
$OFFSYMXREF OFFSYMLIST OnLISTING OFFUPPER

OPTION LIMROW   = 200, LIMCOL = 0;
*option  ITERLIM = 1000000;
*option reslim   =  100000;


$ONTEXT


July 1 2021. Model version for offline execution aligned with SWIM 2.4.5

*---------------------------------------------------------------------------------------------------------------------------------------------------------

Nov 11 2019. Keeping only one default water supply scenario, other water supply inflows will be loaded externally from user interface.
             The default is Observed Inflows + Extended drought  - LGC

* ----------------------------------------------------------------------------------------------------------------------------------------------------------

* jan 30 2019

ag use still increasing in some cases with aquifer protection compared to without, esp ebid and epid.

Need to find the error here.

Increased aquifer protection should limit pumping and reduce total use, and should certainly reduce gw use.

* fixed policy1 and policy2 appearing 2 sequential lines for listing
* running nlp, need to revert to dnlp

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

19  Jan 30 2019  Returns both aquifers and reservoir to starting levels.  With and without 2008 operating agreement set equal
                 Ag water use should be lower when returning reservoirs and aquifers to starting levels.  Still not so.

* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------


* CONTACTS

  Frank A. Ward:
  Dept of Agr Economics/Agr Business
  New Mexico State University, Las Cruces, NM USA
  e-mail: fward@nmsu.edu

* Alex Mayer
  University of Texas at El Paso
  amayer2@utep.edu


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


/
  1_Selected_Inflows
/

$ontext

1.        1_Selected_Inflows:  Selected Inflows from the
          SWIM 2.0 user interface.


$offtext

scalar tStartOffset  /1/; //offset of years after initial   --LG 3/14/18     (1995)  1+x
scalar tElements /40/;   //end year --LG 3/14/18 (2033)      --40-x

SETS

*---------------------------------------------------------------------------------------*
n    Iteration varible for environental flow scheduling
*---------------------------------------------------------------------------------------*

/ 1*20 /


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
      environmental_crop
/


*----------------------------------------------------------------------------------------
k     irrigation technology - one for now - but opens slot for several
*----------------------------------------------------------------------------------------

/     flood

/
;

SETS

*----------------------------------------------------------------------------------------
t     time - years
*----------------------------------------------------------------------------------------

/     1994 * 2033        39 years - expandable
/


tfirst(t)            starting year
tlast(t)             terminal year
tlater(t)            all years after initial
tpost2008(t)         years after 2008
lagtlater(t)         lagged years after first
;

tfirst(t)    = yes $ (ord(t) eq tStartOffset);        // 1st year     //original 1  result: 1994
tlast(t)     = yes $ (ord(t) eq tElements);  // GAMS language -- picks last pd   //result  :2033
tlater(t)    = yes $ (ord(t) gt tStartOffset and ord(t) lt tElements+1);        // picks years after 1     //original 1 //result: 1994-2033
tpost2008(t) = yes $ (ord(t) gt 13 and ord(t) lt tElements+1);
lagtlater(t) = yes $ (ord(t) gt 0);     // 1994 - 2070

alias (tfirst, ttfirst);

**************** Section 1B *************************************************************
*  This section loads some of the parameters dynamically
*  Currently loading only user defined type parameters                                  *
*  1.  Scalars (single numbers),                                                        *
*  2.  Parameters (columns of numbers) or                                               *
*  3.  Tables (data in rows and columns)                                                *
*****************************************************************************************

* Loading of data externally for SWIM

$ontext

singleton sets
p2(p)
w2(w);

scalar
chooser
sw_sustain_p
tStartOffset
tElements;

parameter
gw_sustain_p(aqf)
Yield_p(aguse,j,k)
Price_p(aguse,j)
urb_cost_grow_p(miuse)
urb_gw_cost_grow_p(miuse)
urb_back_cost_grow_p(miuse)
urb_av_back_cost0_p(miuse)
ag_av_back_cost0_p(aguse)
ag_back_cost_grow_p(aguse)
rho_pop_p(miuse)
san_mar_in(t);

* $if not set gdxincname $abort 'no include file name for data file provided'
* $gdxin %gdxincname%
* $loaddc chooser, sw_sustain_p, gw_sustain_p, Yield_p, Price_p, urb_cost_grow_p, urb_gw_cost_grow_p, urb_av_back_cost0_p, urb_back_cost_grow_p, ag_av_back_cost0_p, ag_back_cost_grow_p, rho_pop_p, p2, w2, tStartOffset, tElements, san_mar_in
* $gdxin

$offtext

// display lagtlater, tlast;


ALIAS (river, riverp);  // river nodes wear multiple hats

// display tfirst, tlast, tlater, agdivert;

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


//display ID_adu_p, ID_arr_p, ID_ara_p, ID_mdu_p, ID_mrru_p, ID_mrau_p, ID_adara_p
//        ID_adau_p, ID_adarr_p, ID_adaar_p;


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
parameter rho_p discount rate /0.05/
;
parameter disc_factr_p(t)  discount factor
;
disc_factr_p(t) = 1/[(1+rho_p) ** (ord(t) - 1)];

* display disc_factr_p;


*----------------------------------------------------------------------------------------
* agriculture parameters
*----------------------------------------------------------------------------------------
* Map #3:

* Defines use (simplistically) as a percentage of diversion
* X(use) = Bdu * X(divert)
* These B coeffs are shown below as the matrix, Bu

*---------------------------------------------------------------------------------------

parameter backstop_cost_p   /3000/

* display backstop_cost_p;


Table   Yield_p(aguse,j,k)   Crop Yield (tons per acre)

                  Pecans.flood    Veges.flood  forage.flood  environmental_crop.flood
*-------------------------- use node rows (+) ----------------------------------------
EBID_u_f            1.00            17.00        8.00            8.00
EPID_u_f            0.98            16.85        7.90            7.90
MXID_u_f            0.95            16.20        7.85            7.85
*------------------------------------------------------------------------------------
;

Table   Price_p(aguse,j)    Crop Prices ($ per ton)

                   Pecans          Veges        forage   environmental_crop
EBID_u_f            4960            250           120            1
EPID_u_f            4960            250           120            1
MXID_u_f            4960            250           120            1
;



table lan_p(t,j,k,aguse)  ag land in prodn (1000 acres) over all observed historical years

* (USBR - Data Zhuping Sheng TAMU El Paso March 6 2017 - Alfredo Granados from MX growers still waiting for MX acreage before 2001 (july 3 2017)

         pecans.flood.ebid_u_f  veges.flood.ebid_u_f   forage.flood.ebid_u_f
1994        18.546                  37.126                  22.026
1995        18.546                  37.126                  22.026
1996        18.546                  37.126                  22.026
1997        18.759                  36.480                  25.512
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


+


        pecans.flood.epid_u_f  veges.flood.epid_u_f  forage.flood.epid_u_f
1994           8.252                  34.303          11.205
1995           8.252                  34.303          11.205
1996           8.252                  34.303          11.205
1997           8.390                  33.805          11.232
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


+

        pecans.flood.mxid_u_f    veges.flood.mxid_u_f  forage.flood.mxid_u_f
1994       0.250                        4.319                 24.303
1995       0.250                        4.319                 24.303
1996       0.250                        4.319                 24.303
1997       0.250                        4.319                 24.303
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

;

lan_p(t,'environmental_crop',k,aguse) = 0.001;  //essentially zero observed land in environmental crop

parameter land_p(aguse,j,k,t)  land in prodn over all observed historical years (US Bureau of Reclamation Data Zhuping Sheng TAMU El Paso March 6 2017)
;

land_p(aguse,j,k,t)  = lan_p(t,j,k,aguse);

* display land_p;


table Ba_divert_p(agdivert,j,k)  diversions     (feet depth)

                   Pecans.flood     Veges.flood      forage.flood        environmental_crop.flood
* -------------------------- apply node rows -----------------------------------------------------
EBID_d_f              5.5              4.0             5.0                       5.0
EPID_d_f              5.5              4.0             5.0                       5.0
MXID_d_f              5.5              4.0             3.0                       3.0
* -----------------------------------------------------------------------------------------------
;

table Ba_use_p(aguse,j,k)        use            (feet depth)

                   Pecans.flood     Veges.flood     forage.flood       environmental_crop.flood
* -------------------------- use node rows ------------------------------------------------------
EBID_u_f              5.5              4.0             5.0                       5.0
EPID_u_f              5.5              4.0             5.0                       5.0
MXID_u_f              5.5              4.0             3.0                       3.0
* -----------------------------------------------------------------------------------------------


table Bar_return_p(r_return,j,k) river return flows    (feet depth)

                    Pecans.flood    Veges.flood      forage.flood        environmental_crop.flood
* ------------------------------------------------------------------------------------------------
EBID_rr_f              0.0              0.0             0.0                      0.0
EPID_rr_f              0.0              0.0             0.0                      0.0
MXID_rr_f              0.0              0.0             0.0                      0.0

* ------------------------------------------------------------------------------------------------

table  Baa_return_p(aga_return,j,k) aquifer return flows  (feet depth)

                    Pecans.flood    Veges.flood      forage.flood      environmental_crop.flood
* -----------------------------------------------------------------------------------------------
EBID_ra_f              0.0              0.0             0.0                      0.0
EPID_ra_f              0.0              0.0             0.0                      0.0
MXID_ra_f              0.0              0.0             0.0                      0.0
* -----------------------------------------------------------------------------------------------
;

*overrides above coefficients quickly

Ba_use_p    (aguse,     j,k) =   0.75 * sum(agdivert, ID_adau_p (agdivert,aguse)      * Ba_divert_p(agdivert,j,k));    // 75% of river diversions applied consumed by crop (ET)
Bar_return_p(agr_return,j,k) =   0.00 * sum(agdivert, ID_adarr_p(agdivert,agr_return) * Ba_divert_p(agdivert,j,k));    //  0% of river diversions applied return to river
Baa_return_p(aga_return,j,k) =   0.25 * sum(agdivert, ID_adaar_p(agdivert,aga_return) * Ba_divert_p(agdivert,j,k));    // 25% of river diversions applied return to aquifer


table Bag_pump_aqf_return_p(aguse,j,k)   proportion of ag water pumped recharging pumped aquifer (unitless)

                    Pecans.flood    Veges.flood     forage.flood         environmental_crop.flood
EBID_u_f               0.20           0.20            0.20                         0.20
EPID_u_f               0.20           0.20            0.20                         0.20
MXID_u_f               0.20           0.20            0.20                         0.20
;

Table  Cost_p(aguse,j,k)     Crop Production Costs  ($ per acre)

                      Pecans.flood   Veges.flood     forage.flood       environmental_crop.flood
*-------------------------- use node rows (+) ---------------------------------------------------------
EBID_u_f               2700            3600            820                        820
EPID_u_f               2710            3620            825                        825
MXID_u_f               2700            3620            620                        828
*------------------------------------------------------------------------------------------------------
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

ag_av_gw_cost_p(aguse)   average irrigation costs of pumping gw ($ per a-f) at 2013 Mesilla Aquifer depth level incl capital and operations
;
ag_av_gw_cost_p(aguse)   = 120; // Source EBID consultant Phil King, NMSU March 2013


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


* display cost_af_unit_depth_p;

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

parameter ag_av_back_cost0_p(aguse)  average ag backstop technology water supply cost

/ebid_u_f      3000
 epid_u_f      3000
 mxid_u_f      3000/
;

parameter  cost_af_flow_import_p  average cost of flow imports per acre foot ($ per acre foot)
;

cost_af_flow_import_p = ag_av_back_cost0_p('ebid_u_f');
;

scalar cost_af_flow_export_p  ave cost flow exports -- dump flood flows to desert ($ per acre foot)  /5/

* nominal cost to reduce obj fn for ea unit 'exported'

parameter ag_back_cost_grow_p(aguse)  prop growth per year in ag backstop cost

/ebid_u_f       0.00
 epid_u_f       0.00
 mxid_u_f       0.00
/

scalar  prop_base_back_cost_p   proportion of backstop technology cost for new scenario if needed

/1.00/


parameter

ag_av_back_cost_p(aguse,j,k,t)   future ave ag backstop tech cost
;

ag_av_back_cost_p(aguse,j,k,t) $ (ord(t) eq 1) = 1.00 * ag_av_back_cost0_p(aguse);
ag_av_back_cost_p(aguse,j,k,t) $ (ord(t) ge 2) =        ag_av_back_cost0_p(aguse) * (1 + ag_back_cost_grow_p(aguse)) ** (ord(t) - 2);

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

* Display price_p, yield_p, cost_p, Netrev_acre_p, Netrev_af_p;


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

* display B1_p, B0_p;

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

* ciudad juarez elasticity needs to be checked!

parameter elast_p(miuse)  price elasticity with sensitivity if needed
;
elast_p(miuse) = 1.00 * elas_p(miuse);
* display elast_p;


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
;
                          //  Source:  demouche landfair ward nmwrri tech completion report 256 2010 page 11 demands for year 2009 las cruces water utility
                          //  http://www.wrri.nmsu.edu/publish/techrpt/tr356/tr356.pdf
                          //  published in the international journal of water resources development
                          //  Water Resources Development, Vol. 27, No. 2, 291314, June 2011
                          //  118,500 acre feet supplied from Rio Grande, Hueco Bolson, Mesilla Aquifer, and Kay Baily Hutchinson Desal Plant
                          //  source is http://www.epwu.org/water/water_resources.html

parameter pop0_p(miuse)     urban water buying households (1000s)


/LCMI_u_f     32.303
 epmi_u_f    194.274
 MXMI_u_f    140.082/
;

* el paso water production source dec 28 2015:  http://www.epwu.org/water/water_resources.html
* http://www.epwu.org/water/water_stats.html  194,274 customer household customers: 2012

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

parameter pop_p(miuse,t)    population by year
;

pop_p(miuse,t)                 = pop0_p(miuse) * (1 + rho_pop_p(miuse)) ** (ord(t) - 1);

* display pop0_p, rho_pop_p, pop_p;


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
 MXMI_u_f  0.00
/

urb_av_back_cost0_p(miuse)    urban ave backstop technology costs INCLUDING treatment approximate cost of desal or imported water as of 2017

/LCMI_u_f   3000.00
 epmi_u_f   3000.00
 MXMI_u_f   3000.00
/


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
* Authors:  Diego Tellez, Horacio Lom, Pablo Chargoy, Luis Rosas, Maria Mendoza, Monserrat Coatl, Nuria Macias, Rene Reyes

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
urb_av_back_cost_p(miuse,t)    future urban ave backstop technology cost
;

urb_av_cost_p     (miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_cost0_p(miuse);
urb_av_cost_p     (miuse,t) $ (ord(t) ge 2) =        urb_av_cost0_p(miuse)      * (1 + urb_cost_grow_p(miuse))      ** (ord(t) - 2);

urb_av_gw_cost_p  (miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_gw_cost0_p(miuse);
urb_av_gw_cost_p  (miuse,t) $ (ord(t) ge 2) =        urb_av_gw_cost0_p(miuse)   * (1 + urb_gw_cost_grow_p(miuse))   ** (ord(t) - 2);

urb_av_back_cost_p(miuse,t) $ (ord(t) eq 1) = 1.00 * urb_av_back_cost0_p(miuse);
urb_av_back_cost_p(miuse,t) $ (ord(t) ge 2) =        urb_av_back_cost0_p(miuse) * (1 + urb_back_cost_grow_p(miuse)) ** (ord(t) - 2);

* display urb_av_back_cost_p;

parameter Burb_back_aqf_rch_p(miuse)   proportion of urb water from backstop technology recharging aquifer

/lcmi_u_f     0.00
 epmi_u_f     0.00/


* display urb_av_cost0_p, urb_av_cost_p, urb_av_gw_cost0_p, urb_av_gw_cost_p, urb_av_back_cost0_p, urb_av_back_cost_p;


parameter
BB1_base_p (miuse  )     Slope of observed urban demand function based on observed use and externally estimated price elasticity of demand
BB1_p      (miuse,t)     flattening slope of price-dependent urban demand function with growing population
BB0_p      (miuse  )     Intercept for urban price-dependent demand function
;

BB1_base_p(miuse  )   =  urb_price_p (miuse)  /  [elast_p (miuse) * urb_use_p(miuse)];   // intercept parameter to run base price-dependent demand function through observed price and use
BB0_p     (miuse  )   =  urb_price_p (miuse) - BB1_base_p (miuse) * urb_use_p(miuse);    // intercept parameter for same thing
BB1_p     (miuse,t)   =  BB1_base_p  (miuse) *    [pop0_p (miuse) /     pop_p(miuse,t)]; // higher urb population has lower price slope - future demand pivots out with higher pop

* display urb_price_p, elast_p, BB0_p, BB1_p, bb1_base_p ;

*--------------------- END OF URBAN WATER SUPPLY PARAMETERS -----------------------------

* ------------------------------- RESERVOIR BASED RECREATION PARAMETERS -----------------

scalar counter /1/;
scalar chooser /1/;

PARAMETER

B0_rec_ben_intercept_p(res) intercept in rec benefits power function

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

scalar sw_sustain_p   terminal sustainability proportion of starting sw storage  / 0.03/

parameter gw_sustain_p(aqf) terminal sustainability proportion of starting gw storage

 /Mesilla_aqf_s    0.00
 Hueco_aqf_s      0.00/

* display gw_sustain_p;

parameter

* D1 D2 terms in 2008 operating agreement bureau of rec web page.  Text is at  https://www.usbr.gov/uc/albuq/rm/RGP/pdfs/Operating-Agreement2008.pdf

D1_LB_p(p)  lower bound parameter for D1 variable zero without the 2008 agreement (1-0)

/1-policy_wi_2008_po    1
 2-policy_wo_2008_po    0/

D1_UB_p(p)  upper bound parameter for D1 variable zero without the 2008 agreement (1-0)

/1-policy_wi_2008_po    1
 2-policy_wo_2008_po    10/

D2_LB_p(p)  lower bound parameter for D2 variable zero without the 2008 agreement (1-0)

/1-policy_wi_2008_po    1
 2-policy_wo_2008_po    0/

D2_UB_p(p)  upper bound parameter for D2 variable zero without the 2008 agreement (1-0)

/1-policy_wi_2008_po    1
 2-policy_wo_2008_po    10/


* us mexico 1906 treaty

MX_SW_divert_LB_p(p)  us mexico 1906 treaty divert lower bound param without 2008 agreement (1-0)

/1-policy_wi_2008_po   1
 2-policy_wo_2008_po   0/


MX_SW_divert_UB_p(p)    us mexico 1906 treaty divert lower bound param without 2008 agreement (1-0)

/1-policy_wi_2008_po  1
 2-policy_wo_2008_po  100000/


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

* Climate scenario: Observed (1994-2013) + extreme climate scenario (2014-2033) high emissions scenario

                  1_Selected_Inflows
Marcial_h_f.1994       1144.70
Marcial_h_f.1995       1394.51
Marcial_h_f.1996        447.98
Marcial_h_f.1997       1142.56
Marcial_h_f.1998        767.35
Marcial_h_f.1999        863.91
Marcial_h_f.2000        432.66
Marcial_h_f.2001        441.39
Marcial_h_f.2002        241.65
Marcial_h_f.2003        202.78
Marcial_h_f.2004        406.81
Marcial_h_f.2005        968.26
Marcial_h_f.2006        593.11
Marcial_h_f.2007        514.09
Marcial_h_f.2008        932.22
Marcial_h_f.2009        694.05
Marcial_h_f.2010        541.36
Marcial_h_f.2011        308.92
Marcial_h_f.2012        288.43
Marcial_h_f.2013        303.07
Marcial_h_f.2014        297.16
Marcial_h_f.2015        443.22
Marcial_h_f.2016        894.79
Marcial_h_f.2017       1109.36
Marcial_h_f.2018        855.31
Marcial_h_f.2019        359.82
Marcial_h_f.2020        319.41
Marcial_h_f.2021        400.07
Marcial_h_f.2022        357.81
Marcial_h_f.2023        510.64
Marcial_h_f.2024        455.24
Marcial_h_f.2025        238.91
Marcial_h_f.2026        448.64
Marcial_h_f.2027        453.56
Marcial_h_f.2028        596.48
Marcial_h_f.2029        477.10
Marcial_h_f.2030        390.14
Marcial_h_f.2031        474.60
Marcial_h_f.2032        461.16
Marcial_h_f.2033        351.58
;


* next line is for the swim interface to inject the san marcial inflows on run time.
* source_p('Marcial_h_f',t,'1_Selected_Inflows') = san_mar_in(t);

*parameter

Source_p('WS_Caballo_h_f',   t,w) = 87; // Alex Mayer data: weather station rainfall over watershed area times assumed 5.7% making it to channel published work
Source_p('WS_El_Paso_h_f',   t,w) = 66; //    "
Source_p('WS_above_MX_h_f',  t,w) = 43; //    "
Source_p('WS_below_MX_h_f',  t,w) =  eps; //    "
Source_p('WS_below_EPID_h_f',t,w) =  eps; //    "

* 87, 66, 43

* 0.713 is stressed. Source is:
* authors: hurd and coonrod
* journal:  climate research
* year 2012
* volume 53 pp 103-118;
* title "Hydro-economic consequences of climate change  in the upper Rio Grande,"
* page of data = of 71.3 percent of base inflow occurs on page 113


* display source_p;


table us_mx_1906_p(t,w)  actual deliveries at Acequia Madre gauge -- data source Rector Dr. Alfredo Granados

        1_Selected_Inflows
 1994      60.188
 1995      63.641
 1996      60.085
 1997      59.463
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
;

//us_mx_1906_p(t,'6_zero_flow_sMarcial') = 1.00 * us_mx_1906_P(t,'1_Obs+Extend_Drought');

//display US_MX_1906_p;

table env_mul(t, n)  environmental flow schedule per year
           1
 1994      0
 1995      0
 1996      0
 1997      0
 1998      0
 1999      0
 2000      0
 2001      0
 2002      0
 2003      0
 2004      0
 2005      0
 2006      0
 2007      0
 2008      0
 2009      0
 2010      0
 2011      0
 2012      0
 2013      1
 2014      0
 2015      0
 2016      0
 2017      0
 2018      0
 2019      0
 2020      0
 2021      0
 2022      0
 2023      1
 2024      0
 2025      0
 2026      0
 2027      1
 2028      0
 2029      0
 2030      1
 2031      0
 2032      0
 2033      1
;

parameter env_mult(t) environmental flows multiplier;
env_mult(t) = env_mul(t, '1');


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



//display gaugeflow_p;

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

z0_p  (res,p)   initial reservoir levels at reservoir stock nodes  (1000 af)
zmax_p(res)     maximum reservoir storage capacity                 (1000 af)
;

z0_p  ('Store_res_s', p)   = 1.00 * 2204.7;   // historical starting level

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

* display recharge_p;



scalars

*precip_rat_p     reservoir precip (feet gained per exposed acre per year)                               /0.97/       // data source historic precip data near Truth or Consequences NM*
*Evap_rat_p       reservoir evaporation  (feet loss per exposed acre per year)                           /7.682/       // data source selected New Mexico water reports
B1_area_vol_p    impact of changes in volume on changes in area (acres per 1000 ac feet)                /0.015/      // data source linear regression on area capacity relations
B2_area_volsq_p  impact of changes in volume squared on changes in area (acres per 1000 ac ft squared)  / eps/

parameters

evap_rate_p(t)              evaportation rate by year
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

evap_rate_p(t)  = 1.00 * evap_rat_p(t);   // overrides data with averages


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
* precip_rate_p(t) = 1 * 0.55;  // precip_rate_p(t);  // overrides data with averages


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

pp(p)   = no;   // switches subsests off for now
ww(w)   = no;   // ditto


POSITIVE VARIABLES

*Hydrology block

Z_v            (u,        t,p,w)     water stocks -- surface reservoir storage        (L3 \ yr)   (1000 af by yr)
Q_v            (aqf,      t,p,w)     water stocks -- aquifer storage                  (L3 \ yr)   (1000 af by yr)


*Q_ave_v        (aqf,        p,w)     average aquifer storage                          (L3 \ yr)   (1000 af)
*Q_term_v       (aqf,      t,p)     terminanl aquifer storage                        (L3 \ yr)   (1000 af)

Q_term_v       (aqf,t,      p,w)    terminal aqf storage                               (L3 \ yr)   (1000 af)
*Q_ave_v       (aqf,        p,w)    average  aqf storage                               (L3 \ yr)   (1000 af)

aquifer_recharge_m_v(     t,p,w)     Flow: Mesilla aquifer recharge by year         (L3 \ T)       (1000 af \ yr)
aquifer_recharge_h_v(     t,p,w)     Flow: Hueco  aquifer recharge by year          (L3 \ T)       (1000 af \ yr)

aquifer_discharge_m_v(    t,p,w)     Flow: Mesilla aquifer discharge by year         (L3 \ T)       (1000 af \ yr)
aquifer_discharge_h_v(    t,p,w)     Flow: Hueco  aquifer discharge by year          (L3 \ T)       (1000 af \ yr)

Aquifer_depth_v(aqf,      t,p,w)     aquifer depth                                    (L  \ yr)   (feet by year)

Evaporation_v  (res,      t,p,w)     reservoir surface evaporation                    (L3 \ yr)   (1000 af \ yr)
Precip_v       (res,      t,p,w)     reservoir surface precipation                    (L3 \ yr)   (1000 af \ yr)
surf_area_v    (res,      t,p,w)     reservoir surface area                           (L2 \ yr)   (1000 ac \ yr)

Ag_use_v       (aguse,    t,p,w)     irrigation total water use (sw + gw + backstop)  (L3 \ yr)   (1000 af \ yr)

Ag_use_jk_v    (aguse,j,k,t,p,w)     ag water use by crop (sw + gw + backstop)        (L3 \ yr)   (1000 af \ yr)

Ag_sw_use_jk_v (aguse,j,k,t,p,w)     ag surface water                                 (L3 \ yr)   (1000 af \ yr)

Ag_use_crop_v  (aguse,j,k,t,p,w)     irrigation water use by crop (all sources)       (L3 \ yr)   (1000 af \ yr)

ag_back_use_v  (aguse,j,k,t,p,w)     irrigation total water use backstop tech         (L3 \ yr)   (1000 af \ yr)

ag_pump_v  (aqf,aguse,j,k,t,p,w)     irrigation water pumped                          (L3 \ yr)   (1000 af \ yr)
tot_ag_pump_v(aqf,aguse,  t,p,w)     irrigation water pumped over crops and techs     (L3 \ yr)   (1000 af \ yr)

sum_ag_pump_v  (          t,p,w)     ag pumping over districts                        (L3 \ yr)   (1000 af \ yr)
sum_urb_pump_v (          t,p,w)     urban pumping over cities                        (L3 \ yr)   (1000 af \ yr)

MX_sw_divert_v (          t,p,w)     1906 US Mexico treaty surface wat deliveries     (L3 \ yr)   (1000 af \ yr)

Ag_pump_aq_rch_v(aqf,aguse,t,p,w)    ag pumping contributing to aqf recharge          (L3 \ yr)   (1000 af \ yr)

*ag backstop water use that recharges aquifers -- in progress -- little of this under current (2019) prices
*ag_back_aq_rch_v(aqf,aguse,t,p,w)    Ag backstop use contributing to aqf recharge    (L3 \ yr)   (1000 af \ yr)

Aga_returns_v (aga_return,t,p,w)     ag surface return flows to aquifer               (L3 \ yr)   (1000 af \ hr)

urb_pump_v     (aqf,miuse,t,p,w)     urban groundwater pumping                        (L3 \ yr)   (1000 af \ yr)
urb_use_v      (miuse,    t,p,w)     urban water use summed over sources              (L3 \ yr)   (1000 af \ yr)

urb_sw_use_v   (miuse,    t,p,w)     urban surface water use                            (L3 \ yr)   (1000 af \ yr)
urb_gw_use_v   (miuse,    t,p,w)     urban groundwater use                              (L3 \ yr)   (1000 af \ yr)
urb_back_use_v (miuse,    t,p,w)     urban backstop technology water use                (L3 \ yr)   (1000 af \ yr)

urb_back_aq_rch_v(aqf,miuse,t,p,w)   urban water use from backstop recharge aqf         (L3 \ yr)   (1000 af \ yr)

*land

SWacres_v      (aguse,j,k,t,p,w)     surface irrigated land in prodn                  (L2 \ yr)   (1000 ac \ yr)
GWAcres_v      (aguse,j,k,t,p,w)     groundwater irrigated land in prodn              (L2 \ yr)   (1000 ac \ yr)
BTacres_v      (aguse,j,k,t,p,w)     backstop tech irrigated land                     (L2 \ yr)   (1000 ac \ yr)
gw_aq_acres_v  (aqf,aguse,j,k,t,p,w) groundwater acres irrigated by aquifer           (L2 \ yr)   (1000 ac \ yr)


Tacres_v       (aguse,j,k,t,p,w)     total land (sw + gw  + backstop)                 (L2 \ yr)   (1000 ac \ yr)
tot_acres_v    (aguse,    t,p,w)     total irrigated land over crops                  (L2 \ yr)   (1000 ac \ yr)

yield_v        (aguse,j,k,t,p,w)     crop yield                                                   (tons    \ ac)


* urban economics block

urb_price_v    (miuse,    t,p,w)     urban price                                      ($US \ af)
urb_con_surp_v (miuse,    t,p,w)     urban consumer surplus                           ($US 1000 per year)
urb_use_p_cap_v(miuse,    t,p,w)     urban use per customer                           (af \ yr)
urb_revenue_v  (miuse,    t,p,w)     urban gross revenues from water sales            ($US 1000 per year)
urb_gross_ben_v(miuse,    t,p,w)     urban gross benefits from water sales            ($US 1000 per year)

urb_av_gw_cost_v(miuse,   t,p,w)     urban average pump costs                         ($US per acre foot)
urb_costs_v    (miuse,    t,p,w)     urban costs of water supply                      ($US 1000 per year)

urb_costs_x_bs_v(miuse,   t,p,w)     urban ave costs of water excl backstop tech      ($US 1000 per year)
urb_av_tot_cost_v(miuse,  t,p,w)     urban ave costs of water supply                  ($US per acre foot)

urb_value_v    (miuse,    t,p,w)     urban net economic benefits                      ($US 1000 per year)

* sw import costs block

Flow_import_cost_v(imports,t,p,w)     import flow augmentation costs                   ($US 1000 per year)
Flow_export_cost_v(exports,t,p,w)     export flow reduction costs to avoid spills      ($US 1000 per year)

Tot_imp_costs_v    (t,p,w)            total cost of flow augmentation imports          ($US 1000 \ yr)
Tot_exp_costs_v    (t,p,w)            total cost of flow reductions to avoid spills    (US  1000 \ yr)

DNPV_import_costs_v(  p,w)            dnpv total surface flow import costs             ($US 1000)
DNPV_export_costs_v(  p,w)            dnpv total surface flow export (spill avert) cst ($US 1000)

* ag economics block

*ag_value_v    (aguse,  j,k,t,p,w)       ag net economic benefits                      ($US 1000 per year)

*Ag_costs_v      (aguse,j,k,t,p,w)    ag production costs (sw + gw + bs)               ($US 1000 \ yr)
*Ag_av_gw_costs_v(aguse,j,k,t,p,w)    ag average pump costs  (gw)                      ($US \ af)


VARIABLES

*hydrology block

net_recharge_v (aqf,      t,p,w)     flow: net recharge                               (L3 \ yr)   (1000 af \ yr)

X_v            (i,        t,p,w)     flows -- all kinds                               (L3 \ yr)   (1000 af \ yr)

D1_v           (          t,p,w)     D1 = deliveries                                  (L3 \ yr)   (1000 af \ yr)
D2_v           (          t,p,w)     D2 = diversions                                  (L3 \ yr)   (1000 af \ yr)

D1_LB_v        (          t,p,w)     D1 lower bound = deliveries                      (L3 \ yr)   (1000 af \ yr)
D1_UB_v        (          t,p,w)     D1 upper bound = deliveries                      (L3 \ yr)   (1000 af \ yr)

D2_LB_v        (          t,p,w)     D2 = lower bound diversions                      (L3 \ yr)   (1000 af \ yr)
D2_UB_v        (          t,p,w)     D2 = upper bound diversions                      (L3 \ yr)   (1000 af \ yr)

* urban economics block

*urb_price_v    (miuse,    t,p,w)     urban price                                      ($US \ af)

urb_value_v    (miuse,    t,p,w)     urban net economic benefits                      ($US 1000 per year)

Urb_value_af_v (miuse,    t,p,w)     urban economic benefits per acre foot            ($US per acre foot)
urb_m_value_v  (miuse,    t,p,w)     urban marginal benefits per acre foot            ($US per acre foot)

* ag economics block

Ag_costs_v       (aguse,j,k,t,p,w)    ag production costs (sw + gw + bs)               ($US 1000 \ yr)
Ag_av_costs_v   (aguse,j,k,t,p,w)    ag average total costs of water                  ($US \ acre)

Ag_av_gw_costs_v (aguse,j,k,t,p,w)    ag average pump costs  (gw)                      ($US \ acre)
ag_tot_gw_costs_v(aguse,j,k,t,p,w)    ag tot total groundwater pump costs              ($US 1000 \ yr)

ag_tot_sw_costs_v(aguse,j,k,t,p,w)    ag total surf water costs                        ($US 1000 \ yr)
ag_av_sw_costs_v(aguse, j,k,t,p,w)    ag ave surf water costs                          ($US \ acre)

ag_tot_bt_costs_v(aguse,j,k,t,p,w)    ag total backstop technology prodn costs         (US 1000 \ yr)
ag_av_bt_costs_v (aguse,j,k,t,p,w)    ag ave backstop tech prodn costs                 ($US \ acre)

Ag_av_rev_v      (aguse,j,k,t,p,w)    ag average rev per acre                          ($US \yr)

Ag_value_v      (aguse,j,k,t,p,w)    ag net economic value (sw + gw + bs)             ($US 1000 \ yr)

* economics block all uses

Netrev_acre_v  (aguse,j,k,t,p,w)     ag net revenue per acre                          ($1000 \ ac)
Netrev_af_v    (aguse,j,k,t,p,w)     ag net revenue per acre foot                     ($ \ af)

*ebid
NR_ac_sw_eb_v  (      j,k,t,p,w)     net rev per acre eb surf wat                     ($ \ ac)
NR_ac_gw_eb_v  (      j,k,t,p,w)     net rev per acre eb groundwater                  ($ \ ac)
NR_ac_bt_eb_v  (      j,k,t,p,w)     net rev per acre eb backstop tech                ($ \ ac)
TNR_eb_v       (      j,k,t,p,w)     total net rev elephant butte irr district        ($1000)

*epid
NR_ac_sw_ep_v  (      j,k,t,p,w)     net rev per acre ep surf wat                     ($ \ ac)
NR_ac_gw_ep_v  (      j,k,t,p,w)     net rev per acre ep groundwater                  ($ \ ac)
NR_ac_bt_ep_v  (      j,k,t,p,w)     net rev per acre ep backstop tech                ($ \ ac)
TNR_ep_v       (      j,k,t,p,w)     total net rev el paso irr district               ($1000)

*mxid
NR_ac_sw_mx_v  (      j,k,t,p,w)     net rev per acre mx surf wat                     ($ \ ac)
NR_ac_gw_mx_v  (      j,k,t,p,w)     net rev per acre mx groundwater                  ($ \ ac)
NR_ac_bt_mx_v  (      j,k,t,p,w)     net rev per acre mx backstop tech                ($ \ ac)
TNR_mx_v       (      j,k,t,p,w)     total net rev mexico irr district                ($1000)


Ag_Ben_v       (use,      t,p,w)     net income over crops by node and yr             ($1000 \ yr)
T_ag_ben_v     (            p,w)     Net income over crops nodes and yrs              ($1000 \ yr)


Env_ben_v      (river,    t,p,w)     environmental benefits by year                   ($1000 \ yr)
rec_ben_v      (res,      t,p,w)     reservoir recreation benefits by year            ($1000 \ yr)

Tot_ag_ben_v     (        t,p,w)     Total ag benefits by year                        ($1000 \ yr)
Tot_urb_ben_v    (        t,p,w)     Total urban benefits by year                     ($1000 \ yr)
Tot_env_riv_ben_v(        t,p,w)     Total river environmental benefits by year       ($1000 \ yr)
Tot_rec_res_ben_v(        t,p,w)     Total recreation reservoir benefits by year      ($1000 \ yr)

Tot_ben_v        (        t,p,w)     total benefits over uses by year                 ($1000 \ yr)

DNPV_ag_ben_v     (         p,w)     DNPV ag benefits                                 ($1000)
DNPV_urb_ben_v    (         p,w)     DNPV urban benefits                              ($1000)
DNPV_env_riv_ben_v(         p,w)     DNPV environmental river benefits                ($1000)
DNPV_rec_res_ben_v(         p,w)     DNPV reservoir recreation benefits               ($1000)

DNPV_ben_v       (          p,w)     discounted NPV over uses and years               ($1000)
DNPV_v                                           DNPV looped over sets                            ($1000)

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

Land_e         (aguse,     t,p,w)      Acres land                                    (L2 \ T)       (1000 ac \ yr)
Tacres_e       (aguse,j,k, t,p,w)      total acres in prodn (sw + gw)                (L2 \ T)       (1000 ac \ yr)
acres_pump_e   (aguse,j,k, t,p,w)      acres pumped (gw only)                        (L2 \ T)       (1000 ac \ yr)
BTacres_e      (aguse,j,k, t,p,w)      acres BT irrigated                            (L2 \ T)       (1000 ac \ yr)
gw_aq_acres_e  (aqf,aguse,j,k,t,p,w)      groundwater acres by aquifer               (L2 \ T)       (1000 ac \ yr)

* crop yield block

Yield0_e       (aguse,j,k, t,p,w)      Crop yield initial period                                       (tons \ ac)
Yield_e        (aguse,j,k, t,p,w)      Crop yield later periods                                        (tons \ ac)

* Hydrology Block

Inflows_e      (inflow,    t,p,w)      Flows: source nodes                           (L3 \ T)       (1000 af \ yr)
Rivers_e       (i,         t,p,w)      Flows: mass balance by node                   (L3 \ T)       (1000 af \ yr)

Evaporation_e  (res,       t,p,w)      Flows: Reservoir evaporation                  (L3 \ T)       (1000 af \ yr)
Precip_e       (res,       t,p,w)      Flows: reservoir precip                       (L3 \ T)       (1000 af \ yr)

Surf_area_e    (res,       t,p,w)      Flow:  surface area by reservoir              (L2 \ T)       (1000 ac \ yr)
MX_sw_divert_e (           t,p,w)      Flow:  Mexican surface treaty deliveries      (L3 \ T)       (1000 af \ yr)

Agdiverts_e    (agdivert,  t,p,w)      Flows: ag diverted water from acres           (L3 \ T)       (1000 af \ yr)
Agr_Returns_e  (agr_return,t,p,w)      Flows: ag riv return flows from acres         (L3 \ T)       (1000 af \ yr)
Aga_Returns_e  (aga_return,t,p,w)      Flows: ag aq return flows from acres          (L3 \ T)       (1000 af \ yr)

AgUses_e       (aguse,     t,p,w)      Flows: ag use based on acreage                (L3 \ T)       (1000 af \ yr)

Ag_sw_use_jk_e (aguse,j,k, t,p,w)      Flows: ag surface water use                   (L3 \ T)       (1000 af \ yr)
Ag_use_e       (aguse,     t,p,w)      Flows: ag use -- readable                     (L3 \ T)       (1000 af \ yr)
Ag_Use_jk_e    (aguse,j,k, t,p,w)      Flows: ag use by jk                           (L3 \ T)       (1000 af \ yr)

Ag_use_crop_e  (aguse,j,k, t,p,w)      Flows: ag use by crop                         (L3 \ T)       (1000 af \ yr)

*ag_pump_bound_e(aqf,aguse,j,k,t,p)   Flows: ag pumping bound (experimental)

sum_ag_pump_e  (           t,p,w)      Flows: sum ag pumping all nodes               (L3 \ T)       (1000 af \ yr)
sum_urb_pump_e (           t,p,w)      Flows: sum urban pumping all nodes            (L3 \ T)       (1000 af \ yr)

MIr_Returns_e  (mir_return,t,p,w)      Flows: urban return flows based on urb pop    (L3 \ T)       (1000 af \ yr)
MIa_Returns_e  (mia_return,t,p,w)      Flows: urban riv divert ret to aquiver        (L3 \ T)       (1000 af \ yr)

MIUses_e       (miuse,     t,p,w)      Flows: urban use  based on urb pop            (L3 \ T)       (1000 af \ yr)

reservoirs0_e  (res,       t,p,w)      Stock: starting reservoir level               (L3    )       (1000 af)
reservoirs_e   (res,       t,p,w)      Stock: over time                              (L3    )       (1000 af)

Net_release_e  (           t,p,w)      Flow:  net rel drawdown on res excl dstm imports (L3\T)       (1000 af \ yr)

aquifers0_e    (aqf,       t,p,w)      Stock: starting aquifer storage               (L3 \ T)       (1000 af)

aquifer_discharge_h_e(     t,p,w)      Flow: Mesilla aquifer dischrage by year       (L3 \ T)       (1000 af \ yr)
aquifer_discharge_m_e(     t,p,w)      Flow: Hueco aquifer discharge by year         (L3 \ T)       (1000 af \ yr)

aquifer_recharge_m0_e(     t,p,w)      Stock: initial mesilla recharge
aquifer_recharge_m_e(      t,p,w)      Stock: Mesilla aquifer recharge over time     (L3 \ T)       (1000 af \ yr)

aquifer_recharge_h0_e(     t,p,w)      Flow:  Hueco rechg in 1st period
aquifer_recharge_h_e(      t,p,w)      Stock: Hueco  aquifer recharge over time      (L3 \ T)       (1000 af \ yr)

Net_recharge_m_e          (t,p,w)      Flow: net recharge mesilla                    (L3 \ T)       (1000 af \ yr)
Net_recharge_h_e          (t,p,w)      Flow: net recharge hueco                      (L3 \ T)       (1000 af \ yr)

aquifer_storage_m_e(       t,p,w)      Stock: Mesilla aquifer over time              (L3 \ T)       (1000 af \ yr)
aquifer_storage_h_e(       t,p,w)      Stock: Hueco bolson over time                 (L3 \ T)       (1000 af \ yr)

aquifer_depth_e(aqf,      t,p,w)       State: aquifer depth by aquifer               (L  \ T)       (feet \ yr)
tot_ag_pump_e  (aqf,aguse,t,p,w)       Flows: total ag pumping by aqf node and yr    (L3 \ T)       (1000 af \ yr)

Ag_pump_aq_rch1_e(        t,p,w)       Flows: ag pump EBID NM recharge Mesilla aqf   (L3 \ T)       (1000 af \ yr)
Ag_pump_aq_rch2_e(        t,p,w)       Flows: ag pump EPID TX recharge Hueco bolson  (L3 \ T)       (1000 af \ yr)
Ag_pump_aq_rch3_e(        t,p,w)       Flows: ag pump MXID MX recharge Hueco bolson  (L3 \ T)       (1000 af \ yr)

* ag backstop aquifer recharge slot here
*ag_back_aq_rch1_e(        t,p,w)       Flows: ag back use EBID NM recharge Mesilla aqf   (L3 \ T)   (1000 af \ yr)
*ag_back_aq_rch2_e(        t,p,w)       Flows: ag back use EPID TX recharge Hueco bolson  (L3 \ T)   (1000 af \ yr)
*ag_back_aq_rch3_e(        t,p,w)       Flows: ag back use MXID MX recharge Hueco bolson  (L3 \ T)   (1000 af \ yr)

*urban use block

urb_price_e    (miuse,    t,p,w)       urban water price                                            ($US      \ af)
urb_con_surp_e (miuse,    t,p,w)       urban consumer surplus                                       ($US 1000 \ yr)
urb_use_p_cap_e(miuse,    t,p,w)       urban use per customer                        (L3 \ T)       (af\ yr)
urb_revenue_e  (miuse,    t,p,w)       urban gross revenues from water sales                        ($US 1000 \ yr)
urb_gross_ben_e(miuse,    t,p,w)       urban gross benefits from water sales                        ($US 1000 \ yr)

urb_costs_e     (miuse,   t,p,w)       urban costs of water supply                                  ($US 1000 \ yr)
urb_av_gw_cost_e(miuse,   t,p,w)       urban ave groundwater pump costs                             ($US per ac-ft)
urb_av_tot_cost_e(miuse,  t,p,w)       urban average costs of water supply                          ($US per ac-ft)
urb_costs_x_bs_e(miuse,   t,p,w)       urban costs of water supply exclcluding backstop tech        ($US 1000 \ yr)

urb_value_e    (miuse,    t,p,w)       Urban net economic benefits                                  ($US 1000 \ yr)

urb_sw_use_e   (miuse,    t,p,w)       urban surface water use                       (L3 \ T)       (1000 af \ yr)
urb_gw_use_e   (miuse,    t,p,w)       urban groundwater use                         (L3 \ T)       (1000 af \ yr)
urb_use_e      (miuse,    t,p,w)       urban total use                               (L3 \ T)       (1000 af \ yr)



Urb_back_aq_rch1_e(       t,p,w)       urban use from backstop tech rech mesilla aqf (L3 \ T)       (1000 af \ yr)
Urb_back_aq_rch12_e(      t,p,w)
Urb_back_aq_rch13_e(      t,p,w)

Urb_back_aq_rch21_e(      t,p,w)
Urb_back_aq_rch2_e(       t,p,w)       urban use from backstop tech rech epmi - hueco(L3 \ T)       (1000 af \ yr)
Urb_back_aq_rch3_e(       t,p,w)       urban use from backstop tech rech mxmi - hueco(L3 \ T)       (1000 af \ yr)

Urb_value_af_e (miuse,    t,p,w)       urban average net economic benefits                          ($US \ ac-ft)
urb_m_value_e  (miuse,    t,p,w)       urban marginal net benefits per                              ($US \ ac-ft)

*Institutions Block (all handled in bounds below so shadow prices can be found)


* Ag Economics Block

Ag_costs_eb_e       (      j,k,t,p,w)      Agricultural production costs (sw + gw + bs)  ($US 1000\ yr)
Ag_costs_ep_e       (      j,k,t,p,w)      Agricultural production costs (sw + gw + bs)  ($US 1000\ yr)
Ag_costs_mx_e       (      j,k,t,p,w)      Mx

Ag_av_costs_e    (aguse,j,k,t,p,w)      Ag ave total costs                            ($US \ acre)

ag_tot_sw_costs_e(aguse,j,k,t,p,w)      Ag tot surf water costs                       ($US 1000 \ yr)
Ag_av_sw_costs_e (aguse,j,k,t,p,w)      Ag ave surf water costs                       ($US 1000 \ acre)

ag_tot_gw_costs_e(aguse,j,k,t,p,w)      ag tot total groundwater pump costs           ($US 1000 \ yr)
ag_av_gw_costs_e (aguse,j,k,t,p,w)      ag ag groundwater pump costs                  ($  \ acre)
ag_av_gw_costs_eb_e(    j,k,t,p,w)      ag av ebid gw pump costs                      ($  \ acre)
ag_av_sw_costs_eb_e(    j,k,t,p,w)      ag av ebid sw costs                      ($  \ acre)
ag_av_bt_costs_eb_e(    j,k,t,p,w)      ag av ebid bt costs                      ($  \ acre)

ag_av_bt_costs_e (aguse,j,k,t,p,w)      ag_av_bt_costs_                               ($  \ acre)

ag_tot_bt_costs_e(aguse,j,k,t,p,w)      ag total backstop technology prodn costs      ($US 1000 \ yr)

Ag_value_e     (aguse,j,k,t,p,w)       Agricultural net benefits     (sw + gw)       ($US 1000\ yr)

Ag_av_rev_e    (aguse,j,k,t,p,w)       ag average gross rev per acre                 ($US \ acre)

Netrev_acre_e  (aguse,j,k,t,p,w)       Net farm income per acre                      ($US   \ ac)
Netrev_af_e    (aguse,j,k,t,p,w)       Net farm income per acre foot                 ($US   \ af)

*ebid
NR_ac_sw_eb_e(        j,k,t,p,w)       net rev per acre eb sw                        ($ \ ac)
NR_ac_gw_eb_e(        j,k,t,p,w)       net rev per acre eb gw                        ($ \ ac)
NR_ac_bt_eb_e(        j,k,t,p,w)       net rev per acre eb bt                        ($ \ ac)
TNR_eb_e     (        j,k,t,p,w)       total net revenue el butte irr district       ($1000)

*epid
NR_ac_sw_ep_e  (      j,k,t,p,w)     net rev per acre ep surf wat                     ($ \ ac)
NR_ac_gw_ep_e  (      j,k,t,p,w)     net rev per acre ep groundwater                  ($ \ ac)
NR_ac_bt_ep_e  (      j,k,t,p,w)     net rev per acre ep backstop tech                ($ \ ac)
TNR_ep_e       (      j,k,t,p,w)     total net rev el paso irr district               ($1000)

*mxid
NR_ac_sw_mx_e  (      j,k,t,p,w)     net rev per acre mx surf wat                     ($ \ ac)
NR_ac_gw_mx_e  (      j,k,t,p,w)     net rev per acre mx groundwater                  ($ \ ac)
NR_ac_bt_mx_e  (      j,k,t,p,w)     net rev per acre mx backstop tech                ($ \ ac)
TNR_mx_e       (      j,k,t,p,w)     total net rev mexico irr district                ($1000)


Ag_ben_e       (aguse,    t,p,w)       net farm income over crops and over acres     ($1000 \ yr)
T_ag_ben_e                                         net farm income over crops nodes and yr       ($1000 \ yr)


*Ag_val_bal_e   (aguse,j,k,t,p)       net farm income balance check

Ag_m_value_e   (aguse,j,k,t,p,w)       ag marginal value per unit water              ($US   \ af)

* environmental benefits block

Env_ben_e      (river,    t,p,w)       environmental benefits from surface storage   ($1000 \ yr)

* reservoir recreation benefits block

Rec_ben_e       (res,      t,p,w)       storage reservoir recreation benefits         ($1000 \ yr)

* flow augmentation costs

Flow_import_cost_e(imports,t,p,w)       flow augmentation costs                       ($1000 \ yr)
Flow_export_cost_e(exports,t,p,w)       flow export costs                             ($1000 \ yr)

* total economics added block

Tot_ag_ben_e     (        t, p,w)      Total ag benefits by year                     ($1000 \ yr)
Tot_urb_ben_e    (        t, p,w)      Total urban benefits by year                  ($1000 \ yr)
Tot_env_riv_ben_e(        t, p,w)      Total river environmental benefits by year    ($1000 \ yr)
Tot_rec_res_ben_e(        t, p,w)      Total recreation reservoir benefits by yeaer  ($1000 \ yr)

Tot_imp_costs_e  (        t, p,w)      total surface water import costs              ($1000 \ yr)
Tot_exp_costs_e  (        t, p,w)      tot surf water export costs - avert spill     ($1000 \ yr)

Tot_ben_e        (        t, p,w)      total benefits over uses                      ($1000 \ yr)

DNPV_ag_ben_e     (          p,w)      DNPV ag benefits                              ($1000)
DNPV_urb_ben_e    (          p,w)      DNPV urban benefits                           ($1000)
DNPV_env_riv_ben_e(          p,w)      DNPV environmental river benefits             ($1000)
DNPV_rec_res_ben_e(          p,w)      DNPV reservoir recreation benefits            ($1000)

DNPV_import_costs_e (        p,w)      DNPV surface import costs                     ($1000)
DNPV_export_costs_e(         p,w)      DNPV surfae export costs                      ($1000)

DNPV_ben_e       (           p,w)      discounted net present value over users       ($1000)
DNPV_e                                 discounted npv looped over sets               ($1000)






*matching history

*nm_tx_e          (         t,p,w)      nm deliveries at nm-tx stateline              (1000 af \ yr)




*below_epid_e     (         t,p,w)      below project region                         (1000 af \ yr)

*proj_operate_2008_e(      t,p,w)      2008 project operating constraint cab releases (1000 af \ yr)

proj_operate_2008_LB_e(        t,  w)      2008 project operating constraint cab releases (1000 af \ yr)
proj_operate_2008_UB_e(        t,  w)      2008 project operating constraint cab releases (1000 af \ yr)


*D1_e               (        t,p,w)      D1 term in operating agreement - deliveries    (1000 af \ yr)
*D2_e               (        t,p,w)      D2 term in operating agreement - diversions    (1000 af \ yr)

D1_LB_e             (        t,  w)      D1 lower bound term in 2008 Op agreement
D1_UB_e             (        t,  w)      D1 upper bound

D2_LB_e             (        t,  w)      D2 Lower bound in 2008 op agreement
D2_Ub_e             (        t,  w)      D2 upper bound

*D1_zero_e           (        t,  w)      D1 > 0 for symmetry
*D2_zero_e           (        t,  w)      D2 > 0 for symmetry

*US_MX_1906_e       (        t,p,w)      US MX 1906 treaty flows impl by 2008 po

US_MX_1906_LB_e     (        t,  w)      lower bound US Mexico Treaty flow deliveries
US_MX_1906_UB_e     (        t,  w)      upper bound US Mexico Treaty flow deliveries


*tacres_base_l_e   (  aguse,j,k,t,w)      historical acres in prodn                    (1000 acres \ yr)

*nm_tx_LB_e       (         t,  w)       lower bound nm tx deliveries
*nm_tx_UB_e       (         t,  w)       upper bound nm tx deliveries

up_bnd_EPID_e    (         t,  w)      upper bnd on deliveries to nm-tx stateline    (1000 af \ yr)
;

*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
* EQUATIONS DEFINED ALGEBRAICALLY USING EQUATION NAMES
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*


*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*
*  Agricultural Land  Block
*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*----*-------*


Land_e(aguse,  t,pp,ww)..  sum((j,k), Tacres_v(aguse,  j,k,t,pp,ww)) =e= tot_acres_v(aguse,t,pp,ww);

Yield0_e    (aguse,j,k,t,pp,ww)  $ (ord(t) eq 1)..       yield_v(aguse,j,k,t,pp,ww)   =e= yield_p(aguse,j,k);
*Yield_e     (aguse,j,k,t,pp,ww)  $ (ord(t) gt 1)..       Yield_v(aguse,j,k,t,pp,ww)   =e=  B0_p(aguse,j,k,t)  + B1_p(aguse,j,k,t) * Tacres_v(aguse,j,k,t,pp,ww);  // postive math programming calibration if needed
Yield_e    (aguse,j,k,t,pp,ww)  $ (ord(t) gt 1)..       Yield_v(aguse,j,k,t,pp,ww)   =e= yield_p(aguse,j,k);

Tacres_e     (aguse,j,k,t,pp,ww)..                             Tacres_v (aguse,j,k,t,pp,ww)

                                                                       =e=     SWacres_v(aguse,j,k,t,pp,ww)
                                                                            +  GWacres_v(aguse,j,k,t,pp,ww)
                                                                            +  BTacres_v(aguse,j,k,t,pp,ww);

gw_aq_acres_e(aqf,aguse,j,k,t,pp,ww)..       gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww)
                                                  =e=            ag_pump_v(aqf,aguse,j,k,t,pp,ww) / Ba_use_p(aguse,j,k);
                                                                                                                             ; // total land supplied by sw + gw
acres_pump_e (aguse,j,k,t,pp,ww)..                gwacres_v(aguse,    j,k,t,pp,ww)
                                                  =e=    sum(aqf, ag_pump_v(aqf,aguse,j,k,t,pp,ww)) / Ba_use_p  (aguse,j,k); // land supplied by gw

BTacres_e    (aguse,j,k,t,pp,ww)..                BTacres_v(aguse,j,k,t,pp,ww)
                                                  =e=         ag_back_use_v(aguse,j,k,t,pp,ww) / Ba_use_p(aguse,j,k);  // acreage irrigated by BT technology


*--------------*---------*---------*---------*---------*---------*---------*------------*
* Hydrology  Block
*---------*---------*---------*---------*---------*---------*---------*-----------------*


* --------------------------------------------------------------------------------------*
*                                    surface water begins
* --------------------------------------------------------------------------------------*

* inflows start

Inflows_e(inflow,t,pp,ww)..    X_v(inflow,t,pp,ww) =E= source_p(inflow,t,ww);

Rivers_e  (river,t,pp,ww)..    X_v(river,t,pp,ww)  =E=

     sum(inflow,    Bv_p(inflow,  river)  * source_p(inflow,  t,   ww                )) +
     sum(imports,   Bv_p(imports, river)  *      X_v(imports, t,pp,ww)) +
     sum(exports,   Bv_p(exports, river)  *      X_v(exports, t,pp,ww)) +
     sum(riverp,    Bv_p(riverp,  river)  *      X_v(riverp,  t,pp,ww)) +
     sum(divert,    Bv_p(divert,  river)  *      X_v(divert,  t,pp,ww)) +
     sum(r_return,  Bv_p(r_return,river)  *      X_v(r_return,t,pp,ww)) +
     sum(rel,       Bv_p(rel,     river)  *      X_v(rel,     t,pp,ww)) ;




reservoirs0_e(res,t,pp,ww)  $ (ord(t) eq 1)..   Z_v(res,t,pp,ww) =e= Z0_p(res,pp);

reservoirs_e (res,t,pp,ww) $ (ord(t) gt 1)..   Z_v(res,t,pp,ww)        =E= Z_v(res,t-1,pp,ww)
                                        -  SUM(rel, BLv_p(rel,res)       * X_v(rel,t,  pp,ww))
                                        -                        evaporation_v(res,t,  pp,ww)
                                        +                         precip_v    (res,t,  pp,ww);

* net releases are defined exclusive of imports since entering downstream of the dam don't add to reservoir storage/;

Net_release_e(t,pp,ww).. X_v('store_rel_f',t,pp,ww) =n= X_v('RG_Caballo_out_v_f',t,pp,ww)
*                                                                                      - X_v('Imp_Caballo_m_f',   t,pp,ww)
                                                                                 - source_p('Marcial_h_f', t, ww);  // works for caballo needs adjusting for more reservoirs

*inflows end

* reservoirs start

// reservoir storage tracking

Evaporation_e(res,t,pp,ww)..  Evaporation_v(res,t,pp,ww)  =e= Evap_rate_p(t)       * surf_area_v(res,t,pp,ww);
Precip_e     (res,t,pp,ww)..  Precip_v     (res,t,pp,ww)  =e= Precip_rate_p(t)     * surf_area_v(res,t,pp,ww);

*Surf_area_e  (res,t,pp,ww)..    surf_area_v(res,t,pp,ww)  =e= B1_area_vol_p * Z_v(res,t,pp,ww) + B2_area_volsq_p * Z_v(res,t,pp,ww) ** 2;

$ontext

Surf_area_e  (res,t,pp,ww)..           surf_area_v(res,t,pp)  =e=

                                    4.301     * [1/ (10**2)] * Z_v(res,t,pp,ww) ** 1
                                 -  4.095     * [1/ (10**5)] * Z_v(res,t,pp,ww) ** 2
                                 +  2.421634  * [1/ (10**8)] * Z_v(res,t,pp,ww) ** 3
                                 -  4.9841    * [1/(10**12)] * Z_v(res,t,pp,ww) ** 4;
$offtext

Surf_area_e  (res,t,pp,ww)..    surf_area_v(res,t,pp,ww)  =e= B1_area_vol_p   * Z_v(res,t,pp,ww)
                                                                                            + B2_area_volsq_p * Z_v(res,t,pp,ww) ** 2;

*reservoirs end


AgDiverts_e  (agdivert,  tlater,pp,ww)..  X_v(agdivert,           tlater,pp,ww) =e= sum((j,k), Ba_divert_p (agdivert,  j,k)  * sum(aguse, ID_adu_p(agdivert,aguse   ) * SWacres_v(aguse,j,k,tlater,pp,ww)));  // diversions prop to acreage
AgUses_e     (aguse,     tlater,pp,ww)..  X_v(          aguse,    tlater,pp,ww) =e= sum((j,k), Ba_use_p    (aguse,     j,k)  *    (1                                ) * SWacres_v(aguse,j,k,tlater,pp,ww)) ;  // use prop to acreage
Ag_Use_crop_e(aguse,j,k, tlater,pp,ww)..  Ag_Use_crop_v(aguse,j,k,tlater,pp,ww) =e=            Ba_use_p    (aguse,     j,k)  *    (1                                ) * SWacres_v(aguse,j,k,tlater,pp,ww) ;  // use prop to acreage

Agr_Returns_e(agr_return,tlater,pp,ww)..  X_v(agr_return,tlater,pp,ww) =e= sum((j,k), Bar_return_p(agr_return,j,k)  * sum(aguse, ID_arr_p(agr_return,aguse ) * SWacres_v(aguse,j,k,tlater,pp,ww)));  // return flows prop to acreage
// ag river diversions applied returned to river

Aga_Returns_e(aga_return,tlater,pp,ww)..  Aga_returns_v(aga_return,tlater,pp,ww) =e= sum((j,k), Baa_return_p(aga_return,j,k)  * sum(aguse, ID_ara_p(aga_return,aguse ) * SWacres_v(aguse,j,k,tlater,pp,ww)));  // return flow to aquifer from ag application
// ag river diversions applied returned to aquifer
//Agp_Returns_e (ag pumping returns to river)

MIUses_e     (miuse,       t,pp,ww)..  X_v(miuse,     t,pp,ww) =e=  sum(midivert, Bmdu_p(midivert,     miuse) *  X_v(midivert,t,pp,ww));
MIr_Returns_e(mir_return,  t,pp,ww)..  X_v(mir_return,t,pp,ww) =e=  sum(midivert, Bmdr_p(midivert,mir_return) *  X_v(midivert,t,pp,ww));
* urban river diversions returned to river

MIa_Returns_e(mia_return,  t,pp,ww)..  X_v(mia_return,t,pp,ww) =e=  sum(midivert, Bmda_p(midivert,mia_return) *  X_v(midivert,t,pp,ww));
* urban river diversions returned to aquifer



* ---------------------------------- surface water ends ---------------------------------------------------

* ---------------------------------------------------------------------------------------------------------
* ----------------------------------    Aquifer Water Begins ----------------------------------------------
*----------------------------------------------------------------------------------------------------------

Ag_pump_aq_rch1_e(t,pp,ww)..  Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww) =e= sum((j,k), Bag_pump_aqf_return_p('ebid_u_f',j,k) * ag_pump_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww));     // ebid pump mesilla aq
Ag_pump_aq_rch2_e(t,pp,ww)..  Ag_pump_aq_rch_v('hueco_aqf_s'  ,'epid_u_f',t,pp,ww) =e= sum((j,k), Bag_pump_aqf_return_p('epid_u_f',j,k) * ag_pump_v('hueco_aqf_s',  'epid_u_f',j,k,t,pp,ww));  // epid ag pump hueco aq
Ag_pump_aq_rch3_e(t,pp,ww)..  Ag_pump_aq_rch_v('hueco_aqf_s'  ,'mxid_u_f',t,pp,ww) =e= sum((j,k), Bag_pump_aqf_return_p('mxid_u_f',j,k) * ag_pump_v('hueco_aqf_s',  'mxid_u_f',j,k,t,pp,ww));  // mx ag pump mesilla aq

* ---------------------------------------------------------------------------------------------------------
* ag backstop technology recharge here -- in progress

*ag_back_aq_rch1_e(t,pp,ww)..  ag_back_aq_rch_v('mesilla_aqf_s', 'ebid_u_f',t,pp,ww) =e= sum((j,k), Bag_back_aqf_return_p('ebid_u_f') * ag_back_use_v('ebid_u_f',j,k,t,pp,ww));
*ag_back_aq_rch2_e(t,pp,ww)..  ag_back_aq_rch_v('hueco_aqf_s'  , 'epid_u_f',t,pp,ww) =e= sum((j,k), Bag_back_aqf_return_p('epmi_u_f') * ag_back_use_v('epid_u_f',j,k,t,pp,ww));
*ag_back_aq_rch3_e(t,pp,ww)..  ag_back_aq_rch_v('hueco_aqf_s'  , 'mxid_u_f',t,pp,ww) =e= sum((j,k), Bag_back_aqf_return_p('mxmi_u_f') * ag_back_use_v('mxid_u_f',j,k,t,pp,ww));

* end of ag backstop technology recharge

* ---------------------------------------------------------------------------------------------------------

** urban aquifer recharge from backstop technology by aquifer and city

Urb_back_aq_rch1_e (t,pp,ww)..       urb_back_aq_rch_v('mesilla_aqf_s', 'lcmi_u_f',t,pp,ww) =e=  Burb_back_aqf_rch_p('lcmi_u_f') * urb_back_use_v('lcmi_u_f',t,pp,ww);
Urb_back_aq_rch12_e(t,pp,ww)..       urb_back_aq_rch_v('mesilla_aqf_s', 'epmi_u_f',t,pp,ww) =e=  0;
Urb_back_aq_rch13_e(t,pp,ww)..       urb_back_aq_rch_v('mesilla_aqf_s', 'mxmi_u_f',t,pp,ww) =e=  0;

Urb_back_aq_rch21_e(t,pp,ww)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'lcmi_u_f',t,pp,ww) =e=  0;
Urb_back_aq_rch2_e (t,pp,ww)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'epmi_u_f',t,pp,ww) =e=  Burb_back_aqf_rch_p('epmi_u_f') * urb_back_use_v('epmi_u_f',t,pp,ww);
Urb_back_aq_rch3_e (t,pp,ww)..       urb_back_aq_rch_v('hueco_aqf_s'  , 'mxmi_u_f',t,pp,ww) =e=  Burb_back_aqf_rch_p('mxmi_u_f') * urb_back_use_v('mxmi_u_f',t,pp,ww);

* ------------------------------------------------------------------------------ aquifer recharge and discharge --------------------------------------------------------------------------------------------------------

*mesilla aquifer recharge follows

aquifer_recharge_m0_e(t,pp,ww) $ (ord(t) eq 1)..                    aquifer_recharge_m_v(t,pp,ww) =e= recharge_p('mesilla_aqf_s',t);


aquifer_recharge_m_e(t,pp,ww) $ (ord(t) gt 1)..                     aquifer_recharge_m_v(t,pp,ww) =e=

                                                                                      recharge_p('mesilla_aqf_s',           t      )     // mesilla aq mountain recharge in t

                                                                     +             Aga_returns_v('ebid_ra_f',               t,pp,ww)     // ag ebid river divert return to aqf

                                                                     +          Ag_pump_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww)     // ag ebid pumping return to mesilla

*                                                                     +          ag_back_aq_rch_v('mesilla_aqf_s','ebid_u_f',t,pp,ww)    // ag back technology recharge to Mesilla

                                                                   + sum(miuse, urb_back_aq_rch_v('mesilla_aqf_s', miuse,   t,pp,ww));                   // urban back technology recharge to Mesilla
                                                                                                                                                         // open future slot:  urban pumping return to mesilla aqf
                                                                                                                                                         // open future slot urban river return to mesilla


*hueco aquifer recharge follows

aquifer_recharge_h0_e(t,pp,ww) $ (ord(t) eq 1)..                    aquifer_recharge_h_v(t,pp,ww) =e= recharge_p('hueco_aqf_s',t);

aquifer_recharge_h_e(t,pp,ww) $ (ord(t) gt 1)..                     aquifer_recharge_h_v(t,pp,ww) =e=

                                                                                      recharge_p('hueco_aqf_s',           t      )        // hueco aq mountain recharge in t

                                                                     +             Aga_returns_v('epid_ra_f',             t,pp,ww)        // ag epid river divert return to aqf
                                                                     +             Aga_returns_v('mxid_ra_f',             t,pp,ww)        // ag mxid river divert return to aqf

                                                                     +          Ag_pump_aq_rch_v('hueco_aqf_s','epid_u_f',t,pp,ww)        // ag epid pumping return to hueco
                                                                     +          Ag_pump_aq_rch_v('hueco_aqf_s','mxid_u_f',t,pp,ww)        // ag mxid pumping return to hueco

*                                                                     +          ag_back_aq_rch_v('hueco_aqf_s','epid_u_f',t,pp,ww)        // ag back technology from epid recharge to Hueco
*                                                                     +          ag_back_aq_rch_v('hueco_aqf_s','mxid_u_f',t,pp,ww)        // ag back technology from mxid recharge to Hueco

                                                                  + sum(miuse, urb_back_aq_rch_v('hueco_aqf_s', miuse,    t,pp,ww));      // urban back technology recharge to Hueco
                                                                                                                                                          // open future slot: urban pumping return to Hueco aqf
                                                                                                                                                          // open future slot urban river return to Hueco aqf


aquifer_discharge_m_e(t,pp,ww) $ (ord(t) gt 0)..                   aquifer_discharge_m_v(t,pp,ww) =e=

                                                                         sum(miuse,    urb_pump_v('mesilla_aqf_s',miuse,  t,pp,ww))   // urban pumping from mesilla aquifer
                                                                      +  sum(aguse, tot_ag_pump_v('mesilla_aqf_s',aguse,  t,pp,ww));  // ag pumping from mesilla aquifer


aquifer_discharge_h_e(t,pp,ww) $ (ord(t) gt 0)..                   aquifer_discharge_h_v(t,pp,ww) =e=

                                                                         sum(miuse,    urb_pump_v('hueco_aqf_s',miuse,    t,pp,ww))   // urban pumping from hueco aquifer
                                                                      +  sum(aguse, tot_ag_pump_v('hueco_aqf_s',aguse,    t,pp,ww));   // ag pumping from hueco aquifer

aquifers0_e  (aqf,t,pp,ww)   $ (ord(t) eq 1)..     Q_v(aqf,t,pp,ww)  =e= Q0_p(aqf);   //aquifer starting values


aquifer_storage_m_e(t,pp,ww) $ (ord(t) gt 1)..     Q_v('mesilla_aqf_s',t,  pp,ww) =e=   // mesilla aq storage t
                                                                   Q_v('mesilla_aqf_s',t-1,pp,ww)       // mesilla aq storage t-1
                                                           +      aquifer_recharge_m_v(t,  pp,ww)       // mesilla recharge   t
                                                           -     aquifer_discharge_m_v(t,  pp,ww)  ;    // mesilla discharge  t


aquifer_storage_h_e(t,pp,ww) $ (ord(t) gt 1)..       Q_v('hueco_aqf_s',t,  pp,ww) =e=   // hueco aq storage t
                                                                     Q_v('hueco_aqf_s',t-1,pp,ww)       // hueco aq storage t-1
                                                           +      aquifer_recharge_h_v(t,  pp,ww)       // hueco aq recharge   t
                                                           -     aquifer_discharge_h_v(t,  pp,ww)  ;    // hueco aq discharge  t


Net_recharge_m_e(t,pp,ww)..                    net_recharge_v('mesilla_aqf_s',t,pp,ww) =e=

                                                                         aquifer_recharge_m_v(t,pp,ww)
                                                                      - aquifer_discharge_m_v(t,pp,ww);

Net_recharge_h_e(t,pp,ww)..                      net_recharge_v('hueco_aqf_s',t,pp,ww)  =e=

                                                                         aquifer_recharge_h_v(t,pp,ww)
                                                                      - aquifer_discharge_h_v(t,pp,ww);

* total ag pumping over crops by aquifer
tot_ag_pump_e(aqf,aguse,t,pp,ww)..  tot_ag_pump_v(aqf,aguse,t,pp,ww) =e= sum((j,k), ag_pump_v(aqf,aguse,j,k,t,pp,ww));  // total ag pumping by district

* total ag pumping
sum_ag_pump_e  (t,pp,ww)..     sum_ag_pump_v(t,pp,ww) =e= sum((aqf,aguse), tot_ag_pump_v(aqf,aguse,t,pp,ww));

* total urban pumping
sum_urb_pump_e (t,pp,ww)..    sum_urb_pump_v(t,pp,ww) =e= sum(miuse, urb_gw_use_v  (miuse,t,pp,ww));

* aquifer depth by aquifer
aquifer_depth_e(aqf,t,pp,ww)..     Aquifer_depth_v(aqf,t,pp,ww)  =e= [qmax_p(aqf) - Q_v(aqf,t,pp,ww)] / [porosity_p(aqf) * aq_area_p(aqf)]; // simple rectangle bathub shaped aquifer


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

MX_sw_divert_e(t,pp,ww)..   MX_sw_divert_v(t,pp,ww) =e= X_v('MXMI_d_f', t, pp, ww) + X_v('MXID_d_f', t, pp, ww);


*---------------------------------------------------------------------------------------
* Economics Block as connected to urban and ag use -- money units $ US
*---------------------------------------------------------------------------------------

* urban econ block: document. Booker, michelsen, ward, Water Resources Research 2006  http:  //agecon.nmsu.edu/fward/water/

urb_sw_use_e   (miuse,t,pp,ww)..     urb_sw_use_v(miuse,t,pp,ww) =e=                        X_v(miuse,t,pp,ww);
urb_gw_use_e   (miuse,t,pp,ww)..   urb_gw_use_v  (miuse,t,pp,ww) =e=     sum(aqf,urb_pump_v(aqf,miuse,t,pp,ww));

urb_use_e      (miuse,t,pp,ww)..                                 urb_use_v     (miuse,t,pp,ww) =e=
                                                                                   urb_sw_use_v(miuse,t,pp,ww)
                                                                               +   urb_gw_use_v(miuse,t,pp,ww)
                                                                               + urb_back_use_v(miuse,t,pp,ww); // urban use = urb divert + urb pump + urb backstop use

urb_price_e    (miuse,t,pp,ww)..      urb_price_v(miuse,t,pp,ww) =e=           BB0_p(miuse)  +         [bb1_p(miuse,t)        * urb_use_v(miuse,t,pp,ww)];   // urban demand price flattens as urban customer numbers grow.
urb_con_surp_e (miuse,t,pp,ww)..   urb_con_surp_v(miuse,t,pp,ww) =e=   0.5 * {[BB0_p(miuse) -   urb_price_v  (miuse,t,pp,ww)] * urb_use_v(miuse,t,pp,ww)};   // urban price is not known until model runs (dependent variable)
urb_use_p_cap_e(

*BB1_base_p (miuse)
*BB1_p      (miuse,t)
*BB0_p      (miuse  )


miuse,t,pp,ww)..  urb_use_p_cap_v(miuse,t,pp,ww) =e=       urb_use_v(miuse,t,pp,ww) /         pop_p(miuse,t);                                // per household urban water use typically about 0.5 acre feet/yr
urb_revenue_e  (miuse,t,pp,ww)..    urb_revenue_v(miuse,t,pp,ww) =e=     urb_price_v(miuse,t,pp,ww) *     urb_use_v(miuse,t,pp,ww);                          // urban gross tariff revenue
urb_gross_ben_e(miuse,t,pp,ww)..  urb_gross_ben_v(miuse,t,pp,ww) =e=  urb_con_surp_v(miuse,t,pp,ww) + urb_revenue_v(miuse,t,pp,ww);                          // tariff revenue + consumer surplus

urb_costs_e    (miuse,t,pp,ww)..    urb_costs_v  (miuse,t,pp,ww) =e=

                              urb_Av_cost_p(miuse,t)                                                               *   urb_sw_use_v(              miuse,t,pp,ww)
*                 + sum{aqf,  [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p(ss2) * aquifer_depth_v(aqf,t,pp,ww,ss1,ss2,ss3,ss4)] * urb_pump_v(aqf,miuse,t,pp,ww,ss1,ss2,ss3,ss4)}

           + [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww)] * urb_pump_v('mesilla_aqf_s',miuse,t,pp,ww)
           + [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',  t,pp,ww)] * urb_pump_v('hueco_aqf_s',  miuse,t,pp,ww)

           +  urb_av_back_cost_p(miuse,t)                   * urb_back_use_v(miuse,t,pp,ww);

urb_av_tot_cost_e(miuse,t,pp,ww)..  urb_av_tot_cost_v(miuse,t,pp,ww) =e= urb_costs_v(miuse,t,pp,ww) /
                                                                                                   (.001 + urb_use_v(miuse,t,pp,ww));

urb_av_gw_cost_e(miuse,t,pp,ww).. urb_av_gw_cost_v(miuse,t,pp,ww) =e=
                 [
         sum(aqf,   [urb_av_cost_p(miuse,t) + cost_af_unit_depth_p * aquifer_depth_v(aqf, t,pp,ww)] * urb_pump_v(aqf,miuse,t,pp,ww))
                 ]
                 /
            [.001 +         urb_gw_use_v  (miuse,t,pp,ww)];

* below is urban costs exclusive of backstop technology

urb_costs_x_bs_e(miuse,t,pp,ww).. urb_costs_x_bs_v(miuse,t,pp,ww) =e=
                                                       urb_costs_v(miuse,t,pp,ww)
                - urb_av_back_cost_p(miuse,t) * urb_back_use_v(miuse,t,pp,ww);

urb_value_e    (miuse,t,pp,ww)..   urb_value_v   (miuse,t,pp,ww) =e=    urb_gross_ben_v(miuse,t,pp,ww) - urb_costs_v(miuse,t,pp,ww);                      // urban value - net benefits = gross benefits minus urban costs (cs + ps)

Urb_value_af_e (miuse,t,pp,ww)..   Urb_value_af_v(miuse,t,pp,ww) =e=    urb_value_v(miuse,t,pp,ww) /     (urb_use_v(miuse,t,pp,ww) + 0.01);                      // [wat_use_urb_v(miuse,t) + 0.01]);  // urban economic value per acre foot - includes consumer surplus
urb_m_value_e  (miuse,t,pp,ww)..  urb_m_value_v  (miuse,t,pp,ww) =e=    urb_price_v(miuse,t,pp,ww) - (urb_costs_v(miuse,t,pp,ww) / (.001 + urb_use_v(miuse,t,pp,ww)));    // urb marg value: has errors

* --------------------------------------------------------------------------------------
* end of urban economics block
* --------------------------------------------------------------------------------------

* --------------------------------------------------------------------------------------
* begin irrigation economics block:  see booker, michelsen, ward, Water Resources Research 2006 https://water-research.nmsu.edu/
* --------------------------------------------------------------------------------------


* costs start


ag_costs_eb_e (           j,k,t,pp,ww)..

 ag_costs_v   ('ebid_u_f',j,k,t,pp,ww)           =e=
             [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * 50                                                                                    ] *     swacres_v('ebid_u_f',              j,k,t,pp,ww)
       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww)}] * gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww)
*       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww)
       +     [cost_p('ebid_u_f', j,k) + ba_use_p('ebid_u_f',j,k) * ag_av_back_cost_p('ebid_u_f',j,k,t)                                               ] *     btacres_v('ebid_u_f',              j,k,t,pp,ww);


ag_costs_ep_e (           j,k,t,pp,ww)..

 ag_costs_v ('epid_u_f',j,k,t,pp,ww)           =e=
             [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * 50                                                                                    ] *     swacres_v('epid_u_f',              j,k,t,pp,ww)
       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww)}]   * gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww)
*       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww)
       +     [cost_p('epid_u_f', j,k) + ba_use_p('epid_u_f',j,k) * ag_av_back_cost_p('epid_u_f',j,k,t)                                                   ] *     btacres_v('epid_u_f',              j,k,t,pp,ww);


ag_costs_mx_e (           j,k,t,pp,ww)..

 ag_costs_v ('mxid_u_f',j,k,t,pp,ww)           =e=
             [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * 50                                                                                    ] *     swacres_v('mxid_u_f',              j,k,t,pp,ww)
       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww)}]   * gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww)
*       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * 60                                                                                    ] * gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww)
       +     [cost_p('mxid_u_f', j,k) + ba_use_p('mxid_u_f',j,k) * ag_av_back_cost_p('mxid_u_f',j,k,t)                                                   ] *     btacres_v('mxid_u_f',              j,k,t,pp,ww);

ag_tot_sw_costs_e(aguse,j,k,t,pp,ww)..            ag_tot_sw_costs_v( aguse,j,k,t,pp,ww) =e=
            (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *   50                                                                                                        ])  *          swacres_v(aguse,j,k,t,pp,ww);

ag_tot_gw_costs_e(aguse,j,k,t,pp,ww)..            ag_tot_gw_costs_v( aguse,j,k,t,pp,ww) =e=
  + sum(aqf, (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *  {90 + cost_af_unit_depth_p * aquifer_depth_v('hueco_aqf_s',t,pp,ww)}                      ])  *  gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww));

ag_tot_bt_costs_e(aguse,j,k,t,pp,ww)..            ag_tot_bt_costs_v( aguse,j,k,t,pp,ww) =e=
             (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) *       ag_av_back_cost_p(aguse,j,k,t)                                                                       ])  *        btacres_v(aguse,j,k,t,pp,ww);

*  + sum(aqf, (cost_p(aguse,j,k) +    [ba_use_p(aguse,j,k) * {ag_av_gw_cost_p(aguse,ss4) + (cost_af_unit_depth_p      * aquifer_depth_v(aqf,t,pp,ww))}]) *  gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww));

Ag_av_sw_costs_e(aguse, j,k,t,pp,ww)..   ag_av_sw_costs_v(aguse,j,k,t,pp,ww)
                                                   =n=  ag_tot_sw_costs_v(aguse,j,k,t,pp,ww) / (.001 + swacres_v(aguse,j,k,t,pp,ww));

ag_av_gw_costs_e(aguse, j,k,t,pp,ww)..  ag_av_gw_costs_v(aguse,j,k,t,pp,ww)
                                                   =n= ag_tot_gw_costs_v(aguse,j,k,t,pp,ww) / (.001 + sum(aqf, gw_aq_acres_v(aqf,aguse,j,k,t,pp,ww)));


ag_av_sw_costs_eb_e(j,k,t,pp,ww)..  ag_av_sw_costs_v('ebid_u_f',j,k,t,pp,ww) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * (50) ;

ag_av_gw_costs_eb_e(j,k,t,pp,ww)..  ag_av_gw_costs_v('ebid_u_f',j,k,t,pp,ww) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * {90 + cost_af_unit_depth_p * aquifer_depth_v('mesilla_aqf_s',t,pp,ww)} ;

ag_av_bt_costs_eb_e(j,k,t,pp,ww)..  ag_av_bt_costs_v('ebid_u_f',j,k,t,pp,ww) =e=
                                                              cost_p('ebid_u_f',j,k)
                                                        +   ba_use_p('ebid_u_f',j,k) * {ag_av_back_cost_p('ebid_u_f',j,k,t)};

ag_av_bt_costs_e(aguse, j,k,t,pp,ww)..  ag_av_bt_costs_v(aguse,j,k,t,pp,ww)
                                                   =n= ag_tot_bt_costs_v(aguse,j,k,t,pp,ww) / (.001 + btacres_v(aguse,j,k,t,pp,ww));

Ag_av_costs_e(aguse,j,k,t,pp,ww)..        Ag_av_costs_v(aguse,j,k,t,pp,ww)
                                                   =e=       ag_costs_v(aguse,j,k,t,pp,ww)  / (.001 + ag_use_v(aguse,t,pp,ww));

* costs end

Ag_av_rev_e(aguse,j,k,t,pp,ww)..    Ag_av_rev_v(aguse,j,k,t,pp,ww) =e=
                                                        price_p(aguse,j                          )
                                                 *      yield_v(aguse,j,k,t,pp,ww);  // gross rev per acre

Ag_value_e   (aguse,j,k,t,pp,ww)..     Ag_value_v(aguse,j,k,t,pp,ww)  =e=
                                                      Ag_av_rev_v(aguse,j,k,t,pp,ww)
                                                   *     Tacres_v(aguse,j,k,t,pp,ww)

                                              - Ag_tot_sw_costs_v(aguse,j,k,t,pp,ww)
                                              - Ag_tot_gw_costs_v(aguse,j,k,t,pp,ww)
                                              - Ag_tot_bt_costs_v(aguse,j,k,t,pp,ww);
*                                                     - Ag_costs_v(aguse,j,k,t,pp,ww) ; // farm net income from all water sources

Ag_ben_e     (aguse,    t,pp,ww)..    Ag_Ben_v   (aguse,    t,pp,ww)  =E=      sum((j,k), Ag_value_v(aguse,j,k,t,pp,ww));

Netrev_acre_e(aguse,j,k,t,pp,ww)..  Netrev_acre_v(aguse,j,k,t,pp,ww)  =e=     ag_value_v(aguse,j,k,t,pp,ww)
                                                                                                    / (.01 +    Tacres_v(aguse,j,k,t,pp,ww));   // net farm income per acre

*ebid

NR_ac_sw_eb_e(j,k,t,pp,ww)..  NR_ac_sw_eb_v(j,k,t,pp,ww) =e=    price_p('ebid_u_f',j                          )
                                                                                                        *  yield_v('ebid_u_f',j,k,t,pp,ww)
                                                                                               -  ag_av_sw_costs_v('ebid_u_f',j,k,t,pp,ww);


NR_ac_gw_eb_e(j,k,t,pp,ww)..  NR_ac_gw_eb_v(j,k,t,pp,ww) =e=      price_p('ebid_u_f',j                        )
                                                                                                        *    yield_v('ebid_u_f',j,k,t,pp,ww)
                                                                                                -   ag_av_gw_costs_v('ebid_u_f',j,k,t,pp,ww);


NR_ac_bt_eb_e(j,k,t,pp,ww)..  NR_ac_bt_eb_v(j,k,t,pp,ww) =e=      price_p('ebid_u_f',j                         )
                                                                                                        *    yield_v('ebid_u_f',j,k,t,pp,ww)
                                                                                                -   ag_av_bt_costs_v('ebid_u_f',j,k,t,pp,ww);

TNR_eb_e(j,k,t,pp,ww)..                          TNR_eb_v(j,k,t,pp,ww) =e=

                                                 NR_ac_sw_eb_v(j,k,t,pp,ww) *                      swacres_v('ebid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_gw_eb_v(j,k,t,pp,ww) *  gw_aq_acres_v('mesilla_aqf_s','ebid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_bt_eb_v(j,k,t,pp,ww) *                      btacres_v('ebid_u_f',j,k,t,pp,ww);

*epid


NR_ac_sw_ep_e(j,k,t,pp,ww)..  NR_ac_sw_ep_v(j,k,t,pp,ww) =e=    price_p('epid_u_f',j                          )
                                                                                                        *  yield_v('epid_u_f',j,k,t,pp,ww)
                                                                                               -  ag_av_sw_costs_v('epid_u_f',j,k,t,pp,ww);


NR_ac_gw_ep_e(j,k,t,pp,ww)..  NR_ac_gw_ep_v(j,k,t,pp,ww) =e=      price_p('epid_u_f',j                        )
                                                                                                        *    yield_v('epid_u_f',j,k,t,pp,ww)
                                                                                                -   ag_av_gw_costs_v('epid_u_f',j,k,t,pp,ww);


NR_ac_bt_ep_e(j,k,t,pp,ww)..  NR_ac_bt_ep_v(j,k,t,pp,ww) =e=     price_p('epid_u_f',j                         )
                                                                                                       *    yield_v('epid_u_f',j,k,t,pp,ww)
                                                                                               -   ag_av_bt_costs_v('epid_u_f',j,k,t,pp,ww);

TNR_ep_e(j,k,t,pp,ww)..                         TNR_ep_v(j,k,t,pp,ww) =e=

                                                 NR_ac_sw_ep_v(j,k,t,pp,ww) *                    swacres_v('epid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_gw_ep_v(j,k,t,pp,ww) *  gw_aq_acres_v('hueco_aqf_s','epid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_bt_ep_v(j,k,t,pp,ww) *                    btacres_v('epid_u_f',j,k,t,pp,ww);

*mxid
NR_ac_sw_mx_e(j,k,t,pp,ww)..  NR_ac_sw_mx_v(j,k,t,pp,ww) =e=    price_p('mxid_u_f',j                          )
                                                                                                        *  yield_v('mxid_u_f',j,k,t,pp,ww)
                                                                                               -  ag_av_sw_costs_v('mxid_u_f',j,k,t,pp,ww);


NR_ac_gw_mx_e(j,k,t,pp,ww)..  NR_ac_gw_mx_v(j,k,t,pp,ww) =e=      price_p('mxid_u_f',j                        )
                                                                                                        *    yield_v('mxid_u_f',j,k,t,pp,ww)
                                                                                                -   ag_av_gw_costs_v('mxid_u_f',j,k,t,pp,ww);


NR_ac_bt_mx_e(j,k,t,pp,ww)..  NR_ac_bt_mx_v(j,k,t,pp,ww) =e=     price_p('mxid_u_f',j                         )
                                                                                                       *    yield_v('mxid_u_f',j,k,t,pp,ww)
                                                                                               -   ag_av_bt_costs_v('mxid_u_f',j,k,t,pp,ww);

TNR_mx_e(j,k,t,pp,ww)..                          TNR_mx_v(j,k,t,pp,ww) =e=

                                                 NR_ac_sw_mx_v(j,k,t,pp,ww) *                    swacres_v('mxid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_gw_mx_v(j,k,t,pp,ww) *  gw_aq_acres_v('hueco_aqf_s','mxid_u_f',j,k,t,pp,ww)
                                          +      NR_ac_bt_mx_v(j,k,t,pp,ww) *                    btacres_v('mxid_u_f',j,k,t,pp,ww);

Netrev_af_e(aguse,j,k,t,pp,ww)..      Netrev_af_v(aguse,j,k,t,pp,ww)  =e=     ag_value_v(aguse,j,k,t,pp,ww)
                                                                                                    / (.01 + Ag_use_jk_v(aguse,j,k,t,pp,ww));   // net farm income per acre foot water used (ET)

Ag_use_e     (aguse,    t,pp,ww)..       ag_use_v(aguse,    t,pp,ww)  =e=
                                                              X_v(aguse,    t,pp,ww)
                                  +  sum((j,k,aqf), ag_pump_v(aqf,aguse,j,k,t,pp,ww))
                                  +  sum((j,k),     ag_back_use_v(aguse,j,k,t,pp,ww));

Ag_sw_use_jk_e  (aguse,j,k,t,pp,ww)..   Ag_sw_use_jk_v(aguse,j,k,t,pp,ww) =e=  Ba_use_p  (aguse,j,k) * SWacres_v(aguse,j,k,t,pp,ww) ;  // use prop to acreage

Ag_use_jk_e(aguse,j,k,t,pp,ww)..           ag_use_jk_v(aguse,j,k,t,pp,ww)  =e=
                                                        Ag_sw_Use_jk_v(aguse,j,k,t,pp,ww)              // river use
                                            +  sum(aqf, ag_pump_v(aqf, aguse,j,k,t,pp,ww))             // pumping
                                            +            ag_back_use_v(aguse,j,k,t,pp,ww);            // backstop technology.  total use is sw + gw + backstop ag water use

T_ag_ben_e   (            pp,ww)..    T_ag_ben_v (            pp,ww)  =E=      sum((aguse,t),   Ag_Ben_v(aguse,  t,pp,ww));

Ag_m_value_e(aguse,j,k,t,pp,ww)..    Ag_m_value_v(aguse,j,k,t,pp,ww)   =e=  [price_p(aguse,j) *   Yield_v(aguse,j,k,t,pp,ww)      - Cost_p(aguse,j,k)] * (1/Ba_use_p(aguse,j,k)) +
                                                                             price_p(aguse,j) * SWacres_v(aguse,j,k,t,pp,ww) *      B1_p(aguse,j,k,t)  * (1/Ba_use_p(aguse,j,k));
* --------------------------------------------------------------------------------------
* end irrigation economics block
* --------------------------------------------------------------------------------------

* environmental economics benefit block

Env_ben_e(river,t,pp,ww) $ (ord(river) = card(river))..    env_ben_v('RG_below_EPID_v_f',t,pp,ww)  =e=   B0_env_flow_ben_p('RG_below_EPID_v_f') * (1+X_v('RG_below_EPID_v_f',t,pp,ww))** B1_env_flow_ben_p('RG_below_EPID_v_f');  // env flow benefit inc at falling rate synth data

* reservoir recreation benefit block

Rec_ben_e(res,t,pp,ww)..                  rec_ben_v(res,t,pp,ww)  =e=   B0_rec_ben_intercept_p(res) + B0_rec_ben_p(res) * surf_area_v(res,t,pp,ww)** B1_rec_ben_p(res);  // simple square root function synthetic data

* ---------------------------------------------------------------------------------------
* surface water streamflow augmentation import/export cost block
* ---------------------------------------------------------------------------------------

Flow_import_cost_e(imports,t,pp,ww)..   Flow_import_cost_v(imports,t,pp,ww) =e= 1.0 * cost_af_flow_import_p * X_v(imports,t,pp,ww);
Flow_export_cost_e(exports,t,pp,ww)..   Flow_export_cost_v(exports,t,pp,ww) =e= 1.0 * cost_af_flow_export_p * X_v(exports,t,pp,ww);

* --------------------------------------------------------------------------------------
* total economic welfare block
* --------------------------------------------------------------------------------------

Tot_ben_e (       t,pp,ww) $ (ord(t) gt 1)..         Tot_ben_v          (                    t,pp,ww)   =e=
                                                                 sum(aguse, ag_ben_v    (   aguse,           t,pp,ww))
                                                               + sum(miuse, urb_value_v (   miuse,           t,pp,ww))
                                                               + sum(res,   rec_ben_v   (   res,             t,pp,ww))
                                                               +            env_ben_v   ('RG_below_EPID_v_f',t,pp,ww)  // small benefit from instream flow in forgotton reach below el paso
                                                               - sum(imports, flow_import_cost_v(imports,    t,pp,ww))
                                                               - sum(exports, flow_export_cost_v(exports,    t,pp,ww));

Tot_ag_ben_e     (t,pp,ww)..   Tot_ag_ben_v     (t,pp,ww)   =e=  sum(aguse, ag_ben_v      (aguse,               t,pp,ww));
Tot_urb_ben_e    (t,pp,ww)..   Tot_urb_ben_v    (t,pp,ww)   =e=  sum(miuse, urb_value_v   (miuse,               t,pp,ww));
Tot_env_riv_ben_e(t,pp,ww)..   Tot_env_riv_ben_v(t,pp,ww)   =e=             env_ben_v     ('RG_below_EPID_v_f', t,pp,ww) ;
Tot_rec_res_ben_e(t,pp,ww)..   Tot_rec_res_ben_v(t,pp,ww)   =e=  sum(res,rec_ben_v    (res,                 t,pp,ww)); // recreation benefit from storage at elephant Butte and Caballo

Tot_imp_costs_e  (t,pp,ww)..   Tot_imp_costs_v  (t,pp,ww)   =e=  sum(imports, flow_import_cost_v(imports,       t,pp,ww));
Tot_exp_costs_e  (t,pp,ww)..   Tot_exp_costs_v  (t,pp,ww)   =e=  sum(exports, flow_export_cost_v(exports,       t,pp,ww));

DNPV_ag_ben_e      (pp,ww)..   DNPV_ag_ben_v      (pp,ww)   =e= sum(tlater, disc_factr_p(tlater) *  tot_ag_ben_v     (tlater,pp,ww));
DNPV_urb_ben_e     (pp,ww)..   DNPV_urb_ben_v     (pp,ww)   =e= sum(tlater, disc_factr_p(tlater) *  tot_urb_ben_v    (tlater,pp,ww));
DNPV_env_riv_ben_e (pp,ww)..   DNPV_env_riv_ben_v (pp,ww)   =e= sum(tlater, disc_factr_p(tlater) *  tot_env_riv_ben_v(tlater,pp,ww));
DNPV_rec_res_ben_e (pp,ww)..   DNPV_rec_res_ben_v (pp,ww)   =e= sum(tlater, disc_factr_p(tlater) *  tot_rec_res_ben_v(tlater,pp,ww));

DNPV_import_costs_e(pp,ww)..   DNPV_import_costs_v(pp,ww)   =e= sum(t     , disc_factr_p(t     ) *  tot_imp_costs_v  (t     ,pp,ww));
DNPV_export_costs_e(pp,ww)..   DNPV_export_costs_v(pp,ww)   =e= sum(t     , disc_factr_p(t     ) *  tot_exp_costs_v  (t     ,pp,ww));


DNPV_ben_e         (pp,ww)..      DNPV_ben_v        (pp,ww) =e=

                                                  DNPV_ag_ben_v     (pp,ww)
                                               +  DNPV_urb_ben_v    (pp,ww)
                                               +  DNPV_env_riv_ben_v(pp,ww)
                                               +  DNPV_rec_res_ben_v(pp,ww)
                                               - DNPV_import_costs_v(pp,ww)
                                               - DNPV_export_costs_v(pp,ww);

DNPV_e                                    ..      DNPV_v  =e= sum((pp,ww), DNPV_ben_v(pp,ww));




* --------------------------------------------------------------------------------------
* End of total economic welfare block
* --------------------------------------------------------------------------------------


*************************************************************************************************************************************************************************
* code below constrains model to approximately replicate historical flows at 3 important basin gauges
*************************************************************************************************************************************************************************


* caballo outflow fn of San Marcial inflow and project surface storage -- regression historical gauged flows approximates project operating - 1997 - 2015

*$ontext
                                                                         //pp

proj_operate_2008_LB_e(tlater,   ww)..  X_v('RG_Caballo_out_v_f',tlater, '1-policy_wi_2008_po',      ww)
*                                                                                     '1-policy_wi_2008_po'

                              =g=      {          [0.54 * source_p('marcial_h_f',tlater,                       ww                )]     // .56708
                                                 +[0.44 *      Z_v('store_res_s',tlater, '1-policy_wi_2008_po',ww)]     // .46873
                                       };

proj_operate_2008_UB_e(tlater,   ww)..  X_v('RG_Caballo_out_v_f',tlater, '1-policy_wi_2008_po',      ww)
*                                                                                     '1-policy_wi_2008_po'

                              =l=     {            [0.59 * source_p('marcial_h_f',tlater,                       ww                )]     // .56708
                                                 + [0.49 *      Z_v('store_res_s',tlater, '1-policy_wi_2008_po',ww)]     // .46873
                                       };

*$ontext

D1_LB_e(tlater,   ww)..   D1_v(tlater,'1-policy_wi_2008_po',ww)  =G= [X_v('RG_caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww) - 124.0] * 0.75;    // 0.826 coeff 2008 proj operation (0-1)
D1_UB_e(tlater,   ww)..   D1_v(tlater,'1-policy_wi_2008_po',ww)  =L= [X_v('RG_caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww) - 124.0] * 0.90;    // 0           2008 proj operation (0-1)

D2_LB_e(tlater,   ww)..   D2_v(tlater,'1-policy_wi_2008_po',ww)  =G= [X_v('RG_Caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww) -  69.0] * 1.1;    // 1.34 divertable to project users
D2_UB_e(tlater,   ww)..   D2_v(tlater,'1-policy_wi_2008_po',ww)  =L= [X_v('RG_Caballo_out_v_f',tlater,'1-policy_wi_2008_po', ww) -  69.0] * 1.5;    // 1.34 divertable to project users



US_MX_1906_LB_e(tlater,ww)..                                      MX_sw_divert_v(tlater,'1-policy_wi_2008_po',ww)
                                                                      =G=   min{ 60,
                                                                                0.11 * D1_v(tlater,'1-policy_wi_2008_po',ww)
                                                                               };        // 0.113  US Mexico Treaty holds both with and without 2008 operating agreement, i.e. all values of the set p

US_MX_1906_UB_e(tlater,ww)..                                         MX_sw_divert_v(tlater,'1-policy_wi_2008_po',ww)

                                                                      =L=    min{ 60,
                                                                          0.12 * D1_v(tlater,'1-policy_wi_2008_po',ww)
                                                                                };    // 0.113  US Mexico Treaty holds both with and without 2008 operating agreement, i.e. all values of the set p
$ontext

* Rio Grande at El Paso is a fn of Caballo releases.  Regression coefficient matches historical actual for 1997-2015 -- with operating agreement only

nm_tx_LB_e(tlater,   ww)..                          X_v('RG_El_Paso_v_f',   tlater,'1-policy_wi_2008_po', ww)
                                                                         =N=          [D2_v(tlater,'1-policy_wi_2008_po', ww)
                                                                          -  MX_sw_divert_v(tlater,'1-policy_wi_2008_po', ww)] * 0.42;       // 0.43


nm_tx_UB_e(tlater,   ww)..                          X_v('RG_El_Paso_v_f',   tlater,'1-policy_wi_2008_po', ww)
                                                                         =N=          [D2_v(tlater,'1-policy_wi_2008_po', ww)
                                                                          -  MX_sw_divert_v(tlater,'1-policy_wi_2008_po', ww)] * 0.44;       // 0.43

$offtext

up_bnd_EPID_e(tlater,   ww)..                    X_v('RG_El_Paso_v_f',      tlater,'1-policy_wi_2008_po',ww) =l=
                                                                 350;  // 300 000 af/yr is upper bound on EPID's use

$ontext

*1_wo_stress
*1_wo_stress

*tacres_base_l_e(aguse,j,k,tlater,ww)..         tacres_v(aguse,j,k,tlater,'1-policy_wi_2008_po',  ww) =n= land_p(aguse,j,k,tlater);   // bounds irrigated acreage near historical observed ebid


* terminal then average aquifer protection set to original storage volume

*Q_term_e(aqf,tlast,pp,ww)..        Q_v(aqf,tlast,pp,ww,'2_wi_terminal_aqf_protection')                  =e=      Q_term_v(aqf,tlast,pp,ww);
*Q_ave_e (aqf,      pp,ww).. sum(t, Q_v(aqf,t,    pp,ww,'2_wi_average_aqf_protection'))/card(t)         =e=      Q_ave_v (aqf,      pp,ww);  // defines aquifer storage levels averaged over years

$offtext

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

Z_v.lo        (res,                t,p,w)   = 0.01;    // bounds storage volume away from 0. gradients are infinite at zero for nonlinear terms
surf_area_v.lo(res,                t,p,w)   = 0.01;    // bounds surface area away from 0
SWacres_v.lo  (aguse,j,k,          t,p,w)   = eps;     // bounds total surface water acres away from 0
tacres_v.lo   (aguse,j,k,          t,p,w)   = eps;     // bounds total               acres away from 0

tot_acres_v.up(aguse,              t,p,w)   = LANDRHS_p(aguse);  // upper bound on irrigable area in irrigation regions

Z_v.lo        (res, tlast,p,w) = sw_sustain_p * Z0_p(res,p);          // terminal period return for reservoir storage
Q_v.lo        (aqf, tlast,p,w) = gw_sustain_p(aqf) * Q0_p(aqf);               // terminal aq can be zero withokut aquifer protection

tacres_v.up (aguse,'pecans',k,tlater,p,w)  =  land_p(aguse,'pecans',k,tlater);    // cannot exceed historical land in prodn for any crop with falling water supplies
tacres_v.up (aguse,'veges', k,tlater,p,w)  =  land_p(aguse,'veges', k,tlater);

* forcing environmental acres minimum
tacres_v.lo('ebid_u_f', 'environmental_crop', k, t, p, w) = 5 * env_mult(t);
tacres_v.lo('epid_u_f', 'environmental_crop', k, t, p, w) = eps;
tacres_v.lo('mxid_u_f', 'environmental_crop', k, t, p, w) = eps;

* end of acreage bounds

X_v.up('RG_Caballo_out_v_f', tfirst,p,w) = eps;    // no storage outflow in starting period
X_v.up('RG_Caballo_out_v_f','1994',p,w) = Z0_p('Store_res_s',p) ;  // the most the model can use is the entire reservoir
X_v.up(divert,               tfirst,p,w) = eps;    // no diversions or use from project storage in starting period

* pumping capacity by aquifer and use

urb_pump_v.up   (aqf,miuse,t,p, w)   =     urb_gw_pump_capacity_p(aqf,miuse);   // upper bound on urban pumping capacity by city

tot_ag_pump_v.up(aqf,aguse,t,p,w)   =      ag_gw_pump_capacity_p(aqf,aguse);   // upper bound on ag pumping by aquifer and farming area


* urban diversion treatment capacity

X_v.up          (miuse,t,p,w)       =      SW_Treat_capac_p(miuse);              // upper bound on all urban river water use from surface treatment:
                                                                                              // none for Las Cruces and Juarez, MX as of 2017.

* positive values required for all following flow variables since all are potentially nonlinear with infinite derivatives if set to zero

X_v.lo(inflow,  t,p,w)   = eps;
X_v.lo(imports, t,p,w)   = eps;
X_v.lo(exports, t,p,w)   = eps;
X_v.lo(river,   t,p,w)   = eps;
X_v.lo(divert,  t,p,w)   = eps;
X_v.lo(use,     t,p,w)   = eps;
X_v.lo(r_return,t,p,w)   = eps;
X_v.lo(a_return,t,p,w)   = eps;

D1_v.lo(        t,p,w)   = eps;
D2_v.lo(        t,p,w)   = eps;

MX_sw_divert_v.up(t,p,w) = 60;


Z_v.up(res,     t,p,w)   = 1.0                 * Zmax_p(res  );     // surface storage cannot exceed max storage capacity

Q_v.up(aqf,     t,p,w)   = 1.0                 * Qmax_p(aqf)  ;     // aquifer storage cannot exceed max storage capacity

*Q_term_v.lo(aqf,tlast,p,w)  = pct_return_aqf_p * Q0_p(aqf);  // enforced lower bnd wo ave aqf protect


ag_back_use_v.up(aguse,j,k,t,p,w) =  20000;
ag_back_use_v.lo(aguse,j,k,t,p,w) =  0;

urb_back_use_v.up(miuse,    t,p,w) =   20000;   //  used to calc max capacity teo pay for urban backstop use when upriced
urb_back_use_v.lo(miuse,    t,p,w) =  0;   //  used to give freedom to produce at 0


Netrev_af_v.up(aguse,j,k,t,p,w) = 10000000;

Ag_av_costs_v.up(aguse, j,k,t,p,w) = 100000;


parameter

shad_price_res_p(     res,t,p,w)  defines reservoir terminal condition shadow price
shad_price_aqf_p(     aqf,t,p,w)  defines aquifers terminal condition shadow price

shad_price_aqf_ave_p( aqf,   p,w)  defines shadow price of protecting ave      aquifer conditions
shad_price_aqf_term_p(aqf,t, p,w)  defines shadow price of protecting terminal aquifer conditions

shad_price_urb_back_use_p(miuse,    t,p,w)  shad price urban backstop use
shad_price_ag_back_use_p (aguse,j,k,t,p,w)  shad price ag    backstop use

* ------------------------------ SECTION 7 ---------------------------------------------*
*                              Model Solves Follow                                      *
* --------------------------------------------------------------------------------------*

parameter mod_stat_p  (p,w);  // model optimality status
* prepare to solve inside loops

ww(w) = no;
pp(p) = no;

loop (p,
 loop (w,

  ww(w)   = yes;
  pp(p)   = yes;

  If ((counter eq chooser or chooser eq -1),
        solve RIO_PROTOTYPE using dnlp maximizing DNPV_v;
  );

  mod_stat_p (p,w)  = RIO_PROTOTYPE.Modelstat + eps;

  counter = counter + 1;

  pp(p)   = no;
  ww(w)   = no;

  );
 );


* ---------------------------------  section 8 ----------------------------- *
*                      post-optimality writes to spreadsheet                 *
* -------------------------------------------------------------------------- *

parameter

* land

SWacres_p     (aguse,j,k,t,p,w)      surface water acreage by crop      (1000 ac \ yr)
GWacres_p     (aguse,j,k,t,p,w)      groundwater acreage   by crop      (1000 ac \ yr)
BTacres_p     (aguse,j,k,t,p,w)      backstop technology use            (1000 ac \ yr)
tacres_p      (aguse,j,k,t,p,w)      total acreage         by crop      (1000 ac \ yr)

gw_aq_acres_p (aqf,aguse,j,k,t,p,w)  total groundwater acres by c a     (1000 ac \ yr)

TSWacres_p    (aguse,  k,t,p,w)      Total SW acreage                   (1000 ac \ yr)
TGWacres_p    (aguse,  k,t,p,w)      Total GW acreage                   (1000 ac \ yr)
TBTacres_p    (aguse,  k,t,p,w)      Total BT acreage                   (1000 ac \ yr)
Ttacres_p     (aguse,  k,t,p,w)      Total total acreage                (1000 ac \ yr)
tacres_err_p  (aguse,j,k,t,p,w)      error in predicting tot acreage    (1000 ac \ yr)


* crops
Yield_opt_p    (aguse,j,k,t,p,w)     crop yield                         (tons \ ac)
yield_err_p    (aguse,j,k,t,p,w)     error in predicted crop yield      (tons \ ac)

* water stocks
wat_stocks_p     (res,    t,p,w)     stocks by pd                       (1000 af \ yr)
wat_stock0_p     (res,      p,w)     starting value                     (1000 af \ yr)
tot_wat_stocks_p (t,p,w)             total water stocks by year         (1000 af \ yr)
model_resid_p    (res,    t)         model residual                     (1000 af \ yr)

gw_stocks_p     (aqf,     t,p,w)     gw aquifer stocks by pd            (1000 af by year)
gw_stocks0_p    (aqf,       p,w)     gw aquifer starting stocks         (1000 af)
Aquifer_depth_p (aqf,     t,p,w)     gw aquifer depth                   (feet by year)

aquifer_recharge_m_p(     t,p,w)     flow: Mesilla aq rech over time   (1000 af \ yr)
aquifer_recharge_h_p(     t,p,w)     flow: Hueco  aq rech over time    (1000 af \ yr)

net_recharge_p       (aqf,t,p,w)     Flow: aquifer net recharge        (1000 af \ yr)

* water flows

Evaporation_p   (res,      t,p,w)    total evap by period               (1000 af \ yr)
precip_p        (res,      t,p,w)    total precip by period             (1000 af \ yr)
surf_area_p     (res,      t,p,w)    total surf area by period          (1000 ac \ yr)

inflows_p       (inflow,   t,p,w)    inflows by pd                      (1000 af \ yr)
tot_inflows_p   (          t,p,w)    total inflows over nodes by pd     (1000 af \ yr)

wat_flows_p     (i,        t,p,w)    flows by pd                        (1000 af \ yr)
tot_wat_flows_p (t,          p,w)    total surface flows                (1000 af \ yr)
Caballo_out_flows_p (river,t,p,w)   caballo flows by year               (1000 af \ yr)

MX_flows_p      (divert,   t,p,w)    us mexico treaty flows             (1000 af \ yr)
river_flows_p   (river,    t,p,w)    river flows by pd                  (1000 af \ yr)
total_river_flows_p (t,      p,w)    total river flows by yr            (1000 af \ yr)
diversions_p    (divert,   t,p,w)    surface diversions                 (1000 af \ yr)
total_diversions_p  (t,      p,w)    total surface divertions           (1000 af \ yr)
use_p           (use,      t,p,w)    surface water use                  (1000 af \ yr)
use_total_p     (t,          p,w)    total surface water use per year   (1000 af \ yr)
r_return_p      (r_return, t,p,w)    return flows from riv to river     (1000 af \ yr)
tot_rg_deliveries_p (t,        p,w)    total RG project deliveries      (1000 af \ yr)
outflows_p      (          t,p,w)    river system outflows              (1000 af \ yr

Ag_sw_use_jk_p  (aguse,j,k,t,p,w)    ag surface water use jk            (1000 af \ yr)
ag_use_jk_p     (aguse,j,k,t,p,w)

Ag_sw_use_pp    (aguse,    t,p,w)    ag surface water use               (1000 af \ yr)
ag_sw_divert_p  (agdivert, t,p,w)    ag surface water diversions        (1000 af \ yr)

tot_ag_pump_p   (aqf,aguse,    t,p,w) total ag pumping                  (1000 af \ yr)
ag_pump_p       (aqf,aguse,j,k,t,p,w) ag pumping                        (1000 af \ yr)

tot_ag_bt_use_p (          t,p,w)    total ag bt water use              (1000 af \ yr)
ag_bt_use_p     (aguse,    t,p,w)    ag backstop wate ruse              (1000 af \ yr)

a_div_riv_ret_p(agr_return,t,p,w)    ag river divert ret to river       (1000 af \ yr)

ag_use_p        (aguse,    t,p,w)    total ag use                       (1000 af \ yr)
ag_use_crop_p   (aguse,j,  t,p,w)    ag use by crop                     (1000 af \ yr)

sum_ag_pump_p   (          t,p,w)    sum of ag pumping over nodes       (1000 af \ yr)
sum_urb_pump_p  (          t,p,w)    sum of urban pumping over nodes    (1000 af \ yr)

a_return_p       (a_return, t,p,w)   ag return flows from riv to aq     (1000 af \ yr)

Ag_pump_aq_rch_p (aqf,aguse,t,p,w)    ag return from pumping to aquifer (1000 af \ yr)
urb_back_aq_rch_p(aqf,miuse,t,p,w)    urb return to aq from backstop t  (1000 af \ yr)

urb_use_pp      (miuse,    t,p,w)    urban water use                    (1000 af \ yr)
urb_sw_use_p    (miuse,    t,p,w)    urban surface water use            (1000 af \ yr)
urb_sw_divert_p (midivert, t,p,w)    urban surfacve water divertions    (1000 af \ yr)

urb_sw_a_ret_p (mia_return,t,p,w)    urban sw diversions return to aq   (1000 af \ yr)
urb_sw_r_ret_p( mir_return,t,p,w)    urban sw diversions return to rv   (1000 af \ yr)

urb_pump_p      (aqf,miuse,t,p,w)    urban water pumping                (1000 af \ yr)
urb_back_use_p  (miuse,    t,p,w)    urban backstop technology use      (1000 af \ yr)
total_urb_back_use_p     (t, p,w)    total urban backstop use by yr     (1000 af \ yr)

tot_pumping_p   (aqf,      t,p,w)    total pumping by aquifer           (1000 af \ yr)

* economics
urb_price_pp    (miuse,    t,p,w)    urban price                        ($ per af)
urb_con_surp_p  (miuse,    t,p,w)    urban consumer surplus             ($1000 \ yr)
urb_use_p_cap_p (miuse,    t,p,w)    urban use per capita               (af \ person)
urb_revenue_p   (miuse,    t,p,w)    urban revenue                      ($1000 \ yr)
urb_gross_ben_p (miuse,    t,p,w)    urban gross econ benefit           ($1000 \ yr)
urb_costs_p     (miuse,    t,p,w)    urban costs of prodn               ($1000 \ yr)
urb_av_tot_cost_p(miuse,   t,p,w)    urban ave costs of prodn           ($ per af)

urb_costs_x_bs_p (miuse,  t,p,w)     urban total costs excl backstop    ($1000 \ yr)
urb_use_x_bs_p  (miuse,   t,p,w)     urban water use excl backstop      (1000 af \ yr
urb_av_costs_x_bs_p(miuse,t,p,w)     urban ave cost excl backstop       ($ \ af)

urb_value_p     (miuse,    t,p,w)    urban total net benefit            ($1000 \ yr)
urb_value_af_p  (miuse,    t,p,w)    urban net value per unit water     ($ \ af)
urb_m_value_p   (miuse,    t,p,w)    urban marginal value               ($ per af)

Ag_value_p      (aguse,j,k,t,p,w)  ag net benefits by crop            ($1000 \ yr)
Ag_av_gw_costs_p(aguse,j,k,t,p,w)  ag ave gw pump costs               ($US   \ acre)
Ag_av_sw_costs_p(aguse,j,k,t,p,w)  ag ave sw delivery costs           ($US   \ acre)

ag_tot_sw_costs_p (aguse,j,k,t,p,w)  ag tot sw delivery costs           ($US 1000 \ yr)
ag_tot_gw_costs_p (aguse,j,k,t,p,w)  ag tot gw pump costs               ($1000 \  yr)

Ag_av_costs_p   (aguse,j,k,t,p,w)    ag ave costs per af                ($ \ af)
ag_costs_p      (aguse,j,k,t,p,w)    ag total costs                     ($1000 \ yr)

Tot_ag_ben_p    (          t,p,w)    total ag benefits over districts   ($1000 \ yr)

Farm_income_sw_p(aguse,j,k,t,p,w)    farm income from surface water     ($1000 \ yr)
Farm_income_gw_p(aguse,j,k,t,p,w)    farm income from groundwater       ($1000 \ yr)
Farm_income_bt_p(aguse,j,k,t,p,w)    farm income from backstop tech     ($1000 \ yr)

Netrev_acre_pp  (aguse,j,k,t,p,w)    endogenous net ag rev per acre     ($ \ acre  )
Netrev_af_pp    (aguse,j,k,t,p,w)    endogenous net ag rev per ac-ft    ($ \ af   )

Ag_m_value_p    (aguse,j,k,t,p,w)    ag marginal value of water         ($ \ af    )

rec_ben_p       (res,      t,p,w)    recreation benefit                 ($1000 \ yr)
env_ben_p       (river,    t,p,w)    environmental benefit from flows   ($1000 \ yr)

T_ag_ben_p      (            p,w)    total age benefits                 ($1000)
Env_ben_p       (river,    t,p,w)    Env benefits at stream gauges      ($1000 \ yr)
Tot_ben_p       (          t,p,w)    total benefits over uses           ($1000 \ yr)

Tot_urb_ben_p    (         t,p,w)    total urban net benefits           ($1000 \ yr)
Tot_env_riv_ben_p(         t,p,w)    total envir river benefits         ($1000 \ yr)
Tot_rec_res_ben_p(         t,p,w)    total rec reservoir benefits       ($1000 \ yr)

DNPV_import_costs_p(         p,w)    DNPV import costs                  ($1000 \ yr)
DNPV_export_costs_p(         p,w)    DNPV export costs                  ($1000 \ yr)

DNPV_ag_ben_p     (          p,w)    DNPV ag benefits                   ($1000)
DNPV_urb_ben_p    (          p,w)    DNPV urban benefits                ($1000)
DNPV_env_riv_ben_p(          p,w)    DNPV environmental river benefits  ($1000)
DNPV_rec_res_ben_p(          p,w)    DNPV reservoir recreation benefits ($1000)

DNPV_ben_p      (            p,w)    disc net present value of benefits ($1000)

Ag_Ben_p        (aguse,    t,p,w)    ag benefits                        ($1000 \ yr)
Ag_value_p      (aguse,j,k,t,p,w)    ag benefits by crop                ($1000 \ yr)

Q_term_shad_pr_p(aqf,      t,p,w)     shad price terminal aquifer level  (1000 af)
;

*stocks

*surface reservoir storage
wat_stocks_p  (res,      t,p,w)   =          Z_v.l    (res,      t,p,w)  + eps;
tot_wat_stocks_p (t,p,w)          =          sum(res, wat_stocks_p(res, t, p, w + eps)); // added LG 3/5/18

wat_stock0_p  (res,        p,w)   =          Z0_p     (res,        p              )  + eps;

*groundwater aquifer storage treated like a simple underground reservoir
gw_stocks_p   (aqf,      t,p,w)   =          Q_v.l    (aqf,       t,p,w)  + eps;
gw_stocks0_p  (aqf,        p,w)   =          Q0_p     (aqf                         )  + eps;



aquifer_recharge_m_p(    t,p,w)   =  aquifer_recharge_m_v.l(      t,p,w)  + eps;
aquifer_recharge_h_p(    t,p,w)   =  aquifer_recharge_h_v.l(      t,p,w)  + eps;

net_recharge_p      (aqf,t,p,w)   =  net_recharge_v.l        (aqf,t,p,w)  + eps;


Aquifer_depth_p(aqf,     t,p,w)   =  Aquifer_depth_v.l(aqf,       t,p,w)  + eps;

*flows
inflows_p     (inflow,   t,p,w)   =          X_v.l    (inflow,    t,p,w)  + eps;
tot_inflows_p (          t,p,w)   =   sum(inflow, source_p(inflow,t,  w))  + eps;

river_flows_p (river,    t,p,w)   =          X_v.l    (river,     t,p,w)  + eps;
total_river_flows_p (t,      p,w) =   sum(river,river_flows_p (river,t,p,w)) + eps;
diversions_p  (divert,   t,p,w)   =          X_v.l    (divert,    t,p,w)  + eps;
total_diversions_p  (t,    p,w)   =   sum(divert, diversions_p  (divert,   t,p,w)) + eps;
use_p         (use,      t,p,w)   =          X_v.l    (use,       t,p,w)  + eps;
use_total_p   (t,          p,w)   =   sum(use, use_p  (use,   t,p,w)) + eps;
r_return_p    (r_return, t,p,w)   =          X_v.l    (r_return,  t,p,w)  + eps;

wat_flows_p   (i,        t,p,w)   =          X_v.l    (i,         t,p,w)  + eps;
tot_wat_flows_p (t, p, w)         =      sum(i, wat_flows_p(i, t, p, w))  + eps; //added LG 3/5/18
MX_flows_p    ('MXID_d_f',t,p,w)  =          X_v.l   ('MXID_d_f', t,p,w)  + eps;

Caballo_out_flows_p    ('RG_Caballo_out_v_f',t,p,w)  =          X_v.l   ('RG_Caballo_out_v_f', t,p,w)  + eps; //added
tot_rg_deliveries_p (t,        p,w) =     sum(river, Caballo_out_flows_p(river, t, p, w))+ eps; //added

outflows_p    (          t,p,w)   = X_v.l   ('RG_below_EPID_v_f', t,p,w)  + eps;

urb_use_pp    (miuse,    t,p,w)   =     urb_use_v.l   (miuse,     t,p,w)  + eps;
urb_sw_use_p  (miuse,    t,p,w)   =           X_v.l   (miuse,     t,p,w)  + eps;
urb_sw_divert_p(midivert,t,p,w)   =           X_v.l   (midivert,  t,p,w)  + eps;

urb_sw_a_ret_p(mia_return,t,p,w)  =           X_v.l   (mia_return,t,p,w)  + eps;
urb_sw_r_ret_p(mir_return,t,p,w)  =           X_v.l   (mir_return,t,p,w)  + eps;

urb_pump_p    (aqf,miuse,t,p,w)   =    urb_pump_v.l   (aqf,miuse, t,p,w)  + eps;
urb_back_use_p(miuse,    t,p,w)   = urb_back_use_v.l  (miuse,     t,p,w)  + eps;   // urb use of backstop technology
total_urb_back_use_p   ( t,p,w)   =   sum(miuse, urb_back_use_p(miuse,    t,p,w)) + eps; //added LG 3/5/18

ag_sw_use_pp  (aguse,    t,p,w)   =           X_v.l   (aguse,     t,p,w)  + eps;

ag_sw_divert_p(agdivert,t,p,w)   =            X_v.l   (agdivert,  t,p,w)  + eps;

tot_ag_pump_p (aqf,aguse,t,p,w)   = tot_ag_pump_v.l   (aqf,aguse, t,p,w)  + eps;

ag_pump_p     (aqf,aguse,j,k,t,p,w) =  ag_pump_v.l    (aqf,aguse,j,k,t,p,w) + eps;

ag_use_p      (aguse,    t,p,w)   =      ag_use_v.l   (aguse,     t,p,w)  + eps;  // total ag use
ag_use_crop_p (aguse,j,  t,p,w)   =   sum(k, ag_use_crop_v.l (aguse,j,k, t,p,w))  + eps;

Ag_sw_use_jk_p(aguse,j,k,t,p,w)  = Ag_sw_use_jk_v.l(aguse,j,k,t,p,w) + eps;
ag_use_jk_p   (aguse,j,k,t,p,w)  = ag_use_jk_v.l   (aguse,j,k,t,p,w) + eps;

tot_ag_bt_use_p(         t,p,w) = sum((j,k,aguse), ag_back_use_v.l(aguse,j,k,t,p,w)) + eps;

ag_bt_use_p    (aguse,   t,p,w) = sum((j,k),       ag_back_use_v.l(aguse,j,k,t,p,w)) + eps;

sum_ag_pump_p (          t,p,w)   =  sum_ag_pump_v.l  (           t,p,w)  + eps;
sum_urb_pump_p(          t,p,w)   = sum_urb_pump_v.l  (           t,p,w)  + eps;

a_return_p     (aga_return,t,p,w)  = aga_returns_v.l   (aga_return,t,p,w) + eps;
a_div_riv_ret_p(agr_return,t,p,w)  = X_v.l             (agr_return,t,p,w) + eps;

Ag_pump_aq_rch_p( aqf,aguse,t,p,w)  = Ag_pump_aq_rch_v.l(aqf,aguse, t,p,w) + eps;
urb_back_aq_rch_p(aqf,miuse,t,p,w) = urb_back_aq_rch_v.l(aqf,miuse,t,p,w) + eps;

Tot_pumping_p(aqf,      t,p,w) = sum(aguse, tot_ag_pump_v.l(aqf,aguse,t,p,w))
                                           + sum(miuse,    urb_pump_v.l(aqf,miuse,t,p,w)) + eps;

Evaporation_p (res,     t,p,w)    =    Evaporation_v.l(res,       t,p,w)  + eps;
Precip_p      (res,     t,p,w)    =         Precip_v.l(res,       t,p,w)  + eps;

surf_area_p   (res,     t,p,w)    =     surf_area_v.l (res,       t,p,w)  + eps;

* land
SWacres_p     (aguse,j,k,t,p,w)   =    SWacres_v.l    (aguse, j,k,t,p,w)  + eps;
GWacres_p     (aguse,j,k,t,p,w)   =    GWacres_v.l    (aguse, j,k,t,p,w)  + eps;
BTacres_p     (aguse,j,k,t,p,w)   =    BTacres_v.l    (aguse, j,k,t,p,w)  + eps;

gw_aq_acres_p(aqf,aguse,j,k,t,p,w) =  gw_aq_acres_v.l(aqf,aguse,j,k,t,p,w) + eps;


tacres_p      (aguse,j,k,t,p,w)   =    tacres_v.l     (aguse, j,k,t,p,w)  + eps;
tacres_err_p  (aguse,j,k,t,p,w)   =    tacres_v.l     (aguse, j,k,t,p,w)
                                                -  land_p         (aguse, j,k,t                )  + eps;    // error in baseline predicted acreage

TSWacres_p    (aguse,  k,t,p,w)   =   sum(j, SWacres_p(aguse, j,k,t,p,w)) + eps;
TGWacres_p    (aguse,  k,t,p,w)   =   sum(j, GWacres_p(aguse, j,k,t,p,w)) + eps;
TBTacres_p    (aguse,  k,t,p,w)   =   sum(j, BTacres_p(aguse, j,k,t,p,w)) + eps;

Ttacres_p     (aguse,  k,t,p,w)   =   sum(j,  tacres_p(aguse, j,k,t,p,w)) + eps;

* crops
Yield_opt_p   (aguse,j,k,t,p,w)   =         Yield_v.l (aguse,j,k,t,p, w)  + eps;
yield_err_p   (aguse,j,k,t,p,w)   =         Yield_v.l (aguse,j,k,t,p, w)
                                                      - yield_p   (aguse,j,k                   )  + eps;

* urban benefits and related

urb_price_pp   (miuse,   t,p,w)   =    urb_price_v.l    (miuse,  t,p,w)  + eps;
urb_con_surp_p (miuse,   t,p,w)   =    urb_con_surp_v.l (miuse,  t,p,w)  + eps;
urb_use_p_cap_p(miuse,   t,p,w)   =    urb_use_p_cap_v.l(miuse,  t,p,w)  + eps;
urb_revenue_p  (miuse,   t,p,w)   =    urb_revenue_v.l  (miuse,  t,p,w)  + eps;
urb_gross_ben_p(miuse,   t,p,w)   =    urb_gross_ben_v.l(miuse,  t,p,w)  + eps;
urb_costs_p    (miuse,   t,p,w)   =    urb_costs_v.l    (miuse,  t,p,w)  + eps;
urb_av_tot_cost_p(miuse, t,p,w)   =  urb_av_tot_cost_v.l(miuse,  t,p,w)  + eps;

urb_use_x_bs_p (miuse,   t,p,w)   =  urb_use_v.l     (miuse,t,p,w)
                                               - urb_back_use_v.l(miuse,t,p,w)       + eps;

urb_costs_x_bs_p(miuse,  t,p,w)   =   urb_costs_x_bs_v.l(miuse,  t,p,w) + eps;

urb_av_costs_x_bs_p(miuse,t,p,w)  =   (.001 + urb_costs_x_bs_p(miuse,t,p,w)) /
                                                  (.001 +   urb_use_x_bs_p(miuse,t,p,w)) + eps;

urb_value_p    (miuse,   t,p,w)   =    urb_value_v.l    (miuse,  t,p,w)  + eps;

urb_value_af_p (miuse,   t,p,w)   =    urb_value_af_v.l (miuse,  t,p,w)  + eps;

urb_m_value_p  (miuse,   t,p,w)   =  urb_m_value_v.l    (miuse,  t,p,w)  + eps;

* ag benefits and related

ag_costs_p        (aguse,j,k,t,p,w) =      ag_costs_v.l  (aguse,j,k,t,p,w) + eps;
Ag_av_costs_p     (aguse,j,k,t,p,w) =   Ag_av_costs_v.l  (aguse,j,k,t,p,w) + eps;

ag_av_sw_costs_p  (aguse,j,k,t,p,w) =    Ag_av_sw_costs_v.l  (aguse,j,k,t,p,w) + eps;
Ag_av_gw_costs_p  (aguse,j,k,t,p,w) =    Ag_av_gw_costs_v.l  (aguse,j,k,t,p,w) + eps;

ag_tot_sw_costs_p (aguse,j,k,t,p,w) =   ag_tot_sw_costs_v.l (aguse,j,k,t,p,w) + eps;
ag_tot_gw_costs_p (aguse,j,k,t,p,w) =   ag_tot_gw_costs_v.l (aguse,j,k,t,p,w) + eps;

Netrev_acre_pp(aguse,j,k,t,p,w)  =    Netrev_acre_v.l(aguse, j,k,t,p,w)  + eps;

Netrev_af_pp  (aguse,j,k,t,p,w)  =    Netrev_af_v.l  (aguse, j,k,t,p,w)  + eps;

Ag_Ben_p    (aguse,    t,p,w)   =        Ag_Ben_v.l  (aguse,     t,p,w)  + eps;

Ag_value_p  (aguse,j,k,t,p,w)   =        Ag_value_v.l(aguse, j,k,t,p,w)  + eps;

Tot_ag_ben_p(          t,p,w)   =       Tot_ag_ben_v.l(          t,p,w)  + eps;

Ag_m_value_p(aguse,j,k,t,p,w)   =      Ag_m_value_v.l(aguse, j,k,t,p,w)  + eps;

* environmental benefits from streamflow

Env_ben_p('RG_below_EPID_v_f',t,p,w) = Env_ben_v.l('RG_below_EPID_v_f', t,p,w)  + eps;

*  rec benefits from reservoir storage

rec_ben_p   (res,      t,p,w)   =          rec_ben_v.l(res,      t,p,w)  + eps;

* total benefits by use category

Tot_ag_ben_p     (t,p,w)        =        Tot_ag_ben_v.l     (t,p,w)      + eps;
Tot_urb_ben_p    (t,p,w)        =        Tot_urb_ben_v.l    (t,p,w)      + eps;
Tot_env_riv_ben_p(t,p,w)        =        Tot_env_riv_ben_v.l(t,p,w)      + eps;
Tot_rec_res_ben_p(t,p,w)        =        Tot_rec_res_ben_v.l(t,p,w)      + eps;

Tot_ben_p   (          t,p,w)   =           Tot_ben_v.l(         t,p,w)  + eps;

DNPV_import_costs_p(p,w)        =        DNPV_import_costs_v.l(p,w)      + eps;
DNPV_export_costs_p(p,w)        =        DNPV_export_costs_v.l(p,w)      + eps;

DNPV_ag_ben_p     ( p,w)        =            DNPV_ag_ben_v.l(  p,w)       + eps;
DNPV_urb_ben_p    ( p,w)        =           DNPV_urb_ben_v.l(  p,w)       + eps;
DNPV_env_riv_ben_p( p,w)        =       DNPV_env_riv_ben_v.l(  p,w)       + eps;
DNPV_rec_res_ben_p( p,w)        =       DNPV_rec_res_ben_v.l(  p,w)       + eps;

DNPV_ben_p             (p,w)    =            DNPV_ben_v.l         (p,w)  + eps;


Ag_value_p  (aguse,j,k,t,p,w)   =        Ag_value_v.l(aguse, j,k,t,p,w)   + eps;
Ag_Ben_p    (aguse,    t,p,w)   =          Ag_Ben_v.l(aguse,     t,p,w)   + eps;


*ag income from various water sources


Farm_income_sw_p(aguse,j,k,t,p,w) =
                                                          price_p     (aguse,j)
                                                        * Yield_v.l   (aguse,j,k,t,p,w)
                                                        * SWacres_v.l (aguse,j,k,t,p,w)

                                                 - ag_tot_sw_costs_v.l(aguse,j,k,t,p,w) + eps;

Farm_income_gw_p(aguse,j,k,t,p,w)  =
                                                          price_p     (aguse,j)
                                                        * Yield_v.l   (aguse,j,k,t,p,w)
                                                        * GWacres_v.l (aguse,j,k,t,p,w)

                                                - ag_tot_gw_costs_v.l( aguse,j,k,t,p,w) + eps;

Farm_income_bt_p(aguse,j,k,t,p,w) =
                                                          price_p     (aguse,j)
                                                         * Yield_v.l  (aguse,j,k,t,p,w)
                                                         * BTacres_v.l(aguse,j,k,t,p,w)

                                                 - ag_tot_bt_costs_v.l( aguse,j,k,t,p,w) + eps;

* shadow prices for protection and bt use
  shad_price_res_p(res,tlast,p,w) = Z_v.m  (res,tlast,p,w)  + eps;   // shadow prices lower bound terminal condition reservoir storage all conditions
  shad_price_aqf_p(aqf,tlast,p,w) = Q_v.m  (aqf,tlast,p,w)  + eps;   // shadow prices lower bound terminal condition aquifer storage all conditions
  shad_price_urb_back_use_p(miuse,    t,p,w)      =  urb_back_use_v.m(miuse,    t,p,w) + eps;
  shad_price_ag_back_use_p (aguse,j,k,t,p,w)      =  ag_back_use_v.m (aguse,j,k,t,p,w) + eps;

*----------------------* Filtered Output Parameters *----------------*

singleton sets
* Changes to use or not use operating agrrement. Use of operating agreement breaks the model on wet climate scenario.

p2(p) / 1-policy_wi_2008_po / // with operating agreement
w2(w) / 1_Selected_Inflows /  // climate scenario is one data set now, injected externally on swim, hardcoded here for observed + extended drought
;

*---------------------------------- Output Parameter Declarations ---------------------------------------*
parameter
   evaporation(res,t)
   water_flows(i,t)
   water_stocks(res,t)
   river_flows(river,t)
   diversions(divert,t)
   SWacres(aguse,j,k,t)
   GWacres(aguse,j,k,t)
   surf_use(use,t)
   r_return_o(r_return, t)
   urb_price(miuse,t)
   urb_con_surp(miuse,t)
   urb_use_p_cap(miuse,t)
   ag_value(aguse,j,k,t)
   ag_ben(aguse,t)
   ag_m_value(aguse,j,k,t)
   yield(aguse,j,k,t)
   ag_sw_use(aguse,t)
   urb_pump(aqf,miuse,t)
   urb_sw_use(miuse,t)
   urb_revenue(miuse,t)
   urb_gross_ben(miuse,t)
   urb_costs(miuse,t)
   urb_value(miuse,t)
   urb_value_af(miuse,t)
   urb_use(miuse,t)
   urb_m_value(miuse,t)
   surf_area(res,t)
   env_ben(river,t)
   tot_ben(t)
   rec_ben(res,t)
   tot_ag_pump(aqf,aguse,t)
   gw_stocks(aqf,t)
   aquifer_depth(aqf,t)
   a_return_o(a_return, t)
   ag_pump_aq_rch(aqf,aguse,t)
   precip(res,t)
   tacres(aguse,j,k,t)
   tswacres(aguse,k,t)
   tgwacres(aguse,k,t)
   ttacres(aguse,k,t)
   urb_back_use(miuse,t)
   urb_back_aq_rch(aqf,miuse,t)
   dnpv_ben
   tot_inflows(t)
   tot_wat_stocks(t)
   tot_wat_flows(t)
   tot_rg_deliveries(t)
   tot_diversions(t)
   tot_swuse(t)
   tot_riverflows(t)
   tot_agpumping(t)
   tot_urbpumping(t)
   tot_urbbackuse(t)
   mx_flows(divert, t)
   tot_agbenp(t)
   tot_urbbenp(t)
   tot_envbenp(t)
   tot_recben(t)
   total_ag_ben
   DNPV_import_costs
   DNPV_export_costs
   DNPV_ag_ben
   DNPV_urb_ben
   DNPV_env_riv_ben
   DNPV_rec_res_ben
   Farm_income_sw(aguse,j,k,t)
   Farm_income_gw(aguse,j,k,t)
   Farm_income_bt(aguse,j,k,t)
   shad_price_res(res,t)
   shad_price_aqf(aqf,t)
   shad_price_urb_back_use(miuse,t)
   shad_price_ag_back_use(aguse,j,k,t)
   net_recharge(aqf,t)
   tot_ag_bt_use(t)
   ag_use(aguse,t)

;

*---------------------------------- GDX output of one p and w combination -------------------------------*

evaporation(res,t) $ tlater(t) = Evaporation_p(res,t,p2,w2);
water_flows(i,t) $ tlater(t) = wat_flows_p(i,t,p2,w2);
water_stocks(res,t) $ tlater(t)  =  wat_stocks_p(res,t,p2,w2);
river_flows(river,t) $ tlater(t) =  river_flows_p(river,t, p2, w2);
diversions(divert,t)$ tlater(t) = diversions_p(divert,t,p2,w2);
SWacres(aguse,j,k,t)$ tlater(t) = SWacres_p(aguse,j,k,t,p2,w2);
GWacres(aguse,j,k,t)$ tlater(t) = GWacres_p(aguse,j,k,t,p2,w2);
surf_use(use,t) $ tlater(t) = use_p(use,t,p2,w2);
r_return_o(r_return, t) = r_return_p(r_return,t,p2,w2);
urb_price(miuse,t) $ tlater(t) = urb_price_pp(miuse,t,p2,w2);
urb_con_surp(miuse,t) $ tlater(t) = urb_con_surp_p(miuse,t,p2,w2);
urb_use_p_cap(miuse,t) $ tlater(t) = urb_use_p_cap_p(miuse,t,p2,w2);
ag_value(aguse,j,k,t) $ tlater(t) =  Ag_value_p(aguse,j,k,t,p2,w2);
ag_ben(aguse,t) $ tlater(t) = Ag_Ben_p(aguse,t,p2,w2);
ag_m_value(aguse,j,k,t) $ tlater(t) = Ag_m_value_p(aguse,j,k,t,p2,w2);
yield(aguse,j,k,t) $ tlater(t) = Yield_opt_p(aguse,j,k,t,p2,w2);
ag_sw_use(aguse,t) $ tlater(t) = Ag_sw_use_pp(aguse,t,p2,w2);
urb_pump(aqf,miuse,t) $ tlater(t) = urb_pump_p(aqf,miuse,t,p2,w2);
urb_sw_use(miuse,t) $ tlater(t) = urb_sw_use_p(miuse,t,p2,w2);
urb_revenue(miuse,t) $ tlater(t) = urb_revenue_p(miuse,t,p2,w2);
urb_gross_ben(miuse,t) $ tlater(t) = urb_gross_ben_p (miuse,t,p2,w2);
urb_costs(miuse,t) $ tlater(t) = urb_costs_p(miuse,t,p2,w2);
urb_value(miuse,t)$ tlater(t)= urb_value_p(miuse,t,p2,w2);
urb_value_af(miuse,t)$ tlater(t) = urb_value_af_p(miuse,t,p2,w2);
urb_use(miuse,t) $ tlater(t) = urb_use_pp(miuse,t,p2,w2);
urb_m_value(miuse,t) $ tlater(t)= urb_m_value_p(miuse,t,p2,w2);
surf_area(res,t)$ tlater(t) = surf_area_p(res,t,p2,w2);
env_ben(river,t) $ tlater(t) = env_ben_p(river,t,p2,w2);
tot_ben(t) $ tlater(t) = Tot_ben_p(t,p2,w2);
rec_ben(res,t) $ tlater(t) = rec_ben_p(res,t,p2,w2);
tot_ag_pump(aqf,aguse,t) $ tlater(t) = tot_ag_pump_p(aqf,aguse,t,p2,w2);
gw_stocks(aqf,t) $ tlater(t)= gw_stocks_p(aqf,t,p2,w2);
aquifer_depth(aqf,t) $ tlater(t) = Aquifer_depth_p(aqf,t,p2,w2);
a_return_o(a_return, t) $ tlater(t) = a_return_p(a_return, t,p2,w2);
ag_pump_aq_rch(aqf,aguse,t) $ tlater(t) = Ag_pump_aq_rch_p(aqf,aguse,t,p2,w2);
precip(res,t) $ tlater(t)= precip_p(res,t,p2,w2);
tacres(aguse,j,k,t)$ tlater(t) = tacres_p(aguse,j,k,t,p2,w2);
tswacres(aguse,k,t)$ tlater(t) = TSWacres_p(aguse,k,t,p2,w2);
tgwacres(aguse,k,t)$ tlater(t) = TGWacres_p(aguse,k,t,p2,w2);
ttacres(aguse,k,t)$ tlater(t) = Ttacres_p(aguse,k,t,p2,w2);
urb_back_use(miuse,t)$ tlater(t) = urb_back_use_p(miuse,t,p2,w2);
urb_back_aq_rch(aqf,miuse,t) $ tlater(t) = urb_back_aq_rch_p(aqf,miuse,t,p2,w2);
dnpv_ben = DNPV_ben_p(p2,w2);
tot_inflows(t)$ tlater(t) = tot_inflows_p(t,p2,w2);
tot_wat_stocks(t)$ tlater(t) = tot_wat_stocks_p(t, p2, w2);
tot_wat_flows(t)$ tlater(t) =  tot_wat_flows_p(t, p2, w2);
tot_rg_deliveries(t)$ tlater(t) = tot_rg_deliveries_p(t, p2, w2);
tot_diversions(t)$ tlater(t) =  total_diversions_p(t,p2,w2);
tot_swuse(t)$ tlater(t) = use_total_p(t,p2,w2);
tot_riverflows(t)$ tlater(t) = total_river_flows_p(t,p2,w2);
tot_agpumping(t)$ tlater(t) = sum_ag_pump_p(t,p2,w2);
tot_urbpumping(t)$ tlater(t)  = sum_urb_pump_p(t,p2,w2);
tot_urbbackuse(t)$ tlater(t) = total_urb_back_use_p(t,p2,w2);
mx_flows(divert, t)$ tlater(t) =  MX_flows_p(divert,t,p2,w2);
tot_agbenp(t)$ tlater(t) = Tot_ag_ben_p(t,p2,w2);
tot_urbbenp(t) $ tlater(t)= Tot_urb_ben_p(t,p2,w2);
tot_envbenp(t)$ tlater(t) = Tot_env_riv_ben_p(t,p2,w2);
tot_recben(t)$ tlater(t) = Tot_rec_res_ben_p(t,p2,w2);
tot_agbenp(t)$ tlater(t) = Tot_ag_ben_p(t,p2,w2);

*------------- new outputs ---------------*
DNPV_import_costs = DNPV_import_costs_p(p2,w2);
DNPV_export_costs = DNPV_export_costs_p(p2,w2);
DNPV_ag_ben = DNPV_ag_ben_p(p2,w2);
DNPV_urb_ben = DNPV_urb_ben_p(p2,w2);
DNPV_env_riv_ben = DNPV_env_riv_ben_p(p2,w2);
DNPV_rec_res_ben = DNPV_rec_res_ben_p(p2,w2);
Farm_income_sw(aguse,j,k,t)$ tlater(t) = Farm_income_sw_p(aguse,j,k,t,p2,w2);
Farm_income_gw(aguse,j,k,t)$ tlater(t) = Farm_income_gw_p(aguse,j,k,t,p2,w2);
Farm_income_bt(aguse,j,k,t)$ tlater(t) = Farm_income_bt_p(aguse,j,k,t,p2,w2);
shad_price_aqf(aqf,t)$ tlater(t) = shad_price_aqf_p(aqf,t,p2,w2);
shad_price_res(res,t)$ tlater(t) =  shad_price_res_p(res,t,p2,w2);
shad_price_urb_back_use(miuse,t)$ tlater(t)  = shad_price_urb_back_use_p(miuse,t,p2,w2);
shad_price_ag_back_use(aguse,j,k,t)$ tlater(t)  =  shad_price_ag_back_use_p (aguse,j,k,t,p2,w2) ;
net_recharge(aqf,t) $ tlater(t) = net_recharge_p(aqf,t,p2,w2);
tot_ag_bt_use(t)$ tlater(t) =  tot_ag_bt_use_p(t,p2,w2);
ag_use(aguse,t)$ tlater(t) = ag_use_p(aguse,t,p2,w2);

*------------- average values ---------------*
* All average summary values are now calculated directly on the SWIM interface

*---------------------------------Onload to GDX file ----------------------------------------------------*


execute_unload "swim.gdx"

evaporation, water_flows, water_stocks, river_flows, diversions, SWacres, GWacres, surf_use, r_return_o, urb_price,
urb_con_surp, urb_use_p_cap, ag_value, ag_ben, ag_m_value, yield, ag_sw_use, urb_pump, urb_sw_use, urb_revenue, urb_gross_ben, urb_costs, urb_value,
urb_value_af, urb_use, urb_m_value, surf_area, env_ben, tot_ben, rec_ben, tot_ag_pump, gw_stocks, aquifer_depth, a_return_o, ag_pump_aq_rch,
precip, tacres, tswacres, tgwacres, ttacres, urb_back_use, urb_back_aq_rch, dnpv_ben, mx_flows,
river_flows_p, tot_agpumping, tot_urbpumping, tot_wat_flows, sum_ag_pump_p, source_p, tot_urbbenp,
DNPV_import_costs, DNPV_export_costs, DNPV_ag_ben, DNPV_urb_ben, DNPV_env_riv_ben, DNPV_rec_res_ben, Farm_income_sw, Farm_income_gw, Farm_income_bt,
net_recharge, tot_ag_bt_use, ag_use, shad_price_res, shad_price_aqf, shad_price_urb_back_use, shad_price_ag_back_use
rho_p, backstop_cost_p, Yield_p, Price_p, lan_p, Ba_divert_p, Ba_use_p, Bar_return_p, Baa_return_p, Bag_pump_aqf_return_p, Cost_p, ag_av_gw_cost_p, ag_av_back_cost0_p,
cost_af_flow_import_p, cost_af_flow_export_p, elas_p, urb_av_back_cost0_p, tx_proj_op_p, source_p, us_mx_1906_p, precip_rate_p, evap_rat_p, z_p, gaugeflow_p,
ag_gw_pump_capacity_p, recharge_p, qmax_p, porosity_p, ag_back_cost_grow_p, urb_back_cost_grow_p, LANDRHS_p, gw_sustain_p, sw_sustain_p, pop0_p, z0_p, aq_area_p,
Burb_back_aqf_rch_p, precip_rate_p, zmax_p, depth0_p, urb_cost_grow_p, urb_av_gw_cost0_p, urb_Av_cost0_p, urb_price_p, urb_gw_pump_capacity_p, SW_Treat_capac_p, rho_pop_p, urb_use_p
urb_gw_cost_grow_p;

$onecho > gdxxrwout.txt

i=swim.gdx
o=swim.xlsx

epsout = 0

*----------------------------------------------------------------------*
* INPUT DATA READ AND DISPLAYED ON SWIM INTERFACE
*----------------------------------------------------------------------*

par=ag_av_gw_cost_p          rng = par_ag_av_gw_cost!B2          cdim = 0
par=ag_gw_pump_capacity_p    rng = par_ag_gw_pump_capacity!B2    cdim = 0
par=ag_av_back_cost0_p       rng = par_ag_av_back_cost0!B2       cdim = 0
par=gaugeflow_p              rng = par_gaugeflow!B2              cdim = 0
par=recharge_p               rng = par_recharge!B2               cdim = 0
par=source_p                 rng = par_source!B2                 cdim = 0
par=qmax_p                   rng = par_qmax!B2                   cdim = 0
par=porosity_p               rng = par_porosity!B2               cdim = 0
par=ag_back_cost_grow_p      rng = par_ag_back_cost_grow!B2      cdim = 0
par=urb_back_cost_grow_p     rng = par_urb_back_cost_grow!B2     cdim = 0
par=Cost_p                   rng = par_Cost!B2                   cdim = 0
par=LANDRHS_p                rng = par_LANDRHS!B2                cdim = 0
par=gw_sustain_p             rng = par_gw_sustain!B2             cdim = 0
par=sw_sustain_p             rng = par_sw_sustain!B2             cdim = 0
par=pop0_p                   rng = par_pop0!B2                   cdim = 0
par=z0_p                     rng = par_z0!B2                     cdim = 0
par=aq_area_p                rng = par_aq_area!B2                cdim = 0
par=Price_p                  rng = par_Price!B2                  cdim = 0
par=Yield_p                  rng = par_Yield!B2                  cdim = 0
par=lan_p                    rng = par_lan!B2                    cdim = 0
par=us_mx_1906_p             rng = par_us_mx_1906!B2             cdim = 0
par=Bag_pump_aqf_return_p    rng = par_Bag_pump_aqf_return!B2    cdim = 0
par=Burb_back_aqf_rch_p      rng = par_Burb_back_aqf_rch!B2      cdim = 0
par=evap_rat_p               rng = par_evap_rat!B2               cdim = 0
par=precip_rate_p            rng = par_precip_rat!B2             cdim = 0
par=zmax_p                   rng = par_zmax!B2                   cdim = 0
par=z_p                      rng = par_z!B2                      cdim = 0
par=depth0_p                 rng = par_depth0!B2                 cdim = 0
par=tx_proj_op_p             rng = par_tx_proj_op!B2             cdim = 0
par=urb_cost_grow_p          rng = par_urb_cost_grow!B2          cdim = 0
par=urb_av_gw_cost0_p        rng = par_urb_av_gw_cost0!B2        cdim = 0
par=urb_gw_cost_grow_p       rng = par_urb_gw_cost_grow!B2       cdim = 0
par=urb_Av_cost0_p           rng = par_urb_Av_cost0!B2           cdim = 0
par=urb_price_p              rng = par_urb_price_p!B2            cdim = 0
par=urb_gw_pump_capacity_p   rng = par_urb_gw_pump_capacity!B2   cdim = 0
par=urb_av_back_cost0_p      rng = par_urb_av_back_cost0!B2      cdim = 0
par=SW_Treat_capac_p         rng = par_SW_Treat_capac_p!B2       cdim = 0
par=rho_pop_p                rng = par_rho_pop_p!B2              cdim = 0
par=urb_use_p                rng = par_urb_use_p!B2              cdim = 0
par=elas_p                   rng = par_elas_p!B2                 cdim = 0

*------------------ END OF DATA READ BY MODEL --------------------------*


*-----------------------------------------------------------------------*
* MODEL-OPTIMIZED RESULTS DISPLAYED ON SWIM INTERFACE  (59 outputs)
*------------------------------------------------------------------------

par=DNPV_ag_ben          rng = var_DNPV_ag_ben!B2                cdim = 0
par=ag_m_value           rng = var_ag_m_value!B2                 cdim = 0
par=ag_value             rng = var_ag_value!B2                   cdim = 0
par=a_return_o           rng = var_a_return_o!B2                 cdim = 0
par=ag_pump_aq_rch       rng = var_ag_pump_aq_rch!B2             cdim = 0
par=tot_ag_bt_use        rng = var_tot_ag_bt_use!B2              cdim = 0
par=ag_sw_use            rng = var_ag_sw_use!B2                  cdim = 0
par=ag_use               rng = var_ag_use!B2                     cdim = 0
par=aquifer_depth        rng = var_aquifer_depth!B2              cdim = 0
par=GWacres              rng = var_GWacres!B2                    cdim = 0
par=shad_price_aqf       rng = var_shad_price_aqf!B2             cdim = 0
par=yield                rng = var_yield!B2                      cdim = 0
par=env_ben              rng = var_env_ben!B2                    cdim = 0
par=DNPV_env_riv_ben     rng = var_DNPV_env_riv_ben!B2           cdim = 0
par=evaporation          rng = var_evaporation!B2                cdim = 0
par=DNPV_export_costs    rng = var_DNPV_export_costs!B2          cdim = 0
par=ag_ben               rng = var_ag_ben!B2                     cdim = 0
par=Farm_income_gw       rng = var_Farm_income_gw!B2             cdim = 0
par=gw_stocks            rng = var_gw_stocks!B2                  cdim = 0
par=DNPV_import_costs    rng = var_DNPV_import_costs!B2          cdim = 0
par=net_recharge         rng = var_net_recharge!B2               cdim = 0
par=shad_price_ag_back_use  rng = var_shad_price_ag_back_use!B2  cdim = 0
par=shad_price_urb_back_use rng = var_shad_price_urb_back_use!B2 cdim = 0
par=rec_ben              rng = var_rec_ben!B2                    cdim = 0
par=shad_price_res       rng = var_shad_price_res!B2             cdim = 0
par=DNPV_rec_res_ben     rng = var_DNPV_rec_res_ben!B2           cdim = 0
par=r_return_o           rng = var_r_return_o!B2                 cdim = 0
par=river_flows          rng = var_river_flows!B2                cdim = 0
par=Farm_income_bt       rng = var_Farm_income_bt!B2             cdim = 0
par=SWacres              rng = var_SWacres!B2                    cdim = 0
par=Farm_income_sw       rng = var_Farm_income_sw!B2             cdim = 0
par=water_stocks         rng = var_water_stocks!B2               cdim = 0
par=surf_use             rng = var_surf_use!B2                   cdim = 0
par=ttacres              rng = var_ttacres!B2                    cdim = 0
par=tacres               rng = var_tacres!B2                     cdim = 0
par=tot_ben              rng = var_tot_ben!B2                    cdim = 0
par=tot_ag_pump          rng = var_tot_ag_pump!B2                cdim = 0
par=dnpv_ben             rng = var_dnpv_ben!B2                   cdim = 0
par=tgwacres             rng = var_tgwacres!B2                   cdim = 0
par=precip               rng = var_precip!B2                     cdim = 0
par=tswacres             rng = var_tswacres!B2                   cdim = 0
par=surf_area            rng = var_surf_area!B2                  cdim = 0
par=DNPV_urb_ben         rng = var_DNPV_urb_ben!B2               cdim = 0
par=urb_con_surp         rng = var_urb_con_surp!B2               cdim = 0
par=urb_costs            rng = var_urb_costs!B2                  cdim = 0
par=urb_gross_ben        rng = var_urb_gross_ben!B2              cdim = 0
par=urb_m_value          rng = var_urb_m_value!B2                cdim = 0
par=urb_value_af         rng = var_urb_value_af!B2               cdim = 0
par=urb_price            rng = var_urb_price!B2                  cdim = 0
par=urb_back_aq_rch      rng = var_urb_back_aq_rch!B2            cdim = 0
par=urb_revenue          rng = var_urb_revenue!B2                cdim = 0
par=urb_back_use         rng = var_urb_back_use!B2               cdim = 0
par=urb_sw_use           rng = var_urb_sw_use!B2                 cdim = 0
par=urb_value            rng = var_urb_value!B2                  cdim = 0
par=urb_use_p_cap        rng = var_urb_use_p_cap!B2              cdim = 0
par=urb_pump             rng = var_urb_pump!B2                   cdim = 0
par=urb_use              rng = var_urb_use!B2                    cdim = 0
par=diversions           rng = var_diversions!B2                 cdim = 0
par=water_flows          rng = var_water_flows!B2                cdim = 0


*----------------------* end of model optimized results *----------------*

$offecho
execute 'gdxxrw.exe @gdxxrwout.txt trace=2';

*------------------------The End ----------------------------------------*













