
SRAID=$1
resultFolder=$2

genomeID="Gn-"$SRAID

tmpDir="/dev/shm/Assembly-EXP-SRA-$RANDOM-$RANDOM/$SRAID"
mkdir -p $tmpDir
cd $tmpDir
##$ProgramsSpace/sratoolkit.2.9.2-ubuntu64/bin/fastq-dump –X 5 –Z –split-files $SRAID 

##time $ProgramsSpace/Assembliers/SPAdes/SPAdes-3.12.0-Linux/bin/spades.py --12  $SRAID.fastq --sc -o $(pwd)/assembliedData

## time $ProgramsSpace/sratoolkit.2.9.2-centos_linux64/bin/prefetch $SRAID 
time $ProgramsSpace/sratoolkit.2.9.2-centos_linux64/bin/fasterq-dump $SRAID 
rm /scratch/ncbi/sra/$SRAID*

cat ${SRAID}*.fastq > X_${SRAID}.fastq

rm ${SRAID}*.fastq

result=$(grep "@" X_${SRAID}.fastq | wc -l | awk '{if($0%2==1) print "YES"}')
result='YES'
if [[ $result == 'YES' ]] ; then

time spades.py -s  X_${SRAID}.fastq --sc -o $(pwd)/assembliedData

else

time spades.py -12  X_${SRAID}.fastq --sc -o $(pwd)/assembliedData

fi

cp $tmpDir/assembliedData/*fasta . 
ls *fasta | xargs -I {} mv {} $genomeID"_"{}
mv $genomeID"_"*fasta $resultFolder

cd /dev/shm/
sleep 3s
rm -rf $tmpDir




