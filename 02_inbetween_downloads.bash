At this point I've downloaded the G. alexis genome into /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
Got the ENA read list using:

cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
awk -F'\t' '$2=="Glaucopsyche lygdamus" && $3!=""' ena_report.tsv > lygdamus_runs.tsv
awk -F'\t' '$2=="Glaucopsyche lygdamus xerces" && $3!=""' ena_report.tsv > xerces_runs.tsv
wc -l lygdamus_runs.tsv xerces_runs.tsv

# should have 16 xerces and 23 lygdamus 

Build the URL lists using:

cut -f3 lygdamus_runs.tsv | tr ';' '\n' | sed 's|^|ftp://|' > lygdamus_fastq_urls.txt
cut -f3 xerces_runs.tsv   | tr ';' '\n' | sed 's|^|ftp://|' > xerces_fastq_urls.txt
wc -l lygdamus_fastq_urls.txt xerces_fastq_urls.txt

# counts should be doubled here 

Make a raw output here to keep organized 
cd /uufs/chpc.utah.edu/common/home/u6047808/Xerces/ADXerces
mkdir -p lygdamus/raw lygdamus/trimmed lygdamus/bam xerces/raw xerces/trimmed xerces/bam logs


I ran 03_download*.sh not in the correct directories, will have to move when they wrap up. 

To check them:

squeue -u u6047808          # confirm both have completed (not just queued)
cat logs/dl_lygdamus_*.out  # tail for errors — should just be normal wget progress, no "ERROR" lines
cat logs/dl_xerces_*.out

ls *_1.fastq.gz | wc -l     # expect 23 (lygdamus) + 16 (xerces) = 39 R1 files
ls *_2.fastq.gz | wc -l     # expect 39 R2 files too
