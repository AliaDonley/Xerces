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
