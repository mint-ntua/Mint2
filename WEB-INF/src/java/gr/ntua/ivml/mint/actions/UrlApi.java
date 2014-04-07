package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.XMLUtils;
import gr.ntua.ivml.mint.xml.transform.XSLTGenerator;

import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletRequestAware;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.vocabulary.DCTerms;
import com.hp.hpl.jena.vocabulary.RDF;
import com.opensymphony.xwork2.ActionContext;

@Results({
	@Result(name= "json", location="json.jsp" ),
	@Result(name="error", type="httpheader", params={"error", "404", 
			"errorMessage", "Internal Error"}) 
})

public class UrlApi extends GeneralAction  implements ServletRequestAware{
	private static final Logger log = Logger.getLogger( UrlApi.class );

	private String action;
	private String type;
	private String id;
	
	private String organizationId;
	
	private String datasetId;
	
	private int maxResults = -1;
	private int start = 0;
	private JSONObject json=null;
	
	private HttpServletRequest request;
	private static final String baseURI = "http://mint-projects.image.ntua.gr/dm2e/UrlApi?isApi&";
	
	private Model rdfModel;
	private String xml;
	
	@Action( value="UrlApi"	)
	public String execute() {
		// if( !isApi()) return NONE;
		
		boolean rdf = isRdfRequest();
		if( rdf ) {
			initModelWithNamespace();
		}

		if( "list".equals( action )) {
				if( type.equals( "Dataset")) {
					listDatasets();
				} else if( type.equals( "Mapping")) {
					listMappings( rdf );
				} else if( type.equals( "User")) {
					listUsers( rdf );
				} else if ( type.equals( "Organization")) {
					listOrganizations();
				} else if( type.equals( "DataUpload")) {
					listDataUploads();
				} else if ( type.equals("Transformation")){
				    listTransformations();
				} else if ( type.equals("Publication")){
					listPublications();
				} else if ( type.equals("Derivative")){
					listDerivatives();
				}				
		} else if( !StringUtils.empty( id )) {
			if( "Mappingxsl".equals( type )) {
				singleMappingxsl();
				if( StringUtils.empty(xml)) return ERROR;
				writeXml();
				return NONE;
			} else if( "Dataset".equals( type )) {
				singleDataset( rdf );
			} else if( "Mapping".equals( type )) {
				singleMapping( rdf );
			} else if ( "User".equals( type )) {
				singleUser( rdf );
			} else if( "DataUpload".equals( type )) {
				singleDataUpload( rdf );
			}
		
		} else {
				
			json = new JSONObject()
				.element( "error", "unknown action" );
		}
		
		if( !rdf ) json.element("user", user.toJSON());
		if( rdf && rdfModel != null ) {
			writeModel();
			return NONE;
		} else 
		return "json";
		
	}
	
	
	private void initModelWithNamespace() {
		
		//Create the model
		rdfModel = ModelFactory.createDefaultModel();
		rdfModel.setNsPrefix( "dc" , "http://purl.org/dc/elements/1.1/" );
		rdfModel.setNsPrefix( "ogp", "http://ogp.me/ns#");
		rdfModel.setNsPrefix( "edm", "http://www.europeana.eu/schemas/edm/");
		rdfModel.setNsPrefix( "geo", "http://www.w3.org/2003/01/geo/wgs84_pos#");
		rdfModel.setNsPrefix( "foaf", "http://xmlns.com/foaf/0.1/");
		rdfModel.setNsPrefix( "oo", "http://purl.org/openorg/");
		rdfModel.setNsPrefix( "omnom_xslt", "http://omnom.dm2e.eu/service/xslt#");
		rdfModel.setNsPrefix("omnom", "http://onto.dm2e.eu/omnom/");
		rdfModel.setNsPrefix("omnom_type", "http://onto.dm2e.eu/omnom_type/");
		rdfModel.setNsPrefix("void", "http://rdfs.org/ns/void#");
		rdfModel.setNsPrefix("ore", "http://www.openarchives.org/ore/terms/");
		rdfModel.setNsPrefix("dcterms", "http://purl.org/dc/terms/");
		rdfModel.setNsPrefix("sioc", "http://rdfs.org/sioc/ns#");
		rdfModel.setNsPrefix("rdfs", "http://www.w3.org/2000/01/rdf-schema#");
		rdfModel.setNsPrefix("dct", "http://purl.org/dc/terms/");		
		rdfModel.setNsPrefix("bibo", "http://purl.org/ontology/bibo/");
		rdfModel.setNsPrefix("owl", "http://www.w3.org/2002/07/owl#");
		rdfModel.setNsPrefix("xsd", "http://www.w3.org/2001/XMLSchema#");
		rdfModel.setNsPrefix("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
		rdfModel.setNsPrefix("gr", "http://purl.org/goodrelations/v1#");
		rdfModel.setNsPrefix("sesame", "http://www.openrdf.org/schema/sesame#");
		rdfModel.setNsPrefix("skos", "http://www.w3.org/2004/02/skos/core#");
		rdfModel.setNsPrefix("fn", "http://www.w3.org/2005/xpath-functions#");		
		rdfModel.setNsPrefix("cc", "http://creativecommons.org/ns#");
		rdfModel.setNsPrefix("mint", "http://mint-projects.image.ntua.gr/dm2e/");
	}
	
	private void rdfMapping(  Mapping mapping ) {		
		String omnom = rdfModel.getNsPrefixURI("omnom");
		String omnomType= rdfModel.getNsPrefixURI("omnom_type");
		Resource rMap = rdfModel.createResource(baseURI+"type=Mapping&id="+mapping.getDbID());

		rMap.addProperty(RDF.type,rdfModel.createResource(omnom+"MintMapping"));
		rMap.addProperty(RDF.type,rdfModel.createResource(omnom+"File"));
		rMap.addProperty(rdfModel.createProperty(omnom+"resourceType"), omnomType+"MintMapping");
		Calendar time = Calendar.getInstance();
		time.setTime(mapping.getLastModified() );
		rMap.addProperty( DCTerms.date, rdfModel.createTypedLiteral(time));
		if(( mapping.getOrganization() != null ) &&
			(mapping.getOrganization().getPrimaryContact() != null ))	
			rMap.addProperty( rdfModel.createProperty( omnom+"fileOwner"), baseURI+"type=user&id="+mapping.getOrganization().getPrimaryContact().getDbID());
		rMap.addProperty( rdfModel.createProperty(omnom+"mintMappingAsXsl" ), baseURI+"type=Mappingxsl&id="+mapping.getDbID());
		
		List<Dataset> dsl = mapping.getRecentDatasets();
		if(( dsl != null ) && ( dsl.size() >0 )) {
			Dataset lastDs = dsl.get( dsl.size()-1);
			rMap.addProperty( rdfModel.createProperty( omnom+"mintMappingBasedOn"), baseURI+"type=Dataset&id="+lastDs.getDbID() );
		}
		/*
		 * 
    omnom:hasVersion <$MINT/mapping/1234/2013-04-03T02:34:56Z> .
		 * 
		 */
	}

	public void singleMapping( boolean rdf ) {
		try {
			Long dbID = Long.parseLong(id);
			Mapping mp = DB.getMappingDAO().getById(dbID, false);
			if( rdf ) {
				rdfMapping( mp );
			} else {
				json = new JSONObject() 
				.element( "result", mp.toJSON());
			}
		} catch( Exception e ) {
			log.error( "No plan", e );
		}
		
	}
	
	
	public void singleMappingxsl() {
		// TODO: when there is a version in the URL, retrieve that xsl from meta table
		// TODO: create a version in the meta table
		try {
			Long dbID = Long.parseLong(id);
			Mapping mp = DB.getMappingDAO().getById(dbID, false);

			List<Dataset> dsl = mp.getRecentDatasets();
			if( dsl.size() >0 ) {
				Dataset lastDs = dsl.get( dsl.size()-1);
				
					XSLTGenerator xslt = new XSLTGenerator();
					XpathHolder itemPath = lastDs.getItemRootXpath();

					xslt.setItemLevel(itemPath.getXpathWithPrefix(true));
					xslt.setImportNamespaces(lastDs.getRootHolder().getNamespaces(true));		
					String mappings = mp.getJsonString();
					String xsl = xslt.generateFromString(mappings);

					if(xsl != null && xsl.trim().length() > 0) {
						xsl = XMLUtils.format(xsl);
						xml = xsl;
					} else {
						log.error( "Some problem with xsl generation" );
					}
			} else {
				log.info( "No dataset for this mapping, that shouldn't happen.");
			}
		} catch( Exception e ) {
			log.info( "Some exception in xsl generation.", e );
		}
	}
	
	
	public void singleDataset( boolean rdf ) {
		try {
			Long dbID = Long.parseLong(id);
			Dataset ds = DB.getDatasetDAO().getById(dbID, false);
			if( rdf ) {
				rdfDataset( ds );
			} else {
				json = new JSONObject() 
					.element( "result", ds.toJSON());
			}
		} catch( Exception e ) {
			log.error( "No plan", e );
		}
	}
	
	
	private void rdfDataset( Dataset ds ) {
		String omnom = rdfModel.getNsPrefixURI("omnom");
		String omnomType= rdfModel.getNsPrefixURI("omnom_type");
		Resource rMap = rdfModel.createResource(baseURI+"type=Dataset&id="+ds.getDbID());

		rMap.addProperty(RDF.type,rdfModel.createResource(omnom+"File"));
		rMap.addProperty(rdfModel.createProperty(omnom+"resourceType"), omnomType+"XML");
		Calendar time = Calendar.getInstance();
		time.setTime(ds.getCreated());
		rMap.addProperty( DCTerms.date, rdfModel.createTypedLiteral(time));
		rMap.addProperty( rdfModel.createProperty( omnom+"fileOwner"), baseURI+"type=User&id="+ ds.getCreator().getDbID());
	}
	
	private void rdfDataUpload( DataUpload du ) {
		rdfDataset( du );
	}
	
	
	private boolean isRdfRequest() {
		HttpServletRequest req = getServletRequest();
		if( req == null ) return false;
		String accept = req.getHeader("Accept");
		return (accept.contains( "application/x-turtle" )
				|| accept.contains( "application/rdf+xml")
				|| accept.contains("text/turtle")
				|| accept.contains( "text/rdf+n3" ));
	}
	
	//The built-in languages are "RDF/XML", "RDF/XML-ABBREV", "N-TRIPLE", "N3" and "TURTLE". In addition, for N3 output the language can be specified as: "N3-PP", "N3-PLAIN" or "N3-TRIPLE", which controls the style of N3 produced.
	private void writeModel() {
		String format = "N-TRIPLE";
		String accept = getServletRequest().getHeader("Accept");
		
		if( accept.contains( "application/x-turtle" ))
			format="TURTLE";
		else if( accept.contains( "application/rdf+xml"))
			format = "RDF/XML";
		else if( accept.contains("text/turtle"))
			format = "TURTLE";
		else if( accept.contains( "text/rdf+n3" ))
			format = "N3";
			
		try {
			OutputStream out = ServletActionContext.getResponse().getOutputStream();
			rdfModel.write(out, format);
			out.flush();
		} catch( Exception e ) {
			log.error( e );
		}
	}
	
	private void writeXml( ) {
		try {
			HttpServletResponse hr = ServletActionContext.getResponse();
			hr.addHeader("contentType", "application/xml; charset=UTF-8");
			PrintWriter pw = new PrintWriter( new OutputStreamWriter( hr.getOutputStream(), "UTF-8" ));
			pw.print(xml);
			pw.flush();
		} catch( Exception e ) {
			log.error( "Some problem", e );
		}
	}
	
	public User getUser() {
		if(user == null) {
			Map<String, Object> session = ActionContext.getContext().getSession();
			user = (User) session.get("user");
		}
		
		return user;
	}

	public void rdfUser( User user ) {
		String omnom = rdfModel.getNsPrefixURI("omnom");
		String omnomType= rdfModel.getNsPrefixURI("omnom_type");

	}
	
	private void singleUser( boolean rdf ) {
		try {
			Long dbID = Long.parseLong(id);
			User user = DB.getUserDAO().getById(dbID, false);
			if( rdf ) {
				rdfUser( user );
			} else {
				// not yet implemented
			}
		} catch( Exception e ) {
			log.error( "No plan", e );
		}
		
	}
	
	private void singleDataUpload( boolean rdf ) {
		try {
			Long dbID = Long.parseLong(id);
			DataUpload du = DB.getDataUploadDAO().getById(dbID, false);
			if( rdf ) {
				rdfDataUpload( du );
			} else {
				json = new JSONObject()
					.element( "result" , du.toJSON());
			}
		} catch( Exception e ) {
			log.error( "No plan", e );
		}
	}
 
//	public  JSONObject listTransformations() {
//		List<Transformation> res = DB.getTransformationDAO().findAll();	
//		JSONArray arr = new JSONArray();
//		for( Transformation ts: res ) {
//			if(this.organizationId == null ||  ts.getParentDataset().getOrganization().getDbID()==Long.parseLong(organizationId)) {
//				arr.add( ts.toJSON());
//			}
//		}
//		json = new JSONObject()
//			.element( "result", arr );
//		return json;
//	}		
//	
//	public JSONObject listDatasets() {
//	List<Dataset> res = DB.getDatasetDAO().pageAll(start, maxResults);
//		
//		JSONArray arr = new JSONArray();
//		for( Dataset ds: res ) {
//			if(this.organizationId == null ||    ds.getOrganization().getDbID()==Long.parseLong(organizationId)){				
//				arr.add( ds.toJSON());
//			}
//		}
//		json = new JSONObject()
//			.element( "result", arr );
//		
//		return json;
//	}
//	
//	public JSONObject listDerivatives() {		
//		JSONArray arr = new JSONArray();
//		if (DB.getDatasetDAO().getById(Long.parseLong(this.datasetId), false) != null){
//			Dataset dataset = DB.getDatasetDAO().getById(Long.parseLong(this.datasetId), false);
//			Collection<Dataset> der= dataset.getDerived();						
//			for( Dataset ds: der ) {
//				if(this.organizationId == null || ds.getOrganization().getDbID()==Long.parseLong(organizationId)){				
//					arr.add( ds.toJSON());
//				}
//			}
//			
//		}
//		json = new JSONObject()
//			.element( "result", arr );
//		return json;
//	} 
//	
//	public void listMappings( boolean rdf ) {
//		JSONArray arr = new JSONArray();
//		List<Mapping> res = null;
//		
//		if(getUser().hasRight(User.SUPER_USER)) {
//			res = DB.getMappingDAO().pageAll( start, maxResults );
//		} else {
//			Organization organization = getUser().getOrganization();
//			res = DB.getMappingDAO().findByOrganization(organization);
//		}
//		
//		if(res != null) {
//			for( Mapping m: res ) {
//				if (this.organizationId == null || m.getOrganization().getDbID()==Long.parseLong(organizationId)){
//					if( rdf ) rdfMapping( m );
//					else arr.add( m.toJSON());
//				}
//			}
//			if( ! rdf )
//				json = new JSONObject()
//			.element( "result", arr );
//		}
//	}
//	
//	// compatibility method
//	public JSONObject listMappings() {
//		listMappings( false );
//		return json;
//	}
//	
//	public JSONObject listUsers( boolean rdf ) {
//		List<User> res = DB.getUserDAO().pageAll( start, maxResults );
//		
//		JSONArray arr = new JSONArray();
//		for( User u: res ) {
//			if (this.organizationId==null || u.getOrganization().getDbID()==Long.parseLong(organizationId)){				
//				arr.add( u.toJSON());
//			}
//		}		
//		json = new JSONObject()
//			.element( "result", arr );
//		
//		return json;
//	}
//
//	
//	public JSONObject listOrganizations() {
//		List<Organization> res = DB.getOrganizationDAO().pageAll( start, maxResults );
//		JSONArray arr = new JSONArray();
//		for( Organization org: res ){
//			if (this.organizationId == null || org.getDbID()==Long.parseLong(organizationId)){			
//				arr.add( org.toJSON());
//			}
//			
//		}
//		
//		json = new JSONObject()
//			.element( "result", arr );
//	
//		return json;
//
//	}
//	
//	public JSONObject listDataUploads() {
//		List<DataUpload> res = DB.getDataUploadDAO().pageAll( start, maxResults );
//		JSONArray arr = new JSONArray();
//		for( DataUpload du: res ){
//			if ( this.organizationId==null || du.getOrganization().getDbID()==Long.parseLong(organizationId)){				
//				arr.add( du.toJSON());
//			}
//		}
//		json = new JSONObject()
//			.element( "result", arr );
//		
//		return json;
//		
//	}
//	
//	public JSONObject listPublications() {
//		List<DataUpload> res = DB.getDataUploadDAO().pageAll( start, maxResults );
//		JSONArray arr = new JSONArray();
//		for( DataUpload du: res ){
//			if (du.getPublicationStatus().equals("OK")){
//				if ( this.organizationId==null || du.getOrganization().getDbID()==Long.parseLong(organizationId)){				
//					arr.add( du.toJSON());
//				}
//			}
//		}
//		json = new JSONObject()
//			.element( "result", arr );
//		
//		return json;
//		
//	}
	
		public JSONObject listPublications() {
		List<DataUpload> res;
		if (this.organizationId != null){
		 res = DB.getDataUploadDAO().findByOrganization(DB.getOrganizationDAO().getById(Long.parseLong(organizationId),false));
		}
		else {
			res  = DB.getDataUploadDAO().pageAll( start, maxResults );	
		}
		JSONArray arr = new JSONArray();
		for( DataUpload du: res ){
			//if ( this.organizationId==null || du.getOrganization().getDbID()==Long.parseLong(organizationId)){				
			if (du.getPublicationStatus().equals("OK")){	
				arr.add( du.toJSON());
			}
			//}
		}
		json = new JSONObject()
			.element( "result", arr );
		
		return json;
	}
	
	public  JSONObject listTransformations() {
		List<DataUpload> res;
		List<Transformation> lala = new ArrayList<Transformation>();
		if (this.organizationId == null){
			res = DB.getDataUploadDAO().pageAll(start, maxResults);
		}
		else{
			res = DB.getDataUploadDAO().findByOrganization(DB.getOrganizationDAO().findById(Long.parseLong(this.organizationId), false));
		}
		JSONArray arr = new JSONArray();
		for( Dataset ds: res ) {
			lala.addAll(ds.getTransformations());
			//if(this.organizationId == null ||    ds.getOrganization().getDbID()==Long.parseLong(organizationId)){				
				
		//	}		
		}
		for(Transformation tf:lala){
			arr.add( tf.toJSON());
		}
		json = new JSONObject()
			.element( "result", arr );
		
		return json;
	}		
	
	public JSONObject listDatasets() {
		List<Dataset> res;
		if (this.organizationId == null){
			res = DB.getDatasetDAO().pageAll(start, maxResults);
		}
		else{
			res = DB.getDatasetDAO().findByOrganization(DB.getOrganizationDAO().findById(Long.parseLong(this.organizationId), false));
		}
		JSONArray arr = new JSONArray();
		for( Dataset ds: res ) {
			
			//if(this.organizationId == null ||    ds.getOrganization().getDbID()==Long.parseLong(organizationId)){				
				arr.add( ds.toJSON());
		//	}
		}
		json = new JSONObject()
			.element( "result", arr );
		
		return json;
	}
	
	public JSONObject listDerivatives() {		
		JSONArray arr = new JSONArray();
		if (DB.getDatasetDAO().getById(Long.parseLong(this.datasetId), false) != null){
			Dataset dataset = DB.getDatasetDAO().getById(Long.parseLong(this.datasetId), false);
			Collection<Dataset> der= dataset.getDerived();						
			for( Dataset ds: der ) {
				if(this.organizationId == null || ds.getOrganization().getDbID()==Long.parseLong(organizationId)){				
					arr.add( ds.toJSON());
				}
			}
			
		}
		json = new JSONObject()
			.element( "result", arr );
		return json;
	} 
	/*
	public void listMappings( boolean rdf ) {
		JSONArray arr = new JSONArray();
		List<Mapping> res = null;
		
		if(getUser().hasRight(User.SUPER_USER)) {
			res = DB.getMappingDAO().pageAll( start, maxResults );
		} else {
			Organization organization = getUser().getOrganization();
			res = DB.getMappingDAO().findByOrganization(organization);
		}
		
		if(res != null) {
			for( Mapping m: res ) {
				if (this.organizationId == null || m.getOrganization().getDbID()==Long.parseLong(organizationId)){
					if( rdf ) rdfMapping( m );
					else arr.add( m.toJSON());
				}
			}
			if( ! rdf )
				json = new JSONObject()
			.element( "result", arr );
		}
	}*/
	
	public void listMappings(boolean rdf) {

		List<Mapping> res = null;
		if (this.organizationId == null) {
			res = DB.getMappingDAO().pageAll(start, maxResults);
		} else {
			res = DB.getMappingDAO().findByOrganization(
					DB.getOrganizationDAO().findById(
							Long.parseLong(this.organizationId), false));
		}

		JSONArray arr = new JSONArray();

		/*
		 * if(getUser().hasRight(User.SUPER_USER)) { res =
		 * DB.getMappingDAO().pageAll( start, maxResults ); } else {
		 * Organization organization = getUser().getOrganization(); res =
		 * DB.getMappingDAO().findByOrganization(organization); }
		 */

		if (rdf) {
			if (res != null) {
				for (Mapping m : res) {
					rdfMapping(m);
				}
			}
		}
		if (!rdf) {
			for (Mapping m : res) {
				arr.add(m.toJSON());
			}
		}
		json = new JSONObject().element("result", arr);

	}
	
	
	// compatibility method
	public JSONObject listMappings() {
		listMappings( false );
		return json;
	}
	
	public JSONObject listUsers( boolean rdf ) {
		
		List<User> res = DB.getUserDAO().pageAll( start, maxResults );
		
		JSONArray arr = new JSONArray();
		for( User u: res ) {
			if (this.organizationId==null || u.getOrganization().getDbID()==Long.parseLong(organizationId)){				
				arr.add( u.toJSON());
			}
		}		
		json = new JSONObject()
			.element( "result", arr );
		
		return json;
	}

	
	public JSONObject listOrganizations() {
		List<Organization> res = null ;
		JSONArray arr = new JSONArray();
		if (this.organizationId == null){
		 res = DB.getOrganizationDAO().pageAll( start, maxResults );
		 for( Organization org: res ){
				arr.add( org.toJSON());	
		 }
		}
		else {
			arr.add(DB.getOrganizationDAO().getById(Long.parseLong(this.organizationId), false).toJSON());
		}
	
		
		json = new JSONObject()
			.element( "result", arr );
	
		return json;

	}
	
	public JSONObject listDataUploads() {
		List<DataUpload> res;
		if (this.organizationId != null){
		 res = DB.getDataUploadDAO().findByOrganization(DB.getOrganizationDAO().getById(Long.parseLong(organizationId),false));
		}
		else {
			res  = DB.getDataUploadDAO().pageAll( start, maxResults );	
		}
		JSONArray arr = new JSONArray();
		for( DataUpload du: res ){
			//if ( this.organizationId==null || du.getOrganization().getDbID()==Long.parseLong(organizationId)){				
				arr.add( du.toJSON());
			//}
		}
		json = new JSONObject()
			.element( "result", arr );
		
		return json;
		
	}
	
	
	public void setAction( String action) {
		this.action = action;
	}
	
	public void setType( String type ) {
		this.type = type;
	}
	
	public void setStart( int start ) {
		this.start = start;
	}
	
	public void setMaxResults( int max ) {
		this.maxResults = max;
	}
	
	public JSONObject getJson() {
		return json;
	}
	
	public String getDatasetId() {
		return datasetId;
	}

	public String getOrganizationId() {
		return organizationId;
	}

	public void setDatasetId(String datasetId) {
		this.datasetId = datasetId;
	}

	public void setOrganizationId(String orgId) {
		this.organizationId = orgId;
	}

	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	public HttpServletRequest getServletRequest() {
		return this.request;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
}
