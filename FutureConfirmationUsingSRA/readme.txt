
This folder includes all the scripts needed for confirming the exitance of ARGs in predicted host
as well as the confirmation that MGE and ARGs both found on the same contigs within 10 kb from each other.



### 


BlastnAgainstSequenceReadArchive.sh All.AntibioticResistance.fa SRR9212196 /dev/shm/ResultFolder


## assemble SRA genome

AssembleGenomesFromSRAUsingSPAdes.sh SRR9212196 /dev/shm/ResultFolder/Assembly-SRR9212196

## map both MGE & ARG
