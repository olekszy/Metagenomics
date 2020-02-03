mkdir trimmed
echo -e "\e[34m Trimming Started \e[0m"
for i in *R1*.fastq;
do
	sam=$(echo "$i" | sed "s/_R1_\001\.fastq//")
	echo "$sam"	
	java -Xms4g -Xmx4g -jar /home/fagi/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 64 -phred33 $sam*R1* $sam*R2*.fastq trimmed/"$sam"_R1.fastq /dev/null trimmed/"$sam"_R2.fastq /dev/null TRAILING:20 MINLEN:50
done #cut sequences with trimmomatic
echo -e "\e[34m Trimming Done \e[0m"
mkdir reportskraken #create folder for Kraken result
mkdir outputs # create folder for Kraken outputs
cd trimmed/
echo -e "\e[34m Kraken2 Started \e[0m"
for a in *R1*.fastq
do	 
	sam=$(echo "$a" | sed "s/_L\001\_R1.fastq//")
        echo "$sam"
        #echo "$sam"*_R1.fastq
       	#echo "$sam"*_R2.fastq	
	/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/minikraken2_v1_8GB  --paired $sam*R1*.fastq $sam*R2*.fastq  --report ../reportskraken/"sam"_report --output ../outputs/"$sam"_krona
done 

echo -e "\e[34m Kraken2 Analysis Done \e[0m"

cd .. 

mkdir Kronacharts

cd outputs/

echo -e "\e[34m Krona Started \e[0m"
for b in *krona
do
	        ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html # create Krona chart

done

echo -e "\e[34m Krona Done \e[0m"
