#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --exclude=kp293
#SBATCH --job-name=align_lyg
#SBATCH --array=1-11
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_lyg_%A_%a.out

module load bwa
module load samtools

BASE=/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
GENOME=$BASE/ReferenceGenome/GCA_905404095.1_ilGlaAlex1.1_genomic.fna
IND=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $BASE/lygdamus_todo.txt)

cd $BASE/lygdamus
bwa mem -t 6 -R "@RG\tID:Lyg-$IND\tLB:Lyg-$IND\tSM:Lyg-$IND" $GENOME \
  trimmed/${IND}_1.trim.fastq.gz trimmed/${IND}_2.trim.fastq.gz \
  | samtools sort -@ 2 -m 1G -O BAM -o bam/${IND}.sorted.bam - \
  && samtools index bam/${IND}.sorted.bam
