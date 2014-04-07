package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.XSLTransform
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.Mapping
import gr.ntua.ivml.mint.persistent.Transformation
import junit.extensions.TestSetup;
import junit.framework.Test;
import junit.framework.TestSuite

class TransformationTest extends GroovyTestCase {
	
	public void testTransform() {
		DataUpload du = DB.dataUploadDAO.simpleGet( "name like 'Repox%'");
		assert du != null
		Mapping m = DB.mappingDAO.simpleGet( "name='azoresESE'");
		assert m!= null
	
		Transformation tr =  Transformation.fromDataset(du, m);
		DB.transformationDAO.makePersistent( tr )
		DB.commit()
		assert DB.transformationDAO.count( "name='" + du.getName() +"'") > 0
		
		def execTrans = new XSLTransform(tr);
		Queues.queue( execTrans, "now" )
		Queues.join( execTrans )	
	}
	
	public void setUp() {
		DB.getSession().beginTransaction()

	}
	
	public void tearDown() {
		DB.commit()
		DB.closeSession()
		DB.closeStatelessSession()
	}
	
	public static Test suite() {
		return new TestSetup( new TestSuite( TransformationTest.class )) {
			protected void setUp() throws Exception {
				// new TestDbSetup().run()
			}
		}
	}

}