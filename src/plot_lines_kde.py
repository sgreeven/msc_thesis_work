'''
Created on 10 feb. 2014
Sebastiaan Greeven 

Based on code from jhkwakkel <j.h.kwakkel (at) tudelft (dot) nl>
'''

import numpy as np
import matplotlib.pyplot as plt

from expWorkbench import load_results
from analysis import plotting
from analysis.plotting import envelopes, BOXPLOT, lines, HIST, KDE

results = load_results(r'.\data\EMA results ModelSebastiaanGreeven 1000 exp.bz2')

plotting.lines(results, density=plotting.KDE)

plt.show()