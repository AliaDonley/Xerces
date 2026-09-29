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
