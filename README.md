Xerces samples 1-8 (4 xerces phenotypes, 4 antiacis phenotypes) extracted with NEB kit, lib prepped with IDT 16rxn ssnda kit. 

/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces

# RAW DATA
G. alexis genome downloaded from NCBI using 01_download_reference.sh
```sh
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
```
Lygdamus and Xerces data obtained using 03_download_lygdamus.sh and 03_download_xerces.sh. Lyg will be shown below. All prep steps for this download are detailed in the file above labelled 02_inbetween_steps.bash
```sh
#!/bin/sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=dl_lygdamus
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu


cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
wget -nc -i lygdamus_fastq_urls.txt
```

# Alignment 
## Aligning to G. alexis genome corrected with G. lygdamus. Trying to get just a complete lyg genome 


