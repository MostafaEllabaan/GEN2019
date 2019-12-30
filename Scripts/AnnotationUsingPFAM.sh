

QueryInputFile=$1
OutputFile=$2
workingDir=$3;
numberOfCPUs=$4
pfamAddress=$DataSpace/Databases/PFAM/Pfam27.0
hmmFileDB=$pfamAddress/Pfam-A.hmm


#hmmFileMetaData=$pfamAddress/Pfam-A.dat.tab

hmmFileMetaData=$pfamAddress/Pfam-A.full.summarized.tab
	
rm -rf /dev/shm/*;

pfamTMPFolder=/dev/shm/PFAMAnnotation/
mkdir -p $pfamTMPFolder
cp $pfamAddress/Pfam-A.hmm* $pfamTMPFolder; hmmFileDB=$pfamTMPFolder/Pfam-A.hmm
#cp $hmmFileMetaData $pfamTMPFolder; hmmFileMetaData=$pfamTMPFolder/Pfam-A.dat.tab

cp $hmmFileMetaData $pfamTMPFolder; hmmFileMetaData=$pfamTMPFolder/Pfam-A.full.summarized.tab ;
tmpResult=$pfamTMPFolder/result.tmp
cmd="hmmscan --notextw --noali --cpu $numberOfCPUs --tblout $tmpResult $hmmFileDB  $QueryInputFile"; echo "$cmd"; eval "$cmd" > $pfamTMPFolder/tmp.result.xyz;


cmd="grep -v \"#\" $tmpResult   | awk '{printf \$3\"\t\"\$1\"\t\"\$2\"\t\"\$5\"\t\"\$6\"\t\" ;  for(i=19;i<=NF; i++) printf \$i\" \"; printf \"\n\"}'   | 
sort -k1,1 -k5,5nr  | 
awk -F\"\t\" 'BEGIN {print \"QueryGene\tPFAMShortName\tPFAMAccession\tEvalue\tScore\tDomainShortDescription\";} {if(FNR==1) {queryGene=\$1;  print \$0} else {if(queryGene!=\$1) {queryGene=\$1; print \$0} } }' > 
$tmpResult.tmp "

echo "$cmd"; eval "$cmd"

cmd="JoinTwoFilesBasedOnKeys.sh 2 3  $hmmFileMetaData $tmpResult.tmp | cut -f1,2,3,4,5,6,10 > $OutputFile;"; echo "$cmd"; eval "$cmd"


cmd="mv $pfamTMPFolder/tmp.result.xyz $workingDir;" ; echo "$cmd"; eval "$cmd";


rm -rf /dev/shm/*;



