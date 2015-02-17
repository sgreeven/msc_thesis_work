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
      
    uncertainties = [ParameterUncertainty((0.5,1), 'ImpactFactor'),  
                     ParameterUncertainty((0.01,0.20), 'ReductionPolicyImpact'),
		     ParameterUncertainty((5,30), 'YearsBetweenInternationalNegotiations')  
                     ParameterUncertainty((0.20,0.60), 'RatioLocalEmissionNationalEmission'),  
                     ParameterUncertainty((0,20), 'SDVisionDistribution')                   
                     ]
      
    outcomes = [Outcome('cumulativeghg', time=True),  #
                Outcome('ghg', time=True)
                ]
    
    def run_model(self, case):
        """
        Method for running an instantiated model structure. 
         
        This method should always be implemented.
         
        :param case: keyword arguments for running the model. The case is a 
                     dict with the names of the uncertainties as key, and
                     the values to which to set these uncertainties. 
         
        .. note:: This method should always be implemented.
         
        """
        for key, value in case.iteritems():
            try:
                self.netlogo.command(self.command_format.format(key, value))
            except jpype.JavaException as e:
                warning('variable {0} throws exception: {}'.format((key,
                                                                    str(e))))
             
        debug("model parameters set successfully")
           
        # finish setup and invoke run
        self.netlogo.command("setup")
         
        commands = []
        fns = {}
        for outcome in self.outcomes:
            if outcome.time:
                name = outcome.name
                fn = r'{0}{3}{1}{2}'.format(self.working_directory,
                               name,
                               ".txt",
                               os.sep)
                fns[name] = fn
                fn = '"{}"'.format(fn)
                fn = fn.replace(os.sep, '/')
                 
                if self.netlogo.report('is-agentset? {}'.format(name)):
                    # if name is name of an agentset, we
                    # assume that we should count the total number of agents
                    nc = r'{2} {0} {3} {4} {1}'.format(fn,
                                                       name,
                                                       "file-open",
                                                       'file-write',
                                                       'count')
                else:
                    # it is not an agentset, so assume that it is 
                    # a reporter / global variable
                     
                    nc = r'{2} {0} {3} {1}'.format(fn,
                                                       name,
                                                       "file-open",
                                                       'file-write')
 
                commands.append(nc)
                 
 
        c_start = "repeat {} [".format(self.run_length)
        c_end = "go ]"
        c_middle = " ".join(commands)
        command = " ".join((c_start, c_middle, c_end))
        self.netlogo.command(command)
         
        # after the last go, we have not done a write for the outcomes
        # so we do that now
        self.netlogo.command(c_middle)
         
        self.netlogo.command("file-close-all")
        self._handle_outcomes(fns)
         
    def _handle_outcomes(self, fns):
       
        for key, value in fns.iteritems():
            with open(value) as fh:
                result = fh.readline()
                result = result.strip()
                result = result.split()
                result = [float(entry) for entry in result]
                result = np.asarray(result)
                result = result[0::100]
                self.output[key] = result
            os.remove(value)   
      
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
      
    #perform experiments
    results = ensemble.perform_experiments(1000, reporting_interval=10)
      
    save_results(results, r'.\data\EMA results ModelSebastiaanGreeven 1000 exp.bz2')
