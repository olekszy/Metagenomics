mkdir trimmed
echo -e "\e[34m Trimming Started \e[0m"

for i in *.fastq
do
	java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 64 -phred33 $i trimmed/Td$i TRAILING:20 MINLEN:50 
done
echo -e "\e[34m Trimming Done \e[0m"
mkdir outputs 
mkdir reportskraken

cd trimmed/ 
echo -e "\e[34m Kraken2 Started \e[0m"
for a in *.fastq
do
#a=${z#trimmed/}
/home/fagi/miniconda3/libexec/kraken2 --threads 32 --db /home/fagi/Pulpit/kraken_microbial  --fastq-input $a  --report ../reportskraken/report_$a --output ../outputs/output_$a.krona

done
echo -e "\e[34m Kraken2 Analysis Done \e[0m"
cd .. 
echo -e "\e[34m Krona Started \e[0m"
mkdir Kronacharts

cd outputs/

for b in *.krona 	
do
	ktImportTaxonomy -q 2 -t 3 $b -o ../Kronacharts/$b.html 

done
echo -e "\e[34m Krona Done \e[0m"
#echo "Make data more accesible"
	#cd ../Kronacharts


#for z in *.html
#do 
#	x=$(x echo $z | sed -e 's/.*Mikrobiomy\(.*\).fastq.*/\1/')
#
#	mv "$z" "$x"
#done

#echo "Duration: $((($(date +%s)-$start)/60)) minutes"

#echo "Analysis done in $runtime" 


