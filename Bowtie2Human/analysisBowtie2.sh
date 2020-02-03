start=`date +%s`
for i in */ # loop for all folders 
do
	echo "Analysis attached to $i"
	cd $i
	cp ../Bowtie2SNP . #copy analysing script into folder
	sh Bowtie2SNP.sh |& tee -a BWA_Analysisreport.txt # run analysisi
	rm Bowtie2SNP.sh #remove script
	echo "removed"
	cd ..
done
end=`date +%s`
runtime=$((end-start))
time=$((runtime/60))  
echo -e "\e[92m Analysis completed in $time minutes \e[0m"