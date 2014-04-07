package gr.ntua.ivml.mint.test
import java.sql.Connection
import java.sql.DriverManager

import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.UploadIndexer
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.User
import gr.ntua.ivml.mint.util.Config

// this file from your server gets uploaded
// def uploadFile = Config.getTestFile("data/example_big.tgz")
// def uploadFile = new File( "/Users/admin/Downloads/Alles_voor_Carare.zip" )
def uploadFile = new File( "/Users/admin/Projects/Carare/AllCarare.zip" );

// login of the user for the upload
def user = "oschm"

// set repox to non "" to get the repox import
// Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5433/repox", "postgres", "postgres" );
def repox = ""

DB.getSession().beginTransaction()

User u = DB.userDAO.simpleGet( "login='$user'")
def org = DB.organizationDAO.simpleGet( "originalName='Bundestag'")
DataUpload du = (DataUpload) new DataUpload().init( u );
du.organization = org

if( repox != "" ) {
	du.setName( "Repox import " + repox );
	du.setUploadMethod DataUpload.METHOD_REPOX
	du.setStructuralFormat DataUpload.FORMAT_XML

} else {
	du.setName( uploadFile.getName() );
	du.setUploadMethod DataUpload.METHOD_SERVER

}
DB.dataUploadDAO.makePersistent(du)
DB.commit()

UploadIndexer ui
if( repox != "" ) {
	ui = new UploadIndexer( du, c, repox );
} else {
	ui = new UploadIndexer( du, UploadIndexer.SERVERFILE );
	ui.setServerFile(uploadFile.getAbsolutePath())
}
Queues.queue(ui, "now")
Queues.join(ui)
Queues.join(ui)

DB.commit()
DB.closeSession()
DB.closeStatelessSession()

System.exit(0)

