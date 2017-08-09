import numpy as np
import matplotlib.pyplot as plt
import os
from scipy import interpolate
from matplotlib import rc
from interactive import *
from util import max_pts
import util
import sklearn.metrics as skm
from ll import load_all_graphs
import math


def load_all_stats(path, folders, headers):
    stats = {}
    for folder in folders:
        for dir in os.listdir(path + "data/" + folder):
            if not '.' in dir and not 'Icon' in dir:
                dir_stats = {}
                for file in os.listdir(path + "data/" + folder + '/' + dir):
                    if 'acc' in file:
                        acc_mat = np.genfromtxt(path + "data/" + folder + "/" + dir + "/" + file,
                                                delimiter=',')
                        if "enet" in file:
                            suff = "_enet"
                        elif "ridge" in file:
                            suff = "_ridge"
                        elif "lasso" in file:
                            suff = "_lasso"
                        for i in range(len(headers)):
                            dir_stats[headers[i] + suff] = acc_mat[1:, 1 + i]
                if not dir in stats:
                    stats[dir] = dir_stats
                    stats[dir]['count'] = 1
                else:  # combine
                    for header in dir_stats:
                        stats[dir][header] = np.add(stats[dir][header], dir_stats[header])  # /2
                    stats[dir]['count'] += 1
    for dir in stats:
        # print('count', stats[dir]['count'])
        for header in stats[dir]:
            if not header == 'count':
                stats[dir][header] = stats[dir][header] / stats[dir]['count']
    for dir in stats:
        if not stats[dir]['count'] == 3:
            print(dir + ' count only ' + str(stats[dir]['count']))
    return stats


def compare_regressions(path, stats, data_dir, stat='au_auc'):
    print('compare regression...')
    dirs_all = stats.keys()
    dirs_to_plot = dirs_all
    plt.title('Acc_AUC')

    plt.subplot(221)
    plt.title('ENet')
    for dir in sorted(dirs_to_plot, reverse=True):
        if 'simule' in dir:
            plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'x', markeredgewidth=1.5, markersize=10,
                     label=dir + '_enet')
        elif 'self_edges' in dir:
            plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'x', markeredgewidth=1.5, markersize=30,
                     label=dir + '_enet')
        else:
            plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'o', markeredgewidth=0,
                     label=dir + '_enet')
    # plt.xlim((0, 1000))
    if stat == 'au_auc':
        plt.ylim((.5, .75))
    plt.xlabel('Num Connections')
    plt.ylabel(stat)

    plt.subplot(222)
    plt.title('Ridge')
    for dir in sorted(dirs_to_plot, reverse=True):
        if 'simule' in dir:
            plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'x', markeredgewidth=1.5,
                     markersize=10,
                     label=dir + '_ridge')
        elif 'self_edges' in dir:
            plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'x', markeredgewidth=1.5,
                     markersize=30,
                     label=dir + '_ridge')
        else:
            plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'o', markeredgewidth=0,
                     label=dir + '_ridge')
            # plt.xlim((0, 1000))
    if stat == 'au_auc':
        plt.ylim((.5, .75))
    plt.xlabel('Num Connections')
    plt.ylabel(stat)

    plt.subplot(223)
    plt.title('Lasso')
    for dir in sorted(dirs_to_plot, reverse=True):
        if 'simule' in dir:
            plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'x', markeredgewidth=1.5, markersize=10,
                     label=dir + '_lasso')
        else:
            plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'o', markeredgewidth=0,
                     label=dir + '_lasso')
            # plt.xlim((0, 1000))
    if stat == 'au_auc':
        plt.ylim((.5, .75))
    plt.xlabel('Num Connections')
    plt.ylabel(stat)

    plt.subplot(224)
    plt.title('Acc_Max')
    count = 0
    for dir in sorted(dirs_to_plot, reverse=True):
        if 'simule' in dir:
            plt.plot(count, np.mean(np.array(stats[dir]['acc_max_enet'])), 'x', markeredgewidth=1.5, label=dir)
        else:
            plt.plot(count, np.mean(np.array(stats[dir]['acc_max_enet'])), 'o', markeredgewidth=0, label=dir)
        count += 1
    # plt.ylim((.5, 1.05))
    plt.ylabel("Maximum Accuracy")
    plt.legend(frameon=False, loc="best", mode="expand", ncol=3)
    plt.savefig(path + 'plots/acc/reg/' + str(data_dir) + '_' + stat + '.pdf')


