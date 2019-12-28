genomeFolder=$1;      ## the folder where the genome is stored
min16SrRNALength=$2;  ## the minimum length to confirm that a 16SrRNA gene is found
minIdentity=$3        ## the minimum identity of the 16SrRNA

## precompiled 16SrRNA

rRNAFolder=$DataSpace/Databases/16SrRNADB/;
rRNAblastdb=$rRNAFolder/ALL16SrRNA/all16SrRNA.tab.trimmedBasedOnPrimers.HaveMostOfPrimersBetween1400-1600pb;

workingDir=/dev/shm/Contimination-$RANDOM-$RANDOM-$RANDOM;
mkdir $workingDir
cp $genomeFolder/*.fna* $workingDir
cd $workingDir;
file=$(ls *.fna* | grep -v -i "rna\|cds" )
gzip -d $file;
genomeFile=$(echo $file | sed 's/\.gz//g' | awk '{print $1}')
echo $genomeFile
genomeID=$(echo $genomeFile | sed 's/\.fna//g')

changeFastaFormatToTabularFormat.withIndexedWithGIDS.sh $genomeFile $genomeFile.tab

## blast genome against the 16SrRNA 
time blastn -query $genomeFile -db $rRNAblastdb -out result.tmp -word_size 20 -num_threads 28 -outfmt 6 -max_target_seqs 100

awk -F"\t" -v min16SrRNALength=$min16SrRNALength -v minIdentity=$minIdentity '{
if(FNR>1 && $3>=minIdentity && $4> min16SrRNALength) print $0}' result.tmp > result.tmp.16SrRNA

awk -F"\t" '{print $1"\t"$7"\t"$8}' result.tmp.16SrRNA  | sort -u | 
sort -k1,1 -k2,2n -k3,3nr  |  awk -F"\t" '{if(FNR==1) { 
print "Contig\tStart\tEnd"; print $0; contig=$1; regionStart=$2; regionEnd=$3;} 
else {
if(contig==$1) { x=$2-regionEnd; if(x>0) { print $0; regionStart=$2; regionEnd=$3;}} 
else { print $0; contig=$1; regionStart=$2; regionEnd=$3;}}}'  | 
JoinTwoFiles.sh $genomeFile.tab -  | awk -F"\t" '{
print $1"\t"$2"\t"$3"\t"substr($NF,$2,($3-$2))}'  > result.tmp.16SrRNA.seq

awk -F"\t" '{if( FNR>1) print $0}' result.tmp.16SrRNA.seq  | sort -u | 
awk -F"\t" -v genomeID=$genomeFile '{
print ">"$1"__"$2"__"$3"=="FNR"\n" $NF
}' | sed 's/[_\.]/=/g' > $genomeID.16SrRNA

mkdir Clustering
cd Clustering

SequenceClustering.sh ../$genomeID.16SrRNA 0.97 clustering.out gene.cluster cluster.representative $(pwd) 0.05 &> tmp.result.tmp

numberOfCluster=$(awk -F"\t" '{if(FNR>1) print $2}' gene.cluster | sort -u  | wc -l)

if (( numberOfCluster==1 )); then
        echo "single 16S rRNA Clustered genomes"> ../$genomeFile.16SrRNA.proceed
fi

cd $workingDir
zip -r  $genomeID.16SrRNA.zip {result*,*.16SrRNA*,Clustering}
mv $genomeID.16SrRNA.zip  $genomeFolder
sleep 1s
touch $genomeFolder
ls $genomeFolder/$genomeID.16SrRNA.zip

rm -rf $workingDir
