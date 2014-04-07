<?xml version="1.0" encoding="UTF-8"?>
<!--

  XSL Transform to convert LIDO XML data, according to http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd, 
	into ESE XML, according to http://www.europeana.eu/schemas/ese/ESE-V3.4.xsd

  By Regine Stein, Deutsches Dokumentationszentrum für Kunstgeschichte - Bildarchiv Foto Marburg, Philipps-Universität Marburg
  Provided for Linked Heritage project, 2012-11-20. 

  version2, 2012-04-27: Updated according to LIDO v1.0 to ESE v3.4 mapping document.
  version3, 2012-11-20: lido:classification[@lido:type="classification" mapped to dc:language (previously: dc:type)
								  no output of lido:eventType if creation or production
								  amended output of lido:subjectEvent
								  change mapping from dcterms:extent to dc:format
  version3.1, 2012-12-14: for eventType="provenance" information is mapped to dcterms:provenance
								  no output of repositorySet without repositoryName in dc:description

  Note: Handling of language variants is as follows:
	For all LIDO elements that map to a DC element any language variant available is transformed to ESE, each qualified by xml:lang attribute, thereby 
		providing a mechanism to control search and display for different languages.

-->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:ns0="http://www.lido-schema.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:xml="http://www.w3.org/XML/1998/namespace" 
	xmlns:lido="http://www.lido-schema.org" 
    xmlns:europeana="http://www.europeana.eu/schemas/ese/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
	exclude-result-prefixes="lido xs fn">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="provider">Linked Heritage</xsl:param>
	<xsl:param name="europeana-default-output">full-transform</xsl:param>
	<xsl:param name="europeana-rights">http://www.europeana.eu/rights/unknown/</xsl:param>
	
	<xsl:template match="/">
		<europeana:metadata 
			xmlns:europeana="http://www.europeana.eu/schemas/ese/" 
			xmlns:dcmitype="http://purl.org/dc/dcmitype/" 
			xmlns:dc="http://purl.org/dc/elements/1.1/" 
			xmlns:dcterms="http://purl.org/dc/terms/">
			<xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="'http://www.europeana.eu/schemas/ese/ http://www.europeana.eu/schemas/ese/ESE-V3.4.xsd'"/>
			<xsl:for-each select=".//lido:lido">
			
			<xsl:variable name="europeana-output">
				<xsl:choose>
					<xsl:when test="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordRights/lido:rightsType/lido:term[contains(., 'mandatory only')]">mandatory-only</xsl:when>
					<xsl:when test="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordRights/lido:rightsType/lido:term[contains(., 'no descriptions')]">no-descriptions</xsl:when>
					<xsl:otherwise><xsl:value-of select="$europeana-default-output"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
				
				<xsl:choose>

				<!-- multipleResources: create ESE record for EACH resource -->
				<xsl:when test="contains(lido:administrativeMetadata[1]/lido:recordWrap/lido:recordType/lido:term[1], '/multipleResources')">
					<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[count(not(lido:resourceRepresentation/lido:linkResource='')) &gt; 0]">
						<europeana:record>

					<xsl:for-each select="../../../lido:descriptiveMetadata">
						<xsl:choose>
							<xsl:when test="$europeana-output='mandatory-only'">
								<xsl:call-template name="descriptiveMetadata-mandatory-only" />
							</xsl:when>
							<xsl:when test="$europeana-output='no-descriptions'">
								<xsl:call-template name="descriptiveMetadata-no-descriptions"><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="descriptiveMetadata-full-transform"><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					<xsl:for-each select="../..">
						<xsl:call-template name="work" />
						<xsl:call-template name="record" />
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="$europeana-output='mandatory-only'" />
						<xsl:when test="$europeana-output='no-descriptions'" />
						<xsl:otherwise>
							<xsl:call-template name="resource" />
							<xsl:call-template name="resourceView" />
							<xsl:for-each select="../../..//lido:term[@lido:addedSearchTerm = 'yes'][string-length(.)&gt;0]
								| ../../..//lido:appellationValue[starts-with(@lido:pref, 'alternat')][string-length(.)&gt;0]
								| ../../..//lido:legalBodyName[not(position() = 1)]/lido:appellationValue[string-length(.)&gt;0]
								| ../../..//lido:partOfPlace//lido:appellationValue[string-length(.)&gt;0]
								| ../../..//lido:placeClassification/lido:term[string-length(.)&gt;0]
								">
									<europeana:unstored>
										<xsl:value-of select="." />
									</europeana:unstored>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>

<!-- Europeana elements in requested order --> 
					<xsl:choose>
						<xsl:when test="lido:resourceRepresentation[@lido:type='image_thumb']">
							<europeana:object>
								<xsl:value-of select="lido:resourceRepresentation[@lido:type='image_thumb']/lido:linkResource[1]" />
							</europeana:object>
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="lido:resourceRepresentation[string-length(lido:linkResource)&gt;0]">
							<xsl:if test="position() = 1">
								<europeana:object>
									<xsl:value-of select="lido:linkResource" />
								</europeana:object>
							</xsl:if>
						</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>

					<europeana:provider><xsl:value-of select="$provider" /></europeana:provider>

					<europeana:type>
						<xsl:value-of select="../../../lido:descriptiveMetadata[1]/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[@lido:type = 'europeana:type'][1]/lido:term[string-length(.)&gt;0][1]" />
					</europeana:type>

					<europeana:rights>
						<xsl:choose>
							<xsl:when test="lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]">
								<xsl:value-of select="lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="$europeana-rights"/></xsl:otherwise>
						</xsl:choose>
					</europeana:rights>

					<europeana:dataProvider>
					<xsl:choose>
						<xsl:when test="../../lido:recordWrap/lido:recordSource[@lido:type='europeana:dataProvider']">
							<xsl:value-of select="../../lido:recordWrap/lido:recordSource[@lido:type='europeana:dataProvider']/lido:legalBodyName/lido:appellationValue[string-length(.)&gt;0][1]" />
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="../../lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue[string-length(.)&gt;0][1]">
							<xsl:value-of select="." />
							<xsl:if test="position()!=last()">
								<xsl:text> / </xsl:text>
							</xsl:if>
						</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					</europeana:dataProvider>

					<xsl:for-each select="../../lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink[string-length(.)&gt;0]">
						<xsl:if test="position() = 1">
							<europeana:isShownAt>
								<xsl:value-of select="." />
							</europeana:isShownAt>
						</xsl:if>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="lido:resourceRepresentation[@lido:type='image_master']">
							<europeana:isShownBy>
								<xsl:value-of select="lido:resourceRepresentation[@lido:type='image_master']/lido:linkResource[1]" />
							</europeana:isShownBy>
						</xsl:when>
						<xsl:when test="not(../../lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink)">
							<xsl:for-each select="lido:resourceRepresentation[string-length(lido:linkResource)&gt;0]">
							<xsl:if test="position() = 1">
								<europeana:isShownBy>
									<xsl:value-of select="lido:linkResource" />
								</europeana:isShownBy>
							</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</europeana:record>											
								</xsl:for-each>
					</xsl:when>

					<xsl:otherwise>

				<europeana:record>

					<xsl:for-each select="lido:descriptiveMetadata">
						<xsl:choose>
							<xsl:when test="$europeana-output='mandatory-only'">
								<xsl:call-template name="descriptiveMetadata-mandatory-only" />
							</xsl:when>
							<xsl:when test="$europeana-output='no-descriptions'">
								<xsl:call-template name="descriptiveMetadata-no-descriptions"><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="descriptiveMetadata-full-transform"><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select="lido:administrativeMetadata">
						<xsl:call-template name="work" />
						<xsl:call-template name="record" />
					</xsl:for-each>
					<xsl:choose>
					<!-- mandatory-only: no further elements are transformed to ese -->
						<xsl:when test="$europeana-output='mandatory-only'" />
						<xsl:when test="$europeana-output='no-descriptions'" />
						<xsl:otherwise>
							<!-- full information of the lido record is transformed to ese -->
							<xsl:for-each select="lido:administrativeMetadata">
								<xsl:for-each select="lido:resourceWrap/lido:resourceSet[count(not(lido:resourceRepresentation/lido:linkResource='')) &gt; 0][1]">
									<xsl:call-template name="resource" />
									<xsl:call-template name="resourceView" />
								</xsl:for-each>
							</xsl:for-each>
					
							<xsl:for-each select=".//lido:term[@lido:addedSearchTerm = 'yes'][string-length(.)&gt;0]
								| .//lido:appellationValue[starts-with(@lido:pref, 'alternat')][string-length(.)&gt;0]
								| .//lido:legalBodyName[not(position() = 1)]/lido:appellationValue[string-length(.)&gt;0]
								| .//lido:partOfPlace//lido:appellationValue[string-length(.)&gt;0]
								| .//lido:placeClassification/lido:term[string-length(.)&gt;0]
								">
									<europeana:unstored>
										<xsl:value-of select="." />
									</europeana:unstored>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>

<!-- Europeana elements in requested order --> 

						<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_thumb'][string-length(lido:linkResource)&gt;0]">
							<xsl:if test="position() = 1">
								<europeana:object>
									<xsl:value-of select="lido:linkResource" />
								</europeana:object>
							</xsl:if>
						</xsl:for-each>

					<europeana:provider><xsl:value-of select="$provider" /></europeana:provider>

					<europeana:type>
						<xsl:value-of select="lido:descriptiveMetadata[1]/lido:objectClassificationWrap/lido:classificationWrap/lido:classification[@lido:type = 'europeana:type'][1]/lido:term[string-length(.)&gt;0][1]" />
					</europeana:type>

					<europeana:rights>
					<xsl:choose>
						<xsl:when test="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation[@lido:type='image_master' and string-length(lido:linkResource)&gt;0] and lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]]">
							<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation[@lido:type='image_master'][string-length(lido:linkResource)&gt;0]]/lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]">
								<xsl:if test="position() = 1">
									<xsl:value-of select="." />
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation[string-length(lido:linkResource)&gt;0] and lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]]">
							<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[lido:resourceRepresentation[string-length(lido:linkResource)&gt;0]]/lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]">
								<xsl:if test="position() = 1">
									<xsl:value-of select="." />
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet[lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]]">
							<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet/lido:rightsResource/lido:rightsType/lido:term[@lido:pref='preferred'][starts-with(., 'http://www.europeana.eu/rights') or starts-with(., 'http://creativecommons.org')]">
								<xsl:if test="position() = 1">
									<xsl:value-of select="." />
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$europeana-rights"/></xsl:otherwise>
					</xsl:choose>
					</europeana:rights>

					<europeana:dataProvider>
					<xsl:choose>
						<xsl:when test="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordSource[@lido:type='europeana:dataProvider']">
							<xsl:value-of select="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordSource[@lido:type='europeana:dataProvider']/lido:legalBodyName/lido:appellationValue[string-length(.)&gt;0][1]" />
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordSource/lido:legalBodyName/lido:appellationValue[string-length(.)&gt;0][1]">
							<xsl:value-of select="." />
							<xsl:if test="position()!=last()">
								<xsl:text> / </xsl:text>
							</xsl:if>
						</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					</europeana:dataProvider>

					<xsl:for-each select="lido:administrativeMetadata[1]/lido:recordWrap/lido:recordInfoSet/lido:recordInfoLink[string-length(.)&gt;0]">
						<xsl:if test="position() = 1">
							<europeana:isShownAt>
								<xsl:value-of select="." />
							</europeana:isShownAt>
						</xsl:if>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master'][string-length(lido:linkResource)&gt;0]">
						<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[@lido:type='image_master'][string-length(lido:linkResource)&gt;0]">
							<xsl:if test="position() = 1">
								<europeana:isShownBy>
									<xsl:value-of select="lido:linkResource" />
								</europeana:isShownBy>
							</xsl:if>
						</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="lido:administrativeMetadata[1]/lido:resourceWrap/lido:resourceSet/lido:resourceRepresentation[string-length(lido:linkResource)&gt;0]">
								<xsl:if test="position() = 1">
									<europeana:isShownBy>
										<xsl:value-of select="lido:linkResource" />
									</europeana:isShownBy>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>

				</europeana:record>					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</europeana:metadata>
	</xsl:template>
	
	<xsl:template name="descriptiveMetadata-mandatory-only">
	<!-- only mandatory  elements lido:objectWorkType -> dc:type and lido:titleSet -> dc:title are transformed -->
		<xsl:variable name="desclang">
			<xsl:value-of select="@xml:lang" />
		</xsl:variable>
					<xsl:call-template name="titleSet"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="objectWorkType"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

	</xsl:template>

	<xsl:template name="descriptiveMetadata-full-transform">
	<!-- full information of lido record is transformed -->
	<xsl:param name="europeana-output" />
					<xsl:variable name="desclang">
						<xsl:value-of select="@xml:lang" />
					</xsl:variable>

					<xsl:call-template name="titleSet"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="objectWorkType"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="classification"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:for-each select="lido:objectIdentificationWrap/lido:objectDescriptionWrap/lido:objectDescriptionSet[lido:descriptiveNoteValue/string-length(.)&gt;0]">
						<dc:description>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="lido:descriptiveNoteValue[1]/@xml:lang"><xsl:value-of select="lido:descriptiveNoteValue[1]/@xml:lang" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
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

					<xsl:for-each select="lido:objectIdentificationWrap/lido:inscriptionsWrap/lido:inscriptions">
						<xsl:variable name="type">
							<xsl:choose>
								<xsl:when test="@lido:type"><xsl:value-of select="concat(@lido:type, ': ')" /></xsl:when>
								<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Inschrift: </xsl:when>
								<xsl:otherwise>Inscription: </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="instrans">
							<xsl:choose>
								<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Transkription</xsl:when>
								<xsl:otherwise>transcription</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="insdesc">
							<xsl:choose>
								<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Beschreibung</xsl:when>
								<xsl:otherwise>description</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:for-each select="lido:inscriptionTranscription">
						<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
							<xsl:value-of select="concat($type, ., ' [', $instrans, ']')" />
						</dc:description>
						</xsl:for-each>
						<xsl:for-each select="lido:inscriptionDescription[lido:descriptiveNoteValue/string-length(.)&gt;0]">
						<dc:description>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="lido:descriptiveNoteValue[1]/@xml:lang"><xsl:value-of select="lido:descriptiveNoteValue[1]/@xml:lang" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="$type"/>
							<xsl:for-each select="lido:descriptiveNoteValue">
								<xsl:value-of select="concat(., ' ')"/>
							</xsl:for-each>
							<xsl:if test="string-length(lido:sourceDescriptiveNote[1])&gt;0">
								<xsl:value-of select="concat(' (', lido:sourceDescriptiveNote[1], ')')" />
							</xsl:if>
							<xsl:if test="string-length(lido:descriptiveNoteID[1])&gt;0">
								<xsl:value-of select="concat(' (ID: ', lido:descriptiveNoteID[1], ')')" />
							</xsl:if>
							<xsl:value-of select="concat(' [', $insdesc, ']')" />
						</dc:description>
						</xsl:for-each>
					</xsl:for-each>

					<xsl:for-each select="lido:objectIdentificationWrap/lido:displayStateEditionWrap/*[string-length(.)&gt;0]">
						<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
							<xsl:value-of select="concat(substring-after(name(), 'display'), ': ', .)" />
						</dc:description>
					</xsl:for-each>

					<xsl:for-each select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[not(@lido:type='former')]/lido:workID[string-length(.)&gt;0]">
						<dc:identifier>
						   <xsl:attribute name="xml:lang"><xsl:value-of select="$desclang" /></xsl:attribute>
						   <xsl:value-of select="concat(@lido:type, ' ',.)"/>						           
						</dc:identifier>
					</xsl:for-each>

					<xsl:for-each select="lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet[.//lido:appellationValue]">
						<xsl:variable name="qualifier">
							<xsl:choose>
								<xsl:when test="@lido:type='former' and ($desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger')">Frühere Aufbewahrung/Standort: </xsl:when>
								<xsl:when test="@lido:type='former'">Former Repository/Location: </xsl:when>
								<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Aufbewahrung/Standort: </xsl:when>
								<xsl:otherwise>Repository/Location: </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<dc:description>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="lido:repositoryName/lido:legalBodyName[.//lido:appellationValue][1]/lido:appellationValue[1]/@xml:lang"><xsl:value-of select="lido:repositoryName/lido:legalBodyName[.//lido:appellationValue][1]/lido:appellationValue[1]/@xml:lang" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						   <xsl:value-of select="concat($qualifier, lido:repositoryName/lido:legalBodyName[.//lido:appellationValue][1]/lido:appellationValue[1], ' ', lido:repositoryLocation/lido:namePlaceSet[.//lido:appellationValue][1]/lido:appellationValue[1])"/>
						</dc:description>
					</xsl:for-each>

					<xsl:call-template name="measurementsWrap"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:for-each select="lido:objectClassificationWrap/lido:classificationWrap/lido:classification[lower-case(@lido:type) = 'colour'
								or lower-case(@lido:type) = 'age'
								or lower-case(@lido:type) = 'object-status']/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
								<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
									<xsl:value-of select="../@lido:type" />: <xsl:value-of select="."/>
								</dc:description>
						</xsl:for-each>

					<xsl:call-template name="eventWrap"><xsl:with-param name="desclang" select="$desclang" /><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>

					<xsl:call-template name="relatedWorksWrap"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:for-each select="lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet">
						<xsl:choose>

							<xsl:when test="lido:subject">
								<xsl:for-each select="lido:subject">
									<xsl:variable name="extent"><xsl:value-of select="lido:extentSubject" /></xsl:variable>
									<xsl:call-template name="subjectConceptActorPlace"><xsl:with-param name="desclang" select="$desclang" /><xsl:with-param name="extent" select="$extent" /></xsl:call-template>
									<xsl:choose>
									<xsl:when test="lido:subjectObject/lido:object">
										<xsl:for-each select="lido:subjectObject/lido:object/lido:objectNote[string-length(.)&gt;0]">
											<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject ', $extent, ': ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject: '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:value-of select="."/>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="lido:subjectObject/lido:displayObject">
										<xsl:for-each select="lido:subjectObject/lido:displayObject[string-length(.)&gt;0]">
											<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject (', $extent, '): ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject: '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:value-of select="."/>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									</xsl:choose>
									<xsl:choose>
									<xsl:when test="lido:subjectDate/lido:date">
										<xsl:for-each select="lido:subjectDate/lido:date[string-length(lido:earliestDate)&gt;0]">
											<dc:description>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject date (', $extent, '): ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject date: '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="lido:earliestDate = lido:latestDate">
														<xsl:value-of select="lido:earliestDate"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="concat(lido:earliestDate, '-', lido:latestDate)"/>
													</xsl:otherwise>
												</xsl:choose>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="lido:subjectDate/lido:displayDate">
										<xsl:for-each select="lido:subjectDate/lido:displayDate[string-length(.)&gt;0]">
											<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject date (', $extent, '): ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject date: '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:value-of select="."/>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									</xsl:choose>
									<xsl:choose>
									<xsl:when test="lido:subjectEvent/lido:event">
										<xsl:for-each select="lido:subjectEvent/lido:event[count(not(lido:eventName/lido:appellationValue='')) &gt; 0]">
											<dc:description>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="lido:eventType/lido:term[1]/@xml:lang"><xsl:value-of select="lido:eventType/lido:term[1]/@xml:lang" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject event (', $extent, ') ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject event '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:value-of select="concat(lido:eventType/lido:term[1], ': ', lido:eventName/lido:appellationValue[1], ' (', lido:eventID, ')')"/>
												<xsl:for-each select="lido:eventActor/lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[position()=1]">
													<xsl:value-of select="concat(', ', .)" />
												</xsl:for-each>
												<xsl:choose>
													<xsl:when test="lido:eventDate/lido:displayDate"><xsl:value-of select="concat(', ', lido:eventDate/lido:displayDate)" /></xsl:when>
													<xsl:when test="lido:eventDate/lido:date"><xsl:value-of select="concat(', ', lido:eventDate/lido:date/lido:earliestDate, '-', lido:eventDate/lido:date/lido:latestDate)" /></xsl:when>
												</xsl:choose>
												<xsl:for-each select="lido:eventPlace/lido:place/lido:namePlaceSet/lido:appellationValue[position()=1]">
													<xsl:value-of select="concat(', ', .)" />
												</xsl:for-each>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="lido:subjectEvent/lido:displayEvent">
										<xsl:for-each select="lido:subjectEvent/lido:displayEvent[string-length(.)&gt;0]">
											<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:choose>
													<xsl:when test="string-length($extent)&gt;0"><xsl:value-of select="concat('Subject event (', $extent, '): ')"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="'Subject event: '"/></xsl:otherwise>
												</xsl:choose>
												<xsl:value-of select="."/>
											</dc:description>
										</xsl:for-each>
									</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="lido:displaySubject">
								<xsl:for-each select="lido:displaySubject[string-length(.)&gt;0]">
									<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dc:subject>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					
		</xsl:template>

	<xsl:template name="descriptiveMetadata-no-descriptions">
	<!-- only elements that result in other than dc:description are transformed, e.g. event and subject information IS transformed -->
	<xsl:param name="europeana-output" />
					<xsl:variable name="desclang">
						<xsl:value-of select="@xml:lang" />
					</xsl:variable>

					<xsl:call-template name="titleSet"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="objectWorkType"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="classification"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="measurementsWrap"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:call-template name="eventWrap"><xsl:with-param name="desclang" select="$desclang" /><xsl:with-param name="europeana-output" select="$europeana-output" /></xsl:call-template>

					<xsl:call-template name="relatedWorksWrap"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>

					<xsl:for-each select="lido:objectRelationWrap/lido:subjectWrap/lido:subjectSet">
						<xsl:choose>

							<xsl:when test="lido:subject">
								<xsl:for-each select="lido:subject">
									<xsl:variable name="extent"><xsl:value-of select="lido:extentSubject" /></xsl:variable>
									<xsl:call-template name="subjectConceptActorPlace"><xsl:with-param name="desclang" select="$desclang" /><xsl:with-param name="extent" select="$extent" /></xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="lido:displaySubject">
								<xsl:for-each select="lido:displaySubject[string-length(.)&gt;0]">
									<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dc:subject>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					
		</xsl:template>

	
	<xsl:template name="titleSet">
		<xsl:param name="desclang" />
					<xsl:for-each select="lido:objectIdentificationWrap/lido:titleWrap/lido:titleSet/lido:appellationValue[string-length(.)&gt;0]">
					<xsl:choose>
						<xsl:when test=" starts-with(@lido:pref, 'alternat')">
							<dcterms:alternative>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
								<xsl:value-of select="."/>
							</dcterms:alternative>
						</xsl:when>
						<xsl:otherwise>
							<dc:title>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
								<xsl:value-of select="."/>
							</dc:title>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="objectWorkType">
		<xsl:param name="desclang" />
					<xsl:for-each select="lido:objectClassificationWrap/lido:objectWorkTypeWrap/lido:objectWorkType/lido:term[string-length(.)&gt;0][not(@lido:addedSearchTerm = 'yes')]">
						<dc:type>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
							<xsl:value-of select="."/>
						</dc:type>
					</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="classification">
		<xsl:param name="desclang" />
					<xsl:for-each select="lido:objectClassificationWrap/lido:classificationWrap/lido:classification[not(contains(@lido:type, 'europeana:')) and not(contains(@lido:type, 'euroepana:'))]/lido:term[string-length(.)&gt;0][not(@lido:addedSearchTerm = 'yes')]">
						<xsl:choose>
							<xsl:when test="lower-case(../@lido:type) = 'colour'
								or lower-case(../@lido:type) = 'age'
								or lower-case(../@lido:type) = 'object-status'
								" />
							<xsl:when test="lower-case(../@lido:type) = 'language'">
								<dc:language>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
									<xsl:value-of select="."/>
								</dc:language>
							</xsl:when>
							<xsl:otherwise>
								<dc:type>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
									<xsl:value-of select="."/>
								</dc:type>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
	</xsl:template>

