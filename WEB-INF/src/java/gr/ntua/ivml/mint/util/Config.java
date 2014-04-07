package gr.ntua.ivml.mint.util;

import java.io.File;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;

import org.apache.log4j.Logger;

/**
 * Class to read and reread a property file. Is static unsynced and stupid, 
 * but easy to use.
 * 
 * @author Arne Stabenau
 *
 */
public class Config {
	private static long lastRead;
	private static final long UPDATE_INTERVAL = 2000l;
	private static final String PROPS = "mint.properties";
	private static final String LOCAL = "local.properties";
	private static final String CUSTOM = "custom.properties";

	public static Properties properties = new Properties( System.getProperties());
	public static Properties local = new Properties( properties );
	public static Properties custom = new Properties( properties );
	
	public static final Logger log = Logger.getLogger( Config.class );
	public static ServletContext context;
	public static File projectRoot = null;
	
	public static String get(String key) {
		return Config.getWithDefault(key, null);
	}

	public static String getWithDefault( String key, String defaultValue ) {
		checkAndRead();
		
		String result = defaultValue;
		
		if(local.containsKey(key)) {
			result = local.getProperty(key);
		} else if(custom.containsKey(key)) {
			result = custom.getProperty(key);
		} else if(properties.containsKey(key)) {			
			result = properties.getProperty(key);
		}
		
		return result;
	}
	
	public static boolean debugEnabled()
	{
		return Config.getBoolean("debug");
	}
	
	public static boolean getBoolean( String key, boolean defaultValue ) {
		String result = Config.get(key);
		
		if(result != null) {
			if(result.equalsIgnoreCase("true") || result.equalsIgnoreCase("yes") || result.equalsIgnoreCase("1")) {
				return true;
			}
		}
		
		return defaultValue;
	}

	public static boolean getBoolean( String key ) {
		return Config.getBoolean(key, false);
	}


	public static boolean has( String key ) {
		checkAndRead();
		return local.contains(key) || custom.containsKey(key) || properties.containsKey(key);
	}
	
	public static String get( String key, String defaultValue ) {
		checkAndRead();
		return properties.getProperty( key, defaultValue );
	}
	
	private static void checkAndRead() {
		if( lastRead==0l) readProps();
		else if(( System.currentTimeMillis() - lastRead ) > UPDATE_INTERVAL )
			readProps();
	}
	
	private static void readProps() {
	    try {
	    	InputStream inputStream = Config.class.getClassLoader().getResourceAsStream(PROPS);
	    	if(inputStream != null) properties.load(inputStream);
	        
	        inputStream = Config.class.getClassLoader().getResourceAsStream(CUSTOM);
	        if( inputStream != null ) custom.load(inputStream);
	        
	        inputStream = Config.class.getClassLoader().getResourceAsStream(LOCAL);
	        if( inputStream != null ) local.load(inputStream);
	        
	        lastRead = System.currentTimeMillis();
	    } catch( Exception e) {
	    	log.error( "Can't read properties", e );
	    	throw new Error( "Configuration file " + PROPS + " not found in CLASSPATH", e);
	    }
	}
	
	public static void setContext( ServletContext sc ) {
		context = sc;
	}
	
	public static ServletContext getContext( ) {
		return context;
	}

	public static String getRealPath( String path  ) {
		if( context == null ) {
			log.warn("Calling getRealPath( path )  with no context set.");
			return path;
		}
		return context.getRealPath( path );
	}

	/**
	 * Go up a couple of dirs from mint.properties and return that as project root.
	 * @return
	 */
	public static File getProjectRoot() {
		if( projectRoot == null ) {
			try {
				String resultPath = Config.class.getResource("/mint.properties").getPath();
				resultPath = resultPath.replaceFirst("/WEB-INF.*", "");
				// sometimes this comes from classes sometimes from src ...
				// it should always be in the WEB-INF folder, so cut that of

				projectRoot = new File( resultPath );
				log.info( "project root at '" + projectRoot + "'");
				if( !projectRoot.canRead()) projectRoot = null;
			} catch( Exception e) {
				log.error( "Cant find project root", e );
			}
		}
		return projectRoot;
	}

	public static String getSchemaPath(String xsd) {
		return new File( getSchemaDir(), xsd ).getAbsolutePath();
	}
	
	public static String getXSLPath(String xsl) {
		return context.getRealPath(Config.getWithDefault("paths.xsl", "xsl") + System.getProperty("file.separator") + xsl);
	}

	public static String getScriptPath(String script) {
		return context.getRealPath(Config.getWithDefault("paths.scripts", "scripts") + System.getProperty("file.separator") + script);
	}
	
	public static File getSchemaDir() {
		return getProjectFile( Config.getWithDefault("paths.schemas", "schemas") );
	}
	
	public static File getXSLDir() {
		return getProjectFile( Config.getWithDefault("paths.xsl", "xsl") );
	}
	
	public static File getUploadedSchemaDir() {
		String schemas = Config.getWithDefault("paths.schemas", "schemas");
		String uploaded = Config.getWithDefault("paths.schemas.uploaded", "uploaded");
		
		return getProjectFile( schemas + System.getProperty("file.separator") + uploaded );
	}
	
	public static File getTestRoot() {
		return getProjectFile( "WEB-INF/src/test" );
	}
	
	public static File getTestFile( String path ) {
		return new File( getTestRoot(), path );
	}
	
	public static File getProjectFile( String relativePath ) {
		return new File( getProjectRoot(), relativePath );
	}

	public static File getCustomJsp(String jsp) {
		String subdir = get("custom.name" );
		File jspFile = getProjectFile( "WEB-INF/custom/"+subdir+"/jsp/" + jsp);
		if( jspFile.exists() && jspFile.canRead()) return jspFile;
		return null;
	}
	
}
 