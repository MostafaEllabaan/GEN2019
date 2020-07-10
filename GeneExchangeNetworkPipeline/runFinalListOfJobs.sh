jobFile=$1
while read command; do 	echo "$command"; eval $command; done < $jobFile