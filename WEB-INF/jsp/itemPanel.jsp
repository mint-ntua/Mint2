<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.User" %>
<%@ page import="gr.ntua.ivml.mint.util.Config" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="org.apache.log4j.Logger" %>


<div id="nitems" style="display:none;"><%=request.getAttribute("ItemCount")%></div>
<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div id="message<s:property value="userId"/>_<s:property value="orgId"/>" style="width: 390px;height:20px;padding:3px;"><font color="red"><s:property escape="false" /> </font></div>
		</s:iterator>
	</s:if>	
	<div class="summary"></div>


        <s:if test="items.size>0">
         <s:iterator id="item" value="items">
         <s:if test="getTransformed()">
         <s:set var="default_preview" value="%{'Transformation Output'}" />
          <s:set var="scene" value="%{'fixedMap_output'}"/>
         </s:if>
         <s:else>
            <s:set var="default_preview" value="%{'Original XML'}" />
              <s:set var="scene" value="%{'input'}"/>
         
         </s:else>
          <script type="text/javascript">
          allviewoptions=0;
           if(scene==""){
              scene="<s:property value="scene"/>";
              scenelabel="<s:property value="default_preview"/>";
           }
          
          </script>
		
		<div title="<s:property value="fullImportname" />, Created: <s:property value="date" />"
			           onclick=" javascript:allviewoptions=0;   var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active'); $(this).toggleClass('k-active');
			           $K.kaiten('removeChildren',cp, false);$K.kaiten('load', { kConnector:'html.page',url:'XMLPreview.action?itemId=<s:property value="itemId"/>&uploadId=<s:property value="uploadId"/>&scene='+scene+'&label='+scenelabel+'&selMapping='+scene_selmap+'&mappingSelector='+frommaptool, kTitle:'Item Preview' });"  class="items navigable">
		 				
						<div class="label" style="width:80%">						
						<s:property value="shortName"/></div>
						
						
						<div class="info">
						<s:if test="isValid()==false">
							   <img src="images/problem.png" style="margin-top:10px;" onMouseOver="this.style.cursor='pointer';" title="invalid item">
						</s:if>
						
						</div>
						<div class="tail"></div>
					</div>			
		</s:iterator>
		</s:if>
		<s:else>
				
		<div class="summary">
             <div class="info">Error while retrieving items. </div>
         </div>  
      

		</s:else>
  


