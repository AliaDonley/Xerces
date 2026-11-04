#!/usr/bin/perl
#
# samtools/bcftools variant calling by chromosome, xerces (ENA) on G. alexis
#

use Parallel::ForkManager;
my $max = 24;
my $pm = Parallel::ForkManager->new($max);
my $genome = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";

FILES:
foreach $chrom (@ARGV){
        $pm->start and next; ## fork
        $chrom =~ /chrom([0-9]+)\.list/ or die "failed here: $chrom\n";
        $out = "xer_alexis_chrom$1";
        system "bcftools mpileup -b bams_xerces_alexis -d 1000 -f $genome -R $chrom -a FORMAT/DP,FORMAT/AD -q 20 -Q 30 -I -Ou | bcftools call -v -c -p 0.01 -Ov -o $out.vcf 2> $out.log\n";
        $pm->finish;
}

$pm->wait_all_children;
