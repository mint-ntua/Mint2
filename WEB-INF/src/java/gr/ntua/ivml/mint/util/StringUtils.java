package gr.ntua.ivml.mint.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import nu.xom.ParsingException;
import nu.xom.ValidityException;

import org.ocpsoft.pretty.time.PrettyTime;
import org.w3c.dom.Node;

/**
 * Class with tools to construct Strings.
 * Static import this functions to construct bigger strings.
 * 
 * @author Arne Stabenau 
 *
 */
public class StringUtils {
	private static DateFormat isoDateFormat = new SimpleDateFormat( "yyyy-MM-dd'T'HH:mm:ssZ") ;
	
	/**
	 * Join the two parameter strings with the join string
	 * if they are not empty. If either is empty there will
	 * be no join string added.
	 * @param arg1
	 * @param join
	 * @param arg2
	 * @return
	 */
	public static String join( String arg1, String join, String arg2) {
		if( arg1 == null ) arg1 = "";
		if( arg2 == null ) arg2 = "";
		if((arg1.trim().length() > 0) &&
				( arg2.trim().length() > 0 ))
			return arg1 + join + arg2;
		else
			return arg1 + arg2;
	}
	
	public static String humanNumber( long num ) {
		StringBuilder msg = new StringBuilder();		
		if( num >= 0 ) {
			int mag = 0;
			while( num >=  1000) {
				num = num / 10;
				mag++;
			}
			char[] oMag = { 'K', 'M', 'G' };
			if( mag > 0 ) msg.append( oMag[ (mag-1)/3 ]);
			msg.insert(0, num );
			// and now the dot
			if( mag%3 != 0 ) msg.insert( mag%3, ".");
		}
		return msg.toString();
	}
	
	/**
	 * Gets you the date if its more than 24 hours from now. Else time.
	 * @return
	 */
	public static String getDateOrTime(Date date) {
		long then = date.getTime();
		long now = System.currentTimeMillis();
		if( now-then > ( 24*3600*1000 )) {
			return String.format("%tF", date);
		} else {
			return String.format( "%tR", date);
		}
	}

	public static String joinAll( String join, Object... args ) {
		String result = "";
		for( Object opt : args ) {
			if( opt != null )
			result = join( result, join, opt.toString() );
		}
		return result;
	}

	/**
	 * Return first argument if there is something to return,
	 *  else return second argument if there is something to return
	 *  and so forth, or return empty String.
	 * @param o1
	 * @param defaultString
	 * @return
	 */
	public static String getDefault( Object... args ) {
		String res = "";
		for( Object arg: args ) {
			if( arg != null)
				if( arg.toString().trim().length() > 0 ) {
					res = arg.toString();
					break;
				}
		}
		return res;
	}
	
	/**
	 * Prefix only if there is something to prefix, otherwise return empty string.
	 * Good for constructing "?param1=.." style argument strings
	 * hc.condPrefix( "?",parameters )
	 * @param prefix
	 * @param val
	 * @return
	 */
	public static String condPrefix( String prefix, String val ) {
		if(( val != null ) && ( val.trim().length() > 0  ))
			return prefix+val;
		else
			return "";
	}
	
	public static String condAppend( String val, String append ) {
		if(( val != null ) && ( val.trim().length() > 0  ))
			return val+append;
		else
			return "";
	}
	
	
	/**
	 * Concat only if all arguments are present and have non null length
	 * @param args
	 * @return
	 */
	public static String concatIfAll( Object... args ) {
		StringBuffer sb = new StringBuffer();
		for( Object obj: args ) {
			if( obj == null ) return "";
			String s = obj.toString().trim();			
			if( s.length() == 0 ) return "";
			sb.append( s );
		}
		return sb.toString();
	}
	
	public static StringBuffer filteredStackTrace( Throwable t, String filter ) {
		StringBuffer sb = new StringBuffer();
		StackTraceElement se[] = t.getStackTrace();
		for( StackTraceElement ste: se ) {
			if( ! ste.getClassName().startsWith(filter )) continue;
			sb.append( "  at " + ste.getClassName());
			sb.append( "." + ste.getMethodName());
			sb.append( "(" + ste.getFileName() + ":" + ste.getLineNumber() + ")");
			sb.append( "\n" );
		}
		return sb;
	}

	/**
	 * Inserts "..." inside the String and shortens it to maxLen.
	 * @param msg
	 * @param maxLen
	 * @return
	 */
	public static String shortenMiddle( String msg, int maxLen ) {
		if( msg.length() <= maxLen) return msg;
		int half= (maxLen-3)/2;
		return msg.substring(0,half) + "..." + msg.substring( msg.length()-half);
	}
	
	/**
	 * Inserts "..." on the front and shortens to maxLen.
	 * @param msg
	 * @param maxLen
	 * @return
	 */
	public static String shortenFront( String msg, int maxLen ) {
		if( msg.length() <= maxLen) return msg;
		return "..." + msg.substring( msg.length()-maxLen);
	}
	
	public static String shortenEnd( String msg, int maxLen ) {
		if( msg.length() <= maxLen) return msg;
		return msg.substring( 0, maxLen );
	}
	
