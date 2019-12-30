
#!/bin/bash
## this annotate a give DNA Fsta files with pfam 
DNAFastaFile=$1


$scripts/translateDNAToProtein.sh $DNAFastaFile $DNAFastaFile.prot.fa
time pfamcommand -fasta $DNAFastaFile.prot.fa -outfile $DNAFastaFile.prot.fa.pfam


$scripts/pfamAnnotation.sh $DNAFastaFile.prot.fa.pfam $resultfile

#/bin/bash
## this annotate outputfile of the pfam
## given outputfile form pfam annotation
## you need to limit it to two columns the pfamfamily and the query.
shopt -s expand_aliases
source ~/MachineConfigurationFile.sh

if(( ${#1} > 1 )) ; then 
	pfamOutputfile=$1
else 
	echo "you should insert pfam output file"
        exit -1	
fi
if(( ${#2} > 1 )) ; then 
	resultfile=$2;
else
	echo "please check the file: $pfamOutputfile.final " ;
	resultfile=$pfamOutputfile.final
fi

awk '{if(FNR>29) print $7"\t"$1}' $pfamOutputfile > $pfamOutputfile.tmp


$scripts/addEmptyTitle.sh $pfamOutputfile.tmp

#source ~/.bashrc

$scripts/JoinTwoFiles.sh $pfamDescription  $pfamOutputfile.tmp | awk -F"\t" '{print $2"\t"$1"\t"$4"\t"$5"\t"$NF}' > $resultfile
echo $pfamDescription
