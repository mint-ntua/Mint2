<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
 	xmlns:dcterms="http://purl.org/dc/terms/"
 	xmlns:ens="http://www.europeana.eu/schemas/edm/"
 	xmlns:edm="http://www.europeana.eu/schemas/edm/"
 	 xmlns:europeana="http://www.europeana.eu/schemas/ese/"
 	xmlns:ore="http://www.openarchives.org/ore/terms/"
 	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	version="1.0">
	
	<xsl:output method="xml" encoding="UTF-8" standalone="yes" indent="yes"/>

	<xsl:template match="/">
		<europeana:metadata>		
	  	<xsl:apply-templates select="/rdf:RDF/edm:ProvidedCHO"/>		
		</europeana:metadata>
	</xsl:template>
			
	<xsl:template match="rdf:RDF/edm:ProvidedCHO">
		<europeana:record>
		  <xsl:variable name="id" select="@rdf:about"/>
			<xsl:for-each select="edm:type">
				<europeana:type><xsl:value-of select="."/></europeana:type>
			</xsl:for-each>

			<xsl:call-template name="map_other_properties"/>

			<xsl:for-each select="/rdf:RDF/ore:Aggregation/edm:aggregatedCHO[@rdf:resource=$id]">
			  <xsl:for-each select="../edm:rights">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:rights</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			  <xsl:for-each select="../edm:isShownAt">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:isShownAt</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			  <xsl:for-each select="../edm:isShownBy">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:isShownBy</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			  <xsl:for-each select="../edm:object">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:object</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			  <xsl:for-each select="../edm:dataProvider">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:dataProvider</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			  <xsl:for-each select="../edm:provider">
			    <xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">europeana:provider</xsl:with-param>
			    </xsl:call-template>
			  </xsl:for-each>
			</xsl:for-each>

		</europeana:record>
	</xsl:template>

	<xsl:template name="map_other_properties">

		<xsl:for-each select="dc:description">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:description</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dc:title">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:title</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dc:coverage">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:coverage</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dc:format">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:format</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dcterms:alternative">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:alternative</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dcterms:spatial">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:spatial</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dcterms:extent">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:extent</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="dc:creator">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:creator</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dcterms:temporal">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:temporal</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dcterms:medium">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:medium</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dc:contributor">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:contributor</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dc:identifier">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:identifier</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dc:date">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:date</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dcterms:isPartOf">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isPartOf</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dcterms:created">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:created</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		
		
		<xsl:for-each select="dc:language">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:language</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:provenance">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:provenance</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:issued">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:issued</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dc:publisher">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:publisher</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dc:relation">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:relation</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dc:source">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:source</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:conformsTo">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:conformsTo</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dc:subject">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:subject</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:hasFormat">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:hasFormat</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dc:type">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dc:type</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:isFormatOf">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isFormatOf</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:hasVersion">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:hasVersion</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:isVersionOf">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isVersionOf</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:hasPart">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:hasPart</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:isReferencedBy">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isReferencedBy</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:references">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:references</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:isReplacedBy">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isReplacedBy</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:replaces">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:replaces</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="dcterms:isRequiredBy">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:isRequiredBy</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:requires">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:requires</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

		<xsl:for-each select="dcterms:tableOfContents">
			<xsl:call-template name="create_elements_from_property">
				<xsl:with-param name="tgt_property">dcterms:tableOfContents</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>		

	</xsl:template>

	<xsl:template name="create_elements_from_property">
		<xsl:param name="tgt_property"/>
		<xsl:if test="text()">
		  	<xsl:element name="{$tgt_property}">
			<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="@rdf:resource">
		  <xsl:variable name="resource" select="@rdf:resource"/>
			<xsl:if test="/rdf:RDF/skos:Concept[@rdf:about=$resource]/skos:prefLabel/text()">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="/rdf:RDF/skos:Concept[@rdf:about=$resource]/skos:prefLabel/text()"/>
			  </xsl:element>
			</xsl:if>
			<!--<xsl:if test="/rdf:RDF/edm:Place[@rdf:about=$resource]/skos:prefLabel/text()">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="/rdf:RDF/edm:Place[@rdf:about=$resource]/skos:prefLabel/text()"/>
			  </xsl:element>
			</xsl:if>-->
			<xsl:if test="/rdf:RDF/edm:Place[@rdf:about=$resource]/skos:altLabel/text()">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="/rdf:RDF/edm:Place[@rdf:about=$resource]/skos:altLabel/text()"/>
			  </xsl:element>
			</xsl:if>
			<xsl:if test="/rdf:RDF/edm:Agent[@rdf:about=$resource]/skos:prefLabel/text()">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="/rdf:RDF/edm:Agent[@rdf:about=$resource]/skos:prefLabel/text()"/>
			  </xsl:element>
			</xsl:if>
			<xsl:if test="/rdf:RDF/edm:TimeSpan[@rdf:about=$resource]/skos:prefLabel/text()">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="/rdf:RDF/edm:TimeSpan[@rdf:about=$resource]/skos:prefLabel/text()"/>
			  </xsl:element>
			</xsl:if>
		  	<xsl:element name="{$tgt_property}">
			<xsl:value-of select="$resource"/>
			</xsl:element>
			<!--<xsl:for-each select="/rdf:RDF/skos:Conceptedm:[@rdf:about=$resource]">
			  <xsl:element name="{$tgt_property}">
			    <xsl:value-of select="skos:prefLabel/text()"/>
			  </xsl:element>
			</xsl:for-each>-->
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>


