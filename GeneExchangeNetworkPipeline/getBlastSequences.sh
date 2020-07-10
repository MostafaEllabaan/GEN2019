eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1; geneName=$2; trimmedBlastOutput=$3; outputFastFile=$4; outputFastFileInTabularForm=$5; tmpFile=$trimmedBlastOutput.gids;
echo "geneFolder=$1; geneName=$2; trimmedBlastOutput=$3; outputFastFile=$4; outputFastFileInTabularForm=$5; tmpFile=$trimmedBlastOutput.gids";
## To extract fasta sequences of blast hits
echo "I am here:"
cut -f2 $trimmedBlastOutput | cut -f4 -d"|" | cut -f1 -d"." | sort -u  | awk -F"\t" '{if(FNR==1) print ""; print $0}'| 
awk -v BacterialGenomes=$BacterialGenomeFolder '{cmd="cat "BacterialGenomes"/tabFiles_extra/"$1".fna.tab"; print cmd; system(cmd) }' | awk -F"\t" '{if(FNR==1) print ""; if(NF>2) print $0}' > $outputFastFileInTabularForm;
#$blastExecFolder/blastdbcmd -entry_batch $tmpFile -outfmt %f -db $BacterialGenomesBlastDB -out $outputFastFile;
#echo "I am here 1:"
#time JoinTwoFiles.sh $tmpFile  $BacterialGenomeFolder/All.BacterialGenomes.fna.tab.withGIDS | cut -f1,2,3 > $outputFastFileInTabularForm
#changeFastaFormatToTabularFormat.withIndexedWithGIDS.sh $outputFastFile $outputFastFileInTabularForm;
