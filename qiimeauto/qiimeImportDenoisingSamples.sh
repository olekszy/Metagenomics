conda activate qiime2-2019.7

#importing to Qiime and denoising with 290 leng, unlimited threads. Visualizing.
mkdir ../qiimeSRA
#Import danych -------------------------------------
readlink -f */*fastq > pwds.txt 
ls */*.fastq > files.txt
readlink -f *fasta > pwdsF.txt
ls */*.fasta */* > filesF.txt

python3 manifestcreate.py

echo "Starting importing FastQ to QIIME2"

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path manifest.tsv --output-path ../qiimeSRA/single-end-Mikrobiomy.qza --input-format PairedEndFastqManifestPhred33V2

echo "Starting importing FASTA to QIIME2"
qiime tools import --type 'FeatureData[Sequence]' --input-path manifestF.tsv --output-path ../qiimeSRA/FASTA-SRA.qza --input-format PairedEndFastaManifestPhred33
echo "Starting denoising in DADA2"

qiime dada2 denoise-single --p-trim-left 0  --p-trunc-len 290 --p-n-threads 0 --i-demultiplexed-seqs  single-end-Mikrobiomy.qza --o-representative-sequences rep-seqs-Mikrobiomy.qza --o-table microbiome-table-Mikrobiomy.qza --o-denoising-stats microbiome-stats-Mikrobiomy.qza

rm -r pwds*.txt
rm -r files*.txt
