package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.Tuple;
import gr.ntua.ivml.mint.xml.transform.XMLFormatter;
import gr.ntua.ivml.mint.xml.transform.XSLTGenerator;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

public class Transformation extends Dataset implements Lockable {
	public static final Logger log = Logger.getLogger(Transformation.class );
	public static final int REPORT_SIZE_LIMIT = 20000;

	public static final String TRANSFORM_NOT_APPLICABLE = ITEMS_NOT_APPLICABLE;
	public static final String TRANSFORM_OK = ITEMS_OK;
	public static final String TRANSFORM_RUNNING = ITEMS_RUNNING;
	public static final String TRANSFORM_FAILED = ITEMS_FAILED;

	// A Transformation should work either with a mapping
	// or with a Crosswalk
	private Mapping mapping;
	private Crosswalk crosswalk;
	
	private String jsonMapping;
	private Dataset parentDataset;
	private String report;
	private BlobWrap invalid;
	
	
	/**
	 * If the json string or xsl changed, the transformation is stale ...
	 * @return
	 */
	public boolean isStale() {
		if( getMapping() != null ) {
			String newMapping = null;
			if(getMapping().isXsl()) {
				newMapping = getMapping().getXsl(); 
			} else {
				newMapping = getMapping().getJsonString();
			}
			
			if(newMapping !=null ){
				try {
					return !newMapping.equals(getJsonMapping());
				} catch( Exception e ) {
					log.error( "on is stale check", e );
				}
			}
		}
		return false;
	}

	private static Transformation fromDataset(Dataset source ) {
		Transformation tr = new Transformation();
		tr.init(source.getCreator());
		tr.setName(source.getName());
		tr.setParentDataset(source);
		tr.setCreated(new Date());

		return tr;		
	}
	
	public static Transformation fromDataset( Dataset source, Crosswalk c ) {
		Transformation tr = fromDataset( source );
		tr.setCrosswalk(c);
		if( c.getTargetSchema() != null ) tr.setSchema(c.getTargetSchema());
		return tr;
	}
	
	public static Transformation fromDataset( Dataset source, Mapping m ) {
		Transformation tr = fromDataset( source );
		tr.setMapping(m);
		
		if(m.isXsl()) {
			tr.setJsonMapping(m.getXsl());			
		} else {
			tr.setJsonMapping(m.getJsonString());
		}

		XmlSchema schema = m.getTargetSchema();
		if( schema != null ) {
			tr.setSchema(m.getTargetSchema());			
		}
		return tr;
	}
	
	
	@Override
	public String getLockname() {
		// TODO Auto-generated method stub
		String result = "";
		if( mapping != null ) result += mapping.getName();
		result += " on ";
		if( getParentDataset() != null ) result += getParentDataset().getCreated().toString() + " Dataset.";
		return result;
	}
	
	
	@Override
	public void derivedFrom( List<Dataset> result ) {
		result.add( getParentDataset() );
		getParentDataset().derivedFrom(result);
	}
	

	/**
	 * Only append msg if we are not longer than REPORT_SIZE_LIMIT
	 * otherwise clip the report.
	 * @param msg
	 */
	public void limitedUpdateReport( String msg ) {
		if( getReport().length() + msg.length() < REPORT_SIZE_LIMIT ) {
			setReport( getReport() + msg );
		} else if( getReport().length() == REPORT_SIZE_LIMIT ) {
			// do nothing
		} else {
			StringBuilder sb = new StringBuilder();
			sb.append( getReport());
			sb.append( msg );
			String finalMsg = "\n... report clipped here ...";
			sb.insert(REPORT_SIZE_LIMIT-finalMsg.length(), finalMsg );
			sb.setLength( REPORT_SIZE_LIMIT );
		}
	}
	
	public boolean uploadInvalid( File invalidEntries ) {
		BlobWrap bw = new BlobWrap();
		try {
			bw.saveFile( invalidEntries );
			setInvalid(bw);
		} catch( Exception e ) {
			// some error logging
			log.error( "Uploading file failed.", e );
			logEvent( "Invalid entries upload failed.",invalidEntries.getAbsolutePath()+ "\n" + StringUtils.stackTrace(e, null));
			return false;
		}
		return true;
	}
	
