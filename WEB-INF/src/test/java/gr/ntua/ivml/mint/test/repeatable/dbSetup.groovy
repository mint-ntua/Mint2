package gr.ntua.ivml.mint.test.repeatable
import gr.ntua.ivml.mint.test.*

// include this everywhere you need the connection to the test database
// with: helper = evaluate( Config.getTestFile( "java/gr/ntua/ivml/mint/test/repeatable/dbSetup.groovy" ))

 new PG_Helper(
		user:"mint2",
		passwd:"mint2",
		host:"localhost",
		dbname:"mint2Test",
		port:"5433" );



