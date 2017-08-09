import numpy as np
import matplotlib.pyplot as plt
import os
from interactive import *
from util import max_pts
import util
from scipy import interpolate
import sklearn.metrics as skm


def load_all_graphs(path_folder, folder):
    stats = {}
    path = os.path.join(path_folder, folder)
    for dir in os.listdir(path):
        if not '.' in dir and not 'Icon' in dir:
            try:
                if 'likelihood_.csv' in os.listdir(os.path.join(path, dir, "ll")):
                    ll = np.genfromtxt(os.path.join(path, dir, "ll", "likelihood_.csv"), delimiter='\t')
                    edges = ll[0, 1:]
                    bics = ll[2, 1:]
                    stats[dir] = (edges, bics)
            except:
                pass
    return stats


def calc_aucs(plots):
    print('calculating aucs...')
    dirs = ["simule_dist_labels_2"]
    for dir in dirs:
        edges = plots[dir][0] / 512
        ll = plots[dir][1]
        auc = skm.auc(edges, ll)
        # thresh >0
        idxs = edges > 0
        edges = edges[idxs]
        ll = ll[idxs]
        print('edges', edges)
        print('ll', ll)
        print(dir, "&", auc)


def plot_nice_best(plots, end=51842):
    fig = plt.figure(figsize=(4, 6), tight_layout=True, facecolor='white')  # should be 600
    dirs_to_plot = plots.keys()
    for dir in sorted(dirs_to_plot, reverse=True):
        edges = plots[dir][0]
        ll = plots[dir][1]
        x, y = max_pts(2000, edges, ll)
        if dir[0] == "n":
            ax = plt.subplot(211)
        else:
            ax = plt.subplot(212)
        if not 'simone' in dir and not '_i' in dir:
            if 'dist' in dir:
                dir = dir.replace('simule_dist', 'WELM').upper()
                if dir == "NWELM_2":
                    ax.plot(x / 512, y, linestyle='dotted', label="$\mathrm{W-SIMULE_{dist^2}}$")
                elif dir == "WELM_2":
                    ax.plot(x / 512, y, linestyle='dotted', label="$\mathrm{W-SIMULEG_{dist^2}}$")
            else:
                ax.plot(x / 512, y, label=dir.upper())
    plt.subplot(211)
    plt.title('Nonparanormal Methods', size=10)
    # plt.xlabel("Number of Total Edges", **util.font)
    plt.ylabel("Log-Likelihood", **util.font)
    plt.legend(frameon=False, loc="best", ncol=1, fontsize=9)
    plt.xlim((0, 60))
    plt.subplot(212)
    plt.title('Covariance Methods', size=10)
    plt.ylabel("Log-Likelihood", **util.font)
    plt.xlabel("Total Graph Sparsity (%)", **util.font)
    plt.legend(frameon=False, loc="best", ncol=1, fontsize=9)
    plt.xlim((0, 60))
    plt.ylim((-2970, -2870))
    util.ax_titles()
    plt.savefig(util.path + 'plots/ll/ll_best.pdf')


def plot_nice(plots, end=51842):
    fig = plt.figure(figsize=(4, 6), tight_layout=True, facecolor='white')  # should be 600
    dirs_to_plot = plots.keys()
    for dir in sorted(dirs_to_plot, reverse=True):
        edges = plots[dir][0]
        ll = plots[dir][1]
        x, y = max_pts(2000, edges, ll)
        if dir[0] == "n":
            ax = plt.subplot(211)
        else:
            ax = plt.subplot(212)
        if not 'simone' in dir and not '_i' in dir:
            if 'dist' in dir:
                ax.plot(x / 512, y, linestyle='dotted', label=dir.replace('simule_dist', 'WELM').upper())
            else:
                ax.plot(x / 512, y, label=dir.upper())
    plt.subplot(211)
    plt.title('Nonparanormal Methods', size=10)
    # plt.xlabel("Number of Total Edges", **util.font)
    plt.ylabel("Log-Likelihood", **util.font)
    plt.legend(frameon=False, loc="best", ncol=2, fontsize=7)
    plt.xlim((0, 60))
    plt.subplot(212)
    plt.title('Covariance Methods', size=10)
    plt.ylabel("Log-Likelihood", **util.font)
    plt.xlabel("Total Graph Sparsity (%)", **util.font)
    plt.legend(frameon=False, loc="best", ncol=2, fontsize=7)
    plt.xlim((0, 60))
    util.ax_titles()
    if end < 51842:
        plt.savefig(util.path + 'plots/ll/ll_' + str(end) + '.pdf')
        # plt.savefig(util.path + 'plots/ll/ll_' + str(end) + '.png', dpi=300)
    else:
        plt.savefig(util.path + 'plots/ll/ll_v_num_features.pdf')
        # plt.savefig(util.path + 'plots/ll/ll_v_num_features.png', dpi=300)


def plot_setup():
    print('plot setup...')
    plt.xlabel("Total Graph Sparsity (%)", **util.font)
    plt.ylabel("Log-Likelihood", **util.font)


if __name__ == '__main__':
    util.path
    plots = load_all_graphs(util.path + "data/", "full_1")
    print("keys", sorted(plots.keys()))
    calc_aucs(plots)
    plot_nice(plots, end=20000)
    plot_nice_best(plots, end=20000)
    # plot_nice(plots, 10000)
    # interactive_legend().show()
