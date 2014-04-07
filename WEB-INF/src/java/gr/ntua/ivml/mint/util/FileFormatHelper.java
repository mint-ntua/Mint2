package gr.ntua.ivml.mint.util;

import gr.ntua.ivml.mint.concurrent.EntryProcessorI;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;

import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;



/**
 * Take input file and perform format related actions.
 * 
 * @author Arne Stabenau 
 *
 */
public class FileFormatHelper {
	
	public static class EntryException extends Exception {
		public String entryname;
		public EntryException( String msg, String entryname, Exception rootcause ) {
			super( msg, rootcause );
			this.entryname = entryname;
		}
	}
	
	private File input;
	private String originalName;
	
	private static final Logger log = Logger.getLogger( FileFormatHelper.class );
	
	public static class FileWithFormat {
		public File output;
		
		// input file format ... output is always .tgz
		// ZIP, TGZ, DIR, FILE
		public String format;
		public int entryCount;
	}
	
	/**
	 * Will give you a pair of entry and a stream that will just deliver data for that entry 
	 * and not more. Will ignore close as well.
	 * 
	 * @author Arne Stabenau 
	 *
	 */
	public static class TarEntryStream {
		TarArchiveEntry tae;
		InputStream is;
	}
	
	public FileFormatHelper( File input, String originalName ) throws Exception {
		if( ! input.exists() || ! input.canRead()) throw new Exception( "Cant access input file" );
		this.input = input;
		this.originalName = originalName;
	}
	
	public FileFormatHelper( File input ) throws Exception {
		this( input, null );
	}
	
	
	public FileWithFormat unknownToTgz() {
		FileWithFormat result = new FileWithFormat();
		try {
			result.output = File.createTempFile("MintConvert", ".tgz" );
			
			if( input.isDirectory() )
				if( tryFromPlain(result)) return result;
				else  return null;
			
			// try zip file
			if( tryFromZip(result) ) return result;
			
			// try if its tgz
			if( tryFromTgz(result)) return result;
			
			// just convert the plain file in tgz format
			if( tryFromPlain(result)) return result;
			
		} catch( Exception e ) {
			log.error( "Problem with conversion to tgz",e);
		}
		return null;
	}
	
	
	/**
	 * If the given file is a zip file, open it, reformat it to tgz and return
	 * the File, the format and the entryCount (only files counted, not dirs)
	 * @param result true on success
	 * @return
	 */
	public boolean  tryFromZip(FileWithFormat result ) {

		FileOutputStream fOut = null;
	    BufferedOutputStream bOut = null;
	    GzipCompressorOutputStream gzOut = null;
	    TarArchiveOutputStream tOut = null;
	    int fileEntryCount = 0;
	    ZipFile zf = null;
		try {
			zf = new ZipFile( input );
			Enumeration<ZipArchiveEntry> e = zf.getEntriesInPhysicalOrder();

			fOut = new FileOutputStream(result.output );
	        bOut = new BufferedOutputStream(fOut);
	        gzOut = new GzipCompressorOutputStream(bOut);
	        tOut = new TarArchiveOutputStream(gzOut);

			while( e.hasMoreElements() ) {
				ZipArchiveEntry ze = e.nextElement();
				TarArchiveEntry tarEntry = new TarArchiveEntry( ze.getName());
				tarEntry.setSize(ze.getSize());
				tOut.setLongFileMode(TarArchiveOutputStream.LONGFILE_GNU);
				tOut.putArchiveEntry(tarEntry);
				if(! ze.isDirectory()) {
					IOUtils.copy( zf.getInputStream(ze), tOut );
					fileEntryCount++;
				}
				tOut.closeArchiveEntry();
			}
			log.info( "Reformat from ZIP to TGZ." );
		} catch( Exception e ) {
			log.info( input.getName() + " not a zip file." );
			return false;
		} finally {
			try {
				if( tOut != null ) {
					tOut.finish();
					tOut.close();
				}
				if( gzOut != null ) gzOut.close();
				if( bOut != null ) bOut.close();
				if( fOut != null ) fOut.close();
				if( zf != null ) zf.close();
			} catch(Exception e) {
				log.error( "Closing resources failed", e );
			}
		}
		result.entryCount = fileEntryCount;
		result.format = "ZIP";
		return true;
	}

	
	/**
	 * Check if the given file is a tgz archive. Go through it, 
	 * count the entries and copy it to the output.
	 * @param result
	 * @return
	 */
	public boolean tryFromTgz( FileWithFormat result ) {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		GzipCompressorInputStream gzin = null;
		TarArchiveInputStream tin = null;
		int fileEntryCounter = 0;
		
		try {
			fis = new FileInputStream( input );
			bis = new BufferedInputStream(fis);
			gzin = new GzipCompressorInputStream(bis);
			tin = new TarArchiveInputStream(gzin );
			TarArchiveEntry tae;
			while((tae=tin.getNextTarEntry()) != null) {
				if( tae.isFile()) fileEntryCounter++;
			}
			// all good, close up
			tin.close(); gzin.close();
			bis.close(); fis.close();
			IOUtils.copy( new FileInputStream(input), new FileOutputStream( result.output ));
			result.entryCount = fileEntryCounter;
			result.format = "TGZ";
			log.info( "File is in TGZ format, no reformat.");
			return true;
		} catch( Exception e ) {
			log.info( input.getName() + " probably not tgz format." );
		}
		return false;
	}
	
