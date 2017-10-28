import numpy as np
import matplotlib.pyplot as plt
import cPickle

def add_plot(file, label, color):
	dict = cPickle.load(open(file, "rb"))

	pos0_exp_dist_l = dict['pos0_exp_dist_l']
	pos0_exp_dist = np.concatenate(pos0_exp_dist_l, axis=0)

	pos1_exp_dist_l = dict['pos1_exp_dist_l']
	pos1_exp_dist = np.concatenate(pos1_exp_dist_l, axis=0)

	mean_pos_exp = np.mean(np.concatenate([pos0_exp_dist, pos1_exp_dist], axis=0), axis=0)
	std_pos_exp = np.std(np.concatenate([pos0_exp_dist, pos1_exp_dist], axis=0), axis=0) / np.sqrt(128.)

	plt.errorbar(np.arange(mean_pos_exp.shape[0])+1, mean_pos_exp, yerr=std_pos_exp, fmt='o-', color=color,
	label=label, linewidth=2)

	# return(pos0)


# def plot(file):

gray = '#4D4D4D'
blue = '#5DA5DA'
orange = '#FAA43A'
green = '#60BD68'
pink = '#F17CB0'
brown = '#B2912F'
purple = '#B276B2'
yellow = '#DECF3F'
red = '#F15854'

f = plt.figure(figsize=(6, 5))

file = './flow/cdna_metric_values.pkl'
add_plot(file, 'CDNA [Finn et al., 2016]', orange)

file = './flow/sna_metric_values.pkl'
add_plot(file, 'SNA [Ebert et al., 2017]', pink)

file = './flow/ours_l2_metric_values.pkl'
add_plot(file, 'Ours (no adv)', red)

file = './flow/adv_ours_metric_values.pkl'
add_plot(file, 'Ours', blue)

plt.plot([1,13],[0,0],color=gray,linewidth=4,label='Ground Truth')

plt.xlabel('Predicted Time Steps')
# plt.ylabel('distance between predicted and true object positions +-std.err')
plt.ylabel('Predicted Position Error [pix]')
plt.xlim((1,13))
plt.ylim((-.5,9))
plt.legend(loc=0,fontsize='small')

plt.tight_layout()
plt.savefig('./distance_metric.pdf')
# plt.show()
