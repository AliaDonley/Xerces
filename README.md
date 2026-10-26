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

Then trimmed with 04_trim_lyg.sh and 04_trim_xerces.sh (both are up above)
04_trim_xerces.sh
```sh
#!/bin/sh
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBATCH --account=gompert-np
#SBATCH --partition=gompert-np
#SBATCH --job-name=trim_xerces
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu

source ~/miniforge3/bin/activate adna_trim

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/xerces
perl xerFork.pl $(cat ../xerces_accessions.txt)
```
which ran

xerFork.pl
```pl
#!/usr/bin/perl
use Parallel::ForkManager;
my $max = 15;
my $pm = Parallel::ForkManager->new($max);

FILES:
foreach $ind (@ARGV){
    $pm->start and next FILES;
    my $fq1 = "raw/${ind}_1.fastq.gz";
    my $fq2 = "raw/${ind}_2.fastq.gz";
    system "adapterremoval --in-file1 $fq1 --in-file2 $fq2 --out-prefix trimmed/$ind --merge --min-length 25 --threads 1\n";
    $pm->finish;
}
$pm->wait_all_children;
```
and
lygFork.pl
```pl
#!/usr/bin/perl
use Parallel::ForkManager;
my $max = 15;
my $pm = Parallel::ForkManager->new($max);

FILES:
foreach $ind (@ARGV){
    $pm->start and next FILES;
    my $fq1 = "raw/${ind}_1.fastq.gz";
    my $fq2 = "raw/${ind}_2.fastq.gz";
    system "fastp -i $fq1 -I $fq2 -o trimmed/${ind}_1.trim.fastq.gz -O trimmed/${ind}_2.trim.fastq.gz -j trimmed/${ind}.json -h trimmed/${ind}.html\n";
    $pm->finish;
}
$pm->wait_all_children;
```



Retried cleaning with Soapnuke like last time. Submitted Soapnuke.sh (has all lyg, xer, and my own):
```
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

```
which ran nukeForkXer.pl:
```sh
#!/usr/bin/perl
#
#soapnuke alignment 
#doing before alignment with bwamem2


use Parallel::ForkManager;
my $max = 15;
my $pm = Parallel::ForkManager->new($max);
my $outroot = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/xerces/soapnuke/clean";
my $minlen = 30;

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        ($fq2 = $fq1) =~ s/_1\.fastq\.gz$/_2.fastq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/^(.*\/)?(xerces)\/raw\/([^\/]+)_1\.fastq\.gz$/ or die "failed to match $fq1\n";
        $id = $1;
        $outdir = "$outroot/$id";
        system "mkdir -p $outdir\n";
        system "~/SOAPnuke/SOAPnuke filter -n 0.05 -l 20 -q 0.3 --ada_trim --polyX 50 --minReadLen $minlen -1 $fq1 -2 $fq2 -C ${id}_1.fq.gz -D ${id}_2.fq.gz -o $outdir\n";
        $pm->finish;
}
$pm->wait_all_children;
```
Also have nukeForkLyg.pl and nukeForkOwn.pl

## Alignment of my own samples will depend on which alignment worked better. I'm running bwamem2 and bwa aln. bwamem2 uses softclipping and I want to be sure the alignment rates are not vastly different. 

# Alignment with bwa aln
## Aligning lygdamus to alexis genome to make a corrected reference. Contains contemporary samples and ..2? museum samples
Ran 05_align_lygdamus_bwaaln.sh
```sh
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
mkdir -p lygdamus/bwaaln

perl BwaAlnFork.pl lygdamus/soapnuke/clean/*/*_1.fq.gz
```
Which runs BwaAlnForkLyg.pl
```
#!/usr/bin/perl
#
# alignment with bwa aln + sampe (SOAPnuke-cleaned pairs)
#

use Parallel::ForkManager;
my $max = 8;
my $pm = Parallel::ForkManager->new($max);
my $base = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces";
## fix me my $genome = "$base/ReferenceGenome/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";
my $tmp = "$base/lygdamus/aln_tmp";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        $fq2 = $fq1;
        $fq2 =~ s/_1\.fq\.gz/_2.fq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/clean\/([A-Za-z0-9]+)/ or die "failed to match id $fq1\n";
        $ind = $1;
        $out = "$base/lygdamus/bam/$ind.alexis_bwaaln_soapnuke.sorted.bam";
        system "bwa aln -t 2 $genome $fq1 > $tmp/$ind.1.sai && bwa aln -t 2 $genome $fq2 > $tmp/$ind.2.sai && bwa sampe -r \'\@RG\\tID:LygAln-"."$ind\\tLB:LygAln-"."$ind\\tSM:LygAln-"."$ind"."\' $genome $tmp/$ind.1.sai $tmp/$ind.2.sai $fq1 $fq2 | samtools sort -@ 2 -m 1G -O BAM -o $out - && samtools index -@ 2 $out && rm -f $tmp/$ind.1.sai $tmp/$ind.2.sai\n";

        $pm->finish;
}

$pm->wait_all_children;
```

## Aligning xerces to alexis genome to make a corrected reference
Ran 05_align_xerces_bwaaln.sh
```#!/bin/bash
#SBATCH --time=240:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem=80G
#SBATCH --account=usubio-kp
#SBATCH --partition=usubio-kp
#SBATCH --exclude=kp293
#SBATCH --job-name=align_xer_bwaaln
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=alia.donley@usu.edu
#SBATCH -o /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/logs/align_xer_bwaaln_%j.out

module load bwa
module load samtools
##Version: 1.16 (using htslib 1.16)

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
mkdir -p xerces/bwaaln

perl BwaAlnForkXer.pl xerces/soapnuke/clean/*/*_1.fq.gz
```
Which Ran BwaAlnForkXer.pl
```
#!/usr/bin/perl
#
# alignment with bwa aln + sampe (SOAPnuke-cleaned xerces pairs, aDNA settings)
#Alignment of musuem xerces on ncbi

use Parallel::ForkManager;
my $max = 7;
my $pm = Parallel::ForkManager->new($max);
my $base = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces";
my $genome = "$base/ReferenceGenome/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";
my $tmp = "$base/xerces/aln_tmp";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        $fq2 = $fq1;
        $fq2 =~ s/_1\.fq\.gz/_2.fq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/clean\/([A-Za-z0-9]+)/ or die "failed to match id $fq1\n";
        $ind = $1;
        $out = "$base/xerces/bam/$ind.alexis_bwaaln_soapnuke.sorted.bam";
        system "bwa aln -l 1024 -n 0.01 -o 2 -t 2 $genome $fq1 > $tmp/$ind.1.sai && bwa aln -l 1024 -n 0.01 -o 2 -t 2 $genome $fq2 > $tmp/$ind.2.sai && bwa sampe -r \'\@RG\\tID:XerAln-"."$ind\\tLB:XerAln-"."$ind\\tSM:XerAln-"."$ind"."\' $genome $tmp/$ind.1.sai $tmp/$ind.2.sai $fq1 $fq2 | samtools sort -@ 2 -m 1G -O BAM -o $out - && samtools index -@ 2 $out && rm -f $tmp/$ind.1.sai $tmp/$ind.2.sai\n";

        $pm->finish;
}

$pm->wait_all_children;
```
# Using bwa-mem2 
## aligning lygdamus to alexis
Ran 05_align_lygdamus_bwamem2.sh
```























