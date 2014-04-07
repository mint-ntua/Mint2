<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="dpla" version="2.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dpla="http://dp.la"
  xmlns:europeana="http://www.europeana.eu/schemas/ese/"
  xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <europeana:metadata>
      <xsl:apply-templates select="/dpla:Metadata/dpla:record"/>
    </europeana:metadata>
  </xsl:template>
  <xsl:template match="/dpla:Metadata/dpla:record">
    <europeana:record>
      <xsl:for-each select="dc:title">
        <dc:title>
          <xsl:value-of select="."/>
        </dc:title>
      </xsl:for-each>
      <xsl:for-each select="dc:creator">
        <dc:creator>
          <xsl:value-of select="."/>
        </dc:creator>
      </xsl:for-each>
      <xsl:for-each select="dc:subject">
        <dc:subject>
          <xsl:value-of select="."/>
        </dc:subject>
      </xsl:for-each>
      <xsl:for-each select="dc:description">
        <dc:description>
          <xsl:value-of select="."/>
        </dc:description>
      </xsl:for-each>
      <xsl:for-each select="dc:publisher">
        <dc:publisher>
          <xsl:value-of select="."/>
        </dc:publisher>
      </xsl:for-each>
      <xsl:for-each select="dc:date">
        <dc:date>
          <xsl:value-of select="."/>
        </dc:date>
      </xsl:for-each>
      <xsl:for-each select="dc:identifier">
        <dc:identifier>
          <xsl:value-of select="."/>
        </dc:identifier>
      </xsl:for-each>
      <xsl:for-each select="dc:language">
        <dc:language>
          <xsl:value-of select="."/>
        </dc:language>
      </xsl:for-each>
      <xsl:for-each select="dc:relation">
        <dc:relation>
          <xsl:value-of select="."/>
        </dc:relation>
      </xsl:for-each>
      <europeana:provider>DPLA</europeana:provider>
      <europeana:type>TEXT</europeana:type>
      <europeana:rights/>
      <xsl:for-each select="dpla:dataSource">
        <xsl:if test="position() = 1">
          <europeana:dataProvider>
            <xsl:value-of select="."/>
          </europeana:dataProvider>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="dpla:contentLink">
        <xsl:if test="position() = 1">
          <europeana:isShownBy>
            <xsl:value-of select="."/>
          </europeana:isShownBy>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="dpla:contentLink">
        <xsl:if test="position() = 1">
          <europeana:isShownAt>
            <xsl:value-of select="."/>
          </europeana:isShownAt>
        </xsl:if>
      </xsl:for-each>
    </europeana:record>
  </xsl:template>
</xsl:stylesheet>
