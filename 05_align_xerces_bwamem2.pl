

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


ml samtools

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
perl BwaMem2ForkLyg.pl xerces/soapnuke/clean/*/*_1.fq.gz