	/**
	 * General short string helper. Print max front chars from the beginning,
	 *  the join string and max end chars from the end.
	 * @param msg
	 * @param front
	 * @param join
	 * @param end
	 * @return
	 */
	public static String shorten( String msg, int front, String join, int end ) {
		if( msg.length()<= (front+join.length()+end)) return msg;
		return msg.substring(0,front) + join + msg.substring( msg.length()-end);
	}
	
	
	public static boolean empty(String val) {
		return(( val == null) || ( val.trim().length()==0 ));
	}

	public static StringBuffer fileContents(File file) throws IOException {
		return fileContents(file, false);
	}

	public static StringBuffer fileContents(File file, boolean addNewline) throws IOException {
		StringBuffer buffer = new StringBuffer();
		
		String line;
		BufferedReader in = new BufferedReader(new FileReader(file));
		while((line = in.readLine()) != null) {
			buffer.append(line + ((addNewline)?"\n":""));
		}
		
		return buffer;
	}
	
	public static String xmlContents(File file) throws ValidityException, ParsingException, IOException {
		nu.xom.Builder builder = new nu.xom.Builder();
		nu.xom.Document doc = builder.build(file);
		return doc.toXML();
	}
	
	public static StringBuilder prettyPrint( byte[] data, int length ) {
		if( length > data.length) length = data.length;
		
		StringBuilder result = new StringBuilder();
		byte[] buffer = new byte[16];
		int count = 0;
		while( count < length ) {
			buffer[count%16] = data[count];
			result.append( String.format( "%02x ", data[count]));
			count++;
			if(( count %16 ==0) || (count==length)) {
				String s = "";
				try {
					s = new String( buffer, 0, (count-1)%16+1, "UTF8" );
					s = s.replaceAll("[^\\p{Alnum}\\p{Punct}]", ".");
				} catch( UnsupportedEncodingException e) {}

				if( count%16 != 0 ) {
					while( count%16 != 0 ) {
						result.append( "   " );
						count++;
					}
				}
				result.append( " | ");
				result.append(  s + "\n");
			}
		}
		return result;
	}

	/**
	 * Prints the time in some pretty format, like "3 minutes ago"
	 * @param d
	 * @return
	 */
	public static String prettyTime( Date d ) {
		PrettyTime t = new PrettyTime( new Date());
		return t.format( d );
	}
	
	public static String isoTime( Date d ) {
		if( d == null ) return null;
		return isoDateFormat.format( d );
	}
	
	/**
	 * Return the Stacktrace as String
	 * Optional filter every line with Pattern String
	 * @param th
	 * @param p
	 * @return
	 */
	public static String stackTrace( Throwable th, String pattern ) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter( sw );
		th.printStackTrace( pw );
		if( pattern != null ) {
			BufferedReader br = new BufferedReader( new StringReader( sw.toString()));
			sw = new StringWriter();
			String s = null;
			try {
				while(( s = br.readLine()) != null ) {
					if( s.matches( pattern ))  sw.write(s+"\n" );
				}
			} catch( Exception e ) {
				
			}
		}
		return sw.toString();
	}
	
	/**
	 * Create a random string with upper and lower case latin letters,
	 * spaces and paragraphs.
	 * @param length
	 * @return
	 */
	public static String randomText( int length ) {
		StringBuffer sb = new StringBuffer();
		for( int i=0; i<length; i++ ) {
			sb.append( randomChar() );
		}
		return sb.toString();
	}
	
	private static char randomChar() {
		int num = (int) Math.floor( Math.random()*60 );
		if( num < 26 ) return (char)((int)'a'+num);
		num-=26;
		if( num < 26 ) return (char)((int)'A'+num);
		num -= 26;
		if( num < 1) return '\n';
		return ' ';
	}

	public static String memUsage() {
		return "Total mem: " + humanNumber( Runtime.getRuntime().totalMemory() ) + 
		", Free mem: " + humanNumber( Runtime.getRuntime().freeMemory()) +
		", Max mem: " + humanNumber(Runtime.getRuntime().maxMemory());
	}

	public static boolean isIn(String testString, String... args) {
		for( String s: args ) {
			if( s.equals( testString )) return true;
		}
		return false;
	}

	public static StringBuffer streamContents(InputStream is) throws IOException {
		return streamContents(is, false);
	}

	public static StringBuffer streamContents(InputStream is, boolean addNewline) throws IOException {
		StringBuffer buffer = new StringBuffer();

		String line;
		BufferedReader in = new BufferedReader(new InputStreamReader(is));
		while((line = in.readLine()) != null) {
			buffer.append(line + ((addNewline)?"\n":""));
		}
		
		return buffer;
	}

	public static String fromDOM(Node node) throws TransformerException {
		return StringUtils.fromDOM(node, true);
	}
	
	public static String fromDOM(Node node, boolean omitXmlDeclaration) throws TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer();
		StringWriter buffer = new StringWriter();
		if(omitXmlDeclaration) transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		transformer.transform(new DOMSource(node),
		      new StreamResult(buffer));
		String str = buffer.toString();
		
		return str;
	}
	
	public static String exceptionStackTrace(Exception ex) {
		StringBuffer buffer = new StringBuffer();
		for (StackTraceElement element : ex.getStackTrace()) {
			buffer.append(element.toString());
			buffer.append("\n");
		}

		return buffer.toString();
	}
}
