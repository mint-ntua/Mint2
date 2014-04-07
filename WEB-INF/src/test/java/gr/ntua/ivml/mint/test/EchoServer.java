package gr.ntua.ivml.mint.test;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;

import org.hibernate.engine.jdbc.StreamUtils;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;


public class EchoServer {

	public static void main(String[] args) throws Exception {
			int port = 8000;
			if( args.length > 0 ) port = Integer.parseInt(args[0]);
			
	        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
	        server.createContext("/test", new MyHandler());
	        server.setExecutor(null); // creates a default executor
	        server.start();
	    }

	    static class MyHandler implements HttpHandler {
	        public void handle(HttpExchange t) throws IOException {
	        	
	            // dump the request to stdout
	            System.out.println( "Request URI: " + t.getRequestURI().toString());
	            
	            InputStream is = t.getRequestBody();
	            StreamUtils.copy(is, System.out );
	            System.out.flush();

	            String response = "";
	            t.sendResponseHeaders(200, response.length());
	            OutputStream os = t.getResponseBody();
	            os.write(response.getBytes());
	            os.close();
	            
	        }
	    }
}
