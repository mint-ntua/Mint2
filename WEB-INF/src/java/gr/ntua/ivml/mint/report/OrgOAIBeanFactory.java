package gr.ntua.ivml.mint.report;

import gr.ntua.ivml.mint.actions.UrlApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class OrgOAIBeanFactory {
	
	String organizationId ;
	String projectName;
	OaijsonFetcher oaijsonFetcher ;
	ProjectOAIBean projectstatus;
	//List<OrgOAIBean> orgsoaibeans ;= new ArrayList<OrgOAIBean>();
	HashMap<String, HashMap<String,String>> organizationitemnumberpernamespace;
	
	
	
	protected final Logger log = Logger.getLogger(getClass());
	
	
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public String getOrganizationId() {
		return organizationId;
	}
	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}
	public OaijsonFetcher getOaijsonFetcher() {
		return oaijsonFetcher;
	}
	public void setOaijsonFetcher(OaijsonFetcher oaijsonFetcher) {
		this.oaijsonFetcher = oaijsonFetcher;
	}
	
	public OrgOAIBeanFactory() {
		super();
	//	this.organizationId = organizationId;
		this.oaijsonFetcher = new OaijsonFetcher(this.organizationId);
		this.projectstatus = getProjectOAIBean();
		this.organizationitemnumberpernamespace = getOrganizationOaiItemsPerNamespace();
				
	}
	
	public OrgOAIBeanFactory(String projectName) {
		super();
	//	this.organizationId = organizationId;
		this.projectName = projectName;
		this.oaijsonFetcher = new OaijsonFetcher(this.projectName,this.organizationId);	
		this.projectstatus = getProjectOAIBean();
		this.organizationitemnumberpernamespace = getOrganizationOaiItemsPerNamespace();
	}
	
	
	
	public ProjectOAIBean getProjectstatus() {
		return projectstatus;
	}
	
	
	
	/*public List<OrgOAIBean> getOrgsoaibeans() {
		return orgsoaibeans;
	}*/
	
	
	public HashMap<String, HashMap<String, String>> getOrganizationitemnumberpernamespace() {
		return organizationitemnumberpernamespace;
	}
	
	
	
	public ProjectOAIBean getProjectOAIBean(){
		List<String> namespaces = new ArrayList<String>(); 
		JSONObject object = oaijsonFetcher.getProjectJson();
		System.out.println("DEBUG, OAI FETCHED FOR PROJECT"+object);
		if (object==null){
			Integer unique = 0;
			Integer duplicates = 0;
			Integer publications = 0;
			ProjectOAIBean projectBean = new ProjectOAIBean(projectName, unique, duplicates,publications,namespaces);
			return projectBean;
			//return null;
		}
		JSONArray array = object.getJSONArray("namespaces");
		
		Iterator it = array.iterator();
		while (it.hasNext()){
			JSONObject item = (JSONObject) it.next();
			namespaces.add(item.getString("prefix"));		
		}

		Integer unique = Integer.parseInt(object.getString("unique"));
		Integer duplicates = Integer.parseInt(object.getString("duplicates"));
		Integer publications = Integer.parseInt(object.getString("publications"));
		ProjectOAIBean projectBean = new ProjectOAIBean(projectName, unique, duplicates,publications,namespaces);
		return projectBean;
	}
	
	
	public HashMap<String, HashMap<String,String>> getOrganizationOaiItemsPerNamespace(){
				
		HashMap<String,String> amap  = new  HashMap<String,String>();
		
		HashMap<String, HashMap<String,String>> map  = new HashMap<String,HashMap<String,String>>();
	
		
		List<String> listofnamespaces = projectstatus.getTypes();
		Iterator<String> it = listofnamespaces.iterator();
		while (it.hasNext()){
			String namespace = (String) it.next().toString(); 
			JSONObject object = oaijsonFetcher.getOrgJson(namespace);
			Iterator jsit = object.keys();
			while (jsit.hasNext()){
				String key = (String)jsit.next();
				amap.put(key, (String) object.get(key).toString());
			}
			map.put(namespace, amap);
		}
		
		
		return map;
		
		
		}
	
	
	public List<OrgOAIBean> getOrgOAIBeans2(String OrganizationId){
		List<OrgOAIBean> orgsoaibeans = new ArrayList<OrgOAIBean>();
		Iterator it = organizationitemnumberpernamespace.entrySet().iterator();
		while (it.hasNext()){
			Map.Entry pairs = (Map.Entry)it.next();
			String namespace= pairs.getKey().toString();
			Map itemCountmap = (Map) pairs.getValue();
			if (itemCountmap.containsKey(OrganizationId)){
				Integer unique =  Integer.parseInt(itemCountmap.get(OrganizationId).toString()); //object.getInt(this.organizationId);
				UrlApi api = new UrlApi();
				api.setOrganizationId(this.organizationId);		
				JSONObject json = api.listOrganizations();
				JSONArray result = (JSONArray) json.get("result");
				Iterator ait = result.iterator();
				String organizationName = null;
				while (ait.hasNext()){
					
					JSONObject jsonObject = (JSONObject) ait.next();
					organizationName =(String) jsonObject.get("englishName");
				}
				OrgOAIBean orgoaiBean = new OrgOAIBean(organizationName, namespace, this.organizationId, unique);
				orgsoaibeans.add(orgoaiBean);
			}
			else{
				Integer unique = 0;
				UrlApi api = new UrlApi();
				api.setOrganizationId(this.organizationId);		
				JSONObject json = api.listOrganizations();
				JSONArray result = (JSONArray) json.get("result");
				Iterator ait = result.iterator();
				String organizationName = null;
				while (ait.hasNext()){
					
					JSONObject jsonObject = (JSONObject) ait.next();
					organizationName =(String) jsonObject.get("englishName");
				}
				OrgOAIBean orgoaiBean = new OrgOAIBean(organizationName, namespace, this.organizationId, unique);
				orgsoaibeans.add(orgoaiBean);
			}
		}
		
		return orgsoaibeans;

	}
	
	
	

	
	public Integer getItemCount(String organizationId){
		Integer count=0;
		if (organizationitemnumberpernamespace.containsKey("rdf")){
			 Map organizationmap = this.organizationitemnumberpernamespace.get("rdf");
			 if (organizationmap.containsKey(organizationId)){
				 count = Integer.parseInt(organizationmap.get(organizationId).toString());
			 }
				
		}
		return count;
	}
	


}
