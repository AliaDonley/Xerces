#!/usr/bin/perl
use Parallel::ForkManager;
my $max = 15;
my $pm = Parallel::ForkManager->new($max);
my $genome = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";

FILES:
foreach $ind (@ARGV){
    $pm->start and next FILES;
    my $fq1 = "trimmed/${ind}_1.trim.fastq.gz";
    my $fq2 = "trimmed/${ind}_2.trim.fastq.gz";
    system "bwa mem -t 1 -R \'\@RG\\tID:Lyg-$ind\\tLB:Lyg-$ind\\tSM:Lyg-$ind\' $genome $fq1 $fq2 | samtools sort -@ 2 -O BAM -o bam/${ind}.sorted.bam - && samtools index bam/${ind}.sorted.bam\n";
    $pm->finish;
}
$pm->wait_all_children;
