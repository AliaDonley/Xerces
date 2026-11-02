#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=14
#SBATCH --mem=320G
#SBATCH --account=gompert-kp
#SBATCH --partition=gompert-kp
#SBATCH --job-name=bwamem-xerces
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


ml samtools

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
perl BwaMemForkXer.pl xerces/soapnuke/clean/*/*_1.fq.gz
