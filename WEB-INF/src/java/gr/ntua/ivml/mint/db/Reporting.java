package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.util.Tuple;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Static queries for a data overview of the system
 * @author Arne Stabenau 
 *
 */
public class Reporting {
	public static class Country {
		public String name;
		public int uploadedItems;
		public int publishedItems;
		
		// Tuple<items_count,validated_item_count>
		public Map<String, Tuple<Integer,Integer>> schemaCheckedItems = new HashMap<String, Tuple<Integer, Integer>>(); 
	}
	
	public static class Organization {
		public String organizationName;
		public int uploadedItems;
		public int publishedItems;
		public int organizationId;
		public String country;
		// Tuple<items_count,validated_item_count>
		public Map<String, Tuple<Integer,Integer>> schemaCheckedItems = new HashMap<String, Tuple<Integer, Integer>>();  
	}
	
	
	//Countries and the counts that belong to them
	public static List<Country> getCountries() {
		Map<String,Country> countries = new HashMap<String, Country>();
		// uploads and published counts 
		List<Object[]> res = DB.getSession().createSQLQuery("select o.country, sum( ds.item_count ) as item_count, " +
				"sum( ds.published_item_count ) as published_item_count " +
				"from data_upload du, dataset ds, organization o " +
				"where du.dataset_id = ds.dataset_id " +
				"and o.organization_id = ds.organization_id " +
				"and ds.item_count>0 " +
				"group by o.country" )
				.list();
		for( Object[] row: res ) {
			Country co = new Country();
			co.name = (String)row[0];
			co.uploadedItems = ((BigInteger)row[1]).intValue();
			co.publishedItems = ((BigInteger)row[2]).intValue();
			countries.put( co.name, co);
		}
		// per schema counts
		res = DB.getSession().createSQLQuery("select o.country, xs.name, sum( ds.valid_item_count ) as valid_item_count, " +
				"sum( ds.item_count ) as item_count " +
				"from organization o, dataset ds " +
				"left join xml_schema xs " +
				"on xs.xml_schema_id = ds.xml_schema_id " +
				"where o.organization_id = ds.organization_id " +
				"and ds.item_count>0 " +
				"and xs.name is not null " +
				"group by o.country, xs.name" )
				.list();
		for( Object[] row: res ) {
			Country co = countries.get( row[0] );
			String schemaName = (String) row[1];
			Tuple<Integer,Integer> nums = new Tuple<Integer,Integer>(((BigInteger)row[3]).intValue(), 
					((BigInteger)row[2]).intValue());
			co.schemaCheckedItems.put( schemaName, nums );
		}
		
		Country[] cos = countries.values().toArray( new Country[0] );
		
		Arrays.sort(cos, new Comparator<Country>() {
			@Override
			public int compare(Country arg0, Country arg1) {
				// TODO Auto-generated method stub
				return arg0.name.compareTo(arg1.name);
			}
			
		});
		return Arrays.asList( cos );
	}
	
	// Organizations (per Country) with the item counts
	public static Map<String, List<Organization>> getOrganizations() {
		Map<String, List<Organization>> res = new HashMap<String, List<Organization>>();
		Map<Integer, Organization> allOrgs = new HashMap<Integer, Organization>();
		
		List<Object[]> qres = DB.getSession().createSQLQuery("select o.organization_id, o.country, o.english_name, sum( ds.item_count ) as item_count, " +
				"sum( ds.published_item_count ) as published_item_count " +
				"from organization o, data_upload du, dataset ds " +
				"where du.dataset_id = ds.dataset_id " +
				"and o.organization_id = ds.organization_id " +
				"and ds.item_count>0 " +
				"group by o.organization_id, o.english_name, o.country" )
				.list();
		for( Object[] row: qres ) {
			Organization org = new Organization();
			org.organizationId = (Integer)row[0];
			org.country = (String) row[1];
			org.organizationName = (String) row[2];
			org.uploadedItems =  ((BigInteger) row[3]).intValue();
			org.publishedItems = ((BigInteger) row[4]).intValue();
			allOrgs.put( org.organizationId, org );
		}
		
		// per schema counts
		qres = DB.getSession().createSQLQuery("select o.organization_id, xs.name, sum( ds.valid_item_count ) as valid_item_count, " +
				"sum( ds.item_count ) as item_count " +
				"from organization o, dataset ds " +
				"left join xml_schema xs " +
				"on xs.xml_schema_id = ds.xml_schema_id " +
				"where o.organization_id = ds.organization_id " +
				"and ds.item_count>0 " +
				"and xs.name is not null " +
				"group by o.organization_id, xs.name" )
				.list();
		for( Object[] row: qres ) {
			Organization org = allOrgs.get( (Integer)row[0] );
			
			String schemaName = (String) row[1];
			Tuple<Integer,Integer> nums = new Tuple<Integer,Integer>(((BigInteger)row[3]).intValue(), 
					((BigInteger)row[2]).intValue());
			org.schemaCheckedItems.put( schemaName, nums );
		}

		// collect the results
		for( Organization org: allOrgs.values()) {
			List<Organization> lo = res.get( org.country );
			if( lo == null ) {
				lo = new ArrayList<Organization>();
				res.put( org.country, lo);
			}
			lo.add( org );
		}
		
		for( List<Organization> lo: res.values() ) {
			Collections.sort( lo, new Comparator<Organization>() {
				@Override
				public int compare(Organization o1, Organization o2) {
					return o1.organizationName.compareTo(o2.organizationName);
				}
			});
		}
		return res;

	}
}
