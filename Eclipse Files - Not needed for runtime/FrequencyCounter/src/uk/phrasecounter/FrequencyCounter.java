package uk.phrasecounter;
import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.fs.Path;

public class FrequencyCounter {
	
	public static class Map extends Mapper<LongWritable, Text, Text, IntWritable>{
		public void map(LongWritable inputKey, Text inputValue, Context context) throws IOException, InterruptedException{
			String inputSentence = inputValue.toString();
			inputSentence = inputSentence.replaceAll("\\p{Punct}","").replaceAll("[0123456789]","").toLowerCase();
			
			StringTokenizer tokenizer = new StringTokenizer(inputSentence);
			
			String threeWords = "";
			int length = 0;
			
			while(tokenizer.hasMoreTokens())
			{
				if(threeWords != "")
				{
					length = (threeWords.split(" ").length);
				}
				
				if(length == 2)
				{
					threeWords += tokenizer.nextToken();
					Text outputKey = new Text(threeWords);
					IntWritable outputValue = new IntWritable(1);
					context.write(outputKey, outputValue);
					threeWords = "";
					length = 0;
				}else if(length < 2)
				{
					threeWords += tokenizer.nextToken() + " ";
				}
			}
		}

	}
	
	public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable>{
		public void reduce(Text inputKey, Iterable<IntWritable> inputListOfValues, Context context) throws IOException, InterruptedException{
			int frequencyOfPhrase = 0;
			
			for (IntWritable x: inputListOfValues)
			{
				frequencyOfPhrase += x.get();
			}
			
			Text outputKey = inputKey;
			IntWritable outputValue = new IntWritable(frequencyOfPhrase);
			context.write(outputKey, outputValue);
		}
	}
	
	public static void main(String[] args) throws Exception{
		Configuration conf = new Configuration();
		
		Job job = new Job(conf, "mywc");
		job.setJarByClass(FrequencyCounter.class);
		job.setMapperClass(Map.class);
		job.setReducerClass(Reduce.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		job.setInputFormatClass(TextInputFormat.class);
		job.setOutputFormatClass(TextOutputFormat.class);
		
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}

}
