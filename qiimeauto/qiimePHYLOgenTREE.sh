echo "alignment started"

qiime alignment mafft --i-sequences rep-seqs-dn-MikrobiomyOTU.qza --o-alignment aligned-rep-seqs-dn-MikrobiomyOTU.qza

qiime alignment mask --i-alignment aligned-rep-seqs-dn-MikrobiomyOTU.qza --o-masked-alignment masked-aligned-dn-MikrobiomyOTU.qza

qiime phylogeny fasttree --i-alignment masked-aligned-dn-MikrobiomyOTU.qza --o-tree unrooted-tree-MikrobiomyOTU.qza

qiime phylogeny midpoint-root --i-tree unrooted-tree-MikrobiomyOTU.qza --o-rooted-tree rooted-tree-MikrobiomyOTU.qza

echo "Creating nice images"

qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree-MikrobiomyOTU.qza --i-table table-dn-MikrobiomyOTU-qza.qza --p-sampling-depth 1603 --m-metadata-file manifest.tsv --output-dir core-metrics-results