def compare_intertwined(path, stats, data_dir, stat='au_auc'):
    print('compare intertwined...')
    dirs_all = stats.keys()
    fig = plt.figure(figsize=(12, 10), tight_layout=True, facecolor='white')  # should be 60
    for method in dirs_all:
        if method + '_i' in dirs_all:
            plt.clf()
            plot_setup()
            dirs_to_plot = [method, method + '_i']
            plt.title('Acc_AUC')

            plt.subplot(221)
            plt.title('ENet')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_enet')
                else:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'o', markeredgewidth=0,
                             label=dir + '_enet')
            # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .7))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(222)
            plt.title('Ridge')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_ridge')
                else:
                    plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'o', markeredgewidth=0,
                             label=dir + '_ridge')
                    # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .75))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(223)
            plt.title('Lasso')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_lasso')
                else:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'o', markeredgewidth=0,
                             label=dir + '_lasso')
                    # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .7))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(224)
            plt.title('Acc_Max')
            count = 0
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(count, max(stats[dir]['acc_max_enet']), 'x', markeredgewidth=1.5, label=dir)
                else:
                    plt.plot(count, max(stats[dir]['acc_max_enet']), 'o', markeredgewidth=0, label=dir)
                count += 1
            # plt.ylim((.5, 1.05))
            plt.ylabel("Maximum Accuracy")
            plt.legend(frameon=False, loc="best", mode="expand", ncol=3)
            plt.savefig(path + 'plots/acc/intertwined/' + method + '_' + str(data_dir) + '_' + stat + '.pdf')


def compare_cov(path, stats, data_dir, stat='au_auc'):
    print('compare cov...')
    dirs_all = stats.keys()
    fig = plt.figure(figsize=(12, 10), tight_layout=True, facecolor='white')  # should be 600
    for method in dirs_all:
        if 'n' + method in dirs_all:
            plt.clf()
            plot_setup()
            dirs_to_plot = [method, 'n' + method]
            plt.title('Acc_AUC')

            plt.subplot(221)
            plt.title('ENet')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_enet')
                else:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_enet'], 'o', markeredgewidth=0,
                             label=dir + '_enet')
            # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .7))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(222)
            plt.title('Ridge')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_ridge')
                else:
                    plt.plot(stats[dir]['num_edges_ridge'], stats[dir][stat + '_ridge'], 'o', markeredgewidth=0,
                             label=dir + '_ridge')
                    # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .75))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(223)
            plt.title('Lasso')
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'x', markeredgewidth=1.5,
                             markersize=10,
                             label=dir + '_lasso')
                else:
                    plt.plot(stats[dir]['num_edges_enet'], stats[dir][stat + '_lasso'], 'o', markeredgewidth=0,
                             label=dir + '_lasso')
                    # plt.xlim((0, 1000))
            if stat == 'au_auc':
                plt.ylim((.5, .7))
            plt.xlabel('Num Connections')
            plt.ylabel(stat)

            plt.subplot(224)
            plt.title('Acc_Max')
            count = 0
            for dir in sorted(dirs_to_plot, reverse=True):
                if 'simule' in dir:
                    plt.plot(count, max(stats[dir]['acc_max_enet']), 'x', markeredgewidth=1.5, label=dir)
                else:
                    plt.plot(count, max(stats[dir]['acc_max_enet']), 'o', markeredgewidth=0, label=dir)
                count += 1
            # plt.ylim((.5, 1.05))
            plt.ylabel("Maximum Accuracy")
            plt.legend(frameon=False, loc="best", mode="expand", ncol=3)
            plt.savefig(path + 'plots/acc/cov/' + method + '_' + str(data_dir) + '_' + stat + '.pdf')


