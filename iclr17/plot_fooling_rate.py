
import numpy as np
import matplotlib.pyplot as plt

gray = '#4D4D4D'
blue = '#5DA5DA'
orange = '#FAA43A'
green = '#60BD68'
pink = '#F17CB0'
brown = '#B2912F'
purple = '#B276B2'
yellow = '#DECF3F'
red = '#F15854'

fooling_rates = np.array([[0.13615,0.10448,0.10837,0.10194,0.082051,0.11538,0.08,0.10048,0.073892,0.088083,0.077295,0.11579,0.097345,0.070707,0.065657],
	[0.13776,0.059701,0.10294,0.069519,0.070539,0.10891,0.055866,0.090047,0.074627,0.060185,0.060748,0.051724,0.042654,0.083333,0.063348],
	[0.18009,0.19298,0.26667,0.17277,0.15254,0.15217,0.19653,0.16,0.13613,0.13636,0.11628,0.18817,0.15426,0.20556,0.11979],
	[0.30435,0.25907,0.34343,0.27072,0.28436,0.25822,0.23881,0.23563,0.27568,0.20225,0.20725,0.18634,0.20106,0.25628,0.23684]])

f = plt.figure(figsize=(6,5))
plt.plot(np.arange(1,16),np.zeros(15)+50,'-',color=gray,label='Ground Truth',linewidth=4)
plt.plot(np.arange(1,16),100*fooling_rates[0,:],'o-',color=orange,label='CDNA [Finn et al., 2016]',linewidth=2)
plt.plot(np.arange(1,16),100*fooling_rates[1,:],'o-',color=pink,label='SNA [Ebert et al., 2017]',linewidth=2)
plt.plot(np.arange(1,16),100*fooling_rates[2,:],'o-',color=red,label='Ours (no adv)',linewidth=2)
plt.plot(np.arange(1,16),100*fooling_rates[3,:],'o-',color=blue,label='Ours',linewidth=2)
plt.xlabel('Predicted Time Steps')
plt.ylabel('AMT Fooling Rate [%]')
plt.ylim((0,54))
plt.xlim((1,15))
plt.legend(loc=1,fontsize='small')
f.tight_layout()
plt.savefig('./fooling.pdf')

