
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.concurrent.XSLTransform;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.LockManager;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	  @Result(name="input", location="transformselection.jsp" ),
	  @Result(name="success", location="successtransform.jsp" ),
	  @Result(name = "lala", type = "redirectAction", location = "DatasetOptions_input.action", params = {"uploadId","${uploadId}","organizationId","${organizationId}","userId","${user.dbID}","actionErrors", "${actionErrors}"}),
	  @Result(name="error", location="transformselection.jsp" )
	})

public class Transform extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	private long selectedMapping;
	private long uploadId;
	private long organizationId;
	private Collection<String> missing=new ArrayList<String>();
	private Collection<String> invalid=new ArrayList<String>();
	private String action="";
	private boolean continueInvalid=false;
	private boolean noitem = false;
	
	public List<Mapping> getAccessibleMappings() {
		List<Mapping> maplist= new ArrayList();
        List<Organization> deporgs=user.getAccessibleOrganizations();
        for(Organization org:deporgs){
        	maplist.addAll(DB.getMappingDAO().findByOrganization(org));
        }
        
		return maplist;
	}
	
	public void setAction(String action){
		this.action=action;
	}

	public void setSelectedMapping(long selectedMapping) {
		this.selectedMapping = selectedMapping;
	}
	
	public void setOrganizationId(long orgId) {
		this.organizationId = orgId;
	}

	public long getOrganizationId() {
		return(this.organizationId);
	}

	public void setContinueInvalid(boolean continv){
		this.continueInvalid=continv;
	}
	
	public long getSelectedMapping(){
		return selectedMapping;
	}
	
	public long getUploadId(){
		return uploadId;
	}
	
	public void setUploadId(long uploadId){
		this.uploadId=uploadId;
	}
	
	public Collection<String> getMissing(){
		return this.missing;
	}
	
	public Collection<String> getInvalid(){
		return this.invalid;
	}
	
	public List<Organization> getOrganizations() {
		return  user.getAccessibleOrganizations();
		
	}
	
	
	@Action("Transform_input")
	@Override
	public String input() throws Exception {
	
		log.debug("Transform input controller");
		if( (user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) || !user.hasRight(User.MODIFY_DATA)) {
			addActionError("No transformation rights");
			return ERROR;
    	}
		
		Dataset du = DB.getDatasetDAO().getById(getUploadId(), false);
		
		if (!du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {
			this.noitem = true;
			addActionError("No item level and label defined.");
			return ERROR;
		}
	
		return "input";
	}
	
	@Action(value="Transform")
	public String execute() throws Exception {

		log.debug("selectedMapping"+getSelectedMapping());
		if(this.action.equalsIgnoreCase("delete")){
			log.debug("delete transfrom request");
			Dataset du = DB.getDatasetDAO().getById(getUploadId(), false);

			List<Transformation> lt = du.getTransformations();
			for( Transformation t: lt )
				DB.getTransformationDAO().makeTransient(t);
			DB.commit();
			return SUCCESS;

		}
		if(this.getSelectedMapping()>0){
			//do your stuff
			log.debug("found mapping for transform");

			// shit locked ?
			// this is just precaution, locks are checked again when taken out
			// by offline action
			Mapping m = DB.getMappingDAO().getById(getSelectedMapping(), false);
			Dataset du = DB.getDatasetDAO().getById(getUploadId(), false);


			LockManager lm = DB.getLockManager();

			if(( m==null ) || ( du==null)) {
				addActionError( "Error!Mapping or Upload missing" );
				return "error";
			}

			if(( lm.isLocked(m) != null ) || ( lm.isLocked( du ) != null )) {
				addActionError( "Error!Mapping or Upload currently locked. Please try to transform later." );
				return "error";
			}

			if(m.isXsl()) {
				if(m.getXsl() == null || m.getXsl().isEmpty()) {
					addActionError(" The <i>'"+m.getName()+"'</i> XSL you are trying to use for transformation is empty.");
					return "error";
				}
			} else {
				if(m.getJsonString()==null || m.getJsonString().isEmpty()){
					addActionError(" The <i>'"+m.getName()+"'</i> mappings you are trying to use for transformation are empty.");
					return "error";
				}
			}

			//missing = MappingSummary.getMissingMappings(m); 
			//invalid = MappingSummary.getInvalidXPaths(du, m);

			//check if this import corresponds to mappings
			if((missing!=null || invalid!=null) && this.continueInvalid==false){
				//now check if LIDO complete

				if(missing!=null && missing.size()>0){
					addActionError(" The <i>'"+m.getName()+"'</i> mappings you are trying to use for transformation are <a href=\"#\" onclick=\"ChangeTabs(0);\"><font color='red'>Missing</font></a> mandatory mappings to LIDO.");

				}
				if(invalid!=null && invalid.size()>0){
					addActionError("The <i>'"+m.getName()+"'</i> mappings you are trying to use for this transformation contain <a href=\"#\" onclick=\"ChangeTabs(1);\"><font color='red'>Invalid</font></a> Xpaths that are not present in this import. ");

				}
				if(this.getActionErrors().size()>0){
					return "error";}
			}

			try{

				boolean locksAquired = false;
				ArrayList<Lock> locks = new ArrayList<Lock>();
				
				// aquire locks for mapping and source datatset
				Lock l1 = lm.directLock(getUser(), "offlineTransformation", du);
				locks.add( l1 );
				if( l1 != null ) {
					Lock l2 = lm.directLock(getUser(), "offlineTransformation", m );
					if( l2 != null ) {
						locksAquired = true;
						locks.add( l2 );
					} else {
						lm.releaseLock(l1);
					}
				}

				if( !locksAquired ) {
					addActionError( "Could not lock Upload or Mapping." );
					return "error";
				}

				/*not deleting old anymore, just deleting ones with the same target schema */
				/*log.debug("deleting old transformations");*/
				List<Transformation> lt = du.getTransformations();
				for( Transformation t: lt ){
					System.out.println(t.getMapping().getTargetSchema());
					if(t.getMapping().getTargetSchema()!=null && m.getTargetSchema()!=null && t.getMapping().getTargetSchema().equals(m.getTargetSchema())) 
						DB.getTransformationDAO().makeTransient(t);
					DB.commit();
				}


				Transformation tr = Transformation.fromDataset(du, m);
				tr.setCreator(du.getCreator());
				tr.setMapping(m);
				// set name for transformation
				if( m.getTargetSchema() != null )
					tr.setName(m.getTargetSchema().getName()+" Transformation");
				else 
					tr.setName( m.getName() + " xsl Transformation" );
				DB.getTransformationDAO().makePersistent(tr);
				DB.commit();

				XSLTransform execTrans = new XSLTransform(tr);
				execTrans.setAquiredLocks(locks);
				Queues.queue( execTrans, "db" );
				return "success";
			} catch (Exception ex) {
				addActionError("Error transforming:" + ex.getMessage());
				return "error";
			}
		} else {
			log.debug("no map found");
			addActionError("Error!Choose the mappings that will be used for this transformation.");
			return "error";
		}
	}

	public boolean getNoitem() {
		return noitem;
	}	
	
	
	
}
