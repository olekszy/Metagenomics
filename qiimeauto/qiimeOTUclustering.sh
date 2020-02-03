echo "OTU clustering started" #de novo Clustering closeed- Greengenes Open - other db

qiime vsearch cluster-features-de-novo --i-table microbiome-table-Mikrobiomy.qza --i-sequences rep-seqs-Mikrobiomy.qza --p-perc-identity 0.99 --o-clustered-table table-dn-MikrobiomyOTU-qza --o-clustered-sequences rep-seqs-dn-MikrobiomyOTU.qza

echo "Creating Featuretable Visualization"

qiime feature-table summarize --i-table table-dn-MikrobiomyOTU-qza.qza --o-visualization table-dn-MikrobiomyOTU.qzv

qiime feature-table tabulate-seqs --i-data rep-seqs-dn-MikrobiomyOTU.qza --o-visualization rep-seqs.qzv

echo "inspect .qzv Files and consider sampling-deph parameter"

