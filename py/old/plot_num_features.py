import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rc
import os
import pickle
from cycler import cycler

cblue = '#5DA5DA'
cgreen = '#60BD68'
rc('lines', markersize=8)
rc('legend', numpoints=1)
rc('axes', labelsize=14)
rc('axes_color_cycle')
plt.rc('axes', prop_cycle=(cycler('color', [cblue, 'r', cgreen])))
fig = plt.figure(figsize=(14, 4), tight_layout=True, facecolor='white')  # should be 600


def load_data():
    suff = ["", "k"]
    lams, auts, conts, shares = [], [], [], []
    for file in os.listdir("data"):
        arr = file.split("_")
        print(arr)
        if not 'likelihood' in arr[1]:
            if '.csv' in arr[3]:
                arr[3] = arr[3][:-4]
            lams.append(arr[3])
    print(lams)

    for lam in lams:
        autism = np.loadtxt('data/simule/autism_train_' + lam + '_0.01.csv', delimiter=',')
        control = np.loadtxt('data/simule/control_train_' + lam + '_0.01.csv', delimiter=',')
        shared = np.loadtxt('data/simule/shared_train_' + lam + '_0.01.csv', delimiter=',')
        auts.append(np.sum((autism - shared) != 0))
        conts.append(np.sum((control - shared) != 0))
        shares.append(np.sum(shared != 0))

    pickle.dump([lams, auts, conts, shares], open("num_features.pkl", "wb"))


load_data()

[lams, auts, conts, shares] = pickle.load(open("num_features.pkl", "rb"))

plt.subplot(131)
plt.plot(lams, auts, 'o', markeredgewidth=0, label='SIMULE $\epsilon$=.01')
plt.title('Autism Context-Specific')
plt.ylabel("Num Connections")
plt.xlabel("$\lambda$")
plt.legend(frameon=False)

plt.subplot(132)
plt.plot(lams, conts, 'o', markeredgewidth=0, label='SIMULE $\epsilon$=.01')
plt.title('Control Context-Specific')
plt.ylabel("Num Connections")
plt.xlabel("$\lambda$")
plt.legend(frameon=False)

plt.subplot(133)
plt.plot(lams, shares, 'o', markeredgewidth=0, label='SIMULE $\epsilon$=.01')
plt.title('Shared')
plt.ylabel("Num Connections")
plt.xlabel("$\lambda$")
plt.legend(frameon=False)

'''
simule = np.loadtxt("data/lam_v_num.csv", delimiter=',')
jgl_group = np.loadtxt("data/lam_v_num_jgl_group.csv", delimiter=',')
jgl_fused = np.loadtxt("data/lam_v_num_jgl_fused.csv", delimiter=',')
plt.plot(simule[:, 0], simule[:, 1], 'o', markeredgewidth=0, color=cblue, label='simule')
plt.plot(jgl_group[:, 0], jgl_group[:, 1], '^', markeredgewidth=0, color='red', label='jgl_group')
plt.plot(jgl_fused[:, 0], jgl_fused[:, 1], 'x', markeredgewidth=1, color=cgreen, label='jgl_fused')
'''

plt.hold(True)
plt.savefig('plots/num_features.pdf')
plt.show()
