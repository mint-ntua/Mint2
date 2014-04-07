package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.db.DB;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.sql.Connection;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.postgresql.PGConnection;
import org.postgresql.largeobject.LargeObject;
import org.postgresql.largeobject.LargeObjectManager;

import com.mchange.v2.c3p0.C3P0ProxyConnection;

/**
 * Helper class. The Blob in an object with updates was just too difficult
 * to manage with hibernate.
 * @author arne
 *
 */
public class BlobWrap {
	Long dataId;
	Long dbID;
	int length;
	
	public static final Logger log = Logger.getLogger( BlobWrap.class );
	
	
	
	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public Long getDbID() {
		return dbID;
	}

	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}

	public Long getDataId() {
		return dataId;
	}

	public void setDataId(Long dataId) {
		this.dataId = dataId;
	}
	
	public void saveFile( File tmpFile )  {
		try {
			Connection c = DB.getStatelessSession().connection();
			LargeObjectManager lobjm = getObjManager(c);
			// create an oid for this lob
			setLength( (int) tmpFile.length());
			setDataId( lobjm.createLO());

			LargeObject lob = lobjm.open( dataId, LargeObjectManager.WRITE );
			OutputStream os = lob.getOutputStream();
			IOUtils.copy( new FileInputStream( tmpFile ), os);
			lob.close();
			c.commit();
		} catch( Throwable e ) {
			log.error( "Blob File save failed",e );
		}
	}
	
	public File getFile() {
		try {
		File tmpFile = File.createTempFile("BlobDump", ".tgz");
		if( unload(tmpFile)) return tmpFile;
		tmpFile.delete();
		} catch( Exception e ) {
			log.error( "getFile failed because of ", e );
		}
		return null;
	}
	
	/**
	 * Unload this blob and report success or failure.
	 * @param here
	 * @return
	 */
	public boolean unload( File here ) {
		try {
			Connection c = DB.getStatelessSession().connection();
			LargeObjectManager lobjm = getObjManager(c);
			LargeObject lob = lobjm.open( getDataId(), LargeObjectManager.READ );
			InputStream is = lob.getInputStream();
			IOUtils.copy( is, new FileOutputStream( here ));
			lob.close();
			c.commit();
		} catch( Throwable e ) {
			log.error( "Blob file dump failed", e );
			return false;
		}
		return true;
	}
	
	private LargeObjectManager getObjManager( Connection c ) throws Exception {
		C3P0ProxyConnection cp = (C3P0ProxyConnection) c;
		Method m = PGConnection.class.getMethod("getLargeObjectAPI", new Class[0]);
		LargeObjectManager lobjm = (LargeObjectManager) cp.rawConnectionOperation(m, C3P0ProxyConnection.RAW_CONNECTION, new Object[0]);
		return lobjm;
	}
 }
