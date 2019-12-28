
## To transform fasta-formated file into tabular form



time $(cat $1 | sed 's/%//g' | mawk -F"\n" '{if( index($1,">") > 0) {printf "\n"$1"\t"} else {printf $1}}' | 
mawk -F" " '{print substr($1,2,length($1))"\t"$0}' | awk '{print $0}'  > $2;)


