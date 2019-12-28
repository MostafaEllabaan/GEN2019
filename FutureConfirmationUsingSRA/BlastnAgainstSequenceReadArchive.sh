
queryGenes=$1
SRAID=$2
resultDir=$3

tmpID="EXP-SRA-$RANDOM-$RANDOM"
tmpDir="/dev/shm/$tmpID/$SRAID"
mkdir -p $tmpDir
cd $tmpDir



$ProgramsSpace/sratoolkit.2.9.2-centos_linux64/bin/fastq-dump –X 5 –Z –split-files $SRAID --fasta

rm /dev/shm/ncbi/sra/*${SRAID}*

changeFastaFormatToTabularFormat.withIndexedWithGIDS.sh  $SRAID.fasta $SRAID.tab 

awk -F"\t" '{print $1"\t"length($NF)}' $SRAID.tab  > $SRAID.len




mkdir blastdb; cd blastdb; makeblastdb.sh ../$SRAID.fasta $SRAID $SRAID nucl; 
cd .. ; 
rm *fasta

blastn -query $queryGenes -db blastdb/$SRAID -outfmt 6 -word_size 16 -out $SRAID.blst.rst

awk -F"\t" 'BEGIN {print ""} {if($3>95 && $4>50) print $0}' $SRAID.blst.rst > $SRAID.blst.rst.1

mv $SRAID.blst.rst.1 $SRAID.blst.rst


cut -f2 $SRAID.blst.rst | JoinTwoFiles.sh  $SRAID.len - | cut -f2- > $SRAID.len.1

cut -f2 $SRAID.blst.rst | JoinTwoFiles.sh  $SRAID.tab - | cut -f2- > $SRAID.tab.1
mv $SRAID.len.1 $SRAID.len
mv $SRAID.tab.1 $SRAID.tab


rm -rf blastdb

cd ../ 
mv /dev/shm/$tmpID $resultDir

#rm /dev/shm/ncbi/sra/*${SRAID}*

