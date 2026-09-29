#!/bin/sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=trim_xerces
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu

source ~/miniforge3/bin/activate adna_trim

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/xerces
perl xerFork.pl $(cat ../xerces_accessions.txt)
