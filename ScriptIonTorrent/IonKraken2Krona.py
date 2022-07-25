import glob,os,subprocess, sys
from venv import create
#take first argument in loop
folder = (sys.argv[1])
print(folder)
#change destination
destination = "cd {}".format(folder)
print(destination)
destinationcommand = subprocess.run(destination,shell=True)

def importhomeland():
    stream = os.popen('pwd')
    out = stream.read().strip()
    return out
#Change workspace of script

#execetute commands
def executecommand(command):
    subprocess.run(command, shell = True)

def createfolder(name):
    if not os.path.isdir(name):
        os.mkdir(name)

workspace = importhomeland()+"/"+folder
dir = os.chdir(workspace)
print(workspace)
#make needed folders

createfolder("trimmed")
createfolder("outputs")
createfolder("reportskraken")
createfolder("Kronacharts")

#Run Trimmomatic
for i in glob.glob("*fastq"):
    samplename = i.split(".fastq")[0]
    print("Processing_"+samplename)
    #create command
    trimmomatic= "java -Xms4g -Xmx4g -jar /home/fagi/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 32 -phred33 {} trimmed/trimmed_{}.fastq TRAILING:20 MINLEN:50".format(i, samplename)    
    #save trimmomatic output in folder trimmed
    executecommand(trimmomatic)
    #commandtrimmomatic = subprocess.run(trimmomatic, shell =True)
#Run Kraken2
for i in glob.glob("trimmed/*fastq"):
    #extract filename
    trimmedname = i.split(".fastq")
    #create kraken2 command
    kraken2 = "/home/fagi/kraken2/kraken2 --threads 16 --db /home/fagi/kraken_microbial  --fastq-input {}  --report reportskraken/report_{} --output outputs/output_{}.krona".format(i,trimmedname,trimmedname)
    #save reports to reportskraken and output for krona in outputs
    executecommand(kraken2)
    #commandkraken2 = subprocess.run(kraken2, shell =True)
#Run Krona Chart Creation
for i in glob.glob("outputs/*krona"):
    #extract name for krona
    krakenname = i.split(".krona")[0].split("_")[1]
    krona = "/home/fagi/krona/bin/ktImportTaxonomy -q 2 -t 3 {} -o Kronacharts/{}.html".format(i,krakenname)
    executecommand(krona)
    commandkrona = subprocess.run(krona, shell = True)