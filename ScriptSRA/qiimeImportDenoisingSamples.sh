#importing to Qiime and denoising with 290 leng, unlimited threads. Visualizing.

readlink -f *fastq > pwds.txt
ls */*.fastq > files.txt
readlink -f *fastq >pwdsF.txt
ls */*.fasta > pwdsF.txt

python3 script.py
echo "Starting importing to QIIME2"

qiime tools import --type 'SampleData[SequencesWithQuality]' --input-path manifest.tsv --output-path single-end-Mikrobiomy.qza --input-format SingleEndFastqManifestPhred33V2

echo "Starting denoising in DADA2"

qiime dada2 denoise-single --p-trim-left 0  --p-trunc-len 290 --p-n-threads 0 --i-demultiplexed-seqs  single-end-Mikrobiomy.qza --o-representative-sequences rep-seqs-Mikrobiomy.qza --o-table microbiome-table-Mikrobiomy.qza --o-denoising-stats microbiome-stats-Mikrobiomy.qza

