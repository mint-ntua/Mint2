package gr.ntua.ivml.mint.db;


import gr.ntua.ivml.mint.persistent.Crosswalk;
import gr.ntua.ivml.mint.persistent.XmlSchema;

import java.util.List;

public class CrosswalkDAO extends DAO<Crosswalk, Long> {
	
	public List<Crosswalk> findByTargetName( String name ) {
		return getSession().createQuery( "from Crosswalk c where c.targetSchema.name = :name" )
			.setString("name", name)
			.list();
	}

	public List<Crosswalk> findBySourceAndTarget(XmlSchema source, XmlSchema target) {
		return this.findBySourceAndTarget(source.getName(), target.getName());
	}

	public List<Crosswalk> findBySourceAndTarget(String source, String target) {
		return getSession().createQuery( "from Crosswalk c where c.sourceSchema.name = :source and c.targetSchema.name = :target" )
			.setString("source", source)
			.setString("target", target)
			.list();
	}
}
