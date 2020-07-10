eval "source $GeneEchangeNetworkProgramGlobalSetting"; 

geneFolder=$1; geneName=$2; 
blastTrimmedOutput=$3; 
blastOutputTabular=$4;
outputSeqFileWithCoordinate=$5;
echo "geneFolder=$1; geneName=$2; blastTrimmedOutput=$3; blastOutputTabular=$4; outputSeqFileWithCoordinate=$5;"

tmpFileCoordinate=$geneFolder/$geneName.hit.gids.seq.coordinates
cut -f2,3,9,10 $blastTrimmedOutput | sort -u | awk -F"\t" '{if(FNR==1) print $0; else {if($4<$3) print $1"\t"$2"\t"$4"\t"$3"\tREV"; else print $1"\t"$2"\t"$3"\t"$4"\tFRW"}}'  > $tmpFileCoordinate

JoinTwoFiles.sh $blastOutputTabular $tmpFileCoordinate  | awk -F"\t" '{if(FNR==1) print "";  else { print FNR"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$7"\t"substr($NF,$3,($4-$3)) ;  }}' > $outputSeqFileWithCoordinate

awk -F"\t"  '{  if(FNR==1) print ""; else print "python $reverseComplementaryCommand "$1" "$NF  }' $outputSeqFileWithCoordinate > $outputSeqFileWithCoordinate.tmp

#echo "wc -l  $outputSeqFileWithCoordinate.tmp"; wc -l  $outputSeqFileWithCoordinate.tmp

cmd="$MachineManager $numThreads $outputSeqFileWithCoordinate.tmp $outputSeqFileWithCoordinate.result"
echo "$cmd"; eval "$cmd";  

#echo "wc -l $outputSeqFileWithCoordinate.result"; wc -l $outputSeqFileWithCoordinate.result;head -n 10 $outputSeqFileWithCoordinate.result

JoinTwoFiles.sh	 $outputSeqFileWithCoordinate.result $outputSeqFileWithCoordinate | awk -F"\t" '{if(FNR==1) print ""; else {for(i=2;i<=(NF-2); i++) printf $i"\t"; printf $NF"\n";}}' > $outputSeqFileWithCoordinate.tmpx 

#echo "SLEEEPING"; sleep 1m
mv $outputSeqFileWithCoordinate.tmpx $outputSeqFileWithCoordinate; rm $tmpFileCoordinate $outputSeqFileWithCoordinate.result; 




