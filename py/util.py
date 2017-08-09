import numpy as np

global path
from matplotlib import rc
import matplotlib.pyplot as plt

font = {  # 'family': 'normal',
    'size': 10}
font_small = {  # 'family': 'normal',
    'size': 8}

rc('lines', markersize=4)
rc('legend', numpoints=1, fontsize=10)
rc('axes', labelsize=10)
rc('lines', markeredgewidth=0)
rc('axes', color_cycle=['#E24A33', '#348ABD', '#988ED5', '#777777', '#FBC15E',
                        '#8EBA42', '#FFB5B8', 'red', 'green', 'blue', 'purple', 'cyan', 'black', 'brown'])
rc('xtick', labelsize=7)
rc('ytick', labelsize=7)
plt.hold(True)
path = '/Users/chandansingh/drive/asdf/research/singh_connectome/'

import matplotlib
matplotlib.rcParams['mathtext.fontset'] = 'custom'
matplotlib.rcParams['mathtext.rm'] = 'Bitstream Vera Sans'
matplotlib.rcParams['mathtext.it'] = 'Bitstream Vera Sans:italic'
matplotlib.rcParams['mathtext.bf'] = 'Bitstream Vera Sans:bold'


# want a width of 3.25

def max_pts(interval, x, y):
    xnew, ynew = [], []
    too_big = False
    i = 0
    while not too_big:
        start = i * interval
        end = (i + 1) * interval
        idxs = np.logical_and(x > start, x <= end)
        # print(sum(idxs))
        i += 1
        x_int = x[idxs]
        y_int = y[idxs]
        if len(x_int > 0):
            y_max = np.max(y_int)
            y_argmax = np.argmax(y_int)
            x_max = x_int[y_argmax]
            xnew.append(x_max)
            ynew.append(y_max)
        if end > max(x):
            too_big = True

    # print(x, y)
    return np.array(xnew), np.array(ynew)


def ax_titles(default=True):
    if default:
        ax = plt.subplot(211)
        ax.text(0, 1.05, 'A', transform=ax.transAxes, size=10, weight='bold')
        ax = plt.subplot(212)
        ax.text(0, 1.05, 'B', transform=ax.transAxes, size=10, weight='bold')
    if not default:
        ax = plt.subplot(211)
        ax.text(0, 1.05, 'C', transform=ax.transAxes, size=10, weight='bold')
        ax = plt.subplot(212)
        ax.text(0, 1.05, 'D', transform=ax.transAxes, size=10, weight='bold')
