eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1; geneName=$2; tmpFilePairWiseAlignmentResult=$3
GenExchangNetworkUniqSeqFile=$4; PairWiseAlignementResultFile=$5 #$geneFolder/$geneName.PairWiseSummary.Result
maxNumberOfThreads=$6;

## this to give you things you miss
#
cut -f2 $tmpFilePairWiseAlignmentResult | sort -u | awk -F"\t" '{print FNR"\t"$0}' > $GenExchangNetworkUniqSeqFile;
awk -F"\t" '{l[FNR]=$1; seq[FNR]=$2; max=FNR} END { for(i=1;i<max;i++) for (j=i+1; j<=max;j++) print "$PairWiseCommand "seq[i]" "seq[j]" "i" "j}'  $GenExchangNetworkUniqSeqFile > $geneFolder/$geneName.PairWiseMatrix.jobs
time eval "$queueingSystemCommand $maxNumberOfThreads $geneFolder/$geneName.PairWiseMatrix.jobs $geneFolder/$geneName.PairWiseMatrix.jobs.result"
awk -F"\t" '{min=$9;if($9>$10) min=$10; print $3"\t"$4"\t"min}' $geneFolder/$geneName.PairWiseMatrix.jobs.result | awk -F"\t" '{ if(FNR==1) print ""; min=$3; print $1"\t"$2"\t"(1-min)}' > $PairWiseAlignementResultFile
	
#rm $geneFolder/$geneName.PairWiseMatrix.jobs.result  $geneFolder/$geneName.PairWiseMatrix.jobs

