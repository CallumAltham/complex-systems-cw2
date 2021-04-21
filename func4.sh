rating=$1
impala-shell --delimited --quiet --output_file reviewtext.txt -q "use googlelocal; SELECT reviewText FROM reviews where rating=$rating AND reviewText !='None';"

hdfs dfs -put reviewtext.txt
hadoop jar FrequencyCounter.jar uk.phrasecounter.FrequencyCounter reviewtext.txt output_folder
hdfs dfs -cat output_folder/part-r-00000 | sort -n -k4 -r > part-r-00000_sorted

hdfs dfs -rm reviewtext.txt
hdfs dfs -rm -r output_folder
rm reviewtext.txt

clear
echo " "
echo "=================================================="
echo "	MOST FREQUENT PHRASES WITH RATING $rating	"
echo "=================================================="
echo " "
head -20 part-r-00000_sorted
rm part-r-00000_sorted


