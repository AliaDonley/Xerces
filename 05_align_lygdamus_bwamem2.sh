#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=340G
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=bwamem_lyg
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
ml samtools
cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
perl BwaMem2ForkLyg.pl lygdamus/soapnuke/clean/*/*_1.fq.gz
