#!/usr/bin/env bash
#SBATCH --ntasks=1
#SBATCH --job-name=arrayJob
#SBATCH --partition=qdata
#SBATCH --cpus-per-task=1
Rscript main.R "${SLURM_ARRAY_TASK_ID}"