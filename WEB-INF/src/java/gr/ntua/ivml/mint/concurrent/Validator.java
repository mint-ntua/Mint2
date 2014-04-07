package gr.ntua.ivml.mint.concurrent;

import static gr.ntua.ivml.mint.util.StringUtils.getDefault;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.StringUtils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import javax.xml.validation.Schema;
import javax.xml.validation.ValidatorHandler;

import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;


public class Validator implements Runnable {
	private XMLReader parser;
	private Dataset dataset;
	private String currentProblem;
	private int validCounter=0, invalidCounter=0;
	private TarArchiveOutputStream validOutput = null;
	private TarArchiveOutputStream invalidOutput = null;
	private File validOutputFile = null;
	private File invalidOutputFile = null;
	private boolean stopOnFirstInvalid = false;
	private XmlSchema schema = null;
	
	public static final Logger log = Logger.getLogger( Validator.class );
	
	/**
	 * Validates against dataset's target schema
	 * @param ds
	 */
	public Validator( Dataset ds ) {
		this.dataset = ds;
		this.schema = this.dataset.getSchema();
	}
	
	/**
	 * Validates dataset against a schema
	 * @param ds
	 * @param schema
	 */
	public Validator( Dataset ds, XmlSchema schema ) {
		this.dataset = ds;
		this.schema = schema;
	}
	
	public void runInThread() {
		
		try {
			if( this.schema == null ) {
				dataset.logEvent( "No schema set to validate." );
				return;
			}
			dataset.setSchemaStatus(Dataset.SCHEMA_RUNNING);
			dataset.logEvent("Validation started." );
			DB.commit();
			parser = org.xml.sax.helpers.XMLReaderFactory.createXMLReader(); 
			parser.setFeature("http://apache.org/xml/features/validation/schema-full-checking", false);
			parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
			setupSchemaValidation(parser);
			
			// if there are items, validate items
			if( dataset.getItemizerStatus().equals(Dataset.ITEMS_OK)) 
				checkItemSchema(); 
			// else validate files
			else if(dataset.getLoadingStatus().equals(Dataset.LOADING_OK)) {
				checkEntrySchema();
			}

			if( dataset.getSchemaStatus().equals(Dataset.SCHEMA_RUNNING)) {
				dataset.setSchemaStatus( Dataset.SCHEMA_OK );			
			}
			
			
			// collect the results
			DB.commit();
		} catch( Exception e ) {
			dataset.setSchemaStatus(Dataset.SCHEMA_FAILED); 
			dataset.logEvent("Validation failed. " + e.getMessage(), StringUtils.stackTrace(e, null));
			log.error( "Validation failed.", e );
			DB.commit();
		} 
	}
	
	/**
	 * Changes the parser to handle validation issues. Will change the currentProblem on every
	 * error occuring. If currentProblem is null, there is no problem.
	 * @param parser
	 * @param statsHandler
	 */
	private void setupSchemaValidation( XMLReader parser ) throws Exception {
		ErrorHandler eh = new ErrorHandler() {
			@Override
			public void error(SAXParseException se)
					throws SAXException {
				if( currentProblem == null ) currentProblem = se.getMessage();
				else currentProblem += "\n" + se.getMessage();
			}

			@Override
			public void fatalError(SAXParseException se)
					throws SAXException {
				if( currentProblem == null ) currentProblem = se.getMessage();
				else currentProblem += "\n" + se.getMessage();
				throw se;
			}

			@Override
			public void warning(SAXParseException se)
					throws SAXException {
				if( currentProblem == null ) currentProblem = se.getMessage();
				else currentProblem += "\n" + se.getMessage();
			}				
		};
		
		try {
			Schema schema = this.schema.getSchema();
			ValidatorHandler validationHandler = schema.newValidatorHandler();
			validationHandler.setErrorHandler(eh);
			parser.setContentHandler(validationHandler);
		} catch( Exception e ) {
			log.error( "Schema validation setup failed miserably" ,e );
			throw e;
		}
	}
	
	
	public void run() {
		try {
			DB.getSession().beginTransaction();
			dataset = DB.getDatasetDAO().getById(dataset.getDbID(), false);
			runInThread();
		} finally {
			DB.closeSession();
			DB.closeStatelessSession();
		}
	}

	
	private void checkItemSchema() throws Exception {
		ApplyI<Item> itemProcessor = new ApplyI<Item>() {
			@Override
			public void apply(Item item) throws Exception {
				Thread.sleep(0);
				InputSource ins = new InputSource();
				String itemXml = item.getXml();
				if(!itemXml.startsWith("<?xml")) itemXml = "<?xml version=\"1.0\"  standalone=\"yes\"?>" + item.getXml();
				ins.setCharacterStream(new StringReader( itemXml ));
				currentProblem = null;
				parser.parse( ins );
				if(currentProblem == null ) {
					// this needs a state for the items so the changed item is
					// committed back
					item.setValid( true );
					collectValid(item);
					validCounter++;
				} else {
					if(isStopOnFirstInvalid()) {
						throw new Exception("Invalid item. Schema validation failed");
					}
					invalidCounter++;
					collectInvalid(item, currentProblem );
					if( invalidCounter < 4 ) {
						dataset.logEvent( "Invalid item " + item.getLabel(), currentProblem );
					}
					log.debug( "Item: " + item.getLabel() + "\n" + currentProblem );
				}
			}
		};
		dataset.processAllItems(itemProcessor, true );
		if( invalidOutput != null ) invalidOutput.close();
		if( validOutput != null ) validOutput.close();
		if( validCounter == 0 ) {
			throw new Exception( "No item was validated." );
		}
		dataset.setValidItemCount(validCounter);
		dataset.logEvent("Validation finished. ", validCounter + " Items valid, " + invalidCounter + " Items invalid." );
	}
	
