
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.view.Import;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="itemPanel.jsp"),
	@Result(name="success", location="itemPanel.jsp")
})

public class ItemPanel extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());

	public class DisplayItem {
		String name;
		long itemId;
		long uploadId;
		String itemdate;
		String importname;
		boolean transformed;
		boolean direct;
		boolean truncated;
	    boolean valid=true;	
		
	
		
		public String getDate() {
			return itemdate;
		}
		
		public boolean isValid(){
			return valid;
		}
		
				
		public void setTransformed(boolean transformed) {
			this.transformed=transformed;
		}
		
		public boolean getTransformed(){
			return(this.transformed);
		}
		
		public boolean isDirect(){
			return direct;
		}
		
		public boolean isTruncated(){
			return truncated;
		}
		
		public String getShortName() {
			return StringUtils.shorten( name,40,"..", 0 );
			
		}
		
		public String getName() {
			return name;
			
		}
		
		public long getItemId() {
			return itemId;
		}

		public long getUploadId() {
			return uploadId;
		}
		
		public String getImportname() {
			return StringUtils.shorten( importname,15,"..", 0 );
		}
		
		public String getFullImportname() {
			return importname;
		}
	}

	private int startItem, maxItems;
	private int endItem;
	private long organizationId;
	private Organization o;
	private String action="";
	private String actionmessage="";
	private long uploadId=-1;
	private long userId=-1;
	private User u=null;
	private ArrayList<String> itemCheck=new ArrayList();
	public List<DisplayItem> resultItemList;
	private long selMapping=0;
	
	@Action(value="ItemPanel")
	public String execute() throws Exception {
		log.debug("ItemPanel controller");
		if(this.action.equalsIgnoreCase("delete")){
			 boolean del=false;
			
			 for(int i=0;i<itemCheck.size();i++)
			 {  //code to delete nodes
				  log.debug("looking for node to delete:"+itemCheck.get(i));
				   del=true;
				 
			 }
			 if(del){
				 //DB.commit();
				 setActionmessage("Items successfully deleted");
			 }
			
		 }
		if(startItem>this.getItemCount()){
			 setActionmessage("Page does not exist.");
			 startItem=0;}
		return SUCCESS;
	}
	
	public List<Dataset> getImports() {
		//return all datasets with  itemizer status ok
		
		Organization org = DB.getOrganizationDAO().findById(this.organizationId, false);
		Dataset ds=DB.getDatasetDAO().getById(this.uploadId, false);
		
		List<Dataset> du = new ArrayList<Dataset>();
		List<Dataset> tempdu = new ArrayList<Dataset>();
		
		if(this.userId>-1){
			User u = DB.getUserDAO().findById(userId, false);
			 //du=DB.getDataUploadDAO().findValidByOrganizationUser(org, u);
			 tempdu=DB.getDatasetDAO().findByOrganizationUser(org, u);
			 for(Dataset d:tempdu){
				 if(d.getItemizerStatus().equals(Dataset.ITEMS_OK)){
							 du.add(d);
				 }
			 }
			 //check transform status and set boolean here
			 return du;
		}else{
		tempdu= DB.getDatasetDAO().findByOrganization(org);
		 for(Dataset d:tempdu){
			 if(d.getItemizerStatus().equals(Dataset.ITEMS_OK)){
						 du.add(d);
			 }
		 }
		}
		
		return du;
	} 
	

	public void setItemCheck(String itemCheck){
		this.itemCheck=new ArrayList();
		if(itemCheck.trim().length()>0){
			String[] chstr=itemCheck.split(",");
			java.util.Collection<String> c=java.util.Arrays.asList(chstr);
		    this.itemCheck.addAll(c);
		}
	}

	public void setSelMapping(long selMap) {
		this.selMapping = selMap;
	}


	public long getSelMapping(){
		return selMapping;
	}
   
	
    public String getActionmessage(){
		  return(actionmessage);
	}
    
    public void setAction(String action){
		this.action=action;
	}
		  
	public void setActionmessage(String message){
		  this.actionmessage=message;
	}
	  
	public int getStartItem() {
		return startItem;
	}

	public void setStartItem( int startItem ) {
		this.startItem = startItem;
	}

	public int getEndItem() {
		return endItem;
	}
	public int getMaxItems() {
		return maxItems;
	}

	public void setMaxItems(int maxItems) {
		this.maxItems = maxItems;
	}


	public long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(long organizationId) {
		this.organizationId = organizationId;this.o=DB.getOrganizationDAO().findById(organizationId, false);
	}

	public Organization getO(){
		return this.o;
	}

	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}

	public boolean isTran(){
		Dataset du=DB.getDatasetDAO().findById(this.getUploadId(), false);
		return(new Import(du).isTransformed());
		
	}
	
	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
		this.u=DB.getUserDAO().findById(userId, false);
		
	}
	
	public User getU(){
		return this.u;
	}
	
	/**
	 * @return
	 */
	public List<DisplayItem> getItems() {

		List<Dataset> ld = findUploads();
		return itemsByUploads(ld);
	}

	/**
	 * Use the same upload as getItems to find the overall count of items.
	 * @return
	 */
	public int getItemCount() {
		int result=0;

		List<Dataset> ld = findUploads();
		for( Dataset du: ld ) {
			if( du.getItemizerStatus().equals( Dataset.ITEMS_OK))
				result += du.getItemCount();
		}
		return result;
	}
	
	/**
	 * Select which uploads are involved in this item Panel call
	 * Use it to retrieve items or item count !!
	 * 3 cases:
	 *  - For a specific upload: the uploadID > 1
	 *  - For an organization all items (the "normal" case) organizationId > -1 userId == -1
	 *  - For a specific user in an org: organizationId and userId > -1 
	 * @return
	 */
	private List<Dataset> findUploads() {
		List<Dataset> result = Collections.emptyList();
		if( getUploadId() > -1 ) {
			log.debug( "Items by Upload " + uploadId );
			result = new ArrayList<Dataset>();
			Dataset du = DB.getDatasetDAO().getById(getUploadId(), false);
			result.add( du );
		} else {
			Organization org = DB.getOrganizationDAO().findById(organizationId, false);
			if( org != null ) {
				if( getUserId() > -1 ) {
					log.debug( "Items by User " + userId + " and Org " + organizationId );
					User user = DB.getUserDAO().findById(this.userId,false);
					result = DB.getDatasetDAO().findByOrganizationUser(org, user);
				} else {
					log.debug( "Items by Org " + organizationId );
					result = new ArrayList<Dataset>(org.getDataUploads());
				}
			}
		}
		return result;
	}
	


	/**
	 * All items for given list of uploads. Respect startItem and maxItem
	 * @param uploads
	 * @return
	 */
	private List<DisplayItem> itemsByUploads( List<Dataset> uploads ) {

		if( resultItemList != null ) return resultItemList;
		resultItemList = new ArrayList<DisplayItem>();
		long currentStart = 0l;
 		int itemsRead = 0;
		boolean transform=false;
		for( Dataset du: uploads ) {
			transform=false;
			if( du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {
				if( du instanceof Transformation){
					transform=true;
				}
				/*Transformation tr = du.getTransformation();
				if(( tr != null ) && tr.getTransformStatus().equals(Transformation.TRANSFORM_OK)){
					transform=true;
				}
				if( currentStart + du.getItemCount() < startItem ) {
					currentStart += du.getItemCount();
					continue;
				}*/
				List<Item> li = du.getItems(startItem+itemsRead-currentStart, maxItems);
				for( Item x: li ) {
				
					if( itemsRead < maxItems ) {
						DisplayItem di = new DisplayItem();
						di.name = StringUtils.getDefault( x.getLabel(), "<no label>" );
						di.uploadId = du.getDbID();
						di.direct=(du.getSchema()!=null);
						di.transformed=transform;
						
                        di.itemId=x.getDbID();
                        
                        if(transform==true){
                        di.valid=x.isValid();}
						if( x.getLastModified() == null ) 
							di.itemdate="";
						else
							di.itemdate=new SimpleDateFormat("dd/MM/yyyy HH:mm")
											.format(x.getLastModified());
						di.importname=du.getName();
						resultItemList.add( di );
						itemsRead += 1;
					}
				}
				if( itemsRead == maxItems ) break;
				currentStart += du.getItemCount();
			}
		}
		endItem = startItem+resultItemList.size();
		return resultItemList;
	}	
}