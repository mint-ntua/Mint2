package gr.ntua.ivml.mint.test
// read the SchemaInspector.config and connect to all databases
// compare the schema to the master schema
// assume Postgres databases, this is a mint tool

import groovy.sql.Sql;

// name for the connection, host, port (optional), db-name, schema-name, user, password
params = [
	[ "carare@local", "localhost", "", "carare", "carare", "carare", "carare" ],

	// [ "euscreen@mint", "mint", "", "euscreen", "euscreen", "euscreen", "euscreen" ],
	// [ "athena@panic", "panic.image.ece.ntua.gr", "", "athena", "athena", "athena", "athena" ],
	[ "carare@panic", "panic.image.ece.ntua.gr", "", "carare", "carare", "carare", "carare" ],
	[ "mint@panic", "panic.image.ece.ntua.gr", "", "mint", "mint", "mint", "mint" ],
	[ "eclap@panic", "panic.image.ece.ntua.gr", "", "eclap", "eclap", "eclap", "eclap" ],
	[ "judaica@panic", "panic.image.ece.ntua.gr", "", "judaica", "judaica", "judaica", "judaica" ],
	[ "edm@panic", "panic.image.ece.ntua.gr", "", "edm", "edm", "edm", "edm" ],
	[ "dca@panic", "panic.image.ece.ntua.gr", "", "dca", "dca", "dca", "dca" ],
	[ "dpla@panic", "panic.image.ece.ntua.gr", "", "dpla", "dpla", "dpla", "dpla" ],
	[ "ebu@panic", "panic.image.ece.ntua.gr", "", "ebu", "ebu", "ebu", "ebu" ],
	[ "linkedheritage@panic", "panic.image.ece.ntua.gr", "", "linkedheritage", "linkedheritage", "linkedheritage", "linkedheritage" ],
	[ "lidocidoc@panic", "panic.image.ece.ntua.gr", "", "lidocidoc", "lidocidoc", "lidocidoc", "lidocidoc" ]
]



dbs = params.collect{new DbConfig(it)}

/*
 multiGuardSql( dbs, { dbConf-> 
 return dbConf.getSchema().getTable( "transformation")?.getColumn( "report") == null },
 """alter table transformation add column report text""");
 */

multiSql( dbs, "select name from xml_schema");


/**
 * Execute given sql on given dbs.
 * report some of the results
 * @param dbs
 * @param reportSql
 * @return
 */
def multiSql( dbs, String reportSql ) {
	for( db in dbs ) {
		def result = db.getSql().rows( reportSql )
		if( result.size() > 0 )
			println( db.name )
		for( row in result ) {
			println row;
		}
	}
}


def multiGuardSql( dbs, String guardSql, String actionSql ) {
	for( db in dbs ) {
		db.guardSql( guardSql, actionSql );
	}
}

def multiGuardSql( dbs, Closure func, String actionSql ) {
	for( db in dbs ) {
		db.guardSql( func, actionSql );
	}
}

// db.getSql().eachRow( "select constraint_name, table_name, column_name, ordinal_position from information_schema.key_column_usage order by table_name, ordinal_position"){

class Column {
	String name
	String type
}

class Index {
	String name
	String indexExpression;

	def addColumn( col ) {
		if( indexExpression )
			indexExpression += "," + col
		else
			indexExpression = col;
	}
}


class Table {
	String name
	Map columns = [:];
	Map indices = [:];

	def addColumn( c ) {
		columns[ c.name ] = c;
	}

	def report( Table slave ) {
		def extraColumns = slave.missingColumns( this );
		def missingColumns = missingColumns( slave );
		if( missingColumns.size() > 0 )
			println "MissingColumns $name " + missingColumns.collect([]){ it }.toString()
		if( extraColumns.size() > 0 )
			println "ExtraColumns $name " + extraColumns.collect([]){ it }.toString()

		// println "CommonColumns $name " + commonColumns( slave ).collect([]){ it.key }.toString()
	}

	List missingColumns( Table slave ) {
		return columns.findAll { slave.columns[it.key] == null }.collect([]){  it.key }
	}

	Map commonColumns( Table slave ) {
		return columns.findAll{ slave.columns[it.key] != null  }
	}

	Column getColumn( String name ) {
		return columns[name]
	}
}

class DbConfig {
	String name, host, port, db, schema, user, pass
	private sql = null;

