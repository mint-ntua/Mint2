package gr.ntua.ivml.mint.actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="crossdomain.jsp"),
	@Result(name="success", location="crossdomain.jsp")
})

public class CrossDomainPage extends GeneralAction {

	public static final Logger log = Logger.getLogger(CrossDomainPage.class );
	
	private String url;
	private String html;

	@Action(value="CrossDomainPage")
	public String execute() {
		try {
			this.setHtml(this.readHtmlFromUrl(this.getUrl()));
		} catch (Exception e) {
			this.setHtml(e.getMessage());
			e.printStackTrace();
		}
		return SUCCESS;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getHtml() {
		return html;
	}

	public void setHtml(String html) {
		this.html = html;
	}
	
	private String readAll(Reader rd) throws IOException {
		StringBuilder sb = new StringBuilder();
		int cp;
		while ((cp = rd.read()) != -1) {
			sb.append((char) cp);
		}
		return sb.toString();
	}

	private String readHtmlFromUrl(String url) throws MalformedURLException, IOException {
		InputStream is = new URL(url).openStream();
		try {
			BufferedReader rd = new BufferedReader(new InputStreamReader(is,
					Charset.forName("UTF-8")));
			String text = readAll(rd);
			return text;
		} finally {
			is.close();
		}
	}
}
