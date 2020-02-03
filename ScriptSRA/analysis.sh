for d in */ 
		do
	       echo $d	
			for s in $(ls $d*.fast* | sed '1q;d') # Check if files are Paired and or SingleEnd
			do  
				if [[ $(ls -1q $d | wc -l) == "2" ]];then #Check if pairedEnd
					if [[ $s == *".fasta" ]];then #Check if fasta
			#			echo "wchodze"
						cd $d
						cp ../Kraken2KronaFASTAPE.sh . 
						#echo $d $s 
						echo "Run FASTAPE protocol"
						sh Kraken2KronaFASTAPE.sh 
						rm Kraken2KronaFASTAPE.sh
						cd ..
			#			echo "wychodze"
					elif [[ $s == *".fastq" ]];then #check if fastq
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
				elif [[ $(ls -1q $d | wc -l) == "1" ]];then #Check if SingleEnd
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
