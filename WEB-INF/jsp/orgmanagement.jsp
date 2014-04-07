<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="gr.ntua.ivml.mint.persistent.Organization;"%>

<% String uaction=(String)request.getAttribute("uaction");
   if(uaction==null){uaction="";}
   Organization selorg=(Organization)request.getAttribute("selorg");
  if(uaction.equalsIgnoreCase("showorg") || ( request.getAttribute( "actionmessage" ) != null  && ((String)request.getAttribute( "actionmessage" )).indexOf("save")>0)){%>   
<script>ajaxOrgsPanel(0, orglimit,foid);</script>
<%}%>	
	
<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	<div class="label"></div>
	 <s:if test="hasActionErrors() || actionmessage!=null">
	 
	
	<% if( request.getAttribute( "actionmessage" ) != null ) {  %>
		<div class="errorMessage">
		<%=(String) request.getAttribute( "actionmessage" )%></div>
		<script type="text/javascript">
		
		
		</script>
      <%}%>
					
		   <s:if test="hasActionErrors()">
				<s:iterator value="actionErrors">
					<div class="errorMessage"><s:property escape="false" /> </div>
				</s:iterator>
			</s:if>
			
		</s:if>		<s:else><div class="info">&nbsp;</div></s:else>
		</div>
		<div style="margin-top:10px; padding: 0 5px 0 5px;">

		<%
		if(selorg!=null && (uaction.equalsIgnoreCase("editorg") || uaction.equalsIgnoreCase("saveorg") || uaction.equalsIgnoreCase("createorg"))){ 
		%>
		
		
		<s:form name="orgform" action="Management" cssClass="athform" theme="mytheme">
			
			 <div class="fitem">
			    <s:select label="Country" name="selorg.country"  
				list="#{'':'--no country--', 'Afghanistan':'Afghanistan',  'Åland Islands':'Åland Islands',  'Albania':'Albania',  'Algeria':'Algeria',  'American Samoa':'American Samoa',  'Andorra':'Andorra',  'Angola':'Angola',  'Anguilla':'Anguilla',  'Antarctica':'Antarctica', 'Antigua and Barbuda':'Antigua and Barbuda',  'Argentina':'Argentina',  'Armenia':'Armenia',  'Aruba':'Aruba',  'Australia':'Australia',  'Austria':'Austria',  'Azerbaijan':'Azerbaijan',  'Bahamas':'Bahamas',  'Bahrain':'Bahrain',  'Bangladesh':'Bangladesh',  'Barbados':'Barbados', 'Belarus':'Belarus',  'Belgium':'Belgium',  'Belize':'Belize',  'Benin':'Benin',  'Bermuda':'Bermuda',  'Bhutan':'Bhutan',  'Bolivia':'Bolivia',  'Bosnia and Herzegovina':'Bosnia and Herzegovina',  'Botswana':'Botswana',  'Bouvet Island':'Bouvet Island',  'Brazil':'Brazil',  'British Indian Ocean Territory':'British Indian Ocean Territory', 'Brunei':'Brunei', 'Bulgaria':'Bulgaria',  'Burkina Faso':'Burkina Faso',  'Burundi':'Burundi',  'Cambodia':'Cambodia',  'Cameroon':'Cameroon',  'Canada':'Canada',  'Cape Verde':'Cape Verde',  'Cayman Islands':'Cayman Islands',  'Central African Republic':'Central African Republic',  'Chad':'Chad', 'Chile':'Chile',  'China':'China',  'Christmas Island':'Christmas Island',  'Cocos (Keeling) Islands':'Cocos (Keeling) Islands',  'Colombia':'Colombia',  'Comoros':'Comoros',  'Congo':'Congo',  'Congo (DRC)':'Congo (DRC)',  'Cook Islands':'Cook Islands',  'Costa Rica':'Costa Rica',  'Côte d Ivoire':'Côte d Ivoire',  'Croatia':'Croatia', 'Cuba':'Cuba', 'Cyprus':'Cyprus',  'Czech Republic':'Czech Republic',  'Denmark':'Denmark',  'Djibouti':'Djibouti',  'Dominica':'Dominica',  'Dominican Republic':'Dominican Republic',  'Ecuador':'Ecuador',  'Egypt':'Egypt',  'El Salvador':'El Salvador',  'Equatorial Guinea':'Equatorial Guinea',  'Eritrea':'Eritrea',  'Estonia':'Estonia', 'Ethiopia':'Ethiopia',  'Falkland Islands (Islas Malvinas)':'Falkland Islands (Islas Malvinas)',  'Faroe Islands':'Faroe Islands',  'Fiji Islands':'Fiji Islands',  'Finland':'Finland',  'France':'France',  'French Guiana':'French Guiana',  'French Polynesia':'French Polynesia',  'French Southern and Antarctic Lands':'French Southern and Antarctic Lands',  'Gabon':'Gabon', 'Gambia':'Gambia',  'Georgia':'Georgia',  'Germany':'Germany',  'Ghana':'Ghana',  'Gibraltar':'Gibraltar',  'Greece':'Greece',  'Greenland':'Greenland',  'Grenada':'Grenada',  'Guadeloupe':'Guadeloupe',  'Guam':'Guam',  'Guatemala':'Guatemala',  'Guernsey':'Guernsey',  'Guinea':'Guinea',  'Guinea-Bissau':'Guinea-Bissau', 'Guyana':'Guyana',  'Haiti':'Haiti',  'Heard Island and McDonald Islands':'Heard Island and McDonald Islands',  'Honduras':'Honduras',  'Hong Kong SAR':'Hong Kong SAR',  'Hungary':'Hungary',  'Iceland':'Iceland',  'India':'India',  'Indonesia':'Indonesia',  'Iran':'Iran',  'Iraq':'Iraq',  'Ireland':'Ireland',  'Isle of Man':'Isle of Man',  'Israel':'Israel',  'Italy':'Italy', 'Jamaica':'Jamaica', 'Jan Mayen':'Jan Mayen', 'Japan':'Japan', 'Jersey':'Jersey', 'Jordan':'Jordan', 'Kazakhstan':'Kazakhstan', 'Kenya':'Kenya', 'Kiribati':'Kiribati', 'Korea':'Korea', 'Kuwait':'Kuwait', 'Kyrgyzstan':'Kyrgyzstan', 'Laos':'Laos', 'Latvia':'Latvia', 'Lebanon':'Lebanon', 'Lesotho':'Lesotho', 'Liberia':'Liberia', 'Libya':'Libya', 'Liechtenstein':'Liechtenstein', 'Lithuania':'Lithuania', 'Luxembourg':'Luxembourg', 'Macao SAR':'Macao SAR', 'Macedonia, Former Yugoslav Republic of':'Macedonia, Former Yugoslav Republic of', 'Madagascar':'Madagascar', 'Malawi':'Malawi', 'Malaysia':'Malaysia', 'Maldives':'Maldives', 'Mali':'Mali', 'Malta':'Malta', 'Marshall Islands':'Marshall Islands', 'Martinique':'Martinique', 'Mauritania':'Mauritania', 'Mauritius':'Mauritius', 'Mayotte':'Mayotte', 'Mexico':'Mexico', 'Micronesia':'Micronesia', 'Moldova':'Moldova', 'Monaco':'Monaco', 'Mongolia':'Mongolia', 'Montenegro':'Montenegro', 'Montserrat':'Montserrat', 'Morocco':'Morocco', 'Mozambique':'Mozambique', 'Myanmar':'Myanmar', 'Namibia':'Namibia', 'Nauru':'Nauru', 'Nepal':'Nepal', 'Netherlands':'Netherlands', 'Netherlands Antilles':'Netherlands Antilles', 'New Caledonia':'New Caledonia', 'New Zealand':'New Zealand', 'Nicaragua':'Nicaragua', 'Niger':'Niger', 'Nigeria':'Nigeria', 'Niue':'Niue', 'Norfolk Island':'Norfolk Island', 'North Korea':'North Korea', 'Northern Mariana Islands':'Northern Mariana Islands', 'Norway':'Norway', 'Oman':'Oman', 'Pakistan':'Pakistan', 'Palau':'Palau', 'Palestinian Authority':'Palestinian Authority', 'Panama':'Panama', 'Papua New Guinea':'Papua New Guinea', 'Paraguay':'Paraguay', 'Peru':'Peru', 'Philippines':'Philippines', 'Pitcairn Islands':'Pitcairn Islands', 'Poland':'Poland', 'Portugal':'Portugal', 'Puerto Rico':'Puerto Rico', 'Qatar':'Qatar', 'Reunion':'Reunion', 'Romania':'Romania', 'Russia':'Russia', 'Rwanda':'Rwanda', 'Samoa':'Samoa', 'San Marino':'San Marino', 'São Tomé and Príncipe':'São Tomé and Príncipe', 'Saudi Arabia':'Saudi Arabia', 'Senegal':'Senegal', 'Serbia':'Serbia', 'Seychelles':'Seychelles', 'Sierra Leone':'Sierra Leone', 'Singapore':'Singapore', 'Slovakia':'Slovakia', 'Slovenia':'Slovenia', 'Solomon Islands':'Solomon Islands', 'Somalia':'Somalia', 'South Africa':'South Africa', 'South Georgia and the South Sandwich Islands':'South Georgia and the South Sandwich Islands', 'Spain':'Spain', 'Sri Lanka':'Sri Lanka', 'St. Barthélemy':'St. Barthélemy', 'St. Helena':'St. Helena', 'St. Kitts and Nevis':'St. Kitts and Nevis', 'St. Lucia':'St. Lucia', 'St. Martin':'St. Martin', 'St. Pierre and Miquelon':'St. Pierre and Miquelon', 'St. Vincent and the Grenadines':'St. Vincent and the Grenadines', 'Sudan':'Sudan', 'Suriname':'Suriname', 'Swaziland':'Swaziland', 'Sweden':'Sweden', 'Switzerland':'Switzerland', 'Syria':'Syria', 'Taiwan':'Taiwan', 'Tajikistan':'Tajikistan', 'Tanzania':'Tanzania', 'Thailand':'Thailand', 'Timor-Leste':'Timor-Leste', 'Togo':'Togo', 'Tokelau':'Tokelau', 'Tonga':'Tonga', 'Trinidad and Tobago':'Trinidad and Tobago', 'Tunisia':'Tunisia', 'Turkey':'Turkey', 'Turkmenistan':'Turkmenistan', 'Turks and Caicos Islands':'Turks and Caicos Islands', 'Tuvalu':'Tuvalu', 'Uganda':'Uganda', 'Ukraine':'Ukraine', 'United Arab Emirates':'United Arab Emirates', 'United Kingdom':'United Kingdom', 'United States':'United States', 'United States Minor Outlying Islands':'United States Minor Outlying Islands', 'Uruguay':'Uruguay', 'Uzbekistan':'Uzbekistan', 'Vanuatu':'Vanuatu', 'Vatican City':'Vatican City', 'Venezuela':'Venezuela', 'Vietnam':'Vietnam', 'Virgin Islands, British':'Virgin Islands, British', 'Virgin Islands, U.S.':'Virgin Islands, U.S.', 'Wallis and Futuna':'Wallis and Futuna', 'Yemen':'Yemen', 'Zambia':'Zambia', 'Zimbabwe':'Zimbabwe'}"  value="%{selorg.country}" required="true"/>
			  
			</div>
			 <div class="fitem">
			<s:textfield name="selorg.englishName"  label="English name" required="true" />
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="selorg.originalName"  label="Name" required="true" />
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="selorg.shortName"  label="Organization acronym"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:select label="Type" name="selorg.type"  
				list="#{'':'--not specified--', 'Museum and Gallery':'Museum and Gallery','Library':'Library','Archive':'Archive',
				 'Audio Visual Organization':'Audio Visual Organization','Research and educational organisation':'Research and educational organisation',
				 'Cross-domain organisation':'Cross-domain organisation','Publisher':'Publisher',
				 'Heritage site':'Heritage site','Other':'Other'}"  value="%{selorg.type}" required="true"/>
				
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="selorg.address" label="Address" />
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="selorg.urlPattern"   label="Organization url"/>
			</div>
			<div class="fitem">
			<s:textarea name="selorg.description"  cssStyle="width:50%" label="Organization description" />
			</div>
			
			<%if(user.hasRight(User.SUPER_USER) || user.getOrganization()==null || (uaction.equalsIgnoreCase("editorg") && selorg.getParentalOrganization()==null)){ %>
				
			<div class="fitem"><s:select label="Select parent organization" name="parentorg" 
					headerKey="0" headerValue="-- No parent --" listKey="dbID"
					listValue="name+', '+country" list="connOrgs" value="%{selorg.parentalOrganization.{dbID}}" 
					/></div><%}else{ %>
			    
			<div class="fitem"><s:select label="Parent organization" name="parentorg"   listKey="dbID"
					listValue="name+', '+country" list="connOrgs" value="%{selorg.parentalOrganization.{dbID}}" 
					/></div><%} %>
				<div class="fitem"><s:select label="Primary contact user" name="primaryuser"
					headerKey="0" headerValue="-- Please Select --" listKey="dbID"
					listValue="login" list="adminusers" value="%{selorg.primaryContact.{dbID}}" required="true"
					/></div>
				<%if(user.hasRight(User.SUPER_USER)){ %>
			
			<div class="fitem"><label>
				Organization can publish</label><s:checkbox name="selorg.publishAllowed" cssClass="checks"/> 
					
				</div>
			<%} %>
			<p align="left">
				<a class="navigable focus k-focus"  
					 onclick="saveOrg();">
					 <span>Submit</span></a>  
				<a class="navigable focus k-focus"  onclick="this.blur();document.orgform.reset();"><span>Reset</span></a>  
			
					
				<input type="hidden" name="uaction" value="saveorg"/>
				<s:if test="%{selorg.dbID!=null}">
				<s:hidden name="selorg.dbID"/>				
			     </s:if>			
	
				</p>
			
		</s:form>
		
		
		
		
		
		<%}else{ %>
		
		<s:form cssClass="athform" theme="mytheme" style="width:100%;margin:0;padding:5px;">
		   <div class="fitem">
			   <s:select label="Country" name="selorg.country"  
				list="#{'':'--no country--', 'Afghanistan':'Afghanistan',  'Åland Islands':'Åland Islands',  'Albania':'Albania',  'Algeria':'Algeria',  'American Samoa':'American Samoa',  'Andorra':'Andorra',  'Angola':'Angola',  'Anguilla':'Anguilla',  'Antarctica':'Antarctica', 'Antigua and Barbuda':'Antigua and Barbuda',  'Argentina':'Argentina',  'Armenia':'Armenia',  'Aruba':'Aruba',  'Australia':'Australia',  'Austria':'Austria',  'Azerbaijan':'Azerbaijan',  'Bahamas':'Bahamas',  'Bahrain':'Bahrain',  'Bangladesh':'Bangladesh',  'Barbados':'Barbados', 'Belarus':'Belarus',  'Belgium':'Belgium',  'Belize':'Belize',  'Benin':'Benin',  'Bermuda':'Bermuda',  'Bhutan':'Bhutan',  'Bolivia':'Bolivia',  'Bosnia and Herzegovina':'Bosnia and Herzegovina',  'Botswana':'Botswana',  'Bouvet Island':'Bouvet Island',  'Brazil':'Brazil',  'British Indian Ocean Territory':'British Indian Ocean Territory', 'Brunei':'Brunei', 'Bulgaria':'Bulgaria',  'Burkina Faso':'Burkina Faso',  'Burundi':'Burundi',  'Cambodia':'Cambodia',  'Cameroon':'Cameroon',  'Canada':'Canada',  'Cape Verde':'Cape Verde',  'Cayman Islands':'Cayman Islands',  'Central African Republic':'Central African Republic',  'Chad':'Chad', 'Chile':'Chile',  'China':'China',  'Christmas Island':'Christmas Island',  'Cocos (Keeling) Islands':'Cocos (Keeling) Islands',  'Colombia':'Colombia',  'Comoros':'Comoros',  'Congo':'Congo',  'Congo (DRC)':'Congo (DRC)',  'Cook Islands':'Cook Islands',  'Costa Rica':'Costa Rica',  'Côte d Ivoire':'Côte d Ivoire',  'Croatia':'Croatia', 'Cuba':'Cuba', 'Cyprus':'Cyprus',  'Czech Republic':'Czech Republic',  'Denmark':'Denmark',  'Djibouti':'Djibouti',  'Dominica':'Dominica',  'Dominican Republic':'Dominican Republic',  'Ecuador':'Ecuador',  'Egypt':'Egypt',  'El Salvador':'El Salvador',  'Equatorial Guinea':'Equatorial Guinea',  'Eritrea':'Eritrea',  'Estonia':'Estonia', 'Ethiopia':'Ethiopia',  'Falkland Islands (Islas Malvinas)':'Falkland Islands (Islas Malvinas)',  'Faroe Islands':'Faroe Islands',  'Fiji Islands':'Fiji Islands',  'Finland':'Finland',  'France':'France',  'French Guiana':'French Guiana',  'French Polynesia':'French Polynesia',  'French Southern and Antarctic Lands':'French Southern and Antarctic Lands',  'Gabon':'Gabon', 'Gambia':'Gambia',  'Georgia':'Georgia',  'Germany':'Germany',  'Ghana':'Ghana',  'Gibraltar':'Gibraltar',  'Greece':'Greece',  'Greenland':'Greenland',  'Grenada':'Grenada',  'Guadeloupe':'Guadeloupe',  'Guam':'Guam',  'Guatemala':'Guatemala',  'Guernsey':'Guernsey',  'Guinea':'Guinea',  'Guinea-Bissau':'Guinea-Bissau', 'Guyana':'Guyana',  'Haiti':'Haiti',  'Heard Island and McDonald Islands':'Heard Island and McDonald Islands',  'Honduras':'Honduras',  'Hong Kong SAR':'Hong Kong SAR',  'Hungary':'Hungary',  'Iceland':'Iceland',  'India':'India',  'Indonesia':'Indonesia',  'Iran':'Iran',  'Iraq':'Iraq',  'Ireland':'Ireland',  'Isle of Man':'Isle of Man',  'Israel':'Israel',  'Italy':'Italy', 'Jamaica':'Jamaica', 'Jan Mayen':'Jan Mayen', 'Japan':'Japan', 'Jersey':'Jersey', 'Jordan':'Jordan', 'Kazakhstan':'Kazakhstan', 'Kenya':'Kenya', 'Kiribati':'Kiribati', 'Korea':'Korea', 'Kuwait':'Kuwait', 'Kyrgyzstan':'Kyrgyzstan', 'Laos':'Laos', 'Latvia':'Latvia', 'Lebanon':'Lebanon', 'Lesotho':'Lesotho', 'Liberia':'Liberia', 'Libya':'Libya', 'Liechtenstein':'Liechtenstein', 'Lithuania':'Lithuania', 'Luxembourg':'Luxembourg', 'Macao SAR':'Macao SAR', 'Macedonia, Former Yugoslav Republic of':'Macedonia, Former Yugoslav Republic of', 'Madagascar':'Madagascar', 'Malawi':'Malawi', 'Malaysia':'Malaysia', 'Maldives':'Maldives', 'Mali':'Mali', 'Malta':'Malta', 'Marshall Islands':'Marshall Islands', 'Martinique':'Martinique', 'Mauritania':'Mauritania', 'Mauritius':'Mauritius', 'Mayotte':'Mayotte', 'Mexico':'Mexico', 'Micronesia':'Micronesia', 'Moldova':'Moldova', 'Monaco':'Monaco', 'Mongolia':'Mongolia', 'Montenegro':'Montenegro', 'Montserrat':'Montserrat', 'Morocco':'Morocco', 'Mozambique':'Mozambique', 'Myanmar':'Myanmar', 'Namibia':'Namibia', 'Nauru':'Nauru', 'Nepal':'Nepal', 'Netherlands':'Netherlands', 'Netherlands Antilles':'Netherlands Antilles', 'New Caledonia':'New Caledonia', 'New Zealand':'New Zealand', 'Nicaragua':'Nicaragua', 'Niger':'Niger', 'Nigeria':'Nigeria', 'Niue':'Niue', 'Norfolk Island':'Norfolk Island', 'North Korea':'North Korea', 'Northern Mariana Islands':'Northern Mariana Islands', 'Norway':'Norway', 'Oman':'Oman', 'Pakistan':'Pakistan', 'Palau':'Palau', 'Palestinian Authority':'Palestinian Authority', 'Panama':'Panama', 'Papua New Guinea':'Papua New Guinea', 'Paraguay':'Paraguay', 'Peru':'Peru', 'Philippines':'Philippines', 'Pitcairn Islands':'Pitcairn Islands', 'Poland':'Poland', 'Portugal':'Portugal', 'Puerto Rico':'Puerto Rico', 'Qatar':'Qatar', 'Reunion':'Reunion', 'Romania':'Romania', 'Russia':'Russia', 'Rwanda':'Rwanda', 'Samoa':'Samoa', 'San Marino':'San Marino', 'São Tomé and Príncipe':'São Tomé and Príncipe', 'Saudi Arabia':'Saudi Arabia', 'Senegal':'Senegal', 'Serbia':'Serbia', 'Seychelles':'Seychelles', 'Sierra Leone':'Sierra Leone', 'Singapore':'Singapore', 'Slovakia':'Slovakia', 'Slovenia':'Slovenia', 'Solomon Islands':'Solomon Islands', 'Somalia':'Somalia', 'South Africa':'South Africa', 'South Georgia and the South Sandwich Islands':'South Georgia and the South Sandwich Islands', 'Spain':'Spain', 'Sri Lanka':'Sri Lanka', 'St. Barthélemy':'St. Barthélemy', 'St. Helena':'St. Helena', 'St. Kitts and Nevis':'St. Kitts and Nevis', 'St. Lucia':'St. Lucia', 'St. Martin':'St. Martin', 'St. Pierre and Miquelon':'St. Pierre and Miquelon', 'St. Vincent and the Grenadines':'St. Vincent and the Grenadines', 'Sudan':'Sudan', 'Suriname':'Suriname', 'Swaziland':'Swaziland', 'Sweden':'Sweden', 'Switzerland':'Switzerland', 'Syria':'Syria', 'Taiwan':'Taiwan', 'Tajikistan':'Tajikistan', 'Tanzania':'Tanzania', 'Thailand':'Thailand', 'Timor-Leste':'Timor-Leste', 'Togo':'Togo', 'Tokelau':'Tokelau', 'Tonga':'Tonga', 'Trinidad and Tobago':'Trinidad and Tobago', 'Tunisia':'Tunisia', 'Turkey':'Turkey', 'Turkmenistan':'Turkmenistan', 'Turks and Caicos Islands':'Turks and Caicos Islands', 'Tuvalu':'Tuvalu', 'Uganda':'Uganda', 'Ukraine':'Ukraine', 'United Arab Emirates':'United Arab Emirates', 'United Kingdom':'United Kingdom', 'United States':'United States', 'United States Minor Outlying Islands':'United States Minor Outlying Islands', 'Uruguay':'Uruguay', 'Uzbekistan':'Uzbekistan', 'Vanuatu':'Vanuatu', 'Vatican City':'Vatican City', 'Venezuela':'Venezuela', 'Vietnam':'Vietnam', 'Virgin Islands, British':'Virgin Islands, British', 'Virgin Islands, U.S.':'Virgin Islands, U.S.', 'Wallis and Futuna':'Wallis and Futuna', 'Yemen':'Yemen', 'Zambia':'Zambia', 'Zimbabwe':'Zimbabwe'}"  value="%{selorg.country}" disabled="true"/>
		 </div>
			  <div class="fitem">
			<s:textfield name="selorg.englishName"   label="English name" readonly="true" />
			</div>
			<div class="fitem">
			<s:textfield name="selorg.originalName"   label="Name" readonly="true" />
			</div>
			<div class="fitem">
			<s:textfield name="selorg.shortName"  label="Organization acronym"  readonly="true" />
			</div>
			<div class="fitem">
			<s:select label="Type" name="selorg.type"  
				list="#{'':'--not specified--', 'Museum and Gallery':'Museum and Gallery','Library':'Library','Archive':'Archive',
				 'Audio Visual Organization':'Audio Visual Organization','Research and educational organisation':'Research and educational organisation',
				 'Cross-domain organisation':'Cross-domain organisation','Publisher':'Publisher',
				 'Heritage site':'Heritage site','Other':'Other'}"  value="%{selorg.type}" disabled="true"/>
				
			</div>
			<div class="fitem">
			<s:textfield name="selorg.address" label="Address"  
					readonly="true" />
			</div>
			<div class="fitem">
			<s:textfield name="selorg.urlPattern"   label="Organization url"  readonly="true" />
			</div>
				<div class="fitem">
			<s:textarea name="selorg.description"  cssStyle="width:50%" label="Organization description"  readonly="true" />
			</div>
			<div class="fitem">
			<s:select label="Parent organization" name="parentorg"   
					headerKey="0" headerValue="-- No parent --" listKey="dbID"
					listValue="name+', '+country" list="connOrgs" value="%{selorg.parentalOrganization.{dbID}}" disabled="true"
					/>
			</div>
			<div class="fitem">
			<s:select label="Primary contact user" name="primaryuser"
					headerKey="0" headerValue="-- Please Select --" listKey="dbID"
					listValue="login" list="adminusers" value="%{selorg.primaryContact.{dbID}}"
					disabled="true"/>
			</div>
			<%if(user.hasRight(User.SUPER_USER)){ %>
			<div class="fitem"><label>
				Organization can publish</label><s:checkbox name="selorg.publishAllowed" cssClass="checks" disabled="true"/> 
					
				</div><%} %>
			
			 	<p align="left">
				<a class="navigable focus k-focus"  
				 
			  onclick="editOrg(<%=selorg.getDbID() %>);">
			  <span>Edit</span></a>  
				<a class="navigable focus k-focus"  onclick=" javascript:var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('removeChildren',cp, true);ajaxDeleteOrg(<%=selorg.getDbID() %>,<%if(user.getOrganization()==null){%>-1<%}else{%><%=user.getOrganization().getDbID()%><%}%>);"><span>Delete</span></a>
				</p>   	
		</s:form>
		
		
		
		<%}%> <!-- end org details -->


</div>
</div>

</div>

