package gr.ntua.ivml.mint.xsd;

import gr.ntua.ivml.mint.xsd.ReportErrorHandler.Error;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.*;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.sun.org.apache.xerces.internal.impl.XMLErrorReporter;

public class ReportErrorHandler implements ErrorHandler {
	private ArrayList<SAXParseException> report = new ArrayList<SAXParseException>();
	private  ArrayList<Error> errors = new ArrayList<Error>();
	
	public class Error {
		private String source;
		private int line;
		private int column;
		private String message;
		public String getSource() {
			return source;
		}
		public void setSource(String source) {
			this.source = source;
		}
		public int getLine() {
			return line;
		}
		public void setLine(int line) {
			this.line = line;
		}
		public int getColumn() {
			return column;
		}
		public void setColumn(int column) {
			this.column = column;
		}
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		public JSONObject toJSON() {
			JSONObject result = new JSONObject();

			result.element("message", message);
			result.element("line", line);
			result.element("column", column);
			if(this.source != null) result.element("source", source);
			
			return result;
		}
	}
	
	private void handleException(SAXParseException e) {
		System.out.println(e.getMessage());

		report.add(e);
		
		Error error = new Error();
		error.setLine(e.getLineNumber());
		error.setColumn(e.getColumnNumber());
		error.setMessage(e.getMessage());
		error.setSource(e.getClass().getName());
		
		errors.add(error);
	}

	@Override
	public void error(SAXParseException e) throws SAXException {
		handleException(e);
	}

	@Override
	public void fatalError(SAXParseException e) throws SAXException {
		handleException(e);
	}

	@Override
	public void warning(SAXParseException e) throws SAXException {
		handleException(e);
	}

	public String getReportMessage() {
		StringBuffer result = new StringBuffer();
		if(isValid()) {
//			return "XML is valid";
		} else {
			for(SAXParseException e: report) {
				result.append(e.getMessage());
				result.append("\n");
			}
		}
		
		return result.toString();
	}

	public boolean isValid() {
		return report.isEmpty();
	}

	public ArrayList<SAXParseException> getReport() {
		return report;
	}
	
	public List<Error> getErrors() {
		return this.errors;
	}

	public void addError(Error error) {
		if(error != null) this.errors.add(error);
	}

}