<?xml version="1.0" encoding="UTF-8" ?>
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
  
<!-- version1_FINAL-Core-2013-10-16: lido-v1.0-to-edm-v5.2.4-transform-v1-FINAL-Core-2013-10-16.xsl -->
<!--
        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        xx  XSL Transform to convert LIDO XML data, according to http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd, 
        xx    into EDM RDF/XML, according to http://www.europeana.eu/schemas/edm/EDM.xsd (EDM v5.2.4, 2013-07-14)
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
		xx  • The following parameters need to be set: edm_provider - baseURL edm_providedCHO - baseURL ore_Aggregation
		xx
		xx  *** version1_DRAFT-2013-09-30 ***
		xx  •  The order of properties is fixed according to EDM schema
		xx  •  Repository Location maps to dcterms:provenance instead of dcterms:spatial
		xx  •  Filter names from actors if the actorID is given (dc:contributor, dc:creator, dc:publisher, dc:subject (Actor))
		xx  •  Filter names from places if placeID is given (dcterms:spatial, dc:subject (Place))
		xx  •  Filter labels from concepts if conceptID is given (dc:format, dc:subject (Concept), dc:type, dcterms:medium)
		xx
		xx  •  edm:Agent, skos:Concept resources are created with prefLabel from Partage vocabulary: xml:lang according to descLang, default is english
		xx	 if URI does not dereference in Partage vocab resources are created without any literals
		xx  •  edm:Place resources are created without any literals (eg prefLabel)
		xx
		xx  *** version1_FINAL-Core-2013-10-16 ***
		xx  •  Names from actors given by the providers are not filtered (dc:contributor, dc:creator, dc:publisher, dc:subject (Actor))
		xx     if a partage plus vocab uri is given then two elements are created a resource and a literal with prefLabel from Partage vocabulary
		xx     xml:lang according to descLang, default is english. If the term value is the sameAs the vocab value then only one literal is created.
		xx  •  Names from places given by the providers are not filtered (dcterms:spatial, dc:subject (Place))
		xx  •  Names from concepts given by the providers are not filtered (dc:format, dc:subject (Concept), dc:type, dcterms:medium)
		xx     if a partage plus vocab uri is given then two elements are created a resource and a literal with prefLabel from Partage vocabulary
		xx     xml:lang according to descLang, default is english. If the term value is the sameAs the vocab value then only one literal is created.
		xx
		xx  •  edm:Agent, skos:Concept resources are created with prefLabel and altLabels broader and narrower concepts from Partage vocabulary
		xx	   if URI does not dereference in Partage vocab resources are created without any literals
		xx  •  edm:Place resources are created without any literals 
		xx  •  edm:hasView and and:isShownBy corrections
		xx  •  lido:administrativeMetadata/lido:recordWrap/lido:recordID -> dc:identifier
		xx  •  dcterms:isPartOf is added 
		xx		   lido:relatedWorkRelType/lido:conceptID = 'http://purl.org/dc/terms/isPartOf and
		xx         lido:relatedWork/lido:object/lido:objectNote    then <dcterms:isPartOf>objectNote</dcterms:isPartOf>
		xx  •  dcterms:hasPart is added 
		xx		   lido:relatedWorkRelType/lido:conceptID = 'http://purl.org/dc/terms/hasPart and
		xx         lido:relatedWork/lido:object/lido:objectNote    then <dcterms:isPartOf>objectNote</dcterms:hasPart>
		xx  
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
  <xsl:param name="edm_provider" select="'Partage Plus'" />
  <!-- Specify edm:providedCHO baseURL -->
  <xsl:param name="edm_providedCHO" select="'http://mint-projects.image.ntua.gr/Partage_Plus/ProvidedCHO/'" />
  <!-- Specify ore:Aggregation baseURL -->
  <xsl:param name="ore_Aggregation" select="'http://mint-projects.image.ntua.gr/Partage_Plus/Aggregation/'" />
  
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
            <xsl:if test="position() = 1">
              <xsl:value-of select="concat($edm_providedCHO, $dataProvider,'/',.)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        
        <!-- dc:contributor : lido:eventActor with lido:eventType NOT production or creation or designing or publication -->
        <!-- dc:contributor Resource -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228'))">
            <xsl:for-each select="lido:eventActor">
            <xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <dc:contributor>
                    <xsl:attribute name="rdf:resource">
                    <xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
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
       
		<!-- dc:contributor : lido:eventActor with lido:eventType NOT production or creation or designing or publication -->
        <!-- dc:contributor Resource dereferenced to prefLabel-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228'))">
            <xsl:for-each select="lido:eventActor">
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="lido:actorInRole/lido:actor/lido:actorID[1]/text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]) or not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]/text() = $prefLabel)">
					<dc:contributor>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:contributor>
				</xsl:if>

			</xsl:if>
			</xsl:for-each>
		</xsl:if>
		</xsl:for-each>
        <!-- dc:contributor Resource dereferenced to prefLabel-->
        
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
        
        <!-- dc:contributor : lido:culture from any lido:eventSet -->
		<!-- dc:contributor Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:culture/lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:contributor>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:contributor>
		</xsl:for-each>
		<!-- dc:contributor Resource-->
		
		<!-- dc:contributor : lido:culture from any lido:eventSet -->
        <!-- dc:contributor Resource dereferenced to prefLabel-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:culture/lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="./text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
					<dc:contributor>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:contributor>
				</xsl:if>

		</xsl:for-each>
        <!-- dc:contributor Resource dereferenced to prefLabel-->
		
        <!-- dc:contributor Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:culture">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dc:contributor>
                <xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>			
					<xsl:value-of select="."/>
				</dc:contributor>				
			</xsl:for-each>
        </xsl:for-each>
        <!-- dc:contributor Literal-->
        
        <!-- dc:coverage -->
        <!-- No LIDO property is mapped to dc:coverage of EDM -->

        <!-- dc:creator : lido:eventActor with lido:eventType = production or creation or designing-->
        <!-- dc:creator Resource-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
            <xsl:for-each select="lido:eventActor">
			<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <dc:creator>
					<xsl:attribute name="rdf:resource">
					<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
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
        
        <!-- dc:creator : lido:eventActor with lido:eventType = production or creation or designing-->
        <!-- dc:creator Resource dereferenced to prefLabel-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
            <xsl:for-each select="lido:eventActor">
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="lido:actorInRole/lido:actor/lido:actorID[1]/text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]) or not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]/text() = $prefLabel)">
					<dc:creator>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:creator>
				</xsl:if>

			</xsl:if>
			</xsl:for-each>
        </xsl:if>
       </xsl:for-each>
        <!-- dc:creator Resource dereferenced to prefLabel-->  
            
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
	    <!-- dc:date : lido:eventDate with lido:eventType NOT production or creation or designing -->
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
		
		<!-- dc:description : lido:objectDescriptionSet -->   
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
					<xsl:value-of select="concat(' (', lido:descriptiveNoteID[1], ')')" />
				</xsl:if>
			</dc:description>
		</xsl:for-each>
		<!-- dc:description -->   
		
		<!-- dc:description : lido:resourceSet/lido:resourceDescription --> 
		<!-- include resourceDescription into dc:description as long as edm:WebResource -> dc:description is not displayed -->
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
		
      	<!-- dc:description : lido:resourceSet/lido:reosourceSource -->       
		<!-- include resourceSource (= photographer) into dc:description since edm:WebResource -> dc:creator is not available -->
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
        
        <!-- dc:format : lido:eventMaterialsTech//lido:termMaterials NOT @lido:type=material -->
        <!-- dc:format Resource -->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]">
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
				<dc:format>
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="."/>
					</xsl:attribute>
                </dc:format>
			</xsl:for-each>	
        </xsl:for-each>
        <!-- dc:format Resource -->   
        
        <!-- dc:format : lido:eventMaterialsTech//lido:termMaterials NOT @lido:type=material -->
        <!-- dc:format Resource dereferenced to prefLabel-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]">
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="./text()" />
				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
				<dc:format>
					<xsl:value-of select="$prefLabel" />
				</dc:format>
				</xsl:if>
			</xsl:for-each>	
        </xsl:for-each>
        <!-- dc:format Resource dereferenced to prefLabel -->    
        
        <!-- dc:format Literal-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech[lido:displayMaterialsTech or lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]]">
			<xsl:choose>
				<xsl:when test="lido:displayMaterialsTech">
                    <dc:format>
                        <xsl:value-of select="lido:displayMaterialsTech[1]/text()" />
                    </dc:format>
                </xsl:when>
				<xsl:otherwise>
					<xsl:if test ="lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]/lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
                    <dc:format>
                        <xsl:value-of select="lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]/lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]" />
                    </dc:format>
                    </xsl:if>
                </xsl:otherwise>
			</xsl:choose>
        </xsl:for-each>
        <!-- dc:format Literal-->  
        
        <!-- dc:identifier : lido:objectPublishedID -->
        <xsl:for-each select="lido:objectPublishedID">
          <dc:identifier>
            <xsl:value-of select="."/>
          </dc:identifier>
        </xsl:for-each>
        <!-- dc:identifier -->

       <!-- dc:identifier : lido:workID -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[not(@lido:type='former')]/lido:workID">
          <dc:identifier>
            <xsl:value-of select="."/>
          </dc:identifier>
        </xsl:for-each>
        <!-- dc:identifier -->
        
        <!-- dc:identifier -->
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
        	<dc:identifier>
            	<xsl:value-of select="."/>
          	</dc:identifier>
        </xsl:for-each>
        <!-- dc:identifier -->

		<!-- dc:language : lido:classification / @lido:type=language (MANDATORY with edm:type=TEXT) -->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[@lido:type='language']/lido:term">
          <dc:language>
            <xsl:value-of select="."/>
          </dc:language>
        </xsl:for-each>
		<!-- dc:language -->    
		
		<!-- dc:publisher : lido:eventActor with lido:eventType = publication -->
		<!-- dc:publisher Resource-->  
		<xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
         <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228')">     
            <xsl:for-each select="lido:eventActor">
			<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <dc:publisher>
					<xsl:attribute name="rdf:resource">
					<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
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
		
		<!-- dc:publisher : lido:eventActor with lido:eventType = publication -->
        <!-- dc:publisher Resource dereferenced to prefLabel-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
         <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228')">  
         <xsl:for-each select="lido:eventActor">
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="lido:actorInRole/lido:actor/lido:actorID[1]/text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]) or not(lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]/text() = $prefLabel)">
					<dc:publisher>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:publisher>
				</xsl:if>

			</xsl:if>
			</xsl:for-each>
        </xsl:if>
       </xsl:for-each>
        <!-- dc:publisher Resource dereferenced to prefLabel-->  
		
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
        <!-- No LIDO property is mapped to dc:coverage of EDM -->
        
        <!-- dc:rights : lido:rightsWorkSet (rights for the CHO) -->
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
					</dc:rights>
				</xsl:for-each>
				</xsl:when>
			</xsl:choose>
        </xsl:for-each>
        
        <!-- dc:source -->
        <!-- No LIDO property is mapped to dc:source of EDM -->
        
        <!-- dc:subject : lido:subjectConcept -->
		<!-- dc:subject Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:subject>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:subject>
		</xsl:for-each>
        <!-- dc:subject Resource-->

        <!-- dc:subject : lido:subjectConcept -->
		<!-- dc:subject Resource dereferenced to prefLabel-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="./text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
					<dc:subject>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:subject>
				</xsl:if>
        </xsl:for-each>
		<!-- dc:subject Resource dereferenced to prefLabel-->
        
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
		
        <!-- dc:subject : lido:subjectActor -->
        <!-- dc:subject Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor/lido:actor/lido:actorID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:subject>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:subject>
		</xsl:for-each>
        <!-- dc:subject Resource-->
        
        <!-- dc:subject : lido:subjectActor -->
        <!-- dc:subject Resource dereferenced to prefLabel-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor/lido:actor/lido:actorID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="./text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]) or not(../lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]/text() = $prefLabel)">
					<dc:subject>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:subject>
				</xsl:if>

		</xsl:for-each>
        <!-- dc:subject Resource dereferenced to prefLabel-->
        
        
        <!-- dc:subject Literal-->
         <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor[lido:displayActor or lido:actor]">
    		<xsl:choose>
				<xsl:when test="lido:displayActor">
					<dc:subject>
						<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        					<xsl:attribute name="xml:lang">
        						<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        					</xsl:attribute>
    					</xsl:if>
						<xsl:value-of select="lido:displayActor[1]/text()" />
					</dc:subject>
				</xsl:when>
				<xsl:otherwise>
						<dc:subject>
							<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        						<xsl:attribute name="xml:lang">
        							<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        						</xsl:attribute>
    						</xsl:if>
							<xsl:value-of select= "lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" />
						</dc:subject>
				</xsl:otherwise>
			</xsl:choose>	
        </xsl:for-each>
        <!-- dc:subject Literal-->
		
        <!-- dc:subject : lido:subjectPlace -->
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
			<xsl:choose>
				<xsl:when test="lido:displayPlace">
					<dc:subject>
						<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        					<xsl:attribute name="xml:lang">
        						<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        					</xsl:attribute>
    					</xsl:if>
						<xsl:value-of select="lido:displayPlace[1]/text()" />
					</dc:subject>
				</xsl:when>
				<xsl:otherwise>
						<dc:subject>
							<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        						<xsl:attribute name="xml:lang">
        							<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        						</xsl:attribute>
    						</xsl:if>
							<xsl:value-of select= "lido:place/lido:namePlaceSet//lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]/text()" />
						</dc:subject>
				</xsl:otherwise>
			</xsl:choose>	
        </xsl:for-each>
        <!-- dc:subject Literal-->
        
        <!-- dc:title : lido:titleSet / @lido:pref=preferred or empty -->
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
        
        <!-- dc:type : lido:objectWorkType -->
		<!-- dc:type Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:type>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:type>
		</xsl:for-each>
		<!-- dc:type Resource-->

		<!-- dc:type Resource dereferenced to prefLabel-->		
		<xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">
				<xsl:variable name="partID" select="./text()" />
				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
					<dc:type>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:type>
				</xsl:if>
        </xsl:for-each>
		<!-- dc:type Resource dereferenced to prefLabel-->		
		
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
        <!-- dc:type Literal-->
		
		<!-- dc:type : lido:classification -->
        <!-- dc:type Resource-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dc:type>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:type>
		</xsl:for-each>
		<!-- dc:type Resource-->
		
		<!-- dc:type Resource dereferenced to prefLabel-->	
		<xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">	
				<xsl:variable name="partID" select="./text()" />
				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
					<dc:type>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dc:type>
				</xsl:if>
        </xsl:for-each>
		<!-- dc:type Resource dereferenced to prefLabel-->	
		
        <!-- dc:type Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(@lido:type='language') and not (@lido:type='europeana:project') and not(lido:term[(. = 'IMAGE') or (. = 'VIDEO') or (. = 'TEXT') or (. = '3D') or (. = 'SOUND')])]">

			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))] ">
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
   
   		<!-- dcterms:alternative : lido:titleSet / @lido:pref=alternative  -->
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
        <!-- dcterms:alternative -->
           		
   		<!-- dct:conformsTo -->
   		<!-- No LIDO property is mapped to dct:conformsTo of EDM -->
   		
   		<!-- dcterms:created : lido:eventDate with lido:eventType = production or creation or designing -->
   		<!-- dcterms:created -->
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
        <!-- dcterms:created -->
        
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
        
        <!-- No LIDO property is mapped to the following properties of EDM -->
        <!-- dcterms:hasFormat -->
        <!-- dcterms:hasPart -->
        <!-- dcterms:hasPart -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:relatedWorksWrap/lido:relatedWorkSet">
        	<xsl:if test = "lido:relatedWorkRelType/lido:conceptID = 'http://purl.org/dc/terms/hasPart' and 
        						(lido:relatedWork/lido:object/lido:objectWebResource or lido:relatedWork/lido:object/lido:objectID or
                                lido:relatedWork/lido:object/lido:objectNote)">
            <xsl:for-each select = "lido:relatedWork/lido:object/lido:objectWebResource">
            <xsl:if test = "lido:relatedWork/lido:object/lido:objectWebResource[starts-with(.,'http')]">
        		<dcterms:hasPart>
                <xsl:attribute name="rdf:resource">
        			<xsl:value-of select =	"."/>
                </xsl:attribute>    
        		</dcterms:hasPart>
        	</xsl:if>
        	</xsl:for-each>
        	<xsl:for-each select = "lido:relatedWork/lido:object/lido:objectID">
            	<dcterms:hasPart>
        			<xsl:value-of select =	"."/>
        		</dcterms:hasPart>
        	</xsl:for-each>
        	<xsl:for-each select = "lido:relatedWork/lido:object/lido:objectNote">
                <dcterms:hasPart>
        			<xsl:value-of select =	"."/>
        		</dcterms:hasPart>
        	</xsl:for-each>
        	</xsl:if>
        </xsl:for-each>
        <!-- dcterms:hasVersion -->
        <!-- dcterms:isFormatOf -->
        <!-- dcterms:isPartOf -->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:relatedWorksWrap/lido:relatedWorkSet">
        	<xsl:if test = "lido:relatedWorkRelType/lido:conceptID = 'http://purl.org/dc/terms/isPartOf' and 
        						(lido:relatedWork/lido:object/lido:objectWebResource or lido:relatedWork/lido:object/lido:objectID or
                                lido:relatedWork/lido:object/lido:objectNote)">
            <xsl:for-each select = "lido:relatedWork/lido:object/lido:objectWebResource">
            <xsl:if test = "lido:relatedWork/lido:object/lido:objectWebResource[starts-with(.,'http')]">
        		<dcterms:isPartOf>
                <xsl:attribute name="rdf:resource">
        			<xsl:value-of select =	"."/>
                </xsl:attribute>    
        		</dcterms:isPartOf>
        	</xsl:if>
        	</xsl:for-each>
        	<xsl:for-each select = "lido:relatedWork/lido:object/lido:objectID">
            	<dcterms:isPartOf>
        			<xsl:value-of select =	"."/>
        		</dcterms:isPartOf>
        	</xsl:for-each>
        	<xsl:for-each select = "lido:relatedWork/lido:object/lido:objectNote">
                <dcterms:isPartOf>
        			<xsl:value-of select =	"."/>
        		</dcterms:isPartOf>
        	</xsl:for-each>
        	</xsl:if>
        </xsl:for-each>
        <!-- dcterms:isReferencedBy -->
        <!-- dcterms:isReplacedBy -->
		<!-- dcterms:isReplacedBy -->
		<!-- dcterms:RequiredBy -->
		<!-- dcterms:issued -->
		<!-- dcterms:isVersionOf -->
        
        <!-- dcterms:medium : lido:eventMaterialsTech//lido:termMaterials / @lido:type=material -->
        <!-- dcterms:medium Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']/lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
        	<dcterms:medium>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
        	</dcterms:medium>
        </xsl:for-each>
        <!-- dcterms:medium Resource-->
        
        <!-- dcterms:medium Resource dereferenced to prefLabel-->	
		<xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']/lido:conceptID[starts-with(., 'http://partage.vocnet.org/')]">

				<xsl:variable name="partID" select="./text()" />

				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefLabel" select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				<xsl:if test = "not(../lido:term) or not(../lido:term/text() = $prefLabel)">
					<dcterms:medium>
						<xsl:attribute name="xml:lang" select="$labelLang" />
						<xsl:value-of select="$prefLabel" />
					</dcterms:medium>
				</xsl:if>

        </xsl:for-each>
		<!-- dcterms:medium Resource dereferenced to prefLabel-->	
        
        <!-- dcterms:medium Literal (display -> dc:format, see above) -->
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
        <!-- dcterms:medium Literal--> 
       
        <!-- dcterms:provenance : lido:repositorySet -> lido:repositoryName and/or lido:repositoryLocation -->
        <!-- First approach was:
				IF NOT lido:repositoryName THEN dcterms:spatial : lido:repositorySet/lido:repositoryLocation
				changed by request of Europeana
		-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type='current']">
			<xsl:if test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)] or lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
				<xsl:choose>
					<xsl:when test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)] and lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
					<dcterms:provenance>
						<xsl:value-of select="concat(lido:repositoryName[1]/lido:legalBodyName[1]/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1], ', ', lido:repositoryLocation[1]/lido:namePlaceSet[1]/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1])" />
					</dcterms:provenance>
					</xsl:when>
					<xsl:when test="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
					<dcterms:provenance>
						<xsl:value-of select="lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]" />    
					</dcterms:provenance>
					</xsl:when>
					<xsl:when test="lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
					<dcterms:provenance>
						<xsl:value-of select="lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)][1]"/>
					</dcterms:provenance>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
        </xsl:for-each>
        <!-- dcterms:provenance -->
        
        <!-- dct:references -->
        <!-- No LIDO property is mapped to dct:references of EDM -->
        
        <!-- dcterms:spatial : lido:eventPlace from any lido:eventSet -->
        <!-- dcterms:spatial Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventPlace/lido:place/lido:placeID[starts-with(., 'http://') or starts-with(., 'https://')]">
            <dcterms:spatial>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
        	</dcterms:spatial>
        </xsl:for-each>
        <!-- dcterms:spatial Resource-->
        <!-- dcterms:spatial Literal-->
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventPlace[lido:displayPlace or lido:place/lido:namePlaceSet/lido:appellationValue]">
        
        	<dcterms:spatial>
				<xsl:choose>
					<xsl:when test="lido:displayPlace"><xsl:value-of select="lido:displayPlace"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="lido:place/lido:namePlaceSet/lido:appellationValue[1]/text()" /></xsl:otherwise>
				</xsl:choose>
			</dcterms:spatial>
		
        </xsl:for-each>
        <!-- dcterms:spatial Literal-->
        
        <!-- No LIDO property is mapped to the following properties of EDM -->
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
   
        <!-- edm:type : lido:classification / @lido:type=europeana:type -->        
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
        	
        <!-- owl:sameAs -->
        <!-- No LIDO property is mapped to owl:sameAs of EDM -->
      </edm:ProvidedCHO>
      
      <!-- edm:WebResource : lido:resourceSet -->
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation/lido:linkResource]">
        <xsl:if test="lido:resourceRepresentation/lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://')]">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
            <xsl:for-each select="lido:resourceRepresentation/lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://')]">
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
							 </dc:rights>
						</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
        </edm:WebResource>
        </xsl:if>
      </xsl:for-each>
      <!-- edm:WebResource -->

	  <!-- edm:WebResource : lido:recordInfoLink -->
      <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink[starts-with(., 'http://') or starts-with(., 'https://')]">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
            </xsl:attribute>
        </edm:WebResource>
      </xsl:for-each>
      <!-- edm:WebResource -->
      
      <!-- edm:Agent : lido:eventActor or lido:subjectActor --> 
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
            <!-- include prefLabel from Partage creator authority / xml:lang="en" -->
            <xsl:for-each select="lido:actor/lido:actorID[starts-with(., 'http://partage.vocnet.org')]">
				<xsl:variable name="partID" select=".[1]/text()" />
                <xsl:if test="position() = 1">
                <xsl:for-each select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:prefLabel">
				<!-- prefLabel -->
				<skos:prefLabel>
                    <xsl:attribute name="xml:lang" select="@xml:lang" />
					<xsl:value-of select="."/>
				</skos:prefLabel>
                </xsl:for-each>
                <xsl:for-each select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:altLabel">
                <!-- altLabel -->
				<skos:altLabel>
                    <xsl:attribute name="xml:lang" select="@xml:lang" />
					<xsl:value-of select="."/>
				</skos:altLabel>
                </xsl:for-each>
				<!-- broader -->
                <xsl:for-each select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:broader/@rdf:resource">
    			<skos:broader>
                    <xsl:attribute name="rdf:resource" select="." />
                </skos:broader>
				<!-- narrower -->
                </xsl:for-each>
                <xsl:for-each select="$PPActors/skos:Concept[@rdf:about=$partID]/skos:narrower/@rdf:resource">
    			<skos:narrower>
                    <xsl:attribute name="rdf:resource" select="." />
				</skos:narrower>
				</xsl:for-each>
				</xsl:if>
            </xsl:for-each>
        </edm:Agent>
        </xsl:if>
      </xsl:for-each>
      <!-- edm:Agent --> 
      
      <!-- edm:Place : lido:eventPlace or lido:subjectPlace --> 
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
        </edm:Place>
        </xsl:if>
      </xsl:for-each> 
      <!-- edm:Place --> 
      
      <!-- edm:TimeSpan -->
      <!-- No LIDO property is mapped to this EDM class -->
      
 	  <!-- skos:Concept : lido:objectWorkType or lido:classification or lido:termMaterialsTech or lido:culture or lido:subjectConcept --> 
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
            <!-- include prefLabel from Partage vocabulary -->
            <xsl:for-each select="lido:conceptID[starts-with(., 'http://partage.vocnet.org')]">
				<xsl:variable name="partID" select=".[1]/text()" />
                <xsl:if test="position() = 1">
                <!-- prefLabel -->
			    <xsl:for-each select ="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel">
				<skos:prefLabel>
					<xsl:attribute name="xml:lang" select="@xml:lang" />
					<xsl:value-of select="." />
				</skos:prefLabel>
                </xsl:for-each>
                <!-- altLabel -->
                <xsl:for-each select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:altLabel">
    			<skos:altLabel>
                    <xsl:attribute name="xml:lang" select="@xml:lang" />
					<xsl:value-of select="."/>
				</skos:altLabel>
				<!-- broader -->
                </xsl:for-each>
                <xsl:for-each select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:broader/@rdf:resource">
    			<skos:broader>
                    <xsl:attribute name="rdf:resource" select="." />
                </skos:broader>
				<!-- narrower -->
                </xsl:for-each>
                <xsl:for-each select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:narrower/@rdf:resource">
    			<skos:narrower>
                    <xsl:attribute name="rdf:resource" select="." />
				</skos:narrower>
                </xsl:for-each>
				</xsl:if>
            </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      
      <!-- skos:Concept -->

      <!-- ore:Aggregation -->        
      <ore:Aggregation>
        <xsl:attribute name="rdf:about">
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
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
        
        <!-- edm:dataProvider : lido:recordSource -->
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
		
		<!-- edm:hasView : lido:resourceRepresentation / @lido:type=image_master or empty -->        
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master' or not(@lido:type)]">
        <xsl:if test="position() > 1">
		<xsl:for-each select="lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://')]">
			<edm:hasView>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="."/>
				</xsl:attribute>
			</edm:hasView>
       </xsl:for-each>
       </xsl:if>
       </xsl:for-each>
       <!-- edm:hasView --> 
		
		<!-- edm:isShownAt : lido:recordInfoLink -->
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

		<!-- edm:isShownBy : lido:resourceRepresentation / @lido:type=image_master or empty -->        
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master' or not(@lido:type)]">
        <xsl:if test="position() = 1">
		<xsl:for-each select="lido:linkResource[starts-with(., 'http://') or starts-with(., 'https://')]">
			<edm:isShownBy>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="."/>
				</xsl:attribute>
			</edm:isShownBy>
       </xsl:for-each>
	   </xsl:if>
       </xsl:for-each>
       <!-- edm:isShownBy -->          

       <!-- edm:object -->    
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_thumb']">
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
        
       <!-- edm:rights : lido:rightsResource (MANDATORY, URI taken from a  set of URIs defined for use in Europeana) -->    
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:rightsResource/lido:rightsType[lido:conceptID[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')] or lido:term[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')]]">
          <xsl:if test="position() = 1">
            <edm:rights>
            	<xsl:attribute name="rdf:resource">
					<xsl:choose>
						<xsl:when test="lido:conceptID[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')]">
							<xsl:value-of select="lido:conceptID[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')][1]/text()"/>
						</xsl:when>
						<xsl:when test="lido:term[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')]">
							<xsl:value-of select="lido:term[starts-with(., 'http://creativecommons.org/') or starts-with(., 'http://www.europeana.eu/rights')][1]/text()"/>
						</xsl:when>
					</xsl:choose>
		        </xsl:attribute>
            </edm:rights>
          </xsl:if>
        </xsl:for-each>
        <!-- edm:rights -->  
      </ore:Aggregation> 
	  <!-- ore:Aggregation -->   
    </xsl:for-each>
  </rdf:RDF>
 </xsl:template>
 
