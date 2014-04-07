<%@page import="java.util.HashMap"%>
<%@page import="java.util.Collection"%>
<%@page import="net.sf.json.*"%>
<%@page import="gr.ntua.ivml.mint.util.*"%>
<%@page import="gr.ntua.ivml.mint.mapping.*"%>
<jsp:useBean id='mappings' class='gr.ntua.ivml.mint.mapping.MappingManager' scope='session'/>
<%
	request.setCharacterEncoding("UTF-8");
	out.clear();
	response.setContentType("text/plain; charset=UTF-8");

	MappingAjax.execute(mappings, request, out);
%>