	/**
	 * TarGz the input file. If its a dir tgz that. Return false on error.
	 * @param result
	 */
	public boolean tryFromPlain( FileWithFormat result ) {
		try {
			tgzDir( input, result, originalName );
		} catch( IOException e ) {
			log.error( "Plain file to tgz failed.", e );
			return false;
		}
		return true;
	}
	
	/**
	 * tgz given dir. The output.output file needs to be initialized!
	 * @param input
	 * @param output
	 */
	public static void tgzDir( File input, FileWithFormat output, String othername ) throws IOException  {

		FileOutputStream fOut = null;
	    BufferedOutputStream bOut = null;
	    GzipCompressorOutputStream gzOut = null;
	    TarArchiveOutputStream tOut = null;
	 
	    try {
	        fOut = new FileOutputStream(output.output );
	        bOut = new BufferedOutputStream(fOut);
	        gzOut = new GzipCompressorOutputStream(bOut);
	        tOut = new TarArchiveOutputStream(gzOut);
	        // not sure if it goes here or for every file
	        // tOut.setLongFileMode(TarArchiveOutputStream.LONGFILE_GNU);
	        
	        if( input.isFile()) output.format = "FILE";
	        else output.format= "DIR";
	        output.entryCount = addToStream(input, "", tOut, othername ); 
	    } finally {
	        tOut.finish();
	 
	        tOut.close();
	        gzOut.close();
	        bOut.close();
	        fOut.close();
	    }
	}
	
	/**
	 * use basename + / + input.name and add it to the output
	 * @param input
	 * @param basename
	 * @param out
	 * @return how many files added
	 */
	private static int addToStream( File input, String basename, TarArchiveOutputStream out, String othername ) throws IOException {
		String entryName = basename + input.getName();
		if( othername != null ) {
			entryName = basename+othername;
		}
		TarArchiveEntry tarEntry = new TarArchiveEntry(input, entryName);

		out.setLongFileMode(TarArchiveOutputStream.LONGFILE_GNU);
		out.putArchiveEntry(tarEntry);

		if (input.isFile()) {
			IOUtils.copy(new FileInputStream(input), out);

			out.closeArchiveEntry();
			return 1;
		} else {
			out.closeArchiveEntry();
			int count = 0;
			File[] children = input.listFiles();

			if (children != null) {
				for (File child : children) {
					count += addToStream(child, entryName + "/", out, null );
				}
			}
			return count;
		}	
	}
	
	/**
	 * Iterate through a tgz file and do what the processor says to every file.
	 * Dirs are skipped.
	 * @param tgz
	 * @param ep
	 * @throws EntryException
	 */
	public static void processAllEntries( File tgz, EntryProcessorI ep ) throws EntryException {
		// iterate through the tar archive
		FileInputStream fis = null;
		GzipCompressorInputStream gzin = null;
		TarArchiveInputStream tis = null;
		FilterInputStream fiis = null;
		
		TarArchiveEntry tae = null;
		try {
			fis = new FileInputStream( tgz );
			gzin = new GzipCompressorInputStream( fis );
			tis = new TarArchiveInputStream( gzin );
			fiis = new FilterInputStream( tis ) {
				public void close() throws IOException {};
			};
			
			tae = tis.getNextTarEntry();
			while( tae != null ) {
				// ignore dirs!
				// ignore files that start with "."
				if(( ! tae.isDirectory()) &&
						(!tae.getName().startsWith(".")))
					ep.processEntry(tae.getName(), fiis );
				tae = tis.getNextTarEntry();
			}
		} catch( Exception e ) {
			String msg;
			String entryName = "<unknown>";
			if( tae != null ) entryName= tae.getName();
			log.error( "Reading of entry "+ entryName + " failed ", e );
			msg =  "Reading of entry " + entryName + " failed.\n" + e.getMessage();
			throw new EntryException( msg, entryName, e );
		} finally {
			// close everything 
			try { if( tis != null ) tis.close(); } catch( Exception e ){};
			try { if( gzin != null ) gzin.close(); } catch( Exception e ){};
			try { if( fis != null ) fis.close(); } catch( Exception e ){};
		}
	}
}
