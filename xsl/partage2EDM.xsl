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
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
            <xsl:if test="position() = 1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        <xsl:for-each select="lido:eventActor">
        	<dc:creator>
            	<xsl:if test="lido:actorInRole/lido:actor/lido:actorID">
              		<xsl:attribute name="rdf:resource">
                	<xsl:for-each select="lido:actorInRole/lido:actor/lido:actorID">
                  	<xsl:if test="position() = 1">
                    	<xsl:value-of select="."/>
                  	</xsl:if>
                	</xsl:for-each>
              		</xsl:attribute>
            	</xsl:if>
        	</dc:creator>
        </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event">
        <xsl:if test="(lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')">
        <xsl:for-each select="lido:eventDate">
          <dc:date>
            <xsl:for-each select="lido:date/lido:earliestDate[(../../../lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')]">
              <xsl:value-of select="."/>
            </xsl:for-each>
            <xsl:text> - </xsl:text>
            <xsl:for-each select="lido:date/lido:latestDate[(../../../lido:eventType/lido:conceptID = 'http://terminology.lido-schema.org/lido00224')]">
              <xsl:value-of select="."/>
            </xsl:for-each>
          </dc:date>
        </xsl:for-each>
        </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:objectMeasurementsWrap/lido:objectMeasurementsSet/lido:displayObjectMeasurements">
          <dc:format>
            <xsl:value-of select="."/>
          </dc:format>
        </xsl:for-each>
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
          <dc:identifier>
            <xsl:value-of select="."/>
          </dc:identifier>
        </xsl:for-each>
        <xsl:for-each select="lido:administrativeMetadata/@xml:lang">
          <dc:language>
            <xsl:value-of select="."/>
          </dc:language>
        </xsl:for-each>
        <xsl:for-each select="lido:descriptiveMetadata/@xml:lang">
          <dc:language>
            <xsl:value-of select="."/>
          </dc:language>
        </xsl:for-each>
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordRights/lido:rightsType">
          <dc:rights>
            <xsl:value-of select="."/>
          </dc:rights>
        </xsl:for-each>
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue">
          <dc:source>
            <xsl:value-of select="."/>
          </dc:source>
        </xsl:for-each>
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet/lido:subject/lido:subjectConcept/lido:term">
          <dc:subject>
            <xsl:value-of select="."/>
          </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue">
          <dc:title>
            <xsl:value-of select="."/>
          </dc:title>
        </xsl:for-each>
        <dc:type>
          <xsl:if test="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </dc:type>
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordType/lido:term">
          <dc:type>
            <xsl:value-of select="."/>
          </dc:type>
        </xsl:for-each>
        <dc:type>
          <xsl:if test="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </dc:type>
        <dcterms:medium>
          <xsl:if test="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech/lido:conceptID">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech/lido:materialsTech/lido:termMaterialsTech/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </dcterms:medium>
        <xsl:for-each select="lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet/lido:repositoryLocation/lido:namePlaceSet/lido:appellationValue">
          <dcterms:spatial>
            <xsl:value-of select="."/>
          </dcterms:spatial>
        </xsl:for-each>
        <edm:isRelatedTo>
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://www.image.ntua.gr/CHO/</xsl:text>
            <xsl:for-each select="lido:descriptiveMetadata/lido:objectRelationWrap/lido:relatedWorksWrap/lido:relatedWorkSet/lido:relatedWork/lido:object/lido:objectID">
              <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
        </edm:isRelatedTo>
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
      <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap">
        <edm:WebResource>
          <xsl:if test="lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </edm:WebResource>
      </xsl:for-each>
      <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap">
        <edm:WebResource>
          <xsl:if test="lido:recordInfoSet/lido:recordInfoLink">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:recordInfoSet/lido:recordInfoLink">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </edm:WebResource>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor">
       <xsl:if test="(.)">
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
          <xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
        </edm:Agent>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor">
        <xsl:if test="(.)">
        <skos:Concept>
          <xsl:if test="lido:actorInRole/lido:roleActor/lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:actorInRole/lido:roleActor/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <xsl:for-each select="lido:actorInRole/lido:roleActor/lido:term">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventMaterialsTech">
        <xsl:if test="(.)">
        <skos:Concept>
          <xsl:if test="lido:materialsTech/lido:termMaterialsTech/lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:materialsTech/lido:termMaterialsTech/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <xsl:for-each select="lido:materialsTech/lido:termMaterialsTech/lido:term">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventActor">
        <xsl:if test="(.)">
        <skos:Concept>
          <xsl:if test="lido:actorInRole/lido:roleActor/lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:actorInRole/lido:roleActor/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <xsl:for-each select="lido:actorInRole/lido:roleActor/lido:term">
            <skos:prefLabel>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventType">
        <xsl:if test="(.)">
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
      <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap">
        <xsl:if test="(.)">
        <skos:Concept>
          <xsl:if test="lido:classification/lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:classification/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="lido:descriptiveMetadata/lido:objectClassificationWrap/lido:objectWorkTypeWrap">
        <xsl:if test="(.)">
        <skos:Concept>
          <xsl:if test="lido:objectWorkType/lido:conceptID">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select="lido:objectWorkType/lido:conceptID">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </skos:Concept>
        </xsl:if>
      </xsl:for-each>
      <ore:Aggregation>
        <xsl:attribute name="rdf:about">
          <xsl:text>http://www.image.ntua.gr/Aggregation/</xsl:text>
          <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
            <xsl:if test="position() = 1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
        <edm:aggregatedCHO>
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://www.image.ntua.gr/CHO/</xsl:text>
            <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordID">
              <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
        </edm:aggregatedCHO>
        <xsl:for-each select="lido:administrativeMetadata/lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue">
          <xsl:if test="position() = 1">
            <edm:dataProvider>
              <xsl:value-of select="."/>
            </edm:dataProvider>
          </xsl:if>
        </xsl:for-each>
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
        <edm:isShownBy>
          <xsl:if test="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </edm:isShownBy>
        <edm:object>
          <xsl:if test="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
            <xsl:attribute name="rdf:resource">
              <xsl:for-each select="lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation/lido:linkResource">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
        </edm:object>
        <edm:provider>
          <xsl:text>Partage Plus</xsl:text>
        </edm:provider>
        <xsl:for-each select="lido:administrativeMetadata/lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsHolder/lido:legalBodyName/lido:appellationValue">
          <dc:rights>
            <xsl:value-of select="."/>
          </dc:rights>
        </xsl:for-each>
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