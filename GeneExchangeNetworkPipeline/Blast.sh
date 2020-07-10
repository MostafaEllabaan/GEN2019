# how to add the global variables without changing in this code
eval "source $GeneEchangeNetworkProgramGlobalSetting"; 
geneFolder=$1; geneName=$2;inputFile=$3;outputFile=$4
echo "geneFolder=$1; geneName=$2;inputFile=$3;outputFile=$4";
## to blast gene against databases of microbial genomes. 
cmd="$blastExecFolder/blastn -query $geneFolder/$inputFile -db $BacterialGenomesBlastDB -outfmt 6 -max_target_seqs $maxTargetSeqs -num_threads $numThreads -out $outputFile"
echo "$cmd"; eval $cmd; addEmptyTitle.sh $outputFile;


