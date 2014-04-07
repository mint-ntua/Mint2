package gr.ntua.ivml.mint.test.repeatable

import java.util.GregorianCalendar;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.*;
import gr.ntua.ivml.mint.util.Tuple;
import java.util.Date

import java.text.SimpleDateFormat;

import junit.framework.Test;

class TargetCountTest extends RepeatableTestSuite {
	public static Test suite() {
		return RepeatableTestSuite.init( TargetCountTest.class );
	}
	
	public static suiteSetUp() {
		RepeatableTestSuite.suiteSetUp();
	}
	
	public void setUp() {
		safeTables( "organization", "meta" );
		super.setUp();
	}
	
	
	public void tearDown() {
		super.tearDown()
		restoreTables();
	}

	public void testTargetPeriods() {
		def sdf = new SimpleDateFormat( "dd-MM-yyyy");
		Organization org = DB.getOrganizationDAO().findByName("DPA");
		def now = new Date();
		GregorianCalendar cal = GregorianCalendar.getInstance();
		cal.setTime( new Date());
		cal.add(Calendar.MONTH, 3)
		Date month1 = cal.getTime();
		cal.add(Calendar.MONTH, 3)
		Date month2 = cal.getTime();
		
		cal.add(Calendar.MONTH, 3)
		Date month3 = cal.getTime();
		
		cal.setTime(now);
		cal.add( Calendar.DAY_OF_YEAR, -2);
		Date before = cal.getTime();
		cal.add( Calendar.MONTH, -3 );
		Date before2 = cal.getTime();
		
		JsonOrganizationTargets targets = new JsonOrganizationTargets();
		targets.addPeriod(before2, before, 50);
		targets.addPeriod(before, month1, 100);
		targets.addPeriod(month1, month2, 200 );
		targets.addPeriod(month2, month3, 400 );
		
		org.setTargets(targets);
		
		targets = org.getTargets();
		assertNotNull( targets );
		
		// check currentTarget total item count
		def tuple = targets.currentTarget()
		assertEquals(tuple.second(),150 )
		
		// check Target date is month1 (Date comparison ignoring time)
		assertEquals( sdf.format(month1), sdf.format(tuple.first()))		
		assertEquals( targets.getPeriods().size(), 4 )
		
		// delete targets 
		org.setTargets(null);		
		assertNull( org.getTargets())
		
		// open start targets
		targets = new JsonOrganizationTargets();
		targets.addPeriod(null, before, 50);
		targets.addPeriod(null, month1, 100);
		targets.addPeriod(null, month2, 200 );
		targets.addPeriod(null, month3, 400 );
		
		// set and check new targets
		org.setTargets(targets);		
		targets = org.getTargets();
		assertNotNull( targets );
		
		
		// check the nature of the targets
		tuple = targets.currentTarget()
		assertEquals(tuple.second(),100 )
		
		// check Target date is month1 (Date comparison ignoring time)
		assertEquals( sdf.format(month1), sdf.format(tuple.first()))		
	
		
		// what is the last day behaviour, should give today as deadline
		tuple = targets.getTargetCountUntil(month2)
		assertEquals( sdf.format(month2), sdf.format(tuple.first()))		
		assertEquals(tuple.second(),200 )
	}
	
	public void testTypicalSetup() {
		// setup the targets with groovy script like so
		// import gr.ntua.ivml.mint.persistent.*;
		// import java.text.SimpleDateFormat;
        DB.statelessSession.beginTransaction()

		def deadlines = ["31-03-2001", "30-06-2001", "31-12-2001"] as String[]
		def orgitems = ["NTUA" : [ 5,10,20 ], "DPA" : [100,200,300] ]
		def sdf= new SimpleDateFormat( "dd-MM-yyyy");
		            
		for( org in DB.organizationDAO.findAll()) {
			for( orgitem in orgitems) {
				if( orgitem.key.equals( org.englishName ) ||
						orgitem.key.equals( org.shortName )) {
					// setup periods
					def tgs = new JsonOrganizationTargets()
					for( int i=0; i<deadlines.size(); i++ ) {
						tgs.addPeriod( null, 
								sdf.parse( deadlines[i]), 
								orgitem.value[i])
					}
					org.setTargets( tgs );
				}
			}
		}
		// end groovy test period setup
		
		// test the contents
		Date test1 = sdf.parse("01-12-2001");
		Date test2 = sdf.parse("30-06-2001" );
		Tuple<Date, Integer> tup;
		boolean checkedNTUA = false;
		boolean checkedDPA = false;
		for( org in DB.organizationDAO.findAll()) {
			if( "NTUA".equals( org.englishName ) ||
					"NTUA".equals( org.shortName )) {
				def targets = org.getTargets()
				assertNotNull( "No targets set on NTUA", targets  )
				tup =  targets.getTargetCountUntil(test1)
				assertEquals( sdf.format( tup.first()), "31-12-2001")
				assertEquals( tup.second(), 20 )
				tup =  targets.getTargetCountUntil(test2)
				assertEquals( sdf.format( tup.first()), "30-06-2001")
				assertEquals( tup.second(), 10 )
				checkedNTUA = true;
			}
			if( "DPA".equals( org.englishName) || "DPA".equals( org.shortName )) {
				def targets = org.getTargets()
				assertNotNull(  "No targets set on DPA" , targets)
				tup =  targets.getTargetCountUntil(test1)
				assertEquals( sdf.format( tup.first()), "31-12-2001")
				assertEquals( tup.second(), 300 )
				tup =  targets.getTargetCountUntil(test2)
				assertEquals( sdf.format( tup.first()), "30-06-2001")
				assertEquals( tup.second(), 200 )
				checkedDPA = true
			}
		}
		assertTrue(  "NTUA org not checked", checkedNTUA)
		assertTrue( "DPA org not checked", checkedDPA  )
	}
}
