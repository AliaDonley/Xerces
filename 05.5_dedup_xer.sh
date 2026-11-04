#!/bin/sh
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=14
#SBATCH --mem=96G
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=dedup_xer
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=alia.donley@usu.edu


module load samtools
## version 1.16

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/xerces/bwamem2

perl /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/dedup_xer.pl ERR*_ERR*.bam
