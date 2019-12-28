## To transform fasta-formated file into tabular form


#echo "time $(awk -F\"\n\" {'if( index($1,\"\>\") > 0) {printf \"\n\"$1\"\t\"} else {printf $1}'} $1 > $2)"
time $(cat $1 | sed 's/%//g' | awk -F"\n" '{if( index($1,">") > 0) {printf "\n"$1"\t"} else {printf $1}}' > $2)
