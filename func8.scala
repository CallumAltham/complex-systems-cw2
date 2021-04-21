sqlContext.sql("use googlelocal");

val mainDF = sqlContext.sql(s"""SELECT gPlusPlaceId, gPlusUserId FROM reviews WHERE reviewText LIKE '%$searchterm%'""");
val details = mainDF.rdd.collect();

var main_string = "";
var counter = 0;
val length = details.length - 1

for (record <- details)
{
	
	val rec = record.toString;
	val recordSub = (rec.substring(1, rec.length()-1)).split(",");
	if (counter != length)
	{
		val out = recordSub(0) + "_" + recordSub(1) + "||";
		main_string = main_string + out
	}else
	{
		val out = recordSub(0) + "_" + recordSub(1);
		main_string = main_string + out
	}

	counter = counter + 1
}

println(searchterm + " \n" + main_string)
sys.exit;
