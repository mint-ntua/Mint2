package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.persistent.XpathStatsValues;
import gr.ntua.ivml.mint.persistent.XpathStatsValues.ValueStat;

import java.util.ArrayList;
import java.util.List;

public class XpathStatsValuesDAO extends DAO<XpathStatsValues, Long> {

	/**
	 * Get content / count pairs from this holder. First value is 0.
	 * @param holder
	 * @param start
	 * @param maxCount
	 * @return
	 */
	public List<XpathStatsValues.ValueStat> getValues( XpathHolder holder, long start, int maxCount ) {
		 List<XpathStatsValues> l = getSession().createSQLQuery("select * from xpath_stats_values where xpath_summary_id=:holder and start<:end and start+count>:start" )
		 .addEntity( XpathStatsValues.class )
		 .setEntity("holder", holder )
		 .setLong("end", start+maxCount)
		 .setLong("start", start )
		 .list();
		 ArrayList<ValueStat> res = new ArrayList<XpathStatsValues.ValueStat>();
		 for( XpathStatsValues vals: l ) {
			 long localStart = vals.getStart();
			 for( ValueStat vs: vals.getValueStats()) {
				 if(( start<=localStart) && (localStart<(start+maxCount)))
						 res.add( vs );
				 localStart++;
			 }
		 }
		 return res;
	}

	/**
	 * Get total number of unique values.
	 * @param holder
	 * @return
	 */
	public long getTotalUnique( XpathHolder holder ) {
		 List<XpathStatsValues> l = getSession().createSQLQuery("select * from xpath_stats_values where xpath_summary_id=:holder" )
		 .addEntity( XpathStatsValues.class )
		 .setEntity("holder", holder )
		 .list();
		 
		 long max = -1;
		 long total = 0;
		 
		 for( XpathStatsValues vals: l ) {
			 if(vals.getStart() > max) {
				 max = vals.getStart();
				 total = vals.getStart() + vals.getCount();
			 }
		 }
		 
		 return total;
	}
}
