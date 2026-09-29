#!/bin/sh
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=trim_lygdamus
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


module load fastp/1.3.7

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/lygdamus
perl lygFork.pl $(cat ../lygdamus_accessions.txt)
