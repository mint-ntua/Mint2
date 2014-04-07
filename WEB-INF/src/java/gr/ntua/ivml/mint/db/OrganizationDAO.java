package gr.ntua.ivml.mint.db;


import gr.ntua.ivml.mint.persistent.Organization;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.compass.core.xml.XmlObject;

public class OrganizationDAO extends DAO<Organization, Long> {
	private HashMap<Long, Long> xmlToOrgId = new HashMap<Long,Long>();
	
	public List<Organization> findPrimary() {
		List<Organization> result = Collections.emptyList();
		try {
			result = getSession().createQuery(" from Organization where parentalOrganization is null" ).list();
		} catch( Exception e ) {
			log.error( "Problems: ", e );
		}
		return result;
	}
	
	public	Organization findByName( String name ) {
		Organization result = null;
		try {
			result = (Organization) getSession()
				.createQuery(" from Organization where shortName=:name" )
				.setString("name", name )
				.uniqueResult();
		} catch( Exception e ) {
			log.error( "Problems: ", e );
		}
		return result;
	}

	
	public List<Organization> findByCountry( String country ) {
		List<Organization> result = null;
		result = getSession()
			.createQuery("from Organization where country=:country " 
						+" order by englishName" )
			.setString("country", country ) 
			.list();
		return result;
	}
	
	public List<Organization> findAll() {
		List<Organization> result = null;
		result = getSession()
			.createQuery("from Organization " 
						+" order by englishName" )
			.list();
		return result;
	}
}
