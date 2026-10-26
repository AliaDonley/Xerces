#!/usr/bin/perl
#
# alignment with bwa mem 
#


use Parallel::ForkManager;
my $max = 6;
my $pm = Parallel::ForkManager->new($max);
my $genome = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome/alexis_bwamem2/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        $fq2 = $fq1;
        $fq2 =~ s/_1\.fq\.gz/_2.fq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/clean\/([A-Za-z0-9]+)/ or die "failed to match id $fq1\n";
        $ind = $1;
        $fq1 =~ m/([A-Za-z_\-0-9]+)_1\.fq\.gz$/ or die "failed match for file $fq1\n";
        $file = $1;
        system "/uufs/chpc.utah.edu/common/home/u6000989/source/bwa-mem2-2.0pre2_x64-linux/bwa-mem2 mem -t 1 -k 19 -r 1.5 -R \'\@RG\\tID:Xer-"."$ind\\tLB:Xer-"."$ind\\tSM:Xer-"."$ind"."\' $genome $fq1 $fq2 | samtools sort -@ 2 -O BAM -o $ind"."_$file.bam - && samtools index -@ 2 $ind"."_$file.bam\n";

        $pm->finish;
}

$pm->wait_all_children;
