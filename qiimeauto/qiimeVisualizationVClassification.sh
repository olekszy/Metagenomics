#qiime feature-classifier classify-sklearn --i-classifier trained-silva.qza --i-reads rep-seqs-dn-MikrobiomyOTU.qza --o-classification taxonomyMikrobiomy.qza

echo "Processing Taxonomy"

qiime metadata tabulate --m-input-file ClassifiedMikrobiomy.qza --o-visualization taxonomy.qzv
