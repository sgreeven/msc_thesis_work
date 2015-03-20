'''
Last Modified: 17-3-2015
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
      
    uncertainties = [CategoricalUncertainty(('5','10','15'), 'YearsBetweenInternationalNegotiations'),  
                     ParameterUncertainty((0.3,0.7), 'RatioIndividualEmissionNationalEmission'),  
                     ParameterUncertainty((0.05,0.15), 'InitialSeverityOfClimateDisaster'),
                     ParameterUncertainty((0.3,0.7), 'EffectOfClimateChangeOnClimateDisasters'),
                     ParameterUncertainty((0.01,0.1), 'BaseChanceOfClimateDisaster'),
                     ParameterUncertainty((0.5,1), 'MitigationEnforcementFactor'),
                     ParameterUncertainty((1.02,1.05), 'ExpFactor'),
                     ParameterUncertainty((0.8,1.2), 'ImpactFactor'),
                     CategoricalUncertainty(('2','3','4','5'), 'ClimateDisasterMemory')
                     ]
      
    outcomes = [Outcome('CumulativeGHGreduction', time=True),
                Outcome('AnualGHGreduction', time=True),
                Outcome('TotalAgreementEffect', time=True),
                Outcome('BottomUpMitigationRatio', time=True),
                Outcome('TotalClimateDisasterEffect', time=True)                
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
      
#     cases = [ {'RatioLocalEmissionNationalEmission': 0.4} for _ in range(100)]
    
    #perform experiments
    
    results = ensemble.perform_experiments(1000, reporting_interval=100)
      
    save_results(results, r'.\data\EMA results ModelSebastiaanGreeven 1000 exp.tar.gz')
