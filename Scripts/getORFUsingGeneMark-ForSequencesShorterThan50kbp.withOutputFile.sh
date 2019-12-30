
InputFile=$1
OutputFile=$2

## gmsuite= the address of the folder where genemarks is installed.


##Annotate Using genemarks	
$gmsuite/gmhmmp -m  $gmsuite/heu_11.mod -d $InputFile -o $OutputFile.tmp

awk '{if(FNR==1) flg=0; if(index($0,"Model information:")>0) flg=0; if(flg==1) if(length($0)>=1 )  { if (NF>1) print $1"\t"$2; else print $0 } ; if (index($0,"Nucleotide sequence of predicted genes")>0) flg=1; }
'    $OutputFile.tmp | sed 's/\t>/__/g' >  $OutputFile
