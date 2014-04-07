package gr.ntua.ivml.mint.test.repeatable
import gr.ntua.ivml.mint.test.*
import gr.ntua.ivml.mint.util.*


// use this script to safe the current test db back to the default 
// whenecer you modify intentionally the test db, use this script to
// store the new database in the dump file.

// ADJUST ALL REPEATABLE TESTS NOT TO FAIL AFTER THAT!!!

helper = evaluate( Config.getTestFile( "java/gr/ntua/ivml/mint/test/repeatable/dbSetup.groovy" ))
def file = new File( Config.getTestRoot(), "data/mint2Test.dmp" )

// restore database from given file
helper.restore( file );
