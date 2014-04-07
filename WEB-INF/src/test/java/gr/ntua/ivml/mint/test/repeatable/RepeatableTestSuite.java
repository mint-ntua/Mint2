package gr.ntua.ivml.mint.test.repeatable;

import gr.ntua.ivml.mint.db.DB;

import java.lang.reflect.Method;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import junit.extensions.TestSetup;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;


/**
 * Base class for supporting repeatable tests.
 * It relies that the mint system is connected to the local database
 * mint2test!
 * 
 * Every repeatable test suit assumes that the database is the test-database and
 * will make sure to keep it unchanged.
 * 
 * @author Arne Stabenau 
 *
 */
public class RepeatableTestSuite extends TestCase {
	
	public static final Logger log = Logger.getLogger( RepeatableTestSuite.class  );
	
	
	
	private static List<String> safedTables = new ArrayList<String>();
	private static List<String> restoreForeignKeys = new ArrayList<String>();
	
	public static void suiteSetUp() {
		// override this in your test suit
		List<String> res = DB.getStatelessSession().createSQLQuery("select tablename from pg_tables where schemaname = current_schema() " +
				"and tablename like '%_safed'")
				.list();
			for( String tablename: res ) {
				log.info( "Restored left over safe table " + tablename );
				String source = tablename.substring(0, tablename.length()-6 );
				restoreTable( source);
			}
		
		log.debug( "Repeatable suite setup called");
	}
	
	public static void suiteTearDown() throws Exception {
		restoreTables();
		log.debug( "Repeatable suiteTearDown called");
	}
	
	public void reloadTestdb() {
		log.debug( "reloadTestDb called");
	}
	
	public static Test init( Class clazz ) {
		final Class testclass = clazz;
		if( !DB.isTestDb()) throw new RuntimeException( "DB ist not in test mode!!!");
		final String url = DB.connectionUrl();
		
		// TODO: is the hibernate db the test db?
		log.debug( "Connection url is \"" + url + "\"");
		
		// if( !url.equals( "" )) throw new RuntimeException( "Hibernate is not pointing to right test db" );
		
		// create a test setup
		Test suite = new TestSetup( new TestSuite( testclass )) {
			protected void setUp() throws Exception {
				// find suiteSetUp
				Method setup = testclass.getMethod("suiteSetUp" );
				setup.invoke(null);
			}
			
			protected void tearDown() throws Exception {
				Method tearDown = testclass.getMethod("suiteTearDown" );
				tearDown.invoke(null);
			}
		};
		
		return suite;
	}
	
	public static Test suite() {
		return init( RepeatableTestSuite.class );
	}
	
	
	public void tearDown() {
		log.debug( "default test teardown");
		DB.getSession().getTransaction().commit();
		DB.getStatelessSession().getTransaction().commit();
		DB.closeSession();
		DB.closeStatelessSession();
	}

	public void setUp() {
		log.debug( "default test setup");
		DB.getSession().beginTransaction();
		DB.getStatelessSession().beginTransaction();
	}

	public static void safeTables( String... tablenames ) throws Exception {
		for( String tablename: tablenames ) {
			safeTable( tablename );
		}
		DB.getStatelessSession().connection().commit();
	}
	
	public static void restoreTables() throws Exception {
		for( String tablename: safedTables ) {
			restoreTable( tablename );
		}
		safedTables.clear();
		// recreate foreign keys
		DB.getStatelessSession().connection().commit();
	}
	
	private static void safeTable( String sourceTable ) {
		DB.getStatelessSession().createSQLQuery( "create table " + sourceTable + "_safed as select * from " + sourceTable )
		.executeUpdate();
		safedTables.add( sourceTable );
	}
		
	public static void safeAll() throws Exception {
		List<String> res = DB.getStatelessSession().createSQLQuery("select tablename from pg_tables where schemaname = current_schema() ")
			.list();
		for( String tablename: res ) {
			safeTable( tablename);
		}
		DB.getStatelessSession().connection().commit();
	}
	/**
	 * This probably does not work with huge tables, but that shouldn't happen anyway.
	 * @param sourceTable
	 */
	private static void restoreTable( String sourceTable ) {
		killForeignKeysOn( sourceTable );
		DB.getStatelessSession().createSQLQuery( "delete from " + sourceTable )
		.executeUpdate();
		DB.getStatelessSession().createSQLQuery( "insert into " + sourceTable + " select * from " + sourceTable + "_safed")
		.executeUpdate();	
		DB.getStatelessSession().createSQLQuery( "drop table " + sourceTable + "_safed")
		.executeUpdate();	
		// restore foreign keys
		for( String sql: restoreForeignKeys ) {
			DB.getStatelessSession().createSQLQuery(sql)
				.executeUpdate();
		}
		restoreForeignKeys.clear();
	}
	
	public static int countTableRows( String table ) {
		Object res = DB.getStatelessSession().createSQLQuery( "select count(*) from " + table ).uniqueResult();
		return ((BigInteger) res).intValue();
	}
	
	private static void killForeignKeysOn( String table ) {
		List<Object[]> res = DB.getStatelessSession().createSQLQuery( "select p2.relname, pg_get_constraintdef(pgc.oid), pgc.conname from pg_constraint pgc, pg_class p1, pg_class p2 " + 
				"where p1.oid = pgc.confrelid and p2.oid = pgc.conrelid " +
				" and p1.relname = :tablename" )
				.setString("tablename", table )
				.list();
		for( Object[] constraint: res ) {
			String sql =  "alter table " + constraint[0] + " add " + constraint[1];
			log.debug( "SQL safed = " + sql );
			
			restoreForeignKeys.add( sql );
			sql = "alter table " + constraint[0] + " drop constraint " + constraint[2];
			log.debug( "Kill constraint: '" + sql +"'");
			DB.getStatelessSession().createSQLQuery( sql )
				.executeUpdate();
		}
	}
}
