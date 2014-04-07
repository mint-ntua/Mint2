package gr.ntua.ivml.mint.util;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;

import javax.servlet.jsp.JspWriter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JSStatsTree {
	public JSStatsTree() {
	}
	
	public static JSONArray getJSONObject(Dataset ds) {
		JSONArray result = new JSONArray();
		
		List<? extends TraversableI> children = ds.getRootHolder().getChildren();
		result = JSStatsTree.getJSONObject(children);
		
		
		return result;
	}

	
	public JSONArray getJSONTable(Dataset ds) {
		JSONArray result = new JSONArray();
		try{
		   xpathTableRecurse(result, ds.getRootHolder(),0,0,0);
		}catch (Exception e){
			System.out.println(e.getMessage());
		}
				
		return result;
	}

	
	public static JSONArray getJSONObject(List<? extends TraversableI> children) {
		JSONArray result = new JSONArray();
		
		for(TraversableI t : children) {
			XpathHolder xp = (XpathHolder) t;
			if(!xp.isTextNode()) {
				JSONObject child = JSStatsTree.getJSONObject(xp);
				result.add(child);
			}
		}

		return result;
	}

	public static JSONObject getJSONObject(XpathHolder xp) {
		JSONObject result = new JSONObject();
		
		//JSONObject data = new JSONObject();
		result.element("xpath", xp.getNameWithPrefix(true));
		
		result.element("id",  xp.getDbID());
		
		if (xp.isAttributeNode()) {
			//attribute stuff
			result.element("count",xp.getCount());
			result.element("length",xp.getAvgLength());
			result.element("distinct",xp.getDistinctCount());
		
		} else {
			
			XpathHolder text = xp.getTextNode();
			if (text == null) {
				result.element("count","");
				result.element("length","");
				result.element("distinct","");
			} else {
				// text node stuff
				result.element("count",text.getCount());
				result.element("length",text.getAvgLength());
				result.element("distinct",text.getDistinctCount());
			}
		}
		
		
				
		List<? extends TraversableI> children = xp.getChildren();
		result.element("children", JSStatsTree.getJSONObject(children));
		
		return result;
		
   }
	
	public void xpathTableRecurse(JSONArray resarray,XpathHolder xp,int level , int indent,int parent) throws IOException {


		if (!xp.isTextNode()){


			String name = xp.getNameWithPrefix(true);

			JSONObject result = new JSONObject();
			int id=resarray.size();
			result.element("id",  id);
			result.element("xpath", xp.getNameWithPrefix(true));
			result.element("xpathHolderId", xp.getDbID());
			result.element("count", xp.getCount());
			if(xp.getChildren().size()==1 && (xp.getChildren().get(0).isTextNode())){

				indent=indent+2;
				//out.print("&nbsp;&nbsp;<img src='images/leaf.gif'/>&nbsp;" );
			} else if( xp.getChildren().size()>0 && name.length()>0){
				indent++;  

				//out.print("&nbsp;<img src='css/images/foldertrans.png'/>&nbsp;" );
			} else if(xp.getChildren().size()==0 || xp.isAttributeNode() || xp.getTextNode()!=null) {

				indent=indent+2; 
				//out.print("&nbsp;&nbsp;<img src='images/leaf.gif'/>&nbsp;");
			}
			result.element("indent", indent);
			if(level>0 && resarray.size()>0)
				result.element("parent", parent);

			else{result.element("parent","");}
			if (xp.isAttributeNode()) {
				//attribute stuff
				result.element("count",xp.getCount());
				float ln=xp.getAvgLength();
				DecimalFormat oneDPoint = new DecimalFormat("#.#");
				result.element("length",oneDPoint.format(ln));
				result.element("distinct",xp.getDistinctCount());

			} else {

				XpathHolder text = xp.getTextNode();
				if (text == null) {
					result.element("length","");
					result.element("distinct","");
				} else {
					// text node stuff
					result.element("count",text.getCount());
					float ln=text.getAvgLength();
					DecimalFormat oneDPoint = new DecimalFormat("#.#");
					result.element("length",oneDPoint.format(ln));

					result.element("distinct",text.getDistinctCount());
				}
			}

			if(name.length()>0) 
				resarray.add(result);

			for (XpathHolder child : xp.getChildren())
				xpathTableRecurse(resarray,child, level+1 , indent,id);

		}
	}
	 
}