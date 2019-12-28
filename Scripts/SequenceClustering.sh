
## assume that you have cd-hit-est downloaded

inputFastaFile=$1
i=$2;
output=$3
geneClusterFile=$4

clusterRepresentativeGeneSeq=$5
workingDir=$6
CoverageOFLargerGenes=$7
aL=$CoverageOFLargerGenes #Coverage of the longer sequences.  
aS=$i



#TODO You have to find allow the user to add his own parameters. 
 
cd-hit-est   -d 1000 -i $inputFastaFile  -o  $output  -c $i -M 0 -r 1 -G 0 -g 1  -T 28   -aL $aL -bak 1 -aS $aS 



cat $output.clstr | sed 's/ //g' | awk '{if(index($0,"Cluster")>0) cluster=$0; else print $0"\t"cluster}'  |  
awk -F">" '{print $2"\t"$3}' | sed 's/\.\.\.*/\t/g'  | 
awk -F"\t" '{if(FNR==1) print "Gene\tCluster"; print $1"\t"$NF}'   > $geneClusterFile
	
	
	
changeFastaFormatToTabularFormat.sh $output $output.tab
sed -i 's/>//g' $output.tab
JoinTwoFiles.sh $output.tab $geneClusterFile  | cut -f2,3,4 > $clusterRepresentativeGeneSeq

rm $workingDir*.clstr
