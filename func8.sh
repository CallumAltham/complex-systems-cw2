searchWord=$1
out=$(impala-shell --quiet --delimited -q "SELECT gPlusPlaceId, gPlusUserId FROM reviews WHERE reviewText LIKE '%$searchWord%';")
item_array=($out)
index_string=""
counter=0
for i in "${item_array[@]}"
do
	out=""
	modval=$[$counter%2]
	if [ $modval -eq 0 ]; then
		out+="${i}"
		out+="_"
	elif [ $modval -eq 1 ]; then
		if [ $counter -ne $[${#item_array[@]}-1] ]; then
			out+="${i}"
			out+="||"
		else
			out+="${i}"
		fi
	fi
	index_string+="${out}"
	counter=$[counter + 1]
done
if [ "$index_string" != "" ]; then
	echo $searchWord
	echo $index_string
else
	echo "No results found for the search query $searchWord"
fi
