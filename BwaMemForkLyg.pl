#!/usr/bin/perl
#
#
use Parallel::ForkManager;
my $max = 7;
my $pm = Parallel::ForkManager->new($max);
my $base = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces";
my $genome = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome/alexis_bwamem2/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";
my $bwa2 = "/uufs/chpc.utah.edu/common/home/u6000989/source/bwa-mem2-2.0pre2_x64-linux/bwa-mem2";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        $fq2 = $fq1;
        $fq2 =~ s/_1\.fq\.gz$/_2.fq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/clean\/([^\/]+)\/\1_1\.fq\.gz$/ or die "failed to match id $fq1\n";
        $ind = $1;
        $out = "$base/lygdamus/bwamem2/$ind.alexis_bwamem2_soapnuke.sorted.bam";
        system "$bwa2 mem -t 2 -k 19 -r 1.5 -R \'\@RG\\tID:LygMem2-"."$ind\\tLB:LygMem2-"."$ind\\tSM:LygMem2-"."$ind"."\' $genome $fq1 $fq2 | samtools sort -@ 2 -m 1G -O BAM -o $out - && samtools index -@ 2 $out\n";
        $pm->finish;
}

$pm->wait_all_children;
