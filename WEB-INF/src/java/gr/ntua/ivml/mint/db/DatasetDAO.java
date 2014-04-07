package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;

import java.util.List;

import org.apache.log4j.Logger;

public class DatasetDAO extends DAO<Dataset, Long> {
	public static final Logger log = Logger.getLogger(DatasetDAO.class);
		
	public List<Dataset> findByOrganizationUser( Organization o, User u ) {
		List<Dataset> l = getSession().createQuery( "from Dataset where organization = :org and creator = :user order by created DESC" )
			.setEntity("org", o)
			.setEntity("user", u)
			.list();
		return l;
	}
	
	public List<Dataset> findByOrganization( Organization o) {
		List<Dataset> l = getSession().createQuery( "from Dataset where organization = :org order by created DESC" )
			.setEntity("org", o)
			.list();
		return l;
	}
	
	public Dataset findByName( String name ) {
		Dataset ds = (Dataset) getSession().createQuery( "from Dataset where name=:name")
		 .setString("name", name)
		 .uniqueResult();
		return ds;
	}
	
	public List<Dataset> findPublishedByOrganization( Organization org ) {
		List<Dataset> l = getSession().createQuery( "from Dataset where organization = :org and publicationStatus=:stat" )
		.setEntity("org", org)
		.setString( "stat", Dataset.PUBLICATION_OK)
		.list();
		return l;
	}
	
	public void cleanup() {
		DB.getDataUploadDAO().cleanup();
		DB.getTransformationDAO().cleanup();
	}
}
