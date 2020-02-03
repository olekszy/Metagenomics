mkdir reportskraken
mkdir outputs
cd trimmed/
for a in *R1*.fastq
do	 
	sam=$(echo "$a" | sed "s/_L\001\_R1.fastq//")
        echo "$sam"
        #echo "$sam"*_R1.fastq
       	#echo "$sam"*_R2.fastq	
	/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/maxikraken2  --paired $sam*R1*.fastq $sam*R2*.fastq  --report ../reportskraken/"sam"_report --output ../outputs/"$sam"_krona
done
