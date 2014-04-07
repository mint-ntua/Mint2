<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="lido xml" version="2.0"
  xmlns:crm="http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:lido="http://www.lido-schema.org"
  xmlns:ore="http://www.openarchives.org/ore/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:wgs84="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" standalone="yes" indent="yes"/>
  
<!-- version1_DRAFT-2013-07-31: lido-v1.0-to-edm-v5.2.4-transform-v1_DRAFT-2013-07-31-Partage.xsl -->
<!--
        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        xx  XSL Transform to convert LIDO XML data, according to http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd, 
		xx	into EDM RDF/XML, according to http://www.europeana.eu/schemas/edm/EDM.xsd (EDM v5.2.4, 2013-07-14)
		xx
		xx  Prepared for Linked Heritage (http://www.linkedheritage.org/) / Athena Plus (http://www.athenaplus.eu/) by 
		xx	Nikolaos Simou, National Technical University of Athens - NTUA (nsimou@image.ntua.gr)
		xx	Regine Stein, Bildarchiv Foto Marburg, Philipps-Universitaet Marburg - UNIMAR (r.stein@fotomarburg.de)
		xx
		xx  Notes: 
		xx  • If a resource in LIDO is identified by an http URI this URI is referenced by the EDM property and a respective EDM resource is created
		xx  • If, additionally or solely, a resource in LIDO is identified by a name for the resource an EDM property with the literal value is created
		xx  • If both index and display names for a LIDO resource are given the display variant is preferred as literal value of the EDM property
		xx
		xx  • If more than a lido record exist in the LIDO file the result is a file with a single root (<rdf:RDF>) and many providedCHOs and Aggregations
		xx  • lido:recordID and the dataProvider's name are used for the creation of dummy identifiers for providedCHOs and Aggregations
		xx
		xx  version1_DRAFT-2013-07-31
		xx
		xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-->
  
  <xsl:variable name="var0">
    <item>TEXT</item>
    <item>VIDEO</item>
    <item>IMAGE</item>
    <item>SOUND</item>
    <item>3D</item>
  </xsl:variable>
  
  
    <!-- Specify edm:provider -->
  <xsl:param name="edm_provider" select="'SET_PROVIDER'" />
  <!-- Specify edm:providedCHO baseURL -->
  <xsl:param name="edm_providedCHO" select="'SET_PROVIDEDCHO_BASEURL'" />
  <!-- Specify ore:Aggregation baseURL -->
  <xsl:param name="ore_Aggregation" select="'SET_AGGREGATION_BASEURL'" />
 
  
  
   <xsl:function name="lido:langSelect">
    <xsl:param name="metadataLang"/>
    <xsl:param name="localLang"/>
        <xsl:if test="( string-length($metadataLang) &lt; 4 and string-length($metadataLang) &gt; 0) or
        				(string-length($localLang) &lt; 4 and string-length($localLang) &gt; 0)">
			<xsl:choose>
  			<xsl:when test="(string-length($localLang) &lt; 4 and string-length($localLang) &gt; 0)">
  					<xsl:value-of select="$localLang"/>
  				</xsl:when>
  				<xsl:when test="( string-length($metadataLang) &lt; 4 and string-length($metadataLang) &gt; 0)">
  					<xsl:value-of select="$metadataLang"/>
  				</xsl:when>
  				<xsl:otherwise></xsl:otherwise>
  			</xsl:choose>
    	</xsl:if>
  </xsl:function>
 
  <xsl:template match="/"> 
     <rdf:RDF>
  <!-- <xsl:template match="/lido:lidoWrap/lido:lido | lido:lido"> -->
  <xsl:for-each select="/lido:lidoWrap/lido:lido | lido:lido">
  
    <xsl:variable name="descLang">
    	<xsl:for-each select="lido:descriptiveMetadata/@xml:lang">
			<xsl:value-of select="."/>
		</xsl:for-each>
    </xsl:variable>
    
     <xsl:variable name="adminLang">
    	<xsl:for-each select="lido:administrativeMetadata/@xml:lang">
			<xsl:value-of select="."/>
		</xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="dataProvider">
    	<xsl:choose>
			<xsl:when test="lido:administrativeMetadata/lido:recordWrap/lido:recordSource[lido:type='europeana:dataProvider']">
				<xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource[lido:type='europeana:dataProvider']/lido:legalBodyName/lido:appellationValue">
				  <xsl:if test="position() = 1">
					<edm:dataProvider>
					  <xsl:value-of select="."/>
					</edm:dataProvider>
				  </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue">
				  <xsl:if test="position() = 1">
					<edm:dataProvider>
					  <xsl:value-of select="."/>
					</edm:dataProvider>
				  </xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>

      <edm:ProvidedCHO>
        <xsl:attribute name="rdf:about">
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
          <!--<xsl:for-each select="lido:lidoRecID">-->
            <xsl:if test="position() = 1">
              <xsl:value-of select="concat($edm_providedCHO, $dataProvider,'/',.)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        
        <!-- dc:contributor Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228'))">
            <xsl:for-each select="lido:eventActor">
            <xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://')]">
                <dc:contributor>
                    <xsl:attribute name="rdf:resource">
                    <xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
    				<xsl:if test="position() = 1">
						<xsl:value-of select="."/>
					</xsl:if>
					</xsl:for-each>
					</xsl:attribute>
				</dc:contributor>
			</xsl:if>
            </xsl:for-each>
        </xsl:if>
       </xsl:for-each>
        <!-- dc:contributor Resource-->
      
        <!-- dc:contributor Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228'))">
        	<xsl:for-each select="lido:eventActor/lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">			
				<dc:contributor>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
                    <xsl:value-of select="."/>
      	  		</dc:contributor>
        	</xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        <!-- dc:contributor Literal-->
        
        <!-- dc:coverage -->

        <!-- dc:creator Resource-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
            <xsl:for-each select="lido:eventActor">
			<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://')]">
                <dc:creator>
					<xsl:attribute name="rdf:resource">
					<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
					<xsl:if test="position() = 1">
						<xsl:value-of select="."/>
					</xsl:if>
					</xsl:for-each>
					</xsl:attribute>
                </dc:creator>
			</xsl:if>
            </xsl:for-each>
        </xsl:if>
       </xsl:for-each>
        <!-- dc:creator Resource-->        
        
        <!-- dc:creator Literal-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
            <xsl:for-each select="lido:eventActor[lido:displayActorInRole or lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]]">
                <dc:creator>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
    				<xsl:choose>
						<xsl:when test="lido:displayActorInRole"><xsl:value-of select="lido:displayActorInRole[1]/text()" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" /></xsl:otherwise>
					</xsl:choose>
                </dc:creator>
            </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
	    <!-- dc:creator Literal-->   
	    
	    <!-- dc:date -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224'))">
        <xsl:for-each select="lido:eventDate">
        <xsl:if test="lido:date/lido:earliestDate | lido:displayDate">
        	<dc:date>
				<xsl:choose>
					<xsl:when test="lido:date/lido:earliestDate = lido:date/lido:latestDate">
						<xsl:value-of select="lido:date/lido:earliestDate"/>
					</xsl:when>
					<xsl:when test="lido:date/lido:earliestDate">
						<xsl:value-of select="concat(lido:date/lido:earliestDate, '/', lido:date/lido:latestDate)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="lido:displayDate" />
					</xsl:otherwise>
				</xsl:choose>
			</dc:date>
		</xsl:if>
        </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        <!-- dc:date -->  
		
		<!-- dc:description --> 
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceDescription">
			<xsl:if test="@lido:type">
				<dc:description>
					<xsl:if test="string-length( lido:langSelect($adminLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($adminLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
					<xsl:value-of select="concat(@lido:type, ': ')"/>
					<xsl:value-of select="." />
				</dc:description>	
			</xsl:if>
        </xsl:for-each>
      	<!-- dc:description --> 

    	
    	<!-- dc:description -->   
    	<xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:objectDescriptionWrap/lido:objectDescriptionSet[lido:descriptiveNoteValue/string-length(.)&gt;0]">
			<dc:description>
				<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
				
				
				<xsl:if test="@lido:type">
					<xsl:value-of select="concat(@lido:type, ': ')"/>
				</xsl:if>
				<xsl:for-each select="lido:descriptiveNoteValue">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:for-each>
				<xsl:if test="string-length(lido:sourceDescriptiveNote[1])&gt;0">
					<xsl:value-of select="concat(' (', lido:sourceDescriptiveNote[1], ')')" />
				</xsl:if>
				<xsl:if test="string-length(lido:descriptiveNoteID[1])&gt;0">
					<xsl:value-of select="concat(' (ID: ', lido:descriptiveNoteID[1], ')')" />
				</xsl:if>
			</dc:description>
		</xsl:for-each>
		<!-- dc:description -->   
        
        <!-- dc:description -->       
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceSource">
			<xsl:for-each select="lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            <xsl:if test="position() = 1">
            	<dc:description>
            		<xsl:if test="string-length( lido:langSelect($adminLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($adminLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
            	
					<xsl:if test="../../@lido:type">
						<xsl:value-of select="concat(../../@lido:type, ': ')"/>
					</xsl:if>
					<xsl:value-of select="." />
				</dc:description>
			</xsl:if>
			</xsl:for-each> 
        </xsl:for-each>
    	<!-- dc:description --> 
        
        <!-- dc:format Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]">
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://')]">
				<dc:format>
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="."/>
					</xsl:attribute>
                </dc:format>
			</xsl:for-each>	
        </xsl:for-each>
		<!-- dc:format Resource-->
        
        <!-- dc:format Literal-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech[lido:displayMaterialsTech or lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]]">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dcterms:medium>
					<xsl:value-of select="."/>
                </dcterms:medium>
			</xsl:for-each>	
        </xsl:for-each>
		<!-- dc:format Literal-->
        
        <!-- dc:identifier -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[not(@lido:type='former')]/lido:workID">
          <dc:identifier>
            <xsl:value-of select="."/>
          </dc:identifier>
        </xsl:for-each>
        <!-- dc:identifier -->

		<!-- dc:language -->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[@lido:type='language']/lido:term">
          <dc:language>
            <xsl:value-of select="."/>
          </dc:language>
        </xsl:for-each>
		<!-- dc:language -->   
		
		<!-- dc:publisher Resource-->  
		<xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
         <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228')">     
            <xsl:for-each select="lido:eventActor">
			<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://')]">
                <dc:publisher>
					<xsl:attribute name="rdf:resource">
					<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
					<xsl:if test="position() = 1">
						<xsl:value-of select="."/>
					</xsl:if>
					</xsl:for-each>
					</xsl:attribute>
                </dc:publisher>
			</xsl:if>
            </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
		<!-- dc:publisher Resource-->  
		
		<!-- dc:publisher Literal-->  
		 <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228')">
            <xsl:for-each select="lido:eventActor[lido:displayActorInRole or lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]]">
                <dc:publisher>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
    				<xsl:choose>
						<xsl:when test="lido:displayActorInRole"><xsl:value-of select="lido:displayActorInRole[1]/text()" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" /></xsl:otherwise>
					</xsl:choose>
                </dc:publisher>
            </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
		<!-- dc:publisher Literal-->  
		          
        <!-- dc:relation -->
        
        <!-- dc:rights -->
        <xsl:for-each select="lido:administrativeMetadata/lido:rightsWorkWrap/lido:rightsWorkSet">
    		  <xsl:choose>
				<xsl:when test="lido:creditLine">
                    <dc:rights>
                        <xsl:value-of select="lido:creditLine"/>
                    </dc:rights>
                </xsl:when>
				<xsl:when test="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
				<xsl:for-each select="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
				    <dc:rights>
						<xsl:value-of select="."/>
						<xsl:if test="not(position()=last())"><xsl:value-of select="' / '" /></xsl:if>
					</dc:rights>
				</xsl:for-each>
				</xsl:when>
			</xsl:choose>
        </xsl:for-each>
        
        <!-- dc:source -->
        
        <!-- dc:subject Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:conceptID[starts-with(., 'http://')]">
            <dc:subject>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:subject>
		</xsl:for-each>
        <!-- dc:subject Resource-->
        
        
        
        <!-- dc:subject Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dc:subject>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
				
					<xsl:value-of select="."/>
					<xsl:if test="not(position()=last())"><xsl:value-of select="' '" /></xsl:if>
				</dc:subject>
			</xsl:for-each>
        </xsl:for-each>
        <!-- dc:subject Literal-->
        
        <!-- dc:subject Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:subject>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:subject>
		</xsl:for-each>
        <!-- dc:subject Resource-->
        <!-- dc:subject Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor[lido:displayActor or lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]]">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dc:subject>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
    				<xsl:choose>
						<xsl:when test="lido:displayActor"><xsl:value-of select="lido:displayActor[1]/text()" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" /></xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not(position()=last())"><xsl:value-of select="' '" /></xsl:if>
				</dc:subject>
			</xsl:for-each>
        </xsl:for-each>
        <!-- dc:subject Literal-->
		

        <!-- dc:subject Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectPlace/lido:place/lido:placeID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:subject>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:subject>
		</xsl:for-each>
        <!-- dc:subject Resource-->
        <!-- dc:subject Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectPlace[lido:displayPlace or lido:place/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]]">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dc:subject>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
    				<xsl:choose>
						<xsl:when test="lido:displayPlace"><xsl:value-of select="lido:displayPlace[1]/text()" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="lido:place/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" /></xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not(position()=last())"><xsl:value-of select="' '" /></xsl:if>
				</dc:subject>
			</xsl:for-each>
        </xsl:for-each>
        <!-- dc:subject Literal-->
        
        <!-- dc:title -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
          <dc:title>
          	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
            <xsl:value-of select="."/>
          </dc:title>
        </xsl:for-each>
        <!-- dc:title -->
        
        <!-- dc:type Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID[starts-with(., 'http://')]">
            <dc:type>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:type>
		</xsl:for-each>
		<!-- dc:type Resource-->

       <!-- dc:type Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(lido:term[(. = 'IMAGE') or (. = 'VIDEO') or (. = 'TEXT') or (. = '3D') or (. = 'SOUND')])]">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
			    <dc:type>
			    	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
                    <xsl:value-of select="."/>
                </dc:type>
			</xsl:for-each>
        </xsl:for-each>
        <!-- dc:type Literal-->

		 <!-- dc:type Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID[starts-with(., 'http://')]">
            <dc:type>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:type>
		</xsl:for-each>
		<!-- dc:type Resource-->

        <!-- dc:type Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
                <dc:type>
                <xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>			
					<xsl:value-of select="."/>
				</dc:type>				
			</xsl:for-each>
        </xsl:for-each>
   
   		<!-- dct:alternative -->
   		<xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[starts-with(@lido:pref, 'alternat')]">
          <dcterms:alternative>
          	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
            <xsl:value-of select="."/>
          </dcterms:alternative>
        </xsl:for-each>
        <!-- dct:alternative -->
           		
   		<!-- dct:conformsTo -->
   		
   		<!-- dct:created -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        <xsl:for-each select="lido:eventDate">
            <xsl:if test="lido:date/lido:earliestDate | lido:displayDate">
            <dcterms:created>
				<xsl:choose>
					<xsl:when test="lido:date/lido:earliestDate = lido:date/lido:latestDate">
						<xsl:value-of select="lido:date/lido:earliestDate"/>
					</xsl:when>
					<xsl:when test="lido:date/lido:earliestDate">
						<xsl:value-of select="concat(lido:date/lido:earliestDate, '/', lido:date/lido:latestDate)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="lido:displayDate" />
					</xsl:otherwise>
				</xsl:choose>
            </dcterms:created>
            </xsl:if>
        </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        <!-- dct:created -->
        
         <!-- dcterms:extent : lido:objectMeasurementsSet -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:objectMeasurementsWrap/lido:objectMeasurementsSet[lido:displayObjectMeasurements or lido:objectMeasurements/lido:measurementsSet]">
          <dcterms:extent>
			<xsl:choose>
				<xsl:when test="lido:displayObjectMeasurements"><xsl:value-of select="lido:displayObjectMeasurements[1]/text()"/></xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="lido:objectMeasurements/lido:measurementsSet[string-length(lido:measurementValue)&gt;0]">
						<xsl:value-of select="concat(lido:measurementType, ': ', lido:measurementValue, ' ', lido:measurementUnit)"/>
						<xsl:for-each select="../lido:extentMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(' (', ., ')')" /></xsl:for-each>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
          </dcterms:extent>
        </xsl:for-each>
        <!-- dcterms:extent -->
        <!-- dct:hasFormat -->
        <!-- dct:hasPart -->
        <!-- dct:hasVersion -->
        <!-- dct:isFormatOf -->
        <!-- dct:isPartOf -->
        <!-- dct:isReferencedBy -->
        <!-- dct:isReplacedBy -->
		<!-- dct:isReplacedBy -->
		<!-- dct:RequiredBy -->
		<!-- dct:issued -->
		<!-- dct:isVersionOf -->
        
        <!-- dct:medium Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']/lido:conceptID[starts-with(., 'http://')]">
        	<dcterms:medium>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
        	</dcterms:medium>
        </xsl:for-each>
        <!-- dct:medium Resource-->
            
        <!-- dct:medium Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']">				
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
        		<dcterms:medium>	
        			<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:langg)"/>
        				</xsl:attribute>
    				</xsl:if>	
					<xsl:value-of select="."/>
				</dcterms:medium>
			</xsl:for-each>
        </xsl:for-each>
       <!-- dct:medium Literal-->
		
        <!-- dct:spatial -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type='current']">
			<xsl:if test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)] or lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
			<dcterms:spatial>
				<xsl:choose>
					<xsl:when test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)] and lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:value-of select="concat(lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1], ', ', lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1])" />
					</xsl:when>
					<xsl:when test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:value-of select="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]" />    
					</xsl:when>
					<xsl:when test="lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:value-of select="lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]"/>
					</xsl:when>
				</xsl:choose>
			</dcterms:spatial>
			</xsl:if>
        </xsl:for-each>
        
         <!-- dct:spatial Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventPlace/lido:place/lido:placeID[starts-with(., 'http://')]">
            <dcterms:spatial>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
        	</dcterms:spatial>
        </xsl:for-each>
        <!-- dct:spatial Resource-->
            
        <!-- dct:spatial Literal-->
       <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventPlace[lido:displayPlace or lido:place/lido:namePlaceSet/lido:appellationValue]">
        	<dcterms:spatial>
				<xsl:choose>
					<xsl:when test="lido:displayPlace"><xsl:value-of select="lido:displayPlace"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="lido:place/lido:namePlaceSet/lido:appellationValue[1]/text()" /></xsl:otherwise>
				</xsl:choose>
			</dcterms:spatial>
        </xsl:for-each>
       <!-- dct:spatial Literal-->
        
        <!-- dct:tableOfContents -->
        <!-- dct:temporal -->
		<!-- edm:currentLocation -->
		<!-- edm:hasMet -->
		<!-- edm:hasType -->
		<!-- edm:incorporates -->
		<!-- edm:isDerivativeOf -->
		<!-- edm:isNextInSequence -->
		<!-- edm:isRelatedTo -->
		<!-- edm:isRepresentationOf -->
		<!-- edm:isSimilarTo -->
		<!-- edm:isSuccessorOf -->
		<!-- edm:realizes -->
		<!-- edm:type -->
		<!-- owl:sameAs -->

        <!-- edm:type -->        
        <xsl:if test="(lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term = 'IMAGE') or (lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term = 'VIDEO') or (lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term = 'TEXT') or (lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term = '3D') or (lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term = 'SOUND')">
          <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term[(. = 'IMAGE') or (. = 'VIDEO') or (. = 'TEXT') or (. = '3D') or (. = 'SOUND')]">
            <xsl:if test="position() = 1">
              <xsl:if test="index-of($var0/item, normalize-space()) > 0">
                <edm:type>
                  <xsl:value-of select="."/>
                </edm:type>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        	
      </edm:ProvidedCHO>
      
      <!-- edm:WebResource -->
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation/lido:linkResource]">
        <xsl:if test="lido:resourceRepresentation/lido:linkResource[starts-with(., 'http://')]">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
            <xsl:for-each select="lido:resourceRepresentation/lido:linkResource">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
            </xsl:attribute>
				<xsl:for-each select="lido:rightsResource"> 
				  <xsl:choose>
						<xsl:when test="lido:creditLine">
							<dc:rights>
								<xsl:value-of select="lido:creditLine"/>
							</dc:rights>
						</xsl:when>
						<xsl:when test="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:for-each select="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
							<dc:rights>
								<xsl:value-of select="."/>
								<xsl:if test="not(position()=last())"><xsl:value-of select="' / '" /></xsl:if>
							 </dc:rights>
						</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
        </edm:WebResource>
        </xsl:if>
      </xsl:for-each>
      <!-- edm:WebResource -->

	  <!-- edm:WebResource -->
      <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink[starts-with(., 'http://')]">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
            </xsl:attribute>
        </edm:WebResource>
      </xsl:for-each>
      <!-- edm:WebResource -->
      
     <!-- edm:Agent --> 
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor/lido:actorInRole | lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor">
       <xsl:if test="lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
        <edm:Agent>
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          
          <xsl:for-each select="lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            <skos:prefLabel>
            	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:actor/lido:nameActorSet/lido:appellationValue[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </edm:Agent>
        </xsl:if>
      </xsl:for-each>
      <!-- edm:Agent --> 
      
       <!-- edm:Place --> 
     <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventPlace | lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectPlace">
      <xsl:if test="lido:place/lido:placeID[starts-with(., 'http://') or starts-with(., 'https://')]"> 
       <edm:Place>
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:place/lido:placeID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          
          <xsl:for-each select="lido:place/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            <skos:prefLabel>
            	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:place/lido:namePlaceSet/lido:appellationValue[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </edm:Place>
        </xsl:if>
      </xsl:for-each> 
      <!-- edm:Place --> 
 
 	      <!-- skos:Concept --> 
    <xsl:for-each select="
		  lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType | 
		  lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(starts-with(@lido:type, 'europeana'))] | 
		  lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech | 
		  lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:culture | 
		  lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept
		">
        <xsl:if test="lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
        <skos:Concept>
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
            	<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
             	<xsl:if test="string-length( lido:langSelect(@xml:lang,$descLang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>  
      <!-- skos:Concept --> 

      <!-- ore:Aggregation -->        
      <ore:Aggregation>
        <xsl:attribute name="rdf:about">
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
          <!--<xsl:for-each select="lido:lidoRecID">-->
            <xsl:if test="position() = 1">
              <xsl:value-of select="concat($ore_Aggregation, $dataProvider,'/',.)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        
        <!-- edm:aggregatedCHO -->
         <edm:aggregatedCHO>
          <xsl:attribute name="rdf:resource">
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
              <xsl:if test="position() = 1">
              <xsl:value-of select="concat($edm_providedCHO, $dataProvider,'/',.)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
        </edm:aggregatedCHO>
        <!-- edm:aggregatedCHO -->
        
        <!-- edm:dataProvider -->
        <xsl:choose>
			<xsl:when test="lido:administrativeMetadata/lido:recordWrap/lido:recordSource[lido:type='europeana:dataProvider']">
				<xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource[lido:type='europeana:dataProvider']/lido:legalBodyName/lido:appellationValue">
				  <xsl:if test="position() = 1">
					<edm:dataProvider>
					  <xsl:value-of select="."/>
					</edm:dataProvider>
				  </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue">
				  <xsl:if test="position() = 1">
					<edm:dataProvider>
					  <xsl:value-of select="."/>
					</edm:dataProvider>
				  </xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<!-- edm:dataProvider -->
		
		<!-- edm:isShownAt -->
      
         <xsl:if test="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink[starts-with(., 'http://') or starts-with(., 'https://')]">
              <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink">
                <edm:isShownAt>
                    <xsl:attribute name="rdf:resource">
                	<xsl:if test="position() = 1">
                  		<xsl:value-of select="."/>
                	</xsl:if>
                    </xsl:attribute>
                </edm:isShownAt>
              </xsl:for-each>
          </xsl:if>
        
		<!-- edm:isShownAt -->

		<!-- edm:isShownBy -->        
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master' or not(@lido:type)]">
		<xsl:for-each select="lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://')]">
          <xsl:if test="position() = 1">
			<edm:isShownBy>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="."/>
				</xsl:attribute>
			</edm:isShownBy>
          </xsl:if>
       </xsl:for-each>
       </xsl:for-each>
       <!-- edm:isShownBy -->        

       <!-- edm:object -->    
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_thumb' or not(@lido:type)]">
        <xsl:for-each select="lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://') ]">
          <xsl:if test="position() = 1">
			<edm:object>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="."/>
				</xsl:attribute>
			</edm:object>
          </xsl:if>
       </xsl:for-each>
       </xsl:for-each>
       <!-- edm:object -->    

       <!-- edm:provider -->    
        <edm:provider>
          <xsl:value-of select="$edm_provider" />
        </edm:provider>
        <!-- edm:provider -->  
        
        <!-- edm:rights -->    
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:rightsResource/lido:rightsType/lido:term">
          <xsl:if test="position() = 1">
            <edm:rights>
            	<xsl:attribute name="rdf:resource">
		            <xsl:value-of select="."/>
		        </xsl:attribute>
            </edm:rights>
          </xsl:if>
        </xsl:for-each>
        <!-- edm:rights -->  
      </ore:Aggregation> 
    </xsl:for-each>
  </rdf:RDF>
 </xsl:template>
</xsl:stylesheet>
<!--end -->  