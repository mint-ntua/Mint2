package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.Activity;

import java.io.ByteArrayInputStream;
import java.io.ObjectInputStream;
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.StatelessSession;
import org.hibernate.Transaction;

public class ActivityManager {
	static final Logger log = Logger.getLogger( ActivityManager.class );
	
	static List<Activity> currentActivities = new ArrayList<Activity>();
	
	public static StatelessSession getSession() {
		return DB.getStatelessSession();
	}
	
	/**
	 * Start and safe this activity so it can be cleanup up if need be.
	 * @param a
	 */
	public static void storeActivity( Activity a ) {
		StatelessSession s = getSession();
		Transaction tx = s.beginTransaction();
		try {
			List<?> l = s.createSQLQuery("insert into activity" + 
					"( activity_id, class_name, serial, description, created ) "
					+ "values(nextval('seq_activity_id'), :class, :bytes, :desc, :date) returning currval( 'seq_activity_id')")
			.setString( "class", a.getClassName())
			.setBinary("bytes", a.getSerial())
			.setString( "desc", a.getDescription())
			.setDate("date", a.getCreated())
			.list();
			a.setDbID(((BigInteger)l.get(0)).longValue());
			tx.commit();
		} catch( Exception e ) {
			log.error( "Error writing Activity", e  );
			tx.rollback();
		}
		currentActivities.add(a);
	}
	
	/**
	 * Remove the activity after it has finished operation. Activities do that once they finished the run.
	 * @param a
	 */
	public static void removeActivity( Activity a ) {
		StatelessSession s = getSession();
		Transaction tx = s.beginTransaction();
		try {
			s.createSQLQuery( "delete from activity where activity_id = :id")
			.setLong("id", a.getDbID())
			.executeUpdate();
			tx.commit();
		} catch( Exception e ) {
			log.error( "Error deleting Activity",e  );
			tx.rollback();
		}
		currentActivities.remove(a);
	}
	
	
	/**
	 * A list of all activities currently in the database. Usually these are the ones running.
	 * On restart, those have to be cleaned up. During operation they should reflect whats in
	 * the ActivityManager anyway.
	 * @return
	 */
	public static List<Activity> findAll() {
		List<Activity> result = new ArrayList<Activity>();
		Connection c = getSession().connection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			ps = c.prepareStatement("select serial from activity" );
			rs = ps.executeQuery();
			while( rs.next()) {
				byte[] serial = rs.getBytes("serial" );
				ByteArrayInputStream bis = new ByteArrayInputStream(serial);
				ObjectInputStream ois = new ObjectInputStream( bis );
				Activity a = (Activity) ois.readObject();
				result.add( a );
			}
		} catch( Exception e ) {
			log.error( "Problem with reading activities.", e );
		} finally {
			try {if( rs != null) rs.close();} catch( Exception e2 ) {}
			try {if( ps != null ) ps.close();} catch( Exception e2) {}
		}
		return result;
	}

}
