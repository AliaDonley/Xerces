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
