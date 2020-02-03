start=`date +%s`
for i in */ # loop for all folders 
do
	echo "Analysis attached to $i"
	cd $i
	cp ../Kraken2KronaIlluminaPE.sh ./ #copy analysing script into folder
	sh Kraken2KronaIlluminaPE.sh |& tee -a Analysisreport.txt # run analysis
	rm Kraken2KronaIlluminaPE.sh #remove script
	echo "removed"
	cd ..
done

end=`date +%s`

runtime=$((end-start))

echo "Time:  $runtime"
