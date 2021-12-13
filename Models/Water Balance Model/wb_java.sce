//This is a yearly surface water balance from the combined gauges at San Marcial,NM to Fort Quitman,TX
//Historical Values are from 1993-2004
//Code Includes Elephant Butte and Caballo Reservoirs
//Code Includes Caballo to El Paso and El Paso to Fort Quitman Reaches

//Model Author
// Alex Mayer - Michigan Technological University (MTU)

//Contributors
// Kenneth Thiemann - Michigan Technological University (MTU)
// Luis Garnica - University of Texas at El Paso (UTEP)

//Model Milestones:
//Update formulas according to most recent spreadsheet model.  -> Done
//Validate with miroc climate scenario                         -> Done
//Add Groundwater modeling                                     -> Done
//Downstream diversions                                        -> Pending
//Integration with SWIM WS                                     -> Done
//User Interface                                               -> Done
//Add user changebale percentage dials: + Min storage by percentage of max capacity on EB, + Reduce ET surface area by percentage.  -> Pending

//Unit Notes
//Most calculations are done with acre-feet should feed the model same unit system and feed with converted data? Some are surface area dependent.
//Pan evap AVG (inches/yr), Basin Precipitation AVG (mm/day), ET AVG(mm/day), Res Precipitation (inches/yr)

//Integration notes
// use ';' to end each line, otherwise the variable is displayed on the console (causes java problems)
// use '//' for comments, /* is not good for version 5.3.3 of scilab
// managed test integration with version 6.0.2 of scilab ---> more to come!

clc    
//clear  //kills variables dot not include from hava use or you kill preloded variables
//close  

//Excel where source data is located, can be edited to change input data.
//inputDataSource = 'input_parameters_new.xls'; //scilab only compatible with old .xls format

//Load Excel File
//inputData = readxls(inputDataSource);

//***********************INPUT LOAD****************************************/
//************************************************************************/

//***********TIMESTEPS******************/

//Simulation start year
//StartYear = (inputData(1)(2, 2));
//Simulation end year
//EndYear = (inputData(1)(3,2));
//Calculate number of years inclusive
NYears = EndYear - StartYear + 1;
//Excel year range add title row
YearRange = NYears + 1;
//Year List
//Years = (inputData(2)(2:YearRange, 1));

//**********ELEPHANT BUTTE RESERVOIR******************/

//Initial Storage Volume: 415000 acre-feet
//EBInitStorage = (inputData(1)(5,2));

//DAM MINIMUM STORAGE AMOUNTS (User Defined): 17300 acre-feet
//EBMin = (inputData(1)(9,2));

//EB Maximum Storage Volume: 1.99E+06 acre-feet
//EBMax = (inputData(1)(10,2));

//San Marcial Gauge In (Acre-Feet): miroc-esm_rcp26_r1i1p1 (v2)
//SanMarIn = (inputData(2)(2:YearRange, 2));

//Elephant Butte Precipitation (inches)
//EB_PrecG_in = (inputData(2)(2:YearRange, 3));

//Elephant Butte Pan Evaporation (inches)
//EB_Pan_in= (inputData(2)(2:YearRange, 6));

//**********CABALLO RESERVOIR******************/

//Caballo Initial Storage Volume
//CaballoInitStorage = (inputData(1)(6,2));

//Watershed Input to Caballo Gauge (Acree-Feet)
//Cab_WH_in = (inputData(2)(2:YearRange, 4));

//********COMBINED SURFACE STORAGE***********/
  
//Pan Evaporation Coefficient
//PanCo = (inputData(1)(8,2));

//**************DEMAND*******************/

//Desired full allocation of water
//Full_Allocation = (inputData(1)(7,2)); 

//*********Operating Agreement Coefficients***********//
//OPConst1 = (inputData(1)(24,2));
//OPConst2 = (inputData(1)(25,2));
//OPConst3 = (inputData(1)(26,2));

//***********Groundwater Inputs****************/
//MAA_Recharge_Coeff_Art = (inputData(1)(28,2));
//MIDA_Fraction_Urban = (inputData(1)(29,2));
//MIDA_Fraction_Ag = (inputData(1)(30,2));
//HB_Urb_Baseline = (inputData(1)(31,2));
//HB_Ag_Baseline = (inputData(1)(32 ,2));
//HB_Recharge_Baseline = (inputData(1)(33 ,2));
//HB_Underalloc_Fraction = (inputData(1)(34 ,2));
//HB_Underalloc_Urban_Frac = (inputData(1)(35 ,2));
//HB_Underalloc_Ag_Frac = (inputData(1)(36 ,2));
//HB_SW_Irr_Baseline = (inputData(1)(37 ,2));
//HB_RF_Coeff = (inputData(1)(38 ,2));
//HB_Net_Recharge = (inputData(1)(39 ,2));

