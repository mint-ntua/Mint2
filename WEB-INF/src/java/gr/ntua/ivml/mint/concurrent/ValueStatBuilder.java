package gr.ntua.ivml.mint.concurrent;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.persistent.XpathStatsValues;
import gr.ntua.ivml.mint.persistent.XpathStatsValues.ValueStat;
import gr.ntua.ivml.mint.util.Counter;
import gr.ntua.ivml.mint.util.ExternalSort;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.TabbedStringComparator;
import gr.ntua.ivml.mint.util.TabbedStringComparator.Sorter;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map.Entry;

import org.apache.commons.io.IOUtils;
import org.apache.commons.io.LineIterator;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import de.schlichtherle.io.FileInputStream;


public class ValueStatBuilder {
	private static final Logger log = Logger.getLogger( ValueStatBuilder.class );
	
	private int MAXSIZE = 200000;
	private XpathHolder holder;
	
	private int size;
	private File tmpFile = null;
	private final HashMap< String, Counter> valuemap = new HashMap<String, Counter>();
	private XpathStatsValues currentStatsValues = null;
	private long currentValueStatCount = 0l;
	
	
	public long totalCount, distinctCount, charCount;
	
	public ValueStatBuilder(XpathHolder holder ) {
		this.holder = holder;
	}
	
	public void add( String value ) throws Exception {
		Counter c = valuemap.get( value );
		if( c == null ) {
			valuemap.put( value, new Counter());
			size += value.length();
			
			if( size > MAXSIZE ) toFile();
		} else {
			c.inc();
		}
	}
	
	/**
	 * Reflects total size, not in memory size 
	 * @return
	 */
	public int getSize() {
		if( tmpFile != null ) return (int)tmpFile.length()+size;
		return size;
	}
	
	/**
	 * Write the hash to the tmpfile and empty it
	 */
	private void toFile() throws Exception {
		if( tmpFile == null ) {
			tmpFile= File.createTempFile("Values_"+holder.getDbID(), ".txt" );
		}
		
		FileOutputStream fos = new FileOutputStream(tmpFile, true );
		BufferedOutputStream bos = new BufferedOutputStream(fos);
		PrintWriter w = new PrintWriter( new OutputStreamWriter(bos, "UTF-8" ));
		for( Entry<String, Counter> e: valuemap.entrySet() ) {
			w.print( e.getValue().get() );
			w.print( "\t" );
			w.println( StringEscapeUtils.escapeJava(e.getKey()));
		}
		w.flush();
		
		// not sure if they all need closing :-)
		w.close(); bos.close(); fos.close();
		
		size = 0;
		valuemap.clear();
	}
	
