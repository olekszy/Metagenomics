import glob,os,subprocess, sys
#take first argument in loop
folder = (sys.argv[1])
print(folder)
#change destination
destination = "cd {}".format(folder)
print(destination)
destinationcommand = subprocess.run(destination,shell=True)

    #Change workspace of script
def importhomeland():
    stream = os.popen('pwd')
    out = stream.read().strip()
    return out
#execute commands
def executecommand(command):
    subprocess.run(command, shell = True)
#create folders
def createfolder(name):
    if not os.path.isdir(name):
        os.mkdir(name)

workspace = importhomeland()+"/"+folder
dir = os.chdir(workspace)
print(workspace)

pathtofagi = "/bighdd/metagenomics/IlluminaSeq/workspace/"

trimmedpath = pathtofagi+"trimmed_"+folder
outputspath = pathtofagi+"outputs_"+folder
reportspath = pathtofagi+"reportskraken_"+folder
#kronapath = pathtofagi+"Kronacharts_"+folder
cleanseqpath = pathtofagi+"cleanseq_"+folder
normalreportpath= pathtofagi+"normalreport_"+folder


createfolder(pathtofagi+"trimmed_"+folder)
createfolder(pathtofagi+"outputs_"+folder)
createfolder(pathtofagi+"reportskraken_"+folder)
#createfolder(pathtofagi+"Kronacharts_"+folder)
createfolder(pathtofagi+"cleanseq_"+folder)
createfolder(pathtofagi+"unclassified_"+folder)
createfolder(pathtofagi+"normalreport_"+folder)

#Run Trimmomatic
#for i in glob.glob("*R1*fastq"):
 #   print(i)
 #   samplename = i.split(".fastq")[0]
 #   readname = i.split("_")[0]
 #   print("Processing_"+samplename)
    #create command
 #   trimmomatic= "java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 32 -phred33 {}*R1* {}*R2* {}/clean_{}_R1.fastq /dev/null {}/clean_{}_R2.fastq /dev/null TRAILING:20 MINLEN:50".format(readname,readname,trimmedpath,readname,trimmedpath, readname)    
 #   print(trimmomatic)
 #   #save trimmomatic output in folder trimmed
 # executecommand(trimmomatic)

#discard human sequences
#for i in glob.glob(trimmedpath+"/*R1*fastq"):
#    print(i)
#    trimmedname = i.split(".fastq")[0]
#    print(trimmedname)
#    readname = i.split("_")[2]
#    print(trimmedpath+readname)
#    print(readname)
#    print(cleanseqpath)
#    bowtiediscard = "/home/fagi/miniconda3/bin/bowtie2 --threads 16 --very-sensitive-local -x /home/fagi/bowtie2grch38/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index -1 {}*R1.fastq -2 {}*R2.fastq --un-conc {}/clear_{}.fastq -S /dev/null".format(trimmedpath+"/*"+readname,trimmedpath+"/*"+readname,cleanseqpath, readname)
#    print(bowtiediscard)
#    executecommand(bowtiediscard)

#Run kraken2
for i in glob.glob(cleanseqpath+"/*.1.fastq"):
    #extract filename
    trimmedname = i.split(".fastq")[0].split(".")[0]
    outname = trimmedname.split("/")[-1]
    print(trimmedname)
    #create kraken2 command
    kraken2 = "/home/fagi/kraken2/kraken2 --threads 32 --db /home/fagi/kraken_microbial --paired {}*.1.fastq {}*.2.fastq --report {}/report_{}".format(trimmedname,trimmedname,normalreportpath,outname)
    print(kraken2)
    #save reports to reportskraken and output for krona in outputs
    executecommand(kraken2)