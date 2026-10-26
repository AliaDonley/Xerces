#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=2G
#SBATCH --mem=16G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --exclude=kp293
#SBATCH --job-name=align_own
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_own_%x_%A_%a.out

module load bwa
module load samtools


