package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.BlobWrap;
import gr.ntua.ivml.mint.persistent.Crosswalk;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.DatasetLog;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.persistent.ValueEdit;
import gr.ntua.ivml.mint.persistent.XMLNode;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.persistent.XpathStatsValues;
import gr.ntua.ivml.mint.util.Config;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOError;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.StatelessSession;
import org.hibernate.Transaction;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.impl.SessionFactoryImpl;
import org.hibernate.jdbc.Work;

public class DB {
	private static SessionFactory sf;
	static final Logger log = Logger.getLogger( DB.class );

	private static ThreadLocal<StatelessSession> statelessSessions = new ThreadLocal<StatelessSession>();
	private static ThreadLocal<Session> sessions = new ThreadLocal<Session>();
	
	private static void initSession() {
		try {
			// Create the SessionFactory from hibernate.cfg.xml
			// or, like here, from hibernate.properties
			Class<?>[] classes = { User.class, Organization.class, 
							Dataset.class, BlobWrap.class,
							XMLNode.class, Lock.class,
							Mapping.class, XmlSchema.class,
							Crosswalk.class, DatasetLog.class,
							Item.class, XpathStatsValues.class,
							ValueEdit.class };

			Set<Class<?>> classSet = new HashSet<Class<?>>();
			classSet.addAll( Arrays.asList( classes ));
			
		
			AnnotationConfiguration ac = new AnnotationConfiguration();
			String testDbUrl = Config.get( "hibernate.testdb");
			if( testDbUrl != null ) {
				ac.setProperty("hibernate.connection.url", testDbUrl );
			}
			
			// is there custom db stuff ?
			try {
				Class<?> customDB = Class.forName("gr.ntua.ivml.mint.db.CustomDB");
				Method m = customDB.getMethod("init", AnnotationConfiguration.class, Set.class );
				m.invoke(null, ac, classSet );
			} catch( Exception e ) {
				log.debug( "No CustomDB found" );
			}

			for( Class<?> c: classSet ) {
				ac.addClass(c);
			}

			sf = ac.buildSessionFactory( );
			
		} catch (Throwable ex) {
			// Make sure you log the exception, as it might be swallowed
			log.error("Initial SessionFactory creation failed." , ex);
			throw new ExceptionInInitializerError(ex);
		}
		log.info( "SessionFactory instantiated" );
	}

	public static boolean isTestDb() {
		String testDbUrl = Config.get( "hibernate.testdb");
		return ( testDbUrl != null ); 
	}
	
	private static SessionFactory getSessionFactory() {
		if( sf == null ) initSession();
		return sf;
	}
	
	
	/*
	 * Should try and open session when request comes in
	public static Session getSession() {
		return sessionFactory.openSession();
	}	
	 */
	public static void setSession( Session s ) {
		sessions.set(  s );		
	}

	public static void removeSession() {
		sessions.remove();
	}
	
	public static Session getSession() {
		Session s;
		s = sessions.get();
		if((s == null ) || ( !s.isOpen())) {
			s = freshSession();
			sessions.set( s );
		}
		return s;
	}	
	
	/**
	 * Returns a newly made session. Make sure you close it after usage.
	 * @return
	 */
	public static Session freshSession() {
		Session s = null;
		try {
			s = getSessionFactory().openSession();
			log.debug( "Session created!");
		} catch( HibernateException e ) {
			log.error( "Couldn't create Session", e );
			throw e;
		}
		return s;
	}
	
	public static StatelessSession getStatelessSession() {
		StatelessSession ss = statelessSessions.get();
		if( ss == null ) {
			ss = freshStatelessSession();
			statelessSessions.set( ss );
		}
		return ss;
	}
	
	/**
	 * In case you really need to work on something big to iterate over, this is the safest choice I guess.
	 * @return
	 */
	public static StatelessSession freshStatelessSession() {
		try {
			Connection c  = ((SessionFactoryImpl)getSessionFactory()).getConnectionProvider().getConnection();
			StatelessSession ss = getSessionFactory().openStatelessSession(c);
			log.debug( "StatelessSession created!");
			return ss;
		} catch( SQLException se ) {
			log.error( "No stateless Session", se );
		}
		return null;
	}
	
	
	public static void closeStatelessSession() {
		StatelessSession ss = statelessSessions.get();
		if( ss != null ) {
			try {
				ss.connection().close();
				ss.close();
			} catch( Exception e ) {
				log.error( e );
			}
			statelessSessions.set( null );
		}
	}
	
