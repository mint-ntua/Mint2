package gr.ntua.ivml.mint.test;
import groovy.util.GroovyTestCase

import gr.ntua.ivml.mint.actions.LockSummary
import gr.ntua.ivml.mint.db.DB

class LockSummaryAction extends GroovyTestCase {
	public void testSome() {
		def user = DB.userDAO.simpleGet("login='oschm'")
		assert user!=null
		// make a lock
		// get a Mapping to lock
		def mappings = DB.mappingDAO.findAll()
		assert mappings.size() > 0
		def mapping = mappings.get(0)
		
		def lock = DB.lockManager.directLock( user, "sessionId", mapping )
		assert lock != null
		
		def lockAction = new LockSummary()
		lockAction.setUser(user)
		assert lockAction.getMappingLocks().size() > 0
		
		def admin = DB.userDAO.simpleGet("login='admin'")
		assert admin != null
		
		lockAction.setUser( admin )
		def locks = lockAction.getMappingLocks()
		assert  locks.size() > 0
		
		String allLockIds = locks.collect{ it.dbID }.join( "," )
		println "Locks: '$allLockIds'"
		lockAction.setLockDeletes(allLockIds)
		lockAction.execute()
		
		assert lockAction.getMappingLocks().size() == 0
		
	}
	
}