	/**
	 * Download stream, will delete the backing tmp file when closed. Format is fixed to
	 * tgz for the time being. 
	 */
	public Tuple<InputStream,Integer> getInvalidStream() throws Exception {
		final File tmpFile = File.createTempFile("Invalid"+getDbID()+"unload", ".tgz" );
		if( !invalid.unload( tmpFile)) return null;
		InputStream is = new java.io.FileInputStream(tmpFile) {
			@Override
			public void close() throws IOException {
				super.close();
				tmpFile.delete();
			}
		};
		return new Tuple<InputStream, Integer>( is, (int)tmpFile.length());
	}
	
	
	/**
	 * Gets XSL either from crosswalk or from Mapping
	 * @return
	 */
	public String getXsl() {
		if( getCrosswalk() != null) return getCrosswalk().getXsl();
		
		if(getMapping().isXsl()) {
			return getMapping().getXsl();
		} else {	
			XSLTGenerator xslt = new XSLTGenerator();
	
			xslt.setItemLevel(getParentDataset().getItemRootXpath().getXpathWithPrefix(true));
			xslt.setImportNamespaces(getParentDataset().getRootHolder().getNamespaces(true));
			xslt.setOption(XSLTGenerator.OPTION_OMIT_XML_DECLARATION, true);
			//xslt.setNamespaces(ftr.getDataUpload().getRootXpath().getNamespaces(true));
			String xsl = XMLFormatter.format(xslt.generateFromString(getMapping().getJsonString()));
	
			return xsl;
		}
	}
	
	
	public String getTargetName() {
		if( getCrosswalk() != null ) return "Crosswalk:"+getCrosswalk().getTargetSchema().getName();
		else if( getMapping() != null ) return "Mapping:" + getMapping().getName();
		else return "No Transformation target.";
	}
	
	@Override
	public JSONObject toJSON() {
		JSONObject res = super.toJSON();	
		res.element("invalidItems",getInvalidItemCount());			
		res.element("validItems", getValidItemCount());
		if (getMapping() != null){
		res.element("mappingUsed",getMapping().getName());
		}
		if (getMapping() != null){
			if( getMapping().getTargetSchema() != null )
				res.element("targetSchema",getMapping().getTargetSchema().getName());
		}
		else if (getCrosswalk() != null ){
			res.element("targetSchema",getCrosswalk().getTargetSchema().getName());
		}
		if (parentDataset !=null){
			res.element("parentDataset",parentDataset.getName());
		
			res.element( "organization", new JSONObject()
				.element( "dbID", parentDataset.getOrganization().getDbID())
				.element( "name", parentDataset.getOrganization().getName()));
		}
		else {
			res.element( "organization", new JSONObject()
				.element( "dbID", getOrganization().getDbID())
				.element( "name", getOrganization().getName()));
		}

		
		res.element( "type", "Transformation");
		return res;
	
	}
	
	/**
	 * Just a rename for the existing field.
	 * @return
	 * @throws Exception
	 */
	public Tuple<InputStream, Integer> getValidStream() throws Exception {
		return getDownloadStream();
	}
	//
	//  Transformation state is stored in itemizer state 
	//
	public String getTransformStatus() {
		return getItemizerStatus();
	}
	
	public void setTransformStatus( String state ) {
		setItemizerStatus(state);
	}
	
	//
	// Getters and Setters
	//
	
	public Dataset getParentDataset() {
		return parentDataset;
	}
	public void setParentDataset(Dataset parentDataset) {
		this.parentDataset = parentDataset;
	}

	public String getJsonMapping() {
		return jsonMapping;
	}
	public void setJsonMapping(String jsonMapping) {
		this.jsonMapping = jsonMapping;
	}
	
	public Crosswalk getCrosswalk() {
		return crosswalk;
	}

	public void setCrosswalk(Crosswalk crosswalk) {
		this.crosswalk = crosswalk;
	}

	public Mapping getMapping() {
		return mapping;
	}
	public void setMapping(Mapping mapping) {
		this.mapping = mapping;
	}

	public String getReport() {
		return report;
	}
	public void setReport(String report) {
		this.report = report;
	}

	public BlobWrap getInvalid() {
		return invalid;
	}
	public void setInvalid(BlobWrap invalid) {
		this.invalid = invalid;
	}
}
