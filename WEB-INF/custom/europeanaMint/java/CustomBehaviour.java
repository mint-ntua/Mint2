import gr.ntua.ivml.mint.Custom;
import gr.ntua.ivml.mint.persistent.Item;

import org.apache.solr.common.SolrInputDocument;


public class CustomBehaviour extends Custom {
	@Override
	public void customModifySolarizedItem( Item item, SolrInputDocument sid ) {
		// add more fields or modify existing fields ?
		// copy fields into ones with different names?
		sid.addField("arnes_custom_field_tg", Integer.toString((int)Math.random()*10000000 ));
	}
}
