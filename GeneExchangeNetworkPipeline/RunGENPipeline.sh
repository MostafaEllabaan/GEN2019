eval "source $GeneEchangeNetworkProgramGlobalSetting";
geneFolder=$1 ; geneName=$2; inputFile=$3; tmpFolder=$4 ; ## HELP  geneFolder=$1 ; geneName=$2; inputFile=$3; tmpFolder=$4

#Prepare InputFiles
echo $tmpFolder; mkdir -p $tmpFolder; cp $geneFolder/$inputFile $tmpFolder/;


blastOutput=$tmpFolder/$geneName.blastn; trimmedBlastOutput=$blastOutput.trimmedBlast;PairWiseTrimmedOutputResult=$blastOutput.trimmedBlast.PairWiseTrimmedOutputResult;
geneTabularFile=$tmpFolder/$inputFile.tab; outputFastFile=$trimmedBlastOutput.gids.fasta; outputFastFileTabularForm=$trimmedBlastOutput.gids.fasta.tab;
inputFileWithGeneLength=$tmpFolder/$inputFile.tab.length;


##putSequeence in right format
lengthFile=$tmpFolder/$inputFile.tab.length

outputSeqFileWithCoordinate=$blastOutput.gids.seq.coordinates.trimmedToTheGene.WithBothFRWandREV


changeFastaFormatToTabularFormat.sh $tmpFolder/$inputFile $geneTabularFile; sed -i 's/>//g'  $geneTabularFile;
awk -F"\t" '{if(FNR==1) print $0; else print $1"\t"$2"\t"length($NF)}' $geneTabularFile >  $inputFileWithGeneLength

maxNumberOfThreads=8 

cmd="$GeneExchangeNetworkPipeline/Blast.sh $tmpFolder $geneName $inputFile $blastOutput; " 
echo $cmd; eval $cmd;

##  we trim blast output based on blast identity and coverage
cmd="$GeneExchangeNetworkPipeline/trimBlastOutput.sh $inputFileWithGeneLength $blastOutput $trimmedBlastOutput;"
echo $cmd; eval $cmd;

## we then extract sequences form blast databases
cmd="$GeneExchangeNetworkPipeline/getBlastSequences.sh $tmpFolder $geneName $trimmedBlastOutput $outputFastFile $outputFastFileTabularForm"
echo $cmd; eval $cmd;

## we then extract aligned region and unique them   
cmd="$GeneExchangeNetworkPipeline/getMatchedSequences.sh $tmpFolder $geneName $trimmedBlastOutput $outputFastFileTabularForm $outputSeqFileWithCoordinate;"
echo $cmd; eval $cmd;
## trim based on pairwise alignment
GenExchangeNetworkMainitianingFile=$outputSeqFileWithCoordinate.shorten

cmd="$GeneExchangeNetworkPipeline/PairWiseTrimming.sh $tmpFolder $geneName $geneTabularFile $outputSeqFileWithCoordinate $PairWiseTrimmedOutputResult $GenExchangeNetworkMainitianingFile $maxNumberOfThreads"
echo "$cmd"; eval "$cmd";

rm $outputFastFileTabularForm $outputFastFile

##remove this file here $outputSeqFileWithCoordinate
## remove fasta and tabular form of it here

 
GenExchangNetworkUniqSeqFile=$tmpFolder/$geneName.GenNetwork.UniqSeq; PairWiseAlignementResultFile=$tmpFolder/$geneName.PairWiseSummary.Result;
cmd="$GeneExchangeNetworkPipeline/PairWiseAlignmentForATabedSeqFile.sh  $tmpFolder $geneName $PairWiseTrimmedOutputResult $GenExchangNetworkUniqSeqFile $PairWiseAlignementResultFile $maxNumberOfThreads"
echo "$cmd"; eval "$cmd";

networkFile=$tmpFolder/Resutl.accession.Network; networkOrganismFile=$tmpFolder/$geneName.Networkfile.Organism; SummarizedNetwork=$networkOrganismFile.summarized;
cmd="$GeneExchangeNetworkPipeline/prepareForMatrix.sh $tmpFolder $geneName $GenExchangNetworkUniqSeqFile $GenExchangeNetworkMainitianingFile $networkFile $networkOrganismFile $SummarizedNetwork"
echo "$cmd"; eval "$cmd";

##outputFiles
outputMatrixFile16SrRNA=$tmpFolder/16SrRNA.distmat.mat.1; indexFileNameFor16SrRNA=$tmpFolder/16SrRNA.IndexTable; PairWiseAlignementResultFor16SrRNAFileForCurrentNetwork=$tmpFolder/16SrRNA.pairWiseAlignmentForCurrentNetwork;
cmd="$GeneExchangeNetworkPipeline/prepare16SrRNAMatrix.sh $tmpFolder $geneName $networkOrganismFile $outputMatrixFile16SrRNA $indexFileNameFor16SrRNA $PairWiseAlignementResultFor16SrRNAFileForCurrentNetwork $SummarizedNetwork" 
echo "$cmd"; eval "$cmd" ;

##outputFiles
outputMatrixFileTheGene=$tmpFolder/$geneName.distmat.mat.1; indexFileNameForGENSeqs=$tmpFolder/$geneName.IndexTable
cmd="$GeneExchangeNetworkPipeline/prepareGeneMatrix.sh $tmpFolder $geneName $networkOrganismFile $PairWiseAlignementResultFile $outputMatrixFileTheGene $indexFileNameForGENSeqs $SummarizedNetwork"
echo "$cmd"; eval "$cmd"; 

PValueOutput=$tmpFolder/$geneName.pvalue; PvalueClusteringFile=$tmpFolder/$geneName.Clusters
cmd="$GeneExchangeNetworkPipeline/runPValueCalculation.sh $tmpFolder $geneName $outputMatrixFile16SrRNA $indexFileNameFor16SrRNA $outputMatrixFileTheGene $indexFileNameForGENSeqs $PValueOutput $PvalueClusteringFile"
echo "$cmd"; eval "$cmd"; 

## prepare the final files
JoinTwoFilesBasedOnKeys.sh 2 2 $PvalueClusteringFile  $tmpFolder/16SrRNA.IndexTable  | JoinTwoFilesBasedOnKeys.sh 3 8 - $tmpFolder/$geneName.Networkfile.Organism | awk '{print $NF"\t"$0}' | sort -n > $tmpFolder/clusteringResult.organized 

cp -r $tmpFolder $geneFolder
#rm -rf $tmpFolder/
## add the original blast output result and the pairwise aligment
## add metadata about the genomes (gram + or negative )
## add metadata about the genomes (gram + or negative )