	/**
	 * Sorts the output file so records can be read directly into database.
	 * @throws Exception
	 */
	private void collectAndSort() throws Exception  {

		log.info( "Sorting file " + tmpFile.getName() + " Size: " + StringUtils.humanNumber(tmpFile.length()));
		
		// sort so that equal values are on top of each other
		long totalMem = Runtime.getRuntime().maxMemory() + Runtime.getRuntime().freeMemory() - Runtime.getRuntime().totalMemory();
		ExternalSort es = new ExternalSort(totalMem / 3);
		File sortedData = File.createTempFile("Sorted_" + holder.getDbID(), ".txt");
		TabbedStringComparator comp = new TabbedStringComparator();
		Sorter valueSorter = comp.addKey(1, false, false);
		Sorter countSorter = comp.addKey( 0, true, true );
		
		es.sort( tmpFile, sortedData, comp );

		// prepare for collecting
		tmpFile.delete();
		tmpFile = File.createTempFile("Collected_"+holder.getDbID(), ".txt");
		PrintWriter pw = new PrintWriter(
			new OutputStreamWriter(
			new BufferedOutputStream(
			new FileOutputStream(tmpFile)), "UTF-8"));
		LineIterator lineIt = null;
		String lastVal = "";
		String currentVal = null;
		int lastCount = -1;
		int currentCount = -1;
		
		// collect into tmpfile
		try {
			lineIt = IOUtils.lineIterator(new FileInputStream(sortedData), "UTF-8");
			while (lineIt.hasNext()) {
				String line = lineIt.nextLine();
				/// do something with line
				currentVal = valueSorter.extract(line);
				currentCount = Integer.parseInt(countSorter.extract(line));
				
				if( !currentVal.equals(lastVal )) {
					if( lastCount > 0 )
						pw.println( lastCount+"\t"+lastVal);
					lastVal = currentVal;
					lastCount = currentCount;
				} else {
					lastCount += currentCount;
				}
			}
			pw.println( lastCount+"\t"+lastVal);
		} finally {
			LineIterator.closeQuietly(lineIt);
			IOUtils.closeQuietly(pw);
		}

		// and another sort
		
		sortedData.delete();
		sortedData = File.createTempFile("Sorted_" + holder.getDbID(), ".txt");
		comp = new TabbedStringComparator();
		// numeric descending on column 0
		comp.addKey( 0, true, true );
		// alphabetic ascending on column 1
		comp.addKey(1, false, false);
		
		totalMem = Runtime.getRuntime().maxMemory() + Runtime.getRuntime().freeMemory() - Runtime.getRuntime().totalMemory();
		es = new ExternalSort(totalMem / 3);
		es.sort( tmpFile, sortedData, comp);
		tmpFile.delete();
		tmpFile= sortedData;
	}
	/**
	 * processes the file and writes the result to db
	 */
	private void writeFromFile() throws Exception {
		toFile();
		collectAndSort();
		
		TabbedStringComparator comp = new TabbedStringComparator();

		Sorter valueSorter = comp.addKey(1, false, false);
		Sorter countSorter = comp.addKey( 0, true, true );

		long length = 0;
		boolean unique = true;
		
		LineIterator lineIt = null;
		try {
			lineIt = IOUtils.lineIterator(new FileInputStream(tmpFile), "UTF-8");
			while (lineIt.hasNext()) {
				String line = lineIt.nextLine();
				distinctCount++;
				String val = StringEscapeUtils.unescapeJava( valueSorter.extract(line));
				int count = Integer.parseInt(countSorter.extract(line));
				if( count > 1 ) unique=false;
				length += count*val.length();
				totalCount += count;
				charCount += val.length();
				serializeValueStat( new ValueStat( val, count ));
				
			}
			holder.setUnique(unique);
			holder.setAvgLength((float)length/totalCount);
			holder.setCount(totalCount);
			holder.setDistinctCount(distinctCount);
			currentStatsValues = DB.getXpathStatsValuesDAO().makePersistent(currentStatsValues);
			DB.getSession().flush();
			DB.getSession().evict(currentStatsValues);
		} finally {
			LineIterator.closeQuietly(lineIt);
		}
	}
	
	public void finalize() {
		if( tmpFile != null ) tmpFile.delete();
	}
	
	private void serializeValueStat( ValueStat val ) {
		if( currentStatsValues == null ) {
			currentStatsValues = new XpathStatsValues();
			currentStatsValues.setDataset(holder.getDataset());
			currentStatsValues.setHolder(holder);
			currentStatsValues.setStart(currentValueStatCount);
		}
		currentStatsValues.add( val.value, val.count);
		currentValueStatCount++;
		
		if( currentStatsValues.getSize() > 6000 ) {
			currentStatsValues = DB.getXpathStatsValuesDAO().makePersistent(currentStatsValues);
			DB.getSession().flush();
			DB.getSession().evict(currentStatsValues);
			currentStatsValues = null;
		}
	}
	
 	/**
	 * Write the contents to the DB.
	 */
	public void write() {
		try {
			if( tmpFile!= null) writeFromFile();
			else {
				holder.setUnique(true);
				long length = 0;
				long count = 0;
				ArrayList<XpathStatsValues.ValueStat> vals = new ArrayList<XpathStatsValues.ValueStat>();
				for( Entry<String, Counter> e: valuemap.entrySet()) {
					if( e.getValue().get() > 1 ) holder.setUnique(false);
					count += e.getValue().get();
					length += ( (long) e.getKey().length() * (long) e.getValue().get());
					vals.add( new ValueStat(e.getKey(), e.getValue().get()));
				}
				holder.setAvgLength((float)length/count);
				holder.setCount(count);
				holder.setDistinctCount(valuemap.size());


				// first high counts .. inside same count alphabetically
				Collections.sort( vals, new Comparator<ValueStat>() {
					public int compare(ValueStat o1, ValueStat o2) {
						if( o1.count > o2.count ) return -1;
						if( o1.count < o2.count ) return 1;
						return o1.value.compareTo(o2.value );
					}				
				});

				for( ValueStat val: vals) {
					serializeValueStat( val );
					totalCount += val.count;
					charCount += val.value.length();
					distinctCount ++;
				}
				if( currentStatsValues != null ) {
					// TODO: store the last values
					currentStatsValues = DB.getXpathStatsValuesDAO().makePersistent(currentStatsValues);
					DB.getSession().flush();
					DB.getSession().evict(currentStatsValues);
					log.debug( currentStatsValues.toString());
				}
			}
		} catch( Exception e ) {
			log.error( "ValueStatsFailure", e );
		}
		finally {
			if( tmpFile != null ) tmpFile.delete();
		}
	}
}