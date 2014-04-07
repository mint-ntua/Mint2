<%@ page isErrorPage="true"%>
   
<%@ include file="_include.jsp"%>

<%@page pageEncoding="UTF-8"%>

<div class="panel-body">
 <div class="block-nav">

	<div class="summary">
		<s:if test="exception!=null">
        	<h4>Exception</h4>
        	<s:property value="%{exception.message}"/>

        	<h4>Stack trace</h4>
        	<s:property value="%{exception.stackTrace}"/>
        	
        	<h4>Full Stack trace</h4>
         	<s:set name="ex" value="%{exception}" scope="page"/>
        	<%
                Exception ex = (Exception)pageContext.getAttribute("ex");
    			for (StackTraceElement element : ex.getStackTrace()) {
        			out.println(element.toString());
        			out.println("<br/>");
    			}
        	%>
      </s:if>
    </div>
 
 </div>
</div>





