import numpy
from nilearn import datasets
from nilearn import plotting
from PyPDF2 import PdfFileMerger
import util
import matplotlib.pyplot as plt


def plot_connectome(path):
    # Each of these is a p X p matrix, where p = the number of brain regions
    # In this dataset, we're looking at 160 ROIs. Each matrix graphs the functional dependencies between pairs of ROIs (building a connectome)
    # for 2 groups - patients with ASD and control subjects
    folder = "data/full_1/nsimule_dist_2/"
    autism = numpy.loadtxt(path + folder + "autism_0.2_1.csv",
                           delimiter=',')  # File containing the output graph from running SIMULE - autism
    control = numpy.loadtxt(path + folder + "control_0.2_1.csv",
                            delimiter=',')  # File containing the output graph from running SIMULE - control

    autism = numpy.around(autism, decimals=3) != 0
    control = numpy.around(control, decimals=3) != 0
    print("shape", autism.shape)
    print("topleft", autism[:3, :3])

    # find diff
    diff = autism - control
    print("diff shape", diff.shape)
    print("nonzeros autism", numpy.sum(diff != 0))

    # Get the MNI coordinates for the Dosenbach atlas
    # Here I load the dosenbach atlas directly from nilearn, but you will need to provide a list of the MNI coordinates as a 2d array (see reformatting below)
    dos_coords = datasets.fetch_coords_dosenbach_2010()
    dos_coords = dos_coords.rois
    dos_coords_table = [[x, y, z] for (x, y, z) in dos_coords]  # Reformat the atlas coordinates

    # WARNING: The more coordinates, the slower this becomes. I haven't tried plotting with >160 coordinates, and it takes about a minute to plot.
    # You might need to consider filtering your coordinates down to fewer ROIs
    out = 'pdf'

    tit = {'fontsize': 14, 'horizontalalignment': 'center'}

    f = plt.figure(figsize=(2.3, 3.5))  # 2.2,2.3
    plotting.plot_connectome(-1 * autism, dos_coords_table, display_mode='z',
                             # output_file=path + "plots/connectomes/autism." + out,
                             # title="$\mathrm{\Omega^{Autism}}$",
                             annotate=False, figure=f, node_size=18)
    plt.title("$\mathrm{\hat{\Omega}^{Autism}}$", **tit)
    plt.savefig(path + "plots/connectomes/autism." + out)
    # print('out', plot_out)
    # plt.show()

    f = plt.figure(figsize=(2.3, 3.5))  # 2.2,2.3
    plotting.plot_connectome(-1 * control, dos_coords_table, display_mode='z',
                             # output_file=path + "plots/connectomes/autism." + out,
                             # title="$\mathrm{\Omega^{Autism}}$",
                             annotate=False, figure=f, node_size=18)
    plt.title("$\mathrm{\hat{\Omega}^{Control}}$", **tit)
    plt.savefig(path + "plots/connectomes/control." + out)

    f = plt.figure(figsize=(2.3, 3.5))  # 2.2,2.3
    plotting.plot_connectome(-1 * diff, dos_coords_table, display_mode='z',
                             # output_file=path + "plots/connectomes/autism." + out,
                             # title="$\mathrm{\Omega^{Autism}}$",
                             annotate=False, figure=f, node_size=18)
    plt.title("$\mathrm{\hat{\Omega}^{Autism}-\hat{\Omega}^{Control}}$", **tit)
    plt.savefig(path + "plots/connectomes/diff." + out)


def merge_pdfs(path):
    pdfs = [path + 'plots/connectomes/autism.pdf', path + '/plots/connectomes/control.pdf',
            path + '/plots/connectomes/diff.pdf']
    outfile = PdfFileMerger()
    for f in pdfs:
        outfile.append(open(f, 'rb'))
    outfile.write(open(path + '/plots/connectomes/merged.pdf', 'wb'))


def dist(vec1, vec2):
    sum = 0
    for i in range(3):
        sum += (vec1[i] - vec2[i]) * (vec1[i] - vec2[i])
    return sum ** (1 / 2)


def save_dists(path):
    # Get the MNI coordinates for the Dosenbach atlas
    # Here I load the dosenbach atlas directly from nilearn, but you will need to provide a list of the MNI coordinates as a 2d array (see reformatting below)
    dos_coords = datasets.fetch_coords_dosenbach_2010()
    print("networks", dos_coords.networks)
    labels = numpy.array([str(x[2:x.rfind(' ') - 1]) for x in dos_coords.labels])
    networks = numpy.array([x.decode("utf-8") for x in dos_coords.networks])

    print("networks shape", dos_coords.networks.shape)
    dos_coords = dos_coords.rois
    dos_coords_table = [[x, y, z] for (x, y, z) in dos_coords]  # Reformat the atlas coordinates
    dists = numpy.zeros((160, 160))
    for i in range(160):
        for j in range(160):
            dists[i, j] = dist(dos_coords_table[i], dos_coords_table[j])
            # print("coords", dos_coords_table)
    numpy.savetxt(path + '/data/dists.csv', dists, delimiter=',')
    numpy.savetxt(path + '/data/labels.csv', labels, fmt="%s", delimiter=',')
    numpy.savetxt(path + '/data/networks.csv', networks, fmt="%s", delimiter=',')


if __name__ == "__main__":
    # save_dists(util.path)
    plot_connectome(util.path)
    merge_pdfs(util.path)
