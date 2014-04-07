package gr.ntua.ivml.mint.persistent;

import java.util.Date;
import java.util.List;

import nu.xom.Document;
import nu.xom.Node;
import nu.xom.Nodes;
import nu.xom.Text;

public class ValueEdit {
	private Long dbID;
	private XpathHolder xpathHolder;
	
	// redundant, but good for queries
	private Dataset dataset;
	
	private String matchString;
	private String replaceString;
	private Date created;
	/** 
	 * change the given Document according to this edit.
	 * @param doc
	 */
	public ValueEdit() {}
	
	
	public ValueEdit( XpathHolder xp, String matchString, String replaceString ) {
		this.xpathHolder = xp;
		this.matchString = matchString;
		this.replaceString = replaceString;
	}
	
	
	
	/**
	 * Apply edits that belong to the same xpathHolder
	 * @param valueEdits
	 * @param doc
	 */
	public static void applyOneXpath( Document doc, List<ValueEdit> valueEdits ) {
		Nodes nodes = null;
		for( ValueEdit e: valueEdits ) {
			if( nodes == null) {
				nodes = doc.query( e.getXpathHolder().getXpathWithPrefix(true));
			}

			for( int i =0; i< nodes.size(); i++ ) {
				Node n = nodes.get( i );
				if( n instanceof Text ) {
					String val = ((Text)n).getValue();
					String newVal = val.replaceAll(e.getMatchString(), e.getReplaceString());
					if( !newVal.equals( val ))
						((Text)n).setValue(newVal);
				}
			}
		}
	}

	/**
	 * Applies all edits to the document. Assumes the edits are sorted by xpathholder !!
	 * @param doc
	 * @param valueEdits
	 */
	public static void applyAll( Document doc, List<ValueEdit> valueEdits ) {
		// I think we should assume sorted by xpathholder
		int start = 0, end = 0;
		ValueEdit startEdit = null;
		
		for( ValueEdit e: valueEdits ) {
			if( startEdit == null )	startEdit = e;
			if( e.getXpathHolder().getDbID() != startEdit.getXpathHolder().getDbID()) {
				applyOneXpath( doc, valueEdits.subList(start, end ));
				start = end;
				startEdit= e;
			}
			end++;
		}
		if( !valueEdits.isEmpty()) {
			applyOneXpath( doc, valueEdits.subList(start, valueEdits.size()));
		}
	}
	
	//
	//  Getter setters below this point
	//
	

	public XpathHolder getXpathHolder() {
		return xpathHolder;
	}

	public void setXpathHolder(XpathHolder xpathHolder) {
		this.xpathHolder = xpathHolder;
	}

	public Long getDbID() {
		return dbID;
	}


	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}


	public Dataset getDataset() {
		return dataset;
	}

	public void setDataset(Dataset dataset) {
		this.dataset = dataset;
	}

	public String getMatchString() {
		return matchString;
	}

	public void setMatchString(String matchString) {
		this.matchString = matchString;
	}

	public String getReplaceString() {
		return replaceString;
	}

	public void setReplaceString(String replaceString) {
		this.replaceString = replaceString;
	}


	public Date getCreated() {
		return created;
	}


	public void setCreated(Date created) {
		this.created = created;
	}
	
	
}
