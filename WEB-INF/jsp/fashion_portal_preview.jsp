<%@ page import="gr.ntua.ivml.mint.util.Config" %>
<%@page pageEncoding="UTF-8"%>
<%
	String theContent = request.getParameter("content");
%>

<div>
        <form id="iframe-preview-form" method="post" action="http://ipa.image.ece.ntua.gr:9000/api/previewRecordTransformSimple" target="portalview">
                <input type="hidden" name="record" id="record" value='<% out.println(java.net.URLEncoder.encode(theContent.trim(), "UTF-8")); %>'>
        </form>
</div>

<script>
	$("#iframe-preview-form").submit();
</script>

<iframe name="portalview" src="" style="width: 100%; height: 500px">
</iframe>