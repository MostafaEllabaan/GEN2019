#This file to convert dna to protein seqs

if(( ${#1} > 1 )) ; then 
	inputDNAFastafile=$1
else 
	echo "No thing to translate"
	quit
fi

if(( ${#2} > 1 )) ; then 
	outputProteinFastaFile=$2;
else
	echo "please check the file: $inputDNAFastafile.prot.fa " ;
	outputProteinFastaFile=$inputDNAFastafile.prot.fa 
fi


$EMBOSSEXE/transeq -frame 6 $inputDNAFastafile -outseq $outputProteinFastaFile 



