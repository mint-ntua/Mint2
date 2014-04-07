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
  
<!-- version1_FINAL-Photo-2013-10-16: lido-v1.0-to-edm-v5.2.4-transform-v1-FINAL-Photo-2013-10-16.xsl -->
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
		xx  *** Custom for EuPhoto ***
		xx
		xx 	 dc:format-> lido:eventMethod
		xx	 dc:type -> lido:eventDescriptionSet/lido:descriptiveNoteValue
		xx   dc:type -> lido:eventDescriptionSet/lido:descriptiveNoteID
		xx	 dc:identifier -> lido:recordID
        xx   skos:concept -> eventMethod
        xx   skos:concept -> descriptiveNoteID
        xx
        xx   dc:creator Literal corrected
		xx   dcterms:created corrected
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
  <xsl:param name="edm_provider" select="'EuropeanaPhotography'" />
  <!-- Specify edm:providedCHO baseURL -->
  <xsl:param name="edm_providedCHO" select="'http://mint-projects.image.ntua.gr/photography/ProvidedCHO/'" />
  <!-- Specify ore:Aggregation baseURL -->
  <xsl:param name="ore_Aggregation" select="'http://mint-projects.image.ntua.gr/photography/Aggregation/'" />
  
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
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:culture/lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        	<xsl:for-each select="lido:eventActor/lido:displayActorInRole">
            	<dc:creator>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
    				<xsl:value-of select="." />
                </dc:creator>
            </xsl:for-each>
        	</xsl:if>
        </xsl:for-each>
	    <!-- dc:creator Literal-->   
	    
	    <!-- dc:creator Literal-->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        	<xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        	<xsl:for-each select="lido:eventActor/lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            	<dc:creator>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
					<xsl:value-of select="." />
					
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
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        
        <!-- dc:format Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMethod">
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://') or starts-with(., 'https://')]">
				<dc:format>
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="."/>
					</xsl:attribute>
                </dc:format>
			</xsl:for-each>	
        </xsl:for-each>
		<!-- dc:format Resource-->
		
		<!-- dc:format : lido:eventMethod -->
        <!-- dc:format Resource dereferenced to prefLabel-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMethod">
			<xsl:for-each select="lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMethod">
			<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
				<dc:format>
					<xsl:value-of select="."/>
                </dc:format>
			</xsl:for-each>	
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
       		<xsl:if test="lido:actorInRole/lido:actor/lido:actorID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectActor/lido:actor/lido:actorID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
		<xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">
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
                <xsl:if test = "not(text() = 'Ancient Photography' or text()='Ancient PhotographyPhotography')">
                    <dc:type>
                    <xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">	
                        <xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    			    </xsl:if>			
				    <xsl:value-of select="."/>
                    </dc:type>    			
    			</xsl:if>	
				<xsl:if test = "text() = 'Ancient Photography'">
    			    <dc:type>
                        <xsl:attribute name="xml:lang">
            				<xsl:value-of select="'en'"/>
        				</xsl:attribute>
                    <xsl:value-of select="'Photography'"/>
                    </dc:type>
				</xsl:if>
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
		<xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">	
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
        
        <!-- dc:type Resource-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventDescriptionSet/lido:descriptiveNoteID[starts-with(., 'http://') or starts-with(., 'https://')]">
			<dc:type>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="."/>
				</xsl:attribute>
            </dc:type>
        </xsl:for-each>
		<!-- dc:type Literal-->
		
		<!-- dc:type Resource dereferenced to prefLabel-->	
		<xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventDescriptionSet/lido:descriptiveNoteID[starts-with(., 'http://bib.arts.kuleuven.be/')]">	
				<xsl:variable name="partID" select="./text()" />
				<xsl:variable name="labelLang">
					<xsl:choose>
						<xsl:when test="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$descLang]"><xsl:value-of select="$descLang" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="'en'" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<dc:type>
					<xsl:attribute name="xml:lang" select="$labelLang" />
					<xsl:value-of select="$PPTerminology/skos:Concept[@rdf:about=$partID]/skos:prefLabel[@xml:lang=$labelLang]" />
				</dc:type>
        </xsl:for-each>
		<!-- dc:type Resource dereferenced to prefLabel-->	
		
		<!-- dc:type Literal-->    
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventDescriptionSet/lido:descriptiveNoteValue">
				<dc:type>
					<xsl:if test="string-length( lido:langSelect($descLang,@xml:lang)) &gt; 0">
        				<xsl:attribute name="xml:lang">
        					<xsl:value-of select="lido:langSelect($descLang,@xml:lang)"/>
        				</xsl:attribute>
    				</xsl:if>
					<xsl:value-of select="."/>
                </dc:type>
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
					<xsl:when test="lido:date/lido:earliestDate and lido:date/lido:latestDate">
						<xsl:value-of select="concat(lido:date/lido:earliestDate, '/', lido:date/lido:latestDate)"/>
					</xsl:when>
					<xsl:when test="lido:date/lido:earliestDate and not (lido:date/lido:latestDate)">
    					<xsl:value-of select="lido:date/lido:earliestDate"/>
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
		<xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']/lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be/')]">

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
            <xsl:for-each select="lido:actor/lido:actorID[starts-with(., 'http://bib.arts.kuleuven.be')]">
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
		  lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept |
		  lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMethod
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
            <xsl:for-each select="lido:conceptID[starts-with(., 'http://bib.arts.kuleuven.be')]">
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
      
      <!-- skos:Concept : lido:objectWorkType or lido:classification or lido:termMaterialsTech or lido:culture or lido:subjectConcept --> 
      <xsl:for-each select="
		  lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventDescriptionSet
		">
        <xsl:if test="lido:descriptiveNoteID[starts-with(., 'http://') or starts-with(., 'https://')]">
        <skos:Concept>
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:descriptiveNoteID[starts-with(., 'http://') or starts-with(., 'https://')]">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
            <!-- include prefLabel from Partage vocabulary -->
            <xsl:for-each select="lido:descriptiveNoteID[starts-with(., 'http://bib.arts.kuleuven.be')]">
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
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30257">
    <skos:prefLabel xml:lang="bg">индустриален пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">industrinis peizažas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:prefLabel xml:lang="fr">Paysage industriel</skos:prefLabel>
    <skos:prefLabel xml:lang="en">industrial landscape</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">krajobraz przemysłowy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Industrielandschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industrieel landschap</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paisatge industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio industriale</skos:prefLabel>
    <skos:prefLabel xml:lang="da">industrielle landskab</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">priemyselná krajina</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje industrial</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31219">
    <skos:prefLabel xml:lang="pl">wykop</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vykopávky</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kasinėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tecnología e ingeniería</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Opgraving</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Fouille</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:prefLabel xml:lang="de">Abbau</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scavo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">excavation</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">разкопки</skos:prefLabel>
    <skos:prefLabel xml:lang="da">udgravninger</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausgrabung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">excavacions arqueològiques</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erdarbeiten</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11019">
    <skos:prefLabel xml:lang="es">impresiones al carbón</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kooldruk</skos:prefLabel>
    <skos:altLabel xml:lang="de">Karbondruck-Fotos</skos:altLabel>
    <skos:prefLabel xml:lang="fr">épreuve au charbon</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">uhlotlač</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">stampe al carbone</skos:prefLabel>
    <skos:altLabel xml:lang="de">Karbon prints</skos:altLabel>
    <skos:prefLabel xml:lang="lt">anglies atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki węglowe</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="ca">paper al carbó</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Karbondruck-Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="da">carbon prints</skos:prefLabel>
    <skos:prefLabel xml:lang="en">carbon prints</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">въглероден отпечатък</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30246">
    <skos:prefLabel xml:lang="fr">Régisseur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">režisér/ka</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">диригент</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Director</skos:prefLabel>
    <skos:prefLabel xml:lang="it">direttore</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="ca">director</skos:prefLabel>
    <skos:prefLabel xml:lang="es">director</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">reżyser</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Regisseur</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Regisseur</skos:prefLabel>
    <skos:prefLabel xml:lang="da">direktør</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">režisierius</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30714">
    <skos:altLabel xml:lang="de">Händlerin</skos:altLabel>
    <skos:prefLabel xml:lang="lt">prekybininkas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">obchodník/predajca</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Händler</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="fr">Commerçant</skos:prefLabel>
    <skos:prefLabel xml:lang="it">commerciante/negoziante</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">comerciants</skos:prefLabel>
    <skos:prefLabel xml:lang="en">trader/dealer</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">дилър</skos:prefLabel>
    <skos:prefLabel xml:lang="da">forhandler / forhandler</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">handlowiec</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Handelaar</skos:prefLabel>
    <skos:prefLabel xml:lang="es">comerciantes</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kaufmann</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30305">
    <skos:altLabel xml:lang="de">Katastrophen</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Ramp</skos:prefLabel>
    <skos:prefLabel xml:lang="en">disaster</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30300"/>
    <skos:prefLabel xml:lang="es">catástrofes naturales</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">disastro</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">catàstrofes naturals</skos:prefLabel>
    <skos:prefLabel xml:lang="da">katastrofer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">katastrofa / klęska / nieszczęście</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nelaimė</skos:prefLabel>
    <skos:altLabel xml:lang="de">Katastrophe</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Catastrophe</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">катастрофа</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nešťastie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Desaster</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30704">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30700"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">conflicto laboral</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Arbeitskampf</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Arbeidsdispuut</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Contestation de travailleurs</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">arbejdskonflikter</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">трудов конфликт</skos:prefLabel>
    <skos:prefLabel xml:lang="it">controversia di lavoro</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">spór pracowniczy</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">darbo ginčas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">conflictes laborals</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">odborárske diskusie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">labour dispute</skos:prefLabel>
    <skos:altLabel xml:lang="de">Arbeitskonflikt</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11022">
    <skos:prefLabel xml:lang="de">Silver Dye-bleach prints</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sidabro dažais balinti atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">zilverpigment bleekafdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">отпечатъци чрез процеса Цибахром</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe d'argento sbiancate</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones en plata blanqueada</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">épreuve argentique par blanchiment</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="pl">"odbitki ""silver-dye bleach"""</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="sl">striebrotlač</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sølv-farvning blegemiddel prints</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">revelat per blanqueig de tints</skos:prefLabel>
    <skos:prefLabel xml:lang="en">silver-dye bleach prints</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30512">
    <skos:prefLabel xml:lang="en">Red Cross</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Croce Rossa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Raudonasis Kryžius</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Røde Kors</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Červený kríž</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Cruz Roja</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Rode Kruis</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30509"/>
    <skos:prefLabel xml:lang="bg">Червен кръст</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Czerwony Krzyż</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Creu Roja</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Croix-rouge</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Rotes Kreuz</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30108">
    <skos:prefLabel xml:lang="sl">móda</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">escultura</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mada</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fashion</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Brauch</skos:altLabel>
    <skos:prefLabel xml:lang="bg">мода</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mode</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">moda</skos:prefLabel>
    <skos:prefLabel xml:lang="it">moda</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">moda</skos:prefLabel>
    <skos:prefLabel xml:lang="da">mode</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mode</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Mode</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31257">
    <skos:prefLabel xml:lang="lt">gatvė (architektūra)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">street (architecture)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Straat (architectuur)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Straßenbaukunst</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">rue (architecture)</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">carrer (arquitectura)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gade (arkitektur)</skos:prefLabel>
    <skos:prefLabel xml:lang="es">calle (arquitectura)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">strada (architettura)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ulica (architektura)</skos:prefLabel>
    <skos:altLabel xml:lang="de">Straßenarchitektur</skos:altLabel>
    <skos:prefLabel xml:lang="bg">улица (архитектура)</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:prefLabel xml:lang="sl">ulica (architektúra)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11009">
    <skos:prefLabel xml:lang="sl">čiernobiela tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estampas en blanco y negro</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schwarz-weiß Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">baltai juodi atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wydruki czarno-białe</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">черно-бял отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe in bianco e nero</skos:prefLabel>
    <skos:prefLabel xml:lang="en">black-and-white prints</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve en noir et blanc</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="ca">còpia blanc i negre</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">zwart-wit afdruk</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:altLabel xml:lang="de">schwarz-weiss prints</skos:altLabel>
    <skos:prefLabel xml:lang="da">sort-hvide prints</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30917">
    <skos:prefLabel xml:lang="en">toys</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jouets</skos:prefLabel>
    <skos:altLabel xml:lang="de">Spielzeug</skos:altLabel>
    <skos:prefLabel xml:lang="it">giocattoli</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Speelgoed</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Spielsachen</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <skos:prefLabel xml:lang="lt">žaislai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hračky</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">играчка</skos:prefLabel>
    <skos:altLabel xml:lang="de">Spielwaren</skos:altLabel>
    <skos:prefLabel xml:lang="es">juguetes</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">legetøj</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zabawki</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">joguines</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30232">
    <skos:prefLabel xml:lang="en">Staged photography</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фотографска постановка</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">surežisuota fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Georkestreerde fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bühnenfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">inscenovaná fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">staged photography</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escenario fotográfico</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mise en scène photographique</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="da">iscenesat fotografi</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia reżyserowana</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escenari fotogràfic</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30913">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <skos:prefLabel xml:lang="it">vestiti e ornamenti personali</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">odev a zdobenie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kleidung und persönlicher Schmuck</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odzież i indywidualne ozdoby</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kleding en persoonlijke opsmuk</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">облекло и аксесоари</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Clothing and personal ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vestits i ornaments personals</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Apranga ir asmeniniai papuošalai</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vestuario y ornamentación personal</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vêtements et parure</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">tøj</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30267">
    <skos:prefLabel xml:lang="pl">obrona bierna</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">defensa pasiva</skos:prefLabel>
    <skos:prefLabel xml:lang="es">defensa pasiva</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Passieve defensie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пасивна защита</skos:prefLabel>
    <skos:prefLabel xml:lang="it">difesa passiva</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">passive Verteidigung</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Défense passive</skos:prefLabel>
    <skos:prefLabel xml:lang="en">passive defense</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">pasívna obrana</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pasyvi gynyba</skos:prefLabel>
    <skos:prefLabel xml:lang="da">passivt forsvar</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31228">
    <skos:prefLabel xml:lang="fr">Révolution industrielle</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pramonės revoliucija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">revolució industrial</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31224"/>
    <skos:prefLabel xml:lang="da">industrielle revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="de">industrielle Revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industriële revolutie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">barco</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rewolucja przemysłowa</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">priemyselná revolúcia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индустриална революция</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rivoluzione industriale</skos:prefLabel>
    <skos:prefLabel xml:lang="en">industrial revolution</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30205">
    <skos:prefLabel xml:lang="en">war</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">wojna</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Oorlog</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojna</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Guerre</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">война</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <skos:prefLabel xml:lang="de">Krieg</skos:prefLabel>
    <skos:prefLabel xml:lang="da">krig</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31237">
    <skos:prefLabel xml:lang="es">tienda / carpa</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schiff</skos:prefLabel>
    <skos:prefLabel xml:lang="it">nave</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">ship</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bateau</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">statek</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">кораб</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">laivas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skibe</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="ca">vaixell</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schip</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">loď</skos:prefLabel>
    <skos:altLabel xml:lang="de">Raumschiff</skos:altLabel>
    <skos:altLabel xml:lang="de">Luftschiff</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30306">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="it">siccità</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tørke</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">суша</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Droogte</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sécheresse</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sequeres</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dürre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sequías</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sausra</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">susza</skos:prefLabel>
    <skos:prefLabel xml:lang="en">drought</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">obdobie sucha</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30826">
    <skos:altLabel xml:lang="de">Anschnitt</skos:altLabel>
    <skos:prefLabel xml:lang="ca">portes</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">brama</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Poort</skos:prefLabel>
    <skos:prefLabel xml:lang="en">gate</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">порта</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="lt">vartai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Porte</skos:prefLabel>
    <skos:prefLabel xml:lang="es">espacios naturales</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausgang</skos:altLabel>
    <skos:prefLabel xml:lang="it">porta</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">brána</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Tor</skos:prefLabel>
    <skos:prefLabel xml:lang="da">porte og låger</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30107">
    <skos:prefLabel xml:lang="pl">wystawa</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Messe</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Exposition</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">výstava</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vorführung</skos:altLabel>
    <skos:prefLabel xml:lang="it">mostra, esposizione</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="nl">Tentoonstelling</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausstellung</skos:altLabel>
    <skos:prefLabel xml:lang="en">exhibition</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">periodismo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">paroda</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">exposicions</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изложба</skos:prefLabel>
    <skos:prefLabel xml:lang="da">udstillinger</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30816">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="bg">пустиня</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Désert</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">púšť</skos:prefLabel>
    <skos:altLabel xml:lang="de">Öde</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Wüste</skos:prefLabel>
    <skos:prefLabel xml:lang="it">deserto</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pustynia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ørken</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Woestijn</skos:prefLabel>
    <skos:prefLabel xml:lang="en">desert</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">deserts</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">vista de calle</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dykuma</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31218">
    <skos:prefLabel xml:lang="bg">археологически обект</skos:prefLabel>
    <skos:altLabel xml:lang="de">archäologische Stätte</skos:altLabel>
    <skos:prefLabel xml:lang="da">arkæologiske områder</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:prefLabel xml:lang="en">archaeological site</skos:prefLabel>
    <skos:prefLabel xml:lang="de">archäologische Fund-Stätte</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">stanowisko archeologiczne</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">jaciments arqueològics</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sociología</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sito archeologico</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">archeologické nálezisko</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">archeologinis</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Archeologische site</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Site archéologique</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31247">
    <skos:prefLabel xml:lang="lt">Griuvėsiai</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ruine</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ruine</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">руина</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">ruin</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">Ruin</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ruinen</skos:altLabel>
    <skos:prefLabel xml:lang="it">rovina</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Ruina</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ruïne</skos:prefLabel>
    <skos:prefLabel xml:lang="es">revolución industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">restes arquitectòniques</skos:prefLabel>
    <skos:altLabel xml:lang="de">Zerfall</skos:altLabel>
    <skos:prefLabel xml:lang="sl">ruina</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30713">
    <skos:prefLabel xml:lang="nl">Hoeder</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">piemenys</skos:prefLabel>
    <skos:prefLabel xml:lang="en">shepherds</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pastier</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pasterze</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">pastors</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bergers</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">овчар</skos:prefLabel>
    <skos:prefLabel xml:lang="da">hyrder</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="es">pastores</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Hirten</skos:prefLabel>
    <skos:prefLabel xml:lang="it">pastori</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30258">
    <skos:prefLabel xml:lang="nl">Modernisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Modernisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Modernisme</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Modernismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">modernizmus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="en">Modernism</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">modernizm</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Modernismus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">modernisme</skos:prefLabel>
    <skos:prefLabel xml:lang="it">modernismo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">modernizmas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Moderne</skos:altLabel>
    <skos:prefLabel xml:lang="bg">модернизъм</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30900">
    <skos:prefLabel xml:lang="es">estilo de vida y ocio</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">estil de vida i oci</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stile di vita e tempo libero</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">свободно време</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gyvenimo būdas ir laisvalaikis</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">styl życia i rozrywka</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fritid</skos:prefLabel>
    <skos:prefLabel xml:lang="en">lifestyle and leisure</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Lifestyle en ontspanning</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">životný štýl a voľný čas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Lifestyle und Freizeit</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Lifestyle et loisirs</skos:prefLabel>
    <skos:altLabel xml:lang="de">Lebensstil und Freizeit</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30245">
    <skos:prefLabel xml:lang="sl">obraznosť,zobrazovanie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Imagerie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">imatgeria</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Beelden</skos:prefLabel>
    <skos:prefLabel xml:lang="en">imagery</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">immagini</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bildsprache</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="bg">образ</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">raižiniai/ reljefiška detalė</skos:prefLabel>
    <skos:altLabel xml:lang="de">Symbolik</skos:altLabel>
    <skos:prefLabel xml:lang="pl">obrazowanie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">imaginería</skos:prefLabel>
    <skos:prefLabel xml:lang="da">billedsprog</skos:prefLabel>
    <skos:altLabel xml:lang="de">Metaphorik</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30231">
    <skos:prefLabel xml:lang="de">Private Fotografie von Theaterpersönlichkeiten, Bühnendarstellern</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photo privée d'acteur/actrice</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografie private di personalità teatrali</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Privat fotografering eller teatralske personlighed / personligheder</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia prywatna osobistości teatralnych</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">Private photography of theatrical personality/personalities</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">súkromná fotografia divadelnej osobnosti /osobností</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia privada de personalitats teatrals</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">asmeninė teatro aktoriaus/ -ės/ -ių nuotrauka</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Privé-foto van een acteur/actrice</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="es">fotografía privada de personalidades teatrales</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">лични фотографии на театрални личности</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30918">
    <skos:prefLabel xml:lang="fr">Installations récréatives</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">installazioni ricreative</skos:prefLabel>
    <skos:prefLabel xml:lang="es">instalaciones recreativas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">reakreačné strediská</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">obiekty rekreacyjne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">recreation facilities</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Recreatieve voorzieningen</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">съоръжения за отдих</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rekreative faciliteter</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Freizeitanlagen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">rekreaciniai įrenginiai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erholungseinrichtungen</skos:altLabel>
    <skos:prefLabel xml:lang="ca">instal·lacions recreatives</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30513">
    <skos:prefLabel xml:lang="bg">помощ</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fordele</skos:prefLabel>
    <skos:prefLabel xml:lang="es">beneficiencia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30503"/>
    <skos:prefLabel xml:lang="ca">beneficencia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vorsorgeleistungen</skos:altLabel>
    <skos:prefLabel xml:lang="lt">šelpimas/ lapdariniai renginiai</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zuschüsse</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zisky, prínosy</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sozialleistungen</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Liefdadigheid</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">świadczenia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Charité</skos:prefLabel>
    <skos:prefLabel xml:lang="en">benefits</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30703">
    <skos:prefLabel xml:lang="lt">profesinė sąjunga</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">професионален съюз</skos:prefLabel>
    <skos:prefLabel xml:lang="en">trade union</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Trade Union</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30701"/>
    <skos:prefLabel xml:lang="pl">związek zawodowy</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sindacato</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">odbory</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Gewerkschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Syndicat</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fagforeninger</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vakbond</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sindicats</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30914">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">šperky</skos:prefLabel>
    <skos:prefLabel xml:lang="es">joyería</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">juvelyriniai dirbiniai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бижутерия</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Joaillerie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schmuck</skos:prefLabel>
    <skos:prefLabel xml:lang="it">gioielleria, gioielli</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Jewellery</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30913"/>
    <skos:prefLabel xml:lang="nl">Juwelen</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Biżuteria</skos:prefLabel>
    <skos:prefLabel xml:lang="da">smykker</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">joieria</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31207">
    <skos:prefLabel xml:lang="sl">pošta</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">investigació</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">научно изследване</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Recherche</skos:prefLabel>
    <skos:prefLabel xml:lang="en">research</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31200"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">descubrimientos e innovación</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Forschung</skos:prefLabel>
    <skos:altLabel xml:lang="de">Untersuchung</skos:altLabel>
    <skos:prefLabel xml:lang="pl">badania</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">paštas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ricerca</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Onderzoek</skos:prefLabel>
    <skos:prefLabel xml:lang="da">forskning</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erforschung</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31258">
    <skos:prefLabel xml:lang="de">Motorrad</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Motor</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">motociklas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">motocicletes</skos:prefLabel>
    <skos:prefLabel xml:lang="en">motorcycle</skos:prefLabel>
    <skos:prefLabel xml:lang="da">motorcykel</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Zweirad</skos:altLabel>
    <skos:prefLabel xml:lang="it">motocicletta</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="bg">мотоциклет</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Moto</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">motocykel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">motocicletas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">motocykl</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30304">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">wypadek w komunikacji</skos:prefLabel>
    <skos:prefLabel xml:lang="da">transportulykker</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">eismo nelaimė</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30301"/>
    <skos:prefLabel xml:lang="it">incidente di trasporto</skos:prefLabel>
    <skos:altLabel xml:lang="de">Transportunfälle</skos:altLabel>
    <skos:prefLabel xml:lang="bg">транспортно произшествие</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Accident de transport</skos:prefLabel>
    <skos:prefLabel xml:lang="es">accidente de tráfico</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Transportunfall</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Transportongeval</skos:prefLabel>
    <skos:prefLabel xml:lang="en">transport accident</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">accident de transport</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">doprvná nehoda</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30207">
    <skos:prefLabel xml:lang="nl">Balkanoorlogen</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra dei Balcani</skos:prefLabel>
    <skos:altLabel xml:lang="de">Balkan-Kriege</skos:altLabel>
    <skos:prefLabel xml:lang="en">Balkan Wars</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Balkanų karas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra yugoslava, 1991-1995</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">Балкански войни</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Guerra Iugoslava, 1991-1995</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Balkankriege</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojny na Balkáne</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerres balkaniques</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Balkankrigene</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="pl">Wojny Bałkańskie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11021">
    <skos:prefLabel xml:lang="pl">odbitki na papierze solnym</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="sl">slaný papier</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones en papel salado</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Salzpapier-Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="da">saltede papirkopier</skos:prefLabel>
    <skos:altLabel xml:lang="de">Salzpapier-Fotos</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">paper a la sal</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve sur papier salé</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">druskos popieriaus atspaudai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Salzpapier prints</skos:altLabel>
    <skos:prefLabel xml:lang="bg">солен отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe su carta salata</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">zoutdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="en">salted paper prints</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30268">
    <skos:prefLabel xml:lang="sl">Októbrová revolúcia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Spalio revoliucija</skos:prefLabel>
    <skos:prefLabel xml:lang="en">October revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rivoluzione d'ottobre</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">revolució d'Octubre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">revolución de Octubre</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Oktoberrevolutionen</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Rewolucja Październikowa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Révolution d'Octobre</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Oktoberrevolutie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Октомврийска революция</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Oktober-Revolution</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31227">
    <skos:prefLabel xml:lang="sl">architektúra</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arkitektur</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arquitectura</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Architecture</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Architektur</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">architektūra</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31224"/>
    <skos:prefLabel xml:lang="nl">Architectuur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">архитектура</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">architektura</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">architecture</skos:prefLabel>
    <skos:prefLabel xml:lang="it">architettura</skos:prefLabel>
    <skos:altLabel xml:lang="de">Baukunst</skos:altLabel>
    <skos:prefLabel xml:lang="es">radio y televisión</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30206">
    <skos:prefLabel xml:lang="da">Østrigsk-preussiske krig</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Duitse oorlog</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Austro-Prussian war</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra austro-prussiana</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre austro-prussienne</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra austro prusian</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Guerra austro-prussiana</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Wojna Austriacko-Pruska</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Австро-Пруска война</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Preußisch-Österreichische Krieg</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="sl">Rakúsko-pruská vojna</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Preussisch-Österreichische Krieg</skos:altLabel>
    <skos:prefLabel xml:lang="lt">Austrijos-Prūsijos karas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30827">
    <skos:prefLabel xml:lang="bg">надгробна структура</skos:prefLabel>
    <skos:prefLabel xml:lang="da">begravelseskultur</skos:prefLabel>
    <skos:altLabel xml:lang="de">Grabanordnung</skos:altLabel>
    <skos:prefLabel xml:lang="lt">Laidojimo statiniai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">budowle grobowe</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Funeraire structuur</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Gräber</skos:prefLabel>
    <skos:prefLabel xml:lang="es">desierto</skos:prefLabel>
    <skos:prefLabel xml:lang="it">struttura funeraria</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pohrebný obrad</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Structure funéraire</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Funerary structure</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:altLabel xml:lang="de">Grabstruktur</skos:altLabel>
    <skos:prefLabel xml:lang="ca">monuments funeraris</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31208">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">откритие и нововъведение</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31207"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">electricidad</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Découverte et innovation</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">objavy a inovácie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Neuerung</skos:altLabel>
    <skos:prefLabel xml:lang="pl">odkrycia i innowacje</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">descobriments i innovació</skos:prefLabel>
    <skos:prefLabel xml:lang="en">discovery and innovation</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Entdeckung und Innovation</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scoperta e innovazione</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">atradimas ir naujovė</skos:prefLabel>
    <skos:prefLabel xml:lang="da">opdagelser</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ontdekking en innovatie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30106">
    <skos:prefLabel xml:lang="bg">танц</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Danse</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">šokis</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dans</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">danza</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">dansa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">dance</skos:prefLabel>
    <skos:prefLabel xml:lang="da">dans</skos:prefLabel>
    <skos:altLabel xml:lang="de">tanzen</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="de">Tanz</skos:prefLabel>
    <skos:prefLabel xml:lang="es">mas media</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">taniec</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">tanec</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31238">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">pociąg</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Trein</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zug</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tog</skos:prefLabel>
    <skos:prefLabel xml:lang="it">treno</skos:prefLabel>
    <skos:altLabel xml:lang="de">Züge</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">train</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bahn</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Train</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vlak</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ferrocarrils</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="lt">traukinys</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ruinas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">влак</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31248">
    <skos:prefLabel xml:lang="lt">Sutvirtinimas/ įtvirtinimai</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:prefLabel xml:lang="pl">Fortyfikacja</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Befestigung</skos:prefLabel>
    <skos:altLabel xml:lang="de">Festung</skos:altLabel>
    <skos:prefLabel xml:lang="da">fæstningsanlæg</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fortificazione</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fortificacions</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Versterking / Fortificatie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Verstärkung</skos:altLabel>
    <skos:prefLabel xml:lang="sl">opevnenie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Fortification</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Fortification</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">крепост</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">arquitectura</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30712">
    <skos:prefLabel xml:lang="fr">Artisans</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">remeselník</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rzemieślnicy</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Ambachtslui</skos:prefLabel>
    <skos:prefLabel xml:lang="da">håndværkere</skos:prefLabel>
    <skos:prefLabel xml:lang="es">artesanos</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">занаятчия</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="de">Facharbeiter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Handwerker</skos:altLabel>
    <skos:prefLabel xml:lang="en">craftsmen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">amatininkai</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">artesans</skos:prefLabel>
    <skos:prefLabel xml:lang="it">artigiani</skos:prefLabel>
    <skos:altLabel xml:lang="de">Facharbeiterin</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31217">
    <skos:prefLabel xml:lang="es">historia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">архелогичен артефакт</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">archeologinis</skos:prefLabel>
    <skos:prefLabel xml:lang="en">archaeological artefact</skos:prefLabel>
    <skos:prefLabel xml:lang="de">archäologischer Artefakt</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">archeologický nález</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">eksponat archeologiczny</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:altLabel xml:lang="de">archäologischer Fund</skos:altLabel>
    <skos:prefLabel xml:lang="it">manufatto archeologico</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">antiguitats (Arqueologia)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Artefact archéologique</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arkæologisk artefakter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Archeologisch artefact</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30817">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">les</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wald</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">pueblo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Forêt</skos:prefLabel>
    <skos:prefLabel xml:lang="it">foresta</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">miškas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гора</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">las</skos:prefLabel>
    <skos:prefLabel xml:lang="en">forest</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">boscos i silvicultura</skos:prefLabel>
    <skos:altLabel xml:lang="de">Forst</skos:altLabel>
    <skos:prefLabel xml:lang="da">skove</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="nl">Woud</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wälder</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30901">
    <skos:altLabel xml:lang="de">Club und Verein</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">klub a spolok</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kluby i stowarzyszenia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">клубове и дружества</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Club et société</skos:prefLabel>
    <skos:prefLabel xml:lang="da">foreninger</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Club und Verband</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">klubas ir asociacijos</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Club en vereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="es">club y asociación</skos:prefLabel>
    <skos:prefLabel xml:lang="en">club and association</skos:prefLabel>
    <skos:prefLabel xml:lang="it">club e associazioni</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">clubs i associacions</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30716">
    <skos:prefLabel xml:lang="nl">Visser</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pêcheur</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fiskere</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žvejas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">pescatori</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="de">Fischer</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">pescadors</skos:prefLabel>
    <skos:prefLabel xml:lang="es">pescadores</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fishers</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">rybári</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rybacy</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">рибар</skos:prefLabel>
    <skos:altLabel xml:lang="de">Angler</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30500">
    <skos:prefLabel xml:lang="en">health</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sveikata</skos:prefLabel>
    <skos:prefLabel xml:lang="es">salud</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zdrowie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">salute</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">здраве</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gesundheit</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sundhed</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Gezondheid</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zdravie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Befinden</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Santé</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">salut</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30840">
    <skos:prefLabel xml:lang="ca">bestiar</skos:prefLabel>
    <skos:prefLabel xml:lang="it">gregge</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ganado</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Cattle</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Gros bétail</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">говеда</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vee</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Galvijai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Bydło</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vieh</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30837"/>
    <skos:prefLabel xml:lang="de">Rind</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">dobytok</skos:prefLabel>
    <skos:altLabel xml:lang="de">Rinder</skos:altLabel>
    <skos:prefLabel xml:lang="da">kvæg</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31141">
    <skos:prefLabel xml:lang="lt">stačiatikybė</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ortodoxes</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ortodoxia</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Orthodox Eastern</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Prawosławie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">východná pravoslávna cirkev</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Pasqua ortodossa</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ortodoks</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="bg">православие</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">orthodoxie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ost-Orthodox</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Orthodoxie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30244">
    <skos:prefLabel xml:lang="lt">teatro pastatymas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">produzione teatrale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">producción teatral</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Production de théâtre</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">театрална продукция</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="de">Theaterproduktion</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Theaterproductie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Theatre production</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">divadelná inscenácia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">Producció teatral</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">produkcja teatralna</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">Teater produktion</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30255">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:prefLabel xml:lang="en">Townscape</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">miestelio peizažas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje urbano</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dorpszicht</skos:prefLabel>
    <skos:altLabel xml:lang="de">Stadtansicht</skos:altLabel>
    <skos:prefLabel xml:lang="bg">градски пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="da">bybillede</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ortsbild</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pejzaż miejski</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paisatge urbà</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue sur village</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio urbano</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pohľad na mesto</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30510">
    <skos:prefLabel xml:lang="fr">Médecin</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gydytojas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">lekár</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lekarz</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Arzt</skos:prefLabel>
    <skos:altLabel xml:lang="de">Doktor</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30509"/>
    <skos:prefLabel xml:lang="bg">лекар</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dokter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">doctor</skos:prefLabel>
    <skos:prefLabel xml:lang="en">doctor</skos:prefLabel>
    <skos:prefLabel xml:lang="it">dottore</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">metges</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ärztin</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">læger</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30141">
    <skos:prefLabel xml:lang="sl">viktoriánske obdobie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="lt">Viktorijos periodas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">okres wiktoriański</skos:prefLabel>
    <skos:altLabel xml:lang="de">Viktorianisches Zeitalter</skos:altLabel>
    <skos:prefLabel xml:lang="ca">època victoriana</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">escena de caza</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Victorian period</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Victorian period</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Викториански период</skos:prefLabel>
    <skos:prefLabel xml:lang="da">victorianske periode</skos:prefLabel>
    <skos:prefLabel xml:lang="it">periodo vittoriano</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Période victorienne</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Victoriaanse periode</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11020">
    <skos:altLabel xml:lang="de">Platin-Fotos</skos:altLabel>
    <skos:prefLabel xml:lang="bg">платинен отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones en platino</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">platinotype</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">platinová tlač</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="da">platin prints</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">platinum prints</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">platinadruk</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki platynowe</skos:prefLabel>
    <skos:altLabel xml:lang="de">Platin prints</skos:altLabel>
    <skos:prefLabel xml:lang="lt">platininiai atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">platinotipia, stampe al platino</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paper al platí</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Platin-Abzüge</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11007">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">stampe fotografiche</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki fotograficzne</skos:prefLabel>
    <skos:altLabel xml:lang="de">photographische prints</skos:altLabel>
    <skos:prefLabel xml:lang="bg">фотографски отпечатъци</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">fototlač</skos:prefLabel>
    <skos:prefLabel xml:lang="en">photographic prints</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fotografiske prints</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="es">impresiones fotográficas</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fotografinai atspaudai</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11000"/>
    <skos:prefLabel xml:lang="fr">épreuve photographique</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">fotografische afdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">còpia fotogràfica</skos:prefLabel>
    <skos:prefLabel xml:lang="de">fotografische  Abzüge</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30911">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Grand tour</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">grand tour</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Grand tour</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30910"/>
    <skos:prefLabel xml:lang="de">Große Reise</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">grand tour</skos:prefLabel>
    <skos:prefLabel xml:lang="en">grand tour</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гранд тур</skos:prefLabel>
    <skos:altLabel xml:lang="de">Große Tour</skos:altLabel>
    <skos:prefLabel xml:lang="es">Gran Tour</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">Grand Tour</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rundvisninger</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ilga kelionė</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Grand tour/ wielka wyprawa</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30915">
    <skos:prefLabel xml:lang="bg">мъжко облекло</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">herretøj</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mannenkleding</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Herrenbekleidung</skos:prefLabel>
    <skos:altLabel xml:lang="de">Herrenmode</skos:altLabel>
    <skos:prefLabel xml:lang="pl">Ubrania męskie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Männerkleidung</skos:altLabel>
    <skos:prefLabel xml:lang="en">Men's clothing</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vêtements d'homme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30913"/>
    <skos:prefLabel xml:lang="lt">Vyrų apranga</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">roba de vestir d'home</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">ropa de vestir masculina</skos:prefLabel>
    <skos:prefLabel xml:lang="it">abbigliamento maschile</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mužský odev</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30234">
    <skos:prefLabel xml:lang="sl">divadlo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schauspielhaus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="it">teatro (spettacolo)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wnętrza teatralne</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">театрално място</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esdeveniment teatral</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Theatre venue</skos:prefLabel>
    <skos:prefLabel xml:lang="es">acontecimiento teatral</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Theaterlocatie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Théâtre (endroit)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Teater mødested</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">teatro salė</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/10000">
    <skos:prefLabel xml:lang="lt">Fotografinės technikos</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Fotografische technieken</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Técnicas fotográficas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Techniques photographiques</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tècniques fotogràfiques</skos:prefLabel>
    <skos:altLabel xml:lang="de">fotografische Technik</skos:altLabel>
    <skos:prefLabel xml:lang="bg">Фотографски техники</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Tecniche fotografiche</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Fotografické techniky</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Techniki fotograficzne</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Photographic techniques</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Fotografie-Technik</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Fotografiske teknikker</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30702">
    <skos:altLabel xml:lang="de">Berufsorganisation</skos:altLabel>
    <skos:altLabel xml:lang="de">Berufskammer</skos:altLabel>
    <skos:prefLabel xml:lang="sl">profesné združenie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30701"/>
    <skos:prefLabel xml:lang="it">associazioni professionali</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Association professionnelle</skos:prefLabel>
    <skos:prefLabel xml:lang="en">professional association</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">faglig forening</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Berufsverband</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Professionele vereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">stowarzyszenie zawodowe</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">profesinė asociacija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">associacions de professional i tècnics</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">професионално обединение</skos:prefLabel>
    <skos:prefLabel xml:lang="es">asociación profesional</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30269">
    <skos:prefLabel xml:lang="ca">Guerra Polaco-soviètica</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="nl">Pools-Russische oorlog (1919-1921)</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Guerra Polaco-soviética</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre soviéto-polonaise (1919-1921)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Lenkijos-sovietų karas (1919-1921)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Wojna Polsko-Rosyjska (1919-1921)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Polnisch-Sowjetischer Krieg</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Guerra sovietico-polacca (1919-1921)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">Полско-Съветска война (1919-1921)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Den polsk-sovjetiske krig</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Poľsko-sovietska vojna (1919-1921)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Polish-Soviet War (1919-1921)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31255">
    <skos:prefLabel xml:lang="bg">фонтан</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">fontaine</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">font</skos:prefLabel>
    <skos:prefLabel xml:lang="da">springvand</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fontein</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fontäne</skos:altLabel>
    <skos:prefLabel xml:lang="de">Brunnen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fontanas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">fontána</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">fountain</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">fontanna</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fontana</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fuente</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:altLabel xml:lang="de">Springbrunnen</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30701">
    <skos:prefLabel xml:lang="es">moviento laboral</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mouvement ouvrier</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Arbeiterbewegung</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">darbininkų judėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ruch robotniczy</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">movimento dei lavoratori</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">работническо движение</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arbejderbevægelsen</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">moviment obrer</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30700"/>
    <skos:prefLabel xml:lang="sl">odborárske hnutie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">labour movement</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Arbeidersbeweging</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30308">
    <skos:prefLabel xml:lang="pl">głód /klęska głodu</skos:prefLabel>
    <skos:prefLabel xml:lang="es">hambre</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Famine</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hungers-Not</skos:altLabel>
    <skos:prefLabel xml:lang="lt">badas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">глад</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fam</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Hongersnood</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hlad</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">hungersnød</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="it">carestia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hungersnot</skos:prefLabel>
    <skos:prefLabel xml:lang="en">famine</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30910">
    <skos:prefLabel xml:lang="fr">Voyage</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пътешествие</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Reis</skos:prefLabel>
    <skos:prefLabel xml:lang="es">viaje</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">keliavimas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Reisen</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">podróż</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rejser</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">viatges</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <skos:prefLabel xml:lang="sl">cestovanie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">travel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Reise</skos:prefLabel>
    <skos:prefLabel xml:lang="it">viaggio</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31235">
    <skos:prefLabel xml:lang="it">radio e TV</skos:prefLabel>
    <skos:prefLabel xml:lang="es">nómada</skos:prefLabel>
    <skos:altLabel xml:lang="de">Radio und Fernsehen</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="pl">radio i telewizja</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">radijas ir TV</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ràdio i televisió</skos:prefLabel>
    <skos:prefLabel xml:lang="da">radio &amp; tv</skos:prefLabel>
    <skos:prefLabel xml:lang="en">radio &amp; tv</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">радио и телевизия</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Radio &amp; télévision</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Radio &amp; TV</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">rozhlas a televízia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Radio und TV</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22001">
    <skos:prefLabel xml:lang="da">fotojournalistik</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotogiornalismo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fotojournalisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">photojournalism</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotoreportaż</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photojournalisme</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">фотожуналистика</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotoperiodisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fotožurnalizmas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="sl">novinárska fotografia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bildjournalismus</skos:altLabel>
    <skos:prefLabel xml:lang="es">fotoperiodismo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Foto-Journalismus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30828">
    <skos:prefLabel xml:lang="fr">Canal</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje marino</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bahn</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">canals</skos:prefLabel>
    <skos:prefLabel xml:lang="en">channel</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">канал</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kanal</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kanalas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30811"/>
    <skos:prefLabel xml:lang="it">canale</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kanaal</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">kanaler</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kanál</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kanał</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30161">
    <skos:prefLabel xml:lang="fr">Imprimerie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Grafika</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Graviravimas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampa</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arts gràfiques</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">potlač</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="da">Grafik</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Drukkunst</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">печатна графика</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Printmaking</skos:prefLabel>
    <skos:prefLabel xml:lang="es">público</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30203">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">internationale Militärintervention</skos:prefLabel>
    <skos:prefLabel xml:lang="da">interventioner</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Internationale militaire interventie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">"międzynarodowa interwencja wojskowa międzynarodowa interwencja wojskowa międzynarodowa interwencja wojskowa"</skos:prefLabel>
    <skos:prefLabel xml:lang="it">intervento militare internazionale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">intervención militar internacional</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">medzinárodná vojenská intervencia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">intervenció militar internacional</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">международна въоръжена намеса</skos:prefLabel>
    <skos:prefLabel xml:lang="en">international military intervention</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <skos:prefLabel xml:lang="fr">Intervention militaire internationale</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tarptautinių karinių pajėgų įsikišimas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31121">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="es">templo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">chrám</skos:prefLabel>
    <skos:prefLabel xml:lang="da">templer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tempio</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">świątynia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Temple</skos:prefLabel>
    <skos:prefLabel xml:lang="en">temple</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">šventykla</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Tempel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Tempel</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">храм</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">temples</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31216">
    <skos:prefLabel xml:lang="lt">archeologija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">археология</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">archeologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">archeologia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Archeologie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Altertumsforschung</skos:altLabel>
    <skos:prefLabel xml:lang="es">geografía</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arqueologia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:prefLabel xml:lang="de">Archäologie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">archaeology</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Archéologie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arkæologi</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">archeológia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30180">
    <skos:prefLabel xml:lang="pl">" mozaika mozaika"</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Mosaik</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Mosaik</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мозайка</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="es">periodo de entreguerras</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Mozaika</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mozaika</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Mosaic</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mosaïque</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">mosaico</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mosaics</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mozaïek</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30814">
    <skos:altLabel xml:lang="de">Bahnstation</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">railway station</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bahnhof</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">estacions de ferrocarrils</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stazione ferroviaria</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30811"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Gare</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">geležinkelio stotis</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ЖП гара</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cascadas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Station</skos:prefLabel>
    <skos:altLabel xml:lang="de">Eisenbahnstation</skos:altLabel>
    <skos:prefLabel xml:lang="sl">železničná stanica</skos:prefLabel>
    <skos:prefLabel xml:lang="da">stationer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">dworzec kolejowy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31249">
    <skos:altLabel xml:lang="de">Anlage</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Complex</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">Complex</skos:prefLabel>
    <skos:prefLabel xml:lang="da">komplekser</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">kompliziert</skos:altLabel>
    <skos:prefLabel xml:lang="sl">komplex</skos:prefLabel>
    <skos:prefLabel xml:lang="it">complesso</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kompleks</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ingeniería mecánica</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Complexe</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Komplex</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">комплекс</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Kompleksas/ pastatų visuma</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">lloc històric</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30902">
    <skos:prefLabel xml:lang="pl">organizacja charytatywna</skos:prefLabel>
    <skos:prefLabel xml:lang="da">velgørenhedsorganisationer</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">благотворителна организация</skos:prefLabel>
    <skos:prefLabel xml:lang="en">charity organisation</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30901"/>
    <skos:prefLabel xml:lang="es">asistencia institucional</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">karitativer Verein</skos:altLabel>
    <skos:prefLabel xml:lang="sl">dobročinná organizácia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Œuvre de charité</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Liefdadigheidsvereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="it">organizzazioni caritative</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wohltätigkeitsorganisation</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wohlfahrt</skos:altLabel>
    <skos:prefLabel xml:lang="lt">labdaros organizacija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">assistència institucional</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30243">
    <skos:prefLabel xml:lang="ca">escenari celebració rural</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">uroczystości wiejskie</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Georkestreerde landelijke viering</skos:prefLabel>
    <skos:prefLabel xml:lang="it">festività rurali</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escenario celebración rural</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">inscenovaná vidiecka slávnosť</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Provinztheater-Fest</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">surežisuota kaimo šventė</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="en">Staged rural celebration</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Festivités rurales mises en scène</skos:prefLabel>
    <skos:prefLabel xml:lang="da">landfest</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">организирано селско празненство</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30501">
    <skos:prefLabel xml:lang="fr">Maladies et affections</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">болести и болестни състояния</skos:prefLabel>
    <skos:prefLabel xml:lang="es">enfermedades y afecciones</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Ziektes en aandoeningen</skos:prefLabel>
    <skos:prefLabel xml:lang="it">malattie e condizioni</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sygdomme</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Krankheiten und Bedingungen</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">choroby a ťažkosti</skos:prefLabel>
    <skos:prefLabel xml:lang="en">diseases and conditions</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">choroby i warunki socjalne</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ligos ir būklės</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erkrankungen</skos:altLabel>
    <skos:prefLabel xml:lang="ca">malalties i afeccions</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30500"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30715">
    <skos:prefLabel xml:lang="sl">baníci</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">górnicy</skos:prefLabel>
    <skos:prefLabel xml:lang="en">miners</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">miners</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mijnwerker</skos:prefLabel>
    <skos:prefLabel xml:lang="da">minearbejdere</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">minatori</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="es">mineros</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bergarbeiter</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kalnakasys</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bergleute</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Mineur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">миньор</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30119">
    <skos:prefLabel xml:lang="ca">bandes (Música)</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kapela</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">grupė; orkestras</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">оркестър</skos:prefLabel>
    <skos:prefLabel xml:lang="en">band</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Band</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Band</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kapelle</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Harmonie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="da">musikgrupper</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">banda</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="pl">zespół muzyczny</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30256">
    <skos:prefLabel xml:lang="ca">paisatge</skos:prefLabel>
    <skos:prefLabel xml:lang="en">landscape</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Paysage</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:prefLabel xml:lang="bg">пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Landschaft</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">krajina</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">peizažas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">landskab</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landschaftsbild</skos:altLabel>
    <skos:prefLabel xml:lang="pl">krajobraz</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Landschap</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31140">
    <skos:prefLabel xml:lang="it">protestantesimo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">protestantizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">protestantisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">protestantisme</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Protestantismus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">protestantismo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">протестанство</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Protestantyzm</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">protestantizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Protestantisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Protestantism</skos:prefLabel>
    <skos:prefLabel xml:lang="da">protestantismen</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30140">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">surrealismo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escena de animales</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">surrealizm</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Surréalisme</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сюрреализъм</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">surrealism</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">surrealisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">surrealisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="lt">siurrealizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Surrealismus</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Surrealisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">surrealizmus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30801">
    <skos:prefLabel xml:lang="da">botanik</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Botanik und Gärten</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <skos:prefLabel xml:lang="sl">botanika a záhrady</skos:prefLabel>
    <skos:prefLabel xml:lang="en">botany and gardens</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">botanica e giardini</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">botanika ir sodai</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">botànica i jardins</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Plantkunde en tuinen</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Botanique et jardins</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">botanika i ogrody</skos:prefLabel>
    <skos:prefLabel xml:lang="es">botánica i jardines</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ботаника и градини</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31256">
    <skos:prefLabel xml:lang="pl">miasto (architektura)</skos:prefLabel>
    <skos:altLabel xml:lang="de">Städtearchitektur</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">ciudad (arquitectura)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Stad (architectuur)</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">ville (architecture)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">by (arkitektur)</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">град (архитектура)</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ciutat (arquitectura</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mesto (architektúra)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">city (architecture)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Stadtarchitektur</skos:prefLabel>
    <skos:prefLabel xml:lang="it">città (architettura)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">miestas (architektūra)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30233">
    <skos:prefLabel xml:lang="en">Theatre costume</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Teater kostume</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">teatro kostiumai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">divadelný kostým</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vestuari</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="de">Bühnenkostüm</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">vestuario</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kostium teatralny</skos:prefLabel>
    <skos:prefLabel xml:lang="it">costumi teatrali</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">театрален костюм</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Theaterkostuum</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bühnenkostümierung</skos:altLabel>
    <skos:prefLabel xml:lang="fr">costume de théâtre</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30109">
    <skos:prefLabel xml:lang="ca">biblioteques</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">библиотека</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sammlung</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">cabeza</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">library</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Bibliotheek</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bibliothek</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bibilothèque</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">biblioteka</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">biblioteka</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">knižnica</skos:prefLabel>
    <skos:prefLabel xml:lang="it">biblioteca</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bücherei</skos:altLabel>
    <skos:prefLabel xml:lang="da">biblioteker</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11008">
    <skos:prefLabel xml:lang="da">negative udskrifter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">negatiu en paper</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki negatywowe</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Negativ-Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">negatyvo atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe negative</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones negativas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve négative</skos:prefLabel>
    <skos:altLabel xml:lang="de">Negativ prints</skos:altLabel>
    <skos:prefLabel xml:lang="sl">tlač z negatívu</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">negatiefdruk</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="en">negative prints</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="bg">негативен отпечатък</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30912">
    <skos:prefLabel xml:lang="nl">Toerisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Tourisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">turizmus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">туризъм</skos:prefLabel>
    <skos:altLabel xml:lang="de">Touristik</skos:altLabel>
    <skos:prefLabel xml:lang="en">tourism</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Tourismus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30910"/>
    <skos:prefLabel xml:lang="ca">turisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">turisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">turizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">turystyka</skos:prefLabel>
    <skos:prefLabel xml:lang="es">turismo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">turismo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fremdenverkehr</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30511">
    <skos:prefLabel xml:lang="pl">pielęgniarka</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kindermädchen</skos:altLabel>
    <skos:prefLabel xml:lang="es">enfermera</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">seselė</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">sygeplejersker</skos:prefLabel>
    <skos:prefLabel xml:lang="it">infermiera</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Infirmier</skos:prefLabel>
    <skos:altLabel xml:lang="de">Amme</skos:altLabel>
    <skos:prefLabel xml:lang="en">nurse</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Krankenschwester</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Verpleegkundige</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sestrička</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">infermeres</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">медицинска сестра</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30509"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30916">
    <skos:prefLabel xml:lang="lt">Moterų apranga</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30913"/>
    <skos:prefLabel xml:lang="es">ropa de vestir femenina</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Damenbekleidung</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">roba de vestir de dona</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">женско облекло</skos:prefLabel>
    <skos:altLabel xml:lang="de">Frauenkleidung</skos:altLabel>
    <skos:prefLabel xml:lang="en">Women's clothing</skos:prefLabel>
    <skos:altLabel xml:lang="de">Damenmode</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Vrouwenkleding</skos:prefLabel>
    <skos:prefLabel xml:lang="it">abbigliamento femminile</skos:prefLabel>
    <skos:prefLabel xml:lang="da">dametøj</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vêtements de femme</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Ubrania damskie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ženský odev</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30307">
    <skos:prefLabel xml:lang="en">earthquake</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">jordskælv</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="ca">terratrèmols</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">земетресение</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Erdbeben</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">terremotos</skos:prefLabel>
    <skos:prefLabel xml:lang="it">terremoto</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Aardbeving</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žemės drebėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">trzęsienie ziemi</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zemetrasenie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tremblement de terre</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30700">
    <skos:prefLabel xml:lang="ca">treball</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lavoro</skos:prefLabel>
    <skos:prefLabel xml:lang="en">labour</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">darbas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Arbeitskraft</skos:prefLabel>
    <skos:prefLabel xml:lang="es">trabajo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="nl">Arbeid</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Emploi</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">práca</skos:prefLabel>
    <skos:altLabel xml:lang="de">Personal</skos:altLabel>
    <skos:prefLabel xml:lang="bg">труд</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arbejdskraft</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">praca</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Arbeiterschaft</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30829">
    <skos:altLabel xml:lang="de">Pflanzenbewuchs</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="ca">vegetació</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vegetatie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">augalija/augmenija</skos:prefLabel>
    <skos:prefLabel xml:lang="es">canal</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">vegetation</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vegetazione</skos:prefLabel>
    <skos:prefLabel xml:lang="en">vegetation</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">растителност</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Végétation</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">roślinność</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Vegetation</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vegetácia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30204">
    <skos:prefLabel xml:lang="lt">karinė okupacija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <skos:prefLabel xml:lang="en">military occupation</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojenská okupácia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">военна окупация</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ocupación militar</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Militaire bezetting</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ocupació militar</skos:prefLabel>
    <skos:prefLabel xml:lang="de">militärische Besetzung</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Occupation militaire</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">okupacja wojenna /wojskowa</skos:prefLabel>
    <skos:prefLabel xml:lang="da">besættelser</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">occupazione militare</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30800">
    <skos:prefLabel xml:lang="nl">Landschappen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">peizažai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">landscapes</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">krajobrazy</skos:prefLabel>
    <skos:prefLabel xml:lang="da">landskaber</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Landschaften</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пейзаж</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Paysages</skos:prefLabel>
    <skos:prefLabel xml:lang="it">panorami</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">paisatge</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">krajiny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisajes</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30160">
    <skos:prefLabel xml:lang="ca">dibuix</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">Rysunki</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Piešiniai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">disegno</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Tekening</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kresba</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zeichnungen</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Dessins</skos:prefLabel>
    <skos:prefLabel xml:lang="es">artista</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Drawings</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">рисунка</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Tegninger</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31236">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">geležinkelis</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kolej żelazna</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">железница</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Voie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bahn</skos:altLabel>
    <skos:prefLabel xml:lang="de">Eisenbahn</skos:prefLabel>
    <skos:prefLabel xml:lang="da">jernbaner</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="it">ferrovia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Spoor</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">railway</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cabañas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">železnica</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ferrocarrils</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22000">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">dokumentárna fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dokumentarfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía documental</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Documentaire fotografie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <skos:prefLabel xml:lang="bg">документална фотография</skos:prefLabel>
    <skos:altLabel xml:lang="de">Dokumentarphotographie</skos:altLabel>
    <skos:prefLabel xml:lang="lt">dokumentinė fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="en">documentary photography</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="da">dokumentarisk fotografi</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia dokumentalna</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia documental</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie documentaire</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia documentaria</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31229">
    <skos:prefLabel xml:lang="ca">enginyeria mecànica</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">машинно инженерство</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mechaninė inžinerija/ technika</skos:prefLabel>
    <skos:prefLabel xml:lang="en">mechanical engineering</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ingegneria meccanica</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31224"/>
    <skos:prefLabel xml:lang="es">tranvía</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mechanica</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">strojárstvo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Mécanique</skos:prefLabel>
    <skos:prefLabel xml:lang="da">maskinindustrien</skos:prefLabel>
    <skos:altLabel xml:lang="de">Maschinenbauwesen</skos:altLabel>
    <skos:prefLabel xml:lang="de">Maschinenbau</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">inżynieria mechaniczna</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31215">
    <skos:prefLabel xml:lang="pl">antropologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">antropologia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">antropologia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:prefLabel xml:lang="da">antropologi</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Antropologie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">anthropology</skos:prefLabel>
    <skos:altLabel xml:lang="de">Menschenkunde</skos:altLabel>
    <skos:prefLabel xml:lang="bg">антропология</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">antropológia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">arqueología</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">antropologija</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Anthropologie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Anthropologie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31120">
    <skos:prefLabel xml:lang="fr">Synagogue</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">синагога</skos:prefLabel>
    <skos:prefLabel xml:lang="en">synagogue</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">synagóga</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sinagoga</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sinagoga</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sinagoga</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="da">synagoger</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Synagoge</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Synagoge</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">synagoga</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sinagogues</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30815">
    <skos:prefLabel xml:lang="lt">gamtovaizdis</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <skos:prefLabel xml:lang="pl">krajobraz naturalny</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">природен пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Naturlandschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Paysage naturel</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">paisatges naturals</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Natuurlijk landschap</skos:prefLabel>
    <skos:prefLabel xml:lang="en">natural landscape</skos:prefLabel>
    <skos:prefLabel xml:lang="da">natur</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cementerio</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prírodná scenéria</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio naturale</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30181">
    <skos:altLabel xml:lang="de">Töpferware</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Céramique</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Keramika</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">ceramica</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ceramika</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="de">Keramik</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Keramik</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Pottery</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ceràmica</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hrnčiarstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изделие от керамика</skos:prefLabel>
    <skos:altLabel xml:lang="de">Töpferei</skos:altLabel>
    <skos:prefLabel xml:lang="es">años veinte</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Aardewerk</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30118">
    <skos:altLabel xml:lang="de">Zuschauer</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">publikum</skos:prefLabel>
    <skos:prefLabel xml:lang="da">publikum</skos:prefLabel>
    <skos:prefLabel xml:lang="it">pubblico</skos:prefLabel>
    <skos:altLabel xml:lang="de">Zuhörer</skos:altLabel>
    <skos:prefLabel xml:lang="bg">публика</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Publiek</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">publiczność</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Publikum</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">públic</skos:prefLabel>
    <skos:prefLabel xml:lang="en">audience</skos:prefLabel>
    <skos:prefLabel xml:lang="es">relicario</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Public</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">publika/ auditorija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21006">
    <skos:altLabel xml:lang="de">Studio-Porträt</skos:altLabel>
    <skos:prefLabel xml:lang="bg">студиен портрет</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Studioportret</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="de">Studio-Portrait</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">ritratto in studio</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">studijinis portretas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">portret studyjny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">retrato de estudio</skos:prefLabel>
    <skos:prefLabel xml:lang="en">studio portrait</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Portrait en studio</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">štúdiový portrét</skos:prefLabel>
    <skos:prefLabel xml:lang="da">studie portræt</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">retrat d'estudi</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30242">
    <skos:prefLabel xml:lang="fr">Festivités urbaines mises en scène</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escenari celebració ciutadana</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Georkestreerde stedelijke viering</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">surežisuota miesto šventė</skos:prefLabel>
    <skos:prefLabel xml:lang="da">byfest</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">inscenovaná mestská slávnosť</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">организирано градско празненство</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="de">Stadttheater-Fest</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escenario celebración ciudadana</skos:prefLabel>
    <skos:prefLabel xml:lang="it">festività cittadine</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">uroczystości  miejskie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Staged city celebration</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31133">
    <skos:prefLabel xml:lang="bg">окупация</skos:prefLabel>
    <skos:prefLabel xml:lang="en">occupation</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">okupacija</skos:prefLabel>
    <skos:altLabel xml:lang="de">Besatzung</skos:altLabel>
    <skos:prefLabel xml:lang="de">Besetzung</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Occupation</skos:prefLabel>
    <skos:prefLabel xml:lang="da">besættelse</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ocupación</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">oficis</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zamestnanie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">zawód</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31100"/>
    <skos:altLabel xml:lang="de">Arbeit</skos:altLabel>
    <skos:prefLabel xml:lang="it">occupazione</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Beroep</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30821">
    <skos:prefLabel xml:lang="ca">paisatge marí</skos:prefLabel>
    <skos:prefLabel xml:lang="da">marinemalerier</skos:prefLabel>
    <skos:prefLabel xml:lang="es">playa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue sur mer</skos:prefLabel>
    <skos:altLabel xml:lang="de">Meeres-Panorama</skos:altLabel>
    <skos:prefLabel xml:lang="de">Meer-Landschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Zeegezicht</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio marino</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">marina/jūros peizažas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">seascape</skos:prefLabel>
    <skos:altLabel xml:lang="de">Seelandschaft</skos:altLabel>
    <skos:prefLabel xml:lang="bg">морски пейзаж</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">pejzaż morski</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">morská scenéria</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31204">
    <skos:prefLabel xml:lang="lt">chemija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
    <skos:prefLabel xml:lang="nl">Chemie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">chimica</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Chemie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">chemistry</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Chimie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">chémia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">chemia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kemi</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">química</skos:prefLabel>
    <skos:prefLabel xml:lang="es">química</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">химия</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11005">
    <skos:prefLabel xml:lang="it">trasporti dell'immagine</skos:prefLabel>
    <skos:prefLabel xml:lang="da">billedoverførsler</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prenos obrazu/fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">експониране на изображения</skos:prefLabel>
    <skos:prefLabel xml:lang="es">transferencia de imágenes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">imatge per transferència</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">transfery obrazu</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bildübertragungen</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11001"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="lt">vaizdo perkėlimai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">transfert d'image</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">beeldoverdracht</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">image transfers</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30253">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">морски пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="es">marinero</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">marina; marinistinis peizažas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Marine</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Marine</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Marine</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Marine</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Marine</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">marina</skos:prefLabel>
    <skos:prefLabel xml:lang="it">marina</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Marí</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:prefLabel xml:lang="sl">loďstvo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30708">
    <skos:prefLabel xml:lang="nl">Klerken</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">administratíva</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Clercs</skos:prefLabel>
    <skos:altLabel xml:lang="de">Büroangestellte</skos:altLabel>
    <skos:prefLabel xml:lang="es">estamento eclesiástico</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">raštinės darbuotojai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">духовник</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kontorarbejdere</skos:prefLabel>
    <skos:prefLabel xml:lang="en">clerical staff</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">impiegati</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sacerdots</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">personel biurowy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Büropersonal</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30802">
    <skos:prefLabel xml:lang="lt">parkas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">park</skos:prefLabel>
    <skos:prefLabel xml:lang="it">parco</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">park</skos:prefLabel>
    <skos:prefLabel xml:lang="en">park</skos:prefLabel>
    <skos:prefLabel xml:lang="es">parque</skos:prefLabel>
    <skos:altLabel xml:lang="de">Grünanlage</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Park</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Park</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">parcs</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">парк</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30801"/>
    <skos:prefLabel xml:lang="fr">Parc</skos:prefLabel>
    <skos:prefLabel xml:lang="da">parker</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30832">
    <skos:prefLabel xml:lang="ca">pedreres</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mijn</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="pl">dół</skos:prefLabel>
    <skos:prefLabel xml:lang="da">huler</skos:prefLabel>
    <skos:prefLabel xml:lang="es">lagos</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Pit</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Bergwerk</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Mine</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">baňa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">duobė</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kern</skos:altLabel>
    <skos:prefLabel xml:lang="bg">яма</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">pozzo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">pit</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30192">
    <skos:prefLabel xml:lang="bg">интериор</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vista interior</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="nl">Binnenhuiszicht</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diseño de vestuario</skos:prefLabel>
    <skos:altLabel xml:lang="de">Innen-Ansicht</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Vue intérieure</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Widok wnętrza</skos:prefLabel>
    <skos:prefLabel xml:lang="da">indretning</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Vidinis paviršius</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Innenansicht</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">interiér</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Interior view</skos:prefLabel>
    <skos:prefLabel xml:lang="it">veduta d'interni</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30842">
    <skos:prefLabel xml:lang="de">Autobahn</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">carreteres</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">cesta, diaľnica</skos:prefLabel>
    <skos:prefLabel xml:lang="en">highway</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">autostrada</skos:prefLabel>
    <skos:prefLabel xml:lang="it">autostrada</skos:prefLabel>
    <skos:prefLabel xml:lang="es">carreteras</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Schnellstraße</skos:altLabel>
    <skos:prefLabel xml:lang="da">hovedvej</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">plentas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="bg">магистрала</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Snelweg</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Autoroute</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fernstraße</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30263">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30143"/>
    <skos:prefLabel xml:lang="nl">Castell</skos:prefLabel>
    <skos:prefLabel xml:lang="en">castellers (human tower)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">akrobatisk pyramide</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гимнастическа пирамида</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">castellers (wieże ludzkie)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Castells</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">castell (žmonių bokštas)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Menschenturm</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ľudské veže</skos:prefLabel>
    <skos:prefLabel xml:lang="es">castellers</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">castellers</skos:prefLabel>
    <skos:prefLabel xml:lang="it">torri umane</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11015">
    <skos:prefLabel xml:lang="fr">transfert au collodion</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kollodium-Übertragung</skos:prefLabel>
    <skos:prefLabel xml:lang="es">transferencias al colodión</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="pl">transfery kolodionowe</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">trasporti al collodio</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kolodiniai perkėlimai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">collodiumoverdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kollodium overførsler</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kolódiový prenos</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">transferència al col·lodió</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">колодиево експониране</skos:prefLabel>
    <skos:prefLabel xml:lang="en">collodion transfers</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30718">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="bg">служител</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Angestellter</skos:prefLabel>
    <skos:prefLabel xml:lang="en">employee</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tarnautojas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Angestellte</skos:altLabel>
    <skos:prefLabel xml:lang="ca">empleats</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">pracownik</skos:prefLabel>
    <skos:prefLabel xml:lang="es">empleados</skos:prefLabel>
    <skos:prefLabel xml:lang="da">medarbejder</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zamestnanec</skos:prefLabel>
    <skos:prefLabel xml:lang="it">impiegato</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Werknemer</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Employé</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11026">
    <skos:prefLabel xml:lang="it">autocromie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">autochróm</skos:prefLabel>
    <skos:prefLabel xml:lang="en">autochromes</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11023"/>
    <skos:prefLabel xml:lang="de">Autochrome</skos:prefLabel>
    <skos:prefLabel xml:lang="es">autocromo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">autochroomplaat</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="bg">автохром</skos:prefLabel>
    <skos:prefLabel xml:lang="da">autochromer</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">autochromai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">autochrome</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">autocrom</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">autochromy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30502">
    <skos:prefLabel xml:lang="da">epidemier</skos:prefLabel>
    <skos:altLabel xml:lang="de">Seuche</skos:altLabel>
    <skos:prefLabel xml:lang="en">epidemic</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Epidemie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Epidemie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">epidemia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">epidemia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">epidemia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Épidémie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">епидемия</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">epidèmies</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">epidemija</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">epidémia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30501"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30811">
    <skos:prefLabel xml:lang="es">bosque</skos:prefLabel>
    <skos:prefLabel xml:lang="en">industrial landscape</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paisatges industrials</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industrieel landschap</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <skos:prefLabel xml:lang="de">Industrie-Landschaft</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">priemyselná krajina</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индустриален пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio industriale</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">krajobraz przemysłowy</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pramoninis peizažas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">industrielle Landschaft</skos:altLabel>
    <skos:prefLabel xml:lang="da">industri</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Paysage industriel</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30812">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30811"/>
    <skos:altLabel xml:lang="de">Flugplatz</skos:altLabel>
    <skos:prefLabel xml:lang="en">airport</skos:prefLabel>
    <skos:prefLabel xml:lang="es">montaña</skos:prefLabel>
    <skos:prefLabel xml:lang="da">lufthavne</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">летище</skos:prefLabel>
    <skos:prefLabel xml:lang="it">aeroporto</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">letisko</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Flughafen</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lotnisko</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Luchthaven</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">oro uostas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Aéroport</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">aeroports</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30153">
    <skos:prefLabel xml:lang="en">Outdoor sculpture</skos:prefLabel>
    <skos:altLabel xml:lang="de">Außenskulptur</skos:altLabel>
    <skos:prefLabel xml:lang="es">museo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escultura a l'aire lliure</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">Lauko skulptūra</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">socha na vonkajšom priestranstve</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Rzeźba plenerowa</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Udendørsskulpturer</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Skulptur im Freien</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sculpture extérieure</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Buitensculptuur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">скулптура на открито</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scultura all'aperto</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30117">
    <skos:prefLabel xml:lang="nl">Artiest</skos:prefLabel>
    <skos:prefLabel xml:lang="en">artist</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skuespiller</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Künstler</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">artistes</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">художник</skos:prefLabel>
    <skos:altLabel xml:lang="de">Maler</skos:altLabel>
    <skos:prefLabel xml:lang="it">artista</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">artysta</skos:prefLabel>
    <skos:prefLabel xml:lang="es">relieve</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="lt">menininkas; artistas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Artiste</skos:prefLabel>
    <skos:altLabel xml:lang="de">Künstlerin</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">umelec</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30222">
    <skos:prefLabel xml:lang="sl">mierový proces</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">proces pokojowy</skos:prefLabel>
    <skos:prefLabel xml:lang="es">prisioneros de guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">taikos procesas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Processus de paix</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fredsprocesser</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tractats de pau</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мирен процес</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Friedensprozess</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <skos:prefLabel xml:lang="nl">Vredesproces</skos:prefLabel>
    <skos:prefLabel xml:lang="it">processo di pace</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">peace process</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31243">
    <skos:altLabel xml:lang="de">Volksstamm</skos:altLabel>
    <skos:altLabel xml:lang="de">Sippe</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Stam (bevolkingsgroep)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">plemię</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31215"/>
    <skos:prefLabel xml:lang="it">tribù</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Tribu</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kmeň</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tribu</skos:prefLabel>
    <skos:prefLabel xml:lang="da">stammer</skos:prefLabel>
    <skos:prefLabel xml:lang="es">artefacto arqueológico</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">племе</skos:prefLabel>
    <skos:prefLabel xml:lang="en">tribe</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Stamm</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">gentis</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30103">
    <skos:prefLabel xml:lang="bg">предмети на изкуството</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Oeuvres d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunstvoorwerpen</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Kunstgegenstände</skos:altLabel>
    <skos:prefLabel xml:lang="de">Kunstobjekte</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">objectes d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">meno objektai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">oggetti d'arte</skos:prefLabel>
    <skos:prefLabel xml:lang="en">art objects</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kunstgenstande</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="sl">umelecké objekty</skos:prefLabel>
    <skos:prefLabel xml:lang="es">objeto de arte</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przedmioty artystyczne</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31233">
    <skos:altLabel xml:lang="de">Apparat</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">stroj</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="da">maskiner</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">машина</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">locomotores</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">mechanizmas/ įrenginys</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Maschine</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Machine</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">maszyna</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Machine</skos:prefLabel>
    <skos:prefLabel xml:lang="it">veicolo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">zoología</skos:prefLabel>
    <skos:prefLabel xml:lang="en">machine</skos:prefLabel>
    <skos:altLabel xml:lang="de">Automat</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30201">
    <skos:prefLabel xml:lang="de">Terrorakt</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Terreurdaad</skos:prefLabel>
    <skos:prefLabel xml:lang="es">acto de terrorismo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">teroro aktas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">терористичен акт</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">akt terroru</skos:prefLabel>
    <skos:prefLabel xml:lang="it">atto di terrorismo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">terrorisme</skos:prefLabel>
    <skos:altLabel xml:lang="de">Terror-Akt</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">act of terror</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">teroristické akcie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Terrorisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">terror</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30163">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Metalarbejder</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Metalwork</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Metalo dirbinys</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">метал</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Dinanderie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">oggetti metallici</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">club infantil</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kovové výrobky</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="ca">metal·listeria</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Metaalwerk</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wyroby z metalu</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Metallarbeit</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11025">
    <skos:prefLabel xml:lang="nl">kleurentransparant</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:altLabel xml:lang="de">Farbschablonen</skos:altLabel>
    <skos:prefLabel xml:lang="en">color transparencies</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Farb-Schablonen</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">transparència color</skos:prefLabel>
    <skos:prefLabel xml:lang="da">farvetransparenter</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spalvotos skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цветна плака</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">transparent en couleur</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11023"/>
    <skos:prefLabel xml:lang="es">transparencias a colores</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">folie kolorowe</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lucidi a colori</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">farebné diapozitivy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30822">
    <skos:prefLabel xml:lang="sl">cintorín</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kapinės</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cimitero</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">cmentarz</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cementiris</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30801"/>
    <skos:prefLabel xml:lang="nl">Kerkhof</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kirkegårde</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cemetery</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гробище</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Cimetière</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gräber</skos:altLabel>
    <skos:prefLabel xml:lang="es">arquitectura del paisaje urbano</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gräber-Feld</skos:altLabel>
    <skos:prefLabel xml:lang="de">Friedhof</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31132">
    <skos:altLabel xml:lang="de">Versöhnungstag</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Yom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Yom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Yom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Yom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Yom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Yom Kippur /Fiesta del Gran Perdón</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Yom Kippur (Permaldavimas)</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:prefLabel xml:lang="sl">Jom kipur</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Jom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Jom Kippur</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Yom Kippour</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Йом Кипур</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30241">
    <skos:prefLabel xml:lang="lt">baletas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">balletto</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">balet</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">balet</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Ballett</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ballet</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ballet</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Ballet</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">ballet</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ballet</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ballet</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="bg">балет</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30707">
    <skos:prefLabel xml:lang="nl">Landbouwwerkers</skos:prefLabel>
    <skos:prefLabel xml:lang="es">agricultores</skos:prefLabel>
    <skos:prefLabel xml:lang="it">contadini</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žemės ūkio darbininkai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">poľnohospodárski robotníci</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Landarbeiter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">treballadors agrícoles</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">селскостопански работник</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landarbeiterin</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="da">landarbejdere</skos:prefLabel>
    <skos:prefLabel xml:lang="en">agricultural workers</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">robotnicy rolni</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ouvriers agricoles</skos:prefLabel>
    <skos:altLabel xml:lang="de">landwirtschaftlicher Arbeiter</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30803">
    <skos:prefLabel xml:lang="bg">градина</skos:prefLabel>
    <skos:prefLabel xml:lang="es">jardín</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">jardins</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Tuin</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jardin</skos:prefLabel>
    <skos:prefLabel xml:lang="da">haver</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">giardino</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ogród</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Garten</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">záhrada</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30801"/>
    <skos:prefLabel xml:lang="lt">sodas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">garden</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11006">
    <skos:prefLabel xml:lang="pl">ferrotypy</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ferrotipi</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">ferrotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">ferrotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tintypia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ferrotip</skos:prefLabel>
    <skos:altLabel xml:lang="de">Blechfotografien</skos:altLabel>
    <skos:prefLabel xml:lang="bg">тинтипия</skos:prefLabel>
    <skos:prefLabel xml:lang="en">tintypes</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ferrotypien</skos:altLabel>
    <skos:prefLabel xml:lang="es">ferrotipos</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11001"/>
    <skos:prefLabel xml:lang="lt">tintipai</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tintyper</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Tintypien</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30193">
    <skos:prefLabel xml:lang="nl">Dierenscene</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Gyvūnų scena</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">przedstawienie / scena animalistyczna</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сцена с животни</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escena amb animals</skos:prefLabel>
    <skos:altLabel xml:lang="de">Tiergeschichte</skos:altLabel>
    <skos:prefLabel xml:lang="it">scena animale</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">dyrebilleder</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Animal scene</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Tier-Szene</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">scéna so zvieratami</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tableau d'animaux</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="es">diseño de moda</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31203">
    <skos:prefLabel xml:lang="pl">biologia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">biologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">biologia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">biología</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">biológia</skos:prefLabel>
    <skos:prefLabel xml:lang="en">biology</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">биология</skos:prefLabel>
    <skos:prefLabel xml:lang="da">biologi</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">biologija</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Biologie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Biologie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Biologie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30831">
    <skos:prefLabel xml:lang="lt">ežeras</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">езеро</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="pl">jezioro</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lago</skos:prefLabel>
    <skos:prefLabel xml:lang="de">See</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">llacs</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Lac</skos:prefLabel>
    <skos:prefLabel xml:lang="da">søer</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Seen</skos:altLabel>
    <skos:prefLabel xml:lang="en">lake</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">jazero</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Meer</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">estanques</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30254">
    <skos:prefLabel xml:lang="es">paisaje urbano</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Stadszicht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paisatge urbà</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue sur la ville</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Stadtbild</skos:altLabel>
    <skos:prefLabel xml:lang="en">Cityscape</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Stadtlandschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pejzaż wielkomiejski</skos:prefLabel>
    <skos:prefLabel xml:lang="da">bybillede</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">miesto peizažas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">градски пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio urbano</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">panoráma mesta</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30717">
    <skos:prefLabel xml:lang="lt">namų darbininkas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lavoratori domestici</skos:prefLabel>
    <skos:altLabel xml:lang="de">Dienstboten</skos:altLabel>
    <skos:prefLabel xml:lang="bg">домашен работник</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Huishoudelijk personeel</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="en">domestic workers</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pomoc domowa</skos:prefLabel>
    <skos:prefLabel xml:lang="es">trabajadores domésticos</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">treballadors domèstic</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hausangestellte</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pracovníci v domácnosti</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">hushjælp</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Travailleur domestique</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30841">
    <skos:prefLabel xml:lang="ca">camins</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">path</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="sl">cesta, chodník,dráha</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sentiero</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">takas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Weg</skos:altLabel>
    <skos:prefLabel xml:lang="pl">ścieżka</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Wegen</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Route</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Pfad</skos:prefLabel>
    <skos:prefLabel xml:lang="es">caminos</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sti</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wanderweg</skos:altLabel>
    <skos:prefLabel xml:lang="bg">път</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30264">
    <skos:prefLabel xml:lang="da">traditionelt  catalansk bal</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">balli tradizionali/danze tradizionali</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tradičné plesy</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sardana</skos:altLabel>
    <skos:prefLabel xml:lang="bg">традиционен танц (сардана)</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sardanatanz</skos:altLabel>
    <skos:prefLabel xml:lang="es">bailes tradicionales (sardanas)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Katalonischer Volkstanz</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30143"/>
    <skos:prefLabel xml:lang="pl">sardanes</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sardane</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tradicinis šokis (sardana)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Traditioneel ball (sardana)</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">balls tradicionals (sardanes)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">traditional ball (sardanes)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11016">
    <skos:prefLabel xml:lang="en">cyanotypes</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cianotipi</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">cianotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kyanotypia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cianotipos</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цианотипия</skos:prefLabel>
    <skos:altLabel xml:lang="de">Blaudrucke</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:altLabel xml:lang="de">fotografisches Edeldruckverfahren</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">cianotip</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">cyjanotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">cyanotyper</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="nl">cyanotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">cyanotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Cyanotypien</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31142">
    <skos:prefLabel xml:lang="pl">zakonnice</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Soeurs</skos:prefLabel>
    <skos:altLabel xml:lang="fr">Nonnes</skos:altLabel>
    <skos:prefLabel xml:lang="it">suore</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">монахиня</skos:prefLabel>
    <skos:prefLabel xml:lang="da">nonner</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">monges</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Nonnen</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Nonnen</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Nonne</skos:altLabel>
    <skos:prefLabel xml:lang="es">monjas</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vienuolės</skos:prefLabel>
    <skos:prefLabel xml:lang="en">nuns</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mníšky</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31133"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30503">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">trattamento sanitario</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30500"/>
    <skos:prefLabel xml:lang="fr">Traitement de santé</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gezondheidsbehandeling</skos:prefLabel>
    <skos:prefLabel xml:lang="en">health treatment</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">здравно лечение</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">liečenie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tratamiento médico</skos:prefLabel>
    <skos:prefLabel xml:lang="da">behandlinger</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gesundheitsvorsorge</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">zdrowie / leczenie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tractament sanitari</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gydymas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30152">
    <skos:prefLabel xml:lang="nl">Zuilfiguur (kariatide)</skos:prefLabel>
    <skos:prefLabel xml:lang="it">figura intera, cariatide</skos:prefLabel>
    <skos:altLabel xml:lang="de">Säulen-Statue</skos:altLabel>
    <skos:prefLabel xml:lang="bg">колонна статуя</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Kolona</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="da">Søjlefigurer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Figura kolumnowa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Column figure</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Säulen-Figur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">karyatida</skos:prefLabel>
    <skos:prefLabel xml:lang="es">biblioteca</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Figure colonne</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">figura de columna</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30116">
    <skos:prefLabel xml:lang="da">kunstnere</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">aktorius</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Acteur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">актьор</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Acteur</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schauspieler</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">aktor</skos:prefLabel>
    <skos:prefLabel xml:lang="it">attore</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">estructuras funerarias</skos:prefLabel>
    <skos:altLabel xml:lang="de">Darsteller</skos:altLabel>
    <skos:prefLabel xml:lang="sl">herec</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="en">actor</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">actor</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30813">
    <skos:prefLabel xml:lang="lt">uostas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Port</skos:prefLabel>
    <skos:prefLabel xml:lang="en">port</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30811"/>
    <skos:prefLabel xml:lang="sl">prístav</skos:prefLabel>
    <skos:prefLabel xml:lang="da">havne</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">port / przystań</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Haven</skos:prefLabel>
    <skos:prefLabel xml:lang="es">río</skos:prefLabel>
    <skos:altLabel xml:lang="de">Häfen</skos:altLabel>
    <skos:prefLabel xml:lang="de">Hafen</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ports</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hafenstadt</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">porto</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пристанище</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30504">
    <skos:prefLabel xml:lang="de">Medizin</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">medycyna / lek /lekarstwo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">медицина</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">medicina</skos:prefLabel>
    <skos:prefLabel xml:lang="es">medicina</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">medicina</skos:prefLabel>
    <skos:prefLabel xml:lang="en">medicine</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Médecine</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">medicina</skos:prefLabel>
    <skos:altLabel xml:lang="de">Medikament</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30503"/>
    <skos:prefLabel xml:lang="nl">Geneeskunde</skos:prefLabel>
    <skos:prefLabel xml:lang="da">medicin</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">medicína</skos:prefLabel>
    <skos:altLabel xml:lang="de">Arznei</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30221">
    <skos:prefLabel xml:lang="fr">Révolte</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">zamieszki</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Rel</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nepokoj, výtržnosť</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Krawall</skos:altLabel>
    <skos:prefLabel xml:lang="lt">riaušės</skos:prefLabel>
    <skos:prefLabel xml:lang="da">optøjer</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бунт</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausschreitung</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="en">riot</skos:prefLabel>
    <skos:prefLabel xml:lang="es">prisioneros y detenidos</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">insurgència</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Lärm</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sommossa</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31244">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31215"/>
    <skos:prefLabel xml:lang="pl">koczownik</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">номад</skos:prefLabel>
    <skos:altLabel xml:lang="de">Nomaden</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Nomade</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Nomade</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Nomade</skos:prefLabel>
    <skos:prefLabel xml:lang="da">nomader</skos:prefLabel>
    <skos:prefLabel xml:lang="en">nomad</skos:prefLabel>
    <skos:altLabel xml:lang="de">Nomadin</skos:altLabel>
    <skos:prefLabel xml:lang="ca">nòmada</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nomád</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">klajoklis/ bastūnas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sitio arqueológico</skos:prefLabel>
    <skos:prefLabel xml:lang="it">nomade</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31309">
    <skos:prefLabel xml:lang="de">soziale Bedingungen</skos:prefLabel>
    <skos:prefLabel xml:lang="it">condizione sociale</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31300"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Condition sociale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">condición social</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">socialinės sąlygos</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">condició social</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">social condition</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">životné podmienky</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">социално положение</skos:prefLabel>
    <skos:altLabel xml:lang="de">gesellschaftliche Voraussetzungen</skos:altLabel>
    <skos:prefLabel xml:lang="da">sociale netværk</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">warunki życia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Sociale conditie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31234">
    <skos:prefLabel xml:lang="nl">Metro</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Metro</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="it">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="en">metro</skos:prefLabel>
    <skos:prefLabel xml:lang="da">metro</skos:prefLabel>
    <skos:altLabel xml:lang="de">Untergrundbahn</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">U-Bahn</skos:altLabel>
    <skos:prefLabel xml:lang="es">tribu</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">метро</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Métro</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30102">
    <skos:prefLabel xml:lang="pl">sztuka amatorska</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">любителско изкуство</skos:prefLabel>
    <skos:prefLabel xml:lang="es">artista amateur</skos:prefLabel>
    <skos:altLabel xml:lang="de">Laien-Schaffen</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="da">amatør kunst</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">art amateur</skos:prefLabel>
    <skos:prefLabel xml:lang="en">amateur art</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art amateur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Amateurkunsten</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">amatérske umenie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">artista dilettante</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Amateurkunst</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mėgėjų menas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hobby-Kunst</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30162">
    <skos:prefLabel xml:lang="da">Glas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cristalleria</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cristalleria</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Glassware</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Glaswaren</skos:prefLabel>
    <skos:altLabel xml:lang="de">Glas-Waren</skos:altLabel>
    <skos:prefLabel xml:lang="pl">wyroby szklane</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="sl">predmety zo skla</skos:prefLabel>
    <skos:prefLabel xml:lang="es">banda</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Verrerie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">стъкло</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Stiklo gaminiai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Glaswerk</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30309">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="bg">пожар</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fuego</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">incendis</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fire</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Incendie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pożar</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Feuer</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">gaisras</skos:prefLabel>
    <skos:prefLabel xml:lang="da">brande</skos:prefLabel>
    <skos:altLabel xml:lang="de">Flamme</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Brand</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">oheň</skos:prefLabel>
    <skos:altLabel xml:lang="de">Brand</skos:altLabel>
    <skos:prefLabel xml:lang="it">incendio</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30202">
    <skos:prefLabel xml:lang="de">bewaffneter Konflikt</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ozbrojený konflikt</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="es">conflicto armado</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Conflit armé</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">armed conflict</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">въоръжен конфликт</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">konflikt zbrojny</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <skos:prefLabel xml:lang="it">conflitto armato</skos:prefLabel>
    <skos:prefLabel xml:lang="da">væbnet konflikt</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">ginkluotas konfliktas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gewapend conflict</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30823">
    <skos:prefLabel xml:lang="lt">gatvės vaizdas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vistes de carrers</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">pohľad na ulicu</skos:prefLabel>
    <skos:prefLabel xml:lang="de">streetview</skos:prefLabel>
    <skos:prefLabel xml:lang="en">streetview</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strassen-Ansicht</skos:altLabel>
    <skos:prefLabel xml:lang="da">gadebilleder</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="bg">градски изглед</skos:prefLabel>
    <skos:prefLabel xml:lang="es">aeropuerto</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vista sulla strada</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Straßenansicht</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Straatzicht</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue sur la rue</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">widok ulicy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30830">
    <skos:prefLabel xml:lang="ca">estanys</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vijver</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stagno</skos:prefLabel>
    <skos:altLabel xml:lang="de">Becken</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="sl">rybník</skos:prefLabel>
    <skos:prefLabel xml:lang="da">damme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Étang</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vegetación</skos:prefLabel>
    <skos:prefLabel xml:lang="en">pond</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">tvenkinys</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">декоративно езеро</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">staw</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Teich</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30251">
    <skos:prefLabel xml:lang="pl">widok topograficzny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vista fotográfica</skos:prefLabel>
    <skos:altLabel xml:lang="de">Topografische Aufnahme</skos:altLabel>
    <skos:prefLabel xml:lang="de">Topografische Sicht</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">топографски план</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">topografinis vaizdas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">Vista topogràfica</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Topografisch zicht</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">topografický pohľad</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Topographical View</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vista topografica</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue topographique</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">topografisk View</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31259">
    <skos:prefLabel xml:lang="ca">globus</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Ballon</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ballon</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ballon</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">balionas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">globo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">balon</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">balón</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Luchtballon</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">mongolfiera</skos:prefLabel>
    <skos:prefLabel xml:lang="en">balloon</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="bg">балон</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30706">
    <skos:prefLabel xml:lang="nl">Bezetting</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30700"/>
    <skos:prefLabel xml:lang="it">occupazione</skos:prefLabel>
    <skos:prefLabel xml:lang="da">blokader</skos:prefLabel>
    <skos:altLabel xml:lang="de">Tätigkeit</skos:altLabel>
    <skos:prefLabel xml:lang="lt">okupacija</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ocupación</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">okupácia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zawód /profesja</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">occupation</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">окупация</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ocupació</skos:prefLabel>
    <skos:altLabel xml:lang="de">Beruf</skos:altLabel>
    <skos:prefLabel xml:lang="de">Arbeit</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Occupation</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30265">
    <skos:prefLabel xml:lang="nl">(Stads)reus</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">milžiniškos procesijų lėlės</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">figury procesyjne nadnaturalnych rozmiarów</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30143"/>
    <skos:prefLabel xml:lang="en">giant processional figures</skos:prefLabel>
    <skos:prefLabel xml:lang="es">gigantes</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">големи карнавални фигури</skos:prefLabel>
    <skos:altLabel xml:lang="fr">Géant de cortège</skos:altLabel>
    <skos:prefLabel xml:lang="ca">gegants</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Géant de procession</skos:prefLabel>
    <skos:prefLabel xml:lang="de">riesengroße, riesige Prozessionsfiguren</skos:prefLabel>
    <skos:prefLabel xml:lang="it">figure giganti da processione</skos:prefLabel>
    <skos:prefLabel xml:lang="da">processionsfigurer</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">veľké procesiové bábky</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30804">
    <skos:prefLabel xml:lang="de">Stadtbild</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">krajobraz miejski</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <skos:prefLabel xml:lang="nl">Stadszicht</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">panoráma mesta</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arquitectura del paisatge urbà</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">градски пейзаж</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cityscape</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Stadtlandschaft</skos:altLabel>
    <skos:prefLabel xml:lang="lt">miestovaizdis</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio urbano</skos:prefLabel>
    <skos:prefLabel xml:lang="da">bybilleder</skos:prefLabel>
    <skos:prefLabel xml:lang="es">puente</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vue sur la ville</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31206">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">физика</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fizyka</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fisica</skos:prefLabel>
    <skos:prefLabel xml:lang="en">physics</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fysica</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Physik</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">física</skos:prefLabel>
    <skos:prefLabel xml:lang="es">física</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">fyzika</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fysik</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fizika</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Physique</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31131">
    <skos:prefLabel xml:lang="it">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Ramadán</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ramadán</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Ramadà</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">Рамадан</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Ramadanas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ramadan</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ramadan</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30240">
    <skos:prefLabel xml:lang="en">variety</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">varieté</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">varietats</skos:prefLabel>
    <skos:prefLabel xml:lang="es">variedades</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">varia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">varjetė</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">вариете</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="de">Variete</skos:prefLabel>
    <skos:prefLabel xml:lang="it">varietà</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">variété</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">variété</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">variété</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30514">
    <skos:altLabel xml:lang="de">Kurzentrum</skos:altLabel>
    <skos:prefLabel xml:lang="ca">balnearis</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ozdravovne</skos:prefLabel>
    <skos:prefLabel xml:lang="es">balnearios</skos:prefLabel>
    <skos:prefLabel xml:lang="it">resort/spa</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kurort</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kursted</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Spa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kurortas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30503"/>
    <skos:prefLabel xml:lang="nl">Kuuroord</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">лечебен курорт</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">health resort</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kurort</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11024">
    <skos:prefLabel xml:lang="sl">čiernobiele diapozitivy</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">baltai juodos skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lucidi in bianco e nero</skos:prefLabel>
    <skos:prefLabel xml:lang="es">transparencias blanco y negro</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">zwart-wit transparant</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">transparent en noir et blanc</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">schwarz-weiss-Schablonen</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="pl">folie czarno-białe</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sort-hvide transparenter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">transparència blanc i negre</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schwarz-weiß-Schablonen</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">черно-бяла плака</skos:prefLabel>
    <skos:prefLabel xml:lang="en">black-and-white transparencies</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11023"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30230">
    <skos:prefLabel xml:lang="nl">Vluchteling</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бежанец</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Réfugié</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">uchodźca</skos:prefLabel>
    <skos:prefLabel xml:lang="es">campo de prisioneros</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">utečenec</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="de">Flüchtling</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">refugiats</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rifugiato</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">flygtninge</skos:prefLabel>
    <skos:prefLabel xml:lang="en">refugee</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pabėgėlis</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30919">
    <skos:prefLabel xml:lang="it">parco divertimenti</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30918"/>
    <skos:prefLabel xml:lang="fr">Parc d'attractions</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">parc d'atraccions</skos:prefLabel>
    <skos:prefLabel xml:lang="da">forlystelsespark</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zábavné parky</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">увеселителен парк</skos:prefLabel>
    <skos:altLabel xml:lang="de">Freizeitpark</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Pretpark</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">atrakcionų parkas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">amusement park</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Rummelplatz</skos:altLabel>
    <skos:prefLabel xml:lang="de">Vergnügungspark</skos:prefLabel>
    <skos:prefLabel xml:lang="es">parque de diversiones</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">park rozrywki</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31405">
    <skos:prefLabel xml:lang="lt">profesonalusis sportas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:altLabel xml:lang="de">Sportorganisation</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Professionele sport</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esport professional</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sport professionel</skos:prefLabel>
    <skos:prefLabel xml:lang="da">professionel sport</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Profi-Sport</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Sportverband</skos:altLabel>
    <skos:prefLabel xml:lang="bg">професионален спорт</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sport professionistico</skos:prefLabel>
    <skos:prefLabel xml:lang="en">professional sport</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">profesionálny šport</skos:prefLabel>
    <skos:prefLabel xml:lang="es">deporte professional</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sport zawodowy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11003">
    <skos:prefLabel xml:lang="nl">daguerreotypie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11001"/>
    <skos:prefLabel xml:lang="fr">daguerréotype</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">dagherrotipi</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fotografie-Verfahren</skos:altLabel>
    <skos:prefLabel xml:lang="es">daguerrotipos</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dangerotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">daguerreotip</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">dagerotypia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">dagerotypy</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="de">Daguerreotypien</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">дагеротипия</skos:prefLabel>
    <skos:prefLabel xml:lang="en">daguerreotypes</skos:prefLabel>
    <skos:altLabel xml:lang="de">Dago</skos:altLabel>
    <skos:prefLabel xml:lang="da">daguerreotypier</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11017">
    <skos:prefLabel xml:lang="fr">épreuves gélatino-argentiques</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="it">argentotipo, gelatine ai sali d'argento</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="de">Silbergelatine-Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сребърно-желатинов отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones de plata</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sidabro druskų atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gelatine Sølvtryk</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">ontwikkelgelatinezilverdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="en">gelatin silver prints</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">želatínová tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paper a la gelatina de plata</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki żelatynowo-srebrowe</skos:prefLabel>
    <skos:altLabel xml:lang="de">Silbergelatine-Fotos</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31231">
    <skos:prefLabel xml:lang="es">tranvía</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">bicykel</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vélo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">bicycle</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">велосипед</skos:prefLabel>
    <skos:prefLabel xml:lang="it">bicicletta</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rower</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dviratis</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fiets</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Fahrrad</skos:prefLabel>
    <skos:prefLabel xml:lang="da">cykler</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">bicicletes</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fahrräder</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31245">
    <skos:prefLabel xml:lang="de">Hut</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Hut (huis)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">chata /szałas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">excavación</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31215"/>
    <skos:prefLabel xml:lang="sl">barak</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hütte</skos:altLabel>
    <skos:prefLabel xml:lang="lt">trobelė/ pirkia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">hytter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cabanyes (Habitatges)</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Cabane</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">колиба</skos:prefLabel>
    <skos:prefLabel xml:lang="it">capanna</skos:prefLabel>
    <skos:prefLabel xml:lang="en">hut</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30505">
    <skos:altLabel xml:lang="de">Tauglichkeit</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Fysieke gezondheid</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sprawność fizyczna</skos:prefLabel>
    <skos:prefLabel xml:lang="de">körperliche Fitness</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">физическа годност</skos:prefLabel>
    <skos:altLabel xml:lang="de">körperliches Befinden</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">condició física</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fizinė būklė</skos:prefLabel>
    <skos:prefLabel xml:lang="es">condición física</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Santé physique</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sundhed</skos:prefLabel>
    <skos:prefLabel xml:lang="it">forma fisica</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">fyzická kondícia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30503"/>
    <skos:prefLabel xml:lang="en">physical fitness</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31406">
    <skos:prefLabel xml:lang="sl">rekreačný šport</skos:prefLabel>
    <skos:prefLabel xml:lang="es">deporte recreativo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Recreatieve sport</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">любителски спорт</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rekreativ sport</skos:prefLabel>
    <skos:altLabel xml:lang="de">sportliche Freizeitaktivitäten</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Breitensport</skos:altLabel>
    <skos:prefLabel xml:lang="pl">sport rekreacyjny</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Freizeitsport</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="lt">rekreacinis sportas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sport récréatif</skos:prefLabel>
    <skos:prefLabel xml:lang="en">recreational sport</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esport recreatiu</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">sport dilettantistico</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30115">
    <skos:prefLabel xml:lang="sl">účastníci umeleckých a kultúrnych podujatí</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="bg">човек на изкуството</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunst/cultuurparticipanten</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">actors de la cultura i l'art</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kunstaktører</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kunst / Kultur-Teilnehmer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">operatori d'arte / cultura</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Participants d'art/culture</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">meno/ kultūros veikėjai</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">art / culture participants</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escultura conmemorativa</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">uczestnicy kultury</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kultur-Mitwirkende</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30151">
    <skos:prefLabel xml:lang="pl">Figura</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">socha</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">estàtua</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="it">statua</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Statue</skos:prefLabel>
    <skos:prefLabel xml:lang="es">moda</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Statue</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Statue</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Statue</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Statula</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">статуя</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Standbeeld</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30105">
    <skos:prefLabel xml:lang="nl">Film</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Film</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cinema</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cinema</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kino</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kino</skos:prefLabel>
    <skos:altLabel xml:lang="de">Filmtheater</skos:altLabel>
    <skos:prefLabel xml:lang="de">Kino</skos:prefLabel>
    <skos:altLabel xml:lang="de">Filmkunst</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">corridas de toros</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">kinas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">biografer</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cinematografia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">кино</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30165">
    <skos:prefLabel xml:lang="de">Möblierung</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nábytok</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mobles</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausrüstung</skos:altLabel>
    <skos:prefLabel xml:lang="en">Furniture</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">мебел</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausstattung</skos:altLabel>
    <skos:prefLabel xml:lang="pl">Meble</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Baldai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">arredi, arredamento</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mobilier</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">sociedad musical</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="nl">Meubilair</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Møbler</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30824">
    <skos:prefLabel xml:lang="ca">pobles</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">село</skos:prefLabel>
    <skos:prefLabel xml:lang="it">villaggio</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="en">village</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dorf</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">dedina</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Village</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wieś</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">puerto</skos:prefLabel>
    <skos:altLabel xml:lang="de">Dörfer</skos:altLabel>
    <skos:prefLabel xml:lang="lt">kaimas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Dorp</skos:prefLabel>
    <skos:prefLabel xml:lang="da">landsbyer</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30515">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">sierociniec</skos:prefLabel>
    <skos:prefLabel xml:lang="es">orfanatos</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">našlaičių prieglauda</skos:prefLabel>
    <skos:prefLabel xml:lang="da">børnehjem</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30500"/>
    <skos:prefLabel xml:lang="fr">Orphelinat</skos:prefLabel>
    <skos:prefLabel xml:lang="en">orphanage</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Weeshuis</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">orfanats</skos:prefLabel>
    <skos:altLabel xml:lang="de">Waisenhäuser</skos:altLabel>
    <skos:prefLabel xml:lang="it">orfanatrofio</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сиропиталище</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Waisenhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sirotinec</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30190">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">Alegoria</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estudio</skos:prefLabel>
    <skos:prefLabel xml:lang="it">allegoria</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">al·legoria</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Allegorie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Allegorie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Allegorie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">алегория</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Allégorie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">alegória</skos:prefLabel>
    <skos:prefLabel xml:lang="da">allegorier</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Alegorija</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30220">
    <skos:altLabel xml:lang="de">Umwälzung</skos:altLabel>
    <skos:prefLabel xml:lang="bg">революция</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">revolúcia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">revolucions</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="pl">rewolucja</skos:prefLabel>
    <skos:altLabel xml:lang="de">Umsturz</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Révolution</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">reconstrucción de post guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="en">revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="da">revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rivoluzione</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">revoliucija</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Revolutie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30210">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">Wojny opiumowe</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre de l'opium</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Opium-Kriege</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Opium-krigene</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Opiumoorlogen</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ópiové vojny</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">guerra dell'oppio</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">опиумна война</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">opiumo karai</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra del opio</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Xina--Història--1840-1842, Guerra de l'opi</skos:prefLabel>
    <skos:altLabel xml:lang="de">Opiumkrieg</skos:altLabel>
    <skos:prefLabel xml:lang="en">opium wars</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30266">
    <skos:prefLabel xml:lang="bg">убежище</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">slėptuvė</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Abris</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">rifugio</skos:prefLabel>
    <skos:altLabel xml:lang="de">Obdach</skos:altLabel>
    <skos:prefLabel xml:lang="es">refugios</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Shelter</skos:prefLabel>
    <skos:prefLabel xml:lang="da">shelter</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schutzraum</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Schuilplaats</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <skos:prefLabel xml:lang="pl">uchodźcy</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">prístrešok</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zuflucht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">refugis</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30191">
    <skos:altLabel xml:lang="de">Gattung</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="fr">Tableau de genre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">retablo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Žanras</skos:prefLabel>
    <skos:prefLabel xml:lang="it">genere</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kunstgattung</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Genre</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Genre</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Rodzaj / gatunek</skos:prefLabel>
    <skos:prefLabel xml:lang="da">genrer</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Genretafereel</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">žáner</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">жанр</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">gènere</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30252">
    <skos:prefLabel xml:lang="fr">Vue sur mer</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje marino</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Zeezicht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Paisatge marí</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Seelandschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Seascape</skos:prefLabel>
    <skos:altLabel xml:lang="de">Meeres-Panorama</skos:altLabel>
    <skos:prefLabel xml:lang="pl">pejzaż morski</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">morská scenéria</skos:prefLabel>
    <skos:prefLabel xml:lang="da">marinemaleri</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">jūros peizažas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">paesaggio marino</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">морски пейзаж</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30251"/>
    <skos:altLabel xml:lang="de">Meer-Landschaft</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11004">
    <skos:prefLabel xml:lang="sl">hillotypia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">hillotipi</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Hillotipos</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">hilotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">холотипия</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">hillotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">hillotypie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11001"/>
    <skos:prefLabel xml:lang="fr">hillotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Hillotypes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">hil·lotip</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="da">Hillotyper</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hillotypien</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31130">
    <skos:prefLabel xml:lang="lt">Sekminės</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Pfingsten</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Svätodušné sviatky, turíce</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Pentecostés</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Петдестница</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Pentecoste</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">Zielone Świątki</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pentecôte</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Pinse</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Pentecost</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Pentecosta</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Pinksteren</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31205">
    <skos:prefLabel xml:lang="da">havebrug</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Gartenbaukunst</skos:altLabel>
    <skos:prefLabel xml:lang="bg">градинарство</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
    <skos:prefLabel xml:lang="es">horticultura</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">horticultura</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">záhradníctvo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ogrodnictwo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Horticulture</skos:prefLabel>
    <skos:prefLabel xml:lang="en">horticulture</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gartenbau</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sodininkystė</skos:prefLabel>
    <skos:prefLabel xml:lang="it">orticoltura</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Tuinbouw</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30805">
    <skos:prefLabel xml:lang="it">ponte</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Brücke</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мост</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">most</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">most</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Brug</skos:prefLabel>
    <skos:prefLabel xml:lang="en">bridge</skos:prefLabel>
    <skos:prefLabel xml:lang="es">hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tiltas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ponts</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">broer</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pont</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30705">
    <skos:prefLabel xml:lang="nl">Staking</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">strajk</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">streikas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sciopero</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Arbeitsniederlegung</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">huelga</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Streik</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vagues i locauts</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">štrajk</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Grève</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30704"/>
    <skos:prefLabel xml:lang="en">strike</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">стачка</skos:prefLabel>
    <skos:altLabel xml:lang="de">Arbeitseinstellung</skos:altLabel>
    <skos:prefLabel xml:lang="da">strejker</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11023">
    <skos:prefLabel xml:lang="nl">fotografische transparanten</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fotografinės skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">folie fotograficzne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="es">transparencias fotográficas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">fotografické diapozitivy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Foto-Schablonen</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фотоплака</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fotografiske transparenter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">transparència fotogràfica</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">transparents photographiques</skos:prefLabel>
    <skos:prefLabel xml:lang="en">photographic transparencies</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lucidi fotografiche</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30810">
    <skos:altLabel xml:lang="de">Karee</skos:altLabel>
    <skos:prefLabel xml:lang="ca">places</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">площад</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Platz</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">square</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">námestie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">plac</skos:prefLabel>
    <skos:altLabel xml:lang="de">Plätze</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Plein</skos:prefLabel>
    <skos:prefLabel xml:lang="da">torve</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">aikštė</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Place</skos:prefLabel>
    <skos:prefLabel xml:lang="it">piazza</skos:prefLabel>
    <skos:prefLabel xml:lang="es">paisaje industrial</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11018">
    <skos:prefLabel xml:lang="de">Palladium-Abzüge</skos:prefLabel>
    <skos:prefLabel xml:lang="en">palladium prints</skos:prefLabel>
    <skos:prefLabel xml:lang="da">palladium prints</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="fr">palladiotype</skos:prefLabel>
    <skos:altLabel xml:lang="de">Palladium prints</skos:altLabel>
    <skos:prefLabel xml:lang="bg">паладиев отпечатък</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">palladiotipia, stampe al palladio</skos:prefLabel>
    <skos:prefLabel xml:lang="es">copias al paladio</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">paladžio atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">palladiumdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">paládiová tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki palladowe</skos:prefLabel>
    <skos:altLabel xml:lang="de">Palladium-Fotos</skos:altLabel>
    <skos:prefLabel xml:lang="ca">paper al pal·ladi</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30719">
    <skos:prefLabel xml:lang="sl">priemysel</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индустрия</skos:prefLabel>
    <skos:prefLabel xml:lang="da">industri</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="lt">industrija</skos:prefLabel>
    <skos:prefLabel xml:lang="es">industria</skos:prefLabel>
    <skos:prefLabel xml:lang="it">industria</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">industry</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industrie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Industrie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Industrie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Branche</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">przemysł</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">indústria</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30114">
    <skos:altLabel xml:lang="de">Schauspielhaus</skos:altLabel>
    <skos:prefLabel xml:lang="pl">teatr</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Theater</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Theater</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">teatras</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sprech-Bühne</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">teater</skos:prefLabel>
    <skos:prefLabel xml:lang="it">teatro</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">divadlo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">театър</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Théâtre</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">teatre</skos:prefLabel>
    <skos:prefLabel xml:lang="en">theatre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escultura al aire libre</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31232">
    <skos:prefLabel xml:lang="da">vogn</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wagen</skos:altLabel>
    <skos:prefLabel xml:lang="pl">samochód</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Auto</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Auto</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Voiture</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="lt">automobilis</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">automòbils</skos:prefLabel>
    <skos:prefLabel xml:lang="en">car</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">автомобил</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">auto</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">zeppelín</skos:prefLabel>
    <skos:altLabel xml:lang="de">PKW</skos:altLabel>
    <skos:prefLabel xml:lang="it">macchina</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30150">
    <skos:prefLabel xml:lang="es">exposición</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">personage à moité</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Halvfigur</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">polovičná postava</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="it">mezza figura</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">retrat de mig cos</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">полуфигура</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Half figure</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Pół postaci</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Halbfigur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Halve figuur</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Pusė figūros</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31246">
    <skos:prefLabel xml:lang="sl">stan</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tendes (Envelats)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">economía</skos:prefLabel>
    <skos:prefLabel xml:lang="en">tent</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Tent</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">palapinė</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tenda</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">namiot</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tente</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31215"/>
    <skos:prefLabel xml:lang="bg">палатка</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zelt</skos:prefLabel>
    <skos:prefLabel xml:lang="da">telte</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30506">
    <skos:altLabel xml:lang="de">Impfstoff</skos:altLabel>
    <skos:prefLabel xml:lang="pl">szczepionka</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vakcina</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vacunes</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vaccin</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vaccin</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ваксина</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30503"/>
    <skos:prefLabel xml:lang="en">vaccine</skos:prefLabel>
    <skos:prefLabel xml:lang="da">vaccine</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vakcína</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">vaccino</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vakzine</skos:altLabel>
    <skos:prefLabel xml:lang="es">vacunas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Impfmittel</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31407">
    <skos:prefLabel xml:lang="lt">žiūrovai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">diváci</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">espectadores</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tilskuere</skos:prefLabel>
    <skos:prefLabel xml:lang="it">spettatori</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Toeschouwers</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">widzowie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">зрител</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zuschauer</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Spectateurs</skos:prefLabel>
    <skos:prefLabel xml:lang="en">spectators</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="ca">públic</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30200">
    <skos:prefLabel xml:lang="bg">конфликти, война и мир</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">konflikt, voja a mier</skos:prefLabel>
    <skos:prefLabel xml:lang="da">konflikter</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">konflikty, wojna i pokój</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Conflits, guerre et paix</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">konfliktai, karas ir taika</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Konflikte</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="es">conflictos, guerra y paz</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">conflictes, guerra i pau</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">conflitti, guerra e pace</skos:prefLabel>
    <skos:altLabel xml:lang="de">Krieg und Frieden</skos:altLabel>
    <skos:prefLabel xml:lang="en">conflicts, war and peace</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Conflicten, oorlog en vrede</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30825">
    <skos:prefLabel xml:lang="lt">namas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Huis</skos:prefLabel>
    <skos:prefLabel xml:lang="en">house</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estación de tren</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Haus</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Maison</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">casa</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cases</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">къща</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">dom</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">dom</skos:prefLabel>
    <skos:prefLabel xml:lang="da">huse</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30104">
    <skos:prefLabel xml:lang="it">manufatti</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">expresionismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umelecké predmety</skos:prefLabel>
    <skos:prefLabel xml:lang="da">artefakter</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Artefakte</skos:prefLabel>
    <skos:prefLabel xml:lang="en">artefacts</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">objectes d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Artefacts</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="lt">dirbiniai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">артефакт</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Artefacten</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">artefakty</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30164">
    <skos:prefLabel xml:lang="es">coros</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mosaïque</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mozaika</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Mozaika</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Mozaika</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">mosaico</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mosaics</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mozaïek</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Mosaik</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мозайка</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Mosaic</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Mosaic</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30837">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30800"/>
    <skos:prefLabel xml:lang="en">Animals</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Tiere</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">животни</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zvieratá</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Gyvūnai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">animali</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">animales domésticos</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Zwierzęta</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dieren</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Animaux</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">animals</skos:prefLabel>
    <skos:prefLabel xml:lang="da">dyr</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30176">
    <skos:prefLabel xml:lang="lt">Pramonės dizainas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индустриален дизайн</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Design industriel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Industriedesign</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industieel design</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wzornictwo przemysłowe</skos:prefLabel>
    <skos:prefLabel xml:lang="it">design industriale</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">disseny industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Industrial design</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="sl">priemyselný dizajn</skos:prefLabel>
    <skos:altLabel xml:lang="de">Produktdesign</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">Industriel design</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30212">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Kriegsinfrastruktur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojnová infraštruktúra</skos:prefLabel>
    <skos:prefLabel xml:lang="es">infraestructura de guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">infraestructura de guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karo infastruktūra</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Infrastruktur des Krieges</skos:altLabel>
    <skos:prefLabel xml:lang="bg">военна инфраструктура</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wojenna infrastruktura</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Oorlogsinfrastructuur</skos:prefLabel>
    <skos:prefLabel xml:lang="da">krigsramte områder</skos:prefLabel>
    <skos:prefLabel xml:lang="en">war infrastructure</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Infrastructure de guerre</skos:prefLabel>
    <skos:prefLabel xml:lang="it">apparato bellico</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31018">
    <skos:altLabel xml:lang="de">Schützen</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">fusilero</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">стрелец</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tireur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">strelci, poľovníci</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fuseller</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="lt">šauliai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schutters</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">strzelcy</skos:prefLabel>
    <skos:altLabel xml:lang="de">Jäger</skos:altLabel>
    <skos:prefLabel xml:lang="en">riflemen</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skytter</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fuciliere</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Grenadiere</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31210">
    <skos:prefLabel xml:lang="nl">Elektriciteit</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">elektryczność</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">electricitat</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31208"/>
    <skos:prefLabel xml:lang="es">fotografía</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strom</skos:altLabel>
    <skos:prefLabel xml:lang="en">electricity</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">elektra</skos:prefLabel>
    <skos:prefLabel xml:lang="da">elektricitet</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">електричество</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">elektrina</skos:prefLabel>
    <skos:altLabel xml:lang="de">Elektrik</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Électricité</skos:prefLabel>
    <skos:prefLabel xml:lang="it">elettricità</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Elektrizität</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30226">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Kriegsgefangene</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kriegs-Gefangene</skos:altLabel>
    <skos:prefLabel xml:lang="es">refugio</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">presoners de guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="da">krigsfanger</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">jeniec wojenny</skos:prefLabel>
    <skos:prefLabel xml:lang="it">progioniero di guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karo belaisvis</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Prisonnier de guerre</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30224"/>
    <skos:prefLabel xml:lang="bg">пленник</skos:prefLabel>
    <skos:prefLabel xml:lang="en">prisoner of war</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">vojnoví zajatci</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Krijgsgevangenen</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30507">
    <skos:prefLabel xml:lang="lt">sveikatos priežiūros įstaiga</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">здравно заведение</skos:prefLabel>
    <skos:prefLabel xml:lang="it">struttura sanitaria</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Équipement de santé</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zdravotnícke zariadenia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gezondheidsfaciliteit</skos:prefLabel>
    <skos:prefLabel xml:lang="es">centros de salud</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">health facility</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sundhedsfaciliteter</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Sanitäre Einrichtungen</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">centres sanitaris</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30500"/>
    <skos:prefLabel xml:lang="pl">Placówka zdrowia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31220">
    <skos:prefLabel xml:lang="es">aviación</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ekonomika</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ekonomika</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ekonomika</skos:prefLabel>
    <skos:prefLabel xml:lang="en">economics</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Economie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Wirtschaftlichkeit</skos:altLabel>
    <skos:prefLabel xml:lang="da">økonomi</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Économie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">икономика</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:prefLabel xml:lang="ca">economia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">economia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ökonomie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Volkswirtschaft</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22007">
    <skos:prefLabel xml:lang="fr">Photographie de voyage</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">туристическа фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rejse fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia de viatges</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:altLabel xml:lang="de">Reise-Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="lt">kelionių fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia di viaggio</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Reisefotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">travel photography</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Reisfotografie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="sl">fotografia z ciest</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">fotografía de viajes</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia podróżnicza</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30113">
    <skos:prefLabel xml:lang="de">Vorstellung</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">predstavenie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">" przedstawienie przedstawienie / występ"</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">pasirodymas/ atlikimas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изпълнение</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">performance</skos:prefLabel>
    <skos:prefLabel xml:lang="it">performance</skos:prefLabel>
    <skos:prefLabel xml:lang="en">performance</skos:prefLabel>
    <skos:altLabel xml:lang="de">Auftritt</skos:altLabel>
    <skos:altLabel xml:lang="de">Aufführung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">performance (Art)</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Représentation</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Performance</skos:prefLabel>
    <skos:prefLabel xml:lang="es">figura de columna</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13003">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13000"/>
    <skos:prefLabel xml:lang="it">photo cards</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia na tekturce</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">historische Karten-Fotografie</skos:altLabel>
    <skos:prefLabel xml:lang="ca">postal en color</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fotografijos</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="sl">vizitka</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">carte photographique</skos:prefLabel>
    <skos:prefLabel xml:lang="en">card photographs</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tarjetas fotográficas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">fotografische kaart</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фотографии картички</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Card photograhs</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kort fotografier</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30186">
    <skos:altLabel xml:lang="de">Tänzerin</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">dansere</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tanečník</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">collages</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="de">Tänzer</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">танцьор</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">šokėjas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">tancerz</skos:prefLabel>
    <skos:prefLabel xml:lang="en">dancer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ballerino</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ballarins</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Danser</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Danseur</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11001">
    <skos:prefLabel xml:lang="lt">tiesioginiai pozityvai</skos:prefLabel>
    <skos:prefLabel xml:lang="da">direkte positiver</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">контактно копие</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">bezpośrednie pozytywy</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Positif direct</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">positiu directe de càmera</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="it">positivi diretti</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Direktpostive</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Direct positief</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">direct positives</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">priamy pozitív</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11000"/>
    <skos:altLabel xml:lang="de">Direkt-Positive</skos:altLabel>
    <skos:prefLabel xml:lang="es">positivos directos</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30196">
    <skos:prefLabel xml:lang="bg">религиозно изкуство</skos:prefLabel>
    <skos:prefLabel xml:lang="da">religiøs kunst</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">diseño de interiores</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art religieux</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">náboženské umenie</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Religieuze kunst</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Religinis menas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Sztuka religijna</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Religiöse Kunst</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="ca">art religiós</skos:prefLabel>
    <skos:prefLabel xml:lang="it">arte religiosa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Religious art</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31038">
    <skos:prefLabel xml:lang="sl">viktoriánske ovbdobie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Viktorianische Epoche</skos:altLabel>
    <skos:prefLabel xml:lang="it">periodo vittoriano</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Victoriaanse periode</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Viktorijos periodas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">victoriansk periode</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Викториански период</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">època victoriana</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Victorian period</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Victorian period</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Epoka wiktoriańska</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="es">periodo victoriano</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Période victorienne</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31200">
    <skos:prefLabel xml:lang="es">ciencia i tecnología</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ciència i tecnologia</skos:prefLabel>
    <skos:prefLabel xml:lang="en">science and technology</skos:prefLabel>
    <skos:prefLabel xml:lang="da">videnskab og teknologi</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">veda a technika</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mokslas ir technologijos</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scienza e tecnologia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="pl">nauka i technika</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wissenschaft und Technologie</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Wetenschap en technologie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">наука и технология</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Science et technologie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11011">
    <skos:prefLabel xml:lang="sl">albuminová tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki albuminowe</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Albumin Papier-Fotos</skos:altLabel>
    <skos:prefLabel xml:lang="da">æggehvidestof prints</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe all'albumina</skos:prefLabel>
    <skos:prefLabel xml:lang="es">impresiones en albúmina</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">albumino atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">албуминов отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="en">albumen prints</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">albuminedruk</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paper a l'albúmina</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve à l'albumine</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Albuminpapierabzüge</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31017">
    <skos:prefLabel xml:lang="es">veterano</skos:prefLabel>
    <skos:prefLabel xml:lang="it">veterano</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">veterans</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">veterán</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Veteran</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="nl">Veteraan</skos:prefLabel>
    <skos:prefLabel xml:lang="da">veteraner</skos:prefLabel>
    <skos:prefLabel xml:lang="en">veteran</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">veteranas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">weteran</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ветеран</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vétéran</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30836">
    <skos:prefLabel xml:lang="pl">plaża</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pláž</skos:prefLabel>
    <skos:prefLabel xml:lang="it">spiaggia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">strande</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">platges</skos:prefLabel>
    <skos:altLabel xml:lang="de">Flachküste</skos:altLabel>
    <skos:prefLabel xml:lang="en">beach</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">плаж</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Strand</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="de">Strand</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">paplūdimys</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">glaciar</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Plage</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strände</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30211">
    <skos:prefLabel xml:lang="es">guerra rusoturca, 1877-1878</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Rusų-turkų karas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Rusko-turecká vojna</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Wojna Rosyjsko-Turecka</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:altLabel xml:lang="de">Russisch-Türkischer Krieg</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Russisch-Türkische Krieg</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra russo-turca</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Russisch-Turkse oorlog</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Russo-tyrkisk krig</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre russo-turque</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Руско-турска война</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Russo-Turkish war</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">Guerra russoturca, 1877-1878</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/Technique">
    <skos:prefLabel xml:lang="en">Technique</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30225">
    <skos:prefLabel xml:lang="pl">obóz jeniecki</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fangelejre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">armas blancas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">camps de concentració</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30224"/>
    <skos:prefLabel xml:lang="en">prison camp</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Gevangenenkamp</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kalinių stovykla</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">väzenský tábor</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">затворнически лагер</skos:prefLabel>
    <skos:prefLabel xml:lang="it">campo di priogionia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Camp pénitencier</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gefangenenlager</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30508">
    <skos:prefLabel xml:lang="de">Krankenhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">болница</skos:prefLabel>
    <skos:prefLabel xml:lang="da">hospitaler</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">hospitals</skos:prefLabel>
    <skos:altLabel xml:lang="de">Klinik</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Ziekenhuis</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">szpital</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ligoninė</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Hôpital</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nemocnica</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hospital</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30507"/>
    <skos:prefLabel xml:lang="it">ospedale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">hospital</skos:prefLabel>
    <skos:prefLabel xml:lang="en">hospital</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30187">
    <skos:prefLabel xml:lang="en">explorer</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Explorateur</skos:prefLabel>
    <skos:altLabel xml:lang="de">Forscherin</skos:altLabel>
    <skos:prefLabel xml:lang="bg">изследовател</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ontdekkingsreiziger</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erforscher</skos:altLabel>
    <skos:prefLabel xml:lang="ca">exploradors</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tyrinėtojas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">labores de aguja</skos:prefLabel>
    <skos:prefLabel xml:lang="da">opdagelsesrejsende</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">odkrywca / badacz</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="sl">vynálezca</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">esploratore</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Forscher</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30112">
    <skos:prefLabel xml:lang="lt">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="da">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="it">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="en">opera</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">опера</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Opéra</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Opernhaus</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Opera</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">òpera</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Oper</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="es">estatua</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30177">
    <skos:prefLabel xml:lang="lt">Interjero dizainas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">architektura wnętrz</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">интериорен дизайн</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Design intérieur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Binnenhuisontwerp</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">interiérový dizajn</skos:prefLabel>
    <skos:prefLabel xml:lang="it">design d'interni</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Interior design</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">disseny d'interiors</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Interiør</skos:prefLabel>
    <skos:altLabel xml:lang="de">Raumgestaltung</skos:altLabel>
    <skos:prefLabel xml:lang="es">periodo eduardino</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Innenarchitektur</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13004">
    <skos:prefLabel xml:lang="lt">kabinetinės fotografijos</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kabinetfoto</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia cabinet</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kabinetka, kabinetná fotografia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Portrait-Fotografie</skos:altLabel>
    <skos:prefLabel xml:lang="fr">photo cabinet</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">студийни фотографии</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kabinet fotografier</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografías de gabinete</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Cabinet photographs</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13003"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="it">gabinetto</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">fotografia w formacie gabinetowym</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cabinet photographs</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22006">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="nl">Natuurfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia przyrodnicza</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie de nature</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">fotografia prírody</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">природна фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gamtos fotografija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">nature photography</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía de la naturaleza</skos:prefLabel>
    <skos:prefLabel xml:lang="da">naturfoto</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Naturfotografie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Natur-Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="it">fotografia naturalistica</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia de la natura</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11002">
    <skos:prefLabel xml:lang="nl">ambrotypie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ambro</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Ambrotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ambrotipos</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">ambrotypia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Direktpositiv -Verfahren</skos:altLabel>
    <skos:prefLabel xml:lang="it">ambrotipi</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11001"/>
    <skos:prefLabel xml:lang="da">ambrotyper</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ambrotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">ambrotypes</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">амбротипия</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="ca">ambrotip</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ambrotypien</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ambrotypy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30197">
    <skos:prefLabel xml:lang="pl">Martwa natura</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zatišie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Stillleben</skos:prefLabel>
    <skos:altLabel xml:lang="de">Still-Leben</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">Natiurmortas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Still life</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sílex</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Stilleven</skos:prefLabel>
    <skos:prefLabel xml:lang="da">stilleben</skos:prefLabel>
    <skos:prefLabel xml:lang="it">natura morta</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">natura morta</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">натюрморт</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Nature morte</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11012">
    <skos:prefLabel xml:lang="it">cristallotipi</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">crystolea</skos:prefLabel>
    <skos:prefLabel xml:lang="da">krystaltyper</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Crystalotypien</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">кристалотипия</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kristalotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">crystalotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">crystalotypie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11011"/>
    <skos:altLabel xml:lang="de">Positive Albuminfotos von Glas-Negativen</skos:altLabel>
    <skos:prefLabel xml:lang="es">cristalotipos</skos:prefLabel>
    <skos:prefLabel xml:lang="en">crystalotypes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cristal·lotip</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="sl">krystalotypia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30239">
    <skos:prefLabel xml:lang="nl">Circus (optreden)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">cyrk</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">circus (performance)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zirkusvorstellung</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цирк</skos:prefLabel>
    <skos:prefLabel xml:lang="es">circo (evento)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">cirkas (pasirodymas)</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">cirkus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">cirkus</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">circ</skos:prefLabel>
    <skos:prefLabel xml:lang="it">circo (spettacolo circense)</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="fr">cirque (performance)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31037">
    <skos:prefLabel xml:lang="lt">triukšmingi dvidešimtieji</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">feliços anys vint</skos:prefLabel>
    <skos:prefLabel xml:lang="it">anni ruggenti, anni Venti</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="es">años veinte</skos:prefLabel>
    <skos:altLabel xml:lang="fr">Roaring Twenties</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Années folles</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">die Goldenen Zwanziger Jahre</skos:altLabel>
    <skos:prefLabel xml:lang="bg">1920-те</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lata dwudzieste</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="de">roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="en">roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="da">brølende tyvere</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31222">
    <skos:prefLabel xml:lang="es">coche</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Geschiedenis</skos:prefLabel>
    <skos:prefLabel xml:lang="da">historie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">história</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Historie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">istorija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">història</skos:prefLabel>
    <skos:altLabel xml:lang="de">Geschichte</skos:altLabel>
    <skos:prefLabel xml:lang="en">history</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">история</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">historia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:prefLabel xml:lang="it">storia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Histoire</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30214">
    <skos:altLabel xml:lang="de">1939-1945</skos:altLabel>
    <skos:prefLabel xml:lang="de">Zweiter Weltkrieg</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Втора световна война</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">2. Weltkrieg</skos:altLabel>
    <skos:prefLabel xml:lang="pl">II wojna światowa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">WW II</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Antrasis pasaulinis karas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">2ème guerre mondiale</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Seconda guerra mondiale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Segunda Guerra Mundial</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Segona Guerra Mundial</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Druhá svetová vojna</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">WO II</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Anden verdenskrig</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30188">
    <skos:prefLabel xml:lang="ca">estil i temàtica artística</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rodzaje przedstawień</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausführung</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">стил в изкуството</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">niel</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umelecký štýl a subjekt</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunststijlen en onderwerp</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kunst-Stil und Subjekt</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kunstarter</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">meno stilius ir objektai</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="it">stile artistico e soggetto</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kunststil und Gegenstand</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Styles et sujets d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="en">art style and subject</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30174">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Mode-Design</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">módne návrhárstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">disseny de moda</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Mados dizainas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Modedesign</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">moda</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Design de mode</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Modeontwerp</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">моден дизайн</skos:prefLabel>
    <skos:prefLabel xml:lang="it">design di moda</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Fashion design</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30835">
    <skos:prefLabel xml:lang="lt">ledynas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="sl">ľadovec</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">ghiacciaio</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Glacier</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lodowiec</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gletsjere</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gletscher</skos:prefLabel>
    <skos:prefLabel xml:lang="en">glacier</skos:prefLabel>
    <skos:prefLabel xml:lang="es">volcanes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">glaceres</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gletsjer</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ледник</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30101">
    <skos:prefLabel xml:lang="it">arti e intrattenimento</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">menai ir pramogos</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">sztuka i rozrywka</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art et divertissement</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="es">artes i entretenimiento</skos:prefLabel>
    <skos:prefLabel xml:lang="en">arts and entertainment</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изкуство и развлечения</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umenie a zábava</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunsten en entertainment</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kunst und Unterhaltung</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arts i espectacles</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kunst og underholdning</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13005">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">tarjetas de visita</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Cartes-de-visite</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">carte de visite</skos:prefLabel>
    <skos:altLabel xml:lang="de">CDV's</skos:altLabel>
    <skos:prefLabel xml:lang="pl">fotografia w formacie wizytowym</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">photo-cartes de visite</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">lankytojo kortelės</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">cartes-de-visite</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="it">cartes-de-visite</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13003"/>
    <skos:prefLabel xml:lang="en">cartes-de-visite</skos:prefLabel>
    <skos:altLabel xml:lang="de">Papierfotografie</skos:altLabel>
    <skos:prefLabel xml:lang="da">visitkort</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">карт де визит</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vizitky</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice">
    <skos:prefLabel xml:lang="en">Photographic practice</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30224">
    <skos:prefLabel xml:lang="pl">więźniowie i zatrzymani</skos:prefLabel>
    <skos:prefLabel xml:lang="es">armas de fuego</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <skos:prefLabel xml:lang="it">prigionieri e detenuti</skos:prefLabel>
    <skos:altLabel xml:lang="de">Inhaftierte</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">fanger</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">затворници и задържани</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">väzni a zadržaní</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gefangene</skos:altLabel>
    <skos:prefLabel xml:lang="en">prisoners and detainees</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kaliniai ir sulaikytieji</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Prisonniers et détenus</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Häftlinge</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">presos</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gevangenen en arrestanten</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30111">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30273"/>
    <skos:prefLabel xml:lang="bg">музика</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Muziek</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">música</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hudba</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Musik</skos:prefLabel>
    <skos:prefLabel xml:lang="it">musica</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">muzika</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">music</skos:prefLabel>
    <skos:prefLabel xml:lang="es">figura</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Musique</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">muzyka</skos:prefLabel>
    <skos:prefLabel xml:lang="da">musik</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30509">
    <skos:prefLabel xml:lang="bg">медицинска професия</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Arztberuf</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">medicina</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zawód medyczny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">profesión médica / médico</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Medisch beroep</skos:prefLabel>
    <skos:prefLabel xml:lang="da">lægestanden</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">professione medica</skos:prefLabel>
    <skos:prefLabel xml:lang="en">medical profession</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">medikai</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30500"/>
    <skos:prefLabel xml:lang="fr">Profession médicale</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">lekárska profesia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22009">
    <skos:prefLabel xml:lang="it">fotografia aerea</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Luchtfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia aèria</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie aérienne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="bg">въздушна фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="en">aerial photography</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">fotografia lotnicza</skos:prefLabel>
    <skos:prefLabel xml:lang="da">luftfotos</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Luftbildfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">letecká fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía aérea</skos:prefLabel>
    <skos:altLabel xml:lang="de">Luftbild-Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="lt">regioninė fotografija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11013">
    <skos:prefLabel xml:lang="es">hialotipos</skos:prefLabel>
    <skos:altLabel xml:lang="de">Glasdruck</skos:altLabel>
    <skos:prefLabel xml:lang="ca">hyaol·lotip</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">hyalotypy</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="nl">hyalotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">hyalotypie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">hyalotyper</skos:prefLabel>
    <skos:prefLabel xml:lang="en">hyalotypes</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hyalotypien</skos:prefLabel>
    <skos:altLabel xml:lang="de">Positiv-Bilder auf Glasplatten</skos:altLabel>
    <skos:prefLabel xml:lang="bg">хаплотип</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">hilotipai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">hyalotipi</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11011"/>
    <skos:prefLabel xml:lang="sl">hyalotypia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30194">
    <skos:prefLabel xml:lang="da">jagtscener</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Hunting scene</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Medžioklės scena</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escena de caça</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ловна сцена</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Jachtscene</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">scena polowania</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scena di caccia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Scène de chasse</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diseño grafico</skos:prefLabel>
    <skos:altLabel xml:lang="de">Jagd-Szene</skos:altLabel>
    <skos:prefLabel xml:lang="de">Jagdszene</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="sl">lovecká scéna</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31202">
    <skos:prefLabel xml:lang="pl">astronomia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">astronomia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">astronomia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
    <skos:prefLabel xml:lang="sl">astronómia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Astronomie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">астрономия</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Astronomie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Astronomie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">astronomija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">astronomi</skos:prefLabel>
    <skos:prefLabel xml:lang="es">astronomía</skos:prefLabel>
    <skos:prefLabel xml:lang="en">astronomy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/26000">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="bg">художествена фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía artística</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia artística</skos:prefLabel>
    <skos:altLabel xml:lang="de">kunstvolle Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="da">kunstnerisk fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">meninė fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Artistieke fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">artistic photography</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia artistica</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">künstlerische Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia artystyczna</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umelecká fotografia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <skos:prefLabel xml:lang="fr">Photographie artistique</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30175">
    <skos:prefLabel xml:lang="da">Grafisk design</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Design graphique</skos:prefLabel>
    <skos:prefLabel xml:lang="it">grafica</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">grafický dizajn</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">графичен дизайн</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Grafinis dizainas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Grafikdesign</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">disseny gràfic</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Graphic design</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="es">Belle Époque</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">Grafika użytkowa</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Grafisch design</skos:prefLabel>
    <skos:altLabel xml:lang="de">grafische Gestaltung</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30100">
    <skos:prefLabel xml:lang="de">Kunst</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umenie, kultúra a zábava</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sztuka, kultura i rozrywka</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kultur und Unterhaltung</skos:altLabel>
    <skos:prefLabel xml:lang="da">kunst, kultur og underholdning</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Kunsten, cultuur en entertainment</skos:prefLabel>
    <skos:prefLabel xml:lang="en">arts, culture and entertainment</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art, culture et divertissement</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изкуство, култура и развлечения</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">arts, cultura i espectacles</skos:prefLabel>
    <skos:prefLabel xml:lang="it">arti, cultura e intrattenimento</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">menai, kultūra ir pramogos</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">arte, cultura i entretenimiento</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30213">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">WW I</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">WO I</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">Prima guerra mondiale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Primera Guerra Mundial</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Primera Guerra Mundial</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Първа световна война</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Pirmasis pasaulinis karas</skos:prefLabel>
    <skos:altLabel xml:lang="de">1914-1918</skos:altLabel>
    <skos:prefLabel xml:lang="de">Erster Weltkrieg</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">1er guerre mondiale</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Prvá svetová vojna</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Første verdenskrig</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">I wojna światowa</skos:prefLabel>
    <skos:altLabel xml:lang="de">1. Weltkrieg</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30834">
    <skos:prefLabel xml:lang="lt">vulkanas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">wulkan</skos:prefLabel>
    <skos:prefLabel xml:lang="en">volcano</skos:prefLabel>
    <skos:prefLabel xml:lang="da">vulkaner</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Vulkan</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Volcan</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fuentes</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="bg">вулкан</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">volcans</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sopka</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vulcano</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Vulkaan</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13006">
    <skos:prefLabel xml:lang="pl">fotografia w owalu</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13003"/>
    <skos:prefLabel xml:lang="lt">druskos atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">photo camée</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tlač kamejí?</skos:prefLabel>
    <skos:prefLabel xml:lang="da">cameo udskrifter</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cameo prints</skos:prefLabel>
    <skos:altLabel xml:lang="de">Miniatur-Fotografien</skos:altLabel>
    <skos:prefLabel xml:lang="de">Cameo prints</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">отпечатък върху медальон (камея)</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">còpia camafeu</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">cameefoto</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="es">impresión camafeo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cameotipo, stampe cameo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31019">
    <skos:prefLabel xml:lang="de">Feuerwehr</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="bg">пожарна команда</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Brandweer</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">ugniagesių komanda</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vigili del fuoco</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pompier</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fire brigade</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">bombers</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">straż pożarna</skos:prefLabel>
    <skos:altLabel xml:lang="de">Löschzug</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Feuerstoßtrupp</skos:altLabel>
    <skos:prefLabel xml:lang="es">bombero</skos:prefLabel>
    <skos:prefLabel xml:lang="da">brandvæsen</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hasičský zbor</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30110">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">museum</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">музей</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Museum</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Museum</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Musée</skos:prefLabel>
    <skos:prefLabel xml:lang="da">museer</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">muziejus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">busto</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">museus</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">muzeum</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">múzeum</skos:prefLabel>
    <skos:prefLabel xml:lang="it">museo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30189">
    <skos:prefLabel xml:lang="en">Nonrepresentational art</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">абстрактно изкуство</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Niet-beeldende kunst</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">sztuka nieprzedstawieniowa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art non figuratif</skos:prefLabel>
    <skos:prefLabel xml:lang="da">abstrakt kunst</skos:prefLabel>
    <skos:prefLabel xml:lang="es">esbozo</skos:prefLabel>
    <skos:altLabel xml:lang="de">nicht gegenständliche Kunst</skos:altLabel>
    <skos:prefLabel xml:lang="de">gegenstandslose Kunst</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">art abstracte</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="lt">Abstraktusis menas/ dailė</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">abstraktné umenie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">arte astratta</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30223">
    <skos:prefLabel xml:lang="sl">povojnové usporiadanie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">следвоенно възстановяване</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wiederaufbau nach dem Krieg</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbudowa powojenna</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pokario rekonstrukcija</skos:prefLabel>
    <skos:prefLabel xml:lang="en">post-war reconstruction</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Naoorlogse reconstructie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">reconstrucció de postguerra</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">efterkrigstid</skos:prefLabel>
    <skos:prefLabel xml:lang="es">armas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <skos:prefLabel xml:lang="it">ricostruzione post-bellica</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Reconstruction d'après-guerre</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31029">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Périodes historiques/politiques</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">исторически/политически периоди</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Historische/politieke periodes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">períodes històrics/polítics</skos:prefLabel>
    <skos:prefLabel xml:lang="en">historical/political periods</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31000"/>
    <skos:prefLabel xml:lang="da">historiske perioder</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">periodos históricos y políticos</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">istoriniai/politiniai laikotarpiai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">periodo storico/politico</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Historische geschichtliche Epoche / politischer Zeitraum</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">okres historyczny/polityczny</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">historické/politické obdobia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22008">
    <skos:prefLabel xml:lang="es">fotografía de guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie de guerre</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">fotografia di guerra</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojnová fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">krigs fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karo fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="en">war photography</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kriegs-Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Oorlogsfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kriegsfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia wojenna</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">военна фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia de guerra</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31221">
    <skos:prefLabel xml:lang="bg">география</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Geografie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">geografia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">geografia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">geografia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">geografia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">geografi</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Aardrijkskunde</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:altLabel xml:lang="de">Geographie</skos:altLabel>
    <skos:prefLabel xml:lang="lt">geografija</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Géographie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">geography</skos:prefLabel>
    <skos:prefLabel xml:lang="es">bicicleta</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11027">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">transparencia de gelatina de plata</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сребърно-желатинова плака</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sidabro druskų skaidrės</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11023"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="pl">folie żelatynowo-srebrowe</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">transparència de gelatina de plata</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lucidi alla gelatina d'argento</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">transparent gélatino-argentique</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">želatínové diapozitivy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Silbergelatine-Schablonen</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">gelatine-zilver transparant</skos:prefLabel>
    <skos:prefLabel xml:lang="en">gelatin silver transparencies</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gelatine sølv transparenter</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11000">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/10000"/>
    <skos:prefLabel xml:lang="it">positivo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Positiv</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pozitív</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">positiu</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">позитив</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pozytyw</skos:prefLabel>
    <skos:prefLabel xml:lang="da">positiv</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="es">positivos</skos:prefLabel>
    <skos:prefLabel xml:lang="en">positive</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pozityvas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Positif</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Positief</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31049">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">revolución</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Arbeidersbeweging</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">moviment obrer</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arbejderbevægelsen</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mouvement ouvrier</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ruch robotniczy</skos:prefLabel>
    <skos:prefLabel xml:lang="en">labor movement</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="de">Arbeiterbewegung</skos:prefLabel>
    <skos:prefLabel xml:lang="it">movimento dei lavoratori</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">работническо движение</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">darbo judėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">odborové hnutie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/20000">
    <skos:prefLabel xml:lang="es">tipos/ práctica fotográfica</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tipai/ fotografinė praktika</skos:prefLabel>
    <skos:prefLabel xml:lang="da">typer / fotografiske praksis</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tipi / procedimenti fotografici</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Types / fotografisch gebruik</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:altLabel xml:lang="de">Arten / fotografische Praxis</skos:altLabel>
    <skos:prefLabel xml:lang="de">Bereiche</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">druh /fotografická technika/prax</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">types / photographic practice</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Фотографски практики</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rodzaje /praktyka fotograficzna</skos:prefLabel>
    <skos:altLabel xml:lang="de">Methoden</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Types / Utilisation photographique</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tipus / pràctica fotogràfica</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31201">
    <skos:prefLabel xml:lang="fr">Sciences naturelles</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">nauki przyrodnicze</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ciències naturals</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31200"/>
    <skos:prefLabel xml:lang="lt">gamtos mokslai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prírodné vedy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Naturwissenschaften</skos:prefLabel>
    <skos:prefLabel xml:lang="da">naturvidenskab</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Natuurwetenschap</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">ciencias naturales</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scienze naturali</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">естествени науки</skos:prefLabel>
    <skos:prefLabel xml:lang="en">natural science</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30833">
    <skos:altLabel xml:lang="de">Anlass</skos:altLabel>
    <skos:prefLabel xml:lang="pl">źródło</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">извор</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ausgangspunkt</skos:altLabel>
    <skos:prefLabel xml:lang="es">canteras</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prameň</skos:prefLabel>
    <skos:prefLabel xml:lang="en">source</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="fr">Source</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Quelle</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sorgente</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kilder</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Bron</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fonts</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">šaltinis</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30720">
    <skos:prefLabel xml:lang="sl">obchod, remeslo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">comercio</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">търговия</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">comerç</skos:prefLabel>
    <skos:prefLabel xml:lang="en">trade</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gewerbe</skos:altLabel>
    <skos:altLabel xml:lang="de">Handwerk</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Commerce</skos:prefLabel>
    <skos:prefLabel xml:lang="it">commercio</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">handel</skos:prefLabel>
    <skos:prefLabel xml:lang="da">handel</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">prekyba</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Handel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Handel</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11014">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:altLabel xml:lang="de">Kollodium-Fotos</skos:altLabel>
    <skos:prefLabel xml:lang="en">collodion prints</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paper al col·lodió</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">kollodium prints</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">odbitki kolodionowe</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve au collodion</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">daglichtcollodiumzilverdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="es">copias colodón</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kollodium-Abzüge</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kollodium prints</skos:altLabel>
    <skos:prefLabel xml:lang="lt">kolodiniai antspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kolódiová tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="it">stampe al collodio</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">колодиев отпечатък</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30820">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">estructuras funerarias</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cascades</skos:prefLabel>
    <skos:prefLabel xml:lang="en">waterfall</skos:prefLabel>
    <skos:prefLabel xml:lang="da">vandfald</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">водопад</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">wodospad</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Waterval</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vodopád</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Cascade</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">krioklys</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wasserfall</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cascata</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wasserfälle</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31039">
    <skos:prefLabel xml:lang="en">political events</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Politieke gebeutenissen</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31000"/>
    <skos:prefLabel xml:lang="bg">политически събития</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esdeveniments polítics</skos:prefLabel>
    <skos:prefLabel xml:lang="es">asesinato</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Événements politiques</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wydarzenia polityczne</skos:prefLabel>
    <skos:prefLabel xml:lang="da">politiske begivenheder</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">politiniai įvykiai</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">politické udalosti</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Politische Ereignisse</skos:prefLabel>
    <skos:prefLabel xml:lang="it">eventi politici</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30195">
    <skos:prefLabel xml:lang="pl">Wzory</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diseño industrial</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Verhaltensmuster</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Patterns</skos:prefLabel>
    <skos:prefLabel xml:lang="da">mønstre</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">šablóny</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">шарка</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">estampació</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="fr">Motifs</skos:prefLabel>
    <skos:prefLabel xml:lang="it">modelli, motivi</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Patronen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Raštai</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31214">
    <skos:prefLabel xml:lang="bg">обществени науки</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sozialwissenschaften</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Menswetenschappen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">socialiniai mokslai</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Sozialwissenschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="en">social science</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sciences humaines</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">antropología</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sociálne vedy</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sienze sociali</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ciències socials</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31200"/>
    <skos:prefLabel xml:lang="pl">nauki społeczne</skos:prefLabel>
    <skos:prefLabel xml:lang="da">samfundsvidenskab</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30182">
    <skos:prefLabel xml:lang="pl">wyroby szklane</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Glaswerk</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Verrerie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Stiklo gaminiai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Glasware</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">surrealismo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cristalleria</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cristalleria</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Glassware</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="sl">sklenené predmety</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изделие от стъкло</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Glas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Glas-Ware</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31010">
    <skos:prefLabel xml:lang="ca">reis</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Roi</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Koning</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">крал</skos:prefLabel>
    <skos:prefLabel xml:lang="en">king</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">król</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31008"/>
    <skos:prefLabel xml:lang="sl">kráľ</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karalius</skos:prefLabel>
    <skos:prefLabel xml:lang="da">konger</skos:prefLabel>
    <skos:prefLabel xml:lang="es">rey</skos:prefLabel>
    <skos:prefLabel xml:lang="it">re</skos:prefLabel>
    <skos:prefLabel xml:lang="de">König</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31028">
    <skos:prefLabel xml:lang="nl">Regionale overheid</skos:prefLabel>
    <skos:prefLabel xml:lang="en">regional government</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Landesbehörde</skos:altLabel>
    <skos:prefLabel xml:lang="it">governo regionale</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="fr">Gouvernement régional</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">regioninė valdžia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Regional-Regierung</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landesverwaltung</skos:altLabel>
    <skos:prefLabel xml:lang="da">kommunalpolitik</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Samorząd regionu</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">regionálna vláda</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">регионално правителство</skos:prefLabel>
    <skos:prefLabel xml:lang="es">gobierno regional</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">govern regional</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22003">
    <skos:prefLabel xml:lang="fr">Reproduction d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">художествена репродукция</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:prefLabel xml:lang="de">Kunst-Reproduktion</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunstreproductie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">reprodukcja artystyczna</skos:prefLabel>
    <skos:prefLabel xml:lang="es">reproducción de arte</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">umelecká reprodukcia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">reproducció d'art</skos:prefLabel>
    <skos:altLabel xml:lang="de">Nachdruck</skos:altLabel>
    <skos:prefLabel xml:lang="en">art reproduction</skos:prefLabel>
    <skos:prefLabel xml:lang="it">riproduzione d'arte</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">meno reprodukcija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">kunst reproduktion</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31000">
    <skos:prefLabel xml:lang="de">Politik</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Politiek</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Politique</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">políticos</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="it">politica</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">politika</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">politika</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">политика</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">polityka</skos:prefLabel>
    <skos:prefLabel xml:lang="da">politik</skos:prefLabel>
    <skos:prefLabel xml:lang="en">politics</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">política</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13007">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">diapositivas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dia-Positive</skos:prefLabel>
    <skos:prefLabel xml:lang="en">lantern slides</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">laterna magica</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">diapositiva de llanterna màgica</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="da">lysbilleder</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žibintinės skaidrės</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13000"/>
    <skos:prefLabel xml:lang="bg">диапозитиви за диапроектор</skos:prefLabel>
    <skos:prefLabel xml:lang="it">diapositive per lanterne magiche</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przeźrocza do latarni magicznej</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">plaque de lanterne magique</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">lantaarnplaatje</skos:prefLabel>
    <skos:altLabel xml:lang="de">Diapositive</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31014">
    <skos:prefLabel xml:lang="de">Luftwaffe</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Forces aériennes</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">oro pajėgos</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">letectvo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fuerzas aéreas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">военновъздушни сили</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Luchtmacht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">forces aèries</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="pl">wojska lotnicze</skos:prefLabel>
    <skos:prefLabel xml:lang="da">flyvevåben</skos:prefLabel>
    <skos:prefLabel xml:lang="it">aeronautica</skos:prefLabel>
    <skos:prefLabel xml:lang="en">air force</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30172">
    <skos:altLabel xml:lang="de">Altartafel</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Altarbild</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Retable</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Altertavler</skos:prefLabel>
    <skos:prefLabel xml:lang="it">pala d'altare</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">art deco</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Altoriaus paveikslas/statula</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">retabulum</skos:prefLabel>
    <skos:altLabel xml:lang="de">Altargemälde</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="nl">Altaarstuk</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Altarpiece</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">олтар</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">retaules</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ołtarz</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30216">
    <skos:prefLabel xml:lang="it">manifestazione</skos:prefLabel>
    <skos:prefLabel xml:lang="da">demonstrationer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">demonstracja</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="nl">Demonstratie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">rebelión</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Demonstration</skos:prefLabel>
    <skos:prefLabel xml:lang="en">demonstration</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">демонстрация</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Démonstration</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">demonštrácia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">demonstracija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">manifestacions</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31224">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Technologie et ingénierie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">technologija ir technika</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">technológia a strojníctvo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31200"/>
    <skos:altLabel xml:lang="de">Ingenieurswissenschaft</skos:altLabel>
    <skos:prefLabel xml:lang="ca">tecnologia i enginyeria</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">технология и инженерство</skos:prefLabel>
    <skos:prefLabel xml:lang="da">teknologi og teknik</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tecnologia e ingegneria</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Technologia i inżynieria</skos:prefLabel>
    <skos:prefLabel xml:lang="en">technology and engineering</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Technologie en Ingenieurswetenschap</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Technologie und Engineering</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">metro</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30236">
    <skos:prefLabel xml:lang="sl">scénografia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">сценография</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="lt">scenografija</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">scenografia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scenografia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Szenen-Bild</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Décor</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Set design</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Set design</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escenografia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Setontwerp</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bühnenbild</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escenografía</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bühnenausstattung</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30183">
    <skos:prefLabel xml:lang="fr">Dinanderie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="en">Metalwork</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kovové výrobky</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Metalo dirbinys</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">metal·listeria</skos:prefLabel>
    <skos:prefLabel xml:lang="it">oggetti metallici</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Metaalwerk</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">wyroby z metalu</skos:prefLabel>
    <skos:prefLabel xml:lang="es">periodo victoriano</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">изделие от метал</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Metalarbejder</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Metall-Arbeit</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31213">
    <skos:prefLabel xml:lang="da">medicinsk forskning</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Recherche médicale</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">medicininis tyrimas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">медицинско изследване</skos:prefLabel>
    <skos:prefLabel xml:lang="en">medical research</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">badania medyczne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">lekársky výskum</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ciencias sociales</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">medicina-Investigació</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Medisch onderzoek</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ricerca medica</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31207"/>
    <skos:prefLabel xml:lang="de">Medizinische Wissenschaft</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31027">
    <skos:prefLabel xml:lang="en">politician</skos:prefLabel>
    <skos:prefLabel xml:lang="da">politikere</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="sl">politika</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">polítics</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">politikai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Politikerin</skos:altLabel>
    <skos:prefLabel xml:lang="it">uomo politico</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Politicien</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">político</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">polityk</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">политик</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Politiker</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Politicus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/Subject">
    <skos:prefLabel xml:lang="en">Subject</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13008">
    <skos:prefLabel xml:lang="sl">diapozitívy</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diapositivas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">diapositive</skos:prefLabel>
    <skos:prefLabel xml:lang="it">diapositive</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">diapositiva</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przeźrocza</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dias</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">диапозитив</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13000"/>
    <skos:prefLabel xml:lang="da">dias</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="en">slides</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22002">
    <skos:prefLabel xml:lang="de">Landschaftsfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia krajobrazowa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">peizažinė fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia del paeasaggio</skos:prefLabel>
    <skos:prefLabel xml:lang="da">landskabsbilleder</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Landschapsfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie de paysage</skos:prefLabel>
    <skos:prefLabel xml:lang="en">landscape photography</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landschafts-Photographie</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:prefLabel xml:lang="bg">пейзажна фотография</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="sl">fotografia krajiny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía del paisaje</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia de paisatges</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30173">
    <skos:prefLabel xml:lang="es">Art Nouveau / Jugendstil</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">дизайн на облекло</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Tøjdesign</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kostümdesign</skos:altLabel>
    <skos:prefLabel xml:lang="de">Kostümausstattung</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">disseny de vestuari</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Design de costumes</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Kostiumų dizainas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="nl">Kostuumontwerp</skos:prefLabel>
    <skos:prefLabel xml:lang="it">design di costumi</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Costume design</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kostýmové návrhárstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Kostiumy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31013">
    <skos:prefLabel xml:lang="es">aplicación de la ley</skos:prefLabel>
    <skos:prefLabel xml:lang="it">applicazione della legge</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Rechtsvorschrift</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strafverfolgung</skos:altLabel>
    <skos:prefLabel xml:lang="da">retshåndhævelse</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Services de police</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">правоприлагане</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="sl">uplatnenie zákona</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">teisėsauga</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ordehandhaving</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">egzekwowanie prawa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">law enforcement</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">lleis - aplicació</skos:prefLabel>
    <skos:altLabel xml:lang="de">Repression</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31223">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31214"/>
    <skos:prefLabel xml:lang="nl">Sociologie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sociologie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sociologija</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Soziologie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">социология</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">sociologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sociologia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">socjologia</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sociológia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">máquina</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gesellschaftswissenschaft</skos:altLabel>
    <skos:prefLabel xml:lang="en">sociology</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sociologi</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30215">
    <skos:prefLabel xml:lang="es">rallys</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Aufruhr</skos:prefLabel>
    <skos:prefLabel xml:lang="da">uroligheder</skos:prefLabel>
    <skos:prefLabel xml:lang="en">civil unrest</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гражданско вълнение</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Agitation civile</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">fermenti sociali</skos:prefLabel>
    <skos:altLabel xml:lang="de">höhere Gewalt</skos:altLabel>
    <skos:prefLabel xml:lang="lt">pilietinis neramumas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30200"/>
    <skos:prefLabel xml:lang="nl">Burgerlijke onrust</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">agitació civil</skos:prefLabel>
    <skos:altLabel xml:lang="de">innere Unruhen</skos:altLabel>
    <skos:prefLabel xml:lang="sl">občianske nepokoje</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">niepokoje społeczne</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30235">
    <skos:prefLabel xml:lang="nl">Theater (gebouw)</skos:prefLabel>
    <skos:prefLabel xml:lang="it">teatro (edificio)</skos:prefLabel>
    <skos:prefLabel xml:lang="es">teatro (edificio)</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">budynek teatralny</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Theatre building</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="da">Teater bygning</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">teatre (edifici)</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Théâtre (bâtiment)</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">театрална сграда</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">teatras (pastatas)</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">divadelná budova</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Festspielhaus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30249">
    <skos:prefLabel xml:lang="pl">malarz</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schilder</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="en">painter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">maler</skos:prefLabel>
    <skos:prefLabel xml:lang="it">pittore</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Maler</skos:prefLabel>
    <skos:altLabel xml:lang="de">Malerin</skos:altLabel>
    <skos:prefLabel xml:lang="lt">tapytojas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">maliar</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">художник</skos:prefLabel>
    <skos:prefLabel xml:lang="es">pintor (artista)</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">pintor (artista)</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">peintre</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31012">
    <skos:prefLabel xml:lang="de">Königliche Person</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Abgabe</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Koninklijke familie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">władza królewska</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">reis i sobirans</skos:prefLabel>
    <skos:prefLabel xml:lang="en">royalty</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">кралска особа</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">príslušníci kráľovskej rodiny, kráľovská ríša, kráľovská moc</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Lizenz</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Famille royale</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kongelige</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31008"/>
    <skos:prefLabel xml:lang="it">famglia reale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">realeza</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karališkosios šeimos nariai</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30184">
    <skos:prefLabel xml:lang="pl">Tkanina</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cultura</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">teixits</skos:prefLabel>
    <skos:altLabel xml:lang="de">Textilien</skos:altLabel>
    <skos:prefLabel xml:lang="bg">текстил</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Textile</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Textile</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tessile</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Textiel</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:altLabel xml:lang="de">Textil</skos:altLabel>
    <skos:prefLabel xml:lang="lt">Tekstilė</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Tekstiler</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gewebe</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">textílie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22005">
    <skos:prefLabel xml:lang="lt">karinė fotografija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:prefLabel xml:lang="de">Militär-Fotografie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="bg">военна фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia militar</skos:prefLabel>
    <skos:prefLabel xml:lang="en">military photography</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia wojskowa</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia militare</skos:prefLabel>
    <skos:altLabel xml:lang="de">Militär-Photographie</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Militaire fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie militaire</skos:prefLabel>
    <skos:prefLabel xml:lang="da">militær fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vojenská fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía militar</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/24000">
    <skos:prefLabel xml:lang="da">professionel fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">професионална фотография</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Berufsfotografie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Professionelle Fotografie</skos:altLabel>
    <skos:prefLabel xml:lang="en">professional photography</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">profesionálna fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie professionnelle</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotogradia professionale</skos:prefLabel>
    <skos:altLabel xml:lang="de">Profi-Fotografie</skos:altLabel>
    <skos:prefLabel xml:lang="es">fotografía profesional</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia profesjonalna</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">profesonali fotografija</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="nl">Professionele fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia professional</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31212">
    <skos:prefLabel xml:lang="bg">проучване</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">exploracions científiques</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">eksploracja/ wyprawy badawcze</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Ontdekkingsreizen</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erkundung</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31207"/>
    <skos:prefLabel xml:lang="sl">výskum</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Exploration</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Exploration</skos:prefLabel>
    <skos:prefLabel xml:lang="es">investigación científica</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tyrinėjimas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erforschung</skos:altLabel>
    <skos:prefLabel xml:lang="en">exploration</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">udforskning</skos:prefLabel>
    <skos:prefLabel xml:lang="it">esplorazione</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31026">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="ca">partits polítics</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Politieke partij</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Politische Partei</skos:prefLabel>
    <skos:prefLabel xml:lang="it">partito politico</skos:prefLabel>
    <skos:prefLabel xml:lang="es">partido político</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">politinė partija</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Parti politique</skos:prefLabel>
    <skos:prefLabel xml:lang="en">political party</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">partia polityczna</skos:prefLabel>
    <skos:prefLabel xml:lang="da">politisk partier</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">politická strana</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">политическа партия</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30711">
    <skos:prefLabel xml:lang="fr">Tailleur</skos:prefLabel>
    <skos:altLabel xml:lang="de">Herrenschneider</skos:altLabel>
    <skos:prefLabel xml:lang="it">sarto</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">siuvėjas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">marinero</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">krawiec</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">krajčír</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kleermaker</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">skræddere</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sastres</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schneider</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">шивач</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schneiderin</skos:altLabel>
    <skos:prefLabel xml:lang="en">tailor</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30228">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30227"/>
    <skos:prefLabel xml:lang="lt">Šaunamieji ginklai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Firearms</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Waffen</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vuurwapens</skos:prefLabel>
    <skos:prefLabel xml:lang="es">manifestación</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">strelné zbrane</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">broń palna</skos:prefLabel>
    <skos:prefLabel xml:lang="it">armi da fuoco</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Armes à feu</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">огнестрелно оръжие</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skydevåben</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">armes de foc</skos:prefLabel>
    <skos:altLabel xml:lang="de">Feuerwaffen</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30170">
    <skos:altLabel xml:lang="de">Entwurf</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">escritor</skos:prefLabel>
    <skos:prefLabel xml:lang="it">schizzo</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Skitser</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schets</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Eskizas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Sketch</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">скица</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Esquisse</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Szkic</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">náčrt</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Skizze</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="ca">esbós</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31016">
    <skos:prefLabel xml:lang="nl">Politie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">полиция</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Police</skos:prefLabel>
    <skos:prefLabel xml:lang="da">politi</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">policies</skos:prefLabel>
    <skos:prefLabel xml:lang="en">police</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">policía</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">policja</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Polizei</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">polícia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">polizia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">policija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30839">
    <skos:prefLabel xml:lang="sl">divá zver</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">диви животни</skos:prefLabel>
    <skos:prefLabel xml:lang="es">animales salvajes</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Wild animals</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Wilde dieren</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Animaux sauvages</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Laukiniai gyvūnai</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30837"/>
    <skos:prefLabel xml:lang="ca">animals salvatges</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wildtiere</skos:prefLabel>
    <skos:prefLabel xml:lang="it">animali selvatici</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Zwierzęta dzikie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">vilde dyr</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31239">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="lt">tramvajus</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">električka</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strassenbahn</skos:altLabel>
    <skos:prefLabel xml:lang="ca">tramvies</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tram</skos:prefLabel>
    <skos:prefLabel xml:lang="en">tram</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fortificación</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sporvogne</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">tramwaj</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Tram</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tram</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Tram</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">трамвай</skos:prefLabel>
    <skos:altLabel xml:lang="de">Straßenbahn</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13009">
    <skos:prefLabel xml:lang="en">black-and-white slides</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">baltai juodos skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diapositivas en blanco y negro</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schwarz-weiß-Dias</skos:prefLabel>
    <skos:prefLabel xml:lang="it">diapositive in bianco e nero</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13008"/>
    <skos:prefLabel xml:lang="da">sort-hvide lysbilleder</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="pl">przeźrocza czarno-białe</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">diapositiva blanc i negre</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">diapositive en noir et blanc</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">zwartwitdia</skos:prefLabel>
    <skos:altLabel xml:lang="de">schwarz-weiss Dias</skos:altLabel>
    <skos:prefLabel xml:lang="sl">čiernobiele diapozitívy</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">черно-бели диапозитиви</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30238">
    <skos:prefLabel xml:lang="pl">wystawienie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="ca">Muntage</skos:prefLabel>
    <skos:prefLabel xml:lang="it">allestimento teatrale</skos:prefLabel>
    <skos:prefLabel xml:lang="es">montaje</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Inszenierung</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">inscenizacija</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mise en scène</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">постановка</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mise-en-scène</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Staging</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Staging</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">inscenácia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30400">
    <skos:prefLabel xml:lang="lt">švietimas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vzdelávanie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">education</skos:prefLabel>
    <skos:prefLabel xml:lang="it">educazione</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ausbildung</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">образование</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bildung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">educació</skos:prefLabel>
    <skos:prefLabel xml:lang="da">uddannelse</skos:prefLabel>
    <skos:altLabel xml:lang="de">Erziehung</skos:altLabel>
    <skos:prefLabel xml:lang="pl">edukacja / wykształcenie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">educación</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Éducation</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Onderwijs</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30219">
    <skos:prefLabel xml:lang="fr">Rébellion</skos:prefLabel>
    <skos:altLabel xml:lang="de">Aufruhr</skos:altLabel>
    <skos:prefLabel xml:lang="lt">sukilimas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Rebellion</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="da">oprør</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">insurgència</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ribellione</skos:prefLabel>
    <skos:prefLabel xml:lang="es">proceso de paz</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">bunt /  rebelia / rokosz</skos:prefLabel>
    <skos:altLabel xml:lang="de">Aufstand</skos:altLabel>
    <skos:prefLabel xml:lang="bg">бунт</skos:prefLabel>
    <skos:prefLabel xml:lang="en">rebellion</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Rebellie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">rebélia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30198">
    <skos:prefLabel xml:lang="lt">Istorinė tapyba</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Historisch tafereel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Historische Malerei</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">историческа живопис</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">historická maľba</skos:prefLabel>
    <skos:prefLabel xml:lang="da">historiske malerier</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">monedas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">History painting</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">història de la pintura</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Historia malarstwa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tableau historique</skos:prefLabel>
    <skos:prefLabel xml:lang="it">dipinto storico</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30259">
    <skos:prefLabel xml:lang="sl">futurizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="it">futurismo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">futurismo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="en">futurism</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">futuryzm</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Futurisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Futurisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Futurisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Futurismen</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Futurismus</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">футуризъм</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">futurizmas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30229">
    <skos:prefLabel xml:lang="da">skarpe våben</skos:prefLabel>
    <skos:prefLabel xml:lang="de">scharfe Waffen</skos:prefLabel>
    <skos:altLabel xml:lang="de">Blank-Waffen</skos:altLabel>
    <skos:prefLabel xml:lang="ca">armes blanques</skos:prefLabel>
    <skos:prefLabel xml:lang="en">edged weapons</skos:prefLabel>
    <skos:prefLabel xml:lang="it">arma da taglio</skos:prefLabel>
    <skos:prefLabel xml:lang="es">revolución polaca</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30227"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Blanke wapens</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pjaunamieji ginklai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">хладно оръжие</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">broń biała</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Armes blanches</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">bodné zbrane</skos:prefLabel>
    <skos:altLabel xml:lang="de">Klingen-Waffen</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30248">
    <skos:prefLabel xml:lang="de">Sänger</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cantants</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cantante</skos:prefLabel>
    <skos:prefLabel xml:lang="en">singer</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">dainininkas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Chanteur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Zanger</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">piosenkarz</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="ca">cantantes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">spevák</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">певец</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sanger</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sängerin</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/22004">
    <skos:altLabel xml:lang="de">industrielle Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="de">Industrie-Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Photographie industrielle</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/22000"/>
    <skos:prefLabel xml:lang="lt">pramonės fotografija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">fotografía industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia industriale</skos:prefLabel>
    <skos:prefLabel xml:lang="en">industrial photography</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industriële fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">industriel fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">priemyselná fotografia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="pl">fotografia przemysłowa</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индустриална фотография</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30185">
    <skos:prefLabel xml:lang="es">costumbres y tradiciones</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schmuck</skos:altLabel>
    <skos:prefLabel xml:lang="ca">joieria</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Juvelyriniai dirbiniai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Biżuteria</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Smykker</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Joaillerie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">šperky</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">gioielleria</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Juwelen</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бижутерия</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Juwelen</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="en">Jewellery</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31011">
    <skos:prefLabel xml:lang="lt">monarchas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31008"/>
    <skos:prefLabel xml:lang="it">monarca</skos:prefLabel>
    <skos:altLabel xml:lang="de">Herrscherin</skos:altLabel>
    <skos:prefLabel xml:lang="bg">монарх</skos:prefLabel>
    <skos:prefLabel xml:lang="es">monarquía</skos:prefLabel>
    <skos:altLabel xml:lang="de">Herrscher</skos:altLabel>
    <skos:prefLabel xml:lang="en">monarch</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Souverain</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Monarch</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Monarch</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">monarcha</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">monarcha</skos:prefLabel>
    <skos:prefLabel xml:lang="da">monarker</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">monarques</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31025">
    <skos:prefLabel xml:lang="bg">парламент</skos:prefLabel>
    <skos:prefLabel xml:lang="es">parlamento</skos:prefLabel>
    <skos:prefLabel xml:lang="da">parlamenter</skos:prefLabel>
    <skos:prefLabel xml:lang="it">parlamento</skos:prefLabel>
    <skos:altLabel xml:lang="de">Volksvertretung</skos:altLabel>
    <skos:prefLabel xml:lang="de">Parlament</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="nl">Parlement</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Parlement</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">parlament</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">parlament</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">parlament</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">parlamentas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">parliament</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30227">
    <skos:prefLabel xml:lang="da">våben</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zbrane</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30202"/>
    <skos:prefLabel xml:lang="ca">armes</skos:prefLabel>
    <skos:prefLabel xml:lang="en">weapons</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Wapens</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">оръжие</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">agitación civil</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Waffen</skos:prefLabel>
    <skos:prefLabel xml:lang="it">armi</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">broń</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">ginklai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Armes</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30710">
    <skos:prefLabel xml:lang="sl">príležitostní robotníci</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gastarbeiter</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pracownicy emigracyjni</skos:prefLabel>
    <skos:prefLabel xml:lang="es">emigrantes</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Arbeidsmigranten</skos:prefLabel>
    <skos:prefLabel xml:lang="en">migrant workers</skos:prefLabel>
    <skos:prefLabel xml:lang="da">daglejere</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">treballadors migratoris</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Wanderarbeiter</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="bg">сезонен работник</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gastarbeiterin</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">migrantai darbininkai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">lavoratori immigrati</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ouvrier étranger</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31211">
    <skos:prefLabel xml:lang="fr">Photographie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fotografija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31208"/>
    <skos:prefLabel xml:lang="sl">fotografia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="pl">fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">exploración</skos:prefLabel>
    <skos:prefLabel xml:lang="en">photography</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fotografering</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30217">
    <skos:prefLabel xml:lang="bg">Януарско въстание</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Sausio sukilimas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">January uprising</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Januariopstand</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">powstanie styczniowe</skos:prefLabel>
    <skos:altLabel xml:lang="de">1863-1864</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
    <skos:prefLabel xml:lang="da">Januar opstanden</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">Polònia--Història--1863-1864, Revolució</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Insurrection de janvier</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rivolta di gennaio</skos:prefLabel>
    <skos:prefLabel xml:lang="es">revolución</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Januárové povstanie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Januaraufstand</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30838">
    <skos:prefLabel xml:lang="lt">Naminis gyvūnas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">animales domésticos</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Zwierzęta domowe</skos:prefLabel>
    <skos:prefLabel xml:lang="da">husdyr</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">animals domèstics</skos:prefLabel>
    <skos:prefLabel xml:lang="it">animali domestici</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gedomesticeerde dieren</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Haustier</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">домашни животни</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30837"/>
    <skos:prefLabel xml:lang="sl">domáce zvieratá</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Domestic animal</skos:prefLabel>
    <skos:altLabel xml:lang="de">Heimtier</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Animaux domestiques</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30171">
    <skos:prefLabel xml:lang="de">Studie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">studio</skos:prefLabel>
    <skos:prefLabel xml:lang="es">periodos culturales</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">скица</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Study</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Studija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">art-estudis</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Studier</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Studium</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">štúdia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Étude</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Studie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31015">
    <skos:prefLabel xml:lang="lt">armija</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">armia</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Armée</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="en">army</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">armáda</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Armee</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">exèrcits</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">армия</skos:prefLabel>
    <skos:prefLabel xml:lang="es">armada</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">hær</skos:prefLabel>
    <skos:altLabel xml:lang="de">Militär</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Leger</skos:prefLabel>
    <skos:prefLabel xml:lang="it">esercito</skos:prefLabel>
    <skos:altLabel xml:lang="de">Heer</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30237">
    <skos:prefLabel xml:lang="ca">Estrena</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">premiera</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Opening / Premiere</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">премиера</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="nl">Opening/première</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Premiere</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">premiéra</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estreno</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">atidarymas/ premjera</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">prima</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Åbning / Premiere</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Première</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/11010">
    <skos:altLabel xml:lang="de">Farbfotos</skos:altLabel>
    <skos:prefLabel xml:lang="de">Farbabzüge</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">stampe a colori</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">farebná tlač</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">épreuve en couleur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kleurenafdruk</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цветен отпечатък</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">còpia color</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/11007"/>
    <skos:prefLabel xml:lang="lt">spalvoti atspaudai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">color prints</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="pl">wydruki kolorowe</skos:prefLabel>
    <skos:prefLabel xml:lang="da">farveudskrifter</skos:prefLabel>
    <skos:prefLabel xml:lang="es">copias a color</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30218">
    <skos:prefLabel xml:lang="pl">rajd / wiec / zlot</skos:prefLabel>
    <skos:altLabel xml:lang="de">Rallye</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">manifestácia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Rally</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mitingas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">comizio, adunata</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Manifestatie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">folkemøder</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">insurgencia</skos:prefLabel>
    <skos:altLabel xml:lang="de">Rennen</skos:altLabel>
    <skos:prefLabel xml:lang="bg">митинг</skos:prefLabel>
    <skos:prefLabel xml:lang="en">rally</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ral·lis d'automòbils</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Manifestation</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30215"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30199">
    <skos:prefLabel xml:lang="fr">Mythologie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">mytologi</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Mythologie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Welt der Sagen</skos:altLabel>
    <skos:altLabel xml:lang="de">Sagenwelt</skos:altLabel>
    <skos:prefLabel xml:lang="sl">mytológia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">mosaico</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30188"/>
    <skos:prefLabel xml:lang="en">Mythology</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">митология</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Mitologia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Mitologija</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mythologie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mitologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">mitologia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30247">
    <skos:prefLabel xml:lang="bg">сценограф</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">scenograf</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Sæt designer</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Setontwerper</skos:prefLabel>
    <skos:altLabel xml:lang="de">Filmausstatter</skos:altLabel>
    <skos:prefLabel xml:lang="de">Bühnenausstatter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Set designer</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="es">escenógrafo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escenògraf</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scenografo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Décorateur</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">scenografas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">scénograf/ka</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31041">
    <skos:prefLabel xml:lang="nl">Moord</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vražda</skos:prefLabel>
    <skos:prefLabel xml:lang="es">coronación</skos:prefLabel>
    <skos:prefLabel xml:lang="da">snigmord</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="fr">Meurtre</skos:prefLabel>
    <skos:altLabel xml:lang="de">Attentat</skos:altLabel>
    <skos:prefLabel xml:lang="de">Ermordung</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">assassinat</skos:prefLabel>
    <skos:prefLabel xml:lang="it">assassinio</skos:prefLabel>
    <skos:altLabel xml:lang="de">Mordanschlag</skos:altLabel>
    <skos:prefLabel xml:lang="bg">убийство</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zamach</skos:prefLabel>
    <skos:prefLabel xml:lang="en">assassination</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">nužudymas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30600">
    <skos:prefLabel xml:lang="bg">човешки интерес</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">všeobecný záujem</skos:prefLabel>
    <skos:prefLabel xml:lang="en">human interest</skos:prefLabel>
    <skos:altLabel xml:lang="de">menschlicher Aspekt</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Dimension humaine</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">interès humanitari</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">aspekt ludzki</skos:prefLabel>
    <skos:prefLabel xml:lang="da">humanisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="nl">Human interest</skos:prefLabel>
    <skos:prefLabel xml:lang="de">menschliche Interessen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žmonių interesai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">interessi umani</skos:prefLabel>
    <skos:prefLabel xml:lang="es">interés humano</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31055">
    <skos:prefLabel xml:lang="es">nazismo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">dones-sufragi</skos:prefLabel>
    <skos:prefLabel xml:lang="it">suffragette</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">suffragetter</skos:prefLabel>
    <skos:altLabel xml:lang="de">Frauenrechtlerinnen</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">suffragettes</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sufražistės</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="bg">движение за женски права</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sufrażystki</skos:prefLabel>
    <skos:altLabel xml:lang="de">Suffragetten</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Suffragettes</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Suffragettes</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Suffragettes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sufražetky</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30401">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:prefLabel xml:lang="de">Schule</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escoles</skos:prefLabel>
    <skos:prefLabel xml:lang="en">school</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">School</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">училище</skos:prefLabel>
    <skos:altLabel xml:lang="de">Lehranstalt</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">škola</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skoler</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scuola</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escuela</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mokykla</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">École</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">szkoła</skos:prefLabel>
    <skos:altLabel xml:lang="de">Unterricht</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31310">
    <skos:prefLabel xml:lang="bg">бездомни</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Obdachlosigkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="it">senza tetto</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">hjemløs</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vagabunds</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">bezdomność</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dakloos</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sans-abri</skos:prefLabel>
    <skos:prefLabel xml:lang="en">homelessness</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vagabundo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">benamystė</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31309"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">bezdomovectvo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13010">
    <skos:prefLabel xml:lang="ca">diapositiva color</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Farb-Dias</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Farbdias</skos:altLabel>
    <skos:prefLabel xml:lang="bg">цветни диапозитиви</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">diapositive en couleur</skos:prefLabel>
    <skos:prefLabel xml:lang="es">diapositivas</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spalvotos skaidrės</skos:prefLabel>
    <skos:prefLabel xml:lang="en">color slides</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">farebné diapozitívy</skos:prefLabel>
    <skos:prefLabel xml:lang="it">diapositive a colori</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kleurendia</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przeźrocza barwne</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13008"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="da">farvedias</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31001">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">pagrindinės teisės</skos:prefLabel>
    <skos:prefLabel xml:lang="es">derechos fundamentales</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фундаментални права</skos:prefLabel>
    <skos:prefLabel xml:lang="it">diritti fondamentali</skos:prefLabel>
    <skos:prefLabel xml:lang="da">rettigheder</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fundamental rights</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">prawa podstawowe</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Droits fondamentaux</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">základné práva</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31000"/>
    <skos:prefLabel xml:lang="de">Grundrechte</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">drets fonamentals</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fundamentele rechten</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31035">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">златна треска</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zlatá horúčka</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">febre d'or</skos:prefLabel>
    <skos:altLabel xml:lang="de">Goldfieber</skos:altLabel>
    <skos:prefLabel xml:lang="pl">gorączka złota</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gold rush</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="it">corsa all'oro</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Goldrausch</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">gold rush</skos:prefLabel>
    <skos:prefLabel xml:lang="da">guldfeber</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">aukso karštligė</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ruée vers l'or</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fiebre del oro</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31021">
    <skos:prefLabel xml:lang="de">Gemeindeverwaltung</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">samorząd</skos:prefLabel>
    <skos:prefLabel xml:lang="it">governo locale</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Locale overheid</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kommuner</skos:prefLabel>
    <skos:prefLabel xml:lang="es">gobierno local</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:altLabel xml:lang="de">Kreisverwaltung</skos:altLabel>
    <skos:altLabel xml:lang="de">Ortsbehörde</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">vietos valdžia</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">местно самоуправление</skos:prefLabel>
    <skos:prefLabel xml:lang="en">local government</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">administració local</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Gouvernement local</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">miestna vláda</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31042">
    <skos:prefLabel xml:lang="nl">Communisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Communisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">kommunisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">komunizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">комунизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="it">comunismo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">manifestación</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">komunizmus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">communism</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">komunizm</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kommunismus</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">comunisme</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30402">
    <skos:prefLabel xml:lang="da">studerende</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:prefLabel xml:lang="es">estudiante</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">studentas/ mokinys</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Student</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Student</skos:prefLabel>
    <skos:prefLabel xml:lang="it">studente</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">студент</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">študent</skos:prefLabel>
    <skos:altLabel xml:lang="de">Studentin</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Élève</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">student</skos:prefLabel>
    <skos:prefLabel xml:lang="en">student</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">estudiants</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31056">
    <skos:prefLabel xml:lang="da">nationalisme</skos:prefLabel>
    <skos:prefLabel xml:lang="it">nazionalismo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">национализъм</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="lt">nacionalizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">nationalism</skos:prefLabel>
    <skos:prefLabel xml:lang="es">acontecimientos políticos / hechos</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Nationalismus</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nacionalizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">nacjonalizm</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Nationalisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Nationalisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">nacionalisme</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31311">
    <skos:prefLabel xml:lang="de">Armut</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Armoede</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">chudoba</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ubóstwo /bieda</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бедност</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fattigdom</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">pobresa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pauvreté</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31309"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">pobreza</skos:prefLabel>
    <skos:prefLabel xml:lang="en">poverty</skos:prefLabel>
    <skos:prefLabel xml:lang="it">povertà</skos:prefLabel>
    <skos:altLabel xml:lang="de">Mangel</skos:altLabel>
    <skos:prefLabel xml:lang="lt">skurdas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Not</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31002">
    <skos:prefLabel xml:lang="da">censur</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">cenzūra</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">cenzura</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Zensur</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Censure</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">cenzúra</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цензура</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">censura</skos:prefLabel>
    <skos:prefLabel xml:lang="it">censura</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31001"/>
    <skos:prefLabel xml:lang="es">censura</skos:prefLabel>
    <skos:prefLabel xml:lang="en">censorship</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Censuur</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31036">
    <skos:prefLabel xml:lang="lt">tarpukaris</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="en">interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">период между двете свтовни войни</skos:prefLabel>
    <skos:prefLabel xml:lang="da">mellemkrigstid</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">període d'entreguerres</skos:prefLabel>
    <skos:prefLabel xml:lang="it">periodo tra le due guerre</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">dwudziestolecie międzywojenne</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Entre-deux-guerres</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Interbellum</skos:prefLabel>
    <skos:altLabel xml:lang="de">die Zeit zwischen den Weltkriegen</skos:altLabel>
    <skos:prefLabel xml:lang="es">entreguerras</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31022">
    <skos:prefLabel xml:lang="nl">Minister</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Minister</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="da">ministre</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">ministres</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">minister</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">minister</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ministre</skos:prefLabel>
    <skos:prefLabel xml:lang="en">minister</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ministerin</skos:altLabel>
    <skos:prefLabel xml:lang="bg">министър</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">ministerija</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ministro</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ministro</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gesandte</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31043">
    <skos:prefLabel xml:lang="bg">коронация</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kroninger</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">coronacions</skos:prefLabel>
    <skos:prefLabel xml:lang="it">incoronazione</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="fr">Couronnement</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">koronacja</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">karūnavimas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">elecciones</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">korunovácia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kroning</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Krönung</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">coronation</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30403">
    <skos:prefLabel xml:lang="da">lærer</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:prefLabel xml:lang="pl">nauczyciel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">profesor</skos:prefLabel>
    <skos:prefLabel xml:lang="en">teacher</skos:prefLabel>
    <skos:altLabel xml:lang="de">Lehrmeister</skos:altLabel>
    <skos:prefLabel xml:lang="it">insegnante</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">mokytojas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Leerkracht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">professors</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Professeur</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Lehrer</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">učiteľ</skos:prefLabel>
    <skos:altLabel xml:lang="de">Lehrerin</skos:altLabel>
    <skos:prefLabel xml:lang="bg">учител</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30602">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Feine Gesellschaft</skos:altLabel>
    <skos:prefLabel xml:lang="es">alta sociedad</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Haute société</skos:prefLabel>
    <skos:prefLabel xml:lang="da">overklasse</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Hautevolee</skos:altLabel>
    <skos:prefLabel xml:lang="pl">wysokie sfery / klasa wyższa /</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">висше общество</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30600"/>
    <skos:prefLabel xml:lang="en">high-society</skos:prefLabel>
    <skos:prefLabel xml:lang="it">altà società</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">aukštuomenė</skos:prefLabel>
    <skos:prefLabel xml:lang="de">High Society</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">alta burgesia</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">High-society</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">high society</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31053">
    <skos:prefLabel xml:lang="lt">vergovės panaikinimas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">abolition of slavery</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">abolicionistes</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">отмяна на робството</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Afschaffing van de slavernij</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">zniesienie niewolnictwa</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sufragistas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">afskaffelsen af ​​slaveri</skos:prefLabel>
    <skos:prefLabel xml:lang="it">abolizione della schiavitù</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Abschaffung der Sklaverei</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Abolition de l'esclavage</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zrušenie otroctva</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31052"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30603">
    <skos:prefLabel xml:lang="it">manor culture</skos:prefLabel>
    <skos:prefLabel xml:lang="en">manor culture</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">noblesa</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">"""Herenhuis"" cultuur"</skos:prefLabel>
    <skos:altLabel xml:lang="de">Herrenhaus</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">чифликчийска култура</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landgut</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">herregårds kultur</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dvarų kultūra</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">"Culture ""Maison de maître"""</skos:prefLabel>
    <skos:prefLabel xml:lang="es">nobleza</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">šľachtická kultúra</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kulturgut</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30602"/>
    <skos:prefLabel xml:lang="pl">kultura dworska</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31003">
    <skos:prefLabel xml:lang="en">civil rights</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Droits civils</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">drets civils</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">prawa obywatelskie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">derechos civiles</skos:prefLabel>
    <skos:prefLabel xml:lang="da">borgerskab</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">diritti civili</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31001"/>
    <skos:prefLabel xml:lang="nl">Burgerrechten</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">pilietinės teisės</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bürgerrechte</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">граждански права</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">občianske práva</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31033">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="fr">Période edwardienne</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Едуардов период</skos:prefLabel>
    <skos:altLabel xml:lang="de">Edwardische Periode</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Edwardiaanse periode</skos:prefLabel>
    <skos:prefLabel xml:lang="it">periodo edoardiano</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Edvardo periodas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">període eduardià</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Edwardovské Anglicko</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Okres edwardiański</skos:prefLabel>
    <skos:prefLabel xml:lang="es">período eduardino</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Edwardian period</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Edwardian period</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">edwardiansk periode</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31023">
    <skos:prefLabel xml:lang="da">nationale regeringer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">governo nazionale</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rząd krajowy</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">govern nacional</skos:prefLabel>
    <skos:prefLabel xml:lang="es">gobierno nacional</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nacionalinė vyriausybė</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Gouvernement national</skos:prefLabel>
    <skos:prefLabel xml:lang="en">national government</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">правителство</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Nationale overheid</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">národná vláda</skos:prefLabel>
    <skos:altLabel xml:lang="de">Landesregierung</skos:altLabel>
    <skos:prefLabel xml:lang="de">Staatsregierung</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/25000">
    <skos:prefLabel xml:lang="de">Werbung</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:altLabel xml:lang="de">Reklame</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <skos:prefLabel xml:lang="sl">reklama</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">reklama</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía publicitaria</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia publicitària</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">реклама</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">pubblicità</skos:prefLabel>
    <skos:prefLabel xml:lang="da">reklame</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Advertentie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">advertising</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ankündigung</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Publicité</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">reklaminė fotografija</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31044">
    <skos:prefLabel xml:lang="pl">demonstracja</skos:prefLabel>
    <skos:prefLabel xml:lang="es">emigración e inmigración</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">демонстрация</skos:prefLabel>
    <skos:prefLabel xml:lang="it">manifestazione</skos:prefLabel>
    <skos:prefLabel xml:lang="en">demonstration</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">demonstracija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">demonstrationer</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">manifestacions</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Demonstratie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">demonštrácia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Demonstration</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Démonstration</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31054">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="en">socialist movement</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">socialistinis judėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">movimento socialista</skos:prefLabel>
    <skos:prefLabel xml:lang="da">socialistiske bevægelser</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">социалистическо движение</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">socialistické hnutie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Sozialistische Bewegung</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ruch socjalistyczny</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">nacionalismo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Socialistische beweging</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">moviment socialista</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mouvement socialiste</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30601">
    <skos:prefLabel xml:lang="pl">odznaczenie i nagroda</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">награда</skos:prefLabel>
    <skos:prefLabel xml:lang="it">riconoscimento e premio</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Oorkonde en prijs</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30600"/>
    <skos:prefLabel xml:lang="lt">apdovanojimas ir prizas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">condecoraciones y premios</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gewinn und Preis</skos:altLabel>
    <skos:prefLabel xml:lang="da">præmier og priser</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">award and prize</skos:prefLabel>
    <skos:altLabel xml:lang="de">Auszeichnung</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Distinctions et prix</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Preisvergabe</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ocenenie a cena</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">premis i reconeixements</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30404">
    <skos:altLabel xml:lang="de">Unterrichtsmittel</skos:altLabel>
    <skos:prefLabel xml:lang="en">teaching aids</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:altLabel xml:lang="de">Arbeitsmittel</skos:altLabel>
    <skos:prefLabel xml:lang="pl">pomoce dydaktyczne</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Lehrmittel</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">mokymo priemonės</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">учебни помагала</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">učebné pomôcky</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Leermiddelen</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Aide à l'enseignement</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">material didàctic</skos:prefLabel>
    <skos:prefLabel xml:lang="es">material didáctico</skos:prefLabel>
    <skos:prefLabel xml:lang="da">undervisningsmaterialer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">materiali didattici</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30405">
    <skos:prefLabel xml:lang="pl">uniwersytet</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Universiteit</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hochschule</skos:altLabel>
    <skos:prefLabel xml:lang="es">universidad</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">università</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">universitetas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:prefLabel xml:lang="da">universiteter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">universitats</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Université</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">univerzita</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Universität</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">университет</skos:prefLabel>
    <skos:prefLabel xml:lang="en">university</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31004">
    <skos:prefLabel xml:lang="lt">religijos laisvė</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Religionsfreiheit</skos:prefLabel>
    <skos:prefLabel xml:lang="da">religionsfrihed</skos:prefLabel>
    <skos:prefLabel xml:lang="it">libertà di religione</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">wolność wyznania/wolność religijna</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vrijheid van religie</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Liberté religieuse</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">llibertat - Aspectes religiosos</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31001"/>
    <skos:prefLabel xml:lang="en">freedom of religion</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sloboda vyznania</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">свобода на религията</skos:prefLabel>
    <skos:prefLabel xml:lang="es">libertad de culto</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31024">
    <skos:prefLabel xml:lang="lt">rūmai</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Palast</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">palác</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">дворец</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">palaus</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Palais</skos:prefLabel>
    <skos:prefLabel xml:lang="es">palacio</skos:prefLabel>
    <skos:prefLabel xml:lang="it">palazzo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:altLabel xml:lang="de">Schloss</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Paleis</skos:prefLabel>
    <skos:prefLabel xml:lang="da">paladser</skos:prefLabel>
    <skos:prefLabel xml:lang="en">palace</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Paläste</skos:altLabel>
    <skos:prefLabel xml:lang="pl">pałac</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31034">
    <skos:altLabel xml:lang="de">Dekadentismus</skos:altLabel>
    <skos:prefLabel xml:lang="es">fin de siglo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fin de siècle</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="da">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="de">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">от края на 19-ти век</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fi de segle</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fin de siècle, fine secolo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">fin de siècle („šimtmečio pabaiga“)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30128">
    <skos:altLabel xml:lang="de">kultureller Zeitraum</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Culturele periodes</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">períodes culturals</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="da">kulturelle perioder</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">cerámica</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">periodi culturali</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kultúrne epochy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kulturperiode</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">okresy / style w sztuce</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cultural periods</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Périodes culturelles</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kultūriniai periodai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">културни периоди</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31109">
    <skos:prefLabel xml:lang="it">ebraismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">judaizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Judaisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Judaism</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">юдаизъм</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:altLabel xml:lang="de">Jinismus</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Judaïsme</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Jodendom</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">judaizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Judaizm</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Jainismus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Jødedom</skos:prefLabel>
    <skos:prefLabel xml:lang="es">judaísmo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30138">
    <skos:prefLabel xml:lang="pl">dwudziestolecie międzywojenne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="it">periodo tra le due guerre</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">период между двете световни войни</skos:prefLabel>
    <skos:prefLabel xml:lang="es">género</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tarpukaris</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="en">interbellum</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">mellemkrigstiden</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Interbellum</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">període d'entreguerres</skos:prefLabel>
    <skos:altLabel xml:lang="de">die Zeit zwischen den Weltkriegen</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Entre-deux-guerres</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31059">
    <skos:prefLabel xml:lang="nl">Openbaar bestuur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гражданска администрация</skos:prefLabel>
    <skos:prefLabel xml:lang="da">offentlig administration</skos:prefLabel>
    <skos:prefLabel xml:lang="de">öffentliche Verwaltung</skos:prefLabel>
    <skos:altLabel xml:lang="de">Staatsverwaltung</skos:altLabel>
    <skos:prefLabel xml:lang="sl">verejná správa</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="it">pubblica amministrazione</skos:prefLabel>
    <skos:prefLabel xml:lang="es">administración pública</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">viešasis administravimas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Administration publique</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">administració pública</skos:prefLabel>
    <skos:prefLabel xml:lang="en">public administration</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">administracja publiczna</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31045">
    <skos:prefLabel xml:lang="nl">Verkiezing</skos:prefLabel>
    <skos:prefLabel xml:lang="da">valg</skos:prefLabel>
    <skos:prefLabel xml:lang="en">election</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">избори</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="it">elezione</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">elekcja</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">voľby</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">rinkimai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wahl durch Abstimmung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">eleccions</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Élection</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">fascismo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wahl</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12008">
    <skos:prefLabel xml:lang="nl">gelatineplaatnegatief</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="es">negativos en placa seca</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">negatiu de placa seca de gelatina</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy żelatynowe (tzw sucha plyta)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">gelatin dry plate negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">négatif sur verre au gélatino-bromure d'argent</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gelatine-Trockenplatten-Negative</skos:altLabel>
    <skos:prefLabel xml:lang="it">negativi su lastra asciutta alla gelatina</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">gelatine tørre plade negativer</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="bg">негатив върху суха желатинова плака</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">suchý želatínový proces</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">želatiniai sausieji stiklo negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gelatin dry plate Negative</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30169">
    <skos:prefLabel xml:lang="bg">ниело</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Niello</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Niello</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Niello</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Niello</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Niello</skos:prefLabel>
    <skos:prefLabel xml:lang="it">niello, niellatura</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Niellage</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Nielas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">niell</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">grupo de canto</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nielo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13000">
    <skos:prefLabel xml:lang="lt">bendrieji</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Generelt</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/10000"/>
    <skos:prefLabel xml:lang="ca">general</skos:prefLabel>
    <skos:prefLabel xml:lang="en">general</skos:prefLabel>
    <skos:prefLabel xml:lang="es">general</skos:prefLabel>
    <skos:prefLabel xml:lang="it">generale</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Allgemein</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">ogólny</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">všeobecný</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">générale</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">общ</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="nl">algemeen</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31108">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Judentum</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">džinizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">džainizmas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Jaïnisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jaïnisme</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Dżinizm</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Jainisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Jainisme</skos:prefLabel>
    <skos:prefLabel xml:lang="it">jainismo, giainismo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Jainism</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">джайнизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="es">jainismo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31118">
    <skos:prefLabel xml:lang="fr">Cloître</skos:prefLabel>
    <skos:prefLabel xml:lang="da">klostre</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kláštor</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Klöster</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="lt">vienuolynas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">monastery</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Klooster</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Stift</skos:altLabel>
    <skos:prefLabel xml:lang="bg">манастир</skos:prefLabel>
    <skos:prefLabel xml:lang="it">monastero</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">monestirs</skos:prefLabel>
    <skos:prefLabel xml:lang="es">monasterio</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">klasztor</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kloster</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31031">
    <skos:prefLabel xml:lang="lt">kolonializmas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Imperialisme</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kolonialisme</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kolonializm</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kolonializmus</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Colonialisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">colonialism</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kolonialismus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kolonialisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">colonialismo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">colonialismo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="bg">колониализъм</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31005">
    <skos:prefLabel xml:lang="it">libertà di stampa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Liberté de la presse</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spaudos laisvė</skos:prefLabel>
    <skos:prefLabel xml:lang="da">pressefrihed</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">свобода на пресата</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">llibertat d’impremta</skos:prefLabel>
    <skos:prefLabel xml:lang="en">freedom of the press</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Persvrijheid</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31001"/>
    <skos:prefLabel xml:lang="es">libertad de imprenta</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Pressefreiheit</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sloboda tlače</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">wolność prasy /słowa</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30406">
    <skos:altLabel xml:lang="de">Vorschule</skos:altLabel>
    <skos:prefLabel xml:lang="en">Nursery school</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">детска градина</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">llar d'infants</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">vaikų darželis</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kinderopvang</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kita, Kindertagesstätte</skos:altLabel>
    <skos:prefLabel xml:lang="sl">jasle</skos:prefLabel>
    <skos:prefLabel xml:lang="da">børnehave</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">École maternelle</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30400"/>
    <skos:prefLabel xml:lang="it">asilo nido/scuola dell'infanzia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kindergarten</skos:prefLabel>
    <skos:prefLabel xml:lang="es">parvulario</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przedszkole</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30179">
    <skos:prefLabel xml:lang="es">impresionismo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Prägen</skos:altLabel>
    <skos:altLabel xml:lang="de">Geldstück</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Munt</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="lt">Moneta/metalinis pinigas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">minca</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Münze</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Coin</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">monedes</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Mønter</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">монета</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Monnaie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">moneta</skos:prefLabel>
    <skos:prefLabel xml:lang="it">moneta</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31046">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:altLabel xml:lang="de">Auswanderung und Einwanderung</skos:altLabel>
    <skos:prefLabel xml:lang="sl">emigrácia a imigrácia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">emigració i immigració</skos:prefLabel>
    <skos:prefLabel xml:lang="es">independencia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Emigration und Immigration</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Emigratie en immigratie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">udvandring og indvandring</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">emigracja i imigracja</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">емигграция и имиграция</skos:prefLabel>
    <skos:prefLabel xml:lang="it">emigrazione e immigrazione</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Émigration et immigration</skos:prefLabel>
    <skos:prefLabel xml:lang="en">emigration and immigration</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">emigracija ir imigracija</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30129">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="nl">Art Deco</skos:prefLabel>
    <skos:altLabel xml:lang="de">Art Deco</skos:altLabel>
    <skos:prefLabel xml:lang="es">cristalería</skos:prefLabel>
    <skos:prefLabel xml:lang="da">art Déco</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Art déco</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Ар деко</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Art Déco</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Art Déco</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">art déco</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">art déco</skos:prefLabel>
    <skos:prefLabel xml:lang="it">art déco</skos:prefLabel>
    <skos:prefLabel xml:lang="en">art déco</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">art déco</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30139">
    <skos:prefLabel xml:lang="ca">anys vint (S. XX)</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">triukšmingi dvidešimtieji</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">die Goldenen Zwanziger Jahre</skos:altLabel>
    <skos:prefLabel xml:lang="es">vista interior</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Roaring twenties</skos:prefLabel>
    <skos:altLabel xml:lang="fr">Roaring Twenties</skos:altLabel>
    <skos:prefLabel xml:lang="de">Roaring twenties</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="en">roaring twenties</skos:prefLabel>
    <skos:prefLabel xml:lang="da">brølende tyvere</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="it">anni ruggenti, anni Venti</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Années folles</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">1920-те</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lata dwudzieste</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12007">
    <skos:prefLabel xml:lang="pl">negatywy żelatynowo-srebrowe</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="de">Silbergelatine Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">gelatine-zilver negatief</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">želatínový negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gelatine sølv negativer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi alla gelatina d'argento</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">negatiu de gelatina de plata</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos de plata en gelatina</skos:prefLabel>
    <skos:prefLabel xml:lang="en">gelatin silver negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">négatif gélatino-argentique</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сребърно-желатинов негатив</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">želatiniai sidabro negatyvai</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30168">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Näharbeit</skos:altLabel>
    <skos:prefLabel xml:lang="da">Håndarbejde</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Needlework</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="pl">Robótki ręczne</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Siuvinėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Handarbeit</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бродерия</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">labors d'agulla</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Naaldkunst</skos:prefLabel>
    <skos:prefLabel xml:lang="es">escultor</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ricamo, cucito</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Travaux d'aiguilles</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">výšivky, čipky</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31032">
    <skos:prefLabel xml:lang="lt">Commune de Paris</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">París (França)--Història--1871, Comuna</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Commune de Paris</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Commune de Paris</skos:prefLabel>
    <skos:altLabel xml:lang="de">Pariser Kommune</skos:altLabel>
    <skos:prefLabel xml:lang="de">Commune de Paris</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Commune de Paris</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="da">Pariserkommunen</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">Comune di Parigi</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Parížska Komúna</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Komuna Paryska</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Comuna de parís</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Парижката Комуна</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31119">
    <skos:prefLabel xml:lang="de">Moschee</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mosquée</skos:prefLabel>
    <skos:prefLabel xml:lang="it">moschea</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">mečetė</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mešita</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="pl">meczet</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mesquites</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Moskee</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">джамия</skos:prefLabel>
    <skos:prefLabel xml:lang="da">moskéer</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">mezquita</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">mosque</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31006">
    <skos:prefLabel xml:lang="ca">drets humans</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">ľudské práva</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31001"/>
    <skos:prefLabel xml:lang="it">diritti umani</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mensenrechten</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Droits de l'homme</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">derechos humanos</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Menschenrechte</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žmogaus teisės</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">човешки права</skos:prefLabel>
    <skos:prefLabel xml:lang="en">human rights</skos:prefLabel>
    <skos:prefLabel xml:lang="da">menneskerettigheder</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">prawa człowieka</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30178">
    <skos:prefLabel xml:lang="nl">Vuursteen</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kiesel</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Feuerstein</skos:altLabel>
    <skos:prefLabel xml:lang="lt">Titnagas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sílex</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Silex</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30104"/>
    <skos:prefLabel xml:lang="sl">kremeň</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">кремък</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fin de siglo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">" krzemień krzemień"</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Flint</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Flint</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Flint</skos:prefLabel>
    <skos:prefLabel xml:lang="it">selce</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30126">
    <skos:prefLabel xml:lang="it">gruppo canoro</skos:prefLabel>
    <skos:prefLabel xml:lang="en">singers society</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Société de chanteurs</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">towarzystwo spiewacze</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gesangsverein</skos:prefLabel>
    <skos:prefLabel xml:lang="es">muebles</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">певческо дружество</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Zangvereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">grup de cant</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dainininkų draugija</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">spevácka spoločnosť</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sangforeninger</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31047">
    <skos:prefLabel xml:lang="sl">fašizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fascisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">feixisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="it">fascismo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Faschismus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">movimiento laboral</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">faszyzm</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">фашизъм</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Fascisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Fascisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fascism</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fašizmas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31057">
    <skos:prefLabel xml:lang="nl">Nazisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Nazisme</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">nazism</skos:prefLabel>
    <skos:prefLabel xml:lang="it">nazismo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">nacionalsocialisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">nazisme</skos:prefLabel>
    <skos:prefLabel xml:lang="es">abdicación</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">нацизъм</skos:prefLabel>
    <skos:altLabel xml:lang="de">Nationalsozialismus</skos:altLabel>
    <skos:prefLabel xml:lang="lt">nacizmas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
    <skos:prefLabel xml:lang="sl">nacizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Nazismus</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">nazizm</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31106">
    <skos:prefLabel xml:lang="nl">Hindoeïsme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Hindouisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Hinduism</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Hinduisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Hinduisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hinduizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="it">induismo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">Hinduizm</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hinduismus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Hinduismo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">hinduizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">индуизъм</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30167">
    <skos:altLabel xml:lang="de">Kollagen</skos:altLabel>
    <skos:prefLabel xml:lang="it">collage</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">collage</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">koláže</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">колаж</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Collager</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Kolaże</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">editor</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Collage</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Collage</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Collages</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="de">Collagen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Koliažas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13002">
    <skos:prefLabel xml:lang="pl">fotografia barwna</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografie a colori</skos:prefLabel>
    <skos:prefLabel xml:lang="en">color photographs</skos:prefLabel>
    <skos:altLabel xml:lang="de">Farbphotographien</skos:altLabel>
    <skos:prefLabel xml:lang="fr">photo en couleur</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kleurenfoto</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">farvefotografier</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia en color</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цветна фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spalvotos fotografijos</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="es">fotografías en color</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13000"/>
    <skos:prefLabel xml:lang="de">Farbfotografien</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">farebná fotografia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31007">
    <skos:prefLabel xml:lang="bg">правителство</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Regierung</skos:prefLabel>
    <skos:prefLabel xml:lang="it">governo</skos:prefLabel>
    <skos:prefLabel xml:lang="da">regeringer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rząd</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">vyriausybė</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vláda</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Overheid</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">govern</skos:prefLabel>
    <skos:prefLabel xml:lang="en">government</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">gobierno</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31000"/>
    <skos:prefLabel xml:lang="fr">Gouvernement</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30127">
    <skos:prefLabel xml:lang="sl">spisovateľ</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">писател</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">rašytojas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escriptors</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tapicería</skos:prefLabel>
    <skos:prefLabel xml:lang="da">forfattere</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Écrivain</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Autor</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schriftsteller</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">pisarz</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scrittore</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schrijver</skos:prefLabel>
    <skos:altLabel xml:lang="de">Autorin</skos:altLabel>
    <skos:prefLabel xml:lang="en">writer</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31048">
    <skos:prefLabel xml:lang="fr">Indépendance</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">независимост</skos:prefLabel>
    <skos:prefLabel xml:lang="da">uafhængighed</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">independence</skos:prefLabel>
    <skos:prefLabel xml:lang="es">movimiento liberal</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">niepodległość</skos:prefLabel>
    <skos:altLabel xml:lang="de">Selbstständigkeit</skos:altLabel>
    <skos:prefLabel xml:lang="sl">nezávislosť</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nepriklausomybė</skos:prefLabel>
    <skos:prefLabel xml:lang="it">indipendenza</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">independència</skos:prefLabel>
    <skos:altLabel xml:lang="de">Eigenständigkeit</skos:altLabel>
    <skos:prefLabel xml:lang="de">Unabhängigkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Onafhankelijkheid</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31058">
    <skos:prefLabel xml:lang="ca">genocidi</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ludobójstwo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">genocída</skos:prefLabel>
    <skos:prefLabel xml:lang="en">genocide</skos:prefLabel>
    <skos:prefLabel xml:lang="es">genocidio</skos:prefLabel>
    <skos:prefLabel xml:lang="it">genocidio</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">геноцид</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Genocide (volkerenmoord)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">folkedrab</skos:prefLabel>
    <skos:altLabel xml:lang="de">Völkermord</skos:altLabel>
    <skos:prefLabel xml:lang="lt">genocidas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Génocide</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Genozid</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12009">
    <skos:prefLabel xml:lang="de">Wet collodion Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мокър колодиев негатив</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">négatifs au collodion humide</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="ca">negatiu de col·lodió humit</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos al colodión húmedo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi al collodio umido</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Nass-Kollodium-Negative</skos:altLabel>
    <skos:prefLabel xml:lang="da">våde kollodium negativer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy mokrej płyty kolodionowej</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mokrý kolódiový negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">natte collodiumglasnegatief</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="lt">koloidiniai negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">wet collodion negatives</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31107">
    <skos:prefLabel xml:lang="nl">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Islam</skos:prefLabel>
    <skos:prefLabel xml:lang="it">islamismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">islám</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Islamisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">islamas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ислям</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31020">
    <skos:prefLabel xml:lang="sl">vojak</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31013"/>
    <skos:prefLabel xml:lang="nl">Soldaat</skos:prefLabel>
    <skos:prefLabel xml:lang="es">soldado</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">żołnierz</skos:prefLabel>
    <skos:altLabel xml:lang="de">Soldatin</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">karys</skos:prefLabel>
    <skos:prefLabel xml:lang="en">soldier</skos:prefLabel>
    <skos:prefLabel xml:lang="it">soldato</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Soldat</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Soldat</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">soldats</skos:prefLabel>
    <skos:prefLabel xml:lang="da">soldater</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">войник</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31230">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">avions</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Oras ir orlaiviai</skos:prefLabel>
    <skos:prefLabel xml:lang="da">luftfart</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tranvía</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">въздух и летателни апарати</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Aéronautique et avion</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Luft und Flugzeug</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">letecká doprava</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Lucht en vliegtuig</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">Air &amp; aircraft</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lotnictwo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">aria e aereomobili</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/13001">
    <skos:prefLabel xml:lang="it">fotografie in bianco e nero</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Zwartwitfoto</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">черно-бяла фотография</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">baltai juodos fotografijos</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">čiernobiela fotografia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="fr">photo en noir et blanch</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">black-and-white photographs</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia blanc i negre</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografías en blanco y negro</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia czarno-biała</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/13000"/>
    <skos:prefLabel xml:lang="da">sort-hvide fotografier</skos:prefLabel>
    <skos:altLabel xml:lang="de">schwarz-weiss Photographien</skos:altLabel>
    <skos:prefLabel xml:lang="de">Schwarz-weiß-Fotografien</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30166">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Tapisserie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Gobeliner</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Tapiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Gobelenas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">poeta</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tapissos</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Gobelin</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:altLabel xml:lang="de">Gobelin</skos:altLabel>
    <skos:altLabel xml:lang="de">Tapissery</skos:altLabel>
    <skos:prefLabel xml:lang="it">tappezzeria</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Tapestry</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tapisérie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">гоблен</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Wandteppich</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31030">
    <skos:prefLabel xml:lang="de">Belle Epoque</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skønvirke</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Бел епок</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Belle Époque („Gražioji epocha“)</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31029"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31008">
    <skos:prefLabel xml:lang="da">statsoverhoveder</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">caps d'estat</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Staatshoofden</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">capo di stato</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">heads of state</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Staatschef</skos:prefLabel>
    <skos:altLabel xml:lang="de">Staatsoberhaupt</skos:altLabel>
    <skos:prefLabel xml:lang="lt">valstybių vadovai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">przywódcy państwowi</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Chef de l'état</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31007"/>
    <skos:prefLabel xml:lang="bg">държавен глава</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">štátni predstavitelia</skos:prefLabel>
    <skos:prefLabel xml:lang="es">jefe de estado</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30000">
    <skos:prefLabel xml:lang="sl">kľúčové slová</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schlüsselworte</skos:altLabel>
    <skos:prefLabel xml:lang="de">Schlagworte</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">słowa kluczowe</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mots-clés</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">raktiniai žodžiai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">keywords</skos:prefLabel>
    <skos:altLabel xml:lang="de">Stichworte</skos:altLabel>
    <skos:prefLabel xml:lang="it">parole chiave</skos:prefLabel>
    <skos:prefLabel xml:lang="da">søgeord</skos:prefLabel>
    <skos:prefLabel xml:lang="es">palabras clave</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Sleutelwoorden</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">ключови думи</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">paraules clau</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30154">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">escultura commemorativa</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Rzeźba pamiątkowa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sculpture commémorative</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scultura commemorativa</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Herdenkingssculptuur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pamätná socha</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Erindringsskulpturer</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Denkmal</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="en">Commemorative sculpture</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">възпоменателна скулптура</skos:prefLabel>
    <skos:prefLabel xml:lang="es">música</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Memorialinė skulptūra</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30144">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30143"/>
    <skos:prefLabel xml:lang="de">Stierkampf</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">walki byków</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estilo de vida</skos:prefLabel>
    <skos:prefLabel xml:lang="en">bull fighting</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">býčie zápasy</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">bulių kautynės</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Stierengevecht</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">corridas de toros</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бой с бикове</skos:prefLabel>
    <skos:prefLabel xml:lang="it">corrida</skos:prefLabel>
    <skos:altLabel xml:lang="de">Stier-Kämpfe</skos:altLabel>
    <skos:prefLabel xml:lang="da">tyrefægtning</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tauromachie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31009">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">presidents</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Präsident</skos:prefLabel>
    <skos:prefLabel xml:lang="da">præsidenter</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">prezydent</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prezident</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">президент</skos:prefLabel>
    <skos:altLabel xml:lang="de">Firmenchef</skos:altLabel>
    <skos:prefLabel xml:lang="lt">prezidentas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Präsidentin</skos:altLabel>
    <skos:prefLabel xml:lang="nl">President</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31008"/>
    <skos:prefLabel xml:lang="fr">Président</skos:prefLabel>
    <skos:prefLabel xml:lang="en">president</skos:prefLabel>
    <skos:prefLabel xml:lang="es">presidente</skos:prefLabel>
    <skos:prefLabel xml:lang="it">presidente</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31114">
    <skos:prefLabel xml:lang="da">bygninger</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Gebäude</skos:prefLabel>
    <skos:prefLabel xml:lang="es">edificios</skos:prefLabel>
    <skos:prefLabel xml:lang="en">buildings</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31100"/>
    <skos:prefLabel xml:lang="pl">budynki</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bauten</skos:altLabel>
    <skos:prefLabel xml:lang="lt">pastatai</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bâtiments</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сграда</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">edifici</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gebouwen</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">edificis</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">budovy</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30921">
    <skos:altLabel xml:lang="de">Spielcasino</skos:altLabel>
    <skos:prefLabel xml:lang="lt">kazino</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Casino</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Casino</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Casino</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">казино</skos:prefLabel>
    <skos:prefLabel xml:lang="en">casino</skos:prefLabel>
    <skos:prefLabel xml:lang="da">casino</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">casinos</skos:prefLabel>
    <skos:prefLabel xml:lang="es">casinos (edificios recreativos)</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">kasyna</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30918"/>
    <skos:altLabel xml:lang="de">Spielbank</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">kasína</skos:prefLabel>
    <skos:prefLabel xml:lang="it">casinò</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31252">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:prefLabel xml:lang="da">mindesmærke</skos:prefLabel>
    <skos:prefLabel xml:lang="it">memoriale</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Memorial</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">paminklas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Memorial</skos:altLabel>
    <skos:prefLabel xml:lang="pl">pomnik</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">mémorial</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gedenkstätte</skos:altLabel>
    <skos:prefLabel xml:lang="sl">pamätník</skos:prefLabel>
    <skos:prefLabel xml:lang="es">memorial</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">memorial</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Denkmal</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">мемориал</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Gedenkteken</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31104">
    <skos:prefLabel xml:lang="pl">Konfucjanizm</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Konfucianisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Confusianism</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="bg">конфуцианство</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Confucianisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Confucianisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">konfucionizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">confucianesimo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Confusianisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">konfuciánstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Konfuzianismus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">confucionismo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Lehre Konfuzius</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31242">
    <skos:altLabel xml:lang="de">Tierkunde</skos:altLabel>
    <skos:prefLabel xml:lang="pl">zoologia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">zoologia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">zoologia</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Zoology</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Zoologie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zoologie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zoológia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">zoologija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31201"/>
    <skos:prefLabel xml:lang="bg">зоология</skos:prefLabel>
    <skos:prefLabel xml:lang="da">zoologi</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Zoölogie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">investigación</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31124">
    <skos:altLabel xml:lang="de">Trauung</skos:altLabel>
    <skos:prefLabel xml:lang="en">wedding</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hochzeit</skos:prefLabel>
    <skos:altLabel xml:lang="de">Heirat</skos:altLabel>
    <skos:prefLabel xml:lang="bg">сватба</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Huwelijk</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wesele</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:prefLabel xml:lang="fr">Mariage</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">boda</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">svadba</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vestuvės</skos:prefLabel>
    <skos:prefLabel xml:lang="da">bryllupper</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">bodes</skos:prefLabel>
    <skos:prefLabel xml:lang="it">matrimonio</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31404">
    <skos:altLabel xml:lang="de">Olympiade</skos:altLabel>
    <skos:prefLabel xml:lang="pl">Igrzyska Olimpijskie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">Олимпийски игри</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Jocs olímpics</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jeux Olympiques (moderne)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Olympische spelen (modern)</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Olympische Spiele</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Olimpinės žaidynės (šiuolaikinės)</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Olympijské hry (moderné)</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Olympic Games (modern)</skos:prefLabel>
    <skos:prefLabel xml:lang="it">olimpiadi, Giochi Olimpici (moderni)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Olympiske Lege (moderne)</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="es">Juegos Olímpicos (modernos)</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30709">
    <skos:prefLabel xml:lang="bg">работник във фабрика</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30706"/>
    <skos:prefLabel xml:lang="es">trabajadores</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fabrieksarbeiders</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fabriksarbejdere</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">treballadors de les fàbriques</skos:prefLabel>
    <skos:prefLabel xml:lang="it">operai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Fabrikarbeiterin</skos:altLabel>
    <skos:prefLabel xml:lang="lt">fabriko darbuotojai</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Ouvrier d'usine</skos:prefLabel>
    <skos:prefLabel xml:lang="en">factory workers</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">továrenskí robotníci</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Fabrikarbeiter</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pracownicy fabryki</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30134">
    <skos:prefLabel xml:lang="de">Edwardian period</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Edwardian period</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Edwardiaanse periode</skos:prefLabel>
    <skos:prefLabel xml:lang="it">periodo edoardiano</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">exploradores</skos:prefLabel>
    <skos:altLabel xml:lang="de">Edwardisches Zeitalter</skos:altLabel>
    <skos:prefLabel xml:lang="lt">Edvardo periodas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">okres  edwardiański</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Едуардов период</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Période edwardienne</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">període eduardià</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">edvardovské obodobie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">edwardiansk periode</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30272">
    <skos:prefLabel xml:lang="nl">Evacuatie</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">evakuacija</skos:prefLabel>
    <skos:altLabel xml:lang="de">Abtransport</skos:altLabel>
    <skos:prefLabel xml:lang="bg">евакуация</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">evacuación</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">evakuácia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">evacuazione</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Evakuierung</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="en">evacuation</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Evacuation</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ewakuacja</skos:prefLabel>
    <skos:altLabel xml:lang="de">Räumung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">evacuació</skos:prefLabel>
    <skos:prefLabel xml:lang="da">evakuering</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30310">
    <skos:prefLabel xml:lang="bg">наводнение</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">inundacions</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Inondation</skos:prefLabel>
    <skos:altLabel xml:lang="de">Überflutung / Flut</skos:altLabel>
    <skos:altLabel xml:lang="de">Hochwasser</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Overstroming</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="sl">záplava / povodeň</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Zalanie / powódź</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">inundation/flood</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">užtvindymas/potvynis</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Überschwemmung</skos:prefLabel>
    <skos:prefLabel xml:lang="it">inondazione/alluvione</skos:prefLabel>
    <skos:prefLabel xml:lang="es">inundaciones</skos:prefLabel>
    <skos:prefLabel xml:lang="da">oversvømmelser</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31304">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">minories ètniques</skos:prefLabel>
    <skos:prefLabel xml:lang="da">etniske mindretal</skos:prefLabel>
    <skos:prefLabel xml:lang="es">minoría étnica</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">mniejszość etniczna</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ethnische Minorität</skos:altLabel>
    <skos:prefLabel xml:lang="en">ethnic minority</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">etninė mažuma</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Minorité etnique</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Etnische minderheid</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31303"/>
    <skos:prefLabel xml:lang="sl">národnostná menšina</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ethnische Minderheit</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">етническо малцинство</skos:prefLabel>
    <skos:prefLabel xml:lang="it">minoranza etnica</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12004">
    <skos:prefLabel xml:lang="sl">farebný negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy kolorowe</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">farvenegativer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativo a colori</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">négatif en couleur</skos:prefLabel>
    <skos:prefLabel xml:lang="en">color negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos color</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="ca">negatiu color</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:altLabel xml:lang="de">Farbnegative</skos:altLabel>
    <skos:prefLabel xml:lang="de">Farb-Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spalvoti negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цветен негатив</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kleurennegatief</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30922">
    <skos:prefLabel xml:lang="it">escursionismo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Randonnée</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">žygis</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Wanderung</skos:altLabel>
    <skos:prefLabel xml:lang="en">hiking</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">excursionisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">turistika</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30910"/>
    <skos:prefLabel xml:lang="de">Wandern</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wspinaczka</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Wandelen</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">туризъм</skos:prefLabel>
    <skos:prefLabel xml:lang="es">excursionismo</skos:prefLabel>
    <skos:prefLabel xml:lang="da">vandring</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30124">
    <skos:prefLabel xml:lang="nl">Uitgever</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="it">editore</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">издател</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Verlag</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Éditeur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">vydavateľ</skos:prefLabel>
    <skos:prefLabel xml:lang="da">udgivere</skos:prefLabel>
    <skos:altLabel xml:lang="de">Verlegerin</skos:altLabel>
    <skos:prefLabel xml:lang="ca">editors</skos:prefLabel>
    <skos:prefLabel xml:lang="en">publisher</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wydawca</skos:prefLabel>
    <skos:altLabel xml:lang="de">Verleger</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">metalistería</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">leidėjas</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30262">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="fr">Nouvelle Objectivité</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">нова реалност</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Nieuwe Zakelijkheid</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Nuova oggettività/Neue Sachlichkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Nová vecnosť</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Neue Sachlichkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Neue Sachlichkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Neue Sachlichkeit</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Neue Sachlichkeit</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">naujasis daiktiškumas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Nova Objectivitat</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Nueva objetividad</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31134">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31133"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">prete</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Prêtre</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">свещенник</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">priest</skos:prefLabel>
    <skos:altLabel xml:lang="de">Priesterin</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Priester</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Priester</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kunigas/ dvasininkas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">predicador</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">sacerdots</skos:prefLabel>
    <skos:prefLabel xml:lang="da">præster</skos:prefLabel>
    <skos:altLabel xml:lang="de">Pfarrer</skos:altLabel>
    <skos:prefLabel xml:lang="pl">ksiądz</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kňaz</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30145">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">środki masowego przekazu</skos:prefLabel>
    <skos:prefLabel xml:lang="it">mass media</skos:prefLabel>
    <skos:altLabel xml:lang="fr">Mass media</skos:altLabel>
    <skos:prefLabel xml:lang="en">mass media</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Massenmedium</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">средства за масова комуникация</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="da">massemedier</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">masmédiá</skos:prefLabel>
    <skos:prefLabel xml:lang="es">pintura histórica</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žiniasklaida</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mitjans de comunicació de massa</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Médias de masse</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Massamedia</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31251">
    <skos:prefLabel xml:lang="pl">materiał organiczny</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">materia orgánica</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">organický materiál</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">органична материя</skos:prefLabel>
    <skos:prefLabel xml:lang="en">organic material</skos:prefLabel>
    <skos:prefLabel xml:lang="da">organisk materiale</skos:prefLabel>
    <skos:altLabel xml:lang="de">biologischer Stoff</skos:altLabel>
    <skos:prefLabel xml:lang="it">materiale organico</skos:prefLabel>
    <skos:prefLabel xml:lang="de">organische Substanz</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">organinė medžiaga</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Organisch materiaal</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Matériau organique</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31216"/>
    <skos:prefLabel xml:lang="ca">matèria orgànica</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30920">
    <skos:prefLabel xml:lang="sl">dostihové dráhy</skos:prefLabel>
    <skos:prefLabel xml:lang="da">væddeløbsbanen</skos:prefLabel>
    <skos:prefLabel xml:lang="es">hipódromos</skos:prefLabel>
    <skos:altLabel xml:lang="de">Pferderennbahn</skos:altLabel>
    <skos:prefLabel xml:lang="en">horse racetrack</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">hopodromas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Hippodroom</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">corse dei cavalli</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">хиподрум</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">hipòdroms</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Galopprennbahn</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30918"/>
    <skos:prefLabel xml:lang="fr">Hippodrome</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">tor do wyścigów konnych</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31115">
    <skos:prefLabel xml:lang="en">chapel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">capilla</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gotteshaus</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Chapelle</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">параклис</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Kapel</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cappella</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="lt">koplyčia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kapeller</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kaplnka</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">capelles</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kaplica</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kapelle</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31241">
    <skos:prefLabel xml:lang="ca">dirigibles</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zepelín</skos:prefLabel>
    <skos:prefLabel xml:lang="es">dibujo arquitectónico</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">zeppeliner</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цепелин</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">cepelinas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Zeppelin</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Zeppelin</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Zeppelin</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="it">dirigibile</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">zeppelin</skos:prefLabel>
    <skos:prefLabel xml:lang="en">zeppelin</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30155">
    <skos:prefLabel xml:lang="nl">Rouwsculptuur</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Friedhofs-Skulptur</skos:prefLabel>
    <skos:altLabel xml:lang="de">Friedhofs-Grabskulptur</skos:altLabel>
    <skos:prefLabel xml:lang="sl">náhrobok</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Antkapinė skulptūra</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Funerary sculpture</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escultura funerària</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">погребална скулптура</skos:prefLabel>
    <skos:prefLabel xml:lang="es">ópera</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Rzeźba nagrobna</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Begravelsesskulpturer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scultura funeraria</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Sculpture funéraire</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31105">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="it">culto e setta</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kultas ir sekta</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kulter og sekter</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Cultes et sectes</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kulten en sekten</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kult i sekta</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kult und Sekte</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cultes i sectes</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">culto y sectas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">cult and sect</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">култ и секта</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kult a sekta</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31125">
    <skos:prefLabel xml:lang="sl">krst</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">chrzest</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">baptism</skos:prefLabel>
    <skos:prefLabel xml:lang="es">bautismo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Baptême</skos:prefLabel>
    <skos:prefLabel xml:lang="it">battesimo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Taufe</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Doopsel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Baptismus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">dåb</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">baptisme</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">кръщене</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">krikštas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31403">
    <skos:prefLabel xml:lang="es">sociedad gimnástica</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">towarzystwo gimnastyczne</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Turnvereniging</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="sl">gymnastické družstvo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sport-Verein</skos:altLabel>
    <skos:prefLabel xml:lang="en">gymnastic society</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">clubs gimnàstics</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Société de gymnastique</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Sportverein</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gymnastikforeninger</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gimnastų draugija</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">гимнастическо дружество</skos:prefLabel>
    <skos:prefLabel xml:lang="it">società ginnica, sportiva</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30271">
    <skos:prefLabel xml:lang="sl">puč</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Putsch</skos:prefLabel>
    <skos:prefLabel xml:lang="it">colpo di stato</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">cop d'estat</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zamach</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kup</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Staatsgreep</skos:prefLabel>
    <skos:prefLabel xml:lang="es">golpe de estado</skos:prefLabel>
    <skos:altLabel xml:lang="de">Coup</skos:altLabel>
    <skos:prefLabel xml:lang="en">coup</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">valstybės perversmas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Staatsstreich</skos:altLabel>
    <skos:prefLabel xml:lang="fr">coup d'état</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">преврат</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31305">
    <skos:prefLabel xml:lang="en">class conflict</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">класов конфликт</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">klasių konfliktas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Conflit des classes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">triedny boj</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Klassenconflict</skos:prefLabel>
    <skos:prefLabel xml:lang="it">conflitto di classe</skos:prefLabel>
    <skos:prefLabel xml:lang="es">conflicto de clases</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31303"/>
    <skos:prefLabel xml:lang="ca">lluita de classes</skos:prefLabel>
    <skos:prefLabel xml:lang="da">klassekamp</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">konflikt klasowy</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Klassenkampf</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30311">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:altLabel xml:lang="de">Bergrutsch</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Landverschuiving</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Erdrutsch</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Glissement de terrain</skos:prefLabel>
    <skos:prefLabel xml:lang="es">deslizamiento de tierras</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bergsturz</skos:altLabel>
    <skos:prefLabel xml:lang="sl">lavína</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esllavissades</skos:prefLabel>
    <skos:prefLabel xml:lang="en">landslide</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nuošliauža</skos:prefLabel>
    <skos:prefLabel xml:lang="it">frana</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">свличане на почвата</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">osuwisko /osunięcie się ziemi</skos:prefLabel>
    <skos:prefLabel xml:lang="da">jordskred</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30135">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">estilo y temática artística</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ekspresjonizm</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Expressionisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Expressionisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="en">expressionism</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">expresionizmus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">ekspresionizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Expressionismus</skos:prefLabel>
    <skos:prefLabel xml:lang="it">espressionismo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">експресионизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">expressionisme (Art)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ekspressionisme</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30909">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30907"/>
    <skos:prefLabel xml:lang="lt">valstybinė šventė</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Feestdag</skos:prefLabel>
    <skos:prefLabel xml:lang="en">public holiday</skos:prefLabel>
    <skos:altLabel xml:lang="de">gesetzlicher Feiertag</skos:altLabel>
    <skos:prefLabel xml:lang="da">helligdage</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">официален празник</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">święto (państwowe )</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">štátny sviatok</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jour férié</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">dies festius</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Feiertag</skos:prefLabel>
    <skos:prefLabel xml:lang="it">giorno festivo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">festividades</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30261">
    <skos:prefLabel xml:lang="pl">fotografia abstrakcyjne</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">abstrakčioji fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">абстрактна фотография</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Photographie abstraite</skos:prefLabel>
    <skos:prefLabel xml:lang="en">abstract photography</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Fotografia abstracta</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Abstracte fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Abstrakte Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">abstrakt fotografering</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">abstraktná fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia astratta</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fotografía abstracta</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30125">
    <skos:prefLabel xml:lang="nl">Beeldhouwer</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">mosaico</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">skulptorius</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sculpteur</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rzeźbiarz</skos:prefLabel>
    <skos:prefLabel xml:lang="da">billedhuggere</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">скулптор</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bildhauer</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bildhauerin</skos:altLabel>
    <skos:prefLabel xml:lang="en">sculptor</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sochár</skos:prefLabel>
    <skos:prefLabel xml:lang="it">scultore</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escultors</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12003">
    <skos:prefLabel xml:lang="ca">negatiu blanc i negre</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativo in bianco e nero</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">черно-бял негатив</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">négatif en noir et blanc</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Schwarz-weiß Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="en">black-and-white negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">baltai juodi negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy czarno-białe</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">čiernobiele negatívy</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">zwart-wit negatief</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sort-hvide negativer</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos blanco y negro</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:altLabel xml:lang="de">schwarz-weiss Negative</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30250">
    <skos:prefLabel xml:lang="ca">músics</skos:prefLabel>
    <skos:prefLabel xml:lang="en">musician</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">музикант</skos:prefLabel>
    <skos:prefLabel xml:lang="es">músicos</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Muzikant</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Musicien</skos:prefLabel>
    <skos:altLabel xml:lang="de">Musikerin</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">hudobník</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">muzyk</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Musiker</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">muzikantas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">musicista</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="da">musiker</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31135">
    <skos:prefLabel xml:lang="bg">владика</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vyskupas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vescovo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sacerdote</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bischof</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ordinarius</skos:altLabel>
    <skos:prefLabel xml:lang="sl">biskup</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">biskup</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Évêque</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">biskopper</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31133"/>
    <skos:prefLabel xml:lang="en">bishop</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Bischop</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">bisbes</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31254">
    <skos:prefLabel xml:lang="da">arkitektonisk element</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Architectural element</skos:prefLabel>
    <skos:prefLabel xml:lang="es">elemento arquitectònico</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bauelement</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">élément architectural</skos:prefLabel>
    <skos:altLabel xml:lang="de">architektonisches Element</skos:altLabel>
    <skos:prefLabel xml:lang="it">elemento architettonico</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">architektonický prvok</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">architektūrinė detalė</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">element architektoniczny</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Architecturaal element</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">element arquitectònic</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">архитектурен елемент</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31116">
    <skos:prefLabel xml:lang="sl">kostol</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:altLabel xml:lang="de">Kirchengemeinde</skos:altLabel>
    <skos:prefLabel xml:lang="it">chiesa</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kościół</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kirche</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esglésies</skos:prefLabel>
    <skos:prefLabel xml:lang="es">iglesia</skos:prefLabel>
    <skos:prefLabel xml:lang="en">church</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kerk</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">bažnyčia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kirker</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Église</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">църква</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30142">
    <skos:prefLabel xml:lang="nl">Cultuur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kultúra</skos:prefLabel>
    <skos:prefLabel xml:lang="es">estampación</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kultur</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30100"/>
    <skos:prefLabel xml:lang="da">kultur</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">kultura</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Culture</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kultūra</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">култура</skos:prefLabel>
    <skos:prefLabel xml:lang="en">culture</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cultura</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cultura</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21000">
    <skos:prefLabel xml:lang="it">ritratto</skos:prefLabel>
    <skos:altLabel xml:lang="de">Portrait-Photographie</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Portrait-Fotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">portrætter</skos:prefLabel>
    <skos:altLabel xml:lang="de">Porträt-Fotografie</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <skos:prefLabel xml:lang="pl">portret / sportretowanie</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">портрет</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">portretas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Portrait</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="sl">portrétna fotografia</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">retrat</skos:prefLabel>
    <skos:prefLabel xml:lang="es">retratos</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Portret</skos:prefLabel>
    <skos:prefLabel xml:lang="en">portraiture</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30156">
    <skos:prefLabel xml:lang="bg">релеф</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Relieffer</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Reliëf</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rilievo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">perfomance</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">reliéf</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Relief</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Relief</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Relief</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">"Relief Płaskorzeźba / Relief"</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">relleu (Art)</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Reljefas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31240">
    <skos:prefLabel xml:lang="fr">Tramway</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tranvia, linea tranviaria</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">električková trať</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31229"/>
    <skos:prefLabel xml:lang="nl">Tramspoor</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Straßenbahnlinie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sporveje</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tramvajus/ tramvajaus bėgiai</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tramvies</skos:prefLabel>
    <skos:prefLabel xml:lang="es">complejos de edificios</skos:prefLabel>
    <skos:altLabel xml:lang="de">Straßenbahn</skos:altLabel>
    <skos:prefLabel xml:lang="pl">tramwaj</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">трамвайни релси</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">tramway</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31102">
    <skos:prefLabel xml:lang="it">buddismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">budhizmus</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">будизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Buddhisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="lt">budizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Budismo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Buddhismus</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Boeddhisme</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">Budisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Buddhism</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bouddhisme</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Buddyzm</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31307">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">religiöse Ausgrenzung</skos:altLabel>
    <skos:prefLabel xml:lang="ca">discriminació religiosa</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">dyskryminacja religijna</skos:prefLabel>
    <skos:prefLabel xml:lang="da">religiøs diskrimination</skos:prefLabel>
    <skos:prefLabel xml:lang="de">religiöse Diskriminierung</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Discimination religieuse</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">религиозна дискриминация</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Religieuze discriminatie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">religinė diskriminacija</skos:prefLabel>
    <skos:prefLabel xml:lang="it">discriminazione religiosa</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31303"/>
    <skos:prefLabel xml:lang="es">discriminación religiosa</skos:prefLabel>
    <skos:prefLabel xml:lang="en">religious discrimination</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">náboženská diskriminácia</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30908">
    <skos:prefLabel xml:lang="ca">desfilades</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30907"/>
    <skos:prefLabel xml:lang="sl">prehliadka</skos:prefLabel>
    <skos:prefLabel xml:lang="da">parader</skos:prefLabel>
    <skos:altLabel xml:lang="de">Paraden</skos:altLabel>
    <skos:prefLabel xml:lang="en">parade</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">paradas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">парад</skos:prefLabel>
    <skos:prefLabel xml:lang="es">desfiladas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Optocht</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">parada</skos:prefLabel>
    <skos:prefLabel xml:lang="it">parata, sfilata</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vorbeimarsch</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Parade</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Parade</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30136">
    <skos:prefLabel xml:lang="it">fin de siècle, fine secolo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">fin de siècle („šimtmečio pabaiga“)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Fin de siècle</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="bg">от края на 19-ти век</skos:prefLabel>
    <skos:prefLabel xml:lang="es">arte abstracto</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fi de segle</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Fin de Siecle</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">fin de siècle</skos:altLabel>
    <skos:prefLabel xml:lang="sl">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fin de siècle</skos:prefLabel>
    <skos:prefLabel xml:lang="en">fin de siècle</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31306">
    <skos:prefLabel xml:lang="es">racismo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">расизъм</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">racisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">racisme</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Racisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Racisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">racism</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rasizm</skos:prefLabel>
    <skos:prefLabel xml:lang="it">razzismo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">rasizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">rasizmus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31303"/>
    <skos:prefLabel xml:lang="de">Rassismus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12006">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">sausieji koloidiniai negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi al collodio secco</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tørre kollodium negativer</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Dry collodion Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">suchý kolódiový negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">droge collodiumglasnegatief</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos al colodión seco</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy w technice suchego kolodionu</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сух колодиев негатив</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:altLabel xml:lang="de">Trocken-Kollodium Negative</skos:altLabel>
    <skos:prefLabel xml:lang="fr">négatif verre au collodion sec</skos:prefLabel>
    <skos:prefLabel xml:lang="en">dry collodion negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">negatiu de col·lodió humit</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31402">
    <skos:altLabel xml:lang="de">Trainer</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="bg">треньор</skos:prefLabel>
    <skos:prefLabel xml:lang="en">coach</skos:prefLabel>
    <skos:prefLabel xml:lang="es">entrenador</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">entrenadors (Esport)</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">tréner</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">trænere</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">treneris</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Coach</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">trener</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Coach</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Coach</skos:prefLabel>
    <skos:altLabel xml:lang="de">Trainerin</skos:altLabel>
    <skos:prefLabel xml:lang="it">allenatore</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31136">
    <skos:prefLabel xml:lang="fr">Pape</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Pope</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Papst</skos:prefLabel>
    <skos:prefLabel xml:lang="da">paver</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">папа</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">papes</skos:prefLabel>
    <skos:prefLabel xml:lang="it">papa</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Papa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">popiežius</skos:prefLabel>
    <skos:altLabel xml:lang="de">Heiliger Vater</skos:altLabel>
    <skos:prefLabel xml:lang="en">pope</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">pápež</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Paus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31133"/>
    <skos:prefLabel xml:lang="pl">papież</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30260">
    <skos:prefLabel xml:lang="nl">Kubisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Kubisme</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="bg">кубизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">kubizm</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kubizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">cubism</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Cubisme</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kubismus</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Cubisme</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cubismo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">cubismo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kubizmus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31122">
    <skos:altLabel xml:lang="de">Zeremonien und Traditionen</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31100"/>
    <skos:prefLabel xml:lang="es">costumbres, ceremonias y tradiciones</skos:prefLabel>
    <skos:prefLabel xml:lang="en">customs, ceremonies and traditions</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Gebruiken, ceremonieën en tradities</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">papročiai, apeigos, tradicijos</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zwyczaje, ceremonie, tradycje</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ceremonier</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Moeurs, cérémonies et traditions</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zvyky, obrady a tradície</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">costums, cerimònies i tradicions</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Riten</skos:altLabel>
    <skos:prefLabel xml:lang="de">Gebräuche</skos:prefLabel>
    <skos:prefLabel xml:lang="it">costumi, cerimonie e tradizioni</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">обичаи, церемонии и традиции</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/23000">
    <skos:prefLabel xml:lang="lt">mėgėjiška fotografija</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">fotografia amateur</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">amatérska fotografia</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/20000"/>
    <skos:prefLabel xml:lang="fr">Photographie amateur</skos:prefLabel>
    <skos:prefLabel xml:lang="da">amatør fotografering</skos:prefLabel>
    <skos:altLabel xml:lang="de">Amateur-Photographie</skos:altLabel>
    <skos:prefLabel xml:lang="es">fotografía amateur</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">fotografia amatorska</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fotografia amatoriale</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Amateurfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Amateurfotografie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">amateur photography</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="bg">любителска фотография</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30122">
    <skos:altLabel xml:lang="de">Musikgesellschaft</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Muziekvereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="it">società di musica</skos:prefLabel>
    <skos:prefLabel xml:lang="es">artes gráficas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">musical society</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">музикално дружество</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hudobná spoločnosť</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="lt">muzikų draugija</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">towarzystwo muzyczne</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Musikverein</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Société musicale</skos:prefLabel>
    <skos:prefLabel xml:lang="da">musikforeninger</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">grups musicals</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31253">
    <skos:prefLabel xml:lang="lt">ornamentas/ puošybinis elementas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Ornament</skos:altLabel>
    <skos:prefLabel xml:lang="fr">ornement</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">орнамент</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ornament</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">ornamento</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ornamento</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:altLabel xml:lang="de">Schmuckstück</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Ornament</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Verzierung</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31117">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">mauzoleum</skos:prefLabel>
    <skos:prefLabel xml:lang="da">mausoleer</skos:prefLabel>
    <skos:prefLabel xml:lang="it">maudoleo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">мавзолей</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31114"/>
    <skos:prefLabel xml:lang="fr">Mausolée</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">mauzoliejus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">mausoleo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">mausoleum</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Mausoleum</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Mausoleum</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">mauzóleum</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mausoleus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30157">
    <skos:prefLabel xml:lang="de">Reliquien-Figur</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Relikwiarz</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Relikvinė figūra</skos:prefLabel>
    <skos:prefLabel xml:lang="it">reliquiario</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Reliquary figure</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Relikviefigurer</skos:prefLabel>
    <skos:prefLabel xml:lang="es">teatro</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">relikviár</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Reliek</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Reliquaire</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">реликварна фигура</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">reliquiaris</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21001">
    <skos:prefLabel xml:lang="ca">retrat de pla general</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ten voeten uit</skos:prefLabel>
    <skos:altLabel xml:lang="de">in Lebensgröße</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="fr">en pied</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">celok</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">w całej postaci</skos:prefLabel>
    <skos:prefLabel xml:lang="en">full length</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">цял ръст</skos:prefLabel>
    <skos:prefLabel xml:lang="da">fuld længde</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">plano general</skos:prefLabel>
    <skos:prefLabel xml:lang="it">campo lungo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">visu ūgiu</skos:prefLabel>
    <skos:prefLabel xml:lang="de">volle Länge</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30143">
    <skos:prefLabel xml:lang="it">costumi e tradizioni</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">tradycje i zwyczaje</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30142"/>
    <skos:prefLabel xml:lang="nl">Gebruiken en tradities</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">costums i tradicions</skos:prefLabel>
    <skos:prefLabel xml:lang="en">customs and traditions</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gewohnheiten und Traditionen</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">papročiai ir tradicijos</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Us et coutumes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zvyky a tradície</skos:prefLabel>
    <skos:prefLabel xml:lang="da">traditioner</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">arte religioso</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">обичаи и традиции</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31308">
    <skos:prefLabel xml:lang="ca">sexisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sexisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">sexism</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31303"/>
    <skos:prefLabel xml:lang="nl">Seksisme</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сексизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sexizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sexismo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Sexismus</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">saksizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sessismo</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">seksizm</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sexisme</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31103">
    <skos:prefLabel xml:lang="lt">krikščionybė</skos:prefLabel>
    <skos:altLabel xml:lang="de">christlicher Glaube</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="pl">Chrześcijaństwo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Cristianisme</skos:prefLabel>
    <skos:altLabel xml:lang="de">Christenheit</skos:altLabel>
    <skos:prefLabel xml:lang="en">Christianity</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">христианство</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">Cristiandad</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Christenstum</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Christendom</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Kristendom</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cristianesimo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Christianisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">kresťanstvo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31401">
    <skos:altLabel xml:lang="de">Sportlerin</skos:altLabel>
    <skos:prefLabel xml:lang="da">atleter</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">atletes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">atlét</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">athlete</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">atletas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31400"/>
    <skos:prefLabel xml:lang="bg">спортист</skos:prefLabel>
    <skos:altLabel xml:lang="de">Athlet</skos:altLabel>
    <skos:prefLabel xml:lang="de">Sportler</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">lekkoatleta / sportowiec</skos:prefLabel>
    <skos:prefLabel xml:lang="es">atleta</skos:prefLabel>
    <skos:prefLabel xml:lang="it">atleta</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Athlète</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Athleet</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30273">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">forma d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="it">forma d'arte</skos:prefLabel>
    <skos:prefLabel xml:lang="es">forma de arte</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">форма на изкуство</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">umelecká forma</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Kunstform</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kunstform</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">formą sztuki</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30101"/>
    <skos:prefLabel xml:lang="lt">meno forma</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">forme d'art</skos:prefLabel>
    <skos:prefLabel xml:lang="en">art forms</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kunstvorm</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12005">
    <skos:prefLabel xml:lang="da">klichéer-Verre</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="ca">negatiu de vidre</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi su vetro</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativo de cristal</skos:prefLabel>
    <skos:altLabel xml:lang="de">Glasklischee-Druck</skos:altLabel>
    <skos:prefLabel xml:lang="de">Clichés-verre</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">клишѐ верѐ</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">clichés-verre</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">clichés-verre</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">clichés-verre</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">klisza szklana</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">clichés-verre</skos:prefLabel>
    <skos:prefLabel xml:lang="en">clichés-verre</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31123">
    <skos:prefLabel xml:lang="fr">Funérailles</skos:prefLabel>
    <skos:altLabel xml:lang="de">Begräbnis</skos:altLabel>
    <skos:altLabel xml:lang="de">Bestattung</skos:altLabel>
    <skos:prefLabel xml:lang="lt">laidotuvės</skos:prefLabel>
    <skos:prefLabel xml:lang="it">funerale</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Beerdigung</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Begrafenis</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">pogrzeb</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">погребение</skos:prefLabel>
    <skos:prefLabel xml:lang="es">funeral</skos:prefLabel>
    <skos:prefLabel xml:lang="en">funeral</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">exèquies</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">pohreb</skos:prefLabel>
    <skos:prefLabel xml:lang="da">begravelser</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30137">
    <skos:prefLabel xml:lang="nl">Impressionisme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Impressionisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">impressionisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">impressionisme (Art)</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">impresionizmas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="pl">impresjonizm</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">impresionizmus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">alegoría</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Impressionismus</skos:prefLabel>
    <skos:prefLabel xml:lang="en">impressionism</skos:prefLabel>
    <skos:prefLabel xml:lang="it">impressionismo</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">импресионизъм</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31137">
    <skos:prefLabel xml:lang="da">imamer</skos:prefLabel>
    <skos:prefLabel xml:lang="es">imán</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">imams</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Iman</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">imam</skos:prefLabel>
    <skos:prefLabel xml:lang="it">imam</skos:prefLabel>
    <skos:prefLabel xml:lang="en">imam</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31133"/>
    <skos:prefLabel xml:lang="sl">imám</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Imam</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Imam</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">imamas</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">имам</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30123">
    <skos:prefLabel xml:lang="da">digtere</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">básnik</skos:prefLabel>
    <skos:prefLabel xml:lang="en">poet</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Poète</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">поет</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">poeta</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">poeta</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">poetas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">poetes</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Poet</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dichter</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:altLabel xml:lang="de">Poetin</skos:altLabel>
    <skos:altLabel xml:lang="de">Dichter</skos:altLabel>
    <skos:prefLabel xml:lang="es">cristalería</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30907">
    <skos:prefLabel xml:lang="da">ferie</skos:prefLabel>
    <skos:altLabel xml:lang="de">Urlaub</skos:altLabel>
    <skos:prefLabel xml:lang="bg">празник</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">poilsio diena/šventė</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vacances</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Vakantie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Ferien</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <skos:prefLabel xml:lang="it">vacanza</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Vacances</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">holiday</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wakacje / święto</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">dovolenka, prázdniny</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vacaciones</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31110">
    <skos:prefLabel xml:lang="nl">Natuurreligie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="es">teología natural</skos:prefLabel>
    <skos:prefLabel xml:lang="da">naturreligioner</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">prírodné náboženstvá</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">пантеизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Teologia natural</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">animizm</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">gamtos religija</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Religion de la nature</skos:prefLabel>
    <skos:prefLabel xml:lang="it">religione naturalistica</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Naturreligion</skos:prefLabel>
    <skos:prefLabel xml:lang="en">nature religion</skos:prefLabel>
    <skos:altLabel xml:lang="de">Natur-Religion</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21002">
    <skos:prefLabel xml:lang="ca">retrat de pla mig</skos:prefLabel>
    <skos:prefLabel xml:lang="es">plano medio</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nuotrauka iki pusės</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">ujęcie do pasa</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">среден план</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Medium shot</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Driekwart</skos:prefLabel>
    <skos:altLabel xml:lang="de">Halbnahe</skos:altLabel>
    <skos:prefLabel xml:lang="fr">en trois quarts</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">polocelok</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="en">medium shot</skos:prefLabel>
    <skos:prefLabel xml:lang="it">campo medio</skos:prefLabel>
    <skos:prefLabel xml:lang="da">medium foto</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30158">
    <skos:prefLabel xml:lang="sl">ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="it">ready-made</skos:prefLabel>
    <skos:altLabel xml:lang="de">konfektioniert</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">fabryczny</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Ready-made</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Fertigware</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">промишлено произведен</skos:prefLabel>
    <skos:prefLabel xml:lang="es">arte y actores de la cultura</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">„Ready-made“ (fabrikinės gamybos daiktas, gavęs  meno kūrinio statusą)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Brugskunst</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30809">
    <skos:prefLabel xml:lang="es">barrio</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="lt">parduotuvė</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">obchod</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">shop</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Winkel</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Laden</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Magasin</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sklep</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">botigues</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">магазин</skos:prefLabel>
    <skos:altLabel xml:lang="de">Geschäft</skos:altLabel>
    <skos:prefLabel xml:lang="it">negozio</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Shop</skos:prefLabel>
    <skos:prefLabel xml:lang="da">butikker</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31100">
    <skos:prefLabel xml:lang="es">religión y fé</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Religion und Glaube</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="it">religione e fede</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">náboženstvo a viera</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wiara i religia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">religion</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">религия и вяра</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">religija ir tikėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">religions i creences</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Religie en geloof</skos:prefLabel>
    <skos:prefLabel xml:lang="en">religion and belief</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Religion et croyances</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30819">
    <skos:prefLabel xml:lang="es">salida</skos:prefLabel>
    <skos:altLabel xml:lang="de">Strom</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="de">Fluss</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">rius</skos:prefLabel>
    <skos:prefLabel xml:lang="da">floder</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">rzeka</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Rivier</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">river</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">upė</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fiume</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">река</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Rivière</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">rieka</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30148">
    <skos:prefLabel xml:lang="it">testa</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kop</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Tête</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Galva</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Głowa</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">глава</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cap</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="es">cine</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Hoveder</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kopf</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hlava</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">Head</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30300">
    <skos:prefLabel xml:lang="it">disastro e incidenti</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">catàstrofes i accidents</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Catastrophe et accident</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ramp en ongeval</skos:prefLabel>
    <skos:altLabel xml:lang="de">Katastrophen und Unfälle</skos:altLabel>
    <skos:prefLabel xml:lang="bg">катастрофа и произшествие</skos:prefLabel>
    <skos:prefLabel xml:lang="es">desastres y accidentes</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="en">disaster and accident</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nelaimė ir nelaimingas atsitikimas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Katastrophe und Unglück</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">nešťastie a nehoda</skos:prefLabel>
    <skos:prefLabel xml:lang="da">katastrofer &amp; ulykker</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">katastrofa i wypadek</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30906">
    <skos:altLabel xml:lang="de">Hobbys</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Passe-temps</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">pomėgiai</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Hobby</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hobby</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">afeccions</skos:prefLabel>
    <skos:prefLabel xml:lang="es">aficiones</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">хоби</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hobby</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">hobby</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <skos:prefLabel xml:lang="da">hobby</skos:prefLabel>
    <skos:prefLabel xml:lang="it">hobby</skos:prefLabel>
    <skos:prefLabel xml:lang="en">hobby</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30130">
    <skos:prefLabel xml:lang="es">metalistería</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">Naujasis menas/Jugendstilius</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Secesja</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Jugendstil</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">liberty</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Ар нуво</skos:prefLabel>
    <skos:altLabel xml:lang="de">Art Nouveau</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Art Nouveau</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Art Nouveau</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Art Nouveau</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="sl">Art Nouveau / Jugendstil</skos:prefLabel>
    <skos:prefLabel xml:lang="da">art Nouveau / jugendstil</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">art nouveau</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31138">
    <skos:prefLabel xml:lang="lt">religinis konfliktas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">conflictes religiosos</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31100"/>
    <skos:prefLabel xml:lang="sl">náboženský konflikt</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">religiøse konflikter</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Conflit religieux</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">религиозен конфликт</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Religieus conflict</skos:prefLabel>
    <skos:prefLabel xml:lang="it">conflitto religioso</skos:prefLabel>
    <skos:prefLabel xml:lang="en">religious conflict</skos:prefLabel>
    <skos:prefLabel xml:lang="es">conflicto religioso</skos:prefLabel>
    <skos:prefLabel xml:lang="de">religiöser Konflikt</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">konflikt religijny</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30926">
    <skos:prefLabel xml:lang="sl">púzdra na mydlo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Zeepdoos</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Seifenkiste</skos:prefLabel>
    <skos:prefLabel xml:lang="en">soap box</skos:prefLabel>
    <skos:prefLabel xml:lang="it">portasapone</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">boite à savon</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">mydelniczki</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30923"/>
    <skos:prefLabel xml:lang="es">jaboneras (contenedores)</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Sæbeskuffe</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">saboneres (contenidors)</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сапунерка</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">muilo dėžė</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12000">
    <skos:prefLabel xml:lang="ca">negatiu</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatyw</skos:prefLabel>
    <skos:prefLabel xml:lang="da">negativ</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">negatyvas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Negatief</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:prefLabel xml:lang="fr">Négatif</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="en">negative</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/10000"/>
    <skos:prefLabel xml:lang="bg">негатив</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31051">
    <skos:prefLabel xml:lang="lt">revoliucija</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="bg">революция</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">revolució</skos:prefLabel>
    <skos:prefLabel xml:lang="en">revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="es">abolición de la esclavitud</skos:prefLabel>
    <skos:prefLabel xml:lang="da">revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="it">rivoluzione</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">revolúcia</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">rewolucja</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Revolutie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Revolution</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Révolution</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31300">
    <skos:prefLabel xml:lang="lt">visuomenė</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sociedad</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">societat</skos:prefLabel>
    <skos:prefLabel xml:lang="it">società</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">spoločnosť</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">społeczeństwo</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Gesellschaft</skos:prefLabel>
    <skos:prefLabel xml:lang="en">society</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Samenleving</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">общество</skos:prefLabel>
    <skos:prefLabel xml:lang="da">samfund</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
    <skos:prefLabel xml:lang="fr">Société</skos:prefLabel>
    <skos:altLabel xml:lang="de">Verein</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30120">
    <skos:prefLabel xml:lang="nl">Kindervereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">klub dla dzieci</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">klubber</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mouvement de jeunesse</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vaikų klubas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">pintura</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">detský klub</skos:prefLabel>
    <skos:prefLabel xml:lang="en">children's club</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">детски клуб</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">club infantil</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="it">associazione di bambini</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kinderclub</skos:prefLabel>
    <skos:altLabel xml:lang="de">Verein für Kinder</skos:altLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31128">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">Boże Narodzenie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Jul</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Kalėdos</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Navidad</skos:prefLabel>
    <skos:altLabel xml:lang="de">Weihnacht</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Noël</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Коледа</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Natale</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Weihnachten</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Vianoce</skos:prefLabel>
    <skos:altLabel xml:lang="de">Weihnachtsfest</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">Nadal</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Christmas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kerstmis</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31400">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">esports</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Sport</skos:prefLabel>
    <skos:prefLabel xml:lang="es">deporte</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sport</skos:prefLabel>
    <skos:altLabel xml:lang="de">Sportart</skos:altLabel>
    <skos:prefLabel xml:lang="de">Sport</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">спорт</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">sport</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">sport</skos:prefLabel>
    <skos:prefLabel xml:lang="da">sport</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sport</skos:prefLabel>
    <skos:prefLabel xml:lang="en">sport</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sportas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30000"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30808">
    <skos:prefLabel xml:lang="sl">pamätník</skos:prefLabel>
    <skos:prefLabel xml:lang="en">monument</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">monuments</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">паметник</skos:prefLabel>
    <skos:altLabel xml:lang="de">Baudenkmal</skos:altLabel>
    <skos:prefLabel xml:lang="da">monumenter</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">monumentas/paminklas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="pl">pomnik</skos:prefLabel>
    <skos:altLabel xml:lang="de">Denkmal</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Monument</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tienda</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Monument</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Monument</skos:prefLabel>
    <skos:prefLabel xml:lang="it">monumento</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31101">
    <skos:prefLabel xml:lang="nl">Geloof</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">вяра</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Croyances</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31100"/>
    <skos:prefLabel xml:lang="pl">wiara</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">belief</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Glaube</skos:prefLabel>
    <skos:prefLabel xml:lang="da">tro</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">creences</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">viera</skos:prefLabel>
    <skos:prefLabel xml:lang="it">fede</skos:prefLabel>
    <skos:altLabel xml:lang="de">Überzeugung</skos:altLabel>
    <skos:prefLabel xml:lang="lt">tikėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">fe</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30159">
    <skos:prefLabel xml:lang="it">dipinto</skos:prefLabel>
    <skos:prefLabel xml:lang="da">malerier</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">живопис</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tapyba</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Peinture</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Malerei</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">malarstwo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">painting</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="ca">pintura</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Schilderij</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">maľba</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">actor</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31111">
    <skos:prefLabel xml:lang="bg">шинтоизъм</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">Szintoizm</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sintoismo</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Xintoisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sintoizmas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Schintoismus</skos:altLabel>
    <skos:prefLabel xml:lang="de">Shintoismus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="it">scintoismo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="en">Shintoism</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Shintoisme</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Shintoïsme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Shintoïsme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">šintoizmus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21003">
    <skos:prefLabel xml:lang="nl">tot de borst</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Brust-Aufnahme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">bust shot</skos:prefLabel>
    <skos:prefLabel xml:lang="da">buste foto</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ujęcie w popiersiu</skos:prefLabel>
    <skos:prefLabel xml:lang="it">primo piano</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бюст</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">en buste</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">polodetail</skos:prefLabel>
    <skos:prefLabel xml:lang="es">primer plano</skos:prefLabel>
    <skos:altLabel xml:lang="de">Brustbild</skos:altLabel>
    <skos:prefLabel xml:lang="lt">biustinė nuotrauka</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">retrat de primer pla</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30149">
    <skos:prefLabel xml:lang="lt">Biustas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Popiersie</skos:prefLabel>
    <skos:prefLabel xml:lang="it">busto</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">busta</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">bust</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бюст</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">danza</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30147"/>
    <skos:prefLabel xml:lang="da">Buster</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Bust</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Buste</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Buste</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Brust</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30818">
    <skos:prefLabel xml:lang="it">montagna</skos:prefLabel>
    <skos:prefLabel xml:lang="en">mountain</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">kalnas</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hora</skos:prefLabel>
    <skos:prefLabel xml:lang="es">casa</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">muntanyes</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">bjerge</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">планина</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30815"/>
    <skos:prefLabel xml:lang="fr">Montagne</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">góra</skos:prefLabel>
    <skos:altLabel xml:lang="de">Massiv</skos:altLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Berg</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Berg</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31139">
    <skos:prefLabel xml:lang="fr">catholicisme</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">католицизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Katolicyzm</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Katholicisme</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Katholizismus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <skos:prefLabel xml:lang="en">Catholicism</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">catolicismo</skos:prefLabel>
    <skos:prefLabel xml:lang="da">katolicismen</skos:prefLabel>
    <skos:prefLabel xml:lang="it">cattolicesimo</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">katalikybė</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">catolicisme</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">katolicizmus</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30925">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30923"/>
    <skos:prefLabel xml:lang="lt">pudrinė</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">puderniiczki</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">púdrenky</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">kompakt</skos:prefLabel>
    <skos:altLabel xml:lang="de">komprimiert</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">caja de polvos</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пудриера</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Make up compact</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Make up compact</skos:prefLabel>
    <skos:prefLabel xml:lang="en">compact</skos:prefLabel>
    <skos:prefLabel xml:lang="it">portacipria</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">polvorera</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kompakt</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30905">
    <skos:prefLabel xml:lang="pl">gra /zabawa</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">žaidimas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">gioco</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="ca">jocs</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">игра</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Spel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">juego</skos:prefLabel>
    <skos:prefLabel xml:lang="da">spil</skos:prefLabel>
    <skos:altLabel xml:lang="de">Partie</skos:altLabel>
    <skos:prefLabel xml:lang="en">game</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Spiel</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30900"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">hra</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Jeu</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30131">
    <skos:prefLabel xml:lang="ca">bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="da">bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Bauhauzas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Bauhaus</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Bauhaus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">Баухаус</skos:prefLabel>
    <skos:prefLabel xml:lang="es">textil</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30301">
    <skos:altLabel xml:lang="de">Unfälle</skos:altLabel>
    <skos:altLabel xml:lang="de">Unglücksfall</skos:altLabel>
    <skos:prefLabel xml:lang="ca">accidents</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wypadek</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30300"/>
    <skos:prefLabel xml:lang="lt">nelaimingas atsitikimas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">accident</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ongeval</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">nehoda</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">произшествие</skos:prefLabel>
    <skos:prefLabel xml:lang="es">accidente</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Accident</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">ulykker</skos:prefLabel>
    <skos:prefLabel xml:lang="it">infortunio</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Unfall</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31052">
    <skos:prefLabel xml:lang="de">Sklaverei</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">niewolnictwo</skos:prefLabel>
    <skos:prefLabel xml:lang="es">movimientos sociales</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">esclavitud</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Esclavage</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Slavernij</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="en">slavery</skos:prefLabel>
    <skos:prefLabel xml:lang="it">schiavitù</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vergovė</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">робство</skos:prefLabel>
    <skos:prefLabel xml:lang="da">slaveri</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">otroctvo</skos:prefLabel>
    <skos:altLabel xml:lang="de">Knechtschaft</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31301">
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">familieliv</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vida familiar</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">vida familiar</skos:prefLabel>
    <skos:altLabel xml:lang="de">Familien-Leben</skos:altLabel>
    <skos:prefLabel xml:lang="fr">Vie en famille</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">семеен живот</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Familieleven</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31300"/>
    <skos:prefLabel xml:lang="sl">rodinný život</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Familienleben</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">życie rodzinne</skos:prefLabel>
    <skos:prefLabel xml:lang="en">family life</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vita familiare</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">šeimos gyvenimas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30121">
    <skos:prefLabel xml:lang="en">chorus</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">kor</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">chór</skos:prefLabel>
    <skos:prefLabel xml:lang="es">dibujo</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Choeur</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">zbor</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">cors (Música)</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">хор</skos:prefLabel>
    <skos:prefLabel xml:lang="it">coro</skos:prefLabel>
    <skos:altLabel xml:lang="de">Refrain</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30115"/>
    <skos:prefLabel xml:lang="nl">Koor</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Chor</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">choras</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31129">
    <skos:prefLabel xml:lang="it">Pasqua</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Wielkanoc</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Pâques</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Velykos</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Veľká noc</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Ostern</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Великден</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Pasen</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Easter</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Semana Santa</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:prefLabel xml:lang="da">Påske</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Pasqua de resurrecció</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30807">
    <skos:prefLabel xml:lang="nl">Markt</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Markt</skos:prefLabel>
    <skos:prefLabel xml:lang="es">monumento</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">пазар</skos:prefLabel>
    <skos:prefLabel xml:lang="it">mercato</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">turgus</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rynek</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">mercats</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="da">markeder</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">trh</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="fr">Marché</skos:prefLabel>
    <skos:prefLabel xml:lang="en">market</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31112">
    <skos:prefLabel xml:lang="de">Sikhismus</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">Sikhizm</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">сикхизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="es">sijismo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Sikhisme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Sikhisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Sikhisme</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Sikhism</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sikhisme</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sikizmas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">sikhizmus</skos:prefLabel>
    <skos:prefLabel xml:lang="it">sikhismo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31250">
    <skos:prefLabel xml:lang="es">tranvía</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Architektūrinis brėžinys/ piešinys</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">architektonické návrhy</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rysunek architektoniczny</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">архитектурен чертеж</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Bauzeichnung</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31227"/>
    <skos:prefLabel xml:lang="en">Architectural drawing</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">disegno architettonico</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arkitekttegninger</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Architectuurtekening</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">dibuix arquitectònic</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Dessin architectural</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30146">
    <skos:prefLabel xml:lang="nl">Journalist</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Journalist</skos:prefLabel>
    <skos:prefLabel xml:lang="da">journalistik</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">журналист</skos:prefLabel>
    <skos:altLabel xml:lang="de">Journalistin</skos:altLabel>
    <skos:prefLabel xml:lang="en">journalist</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30145"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">žurnalistas</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Journaliste</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">novinár</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="es">mitología</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">periodistes</skos:prefLabel>
    <skos:altLabel xml:lang="de">Berichterstatter</skos:altLabel>
    <skos:prefLabel xml:lang="pl">dziennikarz</skos:prefLabel>
    <skos:prefLabel xml:lang="it">giornalismo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21004">
    <skos:prefLabel xml:lang="es">primerísimo primer plano</skos:prefLabel>
    <skos:prefLabel xml:lang="en">close up</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gross-Aufnahme</skos:altLabel>
    <skos:prefLabel xml:lang="nl">Close up</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Close up</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
    <skos:prefLabel xml:lang="ca">retrat de primeríssim primer pla</skos:prefLabel>
    <skos:prefLabel xml:lang="it">primissimo piano</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">zbliżenie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">nærbillede</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nuotrauka iš arti</skos:prefLabel>
    <skos:altLabel xml:lang="de">Großaufnahme</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">detailný záber</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">близък план</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">en gros plan</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31312">
    <skos:prefLabel xml:lang="es">riqueza</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Richesse</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">riquesa</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Reichtum</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">turtas</skos:prefLabel>
    <skos:altLabel xml:lang="de">Vermögen</skos:altLabel>
    <skos:prefLabel xml:lang="da">rigdom</skos:prefLabel>
    <skos:altLabel xml:lang="de">Wohlstand</skos:altLabel>
    <skos:prefLabel xml:lang="bg">богатство</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31309"/>
    <skos:prefLabel xml:lang="en">Wealth</skos:prefLabel>
    <skos:prefLabel xml:lang="it">benessere</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">bohatstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Rijkdom</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">bogactwo</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30302">
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30301"/>
    <skos:prefLabel xml:lang="fr">Explosion</skos:prefLabel>
    <skos:prefLabel xml:lang="en">explosion</skos:prefLabel>
    <skos:prefLabel xml:lang="es">explosión</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">sprogimas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wybuch / eksplozja</skos:prefLabel>
    <skos:prefLabel xml:lang="it">esplosione</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">výbuch</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">explosions</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ontploffing</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">експлозия</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">eksplosioner</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Explosion</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30209">
    <skos:prefLabel xml:lang="de">Krimkrieg</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Krimoorlog</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Krymo karas</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra di Crimea</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Krymská vojna</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="pl">Wojna Krymska</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra de Crimea, 1853-1856</skos:prefLabel>
    <skos:altLabel xml:lang="de">Krim-Krieg</skos:altLabel>
    <skos:prefLabel xml:lang="en">Crimean war</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Кримска война</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre de Crimée</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Guerra de Crimea, 1853-1856</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">Krim-krigen</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30904">
    <skos:prefLabel xml:lang="pl">harcerze / skauci</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Scout</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">skautai</skos:prefLabel>
    <skos:altLabel xml:lang="de">Kundschafter</skos:altLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30901"/>
    <skos:prefLabel xml:lang="it">scout</skos:prefLabel>
    <skos:prefLabel xml:lang="da">spejdere</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Scouts</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Scouts</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Scouts</skos:altLabel>
    <skos:prefLabel xml:lang="es">escoltas</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">escoltes</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">skauti</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">скаути</skos:prefLabel>
    <skos:prefLabel xml:lang="en">scouts</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30132">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Belle Epoque</skos:prefLabel>
    <skos:prefLabel xml:lang="es">joyería</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">Бел епок</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="da">skønvirke</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">belle époque</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">Belle Époque/„Gražioji epocha“</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="fr">Belle époque</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="it">Belle Époque</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Belle Époque</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12002">
    <skos:altLabel xml:lang="de">Halbton-Negative</skos:altLabel>
    <skos:prefLabel xml:lang="da">halvtone negativer</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">negatywy półtonowe</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">rasternegatief</skos:prefLabel>
    <skos:altLabel xml:lang="de">Raster-Negative</skos:altLabel>
    <skos:prefLabel xml:lang="lt">pustoniniai negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Halftone Negative</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="ca">negatiu de mitja tinta</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi ai mezzi toni</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativos mediotono</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">polotónový negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">полутонови негативи</skos:prefLabel>
    <skos:prefLabel xml:lang="en">halftone negatives</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30924">
    <skos:prefLabel xml:lang="bg">флакон за парфюм</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">flakóny</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">flakony</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30923"/>
    <skos:prefLabel xml:lang="es">frasco de perfume</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">flascó de perfum</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">bottiglia di profumo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Parfumflesje</skos:prefLabel>
    <skos:prefLabel xml:lang="da">parfume flaske</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Parfüm-Flasche</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">flacon de parfum</skos:prefLabel>
    <skos:altLabel xml:lang="de">Parfum-Flakon</skos:altLabel>
    <skos:prefLabel xml:lang="en">perfume bottle</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">parfumerijos/ kvepalų buteliukas</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30312">
    <skos:prefLabel xml:lang="nl">Storm</skos:prefLabel>
    <skos:prefLabel xml:lang="es">tormentas</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">burza</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30305"/>
    <skos:prefLabel xml:lang="sl">búrka</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">буря</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">audra</skos:prefLabel>
    <skos:altLabel xml:lang="de">Orkan</skos:altLabel>
    <skos:prefLabel xml:lang="da">storm</skos:prefLabel>
    <skos:prefLabel xml:lang="en">storm</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="de">Sturm</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">tempestes</skos:prefLabel>
    <skos:prefLabel xml:lang="it">tempesta</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="fr">Orage</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31126">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">komunija</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gemeinschaft</skos:altLabel>
    <skos:prefLabel xml:lang="it">comunione</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">причастие</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Communie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">communion</skos:prefLabel>
    <skos:prefLabel xml:lang="es">comunión</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kommunion</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:prefLabel xml:lang="fr">Communion</skos:prefLabel>
    <skos:prefLabel xml:lang="da">nadver</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">primera comunió</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">komunia</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">sväté prijímanie</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31302">
    <skos:prefLabel xml:lang="fr">Vie quotidienne</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">życie codzienne</skos:prefLabel>
    <skos:prefLabel xml:lang="it">vita quotidiana</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Dagelijks leven</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">бит</skos:prefLabel>
    <skos:altLabel xml:lang="de">tägliche Leben</skos:altLabel>
    <skos:prefLabel xml:lang="en">daily life</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">bežný život</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">kasdieninis gyvenimas</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31300"/>
    <skos:altLabel xml:lang="de">Alltag</skos:altLabel>
    <skos:prefLabel xml:lang="ca">vida diària</skos:prefLabel>
    <skos:prefLabel xml:lang="da">dagligdagen</skos:prefLabel>
    <skos:prefLabel xml:lang="de">alltägliche Leben</skos:prefLabel>
    <skos:prefLabel xml:lang="es">vida cotidiana</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30270">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Ballingschap</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Verbannung</skos:altLabel>
    <skos:prefLabel xml:lang="bg">изгнание</skos:prefLabel>
    <skos:prefLabel xml:lang="da">eksil</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">exil</skos:prefLabel>
    <skos:prefLabel xml:lang="it">esilio</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">tremtis</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="en">exile</skos:prefLabel>
    <skos:prefLabel xml:lang="es">exilio</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wygnanie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">exili</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Exil</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Exil</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30806">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">хотел</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="es">mercado</skos:prefLabel>
    <skos:prefLabel xml:lang="it">albergo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="en">hotel</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">hotels</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30804"/>
    <skos:prefLabel xml:lang="da">hoteller</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">viešbutis</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Hôtel</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31113">
    <skos:prefLabel xml:lang="pl">Taoizm</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">taoizmus</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">Taoismus</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31101"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="nl">Taoïsme</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Taoïsme</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Taoisme</skos:prefLabel>
    <skos:prefLabel xml:lang="da">Taoisme</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">таоизъм</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">taoizmas</skos:prefLabel>
    <skos:prefLabel xml:lang="es">Taoismo</skos:prefLabel>
    <skos:prefLabel xml:lang="it">taoismo</skos:prefLabel>
    <skos:prefLabel xml:lang="en">Taoism</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30147">
    <skos:prefLabel xml:lang="es">artefactos</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="sl">sochárstvo</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Beeldhouwkunst</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Sculpture</skos:prefLabel>
    <skos:prefLabel xml:lang="da">skulpturer</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">escultura</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30103"/>
    <skos:prefLabel xml:lang="it">scultura</skos:prefLabel>
    <skos:prefLabel xml:lang="en">sculpture</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Skulptur</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">скулптура</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">rzeźba</skos:prefLabel>
    <skos:altLabel xml:lang="de">Plastik</skos:altLabel>
    <skos:prefLabel xml:lang="lt">skulptūra</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/21005">
    <skos:prefLabel xml:lang="ca">retrat de grup</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Portrait de groupe</skos:prefLabel>
    <skos:altLabel xml:lang="de">Gruppenportrait</skos:altLabel>
    <skos:prefLabel xml:lang="bg">групов портрет</skos:prefLabel>
    <skos:prefLabel xml:lang="en">group portrait</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">grupinis portretas</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Groepsportret</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/21000"/>
    <skos:prefLabel xml:lang="it">ritratto di gruppo</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="pl">portret grupowy</skos:prefLabel>
    <skos:prefLabel xml:lang="da">gruppe portræt</skos:prefLabel>
    <skos:prefLabel xml:lang="es">retrato de grupo</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">skupinový portrét</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"/>
    <skos:prefLabel xml:lang="de">Gruppenaufnahme</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30903">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="fr">Mouvement de jeunesse</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">detský klub</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">nens - Associacions i clubs</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">детски клуб</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="pl">klub dla dzieci</skos:prefLabel>
    <skos:prefLabel xml:lang="es">club infantil</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Kindervereniging</skos:prefLabel>
    <skos:prefLabel xml:lang="da">ungdomsklubber</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">vaikų klubas</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kinderclub</skos:prefLabel>
    <skos:prefLabel xml:lang="it">associazione di bambini</skos:prefLabel>
    <skos:prefLabel xml:lang="en">children's club</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30901"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30303">
    <skos:prefLabel xml:lang="pl">wypadek przy pracy</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">nelaimingas atsitikimas gamyboje</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Industrieel ongeval</skos:prefLabel>
    <skos:prefLabel xml:lang="da">arbejdsulykker</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30301"/>
    <skos:altLabel xml:lang="de">Arbeitsunfall</skos:altLabel>
    <skos:prefLabel xml:lang="es">accidente industrial</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">priemyselná nehoda</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Industrieunfall</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="en">industrial accident</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">промишлено произшествие</skos:prefLabel>
    <skos:altLabel xml:lang="de">Betriebsunfall</skos:altLabel>
    <skos:prefLabel xml:lang="it">disastro industriale</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">treball--Accidents</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Accident industriel</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31050">
    <skos:prefLabel xml:lang="it">movimento liberale</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">moviment liberal</skos:prefLabel>
    <skos:prefLabel xml:lang="da">liberal bevægelse</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Mouvement libéral</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="lt">liberalų judėjimas</skos:prefLabel>
    <skos:prefLabel xml:lang="en">liberal movement</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">libeálne hnutie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">esclavitud</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="nl">Liberale beweging</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">ruch liberalny</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Liberale Bewegung</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">либерално движение</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/12001">
    <skos:prefLabel xml:lang="bg">цветоразделни негативи</skos:prefLabel>
    <skos:prefLabel xml:lang="es">negativo de separación de color</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">spalvų atskyrimo negatyvai</skos:prefLabel>
    <skos:prefLabel xml:lang="en">color separation negatives</skos:prefLabel>
    <skos:prefLabel xml:lang="it">negativi a separazione di colori</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Color separation Negative</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wyciągi negatywowe barwne</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">kleurgescheiden negatief</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">farebne oddelený negatív</skos:prefLabel>
    <skos:prefLabel xml:lang="da">farveadskillelse negativer</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Technique"/>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/12000"/>
    <skos:prefLabel xml:lang="ca">negatiu de separació de color</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30208">
    <skos:prefLabel xml:lang="en">civil war</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="bg">гражданска война</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Guerre civile</skos:prefLabel>
    <skos:prefLabel xml:lang="es">guerra civil</skos:prefLabel>
    <skos:prefLabel xml:lang="it">guerra civile</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Bürgerkrieg</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wojna domowa</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">pilietinis karas</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30205"/>
    <skos:prefLabel xml:lang="sl">civilná vojna</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Burgeroorlog</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">Guerra civil</skos:prefLabel>
    <skos:altLabel xml:lang="de">Bürger-Krieg</skos:altLabel>
    <skos:prefLabel xml:lang="da">borgerkrige</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30923">
    <skos:prefLabel xml:lang="nl">Containers voor persoonlijke verzorging en hygiëne</skos:prefLabel>
    <skos:altLabel xml:lang="de">Hygienebehälter</skos:altLabel>
    <skos:prefLabel xml:lang="pl">urządzenia do pielęgnacji i higieny osobistej</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="bg">несесер</skos:prefLabel>
    <skos:prefLabel xml:lang="da">beholdere til personlig pleje og personlig hygiejne</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">&lt;contenidors per la cura i la higiene personal&gt;</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30916"/>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="es">&lt;contenedores para el aseo e higiene personal&gt;</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Containers à des fins personnelles de toilettage et de l'hygiène personelle</skos:prefLabel>
    <skos:prefLabel xml:lang="en">containers for personal grooming and personal hygiene</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Kosmetikbeutel</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">dėklas asmens priežiūros ir higienos priemonėms</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">nádobky na skrášľovacie a hygienické prípravky</skos:prefLabel>
    <skos:prefLabel xml:lang="it">&lt;contenitori di effetti per l'igiene personale&gt;</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30133">
    <skos:prefLabel xml:lang="lt">chinoiserie (Tol. Rytų stilistinis elementas)</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">Chinoiserie</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30128"/>
    <skos:prefLabel xml:lang="fr">Chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="en">chinoiserie</skos:prefLabel>
    <skos:prefLabel xml:lang="da">kineserier</skos:prefLabel>
    <skos:prefLabel xml:lang="es">bailarín</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">с китайски мотиви</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="it">cineserie</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31303">
    <skos:prefLabel xml:lang="pl">dyskryminacja</skos:prefLabel>
    <skos:prefLabel xml:lang="es">discriminación</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:altLabel xml:lang="de">Benachteiligung</skos:altLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:altLabel xml:lang="de">Ausgrenzung</skos:altLabel>
    <skos:prefLabel xml:lang="it">discriminazione</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Discrimination</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">discriminació</skos:prefLabel>
    <skos:prefLabel xml:lang="en">discrimination</skos:prefLabel>
    <skos:prefLabel xml:lang="da">diskrimination</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">diskriminácia</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Diskriminierung</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">дискриминация</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Discriminatie</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">diskriminacija</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31300"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31127">
    <skos:prefLabel xml:lang="sl">náboženstvo</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31122"/>
    <skos:prefLabel xml:lang="pl">religia</skos:prefLabel>
    <skos:prefLabel xml:lang="da">religion</skos:prefLabel>
    <skos:prefLabel xml:lang="en">religion</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="lt">religija</skos:prefLabel>
    <skos:prefLabel xml:lang="it">religione</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Religion</skos:prefLabel>
    <skos:prefLabel xml:lang="de">Religion</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">религия</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="ca">religió</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Religie</skos:prefLabel>
    <skos:prefLabel xml:lang="es">religión</skos:prefLabel>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/31040">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="sl">abdikácia</skos:prefLabel>
    <skos:prefLabel xml:lang="lt">atsistatydinimas</skos:prefLabel>
    <skos:prefLabel xml:lang="da">abdikation</skos:prefLabel>
    <skos:prefLabel xml:lang="bg">абдикация</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Abdication</skos:prefLabel>
    <skos:prefLabel xml:lang="it">abdicazione</skos:prefLabel>
    <skos:prefLabel xml:lang="es">comunismo</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">abdykacja</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Troonsafzetting</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/31039"/>
    <skos:prefLabel xml:lang="en">abdication</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">reis i sobirans-Abdicació</skos:prefLabel>
    <skos:altLabel xml:lang="de">Thronverzicht</skos:altLabel>
    <skos:prefLabel xml:lang="de">Abdankung</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
  </skos:Concept>
  <skos:Concept rdf:about="http://bib.arts.kuleuven.be/photoVocabulary/30313">
    <skos:prefLabel xml:lang="lt">nelaimingas atsitikimas namuose</skos:prefLabel>
    <skos:inScheme rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/Subject"/>
    <skos:prefLabel xml:lang="de">häuslicher Unfall</skos:prefLabel>
    <skos:prefLabel xml:lang="es">accidente doméstico</skos:prefLabel>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <skos:prefLabel xml:lang="it">incidente domestico</skos:prefLabel>
    <skos:prefLabel xml:lang="en">domestic accident</skos:prefLabel>
    <skos:prefLabel xml:lang="ca">accident domèstic</skos:prefLabel>
    <skos:prefLabel xml:lang="sl">domáca nehoda</skos:prefLabel>
    <skos:prefLabel xml:lang="fr">Accident domestique</skos:prefLabel>
    <skos:prefLabel xml:lang="nl">Ongeval thuis</skos:prefLabel>
    <skos:altLabel xml:lang="de">heimischer Unfall</skos:altLabel>
    <skos:prefLabel xml:lang="bg">домашен инцидент</skos:prefLabel>
    <skos:prefLabel xml:lang="pl">wypadek w domu</skos:prefLabel>
    <skos:prefLabel xml:lang="da">indenlandske ulykke</skos:prefLabel>
    <skos:broader rdf:resource="http://bib.arts.kuleuven.be/photoVocabulary/30301"/>
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
