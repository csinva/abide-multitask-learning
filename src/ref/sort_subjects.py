# Script to separate .1D files into two folders based on the phenotype of Autism or Control

import csv
import os
import shutil
dict = {}

# Create a dictionary that maps a subject identifier to their designation as either control or autism
with open("Phenotypic_V1_0b_preprocessed.csv") as csvfile:
	reader = csv.reader(csvfile, delimiter=',', quotechar="|")
	for row in reader:
		
		subj = row[6]
		print("subj",subj)
		if subj != "no_filename":
			if row[7] == "1":
				dict[subj] =  1
			elif row[7] == '2':
				dict[subj] = 2
#print('dict',dict)
				
# Create three directories and sort the subjects into the appropriate folder
for f in os.listdir(os.getcwd()):
	if f.endswith(".1D"):
		f_split = f.split("_")
		inst = f_split[0]
		subject_split = []
		if inst in ["UM", "CMU", "Leuven", "UCLA", "MaxMun"]:
			# These insitituions have a slightly different naming convention for subjects
			subject_split = f_split[:3]
		else:
			subject_split = f_split[:2]
		subject_name = "_".join(subject_split)
		print("subj_name",subject_name)
		if dict.get(subject_name) == 1:
			new_dir = "Autism/" + f
			shutil.move(f, new_dir)
		elif dict.get(subject_name) == 2:
			new_dir = "Control/" + f
			shutil.move(f, new_dir)
		else:
			# Some of the subjects cannot be found in the phenotype file, so their designation as control/autism is unclear.
			new_dir = "Unsorted/" + f
			shutil.move(f, new_dir)