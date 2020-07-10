
eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

inputFileWithGeneLength=$1
blastOutput=$2
trimmedBlastOutput=$3
JoinTwoFiles.sh $geneFolder/$inputFileWithGeneLength $blastOutput | 
awk -F"\t" -v identity=$blastIdenity -v blastCoverage=$blastCoverage '{if(FNR==1) print ""; else {if($3>=identity && (100*($4-$5-$6)/$NF)>= blastCoverage) print $0 }}' > $trimmedBlastOutput
	

##TODO: In the debugging mode, rm should not be executed


			


	 
