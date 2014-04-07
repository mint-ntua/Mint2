package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.persistent.Mapping

import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.Mapping
import gr.ntua.ivml.mint.persistent.XmlSchema
import groovy.sql.Sql



// connection to source
sql = Sql.newInstance( "jdbc:postgresql://localhost:5432/judaica", "judaica", "judaica",
 "org.postgresql.Driver" );
new TestDbSetup().run()
DB.getSession().beginTransaction()
importXmlSchemas()
importMappings()

DB.closeSession()
def importXmlSchemas() {
	sql.eachRow( "select * from xml_schema" ) {
		row ->
		  XmlSchema schema = new XmlSchema(
			  name: row.getAt( "name" ),
			  xsd: row.getAt( "xsd" ),
			  itemLevelPath: row.getAt( "item_level_path" ),
			  itemLabelPath: row.getAt( "item_label_path" ),
			  itemIdPath: row.getAt( "item_id_path" ),
			  jsonConfig: row.getAt( "json_config" ),
			  jsonTemplate: row.getAt( "json_template" ),
			  documentation: row.getAt( "documentation" ),
			  created: row.getAt( "created" )
			  )
		  DB.xmlSchemaDAO.makePersistent schema
	}
	DB.commit();
}

def importMappings() {
	def org = DB.organizationDAO.simpleGet( "shortName='Torg1'" );
	def user = DB.userDAO.simpleGet( "login='oschm'");
	
	sql.eachRow( "select mapping.*, xml_schema.name as schemaname from mapping, xml_schema" +
		" where mapping.target_schema_id = xml_schema.xml_schema_id") {
			row ->
			def schema = DB.xmlSchemaDAO.simpleGet( "name='"+ row.getAt( "schemaname" )+"'")
			if( schema != null ) {
				def m = new Mapping(
					name: row.getAt( "name"),
					creationDate: new Date(),
					organization: org,
					jsonString: row.getAt ("json"),
					targetSchema: schema,
					shared: row.getAt("shared"),
					finished: row.getAt("finished") 
				)
				DB.mappingDAO.makePersistent( m )
			}
		}
	DB.commit()	
}