	public DbConfig( List params ) {
		name = params[0]
		host = params[1];
		port = params[2];
		db = params[3];
		schema = params[4];
		user = params[5];
		pass = params[6];
	}

	def getSql() {
		if( sql == null ) {
			if( port ) {
				port = ":"+port
			} else {
				port = ""
			}
			String url = "jdbc:postgresql://${host}${port}/${db}"
			sql =  Sql.newInstance( url, user, pass, "org.postgresql.Driver" )
		}
		return sql
	}

	def getSchema() {
		def s = new Schema()
		s.sql = getSql()
		s.name = name
		Map tables = [:]
		s.tables = tables
		getSql().eachRow( "select table_name from information_schema.tables where table_schema = ${schema} ") {
			def t = new Table()
			t.name = it[0]

			tables[t.name] = t
		}

		getSql().eachRow( "select table_name, column_name, data_type from information_schema.columns where table_schema = ${schema} ") {
			def col = new Column();
			col.name = it[1]
			col.type = it[2]
			tables[ it[0]].addColumn( col )
		}
		return s
	}

	/**
	 * Execute actionSql when testSql returns a row and this row contains an int > 0
	 * @param testSql
	 * @param actionSql
	 * @return
	 */
	def guardSql( String testSql, String actionSql ) {
		try {
			def execute = false
			def row = getSql().firstRow( testSql )
			if( row != null) {
				def num = row.getAt(0)
				if(( num instanceof java.lang.Integer ) || (num instanceof java.lang.Long)) {
					if( num > 0 ) execute = true
				}
				if( num instanceof java.lang.Boolean )
					if( num ) execute = true

				if( num instanceof java.lang.String ) {
					if( num.trim().length() > 0 ) execute = true
				}
				if( execute ) {
					try {
						sql.execute( actionSql )
					} catch( Exception e ) {
						println( "Execute failed with " + e.message )
					}
					println( "Executed \"$actionSql\" on " + name );
					return
				}
			}
		} catch( Exception e ) {}
		println( "Not executed \"$actionSql\" on " + name );
	}


	def guardSql( Closure func, String actionSql ) {
		// func needs to return a boolean to allow actionSql to proceed
		if( func( this )) {
			try {
				sql.execute( actionSql )
			} catch( Exception e ) {
				println( "Execute failed with " + e.message )
			}
			println( "Executed \"$actionSql\" on " + name );
		} else {
			println( "Not executed \"$actionSql\" on " + name );
		}
	}

	def reportSql( reportSql ) {
	}
}

class Schema {
	String name
	Map tables
	Sql sql

	def report( Schema slave ) {
		def extraTables = slave.missingFrom( this );
		def missingTables = missingFrom( slave );
		if( missingTables.size() > 0 )
			println "MissingTables " + missingTables.collect{ it }
		if( extraTables.size() > 0 )
			println "ExtraTables " + extraTables.collect{ it }

		// println "Common Tables " + commonTables( slave )
		commonTables( slave ).each{
			def masterTable = getTable(it)
			def slaveTable = slave.getTable( it )
			masterTable.report( slaveTable )
		}
	}

	def Set commonTables( Schema slave ) {
		Set res = []
		filteredTables().each { if( slave.tables[it.key] != null ) res.add( it.key ); }
		return res
	}


	def Table getTable( String name ) {
		return tables.get( name );
	}

	def addTable( Table t ) {
		tables.put( t.name, t )
	}


	def Set missingFrom( Schema slave ) {
		Set res = []
		filteredTables().each { if( slave.tables[it.key] == null ) res.add( it.key )}
		return res
	}

	def filteredTables() {
		return tables.findAll{ !(it.key ==~ /xml_node_\d+/) }
	}

	def getCounts() {
		def res = [:]
		for( table in filteredTables() ) {
			// skip xml_node_master
			if( table.key =~ /xml_node_master/ ) continue
				res[table.key] = sql.firstRow( "select count(*) from "+table.key ).getAt(0);
		}
		println res;
	}


}

/**
 * 
 * Orphan cleaning sql
 select xo.xml_object_id from xml_object xo 
 left join annotation a 
 on a.xml_output_object_id = xo.xml_object_id
 left join data_upload du 
 on xo.xml_object_id = du.xml_object_id
 left join transformation t
 on xo.xml_object_id = t.output_xml_object_id
 where a.xml_output_object_id is null
 and du.xml_object_id is null
 and t.output_xml_object_id is null
 */
