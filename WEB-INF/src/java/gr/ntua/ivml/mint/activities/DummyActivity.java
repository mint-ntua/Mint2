package gr.ntua.ivml.mint.activities;

import gr.ntua.ivml.mint.persistent.Activity;

/**
 * Just to test basic Activity behaviour
 * @author Arne Stabenau 
 *
 */
public class DummyActivity extends Activity {
	
	String description;
	
	public DummyActivity( String description ) {
		this.description = description;
	}
	
	@Override
	public void activity() {
		log.debug( "Dummy activity started" );
		try {
			Thread.sleep( 20000 );
		} catch( Exception e ) {}
		log.debug( "Dummy Activity finished");
	}
	
	@Override
	public String getDescription() {
		return description;
	}
	
}
