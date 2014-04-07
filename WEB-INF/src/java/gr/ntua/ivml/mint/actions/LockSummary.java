
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.LockManager;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.User;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import java.util.ArrayList;
import java.util.List;

@Results({
	  @Result(name="input", location="locksummary.jsp"),
	  @Result(name="error", location="locksummary.jsp"),
	  @Result(name="success", location="locksummary.jsp" )
	})

public class LockSummary extends GeneralAction {
	  
	  protected final Logger log = Logger.getLogger(getClass());
	  private List<Lock> locks;

	
	private List<Lock> filterForMapping( List<Lock> inLocks ) {
		List<Lock> outLocks = new ArrayList<Lock>();
		for( Lock l: inLocks ) {
			if( l.getObjectType().endsWith("Mapping"))
				outLocks.add(l);
		}
		return outLocks;
	}
	
	public List<Lock> getLocks() {
		List<Lock> tmpLocks;
		if( user.hasRight(User.SUPER_USER)) {
			// get all the Mapping locks
			tmpLocks = DB.getLockManager().findAll();
		} else {
			// just for this user
			tmpLocks = DB.getLockManager().findByUser(user);
		}
		return tmpLocks;
	}
	
	
	public List<Lock> getMappingLocks() {
		List<Lock> tmpLocks = getLocks();
		
		tmpLocks = filterForMapping(tmpLocks);		
		return tmpLocks;
	}
	
	public void setLockDeletes(String lockIds){
		locks=new ArrayList<Lock>();
		if(lockIds.trim().length()>0){
			String[] chstr=lockIds.split(",");			
			for( String num: chstr ) {
				try {
				 Lock l=DB.getLockManager().getByDbID(Long.parseLong(num));
				 locks.add(l);
				} catch( Exception e ) {
					log.error( "Not a lock " + num,  e);
				}
			}
		}
	}
	
	
	@Action(value="LockSummary")
    public String execute() throws Exception {
		if( locks != null ) {
			// delete given locks if you can
			for( Lock l: locks ) {
				if( user.hasRight(User.SUPER_USER))
					DB.getLockManager().releaseLock(l);
				else {
					if( l.getUserLogin().equals( user.getLogin()))
						DB.getLockManager().releaseLock(l);
				}
			}
		}
	    return SUCCESS;
    }	
}