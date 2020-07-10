##TODO to make it based on organism name in the comming version.
eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

cmd="geneFolder=$1; geneName=$2; networkOrganismFile=$3; outputMatrixFileFor16SrRNA=$4 indexFileNameFor16SrRNA=$5;"; 
echo $cmd; eval $cmd;

cmd="PairWiseAlignementResultFor16SrRNAFileForCurrentNetwork=$geneFolder/16SrRNA.pairWiseAlignmentForCurrentNetwork; SummarizedNetwork=$networkOrganismFile.summarized";
echo $cmd; eval $cmd;

cmd="SummarizedNetwork=$SummarizedNetwork";
echo $cmd; eval $cmd;

SummarizedNetwork=$networkOrganismFile.summarized;  
cmd="awk -F\"\t\" '{if(NF>1) print \$NF}' $networkOrganismFile > $SummarizedNetwork;";echo "$cmd"; eval "$cmd";



cmd="awk -F"\t" '{if(FNR==1) print \"\"; l[FNR]=\$1; seq[FNR]=\$2; max=FNR} END { for(i=1;i<max;i++) for (j=i+1; j<=max;j++) { if ( l[i]>l[j])  print l[j]\"==\"l[i]; else  print l[i]\"==\"l[j]; }}' \$SummarizedNetwork > \$SummarizedNetwork.tmp "
echo $cmd; eval $cmd;

## this is a very bad design
cmd="specialSeparator=\"==\"";
echo $cmd; eval $cmd;

cmd="JoinTwoFiles.sh $SummarizedNetwork.tmp  $PairWiseAlignementResultFor16SrRNAFile | sed "s/$specialSeparator/\t/g" | 
awk -F"\t" '{if(length(\$1)>0 && length(\$2)>0) print \$1\"\t\"\$2\"\t\"\$3}'  > \$PairWiseAlignementResultFor16SrRNAFileForCurrentNetwork";
echo $cmd; eval $cmd;


cmd="$CreatePairWiseMatrix $PairWiseAlignementResultFor16SrRNAFileForCurrentNetwork $SummarizedNetwork $indexFileNameFor16SrRNA $outputMatrixFileFor16SrRNA"; echo $cmd; time $(eval "$cmd");

