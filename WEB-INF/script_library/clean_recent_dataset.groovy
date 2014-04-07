import gr.ntua.ivml.mint.util.Tuple;
import gr.ntua.ivml.mint.persistent.*
import gr.ntua.ivml.mint.db.*

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

// remove recent datasets from mapping entries in meta where dataset was deleted

def dsSet = [] as Set
for( Dataset ds: DB.datasetDAO.findAll() ) dsSet.add( ds.dbID )

// Meta.getLike( String pattern ) seems to have some issues on some machines
// the groovy copy works more reliably

def getLike( String pattern ) {
    	List<String[]> queryRes = (List<String[]>) DB.getStatelessSession().createSQLQuery( "select meta_key, meta_value from meta where meta_key like ? order by meta_id")
		.setParameter( 0, pattern )
		.list();
		if(( queryRes == null) || ( queryRes.isEmpty())) return Collections.emptyList();

		List<Tuple<String, String>> res = new ArrayList<Tuple<String, String>>();
		for( Object[] s2: queryRes ) {
			res.add( new Tuple<String, String>( s2[0].toString(), s2[1].toString()));
		}
		return res;
	}

	
def res = getLike( '%recent.datasets')
DB.getStatelessSession().beginTransaction();

res.each{ 
    String key = it.first()
	JSONArray recent = (JSONArray) JSONSerializer.toJSON( it.second());

    Iterator i = recent.iterator();
    while(i.hasNext()) {
		JSONObject entry = (JSONObject) i.next();
		if(entry.has("dataset")) {
            long dsId = entry.getLong( "dataset" )
            if( !dsSet.contains( dsId )) {
                i.remove();
                println "$key refs not existing ds $dsId"
            } 
            else println "$key refs EXISTING $dsId"
		}
    }
    // Meta.put( key, recent.toString())
}

