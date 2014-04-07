
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.User" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="org.apache.log4j.Logger" %>


<div id="nimports" style="display:none;"><%=request.getAttribute("importCount")%></div>
<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div class="message" style="width: 390px;height:20px;padding:3px;"><font color="red"><s:property escape="false" /> </font></div>
		</s:iterator>
	</s:if>	
	<div class="summary"></div>

	 <s:if test="imports.size>0">
	 <form id="importsPanelform" name='imports_<s:property value="userId"/>_<s:property value="orgId"/>'>
		 <s:iterator id="impt" value="imports">
		
		 				<div id="<s:property value="dbID"/>" title="<s:property value="name"/>" 
		 				onclick="ajaxFetchStatus(<s:property value="dbID"/>);var cp=$($(this).closest('div[id^=kp]'));
		 				$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');
		 				$K.kaiten('removeChildren',cp, false);
		 				$K.kaiten('load',{kConnector:'html.page', url:'DatasetOptions.action?uploadId=<s:property value="dbID"/>&userId=<s:property value="userId"/>&organizationId=<s:property value="orgId"/>', kTitle:'Dataset Options' });"
		 			    class="items navigable" style="min-height:30px;height:auto;">
		 				
		 				<div class="head">
		 				   <s:if test="isOai()">
                          <img src="images/oai_symbol.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;" title="<s:property value="fullOai"/>">
                          </s:if>
                          <s:elseif test="isZip()">
						<img src="images/zip-icon.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;">
						</s:elseif>
						<s:elseif test="isTgz()" >
						<img src="images/tgz-icon.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;">
						</s:elseif>
						<s:elseif test="isXml()" >
						<img src="images/xml2.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;">
						</s:elseif>
						<s:elseif test="isCsv()" >
						<img src="images/csv-icon.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;">
						</s:elseif>
						<s:else >
						<img src="images/xml2.png" style="position:absolute;max-width:30px;max-height:30px;top:-1px;">
						</s:else>
					     </div>
		 				
						<div class="importLabel">						
						 
						<s:property value="name"/>
						</div>
						<s:if test="orgFolderNum>0">
						<div class="labelassign lbutton" title="Set labels for upload"></div>
						</s:if>
						<div class="importInfo">
						<!-- status icon goes here -->
						
						
			            <s:if test="status!='OK' && status!='FAILED' && status!='UNKNOWN'">
				            <span id="import_stat_<s:property value="dbID"/>" class="yui-skin-sam">
									 
											  <!-- ajax for working imports -->
											  <script>ajaxFetchStatus(<s:property value="dbID"/>);</script>
									
							</span>
						</s:if>
						
						<s:else>
									      <!-- do html -->
						   <img id="context<s:property value="dbID"/>" src="<s:property value="statusIcon"/>" style="vertical-align:sub;width:16px;height:16px;" onMouseOver="this.style.cursor='pointer';" title="<s:property value="message"/>">

									      
					    </s:else>
						
						</div>
						<div class="tail"></div>
						<div id="labeldiv" style="margin-top:-10px;">
						<s:if test="folderNum>0">
						    <s:iterator id="lbl" value="labels">
						    <span class="labels" style="background-color:<s:property value="lblcolor"/>;"><s:property value="lblname"/></span>
						    </s:iterator>
						</s:if>
						</div>
						
					</div>
		   			</s:iterator>
		   			
            </form>
           </s:if>
           
           <s:else>	
           <div class="summary">
             <div class="label">No imports</div>
            <!-- hide for now
            
             <div class="info">No imports found. Would you like to <a onclick="javascript:$K.kaiten('load',{ kConnector:'html.page', url:'Import_input.action', 'kTitle':'Start Import' });" >
             import an archive</a>?</div>
             -->
           </div>   
	      </s:else>
	         

		
