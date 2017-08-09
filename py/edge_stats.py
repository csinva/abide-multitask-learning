import numpy as np
import matplotlib.pyplot as plt
import os
from interactive import *
from util import max_pts
import util
from scipy import interpolate


def load_all_graphs(path_folder, folder):
    stats = {}
    path = os.path.join(path_folder, folder)
    for dir in os.listdir(path):
        # print('dir', dir)
        try:
            if 'connectome_stats_1.csv' in os.listdir(os.path.join(path, dir, 'll')):
                conn_stats_con = np.genfromtxt(os.path.join(path, dir, "connectome_stats_1.csv"), delimiter=',')
                conn_stats_aut = np.genfromtxt(os.path.join(path, dir, "connectome_stats_2.csv"), delimiter=',')
                conn_stats_diff = np.genfromtxt(os.path.join(path, dir, "connectome_stats_3.csv"), delimiter=',')
                # print('\tgenerated conn stats!', conn_stats)
                conn_stats = {}
                conn_stats['num_edges'] = (conn_stats_con[1:, 1], conn_stats_aut[1:, 1], conn_stats_diff[1:, 1])
                conn_stats['means'] = (conn_stats_con[1:, 2], conn_stats_aut[1:, 2], conn_stats_diff[1:, 2])
                conn_stats['vars'] = (conn_stats_con[1:, 3], conn_stats_aut[1:, 3], conn_stats_diff[1:, 3])
                stats[dir] = conn_stats
        except:
            pass
    return stats


def plot_nice(plots, end=51842):
    # dirs_to_plot = ['nsimule', 'nsimule_i', 'simone', 'simone_i', 'nglasso', 'nglasso_i', 'nclime', 'nclime_i']
    fig = plt.figure(figsize=(3, 2.5), tight_layout=True, facecolor='white')  # should be 600
    dirs_to_plot = plots.keys()
    try:
        for dir in sorted(dirs_to_plot, reverse=False):
            n0, n1 = plots[dir]['num_edges'][0], plots[dir]['num_edges'][1]
            m0, m1 = plots[dir]['means'][0], plots[dir]['means'][1]
            num_edges = n0 + n1
            means = [(m0[i] * n0[i] + m1[i] * n1[i]) / num_edges[i] for i in range(len(n0))]
            x = sorted(num_edges)
            y = sorted(means)
            if dir[:4] == "nsim" and not 'networks' in dir and not 'labels' in dir and not '_i' in dir and not 'e_1' in dir and not 'e_5' in dir:
                # if "dist" in dir:
                #     plt.plot(num_edges, means, 'x', markeredgewidth=1, label=dir)
                # else:
                #     plt.plot(num_edges, means, 'o', markeredgewidth=0, label=dir)
                # f = interpolate.interp1d(x, y, kind="slinear")
                # y = f(x)
                if dir[8:]=="":
                    lab = "NSIMULE"
                else:
                    if dir[-1].isdigit():
                        lab = "WELM_{dist^"+dir[-1]+"}"
                    else:
                        lab = "WELM_{dist}"
                    plt.plot([a/526.0 for a in x], y, label="$\mathrm{"+lab+"}$")
    except:
        pass
    num_edges, means = calc_ave_lens()
    # plt.xlim((0, 50000))
    plt.plot([x/526 for x in num_edges[:]], means[:], markeredgewidth=0, label='OPTIMAL')
    plt.xlabel("Total Graph Sparsity (%)", **util.font_small)
    plt.ylabel("Average Edge Length (MNI Space)", **util.font_small)
    plt.legend(frameon=False, loc="best", ncol=1, fontsize=7)
    # plt.savefig(util.path + 'plots/edge_stats/edge_stats_v_num_features.png', dpi=300)
    plt.savefig(util.path + 'plots/edge_stats/edge_stats_v_num_features.pdf', dpi=300)


