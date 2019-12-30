
<<EXAMPLE
HOW TO USE THE PIPELINE

blastProgram=$blastExecFolder/blastx; # the blast program to run blastn for nucleotide, blastx for nucleotide querys against protein
inputFile=amar.fa	; # inputFile
maxTargetSeqs=10	; # maxTargetSeqs is the maximum target sequences that blast should search for
evalue="1e-10" ; # evalue the maximum evalue considered 
outputFile="amar.fa.out.cogsAnnotation" ; # outputFile
wordSize=4;
cmd="./AnnotateUsingCOGS.sh $blastProgram $inputFile $maxTargetSeqs $evalue $outputFile $wordSize"
echo "$cmd"; eval "$cmd";

EXAMPLE

cmd="blastProgram=$1; inputFile=$2; maxTargetSeqs=$3; evalue=$4 ; outputFile=$5 ; wordSize=$6;"; echo "$cmd"; eval "$cmd";

COGSDB=$DataSpace/Databases/COGS/COG2014/data/; dataBase=$COGSDB/blastdb/cogsdb;
dataBaseAnnotation=$CARDDBInfo/cogNamesPlusFunction.tab;

numCPU=28;
cmd="blastProgram=$1; inputFile=$2; maxTargetSeqs=$3; evalue=$4 ; outputFile=$5 ; wordSize=$6;"; echo "$cmd"; eval "$cmd";

changeFastaFormatToTabularFormat.sh $inputFile $inputFile.tab && sed 's/>//g' -i $inputFile.tab

### We assume the first field to be the ID
awk '{if(FNR==1) print "GeneID\tLength"; print $1"\t"length($NF)}' $inputFile.tab >  $inputFile.length

cmd="$blastProgram -query $inputFile -db $dataBase -max_target_seqs $maxTargetSeqs  -evalue $evalue -outfmt 6 -out $outputFile  -word_size $wordSize -num_threads $numCPU"  ; echo "$cmd"; eval "$cmd";


mv $outputFile $outputFile.tmp  

sort -k1,1 -k12,12nr $outputFile.tmp | awk -F"\t" '{if(FNR==1) {gene=$1; print $0} else {if(gene!=$1) {gene=$1; print $0} } }' | 
awk -F"|"  '{if(FNR==1) print ""; print $2"\t"$0}' | cut -f1,2,3,4,5,12,13 |  
JoinTwoFiles.sh  $COGSDB/cog2003-2014.tab - |  cut -f2,3,4,5,6,7,9,14 |  
awk -F"\t" '{COGID=$NF; print COGID"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' | 
JoinTwoFiles.sh  $COGSDB/cogNamesPlusFunction.tab - | cut -f2,3,4,5,6,7,8,9,10,11 | 
awk -F"\t" '{
if(FNR==1) print "QueryGene\tHitGene\tPrecentageIdentity\tIdentity\tEvalue\tbitScore\t"$7"\t"$8"\t"$9"\t"$10; 
else print $0}' >  $outputFile



## to make it all on tabular format so that the information related to one gene is shown in one row
