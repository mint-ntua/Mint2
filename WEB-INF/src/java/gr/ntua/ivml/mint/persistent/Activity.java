package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.db.ActivityManager;
import gr.ntua.ivml.mint.db.DB;

import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * An activity is something happening to a dataset. Its started from the UI or from another
 * Activity. It logs the fact that it started in the Activity table. A finished activity (failed or ok)
 * is removed from the table. On restart, any activities on the table have to perform their cleanup routine.
 *  
 * Activities should contain their dependencies as Values where practical. Database object references should be held
 * as ids or transient.
 * 
 * Activities go through defined phases.
 * 
 *  - create the object
 *  - create it in the database
 *  - aquires all locks necessary
 *  - queues or executes directly
 *  - on run 
 *  
 * @author Arne Stabenau 
 *
 */
public class Activity implements Runnable, Serializable  {
	transient public Logger log = Logger.getLogger( this.getClass());
	
	// is transient. If next Activity is not started, you don't need to recreate it
	// to clean up.
	transient Activity nextActivity;

	Date created = new Date();
	
	List<Integer> lockIds = new ArrayList<Integer>();
	Long dbID;
	
	/**
	 * Database sessions are closed after activity.
	 */
	public void run() {
		try {
			activity();
		} finally {
			releaseLocks();
			// now we won't forget that any more :-)
			DB.closeSession();
			DB.closeStatelessSession();
			ActivityManager.removeActivity(this);
		}
		if( nextActivity != null ) nextActivity.start(); 
	}
	
	
	/**
	 * Overwrite just this one for standard activity behaviour.
	 * Deal with Exceptions yourself. 
	 */
	public void activity() {
		// do nothing
	}
	/**
	 * Start all activities with start. Don't override this, its the lifecycle of an Activity.
	 */
	public void start() {
		try {
			ActivityManager.storeActivity( this );
			if( aquireLocks() ) {
				if( getQueueName() == null ) run();
				else Queues.queue( this, getQueueName() );
			} else {
				releaseLocks();
			}
		} catch( Exception e ) {
			log.error( "Activity lifecycle problem" ,e );
		}
	}
	
	/**
	 * If you need Locks, aquire them in this function and return true
	 * if you get what you want, other wise return false.
	 * @return
	 */
	public boolean aquireLocks() {
		// aquire all necessary locks
		// put the ids into lockIds list
		return true;
	}
	
	/**
	 * Releases all lock from the list.
	 */
	public void releaseLocks() {
		
	}
	
	
	/**
	 * If you want the activity queued return the queue name here,
	 * otherwise return null;
	 * @return
	 */
	public String getQueueName() {
		return null;
	}
	/**
	 * Overwrite with any cleanup behaviour. Cleanup occurs when Application is restarted and Activities have 
	 * left DB entries. During normal operation Activities cleanup after themselves!!
	 * Of course they can use the same cleanUp() method for that.
	 */
	public void cleanUp() {
		
	}
	
	/**
	 * Create a series of activities that are performed one after the other.
	 * 
	 * @param activities
	 * @return
	 */
	public static Activity serializeActivities( List<Activity> activities ) {
		Activity first, last;
		if( activities == null || activities.size() == 0 ) return null;
		first = activities.get(0); last = first;
		for( int i = 1; i< activities.size(); i++ ) {
			last.nextActivity = activities.get(i);
			last = last.nextActivity;
		}
		return first;
	}
	


	//
	// Boilerplate getter setter 
	//
	
	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public Long getDbID() {
		return dbID;
	}

	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}

	public byte[] getSerial() {
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(bos );
			oos.writeObject(this);
		} catch( Exception e ) {
			log.error( "Serializing Activity went wrong", e );
		}
		return bos.toByteArray();
	}
		
	public String getDescription() {
		return "General Activity description, overwrite";
	}

	public String getClassName() {
		return getClass().getCanonicalName();
	}
}
