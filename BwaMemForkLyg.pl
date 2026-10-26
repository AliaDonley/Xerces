#!/usr/bin/perl
#
#
use Parallel::ForkManager;
my $pm = Parallel::ForkManager->new($max);
my $max = 20
my $base = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces";
my $bwa2 = "/uufs/chpc.utah.edu/common/home/u6000989/source/bwa-mem2-2.0pre2_x64-linux/bwa-mem2";
##Fix me my $genome = "$base/ReferenceGenome/alexis_bwamem2/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        $fq2 = $fq1;
        $fq2 =~ s/_1\.fq/_2.fq/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/([^\/]+)_S\d+_L\d+_1\.fq/;$/ or die "failed to match id $fq1\n";
        $ind = $1;
        $out = "$base/lygdamus/bam/$ind.alexis_bwamem2_soapnuke.sorted.bam";
        system "$bwa2 mem -t 2 -k 19 -r 1.5 -R \'\@RG\\tID:LygMem2-"."$ind\\tLB:LygMem2-"."$ind\\tSM:LygMem2-"."$ind"."\' $genome $fq1 $fq2 | samtools sort -@ 2 -m 1G -O BAM -o $out - && samtools index -@ 2 $out\n";
        $pm->finish;
}

$pm->wait_all_children;

