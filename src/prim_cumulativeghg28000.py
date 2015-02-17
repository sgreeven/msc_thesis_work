'''
Created on 11 feb. 2014
Sebastiaan Greeven 

Based on code from jhkwakkel <j.h.kwakkel (at) tudelft (dot) nl>
'''

import numpy as np
import matplotlib.pyplot as plt

import analysis.prim as prim
from expWorkbench import load_results, ema_logging

ema_logging.log_to_stderr(level=ema_logging.INFO)

def classify(data):
    result = data['cumulativeghg']
    
    #make an empty array of length equal to number of cases 
    classes =  np.zeros(result.shape[0])
    
    classes[result[:, -1] < 28000] = 1
    
    return classes

#load data
results = load_results(r'.\data\EMA results ModelSebastiaanGreeven 1000 exp.bz2')
experiments, results = results

results = (experiments, results)

#perform prim_obj on modified results tuple

prim_obj = prim.Prim(results, classify, threshold=0.3, threshold_type=1)
box_1 = prim_obj.find_box()
box_1.show_ppt()
box_1.show_tradeoff()
box_1.write_ppt_to_stdout()
# box_1.select(25)


#print prim_obj to std_out
prim_obj.write_boxes_to_stdout()


##visualize
prim_obj.show_boxes()
plt.show()