#mkdir trimmed
#for i in *.fasta
#do
#java -Xms4g -Xmx4g -jar /home/fagi/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 $i trimmed/Td$i TRAILING:20 MINLEN:50 

#done

mkdir outputs 
mkdir reportskraken
echo "KRAKEN2 analysis"

#cd trimmed/ 

for a in *.fasta
do
#a=${z#trimmed/}
/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/Pulpit/minikraken2_v1_8GB  --fastq-input $a  --report reportskraken/report_$a --output outputs/output_$a.krona

done 

echo "Krona charts forming"

mkdir Kronacharts

cd outputs/

for b in *.krona 	
do
	ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html 

done
echo "Make data more accesible"
	#cd ../Kronacharts


#for z in *.html
#do 
#	x=$(x echo $z | sed -e 's/.*Mikrobiomy\(.*\).fastq.*/\1/')
#
#	mv "$z" "$x"
#done

#echo "Duration: $((($(date +%s)-$start)/60)) minutes"

#echo "Analysis done in $runtime" 


