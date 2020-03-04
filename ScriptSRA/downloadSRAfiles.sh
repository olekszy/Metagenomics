i=0
while IFS="," read ID forw id2 reve  
	do
	echo "Importing $ID"
	mkdir $ID
	cd $ID #Wejdz do folderu konkretnej proby
	if [[ $forw == *"ebi.ac.uk"* ]] #sprawdz czy http czy https
		then 
			for="http:$forw"
			rev="http:$reve"
		else
			for="https:$forw"
			rev="https:$reve"
	fi
	i=$(($i+1))                   # liczy do okreslonej dlugos
	wget $for
    wget $rev
	cd ..	#Wyjdz z folderu konkretnej proby
	if [ $i -eq 10 ] # ANALYSIS LOOP STARS HERE !!!!!!!
      	then #-------------------------------------------------------------
			for x in */*gz.1 #Sprawdz pliki z MiSeq
				do
				echo "renaming miseq"
				mv $x ${x%.*}
			done	#usun .1 z na koncu plikow miseq
		gunzip */*.gz	# check co 10 analiza
		echo "STARTING ANALAYSSSYYSYSSYYSSYSYSYSYYSYSYSYSYS"
		#sh analysis.sh
				for d in */ #=====================================================
				do
				   echo $d	#
					for s in $(ls $d*.fast* | sed '1q;d') 
					do  
						if [[ $(ls -1q $d | wc -l) == "2" ]];then #Sprawdz czy PE
							if [[ $s == *".fasta" ]];then 
					#			echo "wchodze"
								cd $d
								cp ../Kraken2KronaFASTAPE.sh . 
								#echo $d $s 
								echo "Run FASTAPE protocol"
								sh Kraken2KronaFASTAPE.sh 
								rm Kraken2KronaFASTAPE.sh
								cd ..
					#			echo "wychodze"
								elif [[ $s == *".fastq" ]];then 
					#			echo "wchodze"
								cd $d
								cp ../Kraken2KronaIlluminaPE.sh .
								#echo $d $s
								echo "Run FASTQPE protocol"
								sh Kraken2KronaIlluminaPE.sh
								rm Kraken2KronaIlluminaPE.sh
									rm -r  trimmed/
								#echo "wychodze"
								cd ..	
								else 
								echo "error" 
								fi
						elif [[ $(ls -1q $d | wc -l) == "1" ]];then #Sprawdz czy SE
								if [[ $s == *".fasta" ]];then 
					#			echo "wchodze"
								cd $d
								cp ../Kraken2KronaFASTASE.sh . 
								#echo $d $s 
								echo "Run FASTASE protocol"
								sh Kraken2KronaFASTASE.sh 
								rm Kraken2KronaFASTASE.sh
								cd ..
					#			echo "wychodze"
								elif [[ $s == *".fastq" ]];then 
					#			echo "wchodze"
								cd $d
								cp ../Kraken2KronaIlluminaSE.sh .
								#echo $d $s
								echo "Run FASTQSE protocol"
								sh Kraken2KronaIlluminaSE.sh
								rm Kraken2KronaIlluminaSE.sh
									rm -r  trimmed/
								#echo "wychodze"
								cd ..	
								else 
								echo "error" 
								fi
						else 
							echo "error PE or SE or already analysed \
									skipping"
						fi 
					done 
		done
		i=$(($i-10))
		mkdir ../AnalizaSRA
		mkdir trash
		cp -r */ ../AnalizaSRA
		mv -r */ ../trash
		rm -r trash
		rm ../AnalizaSRA/*/*.fast*
	else 
		echo "proceeding to next Sample"         # inaczej kontynuuj 
	fi
#------------------------------------zalaczanie poszczegolnych skryptow
done < index.csv
cd ..