<xsl:variable name="PPTerminology">
	<skos:Concept rdf:about="http://partage.vocnet.org/part00036">
		<skos:prefLabel xml:lang="en">works on paper</skos:prefLabel>
		<skos:altLabel xml:lang="de">Kunst auf Papier</skos:altLabel>
		<skos:prefLabel xml:lang="sv">konst på papper</skos:prefLabel>
		<skos:prefLabel xml:lang="fi">paperityöt</skos:prefLabel>
		<skos:altLabel xml:lang="es">obras en papel</skos:altLabel>
		<skos:prefLabel xml:lang="es">obras sobre papel</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">dela na papirju</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">trabalho sobre papel</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">prace na papierze</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">werken op papier</skos:prefLabel>
		<skos:prefLabel xml:lang="it">oggetti di carta</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">práce na papíře</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">obra sobre paper</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">œuvre sur papier</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">papír alapú tárgy</skos:prefLabel>
		<skos:prefLabel xml:lang="no">arbeid på papir</skos:prefLabel>
		<skos:prefLabel xml:lang="hr">radovi na papiru</skos:prefLabel>
		<skos:prefLabel xml:lang="de">Werk auf Papier</skos:prefLabel>
		<skos:altLabel xml:lang="de">Arbeiten auf Papier (visuelle Werke)</skos:altLabel>
		<skos:altLabel xml:lang="de">Werke auf Papier</skos:altLabel>
		<skos:altLabel xml:lang="de">Graphik (visuelles Werk)</skos:altLabel>
		<skos:altLabel xml:lang="de">Grafik (visuelles Werk)</skos:altLabel>
		<skos:inScheme rdf:resource="http://partage.vocnet.org"/>
		<skos:broader rdf:resource="http://partage.vocnet.org/part01377"/>
		<skos:exactMatch rdf:resource="http://vocab.getty.edu/aat/300189621"/>
		<skos:closeMatch rdf:resource="http://d-nb.info/gnd/4395805-9"/>
		<skos:editorialNote xml:lang="en">PPObjectType</skos:editorialNote>
	</skos:Concept>
</xsl:variable>

<xsl:variable name="PPActors">
	<skos:Concept rdf:about="http://partage.vocnet.org/part-kue00023474">
		<skos:inScheme rdf:resource="http://partage.vocnet.org/Actor"/>
		<skos:prefLabel xml:lang="en">Prutscher, Otto</skos:prefLabel>
		<skos:scopeNote xml:lang="en">Person / Activity Dates: 1895-1949 / Birth: 1880.04.07 / 1882.04.07 (Wien) / Death: 1949.02.15 (Wien)</skos:scopeNote>
	</skos:Concept>
</xsl:variable>

</xsl:stylesheet>
<!--end -->  