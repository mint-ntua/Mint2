package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.User

import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.UploadIndexer
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.Organization
import groovy.sql.Sql


class BuildFromAthena {
	// connection to source
	static Sql sql = Sql.newInstance( "jdbc:postgresql://panic.image.ece.ntua.gr/athena", "athena", "athena",
	 "org.postgresql.Driver" );
	static Map orgmap = [:]
	static Map usermap = [:]
	
	// have for every Transformation id the blob as $id.zip file in here
	static String transDir = "/Users/admin/Projects/athenaTransformations"
	
	public static void main(String[] args ) {
		DB.doSQLFile "WEB-INF/src/createSchema.sql"
		DB.getSession().beginTransaction()
		clean()
		
		importUsers()
		importOrgs()
		
		// connect users and org with foreign keys		
		resolveOrgs()
		resolveUsers()
		
		File dumpDir = new File( transDir )
		if( !dumpDir.exists()) {
			println "Dir $transDir not found. Exit"
			System.exit(0)
		}
		uploadTransformations( dumpDir )
	}
		
	/**
	 * remove existing users and orgs
	 * @return
	 */
	static def clean() {
		DB.userDAO.deleteAll()
		DB.organizationDAO.deleteAll()
		DB.commit()
	}
	/**
	 * returns a map keyed on the original id in the source db.
	 * Allows to reconnect things.
	 * @return
	 */
	static void importOrgs() {
		sql.eachRow( "select * from organization" ) {
			row ->
				def org = new Organization(
						address:row.getAt("address"),
						country:row.getAt("country"),
						description: row.getAt("description"),
						englishName: row.getAt("english_name"),
						originalName: row.getAt( "original_name"),
						shortName: row.getAt("short_name"),
						type:row.getAt("org_type"),
						urlPattern:row.getAt("url_pattern")
				)	
				DB.getSession().save(org)
				orgmap[ row.getAt( "organization_id")] = org						
		}
		DB.commit()
	}
	
	static Map importUsers() {
		sql.eachRow("select * from users") {
			row->
				def user = new User(
					accountActive:row.getAt("active_account"),
					jobRole:row.getAt("job_role"),
					lastName:row.getAt("last_name"),
					firstName:row.getAt("first_name"),
					md5Password:row.getAt("md5_password"),
					email:row.getAt("email"),
					workTelephone:row.getAt("work_telephone"),
					accountCreated:row.getAt("account_created"),
					login:row.getAt("login"),
					passwordExpires:row.getAt("password_expires"),
					rights:row.getAt("rights")
				)
				DB.getSession().save( user )
				usermap[ row.getAt("users_id")] = user
		}
		DB.commit()
	}
	
	static def resolveOrgs() {
		sql.eachRow( "select * from organization" ) {
			row ->
				Organization org = orgmap[ row.getAt( "organization_id")]
				def parentOrg = orgmap[ row.getAt( "parental_organization_id")]
				if( parentOrg != null ) org.parentalOrganization = parentOrg
				def primaryContact = usermap[ row.getAt("primary_contact_user_id")]
				if( primaryContact != null) org.primaryContact = primaryContact				
		}
		
		// flush and commit the new orgs
		DB.commit()
	}
	
	static def resolveUsers() {
		sql.eachRow( "select * from users" ) {
			row ->
				User u = usermap[ row.getAt("users_id")]
				def org = orgmap[row.getAt("organization_id")]
				if( org != null ) u.organization = org
		}
		// flush and commit the new users
		DB.commit()
	}
	
	static def uploadTransformations( File dmpDir ) {
		sql.eachRow( "select tr.*, du.* from transformation tr, data_upload du" +
					 " where tr.data_upload_id = du.data_upload_id"	) {
			row ->
				File dmp = new File( dmpDir, row.getAt("transformation_id")+".zip")
				if( dmp.exists() ) {
					def org = orgmap[ row.getAt( "organization_id")]
					def user = usermap[ row.getAt("uploader_id")]
					DataUpload du = new DataUpload().init( user )
					if( org != null) du.organization = org
					du.created = row.getAt("upload_date")
					du.originalFilename = row.getAt("transformation_id")+".zip"
					du.setUploadMethod(DataUpload.METHOD_SERVER)
					du.name = row.getAt( "original_filename")
					DB.session.save( du )
				}
		}
		DB.commit()
		
		// now make upload indexers and queue them
		for( DataUpload du: DB.dataUploadDAO.findAll() ) {
			// if( !du.originalFilename.equals( "2163.zip" )) continue;
			UploadIndexer ui = new UploadIndexer( du, UploadIndexer.SERVERFILE )
			String serverfile = new File(dmpDir, du.getOriginalFilename()).getAbsolutePath()
			ui.setServerFile(serverfile)
			Queues.queue( ui, "db")
			println "Queued ${du.name} for user ${du.creator.login} Organization ${du.organization.englishName}"
		}
		println "Finished Queueing."
	}
	
	
}
