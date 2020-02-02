start=`date +%s`
for i in */ # loop for all folders 
do
	echo "Analysis attached to $i"
	cd $i
	cp ../BWAtoSNP.sh . #copy analysing script into folder
	sh BWAtoSNP.sh |& tee -a BWA_Analysisreport.txt # run analysisi
	rm BWAtoSNP.sh #remove script
	echo "removed"
	cd ..
done
end=`date +%s`
runtime=$((end-start))
time=$((runtime/60))  
echo -e "\e[92m Analysis completed in $time minutes \e[0m"
