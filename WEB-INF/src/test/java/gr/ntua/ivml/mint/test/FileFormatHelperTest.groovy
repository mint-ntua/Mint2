package gr.ntua.ivml.mint.test
import groovy.util.GroovyTestCase

import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.FileFormatHelper;

class FileFormatHelperTest extends GroovyTestCase {
	
	public static oneTimeSetUp() {
		println "run the setup"
	}

	public static oneTimeTearDown() {
		println "run the teardown"
	}

	public void  testImportDir() {
		FileFormatHelper ffh = new FileFormatHelper( new File( Config.getTestRoot(), "java" ))
		def res = ffh.unknownToTgz()
		assert( res.format == "DIR" )
		assert( res.entryCount > 10 )
		def procTar = "tar -tzf ${res.output.getAbsolutePath()}".execute()
		def found = false
		procTar.getInputStream().eachLine { if( it =~ /FileFormatHelperTest/) found = true }
		assert found
		// cleanup
		res.output.delete();
	}

	public void testImportZip() {
		File example = new File( Config.getTestRoot(), "data/example_big.zip" )
		FileFormatHelper ffh = new FileFormatHelper( example )
		def res = ffh.unknownToTgz()
		assert res.format == "ZIP"
		assert res.entryCount == 2001

		// test for valid tgz format
		def procTar = "tar -tzf ${res.output.getAbsolutePath()}".execute()
		def found = false
		procTar.getInputStream().eachLine { if( it =~ /1721\.1\.12005\.xml/) found = true }
		assert found

		// cleanup
		res.output.delete();
	}
	
	public void testImportTgz() {
		File example = new File( Config.getTestRoot(), "data/example_big.tgz" )
		FileFormatHelper ffh = new FileFormatHelper( example )
		def res = ffh.unknownToTgz()
		assert res.format == "TGZ"
		assert res.entryCount == 2001

		// test for valid tgz format
		def procTar = "tar -tzf ${res.output.getAbsolutePath()}".execute()
		def found = false
		procTar.getInputStream().eachLine { if( it =~ /1721\.1\.12005\.xml/) found = true }
		assert found

		// cleanup
		res.output.delete();
	}
	

}