qiime tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path /home/fagi/Pulpit/SILVA_132_QIIME_release/taxonomy/16S_only/99/taxonomy_all_levels.txt --output-path ref-taxonomy-Mikrobiomy.qza

qiime tools import --type 'FeatureData[Sequence]' --input-path /home/fagi/Pulpit/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna --output-path silva_132_ref.qza
