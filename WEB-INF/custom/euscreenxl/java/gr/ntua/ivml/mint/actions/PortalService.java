package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.PublishQueue;
import gr.ntua.ivml.mint.util.StringUtils;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.InterceptorRefs;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

/**
 * Use this as trigger for Noterick to start a publication on their server.
 * Trigger for our own backend to start publication on noterick server.
 * 
 * Trigger to delete from Noterick server.
 * 
 * @author Arne Stabenau 
 *
 */
@Results({
	@Result(name="list", type="stream", params={"inputName", "inputStream", "contentType", "text/plain",
			"contentCharSet", "UTF-8" }),
	@Result(name= "success", type="httpheader", params={"status","204" }),
	@Result(name="error", type="httpheader", params={"error", "404", 
			"errorMessage", "Internal Error"}) 
})



public class PortalService extends GeneralAction {
	// which id should be scheduled for publish
	private static final Logger log = Logger.getLogger( PortalService.class );
	String id;
	private StringBuilder output = new StringBuilder();
	
	@Action( value="PortalService", interceptorRefs={
			@InterceptorRef(value="ipFilter", params={"configIpPatterns", "portal.ipPattern"}),
		    @InterceptorRef("myStack")
	  })	
	public String execute() {
		if( StringUtils.empty( id )) {
			allIds();
			return "list";
		} else {
			PublishQueue.queueUpdate(id);
			return SUCCESS;
		}
	}

	private StringBuilder allIds() {
		// test version, just list all ids
		final HashSet<String> allIds = new HashSet<String>();
		try {
			DB.getItemDAO().onAllStateless(new ApplyI<Item>() {
				@Override
				public void apply(Item obj) throws Exception {
					
					// only the right schema and valid items are to be listed here normally !!
					if( ! StringUtils.empty( obj.getPersistentId()))
						allIds.add( obj.getPersistentId());
				}
			}, null );
		} catch( Exception e ) {
			log.debug( "Do nothing?", e  );
		}
		for( String id: allIds ) {
			output.append( id+"\n" );
		}
		return output;
	}
	
	
	//
	// Getter setter below
	//
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public InputStream getInputStream() {
		try {
			return new ByteArrayInputStream(output.toString().getBytes("UTF8"));
		} catch( Exception e ) {
			// encoding is there, stupid exception!
			return null;
		}
	}
}