<xsl:template name="measurementsWrap">
		<xsl:param name="desclang" />
						<xsl:for-each select="lido:objectIdentificationWrap/lido:objectMeasurementsWrap/lido:objectMeasurementsSet">
							<xsl:choose>
								<xsl:when test="lido:displayObjectMeasurements[string-length(.)&gt;0]">
									<xsl:for-each select="lido:displayObjectMeasurements[string-length(.)&gt;0]">
									<dc:format>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dc:format>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="lido:objectMeasurements">
								<xsl:for-each select="lido:objectMeasurements">
									<xsl:variable name="qualifier">
										<xsl:choose>
											<xsl:when test="lido:qualifierMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(lido:qualifierMeasurements[string-length(.)&gt;0][1], ' ')" /></xsl:when>
											<xsl:otherwise />
										</xsl:choose>
									</xsl:variable>
									<xsl:for-each select="lido:measurementsSet[string-length(lido:measurementValue)&gt;0]">
									<dc:format>
										<xsl:attribute name="xml:lang"><xsl:value-of select="$desclang" /></xsl:attribute>
										<xsl:value-of select="$qualifier" />
										<xsl:value-of select="concat(lido:measurementType, ': ', lido:measurementValue, ' ', lido:measurementUnit)"/>
										<xsl:for-each select="../lido:extentMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(' (', ., ')')" /></xsl:for-each>
									</dc:format>
									</xsl:for-each>
									<xsl:for-each select="lido:formatMeasurements[string-length(.)&gt;0]">
										<dc:format>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat($qualifier, .)"/>
											<xsl:for-each select="../lido:extentMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(' (', ., ')')" /></xsl:for-each>
										</dc:format>
									</xsl:for-each>
									<xsl:for-each select="lido:shapeMeasurements[string-length(.)&gt;0]">
										<xsl:variable name="type">
											<xsl:choose>
												<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Form</xsl:when>
												<xsl:otherwise>Shape</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<dc:format>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat($type, ': ', $qualifier, .)"/>
											<xsl:for-each select="../lido:extentMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(' (', ., ')')" /></xsl:for-each>
										</dc:format>
									</xsl:for-each>
									<xsl:for-each select="lido:scaleMeasurements[string-length(.)&gt;0]">
										<xsl:variable name="type">
											<xsl:choose>
												<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Ausmaß</xsl:when>
												<xsl:otherwise>Scale</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<dc:format>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat($type, ': ', $qualifier, .)"/>
											<xsl:for-each select="../lido:extentMeasurements[string-length(.)&gt;0]"><xsl:value-of select="concat(' (', ., ')')" /></xsl:for-each>
										</dc:format>
									</xsl:for-each>
								</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
