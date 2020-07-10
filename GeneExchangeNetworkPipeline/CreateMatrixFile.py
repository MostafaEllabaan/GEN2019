
'''
how to run
PairWiseDataFile="/run/media/mostafa/DataSpace/test/gene1/PairWiseSummary.Result";
Network="/run/media/mostafa/DataSpace/test/gene1/netowrkFile.summarized"
matrixFile="/run/media/mostafa/DataSpace/test/gene1/gene.distmat.mat.1"
IndexFile="/run/media/mostafa/DataSpace/test/gene1/gene.IndexTable"



python /run/media/mostafa/SoftWorkSpace/workspace2/GeneExchangeNetworkPipeline/CreateMatrixFile.py $PairWiseDataFile $Network $matrixFile $matrixFile

'''
from sys import argv

PairWiseDataFile=argv[1]
Network=argv[2]
IndexFile=argv[3]
matrixFile=argv[4]
ValfileReader=open(PairWiseDataFile);

from collections import defaultdict
dict = defaultdict(list)


row="";

NetWorkFileReader=open(Network);

ids=NetWorkFileReader.readlines()


UniqSeqID=[]
dictForPositionIndexFile=defaultdict(list)
hasHeader=True;
for i in range(1,len(ids)):
    if(hasHeader): 
        hasHeader=False;
        continue;    
    itmi=int(ids[i][0:len(ids[i])-1]);
    if itmi in dictForPositionIndexFile.keys():  dictForPositionIndexFile[itmi].append(i);
    else: dictForPositionIndexFile[itmi]=[i];
    UniqSeqID.append(itmi);
     
my_list = sorted(set(UniqSeqID));
for i in my_list:
    dict[i]=[]
  
       
#for i in sorted(dict.keys()):
#print my_list

hasHeader=True;
for i in ValfileReader.readlines():
 #   print i;
    if(hasHeader): 
        hasHeader=False;
        continue;
        
    l=i[0:len(i)-1] 
    
    fields=l.split("\t")
    
    if int(fields[0]) in dict.keys():
        dict[int(fields[0])].append((int(fields[1]),fields[2]))
    else:
        dict[int(fields[0])]=[(int(fields[1]),fields[2])]


#print dict;



from sortedcontainers import SortedList

def findValue(index1,index2):
        if index1==index2: return 0.0;
        lst= SortedList(dict[index1])
        index = lst.bisect((index2,))
#	print lst	
#	print index, len(lst);
	lst[index]
        return float(lst[index][1])

## now we can find the value for any pairs. 

matrixFileWriter=open(matrixFile, "w");
for i in range(0,len(my_list)):
    row="";
    itmi=my_list[i];
    for j in range(0,len(my_list)):
        itmj=my_list[j];
        min=itmi;
        max=itmj;
        if min > max  :
            min=itmj;
            max=itmi;
 #       print min, max
	row = row + str(findValue(min,max))
	
        if j < len(my_list)-1: row = row +"\t"            
#    print row;
    matrixFileWriter.write(row+"\n")
    
matrixFileWriter.close()


indexFileWriter=open(IndexFile, "w");
indexFileWriter.write("\n")
i=0;
#print dictForPositionIndexFile
for itmi in my_list:    
    for itmj in dictForPositionIndexFile[itmi]:
        row=str(itmj)+"\t" + str(i) +"\t"+ str(itmi);
        indexFileWriter.write(row+"\n")
    i=i+1;

indexFileWriter.close()

