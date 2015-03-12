'''
Created on 10 feb. 2014
Sebastiaan Greeven 

Based on code from jhkwakkel <j.h.kwakkel (at) tudelft (dot) nl>
'''

import os
import numpy as np

import jpype
  
from connectors.netlogo import NetLogoModelStructureInterface
from expWorkbench import ParameterUncertainty, CategoricalUncertainty, Outcome,\
                         ModelEnsemble, ema_logging, save_results, warning,\
                         debug
  
class EVO(NetLogoModelStructureInterface):
    model_file = r"/ModelSebastiaanGreeven.nlogo"
      
    run_length = 100
      
    uncertainties = [
#                      ParameterUncertainty((1,1), 'ImpactFactor')],  
#                      ParameterUncertainty((0.01,0.20), 'ReductionPolicyImpact'),
#    		             ParameterUncertainty((5,30), 'YearsBetweenInternationalNegotiations'),  
                     ParameterUncertainty((0.59,0.60), 'RatioLocalEmissionNationalEmission')  
#                      ParameterUncertainty((0,20), 'SDVisionDistribution')                   
                     ]
      
    outcomes = [Outcome('cumulativeghg', time=True),  #
                Outcome('ghg', time=True)
                ]
    

      
if __name__ == "__main__":
    #turn on logging
    ema_logging.log_to_stderr(ema_logging.INFO)
      
    #instantiate a model
    vensimModel = EVO( r"./models", "simpleModel")
      
    #instantiate an ensemble
    ensemble = ModelEnsemble()
      
    #set the model on the ensemble
    ensemble.set_model_structure(vensimModel)
#        
#     run in parallel, if not set, FALSE is assumed
    ensemble.parallel = True
      
    cases = [ {'RatioLocalEmissionNationalEmission': 0.5} for _ in range(1000)]  
    
    
    #perform experiments
    results = ensemble.perform_experiments(cases, reporting_interval=10)
      
    save_results(results, r'.\data\EMA results ModelSebastiaanGreeven 1000 exp .tar.gz')
