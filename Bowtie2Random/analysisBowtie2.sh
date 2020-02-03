start=`date +%s`
for i in */ # loop for all folders 
do
	echo "Analysis attached to $i"
	cd $i
	cp ../Bowtie2Il.sh . #copy analysing script into folder
	sh Bowtie2Il.sh |& tee -a BWA_Analysisreport.txt # run analysisi
	rm Bowtie2Il.sh #remove script
	echo "removed"
	cd ..
done
end=`date +%s`
runtime=$((end-start))
time=$((runtime/60))  
echo -e "\e[92m Analysis completed in $time minutes \e[0m"