def plot_ridge(path, stats, data_dir, stat='au_auc', show_i=True):
    fig = plt.figure(figsize=(4, 6), tight_layout=True, facecolor='white')  # should be 600
    # plt.figure(figsize=(12, 5), tight_layout=True, facecolor='white')  # should be 600
    dirs_all = stats.keys()
    dirs_to_plot = dirs_all
    dirs_to_hide = ["simule_dist_6", "simule_dist_4"]
    dirs_to_hide = dirs_to_hide + ["n" + x for x in dirs_to_hide]
    for dir in sorted(dirs_to_plot, reverse=True):
        if not (show_i == False and '_i' in dir) and not dir in dirs_to_hide:
            # print(dir)
            x = np.array(stats[dir]['num_edges_ridge'])
            y = np.array(stats[dir][stat + '_ridge'])

            points = zip(x, y)
            points = sorted(points, key=lambda point: point[0])
            x, y = zip(*points)

            x = np.array(x, dtype='double')
            y = np.array(y, dtype='double')
            x, y = max_pts(500, x, y)

            if dir[0] == 'n':
                plt.subplot(211)
            else:
                plt.subplot(212)
            if True:  # 'n' in dir:
                # print('\t', dir, 'size before', y.shape)
                good_idxs = y > .5
                x = x[good_idxs]
                y = y[good_idxs]
                if len(x) > 2:
                    # print(dir, 'size after', y.shape)
                    # xnew = np.arange(0, 10000, 100)
                    # spline
                    # f = interpolate.splrep(x, y, k=3)
                    # ynew = interpolate.splev(xnew, f)
                    f = interpolate.interp1d(x, y, kind="slinear")
                    y = f(x)
                    if 'dist' in dir:
                        dir = dir.replace('simule_dist', 'welm')
                        plt.plot(x / 256, y, label=dir.upper())
                    else:
                        plt.plot(x / 256, y, linestyle='dotted', label=dir.upper())
                        # plt.ylim((.6, .75))

    plt.subplot(211)
    plt.title('Nonparanormal Methods', size=10)
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 30))
    # plt.ylim((.62, .76))
    # plt.xlabel('Number of Differential Edges')
    plt.legend(frameon=False, loc="lower right", ncol=2, fontsize=7)
    plt.subplot(212)
    plt.title('Covariance Methods', size=10)
    plt.xlabel('Sparsity of Differential Graph (%)')
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 30))
    plt.ylim((.62, .76))
    plt.legend(frameon=False, loc=4, mode="lower right", ncol=2, fontsize=7)
    util.ax_titles()
    plt.savefig(path + 'plots/acc/' + str(data_dir) + '_ridge_' + stat + '.pdf')


def plot_best(path, stats, data_dir, stat='au_auc', show_i=True):
    fig = plt.figure(figsize=(4, 6), tight_layout=True, facecolor='white')  # should be 600
    # plt.figure(figsize=(12, 5), tight_layout=True, facecolor='white')  # should be 600
    dirs_all = stats.keys()
    dirs_to_plot = dirs_all
    dirs_to_hide = ["simule_dist_6", "simule_dist_4"]
    dirs_to_hide = dirs_to_hide + ["n" + x for x in dirs_to_hide]
    for dir in sorted(dirs_to_plot, reverse=True):
        if not (show_i == False and '_i' in dir) and not dir in dirs_to_hide:
            # print(dir)
            x = np.array(stats[dir]['num_edges_ridge'])
            y = np.array(stats[dir][stat + '_ridge'])

            points = zip(x, y)
            points = sorted(points, key=lambda point: point[0])
            x, y = zip(*points)

            x = np.array(x, dtype='double')
            y = np.array(y, dtype='double')
            x, y = max_pts(500, x, y)

            if dir[0] == 'n':
                plt.subplot(211)
            else:
                plt.subplot(212)
            if True:  # 'n' in dir:
                # print('\t', dir, 'size before', y.shape)
                good_idxs = y > .5
                x = x[good_idxs]
                y = y[good_idxs]
                if len(x) > 2:
                    # print(dir, 'size after', y.shape)
                    # xnew = np.arange(0, 10000, 100)
                    # spline
                    # f = interpolate.splrep(x, y, k=3)
                    # ynew = interpolate.splev(xnew, f)
                    f = interpolate.interp1d(x, y, kind="slinear")
                    y = f(x)
                    if 'dist' in dir:
                        # print('dir',dir)
                        dir = dir.replace('simule_dist', 'welm').upper()
                        if dir == "NWELM_LABELS_2":
                            plt.plot(x / 256, y, linestyle='dotted', label="$\mathrm{W-SIMULE_{anatomical^2}}$")
                        elif dir == "WELM_LABELS_2":
                            plt.plot(x / 256, y, linestyle='dotted', label="$\mathrm{W-SIMULEG_{anatomical^2}}$")
                            # elif dir == "NSIMULE_5_DIST_LABELS_2":
                            #     plt.plot(x / 256, y, linestyle='dotted', label="$\mathrm{WELM_{anatomical3}}$")
                            # elif dir == "NWELM":
                            #     plt.plot(x / 256, y, linestyle='dotted', label="$\mathrm{WELM_{dist}}$")
                    else:
                        plt.plot(x / 256, y, label=dir.upper())
                        # plt.ylim((.6, .75))

    plt.subplot(211)
    plt.title('Nonparanormal Methods', size=10)
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 30))
    # plt.ylim((.62, .76))
    # plt.xlabel('Number of Differential Edges')
    plt.legend(frameon=False, loc="lower right", ncol=1, fontsize=9)
    plt.subplot(212)
    plt.title('Covariance Methods', size=10)
    plt.xlabel('Sparsity of Differential Graph (%)')
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 30))
    plt.ylim((.62, .76))
    plt.legend(frameon=False, loc=4, mode="lower right", ncol=1, fontsize=9)
    util.ax_titles(default=False)
    plt.savefig(path + 'plots/acc/' + str(data_dir) + '_best_ridge_' + stat + '.pdf')


