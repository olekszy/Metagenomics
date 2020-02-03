mkdir trimmed
echo -e "\e[34m Trimming Started \e[0m"

for i in *R1*.fastq;
do
    sam=$(echo "$i" | sed "s/_R1_\001\.fastq//")
	echo "$sam"
	java -Xms4g -Xmx4g -jar /home/fagi/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 64 -phred33 $sam*R1*.fastq $sam*R2*.fastq trimmed/"$sam"_R1.fastq /dev/null trimmed/"$sam"_R2.fastq /dev/null TRAILING:20 MINLEN:50
done #cut sequences with trimmomatic
echo -e "\e[34m Trimming Done \e[0m "
mkdir cleanseq
mkdir matched
echo -e "\e[34m Human GRCh38 Cleaning \e[0m "
cd trimmed/

for x in *R1*.fastq #Delete Human grch38 sequences
do
        sam=$(echo "$x" | sed "s/_L\001\_R1.fastq//")
        echo "$sam"
#        echo "$sam"*_R1.fastq
#        echo "$sam"*_R2.fastq
        /home/fagi/miniconda3/bin/bowtie2 --threads 16 --very-sensitive-local -x /home/fagi/grch38/GrChIndex -1 $sam*R1*.fastq -2 $sam*R2*.fastq -S /dev/null --un-conc  ../cleanseq/$sam.fastq 
done
echo -e "\e[34m Sequences Cleaning Completed \e[0m"
cd ../cleanseq
echo -e "\e[34m Bowtie2 analysis start \e[0m"
for a in *.1.fastq
do	 
	sam=$(echo "$a" | sed "s/.1.fastq//")
	echo "$sam"
#      	echo "$sam"*_R1.fastq
#    	echo "$sam"*_R2.fastq	
	/home/fagi/miniconda3/bin/bowtie2 --threads 16 --very-sensitive-local -x /home/fagi/Pulpit/HelicoPhage/dbHelicobacters/HeliAllPhages -1 $sam*1*.fastq -2 $sam*2*.fastq -S ../$sam.sam  --al-conc ../matched/$sam.fastq
done
echo -e "\e[34 Bowtie2 analysis done \e[0m "
cd ..

#for z in *.sam
#do
#	z1=$(echo "$z" | cut -f 1 -d '.')
#	samtools view -S -b $z > $z1.bam
























































































































































































-/
