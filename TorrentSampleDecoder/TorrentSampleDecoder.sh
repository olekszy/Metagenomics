echo "Decoding IonTorrent samples"
sed 1d coding.csv | while IFS=";" read barcode sample runnumber; do #read csv with attached samples  
		cd *$(echo $runnumber | tr -d '\r')* #Get to folder specified by runnumber
		echo "Decoding"
		pwd #print path
		mv *IonXpress_0$(echo $barcode | tr -d '\r')* "E$sample.fastq"; #change name of file 
		cd ..
	done
