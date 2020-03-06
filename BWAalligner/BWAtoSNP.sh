mkdir trimmed
echo "\e[36m Trimming Started \e[0m"
for i in *.fastq;
do
  sam=$(echo "$i" | rev |cut -d"." -f2- | rev )
	echo "$sam"
	java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 "$sam".fastq trimmed/"$sam".fastq TRAILING:20 MINLEN:50
done #cut sequences with trimmomatic
echo "\e[36m Trimming Done \e[0m "
mkdir samfiles
mkdir bamfiles
echo "\e[36m Human GRCh38 mapping \e[0m "
cd trimmed/
#Check if FASTQ contains more than 100k reads to analyse
for i in *.fastq;
do
	sam=$(echo "$i" | rev |cut -d"." -f2- | rev )
   	echo "$sam"
	count=$(echo $(cat $sam.fastq|wc -l)/4|bc)
	echo "$count"
	if [ "100000" -gt $count ];then 
		rm "$sam.fastq"
		echo "removed $sam"
	fi
done #cut sequences with trimmomatic 

for x in *.fastq #Map human genome for SNPs
do	
	sam=$(echo "$x" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Mapping $sam to GRCh \e[0m"
	bwa mem -t 16 /home/fagi/grch38BWA/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna $sam.fastq > ../samfiles/$sam.sam
done
cd ../samfiles

#Fixing FLAG
#for z in *.bam
#do
#	sam=$(echo "$z" | rev |cut -d"." -f2- | rev )
#	echo "$sam"	
#	samtools fixmate -O bam "$sam".bam fixed"$sam".bam
#done
#Sam to bam
echo "\e[36m SAM -> BAM \e[0m"
for y in *.sam
do
	sam=$(echo "$y" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Translating $sam to BAM \e[0m"
	samtools view -S -b $sam.sam > ../bamfiles/$sam.bam # Translate SAM --> BAM
done
#Sorting 

cd ../bamfiles

echo "\e[36m Sorting \e[0m"
for u in *.bam
do
	sam=$(echo "$u" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Sorting $sam \e[0m"	
	#samtools view -hbS - | samtools sort -m 1000000000 - $sam.bam
	samtools sort -O bam -o sorted"$sam".bam $u
done

#Marking duplicates and removing them
echo "\e[36m Mark Duplicates \e[0m"
for u in sorted*.bam
do
	sam=$(echo "$u" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Checking for duplicates in $sam \e[0m"	
	java -jar /home/fagi/picard/picard/build/libs/picard.jar MarkDuplicates I=$u O=Duplicate$sam.bam M=Duplicates$sam_metrics.txt REMOVE_DUPLICATES=true
done
# samtools faidx / 
#java -jar /home/fagi/picard.jar CreateSequenceDictionary R=GCA_000001405.15_GRCh38_no_alt_analysis_set.fna O=reference.dict

#Indel Realignment ------- nie trzeba w nowszych wersjach oprogramowania
#echo "\e[36m INDEL Realignment \e[0m"

mkdir ../VCFfiles

# Basecalling na vcf bam ->> VC
echo "\e[36m Basecall BCF -> VCF \e[0m"
for z in Duplicatesorted*.bam
do
	sam=$(echo "$z" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Basecalling $sam \e[0m"	
	/home/fagi/miniconda3/bin/bcftools mpileup -Ou -f /home/fagi/GRCh38SNP/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna $z | /home/fagi/miniconda3/bin/bcftools call -vmO z -o $sam.bcf #Variant calling z bcftools
	
	echo "\e[32m Filtering $sam and translating to VCF \e[0m"	
	/home/fagi/miniconda3/bin/bcftools filter -i 'QUAL>100' $sam.bcf > ../VCFfiles/$sam.vcf #PHRED score filtering 
done
cd ../VCFfiles
for z in *.vcf
do
	sam=$(echo "$z" | rev |cut -d"." -f2- | rev )
	echo "\e[32m Annotating SNPs with snpEff $sam \e[0m"
	java -Xmx4g -jar /home/fagi/snpEff/snpEff.jar -c /home/fagi/snpEff/snpEff.config -v GRCh38.86 $z > Annotated$sam.vcf
done

#Visualize
#bcftools stats -F /home/fagi/grch38BWA/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna -s 

#for z in *.sam
#do
#	z1=$(echo "$z" | cut -f 1 -d '.')
#	samtools view -S -b $z > $z1.bam
#done