<%@ page import="java.net.URLEncoder"%>
<%@page pageEncoding="UTF-8"%>
<iframe src='http://rhizomik.net/redefer-services/render?rdf=<%= URLEncoder.encode(request.getParameter("content"),"UTF-8") %>&format=RDF/XML&mode=svg&rules=http://rhizomik.net:8080/html/redefer/rdf2svg/showgraph.jrule'></iframe>