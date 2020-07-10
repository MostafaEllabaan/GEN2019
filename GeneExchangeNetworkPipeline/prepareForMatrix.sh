
eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1; geneName=$2; GenExchangNetworkUniqSeqFile=$3; GenExchangeNetworkMainitianingFile=$4; networkFile=$5; networkOrganismFile=$6;  echo "geneFolder=$1; geneName=$2; GenExchangNetworkUniqSeqFile=$3; GenExchangeNetworkMainitianingFile=$4; networkFile=$5; networkOrganismFile=$6;"

JoinTwoFilesBasedOnKeys.sh 2 2 $GenExchangNetworkUniqSeqFile $GenExchangeNetworkMainitianingFile | cut -f1,4 |  sort -u | awk -F"=" '{ l=substr($4,0,(index($4,".")-1)); print l"\t"$0}'  > $networkFile
JoinTwoFilesBasedOnKeys.sh 1 1 $networkFile $organismFile  | awk -F"\t" '{if(FNR==1) print "Accession\tGenomeID\tOrganism\tUniqNetworkSeqsID"; else print $1"\t"$2"\t"$3"\t"$5"\t"$6}' | 
JoinTwoFilesBasedOnKeys.sh 1 2 $SixTeenSrRNASeqIDMappingFile - |   awk -F"\t" '{if(FNR==1) print "Header"; else print $0}'   | 
cut -f1,2,3,4,5,7 | awk -F"\t" '{if(FNR==1) print "Accession\tOrganism\tgenomeID\tHitID\tUniqHitSeqID\t16SrRNA"; else print $0}' > $networkOrganismFile




