package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.concurrent.EntryProcessorI
import gr.ntua.ivml.mint.util.ApplyI
import gr.ntua.ivml.mint.util.Config
import gr.ntua.ivml.mint.util.FileFormatHelper;
import gr.ntua.ivml.mint.xml.util.XomSpecialParser
import groovy.util.GroovyTestCase


class ItemizeParserTest extends GroovyTestCase {
	int counter;
	def resultCollector = new ApplyI<String>() {
			void apply( String item) throws Exception {
				println "Collected Item $counter"
				counter++
			};
		}
	
	public void notestSimple() {
		File testFile = Config.getTestFile("data/example_big.tgz");
		EntryProcessorI ep = new EntryProcessorI() {
			void processEntry(String pathname, InputStream is) throws Exception {
				XomSpecialParser parser = new XomSpecialParser();
				parser.resultItemCollector = resultCollector
				parser.parseStream( is, "/OAI-PMH/GetRecord/record/metadata" );
			};
		}
		counter = 0
		FileFormatHelper.processAllEntries(testFile, ep);
		
	}
	
	public void testTheBig() {
		File testFile = Config.getTestFile("data/hispexport.zip");
		def ffh  = new FileFormatHelper(testFile)
		def res = ffh.unknownToTgz()
		EntryProcessorI ep = new EntryProcessorI() {
			void processEntry(String pathname, InputStream is) throws Exception {
				XomSpecialParser parser = new XomSpecialParser();
				parser.resultItemCollector = resultCollector
				parser.parseStream( is, "/exportedRecords/record" );
			};
		}
		FileFormatHelper.processAllEntries(res.output, ep)
	}
	
	public void notestTmp() {
		File f = File.createTempFile("some", ".tst")
		println f.getAbsolutePath()
	}
}