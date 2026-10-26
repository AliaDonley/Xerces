#!/usr/bin/perl
#
#soapnuke alignment 
#doing before alignment with bwamem2


use Parallel::ForkManager;
my $max = 15;
my $pm = Parallel::ForkManager->new($max);
my $outroot = "/uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces/lygdamus/soapnuke/clean";
my $minlen = 30;

FILES:
foreach $fq1 (@ARGV){
        $pm->start and next FILES; ## fork
        ($fq2 = $fq1) =~ s/_1\.fastq\.gz$/_2.fastq.gz/ or die "failed substitution for $fq1\n";
        $fq1 =~ m/^(.*\/)?(lygdamus)\/raw\/([^\/]+)_1\.fastq\.gz$/ or die "failed to match $fq1\n";
        $id = $1;
        $outdir = "$outroot/$id";
        system "mkdir -p $outdir\n";
        system "~/SOAPnuke/SOAPnuke filter -n 0.05 -l 20 -q 0.3 --ada_trim --polyX 50 --minReadLen $minlen -1 $fq1 -2 $fq2 -C ${id}_1.fq.gz -D ${id}_2.fq.gz -o $outdir\n";
        $pm->finish;
}
$pm->wait_all_children;
