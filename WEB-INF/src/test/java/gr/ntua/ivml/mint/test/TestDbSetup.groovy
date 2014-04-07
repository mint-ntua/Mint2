package gr.ntua.ivml.mint.test
import org.apache.log4j.Logger

import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.Dataset
import gr.ntua.ivml.mint.persistent.Organization
import gr.ntua.ivml.mint.persistent.User
import gr.ntua.ivml.mint.util.Config

log = Logger.getLogger( this.getClass())

// drop the current schema in the testDb
// reread the createSchema.sql into it
// run the init with this groovy
if( !DB.testDb ) {
	throw new RuntimeException( "Test Connection not setup!!")	
}

DB.doSQLFile "WEB-INF/src/createSchema.sql"
DB.getSession().beginTransaction()
log.info "schema redone"
def org = testOrg()
testUser( org )
testUpload()
DB.commit()

def testUser( org ) {
	User testUser = new User( 
		firstName:"Otto", 
		lastName:"Schmidt",
		company:"Killer Autos",
		login:"oschm",
		organization: org,
		accountActive: true ,
		accountCreated: new Date(),
		mintRole:"ADMIN"
		)
	testUser.setNewPassword "oschm"
	DB.userDAO.makePersistent testUser
}

def testOrg() {
	Organization testOrg = new Organization(
		englishName:"Test Org 1",
		shortName:"Torg1",
		originalName:"Testorganisation 1",
		country:"Greece",
		type:"University",
		description:"Test database standard org"
	)
	testOrg = DB.organizationDAO.makePersistent( testOrg )
	
	org2 = new Organization( 
		englishName:"Guild of thieves",
		shortName:"Parlament",
		originalName:"Bundestag",
		country:"Germany",
		type:"Camorra",
		description:"We take what you can't keep",
		parentalOrganization: testOrg )
	DB.organizationDAO.makePersistent org2
	return testOrg
}

def testUpload() {
	User u = DB.userDAO.simpleGet( "login='oschm'")
	DataUpload du = new DataUpload().init( u )
	du = DB.dataUploadDAO.makePersistent(du)
	du.normalizeAndUpload(new File( Config.getTestRoot(), "/data/example_big.tgz"), false)
	du.name = "ExampleUpload"
	DB.commit();
	du = new DataUpload().init(u)
	du.setLoadingStatus(Dataset.LOADING_HARVEST)
	du = DB.dataUploadDAO.makePersistent(du)
	
}