//------------------------------> INPUT LOAD END <------------------------------------//

//********************************Functions*******************************/
//************************************************************************/


//******************************************MODEL START****************************************************/
//**********************************************************************************************************/

//Produces empty storage array for Elephant Butte Storage in Acre Feet
EB_Storage = zeros(NYears, 1);

//Empty Array for EB Surface area
EB_SurfA_A = zeros(NYears, 1);

//Caballo storage at end year
Cab_Storage = zeros(NYears, 1);

//Caballo storage average
Cab_Storage_AVG = zeros(NYears, 1);

//Empty Array for Caballo Surface Area
Caballo_SurfA_A = zeros(NYears, 1);

//Desired Caballo Gauge
DCab_Gauge = zeros(NYears, 1);

//Actual Caballo Gauge
Cab_Gauge = zeros(NYears, 1);

//Demand
Full_Allocation_AF = zeros(NYears, 1);

//Difference between full allocation and actual Cab Gage (AF)
Allocation_Dif = zeros(NYears, 1);

//Empty Rio Grande project storage evaporation array
RG_SEvap = zeros(NYears, 1);

//Empty Rio Grande project precipitation array
RG_SPrecip = zeros(NYears, 1);

//Empty Excess array
Excess = zeros(NYears, 1);

//Delta storage
DeltaSt = zeros(NYears, 1);

//Yearly caballo releases
Cab_Release = zeros(NYears, 1);

//Cumulative loss in GW Storage MAA (kAF)
MAA_Cum_Loss = zeros(NYears, 1);

//Mesilla Alluvial Ag
MAA_Ag = zeros(NYears, 1);

//Mesilla Alluvial Recharge
MAA_Recharge = zeros(NYears, 1);

//Cumulative loss in GW Storage MIDA (kAF)
MIDA_Cum_Loss = zeros(NYears, 1);

//Mesilla Intermediate Urban
MIDA_Urban = zeros(NYears, 1);

//Mesilla Intermediate Ag
MIDA_Ag = zeros(NYears, 1);

//Mesilla Intermediate Recharge
MIDA_Recharge = zeros(NYears, 1);

//Cumulative loss in GW storage HB (kAF)
HB_Loss = zeros(NYears, 1);
HB_Cum_Loss = zeros(NYears, 1);

//Hueco Bolson Urban
HB_Urban = zeros(NYears, 1);
HB_Urban_Cum = zeros(NYears, 1);

//Hueco Bolson Ag
HB_Ag = zeros(NYears, 1);
HB_Ag_Cum = zeros(NYears, 1);

//Hueco Bolson Recharge
HB_Recharge = zeros(NYears, 1);
HB_Recharge_Cum = zeros(NYears, 1);

