
ListFile=$1 ; GENStableFolder=$2; echo "ListFile=$1 ; GENStableFolder=$2;";

echo "" > commands.sh; 
tmpDir=/dev/shm/GEN; mkdir -p $tmpDir;
while read geneName Sequence; do
	geneFolder=$GENStableFolder/$geneName
	mkdir -p $geneFolder;
	inputFile="$geneName.fa"
	echo -e ">$geneName\n$Sequence" > $geneFolder/$inputFile;
	echo "$GeneExchangeNetworkPipeline/RunGENPipeline.sh $geneFolder $geneName $inputFile $tmpDir/$geneName " >> $GENStableFolder/commands.sh
done < $ListFile

