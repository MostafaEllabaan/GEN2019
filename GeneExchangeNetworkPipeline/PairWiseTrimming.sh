eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1; geneName=$2; inputfile=$3; OutputOFCoordinatesFinding=$4; PairWiseTrimmedOutputResult=$5; GenExchangeNetworkMainitianingFile=$6;maxNumberOfThreads=$7
echo "geneFolder=$1; geneName=$2; inputfile=$3; OutputOFCoordinatesFinding=$4; PairWiseTrimmedOutputResult=$5; GenExchangeNetworkMainitianingFile=$6;maxNumberOfThreads=$7";
   
awk -F"\t" '{if(FNR==1) print $0; else {if($5=="REV") print $1"--"$2"--"$3"--"$4"--"$5"\t"$NF"\tFRW"; else print $1"--"$2"--"$3"--"$4"--"$5"\t"$(NF-1)"\tFRW"  }}' $OutputOFCoordinatesFinding   | sed 's/|/=/g'   > $GenExchangeNetworkMainitianingFile
	
#Unique sequences here
tmpFile2=$geneFolder/$geneName.GenNetwork.UniqSeq;  cut -f2 $GenExchangeNetworkMainitianingFile | sort -u  | awk -F"\t" '{print FNR"_seq\t"$0}' > $tmpFile2;

tmpFileQueueingJobFile=$geneFolder/commandSystem.jobs
geneSeq=$(awk -F"\t" '{if(FNR==2) print $2}' $inputfile)
awk -F"\t" -v seq=$geneSeq -v geneName="$geneName" '{ if(FNR>1) print "$PairWiseAlignmentCommand " seq" "$(NF)" "geneName" "$1;}' $tmpFile2 > $tmpFileQueueingJobFile

command="$MachineManager $maxNumberOfThreads $geneFolder/commandSystem.jobs $geneFolder/commandSystem.jobs.result"; echo $command; eval "$command";

echo "PairWiseCoverage=$PairWiseCoverage";  awk -F"\t" -v pairwiseCoverage=$PairWiseCoverage '{if($(NF-1)>pairwiseCoverage) print $0}' $geneFolder/commandSystem.jobs.result >  $PairWiseTrimmedOutputResult;