def plot_nice_orig(plots, end=51842):
    # dirs_to_plot = ['nsimule', 'nsimule_i', 'simone', 'simone_i', 'nglasso', 'nglasso_i', 'nclime', 'nclime_i']
    fig = plt.figure(figsize=(6, 3.25), tight_layout=True, facecolor='white')  # should be 600
    dirs_to_plot = plots.keys()
    try:
        for dir in sorted(dirs_to_plot, reverse=True):
            plt.subplot(121)
            n0, n1 = plots[dir]['num_edges'][0], plots[dir]['num_edges'][1]
            m0, m1 = plots[dir]['means'][0], plots[dir]['means'][1]
            num_edges = n0 + n1
            means = [(m0[i] * n0[i] + m1[i] * n1[i]) / num_edges[i] for i in range(len(n0))]
            # num_edges = plots[dir]['num_edges'][0]
            # means = plots[dir]['means'][0]
            # (m0*n0+m1*m1)/num_edges
            if dir[0] == "n":
                if "dist" in dir:
                    plt.plot(num_edges, means, 'x', markeredgewidth=1, label=dir)
                else:
                    plt.plot(num_edges, means, 'o', markeredgewidth=0, label=dir)

                plt.subplot(122)
                num_edges = plots[dir]['num_edges'][2]
                means = plots[dir]['means'][2]
                if 'dist' in dir:
                    plt.plot(num_edges, means, 'x', markeredgewidth=1, label=dir)
                else:
                    plt.plot(num_edges, means, 'o', markeredgewidth=0, label=dir)
    except:
        pass

    ax = plt.subplot(121)
    num_edges, means = calc_ave_lens()
    plt.plot(num_edges[:], means[:], markeredgewidth=0, label='optimal')
    plt.xlabel("Number of Total Edges", **util.font)
    plt.ylabel("Average Edge Length", **util.font)

    ax = plt.subplot(122)
    plt.plot(0, 0, markeredgewidth=0, label='optimal')
    plt.xlabel("Number of Differential Edges", **util.font)
    # plt.ylabel("Average Edge Length", **util.font)
    plt.legend(frameon=False, loc="best", ncol=2, fontsize=9)

    ax = plt.subplot(121)
    ax.text(0, 1.05, 'A', transform=ax.transAxes, size=10, weight='bold')
    ax = plt.subplot(122)
    ax.text(0, 1.05, 'B', transform=ax.transAxes, size=10, weight='bold')

    plt.savefig(util.path + 'plots/edge_stats/diff_edge_stats_v_num_features.png', dpi=300)
    plt.savefig(util.path + 'plots/edge_stats/diff_edge_stats_v_num_features.pdf', dpi=300)


def plot_nice_var(plots, end=51842):
    # dirs_to_plot = ['nsimule', 'nsimule_i', 'simone', 'simone_i', 'nglasso', 'nglasso_i', 'nclime', 'nclime_i']
    fig = plt.figure(figsize=(6, 3.25), tight_layout=True, facecolor='white')  # should be 600
    dirs_to_plot = plots.keys()
    try:
        for dir in sorted(dirs_to_plot, reverse=True):
            plt.subplot(121)
            n0, n1 = plots[dir]['num_edges'][0], plots[dir]['num_edges'][1]
            m0, m1 = plots[dir]['vars'][0], plots[dir]['vars'][1]
            num_edges = n0 + n1
            means = [(m0[i] * n0[i] + m1[i] * n1[i]) / num_edges[i] for i in range(len(n0))]
            # num_edges = plots[dir]['num_edges'][0]
            # means = plots[dir]['means'][0]
            # (m0*n0+m1*m1)/num_edges
            if "dist" in dir:
                plt.plot(num_edges, means, 'x', markeredgewidth=1, label=dir)
            else:
                plt.plot(num_edges, means, 'o', markeredgewidth=0, label=dir)

            plt.subplot(122)
            num_edges = plots[dir]['num_edges'][2]
            means = plots[dir]['vars'][2]
            if 'dist' in dir:
                plt.plot(num_edges, means, 'x', markeredgewidth=1, label=dir)
            else:
                plt.plot(num_edges, means, 'o', markeredgewidth=0, label=dir)
    except:
        pass

    ax = plt.subplot(121)
    num_edges, means = calc_ave_lens()
    plt.plot(num_edges[:], means[:], markeredgewidth=0, label='optimal')
    plt.xlabel("Number of Total Edges", **util.font)
    plt.ylabel("Average Edge Length (MNI Space)", **util.font)

    ax = plt.subplot(122)
    plt.plot(0, 0, markeredgewidth=0, label='optimal')
    plt.xlabel("Number of Differential Edges", **util.font)
    # plt.ylabel("Average Edge Length", **util.font)
    plt.legend(frameon=False, loc="best", ncol=2, fontsize=9)

    ax = plt.subplot(121)
    ax.text(0, 1.05, 'A', transform=ax.transAxes, size=10, weight='bold')
    ax = plt.subplot(122)
    ax.text(0, 1.05, 'B', transform=ax.transAxes, size=10, weight='bold')

    # plt.savefig(util.path + 'plots/edge_stats/edge_var_stats_v_num_features.png', dpi=300)
    plt.savefig(util.path + 'plots/edge_stats/edge_var_stats_v_num_features.pdf', dpi=300)


def calc_ave_lens():
    dists = np.genfromtxt(util.path + 'data/dists.csv', delimiter=',')
    dists = np.array(sorted(dists.flatten()))
    print("dists", dists.shape)

    dists = np.array(sorted(np.concatenate((dists, dists))))
    print("dists 2", dists.shape)
    lens = np.zeros(dists.shape)
    lens[0] = dists[0]
    for i in range(1, len(lens)):
        lens[i] = lens[i - 1] + dists[i]
    for i in range(len(lens)):
        lens[i] /= (i + 1)
    return range(lens.shape[0]), lens


if __name__ == '__main__':
    plots = load_all_graphs(util.path + "data/", "full_1")
    print("keys", sorted(plots.keys()))
    plot_nice(plots)
    # plot_nice_var(plots)
    # interactive_legend().show()
    # plt.show()
