
eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1 ;  geneName=$2; outputMatrixFileFor16SrRNA=$3; indexFileNameFor16SrRNA=$4; outputMatrixFileTheGene=$5; indexFileNameForGENSeqs=$6; PValueOutput=$7; PvalueClusteringFile=$8; 


indexFile=$geneFolder/indexTable
resultOFPvalueFile="$geneFolder/$geneName.pvaluetest.result"

JoinTwoFiles.sh $indexFileNameForGENSeqs $indexFileNameFor16SrRNA | cut -f1,2,5 | awk -F"\t" '{if(FNR==1) print "HitID\ttGeneID\t16SrRNAID"; else print $1"\t"$2"\t"$3}'> $indexFile
eval "$PValueTestCommand $outputMatrixFileFor16SrRNA $outputMatrixFileTheGene $indexFile $speciesCutOFF $ConfidenceLevel $PvalueClusteringFile" > $resultOFPvalueFile
grep "P-value" $resultOFPvalueFile | awk -v geneName=$geneName '{print geneName"\t"$NF}' | sed 's/"//g' >  $PValueOutput
echo "$PValueTestCommand $outputMatrixFileFor16SrRNA $outputMatrixFileTheGene $indexFile $speciesCutOFF $ConfidenceLevel $PvalueClusteringFile"