# -*- coding: utf-8 -*-
"""
Created on Thu Sep 23 16:21:00 2021
@name: Middle Rio Grande Basin Water Balance Model 2.0
@author: Luis Garnica
@author: Robyn Holmes
@author: Alex Mayer
@description:
    Object oriented revision of the middle rio grande water balance model
"""

import pandas as pd
import numpy as np
import json

class WaterBalance:

    def __init__(self):
        self.scalars_loaded = False
        self.tables_loaded = False
        self.model_init_done = False
        self.output_init_done = False
        self.input_xls_file = None
        self.output_xls_file = None
        self.sim_names = []
        self.timesteps = []
        self.inputs = {}
        self.model_params = {}
        self.outputs = {}

    def run(self):
        if(self.scalars_loaded and self.tables_loaded):
            self.initialize_model()
            self.initialize_outputs()
        else:
            raise Exception("Input data not loaded") 
        
        self.process()

    def load_data_document(self, inputs):
        '''
        Load input parameters from mongoengine ORM object
        '''
        print('Loading model inputs from json...')
        for input in inputs:
            # only scenario and user defined inputs will be loaded
            if (input['definitionType'] == "scenario" or input['definitionType'] == "user"):
                structType = input['structType']
                # print(input['paramName'])
                if(structType == "scalar"):
                    # map scalar parameters as single value (not a pandas dataframe)
                    self.inputs[input['paramName']] = input['paramValue']
                elif(structType == "table"):
                    # map table type parameters as pandas dataframe
                    df = pd.DataFrame.from_dict(input['paramValue'])
                    df = df.set_index('t')
                    self.inputs[input['paramName']] = df
        
        self.scalars_loaded = True
        self.tables_loaded = True

    def load_scalars_xls(self):
        'Loads scalar parameters from spreadsheet with the name Scalars'

        print('Loading scalar inputs from xls...')

        scalars = pd.read_excel(self.input_xls_file, sheet_name='Scalars')
        for index, row in scalars.iterrows():
            self.inputs[row['Name']] = row['Value']
        
        self.scalars_loaded = True

    def load_tables_xls(self):
        'Load 1..n dimension tables e.g. timeseries from separate sheets'

        print('Loading table inputs from xls...')

        xls = pd.ExcelFile(self.input_xls_file)
        for sheet in xls.sheet_names:
            if sheet != 'Scalars':
                self.inputs[sheet] = pd.read_excel(self.input_xls_file, sheet_name=sheet, index_col=0)
                
        self.tables_loaded = True

    def initialize_model(self):
        'initialize data units and model start points'

        print('Initializing model...')

        # Timesteps
        start = int(self.inputs['StartYearV2'])
        end = int(self.inputs['EndYearV2'] + 1)
        for x in range(start, end):
            self.timesteps.append(x)

        # Unit conversions
        self.inputs['SanMarV2_af'] = self.inputs['SanMarV2_cfs'] * 724.44792344617  # Convert CFS to af/year
        self.inputs['CabPrV2_ft'] = self.inputs['CabPrV2_mmday'] * 1.198302165      # Convert mm/day to ft/year
        self.inputs['EBPrV2_ft'] = self.inputs['EBPrV2_mmday'] * 1.198302165        # Convert mm/day to ft/year

        # Simulation names (for batch run in outter loop)
        self.sim_names = self.inputs['SanMarV2_af'].columns.values.tolist() 

        # Model parameters
        self.model_params['EBStoragePrevYear'] = 0  # Reservoir storage previous year    
        self.model_params['Epsilon'] = .000001 # Convergence threshold
        self.model_params['MaxIt'] = 1000 # Maximum number of iterations

        # Set static parameters 
        # EB hypsometric curve
        self.inputs['EBA0V2'] = 0
        self.inputs['EBA1V2'] = 0.04300591139804
        self.inputs['EBA2V2'] = -4.094164739452E-08
        self.inputs['EBA3V2'] = 2.421056235663E-14
        self.inputs['EBA4V2'] = -4.989812482053E-21

        # Caballo hypsometric curve
        self.inputs['CabA0V2'] = 0
        self.inputs['CabA1V2'] = 0.09990893160458
        self.inputs['CabA2V2'] = -0.0000005918491249596
        self.inputs['CabA3V2'] = 2.017188179347E-12
        self.inputs['CabA4V2'] = -2.50210756958E-18

        # print(self.model_params)

        self.init_done = True

    def initialize_outputs(self):
        'Allocate dataframes from model outputs'

        print('Initializing output structures...')
        
        # RESERVOIR OPERATION
        self.outputs['EBStorageV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)         # Elephant Butte Storage (acre-feet)
        self.outputs['EBSurfAV2_ac'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)           # EB Surface area (acres)
        self.outputs['CabStorageV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)        # Caballo storage average (acre-feet)
        self.outputs['CabSurfAV2_ac'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)          # Caballo Surface Area (acres)
        self.outputs['ResSEvapV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)          # Reservoir Surface Evaporation
        self.outputs['ResSPrecipV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)        # Reservoir Direct Precipitation (af), Caballo + Elephant Butte
        self.outputs['ExcessV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)            # Excess (water that must be released to keep reservoir volume within capacity, not allocated to a user)
        self.outputs['CabGaugeV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)          # Yearly Caballo Gauge (acre-feet) (allocated releases)
        self.outputs['CabROV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)             # Caballo Runoff (acre-feet)
        self.outputs['DCabGaugeV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)         # Desired Caballo Gauge (acre-feet)
        self.outputs['CabReleaseV2_af'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)        # Gauge Flow at Caballo; = Caballo_Realease_af + Excess (acre-feet)
        self.outputs['WBalCheckV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)            # checking if waterbalance = 0
        self.outputs['SWEvapV2_ft'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)            # Surface water evaporation depth (feet)
        self.outputs['AllocationDiffV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)       # Allocation Difference; = Cab_Gauge_af - DCab_Gauge_af
        self.outputs['NetLocalV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)             # Net local reservoir flows; = P + RO - E (af?) better description??
        self.outputs['LocalNetDepthV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)        # what is this????  feet??

        # AQUIFER OPERATION
        self.outputs['FullAllocationV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)       # Full allocation by year
        self.outputs['MAACumLossV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)           # Cumulative loss in GW Storage MAA (kAF)
        self.outputs['MAAAgV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)                # Mesilla Alluvial Ag
        self.outputs['MAARechargeV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)          # Mesilla Alluvial Recharge
        self.outputs['MIDACumLossV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)          # Cumulative loss in GW Storage MIDA (kAF)
        self.outputs['MIDAUrbanV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)            # Mesilla Intermediate Urban
        self.outputs['MIDAAgV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)               # Mesilla Intermediate Ag
        self.outputs['MIDARechargeV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)         # Mesilla Intermediate Recharge
        self.outputs['HBLossV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)               # Loss in GW storage HB (kAF)
        self.outputs['HBCumLossV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)            # Cumulative loss in GW storage HB (kAF)
        self.outputs['HBAgV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)                 # Hueco Bolson Ag
        self.outputs['HBAgCumV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)              # Hueco Bolson Cumulative Ag
        self.outputs['HBRechargeV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)           # Hueco Bolson Recharge
        self.outputs['HBRechargeCumV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)        # Hueco Bolson Cumulative Recharge
        self.outputs['HBUrbanV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)              # Hueco Bolson urb
        self.outputs['HBUrbanCumV2'] = pd.DataFrame(columns=self.sim_names, index=self.timesteps, dtype=np.float64)           # Hueco Bolson cumulative urb        
        
        self.output_init_done = True

    def process(self):
        'Process the water balance model'
        for sim in self.sim_names:

            for year in self.timesteps:
                #*****************************RESERVOIR OPERATION******************************#
                EB_Storage_current_it = 0       # Initialize/reset
                EB_Storage_Diff = 999999999     # Initialize/reset

                if year == self.inputs['StartYearV2']:# First year uses initial storage volume
                    EBStoragePrevYear = self.inputs['EBInitStorageV2']
                else:                           # After first year, use previous year's storage volume
                    EBStoragePrevYear = self.outputs['EBStorageV2_af'].at[year-1, sim]

                self.outputs['FullAllocationV2'].at[year, sim] = self.inputs['FullAllocationV2']

                self.outputs['DCabGaugeV2_af'].at[year, sim] = min(self.inputs['OPConst1V2'], (self.inputs['OPConst2V2'] * self.inputs['SanMarV2_af'].at[year, sim] + self.inputs['OPConst3V2'] * EBStoragePrevYear))  # Desired Caballo Gauge (af)

                self.outputs['CabStorageV2_af'].at[year, sim] = (self.inputs['CabInitStorageV2'] * 0.8859090221627) - 7436.780267639        # Caballo storage average (af) (note: ASSUMED CONSTANT)
                self.outputs['CabSurfAV2_ac'].at[year, sim] = max(0, self.inputs['CabA0V2'] + (self.inputs['CabA1V2'] * self.outputs['CabStorageV2_af'].at[year, sim]) + (self.inputs['CabA2V2']*(self.outputs['CabStorageV2_af'].at[year, sim]**2)) + (self.inputs['CabA3V2']*(self.outputs['CabStorageV2_af'].at[year, sim]**3))+(self.inputs['CabA4V2']*(self.outputs['CabStorageV2_af'].at[year, sim]**4))) # Caballo surface area (ac) (note: ASSUMED CONSTANT)

                self.outputs['SWEvapV2_ft'].at[year, sim] = (self.inputs['HistoricEvapV2'] + self.inputs['EvapCoeffV2'] * (self.inputs['EBTasV2_degC'].at[year, sim] - self.inputs['HistoricTasV2']) + self.inputs['EvapIntV2'])/304.8   # Evaporation depth per year (304.8 converts mm to feet)

                # Iterate to solve for EB storage
                it = 0
                while((EB_Storage_Diff > self.model_params['Epsilon']) and (it < self.model_params['MaxIt'])):
                    if it == 0:
                        EB_Storage_current_it = EBStoragePrevYear  # If first iteration, use prev. year's storage volume as first guess
                    EB_Storage_prev_it = EB_Storage_current_it

                    self.outputs['EBSurfAV2_ac'].at[year, sim] = max(0, self.inputs['EBA0V2'] + (self.inputs['EBA1V2']*EB_Storage_prev_it) + (self.inputs['EBA2V2']*(EB_Storage_prev_it**2)) + (self.inputs['EBA3V2']*(EB_Storage_prev_it**3))+(self.inputs['EBA4V2']*(EB_Storage_prev_it**4)))

                    self.outputs['ResSPrecipV2_af'].at[year, sim] = self.inputs['CabPrV2_ft'].at[year, sim] * self.outputs['CabSurfAV2_ac'].at[year, sim] + self.inputs['EBPrV2_ft'].at[year, sim] * self.outputs['EBSurfAV2_ac'].at[year, sim]     # Reservoir Surface Precip (AF) 
                    self.outputs['ResSEvapV2_af'].at[year, sim] = self.outputs['SWEvapV2_ft'].at[year, sim] * (self.outputs['CabSurfAV2_ac'].at[year, sim] + self.outputs['EBSurfAV2_ac'].at[year, sim]) # Reservoir Surface Evap (AF)

                    self.outputs['CabROV2_af'].at[year, sim] = self.inputs['RunoffCoeffV2'] * ((self.inputs['CabLandAreaV2'] - self.outputs['CabSurfAV2_ac'].at[year, sim]) * self.inputs['CabPrV2_ft'].at[year, sim] + (self.inputs['EBLandAreaV2'] -self.outputs['EBSurfAV2_ac'].at[year, sim]) * self.inputs['EBPrV2_ft'].at[year, sim])
                    
                    # Reservoir Operation (Solve for Caballo Release)
                    EB_Storage_current_it = EBStoragePrevYear + self.inputs['SanMarV2_af'].at[year, sim] + self.outputs['CabROV2_af'].at[year, sim] + self.outputs['ResSPrecipV2_af'].at[year, sim] - self.outputs['ResSEvapV2_af'].at[year, sim] - self.outputs['DCabGaugeV2_af'].at[year, sim]   # Volume of EB after desired release volume released
                    if(EB_Storage_current_it < self.inputs['EBMaxV2'] and EB_Storage_current_it > self.inputs['EBMinV2']):   # If EB is within upper and lower limits, release DCab, no Excess
                        self.outputs['ExcessV2_af'].at[year, sim] = 0
                        self.outputs['CabGaugeV2_af'].at[year, sim] = self.outputs['DCabGaugeV2_af'].at[year, sim]
                    elif(EB_Storage_current_it < self.inputs['EBMinV2']):      # If releasing DCab puts EB below min V, no Excess, release to min V
                        self.outputs['ExcessV2_af'].at[year, sim] = 0
                        self.outputs['CabGaugeV2_af'].at[year, sim] = EBStoragePrevYear + self.inputs['SanMarV2_af'].at[year, sim] + self.outputs['CabROV2_af'].at[year, sim] + self.outputs['ResSPrecipV2_af'].at[year, sim] - self.inputs['EBMinV2']
                    else:   # If EB is above max capacity calculate excess water that needs to be released
                       self.outputs['ExcessV2_af'].at[year, sim] = EB_Storage_current_it - self.inputs['EBMaxV2']  
                       self.outputs['CabGaugeV2_af'].at[year, sim] = self.outputs['DCabGaugeV2_af'].at[year, sim]  
                    self.outputs['CabReleaseV2_af'].at[year, sim] =  self.outputs['CabGaugeV2_af'].at[year, sim] + self.outputs['ExcessV2_af'].at[year, sim]  

                    EB_Storage_current_it = EBStoragePrevYear + self.inputs['SanMarV2_af'].at[year, sim] + self.outputs['CabROV2_af'].at[year, sim] - self.outputs['ResSEvapV2_af'].at[year, sim] + self.outputs['ResSPrecipV2_af'].at[year, sim] - self.outputs['CabReleaseV2_af'].at[year, sim]
                    EB_Storage_Diff = abs(EB_Storage_prev_it - EB_Storage_current_it)   

                    it+=1
                
                    # End iteration that solves for EB storage
                    
                self.outputs['EBStorageV2_af'].at[year, sim] = EB_Storage_current_it       # Store EB Yearly Storage in dataframe
                self.outputs['AllocationDiffV2'].at[year, sim] = self.outputs['DCabGaugeV2_af'].at[year, sim]  - self.outputs['CabGaugeV2_af'].at[year, sim]  # Difference between desired Caballo release and actual

                # Double Check Water Balance
                deltaS = 0
                if year == self.inputs['StartYearV2']:
                    deltaS = self.outputs['EBStorageV2_af'].at[year, sim] - self.inputs['EBInitStorageV2']
                else:
                    deltaS = self.outputs['EBStorageV2_af'].at[year, sim] - self.outputs['EBStorageV2_af'].at[year-1, sim]
                # End iteration that solves EB balance

                self.outputs['WBalCheckV2'].at[year, sim] = self.inputs['SanMarV2_af'].at[year, sim] + self.outputs['CabROV2_af'].at[year, sim] - self.outputs['ResSEvapV2_af'].at[year, sim] + self.outputs['ResSPrecipV2_af'].at[year, sim] - self.outputs['CabReleaseV2_af'].at[year, sim] - deltaS # Reservoir WB = inflows - outflows - delta S
               # WBal_Check.at[Year,ClmSim] =                           SanMar_af.at[Year, ClmSim] +                 Cab_RO_af.at[Year, ClmSim] -               Res_SEvap_af.at[Year, ClmSim] +               Res_SPrecip_af.at[Year, ClmSim] -               Cab_Release_af.at[Year, ClmSim] - deltaS


                #******************************** AQUIFER OPERATION *********************************************# 
                # Total Loss in GW Storage Mesilla Alluvial Aquifer (kAF)
                self.outputs['MAACumLossV2'].at[year, sim] = (((161.9497566/(1233.48/1000000)) - (0.276842788506261 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) - ((self.inputs['MAARechargeCoeffArtV2'] * self.outputs['CabGaugeV2_af'].at[year, sim])/1000)
                # first year
                if(year == self.timesteps[0]):
                    #MAA AG Use
                    self.outputs['MAAAgV2'].at[year, sim] = round((((161.9497566/(1233.48/1000000)) - (0.276842788506261 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000))
                    # MAA Recharge
                    self.outputs['MAARechargeV2'].at[year, sim] = round(-((self.inputs['MAARechargeCoeffArtV2'] * self.outputs['CabGaugeV2_af'].at[year, sim])/1000))
                else:
                    # MAA AG Use
                    self.outputs['MAAAgV2'].at[year, sim] = round((((161.9497566/(1233.48/1000000)) - (0.276842788506261 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) +  self.outputs['MAAAgV2'].at[year - 1, sim])
                    # MAA Recharge
                    self.outputs['MAARechargeV2'].at[year, sim] = round(-((self.inputs['MAARechargeCoeffArtV2'] * self.outputs['CabGaugeV2_af'].at[year, sim])/1000))

                # Total Loss in GW Storage at Mesilla Intermediate Aquifer (kAF)
                if(year == self.timesteps[0]):
                    self.outputs['MIDACumLossV2'].at[year, sim] =(((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) - 33.7257191036742
                    self.outputs['MIDAUrbanV2'].at[year, sim] = (((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) * self.inputs['MIDAFractionUrbanV2']
                    self.outputs['MIDAAgV2'].at[year, sim] = (((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) * self.inputs['MIDAFractionAgV2']
                    self.outputs['MIDARechargeV2'].at[year, sim] = -33.7257191036742
                else: 
                    self.outputs['MIDACumLossV2'].at[year, sim] =(((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) - 33.7257191036742 + self.outputs['MIDACumLossV2'].at[year - 1, sim]
                    self.outputs['MIDAUrbanV2'].at[year, sim] = ((((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) * self.inputs['MIDAFractionUrbanV2']) + self.outputs['MIDAUrbanV2'].at[year - 1, sim]
                    self.outputs['MIDAAgV2'].at[year, sim] = ((((123.87037878/(1233.48/1000000)) - (0.211748518767345 * self.outputs['AllocationDiffV2'].at[year ,sim]))/1000) * self.inputs['MIDAFractionAgV2']) + self.outputs['MIDAAgV2'].at[year - 1, sim]
                    self.outputs['MIDARechargeV2'].at[year, sim] = -33.7257191036742 + self.outputs['MIDARechargeV2'].at[year - 1, sim]
        
                # Total Loss in GW Storage at Hueco Bolson (kAF)
                self.outputs['HBAgV2'].at[year, sim] = self.inputs['HBAgBaselineV2'] - (self.inputs['HBUnderallocFractionV2'] * self.inputs['HBUnderallocAgFracV2'] *(self.inputs['HBAgBaselineV2']/(self.inputs['HBUrbBaselineV2'] + self.inputs['HBAgBaselineV2'])) * self.outputs['AllocationDiffV2'].at[year ,sim]/1000)
                self.outputs['HBRechargeV2'].at[year, sim] = ((-self.outputs['CabGaugeV2_af'].at[year, sim]/self.outputs['FullAllocationV2'].at[year, sim]) * self.inputs['HBSWIrrBaselineV2'] * self.inputs['HBRFCoeffV2']) - ((self.outputs['HBAgV2'].at[year, sim])* self.inputs['HBRFCoeffV2'])- self.inputs['HBNetRechargeV2']
                self.outputs['HBUrbanV2'].at[year, sim] = self.inputs['HBUrbBaselineV2'] - (self.inputs['HBUnderallocFractionV2'] * self.inputs['HBUnderallocUrbanFracV2'] * (self.inputs['HBUrbBaselineV2']/(self.inputs['HBUrbBaselineV2'] + self.inputs['HBAgBaselineV2'])) * self.outputs['AllocationDiffV2'].at[year ,sim]/1000)
                self.outputs['HBLossV2'].at[year, sim] = self.outputs['HBAgV2'].at[year, sim] +  self.outputs['HBRechargeV2'].at[year, sim] + self.outputs['HBUrbanV2'].at[year, sim]
            
                if (year == self.timesteps[0]):
                    self.outputs['HBUrbanCumV2'].at[year, sim] = self.outputs['HBUrbanV2'].at[year, sim]
                    self.outputs['HBAgCumV2'].at[year, sim] = self.outputs['HBAgV2'].at[year, sim]
                    self.outputs['HBRechargeCumV2'].at[year, sim] = self.outputs['HBRechargeV2'].at[year, sim]
                    self.outputs['HBCumLossV2'].at[year, sim] = self.outputs['HBLossV2'].at[year, sim]
                else:
                    self.outputs['HBUrbanCumV2'].at[year, sim] = self.outputs['HBUrbanV2'].at[year, sim] + self.outputs['HBUrbanCumV2'].at[year - 1, sim]
                    self.outputs['HBAgCumV2'].at[year, sim] = self.outputs['HBAgV2'].at[year, sim] + self.outputs['HBAgCumV2'].at[year - 1, sim]
                    self.outputs['HBRechargeCumV2'].at[year, sim] = self.outputs['HBRechargeV2'].at[year, sim] + self.outputs['HBRechargeCumV2'].at[year - 1, sim]
                    self.outputs['HBCumLossV2'].at[year, sim] = self.outputs['HBLossV2'].at[year, sim] + self.outputs['HBCumLossV2'].at[year - 1, sim]
                                    
            print('Run completed.')
            # End Year iteration
        # End Climate Scenario iteration

        self.outputs['NetLocalV2'] = self.outputs['CabROV2_af'].sub(self.outputs['ResSEvapV2_af']).add(self.outputs['ResSPrecipV2_af'])     # Reservoir contributions from the local subwatersheds
        self.outputs['LocalNetDepthV2'] = self.inputs['EBPrV2_ft'].sub(self.outputs['SWEvapV2_ft'].at[year, sim])
        
        print('Model processing complete.')

    
    def export_outputs_document(self, outputs):
        # pandas dataframe to json arrays on values
        print('Exporting outputs to json document...')
        for output in outputs:
            if(output['varName'] in self.outputs):
                # print(output['varName'])
                self.outputs[output['varName']].reset_index(inplace=True)
                self.outputs[output['varName']] = self.outputs[output['varName']].rename(columns = {'index':'t'})
                output['varValue'] = json.loads(self.outputs[output['varName']].to_json(orient="records"))

        return outputs

    def export_outputs_xls(self):
        print('Exporting outputs to excel file...')
        writer = pd.ExcelWriter(self.output_xls_file)
        for key in self.outputs:
            # print(key)
            self.outputs[key].to_excel(writer, key)
        writer.save()


'''
Test example
'''
'''
wb = WaterBalance()
wb.input_xls_file = 'Inputs\\input_parameters_all.xlsx'
wb.output_xls_file = 'Outputs\\ResModelOutput.xlsx'
wb.load_scalars_xls()
wb.load_tables_xls()
wb.run()
wb.export_outputs_xls()
'''