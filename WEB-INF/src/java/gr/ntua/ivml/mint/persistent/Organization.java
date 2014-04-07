package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.Publication;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Meta;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.StringUtils;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.log4j.Logger;

public class Organization implements SecurityEnabled {
	
	public static final Logger log = Logger.getLogger(Organization.class);
	
	public long dbID;
	String originalName;
	String englishName;
	
	String shortName;
	String description;

	String urlPattern;
	String address;
	String country;
	String type;
	Organization parentalOrganization;
	User primaryContact;
	boolean publishAllowed = false;
	
	List<Organization> dependantOrganizations = new ArrayList<Organization>();
	List<User> users = new ArrayList<User>();
	List<DataUpload> dataUploads = new ArrayList<DataUpload>();

	// which folders in this organization
	// its a json array of strings
	// the API should not use this directly
	String jsonFolders;
	
	// transient 
	HashSet<String> folders;
	Publication publication;
	//
	// useful functions
	//
	
	public Publication getPublication() {
		if( publication != null ) return publication;
		if( publishAllowed ) {
			String pubClass = Config.get( "publication.implementation" );
			try {
				Class<?> pubStartClass = this.getClass().getClassLoader().loadClass( pubClass );
				// make an object
					Constructor<?> firstChoice = pubStartClass.getConstructor(Organization.class);
					publication = (Publication) firstChoice.newInstance( this );
			} catch( Exception e ) {
				if( StringUtils.empty(pubClass)) {
					log.info( "No Publication configured in 'publication.implementation'");
				} else {
					log.info( "Could not instantiate " + pubClass );
				}
				publication = new Publication( this );
			}
			log.debug( "Use "+ publication.getClass().getCanonicalName() + " for Publication." );
		} else {
			publication = new Publication( this );
		}
		return publication;
	}
	
	private void makeFoldersFromJson() {
		folders = new HashSet<String>();
		if(( jsonFolders == null ) || (jsonFolders.length()==0 )) return; 
		
		for( Object obj:(JSONArray) JSONSerializer.toJSON( jsonFolders)) {
			folders.add( obj.toString() );
		}		
	}
	
	private void makeJsonFromFolders() {
		JSONArray ja = new JSONArray();
		for( String s: folders ) {
			ja.add( s );
		}
		jsonFolders=  ja.toString();
	}
	
	
	public Collection<String> getFolders() {
		if( folders == null ) {
			makeFoldersFromJson();
		}
		ArrayList<String> res = new ArrayList<String>();
		res.addAll(  folders );
		Collections.sort( res );
		return res;
	}
	
		
	public void addFolder( String folder ) {
		if( folders == null ) makeFoldersFromJson();
		folders.add( folder );
		makeJsonFromFolders();
	}
	
	public void removeFolder( String folder ) {
		if( folders == null ) makeFoldersFromJson();
		folders.remove( folder );
		for( DataUpload du: DB.getDataUploadDAO().findByOrganizationFolders(this, folder )) {
			du.removeFolder(folder);
		}
		makeJsonFromFolders();		
	}
	
	public void renameFolder( String oldName, String newName ) {
		if( folders == null ) makeFoldersFromJson();
		if( folders.remove(oldName ))
			addFolder( newName );
		for( DataUpload du: DB.getDataUploadDAO().findByOrganizationFolders(this, oldName )) {
			du.renameFolder(oldName, newName );
		}
	}
	
	/**
	 * Get the organizational targets from the meta table. Or null if there are none.
	 * @return
	 */
	public JsonOrganizationTargets getTargets() {
		String json = Meta.get( this, "targets" );
		if( json != null ) 
			return new JsonOrganizationTargets( json );
		else
			return null;
	}
	
	public void setTargets( JsonOrganizationTargets targets ) {
		if( targets == null ) {
			Meta.delete(this, "targets" );
		} else {
			Meta.put( this, "targets", targets.toJson() );
		}
	}
	
	// convenience 
	public List<Dataset> getPublishedDatasets() {
		return DB.getDatasetDAO().findPublishedByOrganization(this);
	}
	
	
	// temporary getter setter for old attribute
	public String getName() {
		return getEnglishName();
	}
	
	public void setName( String name ) {
		setEnglishName(name);
	}
	
