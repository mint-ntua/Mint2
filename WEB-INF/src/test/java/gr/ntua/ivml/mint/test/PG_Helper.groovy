package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.util.Config


class PG_Helper {
	
	String user, passwd, host, port
	String dbname
	String path ="/Library/PostgreSQL/9.1/bin/"
	
	/**
	 * Dump the database
	 */
	public void dump( File target ) {
		if( port == null ) port = "5432"
		def process = ["${path}pg_dump", "-p", port, "-h", host, "-U", user, "-Fc", "-f", target.getPath(), dbname].execute();
		process.withWriter{ writer -> writer.println( passwd )}
		process.waitFor()
		println process.errorStream.text
	}
	
	public void restore( File target ) {
		if( port == null ) port = "5432"
		def process = ["${path}dropdb","-p", port, "-h", host, "-U", user, dbname].execute()
		process.withWriter{ writer -> writer.println( passwd )}
		process.waitFor()
		println process.errorStream.text
		
		process = ["${path}pg_restore", "-p", port, "-h", host, "-U", user, "-C", "-d", "postgres", target.getPath()].execute()
		process.withWriter{ writer -> writer.println( passwd )}
		process.waitFor()
		println process.errorStream.text
	}
	
	public String getUrl() {
		return "jdbc:postgresql://$host:$port/$dbname";
	}
	
	
	public static void main(String[] args) {
		def helper=  new PG_Helper(
			user:"mint2",
			passwd:"mint2",
			host:"localhost",
			dbname:"mint2-test",
			port:"5433"
		);
		def file = new File( Config.getTestRoot(), "data/mint2Test.dmp" )
		// helper.dump file
		helper.dump(file)
	}
}
