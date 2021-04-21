sqlContext.sql("use googlelocal");

val mainDF = sqlContext.sql("SELECT * FROM reviews");

val ratingOne = mainDF.filter("rating = 1").select("reviewtext");
val ratingTwo = mainDF.filter("rating = 2").select("reviewtext");
val ratingThree = mainDF.filter("rating = 3").select("reviewtext");
val ratingFour = mainDF.filter("rating = 4").select("reviewtext");
val ratingFive = mainDF.filter("rating = 5").select("reviewtext");

val onecounter = ratingOne.count();
var onetotal = 0.0;

val twocounter = ratingTwo.count();
var twototal = 0.0;

val threecounter = ratingThree.count();
var threetotal = 0.0;

val fourcounter = ratingFour.count();
var fourtotal = 0.0;

val fivecounter = ratingFive.count();
var fivetotal = 0.0;


val rOneList = ratingOne.rdd.collect()
val rTwoList = ratingTwo.rdd.collect()
val rThreeList = ratingThree.rdd.collect()
val rFourList = ratingFour.rdd.collect()
val rFiveList = ratingFive.rdd.collect()

for (reviewItem <- rOneList)
{
	val rv = reviewItem.toString;
	val review = (rv.substring(1, rv.length()-1));
	val length = review.length();
	onetotal += length;
}

for (reviewItem <- rTwoList)
{
	val rv = reviewItem.toString;
	val review = (rv.substring(1, rv.length()-1));
	val length = review.length();
	twototal += length;
}

for (reviewItem <- rThreeList)
{
	val rv = reviewItem.toString;
	val review = (rv.substring(1, rv.length()-1));
	val length = review.length();
	threetotal += length;
}

for (reviewItem <- rFourList)
{
	val rv = reviewItem.toString;
	val review = (rv.substring(1, rv.length()-1));
	val length = review.length();
	fourtotal += length;
}

for (reviewItem <- rFiveList)
{
	val rv = reviewItem.toString;
	val review = (rv.substring(1, rv.length()-1));
	val length = review.length();
	fivetotal += length;
}

println(" ")
println(" ")
println("Reviews with rating 1.0 have an average length of: " + BigDecimal(onetotal / onecounter).setScale(2, BigDecimal.RoundingMode.HALF_UP) + " characters");
println("Reviews with rating 2.0 have an average length of: " + BigDecimal(twototal / twocounter).setScale(2, BigDecimal.RoundingMode.HALF_UP) + " characters");
println("Reviews with rating 3.0 have an average length of: " + BigDecimal(threetotal / threecounter).setScale(2, BigDecimal.RoundingMode.HALF_UP) + " characters");
println("Reviews with rating 4.0 have an average length of: " + BigDecimal(fourtotal / fourcounter).setScale(2, BigDecimal.RoundingMode.HALF_UP) + " characters");
println("Reviews with rating 5.0 have an average length of: " + BigDecimal(fivetotal / fivecounter).setScale(2, BigDecimal.RoundingMode.HALF_UP) + " characters");
sys.exit;