	public String getShortName() {
		return shortName;
	}
	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public List<User> getUsers() {
		return users;
	}
	public void setUsers(List<User> users) {
		this.users = users;
	}
	public List<Organization> getDependantOrganizations() {
		return dependantOrganizations;
	}
	public void setDependantOrganizations(List<Organization> dependantOrganizations) {
		this.dependantOrganizations = dependantOrganizations;
	}
	public long getDbID() {
		return dbID;
	}
	public void setDbID(long dbID) {
		this.dbID = dbID;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Organization getParentalOrganization() {
		return parentalOrganization;
	}
	public void setParentalOrganization(Organization parentalOrganization) {
		this.parentalOrganization = parentalOrganization;
	}
	public User getPrimaryContact() {
		return primaryContact;
	}
	public void setPrimaryContact(User primaryContact) {
		this.primaryContact = primaryContact;
	}


	public String getOriginalName() {
		return originalName;
	}
	public void setOriginalName(String originalName) {
		this.originalName = originalName;
	}
	public String getEnglishName() {
		return englishName;
	}
	public void setEnglishName(String englishName) {
		this.englishName = englishName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getUrlPattern() {
		return urlPattern;
	}

	public void setUrlPattern(String urlPattern) {
		this.urlPattern = urlPattern; 
	}

	public boolean isPublishAllowed() {
		return publishAllowed;
	}

	public void setPublishAllowed(boolean publishAllowed) {
		this.publishAllowed = publishAllowed;
	}

	public List<DataUpload> getDataUploads() {
		return dataUploads;
	}

	public  List<User> getUploaders() {
		return DB.getDataUploadDAO().getUploaders(this);
	}
	
	public void setDataUploads(List<DataUpload> dataUploads) {
		this.dataUploads = dataUploads;
	}

	/**
	 * Return all the dependent organizations all the levels down.
	 * @return
	 */
	public List<Organization> getDependantRecursive() {
		Map<Long, Organization> m = new HashMap<Long,Organization>();
		List<Organization> toDo = new ArrayList<Organization>();
		toDo.addAll(getDependantOrganizations());
		
		while( !toDo.isEmpty()) {
			Organization o = toDo.remove(0);
			if( ! m.containsKey(o.getDbID())) {
				m.put( o.getDbID(), o);
				toDo.addAll( o.getDependantOrganizations());
			}
		}
		toDo.clear();
		toDo.addAll(m.values());
		return toDo;
	}
	
	/**
	 * if find, just look for one
	 * @param find
	 * @return
	 */
	private List<User> directAdmins( boolean find ) {
		List<User> res = new ArrayList<User>();
		for( User u: getUsers() )
			if( u.getMintRole().equalsIgnoreCase("admin")) {
				res.add( u );
				if( find ) break;
			}
		return res;
	}
	
	public String getJsonFolders() {
		return jsonFolders;
	}

	public void setJsonFolders(String jsonFolders) {
		this.jsonFolders = jsonFolders;
	}

	/**
	 * if find, just look for one
	 * @param find
	 * @return
	 */
	private void adminsRecursive( boolean find, List<User> result ) {
		result.addAll( directAdmins( find ));
		if( !result.isEmpty() && find ) return;
		Organization parent = getParentalOrganization();
		if( parent != null )
			parent.adminsRecursive(find, result);
	}
	
	/**
	 * Counts all admins in this organizations and all parents
	 * @return
	 */
	public int getAdmincount() {
		List<User> admins = new ArrayList<User>();
		adminsRecursive(false, admins);
		return admins.size();
	}
	
	/**
	 * Find one admin in this organization or any parent
	 * @return
	 */
	public User findAdmin(){
		List<User> admins = new ArrayList<User>();
		adminsRecursive(true, admins);
		if( admins.isEmpty() ) return null;
		else return admins.get(0);
	}
	
	/**
	 * Returns all admins in this and parent organizations
	 * @return
	 */
	public List<User> getAllAdmins() {
		List<User> admins = new ArrayList<User>();
		adminsRecursive(false, admins);
		return admins;
	}
	
	public List<Mapping> getAllMappings() {
		return DB.getMappingDAO().findByOrganization(this);
	}
	
	public JSONObject toJSON() {
		JSONObject res = new JSONObject()
			.element( "dbID", getDbID())
			.element( "address", getAddress())
			.element( "country", getCountry())
			.element( "englishName" , getEnglishName())
			.element( "description", getDescription())
			.element( "publishAllowed", isPublishAllowed())
			.element( "originalName", getOriginalName())
			.element( "shortName", getShortName())
			.element( "type", getType())
			.element( "urlPattern", getUrlPattern());
		if( getParentalOrganization() != null )
			res.element( "parentalOrganization", new JSONObject()
				.element( "dbID", getParentalOrganization().getDbID()));
		if( getPrimaryContact() != null ) 
			res.element( "primaryContact", new JSONObject() 
				.element( "dbID", getPrimaryContact().getDbID()));
		String targetJson = Meta.get( this, "targets" );
		if( targetJson != null )
			res.element( "targets", JSONObject.fromObject(targetJson));
		return res;
	}
}
