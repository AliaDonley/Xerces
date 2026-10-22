#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --exclude=kp293
#SBATCH --job-name=align_own
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_own_%x_%A_%a.out

module load bwa
module load samtools

BASE=/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
IND=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $BASE/own_samples.txt)

# REF and TAG come from sbatch --export
echo "Reference: $REF  Tag: $TAG  Sample: $IND"

cd $BASE/own
bwa aln -l 1024 -n 0.01 -o 2 -t 8 $REF trimmed/${IND}.merged.fastq.gz > bam/${IND}.${TAG}.sai \
  && bwa samse -r "@RG\tID:Own-$IND\tLB:Own-$IND\tSM:Own-$IND" $REF bam/${IND}.${TAG}.sai trimmed/${IND}.merged.fastq.gz \
  | samtools sort -@ 2 -m 1G -O BAM -o bam/${IND}.${TAG}.sorted.bam - \
  && samtools index bam/${IND}.${TAG}.sorted.bam
