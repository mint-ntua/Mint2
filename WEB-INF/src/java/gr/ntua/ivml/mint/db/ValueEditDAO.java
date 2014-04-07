package gr.ntua.ivml.mint.db;


import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.ValueEdit;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import java.util.List;

public class ValueEditDAO extends DAO<ValueEdit, Long> {
	
	public List<ValueEdit> listByDataset( Dataset ds ) {
		List<ValueEdit> res = getSession().createQuery(
				"from ValueEdit where dataset = :ds order by xpathHolder, dbID" )
				.setEntity("ds", ds )
				.list();
		return res;
	}
	
	public List<ValueEdit> listByXpathHolder( XpathHolder xp ) {
		List<ValueEdit> res = getSession().createQuery(
		"from ValueEdit where xpathHolder = :xp order by dbID desc" )
		.setEntity("xp", xp )
		.list();
		return res;
	}
	
	public void removeLatestByXpathHolder( XpathHolder xp ) {
		getSession().createQuery("delete from ValueEdit where dbID = " +
				" ( select dbID from ValueEdit where path = :xp order by dbID desc limit 1)")
				.setEntity("xp", xp)
				.executeUpdate();
	}
	
}
