
from subprocess import check_output
from pandas import DataFrame
pwd = open('pwds.txt').read().splitlines()
files = open('files.txt').read().splitlines()

#print(pwd)
#print (files)

Data = {'sample-id': files ,
        'absolute-filepath': pwd
        }

df = DataFrame (Data, columns = ['sample-id','absolute-filepath'])
df = df.set_index('sample-id')
command = 'pwd'
#out = check_output(['pwd'])
#out = out.decode('utf-8')

df.to_csv('manifest.tsv', sep='\t')

print('Manifest TSV created')


