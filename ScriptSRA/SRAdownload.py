# Scrap link for fastq and fasta from NCBI

from bs4 import BeautifulSoup
import re
import requests
import pandas as pd
import sys
p  = sys.argv[1]
i = str(p)
df = pd.read_csv('/home/fagi/Pulpit/SRA/SraAccList.txt')
rows = len(df)
url = "trace.ncbi.nlm.nih.gov/Traces/sra/?run="+i
r = requests.get("http://" + str(url))
data = r.text
#soup = BeautifulSoup(data, features="html.parser")
soup = BeautifulSoup(data, "lxml")
##for tag in soup.find_all("a"):
 #   print(tag.name)
 # pluralsight.com/guides/extracting-data-html-beautifulsoup
for link in soup.find_all("a"):
 #   print("Inner Text: {}".format(link.text))
  #  print("Title: {}".format(link.get("title")))
    z = "href: {}".format(link.get("href"))
    print(i+","+z)
   # x = z.subprocess.run(["grep", "ftp.sra.ebi.ac"], capture_output = TRUE) 
   # x = x.subprocess.run(["sed", "-e", "s/href: http://"], capture_output = TRUE)
   # print (x)
#print(soup.prettify())