	public static Session newSession() {
		closeSession();
		return getSession();
	}
	
	
	public static void closeSession() {
		Session s = sessions.get( );
		if( s != null ) {
			s.close();
			sessions.remove();
		}
	}
	
	public static void logPid() {
		Session s = getSession();
		Connection c = s.connection();
		logPid(c );
	}
	
	public static void logPid( Connection c ) {
		try {
		Statement st = c.createStatement();
		st.execute("select pg_backend_pid()");
		ResultSet rs = st.getResultSet();
		rs.next();
		log.debug( "Thread: " + Thread.currentThread().getName() + " pid = " + rs.getInt(1));
		} catch( Exception e ) {
			log.debug( "Cant log transaction id " + e.getMessage());
		}
	}
	
	

	
	// test to write out current transaction (and create new one)
	public static void commit() {
		getSession().flush();
		getSession().getTransaction().commit();
		getSession().beginTransaction();
	}
	
	public static void refresh( Object obj ) throws HibernateException {
		DB.getSession().refresh(obj);
	}
	
	public static LockManager getLockManager() {
		return new LockManager();
	}
	
	public static XpathStatsValuesDAO getXpathStatsValuesDAO() {
		return (XpathStatsValuesDAO) instantiateDAO( XpathStatsValuesDAO.class );
	}

	public static CrosswalkDAO getCrosswalkDAO() {
		return (CrosswalkDAO) instantiateDAO( CrosswalkDAO.class );
	}

	public static ItemDAO getItemDAO() {
		return (ItemDAO) instantiateDAO( ItemDAO.class );
	}

	public static ValueEditDAO getValueEditDAO() {
		return (ValueEditDAO) instantiateDAO( ValueEditDAO.class );
	}

	public static XmlSchemaDAO getXmlSchemaDAO() {
		return (XmlSchemaDAO) instantiateDAO( XmlSchemaDAO.class );
	}

	public static UserDAO getUserDAO() {
		return (UserDAO) instantiateDAO( UserDAO.class );
	}

	public static TransformationDAO getTransformationDAO() {
		return (TransformationDAO) instantiateDAO( TransformationDAO.class );
	}

	public static XMLNodeDAO getXMLNodeDAO() {
		return (XMLNodeDAO) instantiateDAO( XMLNodeDAO.class );
	}

	public static XpathHolderDAO getXpathHolderDAO() {
		return (XpathHolderDAO) instantiateDAO( XpathHolderDAO.class );
	}

	public static OrganizationDAO getOrganizationDAO() {
		return (OrganizationDAO) instantiateDAO( OrganizationDAO.class );
	}
		
	public static DataUploadDAO getDataUploadDAO() {
		return (DataUploadDAO) instantiateDAO( DataUploadDAO.class );
	}

	public static DatasetDAO getDatasetDAO() {
		return (DatasetDAO) instantiateDAO( DatasetDAO.class );
	}

	public static DatasetLogDAO getDatasetLogDAO() {
		return (DatasetLogDAO) instantiateDAO( DatasetLogDAO.class );
	}

	public static MappingDAO getMappingDAO() {
		return (MappingDAO) instantiateDAO( MappingDAO.class );
	}

	

	private static DAO instantiateDAO(Class<? extends DAO> daoClass) {
        try {
            DAO dao = (DAO)daoClass.newInstance();
            return dao;
        } catch (Exception ex) {
            throw new RuntimeException("Can not instantiate DAO: " + daoClass, ex);
        }
    }

	public static void doSQLFile( String filename ) {
		try {
			File input = new File( Config.getProjectRoot(), filename );
			String fileContent = IOUtils.toString( new FileInputStream( input ), "UTF8" );
			Transaction t = DB.getSession().beginTransaction();
			DB.getSession().createSQLQuery(fileContent).executeUpdate();
			t.commit();
		} catch( Exception e ) {
			throw new IOError( e );
		}
	}

	public static void flush() {
		getSession().flush();
	}

	public static void cleanup() {
		// cleanup Datasets!
		getDatasetDAO().cleanup();
		getLockManager().cleanup();
	}
	
	public static String connectionUrl() {
		Session s = getSessionFactory().openSession();
		final StringBuffer sb = new StringBuffer();
		Work w = new Work() {
			public void execute(Connection c) throws SQLException {
				sb.append( c.getMetaData().getURL());
			}
		};
		s.doWork( w );
		return sb.toString();
	}
	
	public static void releaseAll() {
		((SessionFactoryImpl) getSessionFactory()).getConnectionProvider().close();
	}
}


