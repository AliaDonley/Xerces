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

Need to now trim off all the extra junk from xerces and lygdamus files. First going to recreate the accession .txt files, install a package, and then run a forked .pl script

Already have adna trim and adapterremoval installed, using this to activate it

conda activate adna_trim
conda install -c bioconda -c conda-forge perl-parallel-forkmanager -y
perl -MParallel::ForkManager -e 'print "OK\n"'
conda deactivate 


# Making the accession .txt files
wget -O ena_report.tsv "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJEB47122&result=read_run&fields=run_accession,scientific_name,fastq_ftp&format=tsv"
awk -F'\t' '$2=="Glaucopsyche lygdamus" && $3!=""' ena_report.tsv > lygdamus_runs.tsv
awk -F'\t' '$2=="Glaucopsyche lygdamus xerces" && $3!=""' ena_report.tsv > xerces_runs.tsv
cut -f1 lygdamus_runs.tsv > lygdamus_accessions.txt
cut -f1 xerces_runs.tsv   > xerces_accessions.txt
cut -f3 lygdamus_runs.tsv | tr ';' '\n' | sed 's|^|ftp://|' > lygdamus_fastq_urls.txt
cut -f3 xerces_runs.tsv   | tr ';' '\n' | sed 's|^|ftp://|' > xerces_fastq_urls.txt

Also cut one lygdamus out, this is the corrected file:
grep -v "ERR13648410" lygdamus_accessions.txt > lygdamus_accessions_tmp.txt
mv lygdamus_accessions_tmp.txt lygdamus_accessions.txt

Lyg should have 22 and xerces should have 16

Then trimmed with 04_trim_lyg and xer.sh which ran xerFork.pl and LygFork.pl



# Alignment 
## Aligning to G. alexis genome corrected with G. lygdamus. Trying to get just a complete lyg genome 


