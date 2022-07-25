mkdir trimmed
echo -e "\e[34m Trimming Started \e[0m"
for i in *R1*.fastq;
do
	sam=$(echo "$i" | sed "s/_R1_\001\.fastq//" | sed "s/R1.fastq//")
	echo "$sam"	
	java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 64 -phred33 $sam*R1* $sam*R2*.fastq trimmed/"$sam"_R1.fastq /dev/null trimmed/"$sam"_R2.fastq /dev/null TRAILING:20 MINLEN:50
done #cut sequences with trimmomatic
echo -e "\e[34m Trimming Done \e[0m"
mkdir reportskraken #create folder for Kraken result
mkdir outputs # create folder for Kraken outputs
mkdir cleanseq
mkdir unclassified
cd trimmed/
echo -e "\e[34m Discarding human sequences  \e[0m"

for i in *R1*.fastq; #Map human genome for SNPs
do
		sam=$(echo "$i" | sed "s/_R1.fastq//")
		echo "$sam"*R1*
		echo "$sam"*R2*
        /home/fagi/miniconda3/bin/bowtie2 --threads 16 --very-sensitive-local -x /home/fagi/bowtie2grch38/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index -1 "$sam"*R1* -2 "$sam"*R2* --un-conc ../cleanseq/clean"$sam"R%.fastq -S /dev/null
done
cd ../cleanseq
echo -e "\e[34m Kraken2  \e[0m"
for a in *R1.fastq
do	 
	sam=$(echo "$a" | sed "s/R1.fastq//")
    echo "$sam"
        #echo "$sam"*_R1.fastq
       	#echo "$sam"*_R2.fastq	
	/home/fagi/kraken2/kraken2 --threads 32 --db /home/fagi/kraken_microbial  --paired $sam*R1.fastq $sam*R2.fastq  --report ../reportskraken/"$sam"_report --use-mpa-style --output ../outputs/"$sam"_krona --unclassified-out ../unclassified/unclassified"$sam"#.fastq
done 

echo -e "\e[34m Kraken2 Analysis Done \e[0m"

cd .. 

mkdir Kronacharts

cd outputs/

echo -e "\e[34m Krona Started \e[0m"
for b in *krona
do
	        /home/fagi/krona/bin/ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html # create Krona chart

done

echo -e "\e[34m Krona Done \e[0m"
