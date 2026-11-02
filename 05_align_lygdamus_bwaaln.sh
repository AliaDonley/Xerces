#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=25
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --job-name=bwaaln_lyg
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu

module load bwa
module load samtools
##Version: 1.16 (using htslib 1.16)

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
mkdir -p lygdamus/aln_tmp

perl BwaAlnForkLyg.pl lygdamus/soapnuke/clean/*/*_1.fq.gz
