#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem=80G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --exclude=kp293
#SBATCH --job-name=align_xer_bwaaln
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_xer_bwaaln_%j.out

module load bwa
module load samtools
##Version: 1.16 (using htslib 1.16)

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
mkdir -p xerces/aln_tmp

perl BwaAlnForkXer.pl xerces/soapnuke/clean/*/*_1.fq.gz
