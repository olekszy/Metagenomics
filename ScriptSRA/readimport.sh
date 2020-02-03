# read every line from listo downloaded from NCBI
cat SraAccList.txt | while read line
do			
	echo "importing $line"
	python3 SRAdownload.py "$line" | grep -e "amazon\|ebi.ac.uk" | sed -e 's/href: https:// ' | sed -e 's/href: http:// '| paste -sd ',' >> index.csv
done
