#!/bin/sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=get_reference
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


module load bwa
module load samtools

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome

wget -nc https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/905/404/095/GCA_905404095.1_ilGlaAlex1.1/GCA_905404095.1_ilGlaAlex1.1_genomic.fna.gz
gunzip -k GCA_905404095.1_ilGlaAlex1.1_genomic.fna.gz

bwa index GCA_905404095.1_ilGlaAlex1.1_genomic.fna
samtools faidx GCA_905404095.1_ilGlaAlex1.1_genomic.fna