for i = 1:NYears
   
   //first year uses initial storage values
   if(i==1) then
       //disp(Years(i), "Calculations Year");
       EBStoragePrevYear = EBInitStorage;
   //years after first use previous year storage           
   else
       //disp(Years(i), "Calculations Year");
       EBStoragePrevYear = EB_Storage(i-1,1);
   end
   
   //Full allocation for current year
   Full_Allocation_AF(i,1) =  Full_Allocation;
   
   //Desired Caballo Gauge(AF)
   DCab_Gauge(i,1) = min(OPConst1, (OPConst2*(SanMarIn(i,1)/1000))+(OPConst3*EBStoragePrevYear/1000))*1000;
   
   //Initialize while loop conditionals
   iteration = 0;
   EB_Storage_temp_new = 0;   
   epsilon = 1e-6; //converge value
   EB_Storage_Dif = 99999999; //high value to start inside while loop
   WaterBalance = 0; //EB reservoir water balance calculation 
   
   while (EB_Storage_Dif > epsilon) //compare difference in the storage between current and last iteration 
              
       //if on first iteration, use previous end of year storage value
       if(iteration == 0) then
           EB_Storage_temp_new = EBStoragePrevYear;    
       end
       
       //storage at the beginning of the while loop
       EB_Storage_old = EB_Storage_temp_new;
       
       // EB Surface Area based on end of year storage (AF)
       EB_SurfA_A(i,1) = 0 + (0.04300591139804*EB_Storage_old) + (-4.094164739452E-08*(EB_Storage_old^2)) + (2.421056235663E-14*(EB_Storage_old^3))+(-4.989812482053E-21*(EB_Storage_old^4));
       if(EB_SurfA_A(i,1) < 0) then
          EB_SurfA_A(i,1) = 0; 
       end
           
       //Caballo storage at end year (AF)
       Cab_Storage(i,1) = CaballoInitStorage;
           
       //Caballo storage average (AF)
       Cab_Storage_AVG(i,1) = (Cab_Storage(i,1) * 0.8859090221627) - 7436.780267639; 
           
       //Caballo Surface Area based on avg storage (AF)
       Caballo_SurfA_A(i,1) = 0 + (0.09990893160458*Cab_Storage_AVG(i,1)) + (-0.0000005918491249596*(Cab_Storage_AVG(i,1)^2)) + (2.017188179347E-12*(Cab_Storage_AVG(i,1)^3))+(-2.50210756958E-18*(Cab_Storage_AVG(i,1)^4));
           
       //RG Project Storage Evap (AF)
       RG_SEvap(i,1) = PanCo * (EB_Pan_in(i,1)/12)*(Caballo_SurfA_A(i,1) + EB_SurfA_A(i,1));
           
       //RG Project Storage Precip (AF)
       RG_SPrecip(i,1) = (EB_PrecG_in(i,1)/12)*(Caballo_SurfA_A(i,1) + EB_SurfA_A(i,1));

       //EB Storage Water Balance 
       WaterBalance = EBStoragePrevYear + SanMarIn(i,1) + Cab_WH_in(i,1) - RG_SEvap(i,1) + RG_SPrecip(i,1) - DCab_Gauge(i,1);
           
       //Excess calculation
       if(WaterBalance < EBMax) then
           Excess(i,1) = 0; //no excess if below EBMax
       else
           Excess(i,1) = WaterBalance - EBMax; //get excess of water
       end
       
       //disp(Excess(i,1), "Excess: ");  
        
       //Actual Caballo Gauge (AF)
       Cab_Gauge(i,1) = WaterBalance + Excess(i,1);
       if(Cab_Gauge(i,1) > EBMin) then
           Cab_Gauge(i,1) = DCab_Gauge(i,1); //can release desired amount
       else
           Cab_Gauge(i,1) = SanMarIn(i,1) + Cab_WH_in(i,1) - RG_SEvap(i,1) + RG_SPrecip(i,1); //release what came in
       end
       
       //Include the excess water on caballo 
       Cab_Release(i,1) = Cab_Gauge(i,1) + Excess(i,1);
       
       //Storage at end of year
       EB_Storage_temp_new = EBStoragePrevYear + SanMarIn(i,1) + Cab_WH_in(i,1) - RG_SEvap(i,1) + RG_SPrecip(i,1) - (Cab_Release(i,1));

       EB_Storage_Dif = abs(EB_Storage_temp_new - EB_Storage_old);

       //manage iteration limit of 1000 to prevent infinite loop
       iteration = iteration + 1;
       if(iteration > 1000)
            break;    
       end
       
   end  //end of while loop 
   
   //difference between actual caballo gage and full allocation
   if((Cab_Gauge(i,1) - Full_Allocation_AF(i, 1)) > 0) then
       Allocation_Dif(i, 1) = 0;
   else
       Allocation_Dif(i, 1) = Cab_Gauge(i,1) - Full_Allocation_AF(i, 1);
   end
   
   EB_Storage(i,1) = EB_Storage_temp_new;
   
      //********************************* GROUNDWATER **************************************/
   
   //Total Loss in GW Storage Mesilla Alluvial Aquifer (kAF)
   
   
   if(i==1) then
        MAA_Ag(i, 1) = round((((161.9497566/(1233.48/1000000)) - (0.276842788506261 * Allocation_Dif(i, 1)))/1000));
        MAA_Recharge(i, 1) = round(-((MAA_Recharge_Coeff_Art * Cab_Gauge(i,1))/1000));
        MAA_Cum_Loss(i, 1) = (((161.9497566/(1233.48/1000000)) - (0.276842788506261 * Allocation_Dif(i, 1)))/1000) - ((MAA_Recharge_Coeff_Art * Cab_Gauge(i,1))/1000);
   else
        MAA_Ag(i, 1) = round((((161.9497566/(1233.48/1000000)) - (0.276842788506261 * Allocation_Dif(i, 1)))/1000) +  MAA_Ag(i-1, 1));
        MAA_Recharge(i, 1) = round(-((MAA_Recharge_Coeff_Art * Cab_Gauge(i,1))/1000) + MAA_Recharge(i-1, 1));
        MAA_Cum_Loss(i, 1) = (((161.9497566/(1233.48/1000000)) - (0.276842788506261 * Allocation_Dif(i, 1)))/1000) - ((MAA_Recharge_Coeff_Art * Cab_Gauge(i,1))/1000) + MAA_Cum_Loss(i-1, 1);
   end
   
   //Total Loss in GW Storage at Mesilla Intermediate Aquifer (kAF)
   if(i==1) then
       MIDA_Cum_Loss(i, 1) =(((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) - 33.7257191036742;
       MIDA_Urban(i, 1) = (((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) * MIDA_Fraction_Urban;
       MIDA_Ag(i, 1) = (((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) * MIDA_Fraction_Ag;
       MIDA_Recharge(i, 1) = - 33.7257191036742;
   else
       MIDA_Cum_Loss(i, 1) =(((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) - 33.7257191036742 + MIDA_Cum_Loss(i-1, 1);
       MIDA_Urban(i, 1) = ((((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) * MIDA_Fraction_Urban) + MIDA_Urban(i-1, 1);
       MIDA_Ag(i, 1) = ((((123.87037878/(1233.48/1000000)) - (0.211748518767345 * Allocation_Dif(i, 1)))/1000) * MIDA_Fraction_Ag) + MIDA_Ag(i-1, 1);
       MIDA_Recharge(i, 1) = -33.7257191036742 + MIDA_Recharge(i-1, 1);
   end 
   
   //Total Loss in GW Storage at Hueco Bolson (kAF)
   HB_Ag(i, 1) = HB_Ag_Baseline-(HB_Underalloc_Fraction * HB_Underalloc_Ag_Frac *(HB_Ag_Baseline/(HB_Urb_Baseline + HB_Ag_Baseline)) * Allocation_Dif(i, 1)/1000);
   HB_Recharge(i, 1) = ((-Cab_Gauge(i,1)/Full_Allocation_AF(i,1)) * HB_SW_Irr_Baseline * HB_RF_Coeff)-((HB_Ag(i, 1))* HB_RF_Coeff)- HB_Net_Recharge;
   HB_Urban(i, 1) = HB_Urb_Baseline-(HB_Underalloc_Fraction * HB_Underalloc_Urban_Frac * (HB_Urb_Baseline/(HB_Urb_Baseline + HB_Ag_Baseline)) * Allocation_Dif(i, 1)/1000);
   HB_Loss(i, 1) = HB_Ag(i, 1) +  HB_Recharge(i, 1) + HB_Urban(i, 1);
   
   if(i==1) then
       HB_Urban_Cum(i, 1) = HB_Urban(i, 1);
       HB_Ag_Cum(i, 1) = HB_Ag(i, 1);
       HB_Recharge_Cum(i, 1) = HB_Recharge(i, 1);
       HB_Cum_Loss(i, 1) = HB_Loss(i, 1);
   else
       HB_Urban_Cum(i, 1) = HB_Urban(i, 1) + HB_Urban_Cum(i-1, 1);
       HB_Ag_Cum(i, 1) = HB_Ag(i, 1) + HB_Ag_Cum(i-1, 1);
       HB_Recharge_Cum(i, 1) = HB_Recharge(i, 1) + HB_Recharge_Cum(i-1, 1);
       HB_Cum_Loss(i, 1) = HB_Loss(i, 1) + HB_Cum_Loss(i-1, 1);
   end
   
end //end of timestep loop

//************************CSV OUTPUT**************************************/
//************************************************************************/

//Column headings
//heading = ["Year, San Marcial Combined Gauges, Watershed Input to Caballo, EB Storage, Caballo Storage, EB Surface Area, Caballo Storage Average, Caballo Surface Area, EB Pan Evap, Reservoir Evaporation, Reservoir Precipitation, Actual Caballo Gauge, Excess,Desired Caballo Gauge, Delta Storage, Full Allocation"];
//Data Output Columns
//List = [Years, SanMarIn, Cab_WH_in, EB_Storage, Cab_Storage, EB_SurfA_A, Cab_Storage_AVG, Caballo_SurfA_A, EB_Pan_in, RG_SEvap, RG_SPrecip, Cab_Gauge, Excess, DCab_Gauge, DeltaSt, Full_Allocation_AF]; 

// Add x, y, P column header to csv file, list column values []
//csvWrite(List, "wb_output_new.csv",[],[],[], heading);

     
//*********************** END OF MODEL **************************/



