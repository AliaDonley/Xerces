#!/bin/sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=dl_lygdamus
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
wget -nc -i lygdamus_fastq_urls.txt
