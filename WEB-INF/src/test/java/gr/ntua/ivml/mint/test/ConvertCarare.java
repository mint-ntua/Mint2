package gr.ntua.ivml.mint.test;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Collections;

import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.NodeFactory;
import nu.xom.Nodes;
import nux.xom.io.StaxUtil;
import nux.xom.xquery.StreamingPathFilter;
import nux.xom.xquery.StreamingTransform;

// split the big xml files in 50 little ones (roughly)

class ConvertCarare  implements StreamingTransform {
	public static String  filename = "/Users/admin/Projects/Carare/Alles_voor_Carare.xml";
	public File outdir = new File("/Users/admin/Projects/Carare/AllCarare");
	
	
	public int currentTotalItem = 0;
	public int currentFileNum = 1;
	public int currentItemCount;

	public void printCurrent( Document doc ) {
		try {
		File f = new File( outdir, "Split-"+currentFileNum+".xml" );
		PrintWriter pw = new PrintWriter( f, "UTF-8");
		pw.println( doc.toXML());
		pw.close();
		System.out.println( "Wrote File Split-"+currentFileNum+ ".xml") ;
		currentFileNum++;
		currentItemCount = 0;
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
		
	public void split( InputStream is ) {
		String itemPath = "/adlibXML/recordList/record";
		itemPath = itemPath.replaceAll("/", "/*:");
		StreamingPathFilter spf = new StreamingPathFilter(itemPath, Collections.emptyMap());
		NodeFactory nf1 = spf.createNodeFactory(null, this);
		Builder itemBuilder = StaxUtil.createBuilder(null, nf1);
		currentItemCount = 0;
		try {
		Document doc = itemBuilder.build(is);
		// final document
		printCurrent( doc );
		is.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public  static void main( String[] args ) {
		ConvertCarare cc = new ConvertCarare();
		try {
		InputStream is = new BufferedInputStream( new FileInputStream( filename ));
		cc.split(is);
		} catch( Exception e ) { 
			e.printStackTrace();
		}
	}

	@Override
	public Nodes transform(Element item) {
		if( currentItemCount < 20000 ) {
			currentItemCount++;
			return new Nodes( item );
		} else {
			printCurrent( item.getDocument());
			// clean the doc
			Element parent = (Element) item.getParent();
			parent.removeChildren();
			return new Nodes(item);
		}
	}
}