</xsl:template>	
	
	<xsl:template name="subjectConceptActorPlace">
		<xsl:param name="desclang" />
		<xsl:param name="extent" />
									<xsl:choose>
									<xsl:when test="lido:subjectConcept[count(not(lido:term='')) &gt; 0]">
										<xsl:for-each select="lido:subjectConcept/lido:term[string-length(.)&gt;0][not(@lido:addedSearchTerm = 'yes')]">
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
										<!-- usually ignoring addedSearchTerms / special handling Iconclass (to be checked) -->
										<xsl:if test="lido:subjectConcept/lido:conceptID[contains(@lido:source, 'Iconclass')]">
										<xsl:for-each select="
											lido:subjectConcept/lido:term[string-length(.)&gt;0][@lido:addedSearchTerm = 'yes'][1]
											">
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
										</xsl:if>
									</xsl:when>
									</xsl:choose>
									<xsl:choose>
									<xsl:when test="lido:subjectActor/lido:actor">
										<xsl:for-each select="lido:subjectActor/lido:actor/lido:nameActorSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
											<!-- ignoring alternative names -->
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="lido:subjectActor/lido:displayActor">
										<xsl:for-each select="lido:subjectActor/lido:displayActor[string-length(.)&gt;0]">
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
									</xsl:when>
									</xsl:choose>
									<xsl:choose>
									<xsl:when test="lido:subjectPlace/lido:place">
										<xsl:for-each select="lido:subjectPlace/lido:place/lido:namePlaceSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
											<!-- ignoring alternative names -->
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="lido:subjectPlace/lido:displayPlace">
										<xsl:for-each select="lido:subjectPlace/lido:displayPlace[string-length(.)&gt;0]">
											<dc:subject>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:if test="not($extent='')">
													<xsl:value-of select="concat($extent, ': ')"/>
												</xsl:if>
												<xsl:value-of select="."/>
											</dc:subject>
										</xsl:for-each>
									</xsl:when>
									</xsl:choose>
	</xsl:template>

	<xsl:template name="eventWrap">
		<xsl:param name="desclang" />
		<xsl:param name="europeana-output" />
					<xsl:for-each select="lido:eventWrap/lido:eventSet/lido:event">
						<xsl:variable name="eventTypeID" select="lido:eventType/lido:conceptID[string-length(.)&gt;0][1]"/>
						<xsl:variable name="eventTypeLC" select="lower-case(lido:eventType/lido:term[string-length(.)&gt;0][1])"/>
						
						<xsl:variable name="eventType">
							<xsl:choose>
								<xsl:when test="string-length($eventTypeID)&gt;0">
									<xsl:value-of select="$eventTypeTerminology/skos:Concept[@rdf:about=$eventTypeID]/skos:prefLabel[@xml:lang=$desclang]" />
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="lido:eventType/lido:term[string-length(.)&gt;0][1]" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="creation" as="xs:boolean*">
							<xsl:if test="$eventTypeLC = 'creation' 
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00012'
								or $eventTypeLC = 'designing'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00224'
								or $eventTypeLC = 'planning'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00032'
								or $eventTypeLC = 'production'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00007'
								or $eventTypeLC = 'publication'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00228'
								">
								<xsl:sequence select="true()"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="acquisition" as="xs:boolean*">
							<xsl:if test="$eventTypeLC = 'acquisition' 
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00001'
								or $eventTypeLC = 'loss'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00009'
								or $eventTypeLC = 'move'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00223'
								">
								<xsl:sequence select="true()"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="provenance" as="xs:boolean*">
							<xsl:if test="$eventTypeLC = 'provenance'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00227'
								">
								<xsl:sequence select="true()"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="exhibition" as="xs:boolean*">
							<xsl:if test="$eventTypeLC = 'exhibition' 
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00225'
								">
								<xsl:sequence select="true()"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="outputEventType" as="xs:boolean*">
							<xsl:if test="not($eventTypeLC = 'creation' 
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00012'
								or $eventTypeLC = 'production'
								or $eventTypeID = 'http://terminology.lido-schema.org/lido00007'
								)">
								<xsl:sequence select="true()"/>
							</xsl:if>
						</xsl:variable>
						
						<xsl:if test="$exhibition and lido:eventName/lido:appellationValue[string-length(.)&gt;0]">
							<dcterms:provenance>
								<xsl:value-of select="concat($eventType, ': ', lido:eventName/lido:appellationValue[string-length(.)&gt;0][1])" />
								<xsl:if test="lido:eventID"><xsl:value-of select="concat(' (', lido:eventID, ')')" /></xsl:if>
							</dcterms:provenance>
						</xsl:if>
						
						<xsl:for-each select="lido:eventActor">
							<xsl:choose>
								<xsl:when test="$creation and lido:actorInRole">
									<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[string-length(.)&gt;0]">
									<!-- ignoring alternative names -->
									<xsl:if test="not(starts-with(@lido:pref, 'alternat'))">
									<dc:creator>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:for-each select="../../../lido:roleActor/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
											<xsl:choose>
												<xsl:when test="count(not(.='')) = 1 and count(../../lido:roleActor[not(lido:term='')]) = 1"> (<xsl:value-of select="." />)</xsl:when>
												<xsl:when test="position() = 1 and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = 1]"> (<xsl:value-of select="." />, </xsl:when>
												<xsl:when test="position() = last() and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = last()]"><xsl:value-of select="." />)</xsl:when>
												<xsl:otherwise><xsl:value-of select="." />, </xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
										<xsl:if test="not(../../../lido:roleActor/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]) and $outputEventType"> [<xsl:value-of select="$eventType" />]</xsl:if>
									</dc:creator>
									</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$creation and lido:displayActorInRole">
									<xsl:for-each select="lido:displayActorInRole[string-length(.)&gt;0]">
									<dc:creator>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dc:creator>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$provenance and not($europeana-output='no-descriptions') and lido:actorInRole">
									<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
									<!-- ignoring alternative names -->
									<dcterms:provenance>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:for-each select="../../../lido:roleActor/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
											<xsl:choose>
												<xsl:when test="count(not(.='')) = 1 and count(../../lido:roleActor[not(lido:term='')]) = 1"> (<xsl:value-of select="." />)</xsl:when>
												<xsl:when test="position() = 1 and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = 1]"> (<xsl:value-of select="." />, </xsl:when>
												<xsl:when test="position() = last() and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = last()]"><xsl:value-of select="." />)</xsl:when>
												<xsl:otherwise><xsl:value-of select="." />, </xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</dcterms:provenance>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$provenance and not($europeana-output='no-descriptions') and lido:displayActorInRole">
									<xsl:for-each select="lido:displayActorInRole[string-length(.)&gt;0]">
									<dcterms:provenance>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dcterms:provenance>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and lido:actorInRole">
									<xsl:for-each select="lido:actorInRole/lido:actor/lido:nameActorSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
									<!-- ignoring alternative names -->
									<dc:contributor>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:for-each select="../../../lido:roleActor/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
											<xsl:choose>
												<xsl:when test="count(not(.='')) = 1 and count(../../lido:roleActor[not(lido:term='')]) = 1"> (<xsl:value-of select="." />)</xsl:when>
												<xsl:when test="position() = 1 and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = 1]"> (<xsl:value-of select="." />, </xsl:when>
												<xsl:when test="position() = last() and ../../lido:roleActor[string-length(lido:term)&gt;0][position() = last()]"><xsl:value-of select="." />)</xsl:when>
												<xsl:otherwise><xsl:value-of select="." />, </xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
										<xsl:if test="not(../../../lido:roleActor/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0])"> [<xsl:value-of select="$eventType" />]</xsl:if>
									</dc:contributor>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and lido:displayActorInRole">
									<xsl:for-each select="lido:displayActorInRole[string-length(.)&gt;0]">
									<dc:contributor>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="concat(., ' [', $eventType, ']')"/>
									</dc:contributor>
									</xsl:for-each>
								</xsl:when>

							</xsl:choose>
						</xsl:for-each>

						<xsl:for-each select="lido:culture/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
							<xsl:variable name="type">
								<xsl:choose>
									<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">kultureller Kontext</xsl:when>
									<xsl:otherwise>cultural context</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$creation">
									<dc:creator>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="concat(., ' [', $type, ']')"/>
										<xsl:if test="$outputEventType"><xsl:value-of select="concat(' [', $eventType, ']')"/></xsl:if>
									</dc:creator>
								</xsl:when>
								<xsl:when test="$provenance and not($europeana-output='no-descriptions')">
									<dcterms:provenance>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="concat(., ' [', $type, ']', ' [', $eventType, ']')"/>
									</dcterms:provenance>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions')">
									<dc:contributor>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="concat(., ' [', $type, ']', ' [', $eventType, ']')"/>
									</dc:contributor>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>

						<xsl:for-each select="lido:eventMethod/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
						<xsl:if test="not($europeana-output='no-descriptions')">
						<xsl:variable name="type">
							<xsl:choose>
								<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'">Methode</xsl:when>
								<xsl:otherwise>method</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
							<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
								<xsl:value-of select="concat($type, ': ', ., ' [', $eventType, ']')"/>
							</dc:description>
							</xsl:if>
						</xsl:for-each>

						<xsl:for-each select="lido:eventMaterialsTech">
							<xsl:choose>
								<xsl:when test="lido:materialsTech">
									<xsl:for-each select="lido:materialsTech/lido:termMaterialsTech/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
									<xsl:choose>
										<xsl:when test="..[contains(lower-case(@lido:type), 'techn')]">
											<xsl:if test="not($europeana-output='no-descriptions')">
											<dc:description>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:value-of select="concat(../@lido:type, ': ', .)"/>
											</dc:description>
											</xsl:if>
										</xsl:when>
										<xsl:when test="..[contains(lower-case(@lido:type), 'material')]">
											<dcterms:medium>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
												<xsl:value-of select="."/>
											</dcterms:medium>
										</xsl:when>
									</xsl:choose>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="lido:displayMaterialsTech">
									<xsl:for-each select="lido:displayMaterialsTech[string-length(.)&gt;0]">
									<dcterms:medium>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
									</dcterms:medium>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					
						<xsl:for-each select="lido:periodName/lido:term[not(@lido:addedSearchTerm = 'yes')][string-length(.)&gt;0]">
							<xsl:choose>
								<xsl:when test="$creation">
									<dcterms:created>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:if test="../@lido:type"> [<xsl:value-of select="../@lido:type" />]</xsl:if>
										<xsl:if test="$outputEventType"><xsl:value-of select="concat(' [', $eventType, ']')"/></xsl:if>
									</dcterms:created>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and not($provenance)">
									<dc:date>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:if test="../@lido:type"> [<xsl:value-of select="../@lido:type" />]</xsl:if>
										<xsl:value-of select="concat(' [', $eventType, ']')"/>
									</dc:date>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					
						<xsl:for-each select="lido:eventDate">
							<xsl:choose>
								<xsl:when test="$creation and lido:date">
									<xsl:for-each select="lido:date[string-length(lido:earliestDate)&gt;0]">
									<dcterms:created>
										<xsl:attribute name="xml:lang"><xsl:value-of select="$desclang" /></xsl:attribute>
										<xsl:choose>
											<xsl:when test="lido:earliestDate = lido:latestDate">
												<xsl:value-of select="lido:earliestDate"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(lido:earliestDate, '/', lido:latestDate)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="$outputEventType"><xsl:value-of select="concat(' [', $eventType, ']')"/></xsl:if>
									</dcterms:created>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$creation and lido:displayDate">
									<xsl:for-each select="lido:displayDate[string-length(.)&gt;0]">
									<dcterms:created>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="."/>
										<xsl:if test="$outputEventType"><xsl:value-of select="concat(' [', $eventType, ']')"/></xsl:if>
									</dcterms:created>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and not($provenance) and lido:date">
									<xsl:for-each select="lido:date[string-length(lido:earliestDate)&gt;0]">
									<dc:date>
										<xsl:attribute name="xml:lang"><xsl:value-of select="$desclang" /></xsl:attribute>
										<xsl:choose>
											<xsl:when test="lido:earliestDate = lido:latestDate">
												<xsl:value-of select="concat(lido:earliestDate, ' [', $eventType, ']')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(lido:earliestDate, '/', lido:latestDate, ' [', $eventType, ']')"/>
											</xsl:otherwise>
										</xsl:choose>
									</dc:date>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and not($provenance) and lido:displayDate">
									<xsl:for-each select="lido:displayDate[string-length(.)&gt;0]">
									<dc:date>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
										<xsl:value-of select="concat(., ' [', $eventType, ']')"/>
									</dc:date>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>

						<xsl:for-each select="lido:eventPlace">
							<xsl:variable name="qualifier">
								<xsl:choose>
									<xsl:when test="$desclang eq 'de' or $desclang eq 'deu' or $desclang eq 'ger'"> [Ort]</xsl:when>
									<xsl:otherwise> [Place]</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$provenance and not($europeana-output='no-descriptions') and lido:place">
									<xsl:for-each select="lido:place/lido:namePlaceSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
									<!-- ignoring alternative names -->
										<dcterms:provenance>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat(., $qualifier)"/>
										</dcterms:provenance>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$provenance and not($europeana-output='no-descriptions') and lido:displayPlace">
									<xsl:for-each select="lido:displayPlace[string-length(.)&gt;0]">
										<dcterms:provenance>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="."/>
										</dcterms:provenance>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and lido:place">
									<xsl:for-each select="lido:place/lido:namePlaceSet/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))][string-length(.)&gt;0]">
									<!-- ignoring alternative names -->
										<dcterms:spatial>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat(., $qualifier, ' [', $eventType, ']')"/>
										</dcterms:spatial>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="not($acquisition and $europeana-output='no-descriptions') and lido:displayPlace">
									<xsl:for-each select="lido:displayPlace[string-length(.)&gt;0]">
										<dcterms:spatial>
								<xsl:call-template name="langattr">
									<xsl:with-param name="desclang" select="$desclang" />
								</xsl:call-template>
											<xsl:value-of select="concat(., ' [', $eventType, ']')"/>
										</dcterms:spatial>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="relatedWorksWrap">
		<xsl:param name="desclang" />
					<xsl:for-each select="lido:objectRelationWrap/lido:relatedWorksWrap/lido:relatedWorkSet[count(not(lido:relatedWork/lido:object/lido:objectNote='')) &gt; 0 or count(not(lido:relatedWork/lido:displayObject='')) &gt; 0]">
						<xsl:choose>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is part of' or lido:relatedWorkRelType/lido:term[1] ='part of'
								or lido:relatedWorkRelType/lido:term[1] ='Teil von'
								">
								<dcterms:isPartOf>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isPartOf>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='has part'
								or lido:relatedWorkRelType/lido:term[1] ='hat Teil'
								">
								<dcterms:hasPart>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:hasPart>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is version of'">
								<dcterms:isVersionOf>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isVersionOf>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='has version'">
								<dcterms:hasVersion>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:hasVersion>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is replaced by'">
								<dcterms:isReplacedBy>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isReplacedBy>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='replaces'">
								<dcterms:replaces>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:replaces>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is referenced by'">
								<dcterms:isReferencedBy>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isReferencedBy>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='references'">
								<dcterms:references>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:references>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is format of'">
								<dcterms:isFormatOf>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isFormatOf>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='has format'">
								<dcterms:hasFormat>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:hasFormat>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='is required by'">
								<dcterms:isRequiredBy>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:isRequiredBy>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='requires'">
								<dcterms:requires>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:requires>
							</xsl:when>
							<xsl:when test="lower-case(lido:relatedWorkRelType[1]/lido:term[1]) ='conforms to'">
								<dcterms:conformsTo>
									<xsl:call-template name="relatedWork"><xsl:with-param name="desclang" select="$desclang" /></xsl:call-template>
								</dcterms:conformsTo>
							</xsl:when>
							<xsl:when test=".//lido:objectNote[string-length(.)&gt;0] or .//lido:displayObject[string-length(.)&gt;0]">
								<xsl:variable name="reltype">
									<xsl:choose>
										<xsl:when test="lido:relatedWorkRelType/lido:term"><xsl:value-of select="concat(' [', lido:relatedWorkRelType/lido:term[1], ']')" /></xsl:when>
										<xsl:otherwise />
									</xsl:choose>
								</xsl:variable>
								<dc:relation>
									<xsl:for-each select="lido:relatedWork">
										<xsl:choose>
										<xsl:when test=".//lido:objectNote[string-length(.)&gt;0]">
											<xsl:attribute name="xml:lang">
												<xsl:choose>
													<xsl:when test="lido:object[1]/lido:objectNote[1]/@xml:lang"><xsl:value-of select="lido:object[1]/lido:objectNote[1]/@xml:lang" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										<xsl:for-each select="lido:object">
											<xsl:for-each select="lido:objectNote[string-length(.)&gt;0]">
											<xsl:variable name="type">
												<xsl:choose>
													<xsl:when test="@lido:type"><xsl:value-of select="concat(@lido:type, ': ')" /></xsl:when>
													<xsl:otherwise />
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="count(../lido:objectNote[not(.='')]) = 1">
													<xsl:value-of select="concat($type, .)" />
												</xsl:when>
												<xsl:when test="position() = 1">
													<xsl:value-of select="concat($type, ., ', ')" /></xsl:when>
												<xsl:when test="position() = last()">
													<xsl:value-of select="concat($type, .)" />
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="concat($type, ., ', ')" /></xsl:otherwise>
											</xsl:choose>
											</xsl:for-each>
											<xsl:value-of select="$reltype" />
											<xsl:if test="lido:objectWebResource[string-length(.)&gt;0]">
												<xsl:value-of select="concat(' [', lido:objectWebResource[string-length(.)&gt;0][1], ']')" />
											</xsl:if>
										</xsl:for-each>
							</xsl:when>
							<xsl:when test="lido:displayObject[string-length(.)&gt;0]">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="lido:displayObject[not(.='')][1]/@xml:lang"><xsl:value-of select="lido:displayObject[not(.='')][1]/@xml:lang" /></xsl:when>
												<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:value-of select="lido:displayObject[not(.='')][1]" />
										<xsl:value-of select="$reltype" />
							</xsl:when>
							</xsl:choose>
									</xsl:for-each>
								</dc:relation>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="relatedWork">
		<xsl:param name="desclang" />
									<xsl:for-each select="lido:relatedWork">
									<xsl:choose>
										<xsl:when test="lido:object">
											<xsl:attribute name="xml:lang">
												<xsl:choose>
													<xsl:when test="lido:object[1]/lido:objectNote[1]/@xml:lang"><xsl:value-of select="lido:object[1]/lido:objectNote[1]/@xml:lang" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										<xsl:for-each select="lido:object">
											<xsl:for-each select="lido:objectNote[string-length(.)&gt;0]">
											<xsl:variable name="type">
												<xsl:choose>
													<xsl:when test="@lido:type"><xsl:value-of select="concat(@lido:type, ': ')" /></xsl:when>
													<xsl:otherwise />
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="count(../lido:objectNote[not(.='')]) = 1">
													<xsl:value-of select="concat($type, .)" />
												</xsl:when>
												<xsl:when test="position() = 1">
													<xsl:value-of select="concat($type, ., ', ')" /></xsl:when>
												<xsl:when test="position() = last()">
													<xsl:value-of select="concat($type, .)" />
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="concat($type, ., ', ')" /></xsl:otherwise>
											</xsl:choose>
											</xsl:for-each>
											<xsl:if test="lido:objectWebResource[string-length(.)&gt;0]">
												<xsl:value-of select="concat(' [', lido:objectWebResource[string-length(.)&gt;0][1], ']')" />
											</xsl:if>
										</xsl:for-each>
										</xsl:when>
										<xsl:when test="string-length(lido:displayObject) &gt; 0">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="lido:displayObject[not(.='')][1]/@xml:lang"><xsl:value-of select="lido:displayObject[not(.='')][1]/@xml:lang" /></xsl:when>
												<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
											<xsl:value-of select="lido:displayObject[not(.='')][1]" />
										</xsl:when>
									</xsl:choose>
									</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="resourceView">
		<xsl:variable name="admlang">
			<xsl:choose>
				<xsl:when test="@xml:lang">
					<xsl:value-of select="@xml:lang" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../../@xml:lang" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="lido:resourceDescription[string-length(.)&gt;0]">
			<dc:description>
				<xsl:call-template name="langattr">
					<xsl:with-param name="desclang" select="$admlang" />
				</xsl:call-template>
				<xsl:variable name="desctype">
					<xsl:choose>
						<xsl:when test="$admlang eq 'de' or $admlang = 'deu' or $admlang = 'ger'">Fotoinhalt/Ansicht</xsl:when>
						<xsl:otherwise>Content/View Resource</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="concat($desctype, ': ', .)" />
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="lido:resourceDateTaken">
				<xsl:variable name="desctype">
					<xsl:choose>
						<xsl:when test="$admlang eq 'de' or $admlang = 'deu' or $admlang = 'ger'">Datierung des Fotos</xsl:when>
						<xsl:otherwise>Date Resource</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="lido:date">
						<xsl:for-each select="lido:date[string-length(lido:earliestDate)&gt;0]">
							<dc:description>
							<xsl:attribute name="xml:lang"><xsl:value-of select="$admlang" /></xsl:attribute>
							<xsl:choose>
								<xsl:when test="lido:earliestDate = lido:latestDate">
									<xsl:value-of select="concat($desctype, ': ', lido:earliestDate)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($desctype, ': ', lido:earliestDate, '/', lido:latestDate)"/>
								</xsl:otherwise>
							</xsl:choose>
						</dc:description>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="lido:displayDate">
						<xsl:for-each select="lido:displayDate[string-length(.)&gt;0]">
						<dc:description>
							<xsl:call-template name="langattr">
								<xsl:with-param name="desclang" select="$admlang" />
							</xsl:call-template>
							<xsl:value-of select="concat($desctype, ': ', .)"/>
						</dc:description>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="lido:resourceSource/lido:legalBodyName/lido:appellationValue[string-length(.)&gt;0]">
			<xsl:if test="lower-case(../../@lido:type) = 'photographer' or contains(lower-case(../../@lido:type), 'fotograf')">
			<dc:description>
				<xsl:call-template name="langattr">
					<xsl:with-param name="desclang" select="$admlang" />
				</xsl:call-template>
				<xsl:value-of select="concat(../../@lido:type, ': ', .)" />
			</dc:description>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="work">
		<xsl:variable name="admlang" select="@xml:lang" />
		<xsl:choose>
			<xsl:when test="lido:rightsWorkWrap/lido:rightsWorkSet/lido:creditLine[string-length(.)&gt;0]">
				<xsl:for-each select="lido:rightsWorkWrap/lido:rightsWorkSet/lido:creditLine[string-length(.)&gt;0]">
					<!-- ignoring alternative names -->
					<dc:rights>
							<xsl:call-template name="langattr">
								<xsl:with-param name="desclang" select="$admlang" />
							</xsl:call-template>
						<xsl:value-of select="."/>
					</dc:rights>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsType[string-length(lido:term)&gt;0] and not(lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsHolder/lido:legalBodyName)">
				<xsl:for-each select="lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsType[string-length(lido:term)&gt;0]">
					<dc:rights>
							<xsl:call-template name="langattr">
								<xsl:with-param name="desclang" select="$admlang" />
							</xsl:call-template>
						<xsl:value-of select="lido:term"/>
					</dc:rights>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsHolder/lido:legalBodyName">
				<xsl:for-each select="lido:rightsWorkWrap/lido:rightsWorkSet/lido:rightsHolder/lido:legalBodyName[not(lido:appellationValue/starts-with(@lido:pref, 'alternat'))]">
						<dc:rights>
							<xsl:attribute name="xml:lang">
							<xsl:choose>
								<xsl:when test="lido:appellationValue/@xml:lang"><xsl:value-of select="lido:appellationValue/@xml:lang" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="$admlang" /></xsl:otherwise>
							</xsl:choose>
							</xsl:attribute>
							<xsl:if test="../../lido:rightsType[string-length(lido:term)&gt;0]">
								<xsl:for-each select="../../lido:rightsType[string-length(lido:term)&gt;0]">
									<xsl:value-of select="lido:term[1]" />
								</xsl:for-each>
								<xsl:value-of select="': '" />
							</xsl:if>
							<xsl:value-of select="lido:appellationValue"/>
						</dc:rights>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="record">
		
		<xsl:variable name="admlang" select="@xml:lang" />
		<xsl:for-each select="lido:recordWrap/lido:recordID[not(@lido:type='local')][string-length(.)&gt;0]">
			<dc:identifier>
				<xsl:call-template name="langattr">
					<xsl:with-param name="desclang" select="$admlang" />
				</xsl:call-template>
			   <xsl:value-of select="concat(@lido:type, ' ',. , ' [Metadata]')"/>						           
			</dc:identifier>
		</xsl:for-each>

		<xsl:for-each select="lido:recordWrap/lido:recordSource[not(@lido:type = 'europeana:dataProvider')]/lido:legalBodyName/lido:appellationValue[not(@lido:label = 'europeana:dataProvider')][not(starts-with(@lido:pref, 'alternat'))]">
		<!-- ignoring alternative names -->
			<dc:source>
				<xsl:call-template name="langattr">
					<xsl:with-param name="desclang" select="$admlang" />
				</xsl:call-template>
				<xsl:value-of select="."/>
			</dc:source>
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="resource">

		<xsl:variable name="admlang" select="../../@xml:lang" />
		<xsl:variable name="resourceType">
			<xsl:choose>
				<xsl:when test="lido:resourceType/lido:term"><xsl:value-of select="lido:resourceType[1]/lido:term[1]/text()[1]" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="'Resource'" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="lido:resourceID[not(@lido:type='local')][string-length(.)&gt;0]">
			<dc:identifier>
				<xsl:call-template name="langattr">
					<xsl:with-param name="desclang" select="$admlang" />
				</xsl:call-template>
			   <xsl:value-of select="concat(@lido:type, ' ', ., ' [', $resourceType, ']')"/>						           
			</dc:identifier>
		</xsl:for-each>
		
		<xsl:choose>
			<xsl:when test="lido:rightsResource[lido:rightsType/lido:term/@lido:pref='preferred']/lido:creditLine[string-length(.)&gt;0]">
				<dc:rights>
					<xsl:for-each select="lido:rightsResource/lido:creditLine[string-length(.)&gt;0]">
						<xsl:value-of select="."/>
						<xsl:if test="not(position() = last())"><xsl:value-of select="' / '" /></xsl:if>
					</xsl:for-each>
					<xsl:value-of select="concat(' [', $resourceType, ']')"/>
				</dc:rights>
			</xsl:when>
			<xsl:when test="lido:rightsResource[lido:rightsType/lido:term/@lido:pref='preferred']/lido:rightsHolder/lido:legalBodyName">
				<dc:rights>
					<xsl:for-each select="lido:rightsResource/lido:rightsHolder/lido:legalBodyName/lido:appellationValue[not(starts-with(@lido:pref, 'alternat'))]">
						<xsl:value-of select="."/>
						<xsl:if test="not(position() = last())"><xsl:value-of select="' / '" /></xsl:if>
					</xsl:for-each>
					<xsl:value-of select="concat(' [', $resourceType, ']')"/>
				</dc:rights>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="langattr">
		<xsl:param name="desclang" />
			<xsl:attribute name="xml:lang">
				<xsl:choose>
					<xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$desclang" /></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
	</xsl:template>

	<xsl:variable name="eventTypeTerminology">
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00001">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Erwerbung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Acquisition</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Pozyskanie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Accession</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Aquisição</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Iegūšana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Acquizione</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Sealbhú</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Beszerzés</skos:prefLabel>
		<skos:prefLabel xml:lang="el">απόκτηση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Hõive</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Akvizice</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">комплектуване</skos:prefLabel>
		<skos:prefLabel xml:lang="he">רכישה</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">приобретение</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Pridobivanje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Adquisició</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Adquisición</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Verwerving</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Acquisition</skos:prefLabel>
		<skos:altLabel xml:lang="et">Andmehõive</skos:altLabel>
		<skos:altLabel xml:lang="ru">комплектование</skos:altLabel>
		<skos:altLabel xml:lang="nl">Acquisitie</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00002">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Fund</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Finding</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Odnalezienie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Upptäckt</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Procura</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Atradums</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Scoperta</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Fionnachtain</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Megtalálás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">εύρεση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Leid</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Nález</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">намиране</skos:prefLabel>
		<skos:prefLabel xml:lang="he">מציאה</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">находка</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Najdba</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Descobriment</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Descubrimento</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Vondst</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Découverte</skos:prefLabel>
		<skos:altLabel xml:lang="en">Find</skos:altLabel>
		<skos:altLabel xml:lang="deu">Funde</skos:altLabel>
		<skos:altLabel xml:lang="pt">Procurar</skos:altLabel>
		<skos:altLabel xml:lang="it">Scoprire</skos:altLabel>
		<skos:altLabel xml:lang="el">βρίσκω</skos:altLabel>
		<skos:altLabel xml:lang="et">Leidma</skos:altLabel>
		<skos:altLabel xml:lang="bg">намери</skos:altLabel>
		<skos:altLabel xml:lang="he">למצוא</skos:altLabel>
		<skos:altLabel xml:lang="fr">Découvrir</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00003">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Ereignis</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Event</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Wydarzenie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Händelse</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Evento</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Pasākums</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Evento</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Ócáid</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Esemény</skos:prefLabel>
		<skos:prefLabel xml:lang="el">συμβάν</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Sündmus</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Akce</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">събитие</skos:prefLabel>
		<skos:prefLabel xml:lang="he">אירוע</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">событие</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Dogodek</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Esdeveniment</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Evento</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Gebeurtenis</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Événement</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Notikums</skos:altLabel>
		<skos:altLabel xml:lang="bg">изява</skos:altLabel>
		<skos:altLabel xml:lang="nl">Evenement</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00006">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Bearbeitung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Modification</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Modyfikacja</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Modifiering</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Modificação</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Modifikācija</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Modifica</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Mionathrú</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Módosítás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">τροποποίηση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Muutus</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Úprava</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">модификация</skos:prefLabel>
		<skos:prefLabel xml:lang="he">שינוי</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Sprememba</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">изменение</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Modificació</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Modificación</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Modificatie</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Modification</skos:prefLabel>
		<skos:altLabel xml:lang="ga">Bunathrú</skos:altLabel>
		<skos:altLabel xml:lang="et">Täiustus</skos:altLabel>
		<skos:altLabel xml:lang="he">התאמה, תיקון,</skos:altLabel>
		<skos:altLabel xml:lang="nl">Aanpassing</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00007">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Herstellung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Production</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Produkcja</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Produktion</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Produção</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Izgatavošana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Produzione</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Táirgeadh</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Gyártás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">παραγωγή</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Tootmine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Produkce</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">продукция</skos:prefLabel>
		<skos:prefLabel xml:lang="he">ייצור</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">призводство</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Izdelovanje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Producció</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Producción</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Productie</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Production</skos:prefLabel>
		<skos:altLabel xml:lang="et">Produktsioon</skos:altLabel>
		<skos:altLabel xml:lang="ga">Táirgeacht</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00008">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Part addition</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Erweiterung</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">частично добавяне</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Afegiment de part</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Přidání části</skos:prefLabel>
		<skos:prefLabel xml:lang="el">προσθήκη τμήματος</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Adición de parte</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Osa lisamine</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Páirtaguisín</skos:prefLabel>
		<skos:prefLabel xml:lang="he">הוספה חלקית</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Rész hozzáadása</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Aggiunta parziale</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Daļas pievienošana</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Gedeeltelijke toevoeging</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Dodanie części</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Adição de parte</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">добавление части</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Delni dodatek</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Tillskott</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Ajout de partie</skos:prefLabel>
		<skos:altLabel xml:lang="deu">Ergänzung</skos:altLabel>
		<skos:altLabel xml:lang="et">Osa liitmine</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00009">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Verlust</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Loss</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">загуба</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Pèrdua</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Ztráta</skos:prefLabel>
		<skos:prefLabel xml:lang="el">απώλεια</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Pérdida</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Kaotus</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Cailleadh</skos:prefLabel>
		<skos:prefLabel xml:lang="he">אבידה</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Veszteség</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Perdita</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Zudums</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Verlies</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Zagubienie</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Perda</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">утеря</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Izguba</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Förlust</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Perte</skos:prefLabel>
		<skos:altLabel xml:lang="et">Kahju</skos:altLabel>
		<skos:altLabel xml:lang="lv">Zaudējums</skos:altLabel>
		<skos:altLabel xml:lang="ru">утрата</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00010">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Sammelereignis</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Collecting</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Dołączenie do kolekcji</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Samling</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Coleccionar</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Kolekcionēšana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Raccolta</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Ag bailiú</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Gyűjtés</skos:prefLabel>
		<skos:prefLabel xml:lang="el">συλλέγοντας</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Koondav</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Shromažďování</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">колекциониране</skos:prefLabel>
		<skos:prefLabel xml:lang="he">איסוף</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">сбор</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Zbiranje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Col·lecció</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Colección</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Verzameling</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Collecter</skos:prefLabel>
		<skos:altLabel xml:lang="en">Collection Event</skos:altLabel>
		<skos:altLabel xml:lang="en">Field Collection</skos:altLabel>
		<skos:altLabel xml:lang="en">Collection</skos:altLabel>
		<skos:altLabel xml:lang="ga">Bailiú</skos:altLabel>
		<skos:altLabel xml:lang="et">Kogumine</skos:altLabel>
		<skos:altLabel xml:lang="ru">коллекционирование</skos:altLabel>
		<skos:altLabel xml:lang="ca">Recol·lecció</skos:altLabel>
		<skos:altLabel xml:lang="es">Recolección</skos:altLabel>
		<skos:altLabel xml:lang="nl">Collectie</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00011">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Gebrauch</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Use</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Użycie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Användning</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Utilização</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Lietošana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Uso</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Úsáid</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Használat</skos:prefLabel>
		<skos:prefLabel xml:lang="el">χρήση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Kasutus</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Použití</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">употреба</skos:prefLabel>
		<skos:prefLabel xml:lang="he">שימוש</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">использование</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Uporaba</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Ús</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Uso</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Gebruik</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Utilisation</skos:prefLabel>
		<skos:altLabel xml:lang="deu">Wurde genutzt</skos:altLabel>
		<skos:altLabel xml:lang="deu">Nutzung</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00012">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Geistige Schöpfung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Creation</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Utworzenie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Kreation</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Criação</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Veidošana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Ideazione</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Cruthú</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Létrehozás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">δημιουργία</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Loomine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Vytvoření</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">създаване</skos:prefLabel>
		<skos:prefLabel xml:lang="he">יצירה</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">создание</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Kreacija</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Creació</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Creación</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Vervaardiging</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Creation</skos:prefLabel>
		<skos:altLabel xml:lang="en">Conception</skos:altLabel>
		<skos:altLabel xml:lang="en">Create</skos:altLabel>
		<skos:altLabel xml:lang="pt">Criar</skos:altLabel>
		<skos:altLabel xml:lang="lv">Radīšana</skos:altLabel>
		<skos:altLabel xml:lang="it">Ideare</skos:altLabel>
		<skos:altLabel xml:lang="ga">Cruthúchán</skos:altLabel>
		<skos:altLabel xml:lang="el">δημιουργώ</skos:altLabel>
		<skos:altLabel xml:lang="et">Looma</skos:altLabel>
		<skos:altLabel xml:lang="bg">творба</skos:altLabel>
		<skos:altLabel xml:lang="bg">създавам</skos:altLabel>
		<skos:altLabel xml:lang="bg">творя</skos:altLabel>
		<skos:altLabel xml:lang="he">ליצור</skos:altLabel>
		<skos:altLabel xml:lang="sl">Ustvarjanje</skos:altLabel>
		<skos:altLabel xml:lang="fr">Créer</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00013">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Typusdefinition</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Type creation</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Utworzenie typu</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Kategorisering</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Criação de tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Tipu radīšana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Creazione del tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Cruthú cineálacha</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Típus létrehozás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">τύπος δημιουργία</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Tüübi loomine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Tvorba typu</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">вид творба</skos:prefLabel>
		<skos:prefLabel xml:lang="he">יצירת סוג</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">создание типа</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Kreiranje tipa</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Creació de tipus</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Creación de tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Soort vervaardiging</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Création de type</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Tipu veidošana</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00021">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Teilentfernung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Part removal</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Usunięcie części</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Avlägsnande</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Remoção de parte</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Daļas noņemšana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Rimozione parziale</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Aistriú coda</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Rész eltávolítása</skos:prefLabel>
		<skos:prefLabel xml:lang="el">αφαίρεση τμήματος</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Osa eemaldamine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Odstranění části</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">частично премахване</skos:prefLabel>
		<skos:prefLabel xml:lang="he">הסרה חלקית</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">удаление части</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Delna odstranitev</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Eliminació de part</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Eliminación de parte</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Gedeeltelijke verwijdering</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Suppression de partie</skos:prefLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00023">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Typuszuweisung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Type assignment</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Przypisanie typu</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Kategoribestämning</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Atribuição de tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Tipu piešķiršana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Assegnazione del tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Rangú de réir cineáil</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Típus hozzárendelés</skos:prefLabel>
		<skos:prefLabel xml:lang="el">τύπος ανάθεση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Tüübi määramine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Přiřazení typu</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">вид задача</skos:prefLabel>
		<skos:prefLabel xml:lang="he">סיווג</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">присвоение типа</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Doloćitev tipa</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Assignació de tipus</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Asignación de tipo</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Soort opdracht</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Affectation de type</skos:prefLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00026">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Zerstörung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Destruction</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Zniszczenie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Destruktion</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Destruição</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Sairšana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Distruzione</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Scrios</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Megsemmisítés</skos:prefLabel>
		<skos:prefLabel xml:lang="el">καταστροφή</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Hävitus</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Zničení</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">деструкция</skos:prefLabel>
		<skos:prefLabel xml:lang="he">הריסה - להרוס</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">разрушение</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Uničenje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Destrucció</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Destrucción</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Vernietiging</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Destruction</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Sagraušana</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00029">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Umgestaltung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Transformation</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">трансформация</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Transformació</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Transformace</skos:prefLabel>
		<skos:prefLabel xml:lang="el">μετατροπή</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Transformación</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Muundamine</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Claochlú</skos:prefLabel>
		<skos:prefLabel xml:lang="he">שינוי צורה</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Átalakítás</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Trasformazione</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Pārveidošana</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Transformatie</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Transformacja</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Transformação</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">трансформация</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Transformacija</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Förändring</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Transformation</skos:prefLabel>
		<skos:altLabel xml:lang="et">Teisendamine</skos:altLabel>
		<skos:altLabel xml:lang="lv">Transformācija</skos:altLabel>
		<skos:altLabel xml:lang="nl">Omzetting</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00030">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Performance</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Aufführung</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Wykonanie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Uppträdande</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Desempenho</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Performance</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Teljesítmény</skos:prefLabel>
		<skos:prefLabel xml:lang="el">απόδοση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Jõudlus</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Veikšana</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Představení</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">представление</skos:prefLabel>
		<skos:prefLabel xml:lang="he">ביצוע</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">исполнение</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Prireditev</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Representació</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Representación</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Uitvoering</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Léiriú</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Performance</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Izpildīšana</skos:altLabel>
		<skos:altLabel xml:lang="et">Sooritamine</skos:altLabel>
		<skos:altLabel xml:lang="ga">Taibhiú damhsa</skos:altLabel>
		<skos:altLabel xml:lang="ga">Taibhiú ceoil</skos:altLabel>
		<skos:altLabel xml:lang="ga">Reacaireacht</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00032">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Planung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Planning</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">планиране</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Planificació</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Plánování</skos:prefLabel>
		<skos:prefLabel xml:lang="el">προγραμματισμός</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Planificación</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Planeerimine</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Pleanáil</skos:prefLabel>
		<skos:prefLabel xml:lang="he">תכנון</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Progettazione</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Plānošana</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Planning</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Planowanie</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Planeamento</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">планирование</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Načrtovanje</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Planering</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Programmation</skos:prefLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00033">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Ausgrabung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Excavation</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Pozyskanie w wyniku prac wykopaliskowych</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Utgrävning</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Escavação</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Izrakumi</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Scavo</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Gochaltán</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Feltárás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">ανασκαφή</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Väljakaevamine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Exkavace</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">разкопки</skos:prefLabel>
		<skos:prefLabel xml:lang="he">חפירה</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">раскопки</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Izkopavanje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Excavació</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Excavación</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Opgraving</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Fouille</skos:prefLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00034">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Restaurierung</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Restoration</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Konserwacja</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Restaurering</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Restauro</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Restaurācija</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Restauro</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Athchóiriú</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Restaurálás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">συντήρηση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Taastamine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Obnovení</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">реставрация</skos:prefLabel>
		<skos:prefLabel xml:lang="he">רפאות</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">реставрация</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Restavriranje</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Restauració</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Restauración</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Restauratie</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Restauration</skos:prefLabel>
		<skos:altLabel xml:lang="et">Ennistamine</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00223">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Move</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Objektbewegung</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">премести</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Trasllat</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Přesun</skos:prefLabel>
		<skos:prefLabel xml:lang="el">κίνηση</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Traslado</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Teisaldamine</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Bog</skos:prefLabel>
		<skos:prefLabel xml:lang="he">הזזה</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Mozgatás</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Spostamento</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Kustība</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Verplaatsting</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Przeniesienie</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Mover</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">перемещение</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Prenos</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Förflyttning</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Changement</skos:prefLabel>
		<skos:altLabel xml:lang="ca">Desplaçament</skos:altLabel>
		<skos:altLabel xml:lang="et">Nihutamine</skos:altLabel>
		<skos:altLabel xml:lang="ga">Bogadh</skos:altLabel>
		<skos:altLabel xml:lang="he">העתקה</skos:altLabel>
		<skos:altLabel xml:lang="lv">Pārvietošana</skos:altLabel>
		<skos:altLabel xml:lang="ru">движение</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00224">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Designing</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">дизайн</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Disseny</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Projektování</skos:prefLabel>
		<skos:prefLabel xml:lang="el">σχεδιάζοντας</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Diseño</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Kavandamine</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Ag dearadh</skos:prefLabel>
		<skos:prefLabel xml:lang="he">עיצוב</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Tervezés</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Disegno</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Projektēšana</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Ontwerp</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Zaprojektowanie</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Desenhar</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">проектирование</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Oblikovanje</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Formgivning</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Conception</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Entwurf</skos:prefLabel>
		<skos:altLabel xml:lang="en">Design</skos:altLabel>
		<skos:altLabel xml:lang="bg">разрабоване</skos:altLabel>
		<skos:altLabel xml:lang="bg">разработвам</skos:altLabel>
		<skos:altLabel xml:lang="el">σχεδιάζω</skos:altLabel>
		<skos:altLabel xml:lang="et">Disain</skos:altLabel>
		<skos:altLabel xml:lang="ga">Dearadh</skos:altLabel>
		<skos:altLabel xml:lang="pt">Desenho</skos:altLabel>
		<skos:altLabel xml:lang="sl">Oblika</skos:altLabel>
		<skos:altLabel xml:lang="fr">Concevoir</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00225">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Exhibition</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Ausstellung</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Wystawienie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Utställning</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Exibição</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Ekspozīcija</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Mostra</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Taispeántas</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Kiállítás</skos:prefLabel>
		<skos:prefLabel xml:lang="el">έκθεση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Näitus</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Výstava</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">изложба</skos:prefLabel>
		<skos:prefLabel xml:lang="he">תצוגה - תערוכה</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">выставка</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Razstava</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Exposició</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Exposición</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Tentoonstelling</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Exposition</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Izstāde</skos:altLabel>
		<skos:altLabel xml:lang="ru">экспонирование</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00226">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Auftrag</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Commissioning</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Zamówienie</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Ordning</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Ordem</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Kārtība</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Ordinamento</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Ord</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Rendelés</skos:prefLabel>
		<skos:prefLabel xml:lang="el">ταξινόμηση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Järjestama</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Objednávka</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">поръчай</skos:prefLabel>
		<skos:prefLabel xml:lang="he">סדר</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">заказ</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Naročilo</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Encàrrec</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Encargo</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Bestelling</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Ordre</skos:prefLabel>
		<skos:altLabel xml:lang="en">Order</skos:altLabel>
		<skos:altLabel xml:lang="lv">Secība</skos:altLabel>
		<skos:altLabel xml:lang="et">Järjestus</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00227">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="deu">Provenienz</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Provenance</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Proweniencja</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Proveniens</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Proveniência</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Izcelšanās</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Provenienza</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Bunáitíocht</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Eredet</skos:prefLabel>
		<skos:prefLabel xml:lang="el">προέλευση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Päritolu</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Provenience</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">произход</skos:prefLabel>
		<skos:prefLabel xml:lang="he">מוצא</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">происходжение</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Provenienca</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Procedència</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Procedencia</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Eigendom</skos:prefLabel>
		<skos:prefLabel xml:lang="en">Provenance</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Izcelsme</skos:altLabel>
		<skos:altLabel xml:lang="et">Algupära</skos:altLabel>
		<skos:altLabel xml:lang="he">מוצאות</skos:altLabel>
		<skos:altLabel xml:lang="nl">Bezitting</skos:altLabel>
		<skos:altLabel xml:lang="fr">Origine</skos:altLabel>
	</skos:Concept>
	<skos:Concept rdf:about="http://terminology.lido-schema.org/lido00228">
		<skos:inScheme>http://terminology.lido-schema.org/eventType</skos:inScheme>
		<skos:prefLabel xml:lang="en">Publication</skos:prefLabel>
		<skos:prefLabel xml:lang="deu">Veröffentlichung</skos:prefLabel>
		<skos:prefLabel xml:lang="pl">Publikacja</skos:prefLabel>
		<skos:prefLabel xml:lang="sv">Publikation</skos:prefLabel>
		<skos:prefLabel xml:lang="pt">Publicação</skos:prefLabel>
		<skos:prefLabel xml:lang="lv">Izdošana</skos:prefLabel>
		<skos:prefLabel xml:lang="it">Pubblicazione</skos:prefLabel>
		<skos:prefLabel xml:lang="ga">Foilsitheoireacht</skos:prefLabel>
		<skos:prefLabel xml:lang="hu">Nyilvánosságra hozatal</skos:prefLabel>
		<skos:prefLabel xml:lang="el">δημοσίευση</skos:prefLabel>
		<skos:prefLabel xml:lang="et">Avaldamine</skos:prefLabel>
		<skos:prefLabel xml:lang="cs">Publikování</skos:prefLabel>
		<skos:prefLabel xml:lang="bg">публикация</skos:prefLabel>
		<skos:prefLabel xml:lang="he">פרסום</skos:prefLabel>
		<skos:prefLabel xml:lang="ru">публикация</skos:prefLabel>
		<skos:prefLabel xml:lang="sl">Objava</skos:prefLabel>
		<skos:prefLabel xml:lang="ca">Publicació</skos:prefLabel>
		<skos:prefLabel xml:lang="es">Publicación</skos:prefLabel>
		<skos:prefLabel xml:lang="nl">Publicatie</skos:prefLabel>
		<skos:prefLabel xml:lang="fr">Publication</skos:prefLabel>
		<skos:altLabel xml:lang="lv">Publicēšana</skos:altLabel>
		<skos:altLabel xml:lang="ga">Foilseachán</skos:altLabel>
		<skos:altLabel xml:lang="et">Publikatsioon</skos:altLabel>
		<skos:altLabel xml:lang="bg">издание</skos:altLabel>
	</skos:Concept>
	</xsl:variable>

</xsl:stylesheet>
