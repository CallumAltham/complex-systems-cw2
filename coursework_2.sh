function main_loop(){
while :
do
	echo "------------------------------------------"
	echo "                Main Menu                 "
	echo "------------------------------------------"
	echo "1) Compute the number of reviews with a specified rating"
	echo "2) Compute the number of places in every price range ($/\$\$/\$\$\$)"
	echo "3) View all users with job 'IT Specialist'"
	echo "4) Compute the 20 most frequent phrases that appear in reviews with a specific rating"
	echo "5) Retrieve all places that have more than 3 reviews"
	echo "6) Retrieve all reviews that are written by 'IT Specialist' users"
	echo "7) Compute the number of places that are permanently closed and the number of places still operating"
	echo "8) Generate inverted document index based on reviews containing specified word"
	echo "9) Compute average rating for each category of reviews"
	echo "10) Find the top 5 categories with the highest average rating"
	echo "11) Compute the number of places still operating in all price ranges"
	echo "12) Compute the average price rating for all price ranges"
	echo "13) Compute the number of reviews for all price ranges"
	echo "14) Compute the average length of review in each rating"
	echo "15) Find place with largest number of reviews"

	
	read -p "Enter an option to run command (Enter -1 to quit): " user_option
	clear

	case $user_option in

		-1)
			break
		;;

		1)
			echo " "
			echo "=================================================="
			echo "	NUMBER OF PLACES BY PRICE RANGE			"
			echo "=================================================="
			echo " "
			read -p "Enter a rating to calculate number of reviews: " rating
			echo " "
			counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT COUNT(*) FROM reviews where rating=$rating;")
			echo "Number of reviews with rating $rating is $counter"
		;;

		2)
			echo " "
			echo "=================================================="
			echo "	NUMBER OF PLACES BY PRICE RANGE			"
			echo "=================================================="
			echo " "			

			low_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$'")
			mid_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$\\$'")
			high_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$\\$\\$'")

			echo "Price range $ contains $low_counter places"
			echo "Price range "'$$'" contains $mid_counter places"
			echo "Price range "'$$$'" contains $high_counter places"
		;;

		3)
			echo " "
			echo "=================================================="
			echo "	USERS WHO ARE IT SPECIALIST(S)			"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q "use googlelocal; SELECT * FROM users WHERE jobs='IT Specialist';"
		;;

		4)
			echo " "
			echo "=================================================="
			echo "	MOST FREQUENT PHRASES BY RATING			"
			echo "=================================================="
			echo " "
			read -p "Enter a rating to compute most frequent phrases: " rating
			./func4.sh $rating


		;;

		5)
			echo " "
			echo "=================================================="
			echo "	PLACES WITH MORE THAN 3 REVIEWS			"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q " use googlelocal; SELECT gPlusPlaceId AS 'Place ID', COUNT(*) AS 'Number of Reviews' FROM reviews GROUP BY gPlusPlaceId HAVING (COUNT(*)) > 3 ORDER BY COUNT(*) DESC;"
			
		;;

		6)
			echo " "
			echo "=================================================="
			echo "	REVIEWS MADE BY IT SPECIALISTS			"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q "use googlelocal; SELECT users.gPlusUserId, users.jobs, 
			reviews.reviewText FROM users LEFT JOIN reviews ON users.gPlusUserId=reviews.gPlusUserId WHERE users.jobs='IT Specialist';"
		;;

		7)
			echo " "
			echo "=================================================="
			echo "	NUMBER OF PLACES BY OPEN STATUS			"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q "use googlelocal; SELECT COUNT(*) AS 'Number of Places', closed AS 'Closed Status' FROM places GROUP BY closed;"

		;;

		8)
			clear
			echo " "
			echo "=================================================="
			echo "		INVERTED DOCUMENT INDEX			"
			echo "=================================================="
			echo " "
			read -p "Enter a word to search for: " searchWord
			echo " "
			spark-shell -i <(echo 'val searchterm = "'$searchWord'"' ; cat func8.scala) > func8out.txt
			clear
			echo " "
			echo "=================================================="
			echo "		INVERTED DOCUMENT INDEX			"
			echo "=================================================="
			echo " "
			echo "Enter a word to search for: " $searchWord
			consoleOutput=$( tail -2 func8out.txt)
			echo "$consoleOutput"
			rm derby.log
			rm func8out.txt
					
		;;

		9)
			echo " "
			echo "=================================================="
			echo "		AVERAGE RATING PER CATEGORY		"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q "use googlelocal; SELECT AVG(rating) AS 'Average Rating', categories as 'Category' FROM reviews GROUP BY categories LIMIT 15;"
		;;

		10)
			echo " "
			echo "=================================================="
			echo "		TOP 5 CATEGORIES			"
			echo "=================================================="
			echo " "
			impala-shell --quiet -q "use googlelocal; SELECT AVG(rating) AS 'Average Rating', categories AS 'Category' FROM reviews GROUP BY categories ORDER BY AVG(rating) DESC LIMIT 5;"

		;;

		11)
			echo " "
			echo "=================================================="
			echo "	NUMBER OF PLACES BY OPEN STATUS			"
			echo "=================================================="
			echo " "
			
			low_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$' AND closed=False")
			mid_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$\\$' AND closed=False")
			high_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT count(*) FROM places where price='$\\$\\$' AND closed=False")

			echo "Price range $ contains $low_counter open places"
			echo "Price range "'$$'" contains $mid_counter open places"
			echo "Price range "'$$$'" contains $high_counter open places"
		;;

		12)
			echo " "
			echo "=================================================="
			echo "	AVERAGE RATING FOR EACH PRICE RANGE		"
			echo "=================================================="
			echo " "
			
			low_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT AVG(rating) FROM reviews LEFT JOIN places on reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$';")
			mid_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT AVG(rating) FROM reviews LEFT JOIN places on reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$\\$';")
			high_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT AVG(rating) FROM reviews LEFT JOIN places on reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$\\$\\$';")

			echo "Price range $ has an average rating of $low_counter"
			echo "Price range "'$$'" has an average rating of $mid_counter"
			echo "Price range "'$$$'" has an average rating of $high_counter"

		;;

		13)
			echo " "
			echo "=================================================="
			echo "	NUMBER OF REVIEWS FOR EACH PRICE RANGE			"
			echo "=================================================="
			echo " "
			
			low_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT COUNT(*) FROM reviews LEFT JOIN places ON reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$';")
			mid_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT COUNT(*) FROM reviews LEFT JOIN places ON reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$\\$';")
			high_counter=$(impala-shell --quiet --delimited -q "use googlelocal; SELECT COUNT(*) FROM reviews LEFT JOIN places ON reviews.gPlusPlaceId=places.gPlusPlaceId WHERE price='$\\$\\$';")

			echo "Price range $ has $low_counter reviews"
			echo "Price range "'$$'" has $mid_counter reviews"
			echo "Price range "'$$$'" has $high_counter reviews"
		;;

		14)
			spark-shell -i func14.scala > func14output.txt
			clear
			echo " "
			echo "=================================================="
			echo "	AVERAGE CHARACTER LENGTH OF REVIEWS		"
			echo "=================================================="
			echo " "
			consoleOutput=$(tail -5 func14output.txt)
			echo "$consoleOutput"
			rm derby.log
			rm func14output.txt
			
		;;

		15)
			echo " "
			echo "=================================================="
			echo "	PLACE WITH THE MOST REVIEWS			"
			echo "=================================================="
			echo " "
			
			impala-shell --quiet -q "use googlelocal; SELECT COUNT(*) AS 'Number of Reviews',
			places.gPlusPlaceId, places.name FROM reviews LEFT JOIN places 
			ON reviews.gPlusPlaceId=places.gPlusPlaceId GROUP BY places.gPlusPlaceId,
			places.name HAVING places.name != 'NULL'  ORDER BY COUNT(*) DESC LIMIT 1;"
		;;

		*)
			echo "Command entered is not a correct command"
			echo " "
			

	esac

	read -p "Do you want to continue? (1=yes, 0=no): " continue_option
	clear

	if [ $continue_option -eq 0 ]; then
		break
	fi
done
}
main_loop


