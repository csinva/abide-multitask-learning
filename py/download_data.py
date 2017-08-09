import nilearn.datasets

# print("fetching data...")
data = nilearn.datasets.fetch_abide_pcp(derivatives='rois_dosenbach160', DX_GROUP=1, pipeline='cpac')
data = nilearn.datasets.fetch_abide_pcp(derivatives='rois_dosenbach160', DX_GROUP=2, pipeline='cpac')
# pipeline='dparsf', derivatives='rois_dosenbach160')
print("success!!!!")
