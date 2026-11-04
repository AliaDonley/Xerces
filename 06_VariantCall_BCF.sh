#!/bin/sh
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=bcf_call
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


module load samtools
## version 1.16
module load bcftools
## version 1.16

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/xerces/vcf
perl /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/BcfForkXer.pl chrom*list
