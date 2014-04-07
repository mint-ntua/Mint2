package gr.ntua.ivml.mint.db;


import gr.ntua.ivml.mint.persistent.XmlSchema;

public class XmlSchemaDAO extends DAO<XmlSchema, Long> {
	public XmlSchema getByName( String schemaName ) {
		return simpleGet( "name='" + schemaName + "'");
	}
}
