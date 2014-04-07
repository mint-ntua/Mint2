package gr.ntua.ivml.mint.persistent;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;

import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.log4j.Logger;

public class XpathStatsValues {
	private static final Logger log = Logger.getLogger(XpathStatsValues.class);
	
	private Long dbID;
	
	private Dataset dataset;
	private XpathHolder holder;
	private long start;
	private int count;
	
	private byte[] gzippedValues;
	
	// transient, not stored in database
	private int characterCount = 0;
	private ArrayList<ValueStat> valueStats = null;
	
	public static class ValueStat implements Serializable {
		public String value;
		public int count;
		public ValueStat( String value, int count ) {
			this.value = value;
			this.count = count;
		}
	}

	
	public void add( String value, int count ) {
		if( valueStats == null ) valueStats = new ArrayList<XpathStatsValues.ValueStat>();
		valueStats.add( new ValueStat( value, count ));
		characterCount+=value.length();
		this.count++;
	}
	
	/**
	 * How many characters are in here already?
	 * @return
	 */
	public int getSize() {
		return characterCount;
	}
	
	public ArrayList<ValueStat> getValueStats() {
		if(( valueStats == null ) && (gzippedValues != null)) {
			try {
				ByteArrayInputStream bis = new ByteArrayInputStream(gzippedValues);
				GzipCompressorInputStream gz = new GzipCompressorInputStream(bis);

				ObjectInputStream ois = new ObjectInputStream( gz );
				valueStats = (ArrayList<ValueStat>) ois.readObject();
				ois.close();
			} catch( Exception e ) {
				log.error( "Couldnt unserialize values",e );
			}
		}
		return valueStats;
	}
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append( "Dataset: " + dataset.getName() + "\n" );
		sb.append( "Path: " + holder.getXpath() + "\n" );
		for( ValueStat vs: getValueStats()) {
			sb.append( vs.count + "x \"" + vs.value +"\"\n" );
		}
		return sb.toString();
	}
	//
	// Hibernate getter setters
	//
	
	public Long getDbID() {
		return dbID;
	}


	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}


	public Dataset getDataset() {
		return dataset;
	}


	public void setDataset(Dataset dataset) {
		this.dataset = dataset;
	}


	public XpathHolder getHolder() {
		return holder;
	}


	public void setHolder(XpathHolder holder) {
		this.holder = holder;
	}


	public long getStart() {
		return start;
	}


	public void setStart(long start) {
		this.start = start;
	}


	public int getCount() {
		return count;
	}


	public void setCount(int count) {
		this.count = count;
	}


	public byte[] getGzippedValues() {
		if(( gzippedValues == null ) && ( valueStats != null )) {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();

			try {
				GzipCompressorOutputStream gz = new GzipCompressorOutputStream(bos);
				ObjectOutputStream oos = new ObjectOutputStream( gz );
				oos.writeObject(valueStats);
				oos.close();
			} catch( Exception e ) {
				log.error( "Serializing went wrong", e );
			}
			gzippedValues =  bos.toByteArray();
		}
		return gzippedValues;
	}


	public void setGzippedValues(byte[] gzippedValues) {
		this.gzippedValues = gzippedValues;
	}
	
}
