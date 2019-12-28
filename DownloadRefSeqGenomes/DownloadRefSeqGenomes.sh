

## requirement 
##  at least 1 terabyte disk space


## get all the species available at refSeq Genomes
refSeqGenomes=ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/

wget $refSeqGenomes



genomeMainDir=$(pwd)

## get all species 
awk -F'href="'  '{if(NF>1) print $2}' index.html | awk -F'">'  '{ if(NF>1) print $1}' |  
awk -F"\t" '{f=split($0,a,"/"); 
print  "mkdir "a[f-1]"; cd "a[f-1]"; wget "$1"/latest_assembly_versions/"}' > All.jobs.species

## create folder for each species and do that in parallel (20 species a time)
../Scripts/MachineManagerBashScript.1.sh All.jobs.species 20 &> All.species.folder.creation.log



## writing script to download all the genomes for all species

time find */ -type f -name "index.html" | xargs cat  | grep "href="    | 
awk -F'href="'  '{if(NF>1) print $2}'   | 
awk -F'">'  '{print $1}' |  awk -F"/" '{print $NF"\t"$(NF-3)"\t"$0}' | 
while read genomeID species file; do 
speciesFolder="$(pwd)/$species"; 
echo "genomeFolder=/dev/shm/$genomeID; 
mkdir \$genomeFolder; cd \$genomeFolder; 
wget $file/*; 
cd $speciesFolder; 
rm -rf $speciesFolder/$genomeID; \
mv -f \$genomeFolder $speciesFolder; sleep 3s;  ";   
done  > All.genome.downloads.jobs


MachineManagerBashScript.1.sh All.genome.downloads.jobs 5 &> All.download.genaomes.tasks.log


sleep 1m



