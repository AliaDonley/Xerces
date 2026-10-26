#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=30
#SBATCH --cpus-per-task=8
#SBATCH --mem=80G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --job-name=align_lyg_bwaaln
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_lyg_bwaaln%A_%a.out

module load bwa
module load samtools
##Version: 1.16 (using htslib 1.16)

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
mkdir -p lygdamus/aln_tmp

perl BwaAlnFork.pl lygdamus/soapnuke/clean/*/*_1.fq.gz
