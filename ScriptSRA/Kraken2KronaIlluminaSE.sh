for=$(ls *.fas* | sed '1q;d')
#rev=$(ls *.fas*| sed '2q;d')
mkdir trimmed
echo $for #$rev
	java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 $for trimmed/"$for"_R1.fastq TRAILING:20 MINLEN:50

mkdir reportskraken
mkdir outputs
cd trimmed/

for=$(ls | sed '1q;d')
#rev=$(ls | sed '2q;d')

	/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/minikraken2_v1_8GB  $for --report ../reportskraken/"$for"_report --output ../outputs/"$for"_krona

cd .. 

#mkdir Kronacharts

#cd outputs/

#for b in *krona
#do
#	        ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html

#done