	private void checkEntrySchema() throws Exception {
		EntryProcessorI ep = new EntryProcessorI( ) {
			public void  processEntry(String entryName, InputStream is) throws Exception {
				if( !entryName.endsWith(".xml") &&  !entryName.endsWith(".XML")) return;
				// makes this process interruptible
				Thread.sleep(0);
				InputSource ins = new InputSource();
				ins.setByteStream(is);
				currentProblem = null;
				parser.parse( ins );
				if(currentProblem == null ) {
					validCounter++;
				} else {
					if(isStopOnFirstInvalid()) {
						throw new Exception("Invalid item. Schema validation failed");
					}
					invalidCounter++;
					if( invalidCounter < 10 ) {
						dataset.logEvent("Entry " + entryName + " didn't validate.", currentProblem );
					}
				}
			}
		};
		dataset.processAllEntries(ep);
		if( invalidCounter > 0 ) {
			throw new Exception( invalidCounter + " entries failed validation." );
		}
		dataset.logEvent("Validation finished. ", validCounter + " entries valid, " + invalidCounter + " entries invalid." );
	}
	
	
	
	/**
	 * Return the Stream, with the entry already put.
	 * @param item
	 * @return
	 */
	private TarArchiveOutputStream getValidTgz(  ) {
		if( validOutput == null ) {
			try {
				validOutputFile = File.createTempFile("ValidItems", ".tgz" );
				log.info( "Logging valid to " + validOutputFile.getAbsolutePath());
				GzipCompressorOutputStream gz = new GzipCompressorOutputStream(
						new FileOutputStream(validOutputFile));
				validOutput = new TarArchiveOutputStream(gz);
				validOutput.setLongFileMode(TarArchiveOutputStream.LONGFILE_GNU);
				validOutput.putArchiveEntry(new TarArchiveEntry(datasetSubdir(dataset)+"/"));
				validOutput.closeArchiveEntry();
			} catch( Exception e ) {
				log.error( "Cannot create valid output File.", e );
			}
		}
		return validOutput;
	}
	

	private TarArchiveOutputStream getInvalidTgz(  ) {
		if( invalidOutput == null ) {
			try {
				invalidOutputFile = File.createTempFile("InvalidItems", ".tgz" );
				log.info( "Logging invalid to " + invalidOutputFile.getAbsolutePath());
				GzipCompressorOutputStream gz = new GzipCompressorOutputStream(
						new FileOutputStream(invalidOutputFile));
				invalidOutput = new TarArchiveOutputStream(gz);
				invalidOutput.setLongFileMode(TarArchiveOutputStream.LONGFILE_GNU);
				invalidOutput.putArchiveEntry(new TarArchiveEntry(datasetSubdir(dataset)+"/"));
				invalidOutput.closeArchiveEntry();
			} catch( Exception e ) {
				log.error( "Cannot create invalid output File.", e );
			}
		}
		return invalidOutput;
	}

	
	
	/**
	 * Write into the tgz archive for valid items.
	 * @param item
	 */
	private void collectValid( Item item ) {
		TarArchiveOutputStream tos = getValidTgz();
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			String itemXml = item.getXml();
			if(!itemXml.startsWith("<?xml")) itemXml = "<?xml version=\"1.0\"  encoding=\"UTF-8\" ?>\n" + item.getXml();
			IOUtils.write(itemXml, baos, "UTF-8" );
			baos.close();
			
			write( baos.toByteArray(), datasetSubdir(dataset)+"/Item_" + item.getDbID() + ".xml", tos );
		} catch( Exception e ) {
			log.error( "Failed to collect valid item ", e );
		}
	}
	
	/**
	 * Write into the tgz archive for valid items.
	 * @param item
	 */
	private void collectInvalid( Item item, String msg ) {
		TarArchiveOutputStream tos = getInvalidTgz();
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			String itemXml = item.getXml();
			if(!itemXml.startsWith("<?xml")) itemXml = "<?xml version=\"1.0\"  encoding=\"UTF-8\"?>\n" + item.getXml();
			IOUtils.write(itemXml, baos, "UTF-8" );
			baos.close();
			
			write( baos.toByteArray(),  datasetSubdir(dataset)+"/Item_" + item.getDbID() + ".xml", tos );
			baos.reset();

			IOUtils.write(msg, baos, "UTF-8" );
			baos.close();
			write( baos.toByteArray(),  datasetSubdir(dataset)+"/Item_" + item.getDbID() + ".err", tos );
			
		} catch( Exception e ) {
			log.error( "Failed to collect invalid item ", e );
		}	
	}

	private String datasetSubdir( Dataset ds ) {
		return String.format("%1$ty-%1$tm-%1$td_%1$tH:%1$tM:%1$tS", ds.getCreated());
	}
	
	private void write( byte[] data, String name, TarArchiveOutputStream tos ) throws IOException  {
		TarArchiveEntry entry = new TarArchiveEntry(name);
		entry.setSize((long) data.length );
		tos.putArchiveEntry(entry);
		IOUtils.write(data, tos);
		tos.closeArchiveEntry();
	}
	
	public void clean() {
		if( validOutputFile != null) validOutputFile.delete();
		if( invalidOutputFile != null ) invalidOutputFile.delete();
	}
	
	public File getValidItemOutputFile() {
		return validOutputFile;
	}
	
	public File getInvalidItemOutputFile() {
		return invalidOutputFile;
	}

	public void setStopOnFirstInvalid(boolean stopOnFirstInvalid) {
		this.stopOnFirstInvalid = stopOnFirstInvalid;
	}

	public boolean isStopOnFirstInvalid() {
		return stopOnFirstInvalid;
	}
}
