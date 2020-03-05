start=`date +%s`
echo "Decoding"
FILE=./coding.csv
if test -f "$FILE"; 
	then
    		echo "$FILE exist"
		sh ./names.sh
	else
		echo "file not exists"
fi

echo "Decoding Completed"

for i in */ 
do
	echo "Analysis attached to $i"
	cd $i
	cp ../Kraken2KronaSE.sh ./
	sh Kraken2KronaSE.sh |& tee -a Analysisreport.txt
	rm Kraken2KronaSE.sh
	echo "removed"
	cd ..
done

end=`date +%s`
runtime=$((end-start))
time=$((runtime/60))  
echo -e "\e[92m Analysis completed in $time minutes \e[0m"
