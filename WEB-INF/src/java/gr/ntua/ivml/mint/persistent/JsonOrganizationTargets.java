package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.util.Tuple;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

/**
 * A JSON backed class for Meta table to deal with publication count targets for organizations.
 * @author Arne Stabenau 
 *
 */
public class JsonOrganizationTargets {
	public static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	public static final Logger log = Logger.getLogger( JsonOrganizationTargets.class );
	
	
	public static class TargetPeriod {
		TargetPeriod( Date start, Date end, int count ) {
			this.start = start;
			this.end = end;
			this.itemCount = count;
		}
		
		Date start, end;
		int itemCount;
	}
	
	JSONObject json;
	
	public  Tuple<Date,Integer> getTargetCountUntil( Date deadline ) {
		int resI = 0;
		Date resD = null;
		
		Iterator<TargetPeriod> i = getPeriods().iterator();
		while( i.hasNext()) {
			TargetPeriod tp = i.next();

			if( tp.end.before( deadline )) {
				if( tp.start != null ) 
					resI += tp.itemCount;
				else
					resI = tp.itemCount;
				resD = tp.end;
			} else {
				if( tp.start != null ) 
					resI += tp.itemCount;
				else
					resI = tp.itemCount;
				resD = tp.end;				
				break;
			}
		}
		
		return new Tuple<Date,Integer>( resD, resI );
	}
	
	public Tuple<Date,Integer> currentTarget() {
		Date now = new Date();
		return getTargetCountUntil( now );
	}
	
	
	
	/**
	 * Return the currently applicable period or null if none applies.
	 * @return
	 */
	public TargetPeriod currentPeriod() {
		List<TargetPeriod> src = getPeriods();
		Date now = new Date();
		
		TargetPeriod res = null;
		for( TargetPeriod tp: src ) {
			if( tp.end.after( now )) {
				res = tp;
				break;
			}
		}
		if( res != null ) {
			if( res.start != null ) 
				if( ! res.start.before( now ))
					res = null;
		}
		return res;
	}
	
	/**
	 * start in periods is always optional.
	 * If omitted, the item count is implied to be total. 
	 * 
	 * returns chronologically sorted (by end date)
	 * @return
	 */
	public List<TargetPeriod> getPeriods()  {
		ArrayList<TargetPeriod> res = new ArrayList<TargetPeriod>();
		for( Object period: json.getJSONArray("periods")) {
			// period is a json object
			JSONObject jo = (JSONObject) period;
			try {
				// deal with the last day, get the date to be the end of that day
				Calendar cal = GregorianCalendar.getInstance();
				cal.setTime(sdf.parse(jo.getString("end")));
				cal.set( cal.HOUR_OF_DAY, 23 );
				cal.set( cal.MINUTE, 59);
				cal.set(cal.SECOND, 59 );
				Date end = cal.getTime();
				TargetPeriod tp = new TargetPeriod(
					jo.has("start")
							?sdf.parse(jo.getString("start"))
							:null ,
					end,
					jo.getInt("count")
					);
			res.add( tp );
			} catch( Exception e ) {
				log.debug( "invalid Period", e );
			}
		}
		
		
		// sort them nicely
		Collections.sort( res, new Comparator<TargetPeriod>() {
			@Override
			public int compare(TargetPeriod o1, TargetPeriod o2) {
				if( o1.end.before(o2.end)) return -1;
				if( o2.end.before( o1.end )) return 1; 
				return 0;
			}
		});

		
		return res;
	}
	
	
	/**
	 * Add a period to the targets.
	 * @param start
	 * @param end
	 * @param count
	 */
	public void addPeriod( Date start, Date end, int count ) {
		JSONObject jo = new JSONObject();
		if( start != null )
			jo.element( "start", sdf.format(start));
		jo.element( "end", sdf.format( end ));
		jo.element( "count", count );
		JSONArray arr = json.optJSONArray("periods");
		if( arr == null ) arr = new JSONArray();;
		arr.add( jo );
		json.element( "periods", arr );
	}

	public JsonOrganizationTargets( ) {
		this.json = new JSONObject();
	}
	
	public JsonOrganizationTargets( String json) {
		this.json = JSONObject.fromObject( json );
	}
	
	public String toJson() {
		return json.toString();
	}
	
}
