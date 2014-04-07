<%@ include file="_include.jsp"%>
<%@page import="java.util.Iterator"%>

<%@page import="gr.ntua.ivml.mint.persistent.XpathHolder" %>
<%@page import="gr.ntua.ivml.mint.persistent.XpathStatsValues" %>
<%@page import="gr.ntua.ivml.mint.db.DB" %>
<%@page import="java.util.List" %>


<div id="ajaxTableContainer">
<table id="ajaxTable">
<thead> 
  <tr>
    <th> Value </th>
    <th> Frequency </th>
  </tr>
</thead>
<tbody>
<%
	// get the XpathHolder
	String xpathStringId = request.getParameter("pathId");
	try {
		XpathHolder xp = DB.getXpathHolderDAO().getById(
				Long.parseLong(xpathStringId), false);
		if (xp.getTextNode() != null)
			xp = xp.getTextNode();
		if (xp.isAttributeNode() || xp.isTextNode()) {
			List<XpathStatsValues.ValueStat> elements = xp.getValues(0, 30);
			for (XpathStatsValues.ValueStat oa : elements) {
				String value = oa.value;
				Long count = (long) oa.count;
%>
	<tr>
		<td> <%=value%></td>
		<td> <%=count%></td>
	</tr>
<%
			}
		}
	} catch (Exception e) {
		log.error("Problem", e);
	}
%>
</tbody>
</table>
</div>
		 