def plot_comp(path, stats, data_dir, stat='au_auc', show_i=True):
    fig = plt.figure(figsize=(4, 6), tight_layout=True, facecolor='white')  # should be 600
    # plt.figure(figsize=(12, 5), tight_layout=True, facecolor='white')  # should be 600
    dirs_all = stats.keys()
    dirs_to_plot = dirs_all
    dirs_to_hide = ["simule_dist_6", "simule_dist_4"]
    dirs_to_hide = dirs_to_hide + ["n" + x for x in dirs_to_hide]
    for dir in sorted(dirs_to_plot, reverse=True):
        if not (show_i == False and dir[-1] == 'i') and not dir in dirs_to_hide:
            # print(dir)
            x = np.array(stats[dir]['num_edges_ridge'])
            y = np.array(stats[dir][stat + '_ridge'])

            points = zip(x, y)
            points = sorted(points, key=lambda point: point[0])
            x, y = zip(*points)

            x = np.array(x)
            y = np.array(y)
            x, y = max_pts(500, x, y)

            # if dir[0] == 'n':
            #     plt.subplot(211)
            # else:
            # plt.subplot(212)
            if True:  # 'n' in dir:
                # print('\t', dir, 'size before', y.shape)
                good_idxs = y > .5
                x = x[good_idxs]
                y = y[good_idxs]
                if len(x) > 2:
                    # print(dir, 'size after', y.shape)
                    # xnew = np.arange(0, 10000, 100)
                    # spline
                    # f = interpolate.splrep(x, y, k=3)
                    # ynew = interpolate.splev(xnew, f)
                    f = interpolate.interp1d(x, y, kind="slinear")
                    y = f(x)
                    if 'dist' in dir:
                        plt.plot(x, y, linestyle='dotted', label=dir)
                    else:
                        plt.plot(x, y, label=dir)
                        # plt.ylim((.6, .75))

    # plt.subplot(211)
    plt.title('Nonparanormal Methods', size=10)
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 8500))
    plt.ylim((.62, .76))
    # plt.xlabel('Number of Differential Edges')
    plt.legend(frameon=False, loc="lower right", ncol=2, fontsize=7)
    # plt.subplot(212)
    plt.title('Covariance Methods', size=10)
    plt.xlabel('Number of Differential Edges')
    plt.ylabel('Accuracy AUC')
    plt.xlim((0, 8500))
    plt.ylim((.62, .76))
    plt.legend(frameon=False, loc=4, mode="lower right", ncol=2, fontsize=7)
    # util.ax_titles()
    plt.savefig(path + 'plots/acc/' + str(data_dir) + '_comp_' + stat + '.pdf')


def plot_setup():
    plt.xlabel("Number of Edges", **util.font)
    plt.ylabel("Accuracy", **util.font)


