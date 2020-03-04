mkdir trimmed
echo -e "\e[34m Trimming Started \e[0m"

for i in *.fastq;
do
    sam=$(echo "$i" | rev |cut -d"." -f2- | rev )
	echo "$sam"
	java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 "$sam".fastq trimmed/"$sam".fastq TRAILING:20 MINLEN:50
done #cut sequences with trimmomatic
echo -e "\e[34m Trimming Done \e[0m "
mkdir samfiles
mkdir bamfiles
echo -e "\e[34m Human GRCh38 mapping \e[0m "
cd trimmed/
for x in *.fastq #Map human genome for SNPs
do
		echo "Mapping $x"
		sam=$(echo "$x" | rev |cut -d"." -f2- | rev )
		echo "$sam"
        /home/fagi/miniconda3/bin/bowtie2 --threads 16  --very-sensitive-local -x /home/fagi/grch38/GrChIndex -U $sam.fastq -S ../samfiles/$sam.sam #save samfile to samfiles/
done
cd ../samfiles

cd ../bamfiles
#Fixing FLAG
#for z in *.bam
#do
#	sam=$(echo "$z" | rev |cut -d"." -f2- | rev )
#	echo "$sam"	
#	samtools fixmate -O bam "$sam".bam fixed"$sam".bam
#done
#Sam to bam

for y in *.sam
do
	sam=$(echo "$y" | rev |cut -d"." -f2- | rev )
	echo "$sam"	
	samtools view -S -b $sam.sam > ../bamfiles/$sam.bam # Translate SAM --> BAM
done
#Sorting by coordinate order 
samtools sort -n -f E36.bam E36sorted
#Indexing
samtools index E36sorted.bam
for u in fixed*.bam
do
	sam=$(echo "$u" | rev |cut -d"." -f2- | rev )
	echo "$sam"	
	samtools sort -O bam -o sorted"$sam".bam fixed"$sam".bam
done
# Basecalling na vcf bam ->> VC
bcftools mpileup -Ou -f /home/fagi/grch38/GCF_000001405.39_GRCh38.p13_genomic.fna E36-fixed.bam | bcftools call -vmO z -o E35.vcf.gz F

#Annotate Bam files

#for z in *.sam
#do
#	z1=$(echo "$z" | cut -f 1 -d '.')
#	samtools view -S -b $z > $z1.bam
#done