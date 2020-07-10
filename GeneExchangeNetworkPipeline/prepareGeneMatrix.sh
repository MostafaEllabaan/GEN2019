eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

cmd="geneFolder=$1 ; geneName=$2; networkOrganismFile=$3; PairWiseAlignementResultFile=$4; outputMatrixFileTheGene=$5; indexFileNameForGENSeqs=$6;"
echo "$cmd"; eval "$cmd";


tmpfile1=$networkOrganismFile.summarized;  
cmd="awk -F\"\t\" '{if(NF>1) print \$(NF-1)}' $networkOrganismFile > $tmpfile1;";echo "$cmd"; eval "$cmd";


cmd="$CreatePairWiseMatrix  $PairWiseAlignementResultFile $tmpfile1 $indexFileNameForGENSeqs $outputMatrixFileTheGene";
echo "$cmd"; eval "$cmd";

#time $(eval "$cmd");
# rm $tmpfile1  ;
