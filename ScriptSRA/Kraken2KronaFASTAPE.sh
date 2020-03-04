#mkdir trimmed
#for i in *.fasta
#do
#java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 $i trimmed/Td$i TRAILING:20 MINLEN:50 

#done

mkdir outputs 
mkdir reportskraken
echo "KRAKEN2 analysis"

for=$(ls *.fas* | sed '1q;d')
rev=$(ls *.fas*| sed '2q;d')
#a=${z#trimmed/}
/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/minikraken2_v1_8GB --PE $for $rev  --report reportskraken/report_$for --output outputs/output_$for.krona

#echo "Krona charts forming"

#mkdir Kronacharts

#cd outputs/

#for b in *.krona 	
#do
#	ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html 

#done
#echo "Make data more accesible"
	#cd ../Kronacharts


#for z in *.html
#do 
#	x=$(x echo $z | sed -e 's/.*Mikrobiomy\(.*\).fastq.*/\1/')
#
#	mv "$z" "$x"
#done