def calc_aucs(stats):
    plots = load_all_graphs(util.path + "data/", "full_1")
    print('calculating aucs...')
    dirs = ["nsimule_dist", "nsimule_dist_2", "nsimule_dist_labels_1", "nsimule_dist_labels_2",
            "nsimule_5_dist_labels_2", "nsimule_1_dist_labels_2", "nsimule_1e-6_dist_labels_2"]
    labs = ["Distance", "$\\text{Distance}^2$", "Anatomical1", "Anatomical2", "0.5", "0.1", "$10^{-6}$"]

    for i in range(len(dirs)):
        dir = dirs[i]
        x1 = plots[dir][0] / 512
        y1 = plots[dir][1]

        x = np.array(stats[dir]['num_edges_ridge']) / 512
        y = np.array(stats[dir]['au_auc_ridge'])

        # thresh >0, y>-inf
        idxs = y1 > -1e8
        x1, y1 = x1[idxs], y1[idxs]
        idxs = x > 0
        x, y = x[idxs], y[idxs]
        # print("min y", min(y1))

        # thresh < 7%
        i7_1 = x1 < 7
        i7 = x < 7
        ll_7 = skm.auc(x1[i7_1], y1[i7_1]) / 7
        acc_7 = skm.auc(x[i7], y[i7]) / 7

        # thresh < 15%
        i15_1 = x1 < 15
        i15 = x < 15
        ll_15 = skm.auc(x1[i15_1], y1[i15_1]) / 15
        acc_15 = skm.auc(x[i15], y[i15]) / 15

        auc = skm.auc(x, y)
        buf = "%s & %.2f & %.2f & %.2f & %.2f \\\\" % (labs[i], ll_7, acc_7, ll_15, acc_15)
        # print(labs[i], "&", ll_7, "&", acc_7, acc_15, "\\\\")
        print(buf)


def calc_acc_ll(stats):
    plots = load_all_graphs(util.path + "data/", "full_1")
    print('calculating aucs...')
    dirs = ["nsimule_dist", "nsimule_dist_2", "nsimule_dist_labels_1", "nsimule_dist_labels_2",
            "nsimule_5_dist_labels_2", "nsimule_1_dist_labels_2", "nsimule_1e-6_dist_labels_2"]
    labs = ["Distance", "$\\text{Distance}^2$", "Anatomical1", "Anatomical2", "0.5", "0.1", "$10^{-6}$"]

    for i in range(len(dirs)):
        dir = dirs[i]

        small = 5
        big = 20
        # ll
        x1 = plots[dir][0] / 512
        y1 = plots[dir][1]
        f_ll = interpolate.interp1d(x1, y1, kind="slinear")
        ll_7 = f_ll(small)
        ll_15 = f_ll(big)

        # acc auc
        x = np.array(stats[dir]['num_edges_ridge']) / 512
        y = np.array(stats[dir]['au_auc_ridge'])
        f_acc = interpolate.interp1d(x, y, kind="slinear")
        acc_7 = f_acc(small)
        acc_15 = f_acc(big)

        buf = "%s & %.2f & %.2f & %.2f & %.2f \\\\" % (labs[i], ll_7, acc_7, ll_15, acc_15)
        # # print(labs[i], "&", ll_7, "&", acc_7, acc_15, "\\\\")
        print(buf)


if __name__ == "__main__":
    plot_setup()
    path = util.path
    headers = ['num_edges', 'acc_max', 'acc_balanced', 'f1', 'au_auc', 'au_prec', 'au_recall']
    # data_dirs = ['full_1', 'full_3', 'full_6']  # 1 and 3 look good
    data_dirs = ['full_1']
    stats = load_all_stats(path, data_dirs, headers)
    print("headers", headers)
    print("keys", sorted(stats.keys()))
    # calc_aucs(stats)
    # calc_acc_ll(stats)
    # plot_ridge(path, stats, data_dirs, 'au_auc', show_i=False)
    plot_best(path, stats, data_dirs, 'au_auc', show_i=False)
    # for dir in data_dirs:
    # plot_comp(path, stats, data_dirs, 'au_auc', show_i=False)
    # compare_regressions(path, stats, data_dirs, 'au_auc')
    # compare_intertwined(path,stats, data_dirs, 'au_auc')
    # compare_cov(path,stats, data_dirs, 'au_auc')
    interactive_legend().show()
