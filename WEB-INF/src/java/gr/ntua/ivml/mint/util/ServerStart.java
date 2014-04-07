package gr.ntua.ivml.mint.util;


import gr.ntua.ivml.mint.actions.ScriptTester;
import gr.ntua.ivml.mint.db.DB;

import java.util.Set;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.mchange.v2.c3p0.C3P0Registry;
import com.mchange.v2.c3p0.PooledDataSource;

public class ServerStart implements ServletContextListener {

	Logger log = Logger.getLogger(ServerStart.class);
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		for( PooledDataSource pds: (Set<PooledDataSource>) C3P0Registry.allPooledDataSources()) {
			try {
				pds.close();
			} catch( Exception e ) {
				log.debug( "Error closing PooledDataSource.", e );
			}
		}
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		DB.getSession().beginTransaction();
		try {
		DB.cleanup();
		// TODO Auto-generated method stub
		Config.setContext( arg0.getServletContext());
		// load this class
		new ScriptTester();
		} finally {
			DB.closeSession();
			DB.closeStatelessSession();
		}
	}

}
