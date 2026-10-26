
#!/usr/bin/perl
#
# bwa-mem2 alignment of SOAPnuke-cleaned pairs to G. alexis
# usage: perl BwaMem2ForkNuke.pl <clean R1 files>
#   paths must look like <species>/soapnuke/clean/<id>/<id>_1.fq.gz
#

use Parallel::ForkManager;
my $max = 20;
my $pm = Parallel::ForkManager->new($max);
##fix me my $genome = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/ReferenceGenome/alexis_bwamem2/GCA_905404095.1_ilGlaAlex1.1_genomic.fna";
my $base = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces";

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        ($fq2 = $fq1) =~ s/_1\.fq\.gz$/_2.fq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/(lygdamus|xerces)\/soapnuke\/clean\/([^\/]+)\/\2_1\.fq\.gz$/ or die "failed to match $fq1\n";
        $species = $1;
        $ind = $2;
        $tag = ($species eq "lygdamus") ? "Lyg" : "Xer";
        $out = "$base/$species/bam/$ind.alexis_bwamem2_soapnuke.sorted.bam";
        system "$bwa2 mem -t 2 -k 19 -r 1.5 -R \'\@RG\\tID:$tag-"."$ind\\tLB:$tag-"."$ind\\tSM:$tag-"."$ind"."\' $genome $fq1 $fq2 | samtools sort -@ 2 -m 1G -O BAM -o $out - && samtools index -@ 2 $out\n";

        $pm->finish;
}

$pm->wait_all_children;
