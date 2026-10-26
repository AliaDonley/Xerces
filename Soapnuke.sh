
#!/bin/sh
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=30
#SBATCH --account=gompert-kp
#SBATCH --partition=gompert-kp
#SBATCH --job-name=soapnuke
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


ml gcc

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces

perl nukeForkLyg.pl lygdamus/raw/*_1.fastq.gz
#perl nukeForkXer.pl xerces/raw/*_1.fastq.gz


#perl nukeForkOwn.pl /uufs/chpc.utah.edu/common/home/u6047808/Xerces/genome/[1-8]_S*_R1_001.fastq.gz



##Runs all nukeFork*.pl
