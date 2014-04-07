package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.Counter;
import gr.ntua.ivml.mint.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.util.JSONUtils;

import org.apache.log4j.Logger;
import org.hibernate.Query;

public class DataUploadDAO extends DAO<DataUpload, Long> {
	public static final Logger log = Logger.getLogger(DataUploadDAO.class);

	

	
	public List<DataUpload> findByOrganizationUser( Organization o, User u ) {
		List<DataUpload> l = getSession().createQuery( "from DataUpload where organization = :org and  creator = :user order by last_modified DESC" )
			.setEntity("org", o)
			.setEntity("user", u)
			.list();
		return l;
	}
	
	public List<DataUpload> findValidByOrganizationUser( Organization o, User u ) {
		List<DataUpload> l = getSession().createQuery( "from DataUpload where organization = :org and  creator = :user and itemizerStatus=:itemstat order by last_modified DESC" )
			.setEntity("org", o)
			.setEntity("user", u)
			.setString("itemstat", Dataset.ITEMS_OK)
			.list();
		return l;
	}
	
	public List<DataUpload> findByOrganization( Organization o) {
		List<DataUpload> l = getSession().createQuery( "from DataUpload where organization = :org order by last_modified DESC" )
			.setEntity("org", o)
			.list();
		return l;
	}
	
	public List<DataUpload> findValidByOrganization( Organization o) {
		List<DataUpload> l = getSession().createQuery( "from DataUpload where organization = :org and  itemizerStatus=:itemstat order by last_modified DESC" )
			.setEntity("org", o)
			.setString("itemstat", Dataset.ITEMS_OK)
			.list();
		return l;
	}
	
	public List<User> getUploaders( Organization o ) {
		List<User> l = getSession().createQuery( "select distinct(ul) from DataUpload du join du.creator ul where du.organization = :org" )
		.setEntity("org", o)
		.list();
	return l;		
	}

	public List<DataUpload> getByUser( User u ) {
		List<DataUpload> l = getSession().createQuery( "from DataUpload where creator = :user order by created DESC" )
			.setEntity("user", u)
			.list();
		return l;
	}
	
	
	public List<DataUpload> findByOrganizationFolders( Organization o, String... folders ) {
		StringBuilder sb = new StringBuilder();
		ArrayList<String> likeParams = new ArrayList<String>();
		int i =0;
		for( String folder: folders ) {
			String jsonFolder = "%" + JSONUtils.valueToString(folder) + "%";
			sb.append( " and jsonFolders like :param" + i );
			likeParams.add( jsonFolder);
			i++;
		}
		Query q = getSession().createQuery( "from DataUpload where organization = :org " + sb.toString())
				.setEntity("org", o);
		for( int j=0; j<i; j++ ) {
			q.setString("param"+j, likeParams.get(j));
		}
		List<DataUpload> l = 
				q.list();
		return l;
	}
	
	
	public DataUpload findByName( String name ) {
		DataUpload ds = (DataUpload) getSession().createQuery( "from DataUpload where name=:name")
		 .setString("name", name)
		 .uniqueResult();
		return ds;
	}
	
	public void cleanup() {
		final Counter c = new Counter().set(0);
		ApplyI<DataUpload> ap = new ApplyI<DataUpload>() {
			
			@Override
			public void apply(DataUpload du) throws Exception {
				
				try {
					boolean modified = false;
					if( StringUtils.isIn( du.getLoadingStatus(), Dataset.LOADING_HARVEST, Dataset.LOADING_UPLOAD )) {
						du.setLoadingStatus(Dataset.LOADING_FAILED);
						du.logEvent( "Loading interrupted, set to FAILED!");
						modified = true;
					}
					if( du.getItemizerStatus().equals( Dataset.ITEMS_RUNNING )) {
						du.setItemizerStatus(Dataset.ITEMS_FAILED);
						du.logEvent( "Itemizer interrupted, set to FAILED!" );
						DB.getItemDAO().delete("dataset="+du.getDbID());
						modified = true;
					}
					if( du.getSchemaStatus().equals( Dataset.SCHEMA_RUNNING ))  {
						du.setSchemaStatus(Dataset.SCHEMA_FAILED);
						du.logEvent( "Schema validation interrupted, set to FAILED!" );
						modified = true;
					}
					if( du.getNodeIndexerStatus().equals( Dataset.NODES_RUNNING )) {
						du.setNodeIndexerStatus(Dataset.NODES_FAILED);
						du.logEvent( "Node indexing interrupted, set to FAILED!" );
						modified = true;
					}
					if( du.getStatisticStatus().equals( Dataset.STATS_RUNNING)) {
						du.setStatisticStatus(Dataset.STATS_FAILED);
						du.logEvent( "Stats building interrupted, set to FAILED!" );
						DB.getXpathStatsValuesDAO().delete("dataset="+du.getDbID());
						DB.getXpathHolderDAO().delete("dataset="+du.getDbID());
						modified = true;
					}
					if( modified ) c.inc();
					DB.commit();
					
				} catch( Exception e ) {
					du.logEvent("General cleanup problem: " + e.getMessage(), StringUtils.stackTrace(e, null));
					log.error( "General cleanup problem!", e );
				}
			}
		};
		try {
			onAll( ap, null,true );
			log.info( "Cleaned " + c.get() + " DataUploads.");
		} catch( Exception e ) {
			log.error( "Unhandled Exception " , e);
		}
	}
	
	@Override
	public boolean makeTransient( DataUpload du ) {
		// interrupt a running Upload Indexer

		return super.makeTransient(du);
	}

}
