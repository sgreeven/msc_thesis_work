'''
Created on 10 feb. 2014
Sebastiaan Greeven 

Based on code from jhkwakkel <j.h.kwakkel (at) tudelft (dot) nl>
'''

import numpy as np
import matplotlib.pyplot as plt

from expWorkbench import load_results
from analysis import plotting
from analysis.plotting import envelopes, lines
from analysis.plotting_util import KDE, HIST, VIOLIN, BOXPLOT


results = load_results(r'./data/EMA results ModelSebastiaanGreeven 1000 exp .tar.gz')

plotting.lines(results, density=plotting.KDE)

plt.show()