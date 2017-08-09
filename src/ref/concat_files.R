# Combine data from all files in directory into one data matrix
# Run within the Autism and Control folders separately to generate input matrices
filenames <- list.files()
nSubjects <- length(filenames)
data <- list()

for (i in 1:nSubjects){
  subj = read.delim(filenames[[i]], header = TRUE, sep = "\t")
  data[[i]] <- subj
}