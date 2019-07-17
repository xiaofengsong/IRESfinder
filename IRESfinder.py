#!/usr/bin/env python

'''determine whether the version of user's python comply with the requirements of  this procedure'''
import sys
if sys.version_info[0] != 2 or sys.version_info[1] != 7:
	print >>sys.stderr, "\nYou are using python" + str(sys.version_info[0]) + '.' + str(sys.version_info[1]) + " IRESfinder needs python2.7!\n"
	sys.exit()

import os
import optparse

#from cpmodule import ireader
import numpy as np
from sklearn.linear_model import LogisticRegressionCV
from sklearn import preprocessing
 
#==============================================================================
# functions definition
#==============================================================================
def if_fasta(infile):
	'''determine if the input file is fasta format'''
	format = "UNKNOWN"
	f = open(infile)
	tmpstr = f.readline()
	while tmpstr[0] == '#':
		tmpstr = f.readline()

	f.close()
	if tmpstr[0] == '>':
		format="FASTA"
		return format

	return format


#==============================================================================
#   Print the final result 
#==============================================================================
def PrintResult(ids,labels,probability,outputfile):
        
    Tabel = 'ID' + '\t' + 'Index' + '\t' + 'Score' + '\n'
    outputfile.write(Tabel)
    for i in range(len(ids)):
#        transcriptid = ids[i].strip()
#        Arr_label = transcriptid.split('>')
#        line = Arr_label[1]
	line = ids[i].strip()
        if labels[i] == 1:
            line = line + '\t' + 'IRES'
        else:
            line = line + '\t' + 'non-IRES'
        line = line + '\t' + str(probability[i]) +'\n'
        outputfile.write(line)

  
#==============================================================================
# Main program
#==============================================================================

parse=optparse.OptionParser()
parse.add_option('-f','--file',dest='file',action='store',metavar='input files',help="enter transcripts in .fasta format")
parse.add_option('-o','--out',dest='outfile',action='store',metavar='output files',help='assign your output file')
parse.add_option('-m','--model',dest='model',action="store",metavar='handle model',default="0",help="Please select your model for handling transcripts: 0, default, just using the complete transcript sequences; 1, optional, using the subsequences specified by the index (e.g. >id start_pos end_pos); 2, optional, spliting the transcript into fragments, please provides the window size (-w, defualt 174) and the step size (-s, defualt 50);")
parse.add_option("-w","--window",dest="window",action="store",metavar='sliding window size',default="174",help="Ignore this option if the selected model is not 2.")
parse.add_option("-s","--step",dest="step",action="store",metavar='step size of the sliding window',default="50",help="Ignore this option if the selected model is not 2.")


(options,args) = parse.parse_args()

#check input and output files
if options.model == '2':
    for file in ([options.file,options.outfile,options.window,options.step]):
        if not (file):
            parse.print_help()
            sys.exit(0)
else:
    for file in ([options.file,options.outfile]):
        if not (file):
            parse.print_help()
            sys.exit(0)


file_format = if_fasta(options.file)
if file_format == 'UNKNOWN':
	print >>sys.stderr, "\nError: unknown file format of '-f'\n"
	parse.print_help()
	sys.exit(0)		
elif file_format == 'FASTA':
    inPutFileName = options.file


IRESFINDERPATH = os.path.split(os.path.realpath(__file__))[0]

outPutFileName = options.outfile


#==============================================================================
#  Handling transcripts with user slected model
#==============================================================================

temp_inPutFileName = 'temp_inputfile.seq'
temp_outputlab = 'tmp_outputlab.txt'

if options.model == '2':
    os.system('perl '+ IRESFINDERPATH + '/module/handlemodel2.pl '+ inPutFileName + ' '+ temp_inPutFileName + ' '+ temp_outputlab + ' '+ options.window + ' '+ options.step)
else:
    os.system('perl '+ IRESFINDERPATH + '/module/handlemodel0or1.pl '+ inPutFileName + ' '+ temp_inPutFileName + ' '+ temp_outputlab)

#==============================================================================
#  Calculating 19 selected fuzzy k-mer features
#==============================================================================
temp_features = 'tmp_features.txt'
os.system('perl '+ IRESFINDERPATH + '/module/calculate_features.pl '+ temp_inPutFileName + ' '+ temp_features)

#==============================================================================
#  To built a logit model with the training dataset
#==============================================================================
train_file = IRESFINDERPATH + '/module/train.data';
f = open(train_file)
data = np.loadtxt(f)
f.close()
training_data = data[:,1:]
training_label = data[:,0]

scaler = preprocessing.StandardScaler().fit(training_data)
training_data = scaler.transform(training_data)

[R,L] = training_data.shape
xindex = []
for i in range(0,L):
	ra = sum(training_data[:,i]>0)/(R * 1.0)
	if ra > 0.1:
		xindex.append(i)

training_data = training_data[:,xindex]


selected_findex = [0,50,1774,382,339,872,2069,197,250,119,98,13,591,1257,92,1117,822,258,1467]
training_data = training_data[:,selected_findex]
classifier = LogisticRegressionCV(cv=3).fit(training_data,training_label)

#==============================================================================
#  Predicting IRESs
#==============================================================================
f = open(temp_features)
data = np.loadtxt(f)
f.close()
predict_data = scaler.transform(data)

predict_data = predict_data[:,xindex]
predict_data = predict_data[:,selected_findex]
probas = classifier.predict_proba(predict_data)
labels = classifier.predict(predict_data) 

f = open(temp_outputlab)
ids = f.readlines()
f.close()

outfile = open(outPutFileName,'w')
PrintResult(ids,labels,probas[:,1],outfile) 
outfile.close()

os.remove(temp_inPutFileName)
os.remove(temp_outputlab)
os.remove(temp_features)


