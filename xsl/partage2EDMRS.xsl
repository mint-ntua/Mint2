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
  
 <!-- Updated 2013-06-17 by Regine Stein: see inline comments starting with RST -->  
  
  <xsl:variable name="var0">
    <item>TEXT</item>
    <item>VIDEO</item>
    <item>IMAGE</item>
    <item>SOUND</item>
    <item>3D</item>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:apply-templates select="/lido:lidoWrap/lido:lido"/>
  </xsl:template>
  <xsl:template match="/lido:lidoWrap/lido:lido">
    <rdf:RDF>
      <edm:ProvidedCHO>
        <xsl:attribute name="rdf:about">
          <xsl:text>http://www.image.ntua.gr/CHO/</xsl:text>
          <!-- RST: Sure that we shouldn't use the lidoRecID -> better chances that it's unique if it's provided, and if not we have to generate it. Record ID is certainly not unique among different providers -->
          <!--xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID"-->
          <xsl:for-each select="lido:lidoRecID">
            <xsl:if test="position() = 1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
    <!-- RST: actors from production, creation, designing events -> dc:creator -->
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        <xsl:for-each select="lido:eventActor">
        	<dc:creator>
				<!-- RST: if no actorID given choose name (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:creator>
        </xsl:for-each>
        </xsl:if>
        <!-- RST: actors from publication events -> dc:publisher -->
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228')">
        <xsl:for-each select="lido:eventActor">
        	<dc:publisher>
				<!-- RST: if no actorID given choose name (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:publisher>
        </xsl:for-each>
        </xsl:if>
        <!-- RST: actors NOT from production, creation, designing, publication events -> dc:contributor -->
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00228'))">
        <xsl:for-each select="lido:eventActor">
        	<dc:contributor>
				<!-- RST: if no actorID given choose name (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:contributor>
        </xsl:for-each>
        </xsl:if>
        
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        <xsl:for-each select="lido:eventDate">
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
        </xsl:for-each>
        </xsl:if>
        <!-- RST: date NOT from production, creation, designing events -> dc:date -->
        <xsl:if test="not((lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00007') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00012') or (lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224'))">
        <xsl:for-each select="lido:eventDate">
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
        </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:objectMeasurementsWrap/lido:objectMeasurementsSet/lido:displayObjectMeasurements">
          <dc:format>
            <xsl:value-of select="."/>
          </dc:format>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[not(@lido:type='former')]/lido:workID">
          <dc:identifier>
            <xsl:value-of select="."/>
            <xsl:if test="../lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]"><xsl:value-of select="concat(' (', ../lido:repositoryName/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)],  ')')" /></xsl:if>
          </dc:identifier>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[@lido:type='language']/lido:term">
          <dc:language>
            <xsl:value-of select="."/>
          </dc:language>
        </xsl:for-each>
          
        <!-- RST: dc:rights applies to the resource=CHO, not the metadata -->
        <!--xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordRights/lido:rightsType"-->
        <xsl:for-each select="lido:administrativeMetadata/lido:rightsWorkWrap/lido:rightsWorkSet">
          <dc:rights>
			  <xsl:choose>
				<xsl:when test="lido:creditLine"><xsl:value-of select="lido:creditLine"/></xsl:when>
				<xsl:when test="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
				<xsl:for-each select="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
					<xsl:value-of select="."/>
					<xsl:if test="not(position()=last())"><xsl:value-of select="' / '" /></xsl:if>
				</xsl:for-each>
				</xsl:when>
			</xsl:choose>
          </dc:rights>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept">
          <dc:subject>
				<xsl:choose>
					<xsl:when test="lido:conceptID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:conceptID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())"><xsl:value-of select="' '" /></xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
          </dc:subject>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
          <dc:title>
            <xsl:value-of select="."/>
          </dc:title>
        </xsl:for-each>
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[starts-with(@lido:pref, 'alternat')]">
          <dcterms:alternative>
            <xsl:value-of select="."/>
          </dcterms:alternative>
        </xsl:for-each>
 
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(lido:term[(. = 'IMAGE') or (. = 'VIDEO') or (. = 'TEXT') or (. = '3D') or (. = 'SOUND')])]">
        	<xsl:if test="(lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term)">
            <dc:type>
				<!-- RST: if no conceptID given choose term (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:conceptID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:conceptID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:type>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType">
        	<dc:type>
				<!-- RST: if no conceptID given choose term (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:conceptID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:conceptID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:type>
        </xsl:for-each>
   
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[lower-case(@lido:type)='material']">
        	<dcterms:medium>
				<!-- RST: if no conceptID given choose term (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:conceptID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:conceptID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dcterms:medium>
        </xsl:for-each>
		<!-- RST: others - basically @lido:type='technique' -> dc:description -->        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech[not(lower-case(@lido:type)='material')]">
        	<dc:description>
				<!-- RST: if no conceptID given choose term (only first / preferred one) -->
				<xsl:choose>
					<xsl:when test="lido:conceptID">
						<xsl:attribute name="rdf:resource">
						<xsl:for-each select="lido:conceptID">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
        	</dc:description>
        </xsl:for-each>

        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[@lido:type='current']">
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
        </xsl:for-each>
        

		<!-- RST: include resourceDescription and resourceSource (= photographer) into dc:description since respective edm:WebResource properties are not available / displayed -->
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceDescription">
        <dc:description>
				<xsl:if test="@lido:type"><xsl:value-of select="concat(@lido:type, ': ')" /></xsl:if>
				<xsl:value-of select="." />
        </dc:description>
      </xsl:for-each>
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceSource">
        <dc:description>
			<xsl:for-each select="lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            <xsl:if test="position() = 1">
				<xsl:if test="../../@lido:type"><xsl:value-of select="concat(../../@lido:type, ': ')" /></xsl:if>
				<xsl:value-of select="." />
			</xsl:if>
			</xsl:for-each>
        </dc:description>
      </xsl:for-each>
        
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
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:objectDescriptionWrap/lido:objectDescriptionSet[lido:descriptiveNoteValue/string-length(.)&gt;0]">
			<dc:description>
				<xsl:if test="lido:descriptiveNoteValue[1]/@xml:lang">
					<xsl:attribute name="xml:lang">
						<xsl:value-of select="lido:descriptiveNoteValue[1]/@xml:lang" />
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
		
		
      </edm:ProvidedCHO>
      
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation/lido:linkResource]">
        <xsl:if test="lido:resourceRepresentation/lido:linkResource">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
            <xsl:for-each select="lido:resourceRepresentation/lido:linkResource">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
            </xsl:attribute>
				<xsl:for-each select="lido:rightsResource">
				  <dc:rights>
				  <xsl:choose>
						<xsl:when test="lido:creditLine"><xsl:value-of select="lido:creditLine"/></xsl:when>
						<xsl:when test="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
						<xsl:for-each select="lido:rightsHolder/lido:legalBodyName/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())"><xsl:value-of select="' / '" /></xsl:if>
						</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				  </dc:rights>
				</xsl:for-each>
        </edm:WebResource>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink">
        <edm:WebResource>
            <xsl:attribute name="rdf:about">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
            </xsl:attribute>
        </edm:WebResource>
      </xsl:for-each>
      
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor">
       <xsl:if test="lido:actorInRole/lido:actor/lido:actorID">
        <edm:Agent>
          <xsl:if test="lido:actorInRole/lido:actor/lido:actorID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- RST: pref="alternative" -> altLabel -->
          <!--xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each-->
          <xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[@lido:pref='preferred' or not(@lido:pref)]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </edm:Agent>
        </xsl:if>
      </xsl:for-each>
      
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor/lido:actorInRole/lido:roleActor">
        <xsl:if test="lido:conceptID">
        <skos:Concept>
          <xsl:if test="lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- RST: @lido:pref='alternative' -> altLabel -->
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      

      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech">
        <xsl:if test="lido:conceptID">
        <skos:Concept>
          <xsl:if test="lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- RST: @lido:pref='alternative' -> altLabel -->
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      
      
       <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventType">
        <xsl:if test="lido:conceptID">
        <skos:Concept>
          <xsl:if test="lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(starts-with(@lido:type, 'europeana'))]">
        <xsl:if test="lido:conceptID">
        <skos:Concept>
          <xsl:if test="lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- RST: @lido:pref='alternative' -> altLabel -->
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      
      
      <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType">
        <xsl:if test="lido:conceptID">
        <skos:Concept>
          <xsl:if test="lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- RST: @lido:pref='alternative' -> altLabel -->
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      

	  <!-- RST: subjectConcept is skos:Concept -->
      <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept">
        <!--xsl:if test="(lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:conceptID)"-->
        <xsl:if test="lido:conceptID">
        <skos:Concept>
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          
          <!-- RST: @lido:pref='alternative' -> altLabel -->
          <xsl:for-each select="lido:term[@lido:pref='preferred' or (not(@lido:pref) and not(@lido:addedSearchTerm='yes'))]">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <xsl:for-each select="lido:term[starts-with(@lido:pref, 'alternat')]">
            <skos:altLabel>
              <xsl:value-of select="."/>
            </skos:altLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>      
 
      <ore:Aggregation>
        <xsl:attribute name="rdf:about">
          <xsl:text>http://www.image.ntua.gr/Aggregation/</xsl:text>
          <!-- RST: Sure that we shouldn't use the lidoRecID -> better chances that it's unique if it's provided, and if not we have to generate it. Record ID is certainly not unique among different providers -->
          <!--xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID"-->
          <xsl:for-each select="lido:lidoRecID">
            <xsl:if test="position() = 1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        <edm:aggregatedCHO>
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://www.image.ntua.gr/CHO/</xsl:text>
          <!--xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID"-->
          <xsl:for-each select="lido:lidoRecID">
              <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
        </edm:aggregatedCHO>
        
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

        <edm:isShownAt>
          <xsl:if test="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </edm:isShownAt>
        
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master' or not(@lido:type)]">
          <xsl:if test="position() = 1">
			<edm:isShownBy>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="lido:linkResource"/>
				</xsl:attribute>
			</edm:isShownBy>
          </xsl:if>
       </xsl:for-each>

        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_thumb' or not(@lido:type)]">
          <xsl:if test="position() = 1">
			<edm:object>
				<xsl:attribute name="rdf:resource">
                  <xsl:value-of select="lido:linkResource"/>
				</xsl:attribute>
			</edm:object>
          </xsl:if>
       </xsl:for-each>

        <edm:provider>
          <xsl:text>Partage Plus</xsl:text>
        </edm:provider>
        
        
        <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:rightsResource/lido:rightsType/lido:term">
          <xsl:if test="position() = 1">
            <edm:rights>
              <xsl:value-of select="."/>
            </edm:rights>
          </xsl:if>
        </xsl:for-each>
      </ore:Aggregation>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>