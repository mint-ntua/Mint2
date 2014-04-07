<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsi gml xlink" version="2.0"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:lido="http://www.lido-schema.org"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="var0">
    <item>Acquisition</item>
    <item>Collecting</item>
    <item>Commissioning</item>
    <item>Creation</item>
    <item>Designing</item>
    <item>Destruction</item>
    <item>Excavation</item>
    <item>Exhibition</item>
    <item>Finding</item>
    <item>Loss</item>
    <item>Modification</item>
    <item>Move</item>
    <item>Part addition</item>
    <item>Part removal</item>
    <item>Performance</item>
    <item>Planning</item>
    <item>Production</item>
    <item>Provenance</item>
    <item>Publication</item>
    <item>Restoration</item>
    <item>Transformation</item>
    <item>Type assignment</item>
    <item>Type creation</item>
    <item>Use</item>
    <item>(Non-specified)</item>
  </xsl:variable>
  <xsl:variable name="var1">
    <item>Acquisition</item>
    <item>Collecting</item>
    <item>Commissioning</item>
    <item>Creation</item>
    <item>Designing</item>
    <item>Destruction</item>
    <item>Excavation</item>
    <item>Exhibition</item>
    <item>Finding</item>
    <item>Loss</item>
    <item>Modification</item>
    <item>Move</item>
    <item>Part addition</item>
    <item>Part removal</item>
    <item>Performance</item>
    <item>Planning</item>
    <item>Production</item>
    <item>Provenance</item>
    <item>Publication</item>
    <item>Restoration</item>
    <item>Transformation</item>
    <item>Type assignment</item>
    <item>Type creation</item>
    <item>Use</item>
    <item>(Non-specified)</item>
  </xsl:variable>
  <xsl:template match="/">
    <lido:lidoWrap>
      <xsl:apply-templates select="/lido:lidoWrap/lido:lido"/>
    </lido:lidoWrap>
  </xsl:template>
  <xsl:template match="/lido:lidoWrap/lido:lido">
    <xsl:for-each select=".">
      <lido:lido>
        <lido:lidoRecID>
          <xsl:for-each select="lido:lidoRecID/@lido:pref">
            <xsl:if test="position() = 1">
              <xsl:attribute name="lido:pref">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="lido:lidoRecID/@lido:type">
            <xsl:if test="position() = 1">
              <xsl:attribute name="lido:type">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="lido:lidoRecID/@lido:source">
            <xsl:if test="position() = 1">
              <xsl:attribute name="lido:source">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="lido:lidoRecID/@lido:encodinganalog">
            <xsl:if test="position() = 1">
              <xsl:attribute name="lido:encodinganalog">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="lido:lidoRecID/@lido:label">
            <xsl:if test="position() = 1">
              <xsl:attribute name="lido:label">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
          </xsl:for-each>
	  <xsl:for-each select="lido:lidoRecID">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </lido:lidoRecID>
        <xsl:for-each select="lido:category">
          <lido:category>
            <lido:conceptID>
              <xsl:for-each select="lido:conceptID/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:conceptID/@lido:type">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:type">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID/@lido:type">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:type">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID/@lido:type">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:type">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:conceptID/@lido:source">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:source">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID/@lido:source">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:source">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID/@lido:source">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:source">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:conceptID/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:conceptID/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:conceptID">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:conceptID">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:conceptID">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </lido:conceptID>
            <lido:term>
              <xsl:for-each select="lido:term/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term/@lido:pref">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:pref">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:term/@lido:addedSearchTerm">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:addedSearchTerm">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term/@lido:addedSearchTerm">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:addedSearchTerm">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term/@lido:addedSearchTerm">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:addedSearchTerm">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:term/@xml:lang">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term/@xml:lang">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term/@xml:lang">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:term/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term/@lido:encodinganalog">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:encodinganalog">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:term/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term/@lido:label">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="lido:label">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="lido:term">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewType/lido:term">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:for-each select="../lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet/lido:resourceViewSubjectTerm/lido:term">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </lido:term>
          </lido:category>
        </xsl:for-each>
        <xsl:for-each select="lido:descriptiveMetadata">
          <lido:descriptiveMetadata>
            <xsl:for-each select="@xml:lang">
              <xsl:if test="position() = 1">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="."/>
                </xsl:attribute>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="lido:objectClassificationWrap">
              <lido:objectClassificationWrap>
                <xsl:for-each select="lido:objectWorkTypeWrap">
                  <lido:objectWorkTypeWrap>
                    <xsl:for-each select="lido:objectWorkType">
                      <lido:objectWorkType>
                        <xsl:for-each select="lido:conceptID">
                          <lido:conceptID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:conceptID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:term">
                          <lido:term>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:addedSearchTerm">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:addedSearchTerm">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:term>
                        </xsl:for-each>
                      </lido:objectWorkType>
                    </xsl:for-each>
                  </lido:objectWorkTypeWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:classificationWrap">
                  <lido:classificationWrap>
                    <xsl:for-each select="lido:classification">
                      <lido:classification>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:conceptID">
                          <lido:conceptID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:conceptID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:term">
                          <lido:term>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:addedSearchTerm">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:addedSearchTerm">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:term>
                        </xsl:for-each>
                      </lido:classification>
                    </xsl:for-each>
                  </lido:classificationWrap>
                </xsl:for-each>
              </lido:objectClassificationWrap>
            </xsl:for-each>
            <xsl:for-each select="lido:objectIdentificationWrap">
              <lido:objectIdentificationWrap>
                <xsl:for-each select="lido:titleWrap">
                  <lido:titleWrap>
                    <xsl:for-each select="lido:titleSet">
                      <lido:titleSet>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:appellationValue">
                          <lido:appellationValue>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:appellationValue>
                        </xsl:for-each>
                        <xsl:for-each select="lido:sourceAppellation">
                          <lido:sourceAppellation>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:sourceAppellation>
                        </xsl:for-each>
                      </lido:titleSet>
                    </xsl:for-each>
                  </lido:titleWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:inscriptionsWrap">
                  <lido:inscriptionsWrap>
                    <xsl:for-each select="lido:inscriptions">
                      <lido:inscriptions>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select=".">
                          <lido:inscriptionTranscription>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:inscriptionTranscription>
                        </xsl:for-each>
                      </lido:inscriptions>
                    </xsl:for-each>
                  </lido:inscriptionsWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:repositoryWrap">
                  <lido:repositoryWrap>
                    <xsl:for-each select="lido:repositorySet">
                      <lido:repositorySet>
                        <xsl:for-each select="@lido:repositoryType">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:repositoryName">
                          <lido:repositoryName>
                            <xsl:for-each select="lido:legalBodyID">
                              <lido:legalBodyID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:legalBodyID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:legalBodyName">
                              <lido:legalBodyName>
                                <xsl:for-each select="lido:appellationValue">
                                  <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:appellationValue>
                                </xsl:for-each>
                                <xsl:for-each select="lido:sourceAppellation">
                                  <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:sourceAppellation>
                                </xsl:for-each>
                              </lido:legalBodyName>
                            </xsl:for-each>
                            <xsl:for-each select="lido:legalBodyWeblink">
                              <lido:legalBodyWeblink>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:formatResource">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:legalBodyWeblink>
                            </xsl:for-each>
                          </lido:repositoryName>
                        </xsl:for-each>
                        <xsl:for-each select="lido:workID">
                          <lido:workID>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:workID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:repositoryLocation">
                          <lido:repositoryLocation>
                            <xsl:for-each select="@lido:geographicalEntity">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:geographicalEntity">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:politicalEntity">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:politicalEntity">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:placeID">
                              <lido:placeID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:placeID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:namePlaceSet">
                              <lido:namePlaceSet>
                                <xsl:for-each select="lido:appellationValue">
                                  <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:appellationValue>
                                </xsl:for-each>
                                <xsl:for-each select="lido:sourceAppellation">
                                  <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:sourceAppellation>
                                </xsl:for-each>
                              </lido:namePlaceSet>
                            </xsl:for-each>
                            <xsl:for-each select="lido:gml">
                              <lido:gml>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                              </lido:gml>
                            </xsl:for-each>
                            <xsl:for-each select="lido:partOfPlace">
                              <lido:partOfPlace>
                                <xsl:for-each select="@lido:geographicalEntity">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:politicalEntity">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                              </lido:partOfPlace>
                            </xsl:for-each>
                            <xsl:for-each select="lido:placeClassification">
                              <lido:placeClassification>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="lido:conceptID">
                                  <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:conceptID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:term">
                                  <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:term>
                                </xsl:for-each>
                              </lido:placeClassification>
                            </xsl:for-each>
                          </lido:repositoryLocation>
                        </xsl:for-each>
                      </lido:repositorySet>
                    </xsl:for-each>
                  </lido:repositoryWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:displayStateEditionWrap">
                  <lido:displayStateEditionWrap>
                    <xsl:for-each select="lido:displayState">
                      <lido:displayState>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:displayState>
                    </xsl:for-each>
                    <xsl:for-each select="lido:displayEdition">
                      <lido:displayEdition>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:displayEdition>
                    </xsl:for-each>
                    <xsl:for-each select="lido:sourceStateEdition">
                      <lido:sourceStateEdition>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:sourceStateEdition>
                    </xsl:for-each>
                  </lido:displayStateEditionWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:objectDescriptionWrap">
                  <lido:objectDescriptionWrap>
                    <xsl:for-each select="lido:objectDescriptionSet">
                      <lido:objectDescriptionSet>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:descriptiveNoteValue">
                          <lido:descriptiveNoteValue>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:descriptiveNoteValue>
                        </xsl:for-each>
                        <xsl:for-each select="lido:sourceDescriptiveNote">
                          <lido:sourceDescriptiveNote>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:sourceDescriptiveNote>
                        </xsl:for-each>
                      </lido:objectDescriptionSet>
                    </xsl:for-each>
                  </lido:objectDescriptionWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:objectMeasurementsWrap">
                  <lido:objectMeasurementsWrap>
                    <xsl:for-each select="lido:objectMeasurementsSet">
                      <lido:objectMeasurementsSet>
                        <xsl:for-each select="lido:displayObjectMeasurements">
                          <lido:displayObjectMeasurements>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:displayObjectMeasurements>
                        </xsl:for-each>
                        <xsl:for-each select="lido:objectMeasurements">
                          <lido:objectMeasurements>
                            <xsl:for-each select="lido:measurementsSet">
                              <lido:measurementsSet>
                                <xsl:for-each select="@lido:type">
                                  <lido:measurementType>
                                    <xsl:for-each select="../@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:measurementType>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:unit">
                                  <lido:measurementUnit>
                                    <xsl:for-each select="../@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:measurementUnit>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:value">
                                  <xsl:if test="position() = 1">
                                    <lido:measurementValue>
                                    <xsl:for-each select="../@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:measurementValue>
                                  </xsl:if>
                                </xsl:for-each>
                              </lido:measurementsSet>
                            </xsl:for-each>
                            <xsl:for-each select="lido:extentMeasurements">
                              <lido:extentMeasurements>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:extentMeasurements>
                            </xsl:for-each>
                            <xsl:for-each select="lido:qualifierMeasurements">
                              <lido:qualifierMeasurements>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:qualifierMeasurements>
                            </xsl:for-each>
                            <xsl:for-each select="lido:formatMeasurements">
                              <lido:formatMeasurements>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:formatMeasurements>
                            </xsl:for-each>
                            <xsl:for-each select="lido:shapeMeasurements">
                              <lido:shapeMeasurements>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:shapeMeasurements>
                            </xsl:for-each>
                            <xsl:for-each select="lido:scaleMeasurements">
                              <lido:scaleMeasurements>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:scaleMeasurements>
                            </xsl:for-each>
                          </lido:objectMeasurements>
                        </xsl:for-each>
                      </lido:objectMeasurementsSet>
                    </xsl:for-each>
                  </lido:objectMeasurementsWrap>
                </xsl:for-each>
              </lido:objectIdentificationWrap>
            </xsl:for-each>
            <xsl:for-each select="lido:eventWrap">
              <lido:eventWrap>
                <xsl:for-each select="lido:eventSet">
                  <lido:eventSet>
                    <xsl:for-each select="lido:displayEvent">
                      <lido:displayEvent>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:displayEvent>
                    </xsl:for-each>
                    <xsl:for-each select="lido:event">
                      <lido:event>
                        <xsl:for-each select="lido:eventID">
                          <lido:eventID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:eventID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventType">
                          <lido:eventType>
                            <xsl:for-each select="lido:conceptID">
                              <xsl:if test="position() = 1">
                                <lido:conceptID>
                                  <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:value-of select="."/>
                                </lido:conceptID>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <xsl:if test="index-of($var0/item, normalize-space()) > 0">
                                <lido:term>
                                  <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:value-of select="."/>
                                </lido:term>
                              </xsl:if>
                            </xsl:for-each>
                          </lido:eventType>
                        </xsl:for-each>
                        <xsl:for-each select="lido:roleInEvent">
                          <lido:roleInEvent>
                            <xsl:for-each select="lido:conceptID">
                              <lido:conceptID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:conceptID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <lido:term>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:addedSearchTerm">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:roleInEvent>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventName">
                          <lido:eventName>
                            <xsl:for-each select="lido:appellationValue">
                              <lido:appellationValue>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:appellationValue>
                            </xsl:for-each>
                            <xsl:for-each select="lido:sourceAppellation">
                              <lido:sourceAppellation>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:sourceAppellation>
                            </xsl:for-each>
                          </lido:eventName>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventActor">
                          <lido:eventActor>
                            <xsl:for-each select="lido:displayActorInRole">
                              <lido:displayActorInRole>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayActorInRole>
                            </xsl:for-each>
                            <xsl:for-each select="lido:actorInRole">
                              <lido:actorInRole>
                                <xsl:for-each select="lido:actor">
                                  <lido:actor>
                                    <xsl:for-each select="@lido:actorType">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:actorID">
                                    <lido:actorID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:actorID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nameActorSet">
                                    <lido:nameActorSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:nameActorSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nationalityActor">
                                    <lido:nationalityActor>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:nationalityActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:vitalDatesActor">
                                    <lido:vitalDatesActor>
                                    <xsl:for-each select="@lido:birthDate">
                                    <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:deathDate">
                                    <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:vitalDatesActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:genderActor">
                                    <lido:genderActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:genderActor>
                                    </xsl:for-each>
                                  </lido:actor>
                                </xsl:for-each>
                                <xsl:for-each select="lido:roleActor">
                                  <lido:roleActor>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                  </lido:roleActor>
                                </xsl:for-each>
                                <xsl:for-each select="lido:attributionQualifierActor">
                                  <lido:attributionQualifierActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:attributionQualifierActor>
                                </xsl:for-each>
                                <xsl:for-each select="lido:extentActor">
                                  <lido:extentActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:extentActor>
                                </xsl:for-each>
                              </lido:actorInRole>
                            </xsl:for-each>
                          </lido:eventActor>
                        </xsl:for-each>
                        <xsl:for-each select="lido:culture">
                          <lido:culture>
                            <xsl:for-each select="lido:conceptID">
                              <lido:conceptID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:conceptID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <lido:term>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:addedSearchTerm">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:culture>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventDate">
                          <lido:eventDate>
                            <xsl:for-each select="lido:displayDate">
                              <lido:displayDate>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayDate>
                            </xsl:for-each>
                            <xsl:for-each select="lido:date">
                              <lido:date>
                                <xsl:for-each select="lido:earliestDate">
                                  <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="lido:latestDate">
                                  <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                  </xsl:if>
                                </xsl:for-each>
                              </lido:date>
                            </xsl:for-each>
                          </lido:eventDate>
                        </xsl:for-each>
                        <xsl:for-each select="lido:periodName">
                          <lido:periodName>
                            <xsl:for-each select="lido:conceptID">
                              <lido:conceptID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:conceptID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <lido:term>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:addedSearchTerm">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:periodName>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventPlace">
                          <lido:eventPlace>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:displayPlace">
                              <lido:displayPlace>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayPlace>
                            </xsl:for-each>
                            <xsl:for-each select="lido:place">
                              <lido:place>
                                <xsl:for-each select="@lido:geographicalEntity">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:politicalEntity">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="lido:placeID">
                                  <lido:placeID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:placeID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:namePlaceSet">
                                  <lido:namePlaceSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                  </lido:namePlaceSet>
                                </xsl:for-each>
                                <xsl:for-each select="lido:gml">
                                  <lido:gml>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                  </lido:gml>
                                </xsl:for-each>
                                <xsl:for-each select="lido:partOfPlace">
                                  <lido:partOfPlace>
                                    <xsl:for-each select="@lido:geographicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:politicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                  </lido:partOfPlace>
                                </xsl:for-each>
                                <xsl:for-each select="lido:placeClassification">
                                  <lido:placeClassification>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                  </lido:placeClassification>
                                </xsl:for-each>
                              </lido:place>
                            </xsl:for-each>
                          </lido:eventPlace>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventMethod">
                          <lido:eventMethod>
                            <xsl:for-each select="lido:conceptID">
                              <lido:conceptID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:conceptID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <lido:term>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:addedSearchTerm">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:eventMethod>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventMaterialsTech">
                          <lido:eventMaterialsTech>
                            <xsl:for-each select="lido:displayMaterialsTech">
                              <lido:displayMaterialsTech>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayMaterialsTech>
                            </xsl:for-each>
                            <xsl:for-each select="lido:materialsTech">
                              <lido:materialsTech>
                                <xsl:for-each select="lido:termMaterialsTech">
                                  <lido:termMaterialsTech>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                  </lido:termMaterialsTech>
                                </xsl:for-each>
                                <xsl:for-each select="lido:extentMaterialsTech">
                                  <lido:extentMaterialsTech>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:extentMaterialsTech>
                                </xsl:for-each>
                                <xsl:for-each select="lido:sourceMaterialsTech">
                                  <lido:sourceMaterialsTech>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:sourceMaterialsTech>
                                </xsl:for-each>
                              </lido:materialsTech>
                            </xsl:for-each>
                          </lido:eventMaterialsTech>
                        </xsl:for-each>
                        <xsl:for-each select="lido:thingPresent">
                          <lido:thingPresent>
                            <xsl:for-each select="lido:displayObject">
                              <lido:displayObject>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayObject>
                            </xsl:for-each>
                            <xsl:for-each select="lido:object">
                              <lido:object>
                                <xsl:for-each select="lido:objectWebResource">
                                  <lido:objectWebResource>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:formatResource">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectWebResource>
                                </xsl:for-each>
                                <xsl:for-each select="lido:objectID">
                                  <lido:objectID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:objectNote">
                                  <lido:objectNote>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectNote>
                                </xsl:for-each>
                              </lido:object>
                            </xsl:for-each>
                          </lido:thingPresent>
                        </xsl:for-each>
                        <xsl:for-each select="lido:relatedEventSet">
                          <lido:relatedEventSet>
                            <xsl:for-each select="lido:relatedEvent">
                              <lido:relatedEvent/>
                            </xsl:for-each>
                            <xsl:for-each select="lido:relatedEventRelType">
                              <lido:relatedEventRelType>
                                <xsl:for-each select="lido:conceptID">
                                  <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:conceptID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:term">
                                  <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:term>
                                </xsl:for-each>
                              </lido:relatedEventRelType>
                            </xsl:for-each>
                          </lido:relatedEventSet>
                        </xsl:for-each>
                        <xsl:for-each select="lido:eventDescriptionSet">
                          <lido:eventDescriptionSet>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:descriptiveNoteValue">
                              <lido:descriptiveNoteValue>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:descriptiveNoteValue>
                            </xsl:for-each>
                            <xsl:for-each select="lido:sourceDescriptiveNote">
                              <lido:sourceDescriptiveNote>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:sourceDescriptiveNote>
                            </xsl:for-each>
                          </lido:eventDescriptionSet>
                        </xsl:for-each>
                      </lido:event>
                    </xsl:for-each>
                  </lido:eventSet>
                </xsl:for-each>
              </lido:eventWrap>
            </xsl:for-each>
            <xsl:for-each select="lido:objectRelationWrap">
              <lido:objectRelationWrap>
                <xsl:for-each select="lido:subjectWrap">
                  <lido:subjectWrap>
                    <xsl:for-each select="lido:subjectSet">
                      <lido:subjectSet>
                        <xsl:for-each select="lido:displaySubject">
                          <lido:displaySubject>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:displaySubject>
                        </xsl:for-each>
                        <xsl:for-each select="lido:subject">
                          <lido:subject>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:extentSubject">
                              <lido:extentSubject>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:extentSubject>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectConcept">
                              <lido:subjectConcept>
                                <xsl:for-each select="lido:conceptID">
                                  <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:conceptID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:term">
                                  <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:term>
                                </xsl:for-each>
                              </lido:subjectConcept>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectActor">
                              <lido:subjectActor>
                                <xsl:for-each select="lido:displayActor">
                                  <lido:displayActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:displayActor>
                                </xsl:for-each>
                                <xsl:for-each select="lido:actor">
                                  <lido:actor>
                                    <xsl:for-each select="@lido:actorType">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:actorID">
                                    <lido:actorID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:actorID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nameActorSet">
                                    <lido:nameActorSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:nameActorSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nationalityActor">
                                    <lido:nationalityActor>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:nationalityActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:vitalDatesActor">
                                    <lido:vitalDatesActor>
                                    <xsl:for-each select="@lido:birthDate">
                                    <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:deathDate">
                                    <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:vitalDatesActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:genderActor">
                                    <lido:genderActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:genderActor>
                                    </xsl:for-each>
                                  </lido:actor>
                                </xsl:for-each>
                              </lido:subjectActor>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectDate">
                              <lido:subjectDate>
                                <xsl:for-each select="lido:displayDate">
                                  <lido:displayDate>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:displayDate>
                                </xsl:for-each>
                                <xsl:for-each select="lido:date">
                                  <lido:date>
                                    <xsl:for-each select="lido:earliestDate">
                                    <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:latestDate">
                                    <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                  </lido:date>
                                </xsl:for-each>
                              </lido:subjectDate>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectEvent">
                              <lido:subjectEvent>
                                <xsl:for-each select="lido:displayEvent">
                                  <lido:displayEvent>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:displayEvent>
                                </xsl:for-each>
                                <xsl:for-each select="lido:event">
                                  <lido:event>
                                    <xsl:for-each select="lido:eventID">
                                    <lido:eventID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:eventID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventType">
                                    <lido:eventType>
                                    <xsl:for-each select="lido:conceptID">
                                    <xsl:if test="position() = 1">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <xsl:if test="index-of($var1/item, normalize-space()) > 0">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:eventType>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:roleInEvent">
                                    <lido:roleInEvent>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:roleInEvent>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventName">
                                    <lido:eventName>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:eventName>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventActor">
                                    <lido:eventActor>
                                    <xsl:for-each select="lido:displayActorInRole">
                                    <lido:displayActorInRole>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:displayActorInRole>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:actorInRole">
                                    <lido:actorInRole>
                                    <xsl:for-each select="lido:actor">
                                    <lido:actor>
                                    <xsl:for-each select="@lido:actorType">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:actorID">
                                    <lido:actorID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:actorID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nameActorSet">
                                    <lido:nameActorSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:pref">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="xml:lang">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="xml:lang">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:nameActorSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:nationalityActor">
                                    <lido:nationalityActor>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:pref">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:type">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:source">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:pref">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:addedSearchTerm">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="xml:lang">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:nationalityActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:vitalDatesActor">
                                    <lido:vitalDatesActor>
                                    <xsl:for-each select="@lido:birthDate">
                                    <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:source">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:deathDate">
                                    <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="../@lido:source">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:source">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:encodinganalog">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:encodinganalog">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../@lido:label">
                                    <xsl:if test="position() = 1">

                                    <xsl:attribute name="lido:label">

                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:vitalDatesActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:genderActor">
                                    <lido:genderActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:genderActor>
                                    </xsl:for-each>
                                    </lido:actor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:roleActor">
                                    <lido:roleActor>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:roleActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:attributionQualifierActor">
                                    <lido:attributionQualifierActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:attributionQualifierActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:extentActor">
                                    <lido:extentActor>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:extentActor>
                                    </xsl:for-each>
                                    </lido:actorInRole>
                                    </xsl:for-each>
                                    </lido:eventActor>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:culture">
                                    <lido:culture>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:culture>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventDate">
                                    <lido:eventDate>
                                    <xsl:for-each select="lido:displayDate">
                                    <lido:displayDate>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:displayDate>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:date">
                                    <lido:date>
                                    <xsl:for-each select="lido:earliestDate">
                                    <xsl:if test="position() = 1">
                                    <lido:earliestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:earliestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:latestDate">
                                    <xsl:if test="position() = 1">
                                    <lido:latestDate>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:latestDate>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:date>
                                    </xsl:for-each>
                                    </lido:eventDate>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:periodName">
                                    <lido:periodName>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:periodName>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventPlace">
                                    <lido:eventPlace>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:displayPlace">
                                    <lido:displayPlace>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:displayPlace>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:place">
                                    <lido:place>
                                    <xsl:for-each select="@lido:geographicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:politicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:placeID">
                                    <lido:placeID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:placeID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:namePlaceSet">
                                    <lido:namePlaceSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:namePlaceSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:gml">
                                    <lido:gml>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:gml>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:partOfPlace">
                                    <lido:partOfPlace>
                                    <xsl:for-each select="@lido:geographicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:politicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:partOfPlace>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:placeClassification">
                                    <lido:placeClassification>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:placeClassification>
                                    </xsl:for-each>
                                    </lido:place>
                                    </xsl:for-each>
                                    </lido:eventPlace>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventMethod">
                                    <lido:eventMethod>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:eventMethod>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventMaterialsTech">
                                    <lido:eventMaterialsTech>
                                    <xsl:for-each select="lido:displayMaterialsTech">
                                    <lido:displayMaterialsTech>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:displayMaterialsTech>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:materialsTech">
                                    <lido:materialsTech>
                                    <xsl:for-each select="lido:termMaterialsTech">
                                    <lido:termMaterialsTech>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:termMaterialsTech>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:extentMaterialsTech">
                                    <lido:extentMaterialsTech>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:extentMaterialsTech>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceMaterialsTech">
                                    <lido:sourceMaterialsTech>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceMaterialsTech>
                                    </xsl:for-each>
                                    </lido:materialsTech>
                                    </xsl:for-each>
                                    </lido:eventMaterialsTech>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:thingPresent">
                                    <lido:thingPresent>
                                    <xsl:for-each select="lido:displayObject">
                                    <lido:displayObject>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:displayObject>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:object">
                                    <lido:object>
                                    <xsl:for-each select="lido:objectWebResource">
                                    <lido:objectWebResource>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:formatResource">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectWebResource>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectID">
                                    <lido:objectID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectNote">
                                    <lido:objectNote>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectNote>
                                    </xsl:for-each>
                                    </lido:object>
                                    </xsl:for-each>
                                    </lido:thingPresent>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:relatedEventSet">
                                    <lido:relatedEventSet>
                                    <xsl:for-each select="lido:relatedEvent">
                                    <lido:relatedEvent/>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:relatedEventRelType">
                                    <lido:relatedEventRelType>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:relatedEventRelType>
                                    </xsl:for-each>
                                    </lido:relatedEventSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:eventDescriptionSet">
                                    <lido:eventDescriptionSet>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:descriptiveNoteValue">
                                    <lido:descriptiveNoteValue>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:descriptiveNoteValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceDescriptiveNote">
                                    <lido:sourceDescriptiveNote>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceDescriptiveNote>
                                    </xsl:for-each>
                                    </lido:eventDescriptionSet>
                                    </xsl:for-each>
                                  </lido:event>
                                </xsl:for-each>
                              </lido:subjectEvent>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectPlace">
                              <lido:subjectPlace>
                                <xsl:for-each select="lido:displayPlace">
                                  <lido:displayPlace>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:displayPlace>
                                </xsl:for-each>
                                <xsl:for-each select="lido:place">
                                  <lido:place>
                                    <xsl:for-each select="@lido:geographicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:politicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:placeID">
                                    <lido:placeID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:placeID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:namePlaceSet">
                                    <lido:namePlaceSet>
                                    <xsl:for-each select="lido:appellationValue">
                                    <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:appellationValue>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:sourceAppellation">
                                    <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:sourceAppellation>
                                    </xsl:for-each>
                                    </lido:namePlaceSet>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:gml">
                                    <lido:gml>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:gml>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:partOfPlace">
                                    <lido:partOfPlace>
                                    <xsl:for-each select="@lido:geographicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:geographicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:politicalEntity">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:politicalEntity">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    </lido:partOfPlace>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:placeClassification">
                                    <lido:placeClassification>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:conceptID">
                                    <lido:conceptID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:conceptID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:term">
                                    <lido:term>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:addedSearchTerm">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:term>
                                    </xsl:for-each>
                                    </lido:placeClassification>
                                    </xsl:for-each>
                                  </lido:place>
                                </xsl:for-each>
                              </lido:subjectPlace>
                            </xsl:for-each>
                            <xsl:for-each select="lido:subjectObject">
                              <lido:subjectObject>
                                <xsl:for-each select="lido:displayObject">
                                  <lido:displayObject>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:displayObject>
                                </xsl:for-each>
                                <xsl:for-each select="lido:object">
                                  <lido:object>
                                    <xsl:for-each select="lido:objectWebResource">
                                    <lido:objectWebResource>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:formatResource">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectWebResource>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectID">
                                    <lido:objectID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectID>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectNote">
                                    <lido:objectNote>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                    </lido:objectNote>
                                    </xsl:for-each>
                                  </lido:object>
                                </xsl:for-each>
                              </lido:subjectObject>
                            </xsl:for-each>
                          </lido:subject>
                        </xsl:for-each>
                      </lido:subjectSet>
                    </xsl:for-each>
                  </lido:subjectWrap>
                </xsl:for-each>
                <xsl:for-each select="lido:relatedWorksWrap">
                  <lido:relatedWorksWrap>
                    <xsl:for-each select="lido:relatedWorksSet">
                      <lido:relatedWorkSet>
                        <xsl:for-each select="lido:relatedWork">
                          <lido:relatedWork>
                            <xsl:for-each select="lido:displayObject">
                              <lido:displayObject>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:displayObject>
                            </xsl:for-each>
                            <xsl:for-each select="lido:object">
                              <lido:object>
                                <xsl:for-each select="lido:objectWebResource">
                                  <lido:objectWebResource>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:formatResource">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectWebResource>
                                </xsl:for-each>
                                <xsl:for-each select="lido:objectID">
                                  <lido:objectID>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectID>
                                </xsl:for-each>
                                <xsl:for-each select="lido:objectNote">
                                  <lido:objectNote>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:type">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:objectNote>
                                </xsl:for-each>
                              </lido:object>
                            </xsl:for-each>
                          </lido:relatedWork>
                        </xsl:for-each>
                        <xsl:for-each select="lido:relatedWorkRelType">
                          <lido:relatedWorkRelType>
                            <xsl:for-each select="lido:conceptID">
                              <lido:conceptID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:conceptID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:term">
                              <lido:term>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:addedSearchTerm">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:addedSearchTerm">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:relatedWorkRelType>
                        </xsl:for-each>
                      </lido:relatedWorkSet>
                    </xsl:for-each>
                  </lido:relatedWorksWrap>
                </xsl:for-each>
              </lido:objectRelationWrap>
            </xsl:for-each>
          </lido:descriptiveMetadata>
        </xsl:for-each>
        <xsl:for-each select="lido:administrativeMetadata">
          <lido:administrativeMetadata>
            <xsl:for-each select="@xml:lang">
              <xsl:if test="position() = 1">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="."/>
                </xsl:attribute>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="lido:rightsWorkWrap">
              <lido:rightsWorkWrap>
                <xsl:for-each select="lido:rightsWorkSet">
                  <lido:rightsWorkSet>
                    <xsl:for-each select="lido:rightsType">
                      <lido:rightsType>
                        <xsl:for-each select=".">
                          <lido:term>
                            <xsl:attribute name="lido:addedSearchTerm">no</xsl:attribute>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:term>
                        </xsl:for-each>
                      </lido:rightsType>
                    </xsl:for-each>
                    <xsl:for-each select="lido:rightsDate">
                      <lido:rightsDate>
                        <xsl:for-each select="lido:earliestDate">
                          <xsl:if test="position() = 1">
                            <lido:earliestDate>
                              <xsl:for-each select="@lido:source">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:encodinganalog">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:label">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:value-of select="."/>
                            </lido:earliestDate>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:latestDate">
                          <xsl:if test="position() = 1">
                            <lido:latestDate>
                              <xsl:for-each select="@lido:source">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:encodinganalog">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:label">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:value-of select="."/>
                            </lido:latestDate>
                          </xsl:if>
                        </xsl:for-each>
                      </lido:rightsDate>
                    </xsl:for-each>
                    <xsl:for-each select="lido:rightsHolder">
                      <lido:rightsHolder>
                        <xsl:for-each select="lido:legalBodyID">
                          <lido:legalBodyID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:legalBodyID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:legalBodyName">
                          <lido:legalBodyName>
                            <xsl:for-each select="lido:appellationValue">
                              <lido:appellationValue>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:appellationValue>
                            </xsl:for-each>
                            <xsl:for-each select="lido:sourceAppellation">
                              <lido:sourceAppellation>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:sourceAppellation>
                            </xsl:for-each>
                          </lido:legalBodyName>
                        </xsl:for-each>
                        <xsl:for-each select="lido:legalBodyWeblink">
                          <lido:legalBodyWeblink>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:formatResource">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:formatResource">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:legalBodyWeblink>
                        </xsl:for-each>
                      </lido:rightsHolder>
                    </xsl:for-each>
                    <xsl:for-each select="lido:creditLine">
                      <lido:creditLine>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:creditLine>
                    </xsl:for-each>
                  </lido:rightsWorkSet>
                </xsl:for-each>
              </lido:rightsWorkWrap>
            </xsl:for-each>
            <xsl:for-each select="lido:recordWrap">
              <lido:recordWrap>
                <xsl:for-each select="lido:recordID">
                  <lido:recordID>
                    <xsl:for-each select="@lido:pref">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:pref">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="@lido:type">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:type">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="@lido:source">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:source">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="@lido:encodinganalog">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:encodinganalog">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="@lido:label">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:label">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="."/>
                  </lido:recordID>
                </xsl:for-each>
                <xsl:for-each select="lido:recordType">
                  <lido:recordType>
                    <xsl:for-each select=".">
                      <lido:term>
                        <xsl:attribute name="lido:addedSearchTerm">no</xsl:attribute>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:term>
                    </xsl:for-each>
                  </lido:recordType>
                </xsl:for-each>
                <xsl:for-each select="lido:recordSource">
                  <lido:recordSource>
                    <xsl:for-each select="lido:legalBodyID">
                      <lido:legalBodyID>
                        <xsl:for-each select="@lido:pref">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:pref">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:source">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:source">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:legalBodyID>
                    </xsl:for-each>
                    <xsl:for-each select="lido:legalBodyName">
                      <lido:legalBodyName>
                        <xsl:for-each select="lido:appellationValue">
                          <lido:appellationValue>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:appellationValue>
                        </xsl:for-each>
                        <xsl:for-each select="lido:sourceAppellation">
                          <lido:sourceAppellation>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:sourceAppellation>
                        </xsl:for-each>
                      </lido:legalBodyName>
                    </xsl:for-each>
                    <xsl:for-each select="lido:legalBodyWeblink">
                      <lido:legalBodyWeblink>
                        <xsl:for-each select="@lido:pref">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:pref">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:formatResource">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:formatResource">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:legalBodyWeblink>
                    </xsl:for-each>
                  </lido:recordSource>
                </xsl:for-each>
                <xsl:for-each select="lido:recordRights">
                  <lido:recordRights>
                    <xsl:for-each select="lido:rightsType">
                      <lido:rightsType>
                        <xsl:for-each select=".">
                          <lido:term>
                            <xsl:attribute name="lido:addedSearchTerm">no</xsl:attribute>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:term>
                        </xsl:for-each>
                      </lido:rightsType>
                    </xsl:for-each>
                    <xsl:for-each select="lido:rightsDate">
                      <lido:rightsDate>
                        <xsl:for-each select="lido:earliestDate">
                          <xsl:if test="position() = 1">
                            <lido:earliestDate>
                              <xsl:for-each select="@lido:source">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:encodinganalog">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:label">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:value-of select="."/>
                            </lido:earliestDate>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="lido:latestDate">
                          <xsl:if test="position() = 1">
                            <lido:latestDate>
                              <xsl:for-each select="@lido:source">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:encodinganalog">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="@lido:label">
                                <xsl:if test="position() = 1">
                                  <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                  </xsl:attribute>
                                </xsl:if>
                              </xsl:for-each>
                              <xsl:value-of select="."/>
                            </lido:latestDate>
                          </xsl:if>
                        </xsl:for-each>
                      </lido:rightsDate>
                    </xsl:for-each>
                    <xsl:for-each select="lido:rightsHolder">
                      <lido:rightsHolder>
                        <xsl:for-each select="lido:legalBodyID">
                          <lido:legalBodyID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:legalBodyID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:legalBodyName">
                          <lido:legalBodyName>
                            <xsl:for-each select="lido:appellationValue">
                              <lido:appellationValue>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:appellationValue>
                            </xsl:for-each>
                            <xsl:for-each select="lido:sourceAppellation">
                              <lido:sourceAppellation>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:sourceAppellation>
                            </xsl:for-each>
                          </lido:legalBodyName>
                        </xsl:for-each>
                        <xsl:for-each select="lido:legalBodyWeblink">
                          <lido:legalBodyWeblink>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:formatResource">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:formatResource">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:legalBodyWeblink>
                        </xsl:for-each>
                      </lido:rightsHolder>
                    </xsl:for-each>
                    <xsl:for-each select="lido:creditLine">
                      <lido:creditLine>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:creditLine>
                    </xsl:for-each>
                  </lido:recordRights>
                </xsl:for-each>
                <xsl:for-each select="lido:recordInfoSet">
                  <lido:recordInfoSet>
                    <xsl:for-each select="@lido:type">
                      <xsl:if test="position() = 1">
                        <xsl:attribute name="lido:type">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="lido:recordInfoID">
                      <lido:recordInfoID>
                        <xsl:for-each select="@lido:pref">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:pref">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:source">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:source">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:recordInfoID>
                    </xsl:for-each>
                    <xsl:for-each select="lido:recordInfoLink">
                      <lido:recordInfoLink>
                        <xsl:for-each select="@lido:pref">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:pref">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:formatResource">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:formatResource">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:recordInfoLink>
                    </xsl:for-each>
                    <xsl:for-each select="lido:recordMetadataDate">
                      <lido:recordMetadataDate>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:source">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:source">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:recordMetadataDate>
                    </xsl:for-each>
                  </lido:recordInfoSet>
                </xsl:for-each>
              </lido:recordWrap>
            </xsl:for-each>
            <xsl:for-each select="lido:resourceWrap">
              <lido:resourceWrap>
                <xsl:for-each select="lido:resourceSet">
                  <lido:resourceSet>
                    <xsl:for-each select="lido:resourceID">
                      <xsl:if test="position() = 1">
                        <lido:resourceID>
                          <xsl:for-each select="@lido:pref">
                            <xsl:if test="position() = 1">
                              <xsl:attribute name="lido:pref">
                                <xsl:value-of select="."/>
                              </xsl:attribute>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:for-each select="@lido:type">
                            <xsl:if test="position() = 1">
                              <xsl:attribute name="lido:type">
                                <xsl:value-of select="."/>
                              </xsl:attribute>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:for-each select="@lido:source">
                            <xsl:if test="position() = 1">
                              <xsl:attribute name="lido:source">
                                <xsl:value-of select="."/>
                              </xsl:attribute>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:for-each select="@lido:encodinganalog">
                            <xsl:if test="position() = 1">
                              <xsl:attribute name="lido:encodinganalog">
                                <xsl:value-of select="."/>
                              </xsl:attribute>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:for-each select="@lido:label">
                            <xsl:if test="position() = 1">
                              <xsl:attribute name="lido:label">
                                <xsl:value-of select="."/>
                              </xsl:attribute>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:value-of select="."/>
                        </lido:resourceID>
                      </xsl:if>
                    </xsl:for-each>
                    <lido:resourceRepresentation>
                      <xsl:for-each select="lido:linkResource">
                        <xsl:if test="position() = 1">
                          <lido:linkResource>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:formatResource">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:formatResource">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:linkResource>
                        </xsl:if>
                      </xsl:for-each>
                    </lido:resourceRepresentation>
                    <xsl:for-each select="lido:resourceType">
                      <lido:resourceType>
                        <xsl:for-each select="lido:conceptID">
                          <lido:conceptID>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:type">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:type">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:source">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:source">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:conceptID>
                        </xsl:for-each>
                        <xsl:for-each select="lido:term">
                          <lido:term>
                            <xsl:for-each select="@lido:pref">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:pref">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:addedSearchTerm">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:addedSearchTerm">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:term>
                        </xsl:for-each>
                      </lido:resourceType>
                    </xsl:for-each>
                    <xsl:for-each select="lido:resourceRelType">
                      <lido:resourceRelType/>
                    </xsl:for-each>
                    <xsl:for-each select="lido:resourceViewDescription">
                      <lido:resourceDescription>
                        <xsl:for-each select="@xml:lang">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:encodinganalog">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:encodinganalog">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:label">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:label">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:value-of select="."/>
                      </lido:resourceDescription>
                    </xsl:for-each>
                    <xsl:for-each select="lido:resourceViewDate">
                      <lido:resourceDateTaken>
                        <lido:date>
                          <xsl:for-each select="@lido:earliestdate">
                            <xsl:if test="position() = 1">
                              <lido:earliestDate>
                                <xsl:value-of select="."/>
                              </lido:earliestDate>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:for-each select="@lido:latestdate">
                            <xsl:if test="position() = 1">
                              <lido:latestDate>
                                <xsl:value-of select="."/>
                              </lido:latestDate>
                            </xsl:if>
                          </xsl:for-each>
                        </lido:date>
                      </lido:resourceDateTaken>
                    </xsl:for-each>
                    <xsl:for-each select="lido:resourceSource">
                      <lido:resourceSource>
                        <xsl:for-each select="@lido:type">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="lido:type">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>
                      </lido:resourceSource>
                    </xsl:for-each>
                    <xsl:for-each select="lido:rightsResource">
                      <lido:rightsResource>
                        <xsl:for-each select="lido:rightsType">
                          <lido:rightsType>
                            <xsl:for-each select=".">
                              <lido:term>
                                <xsl:attribute name="lido:addedSearchTerm">no</xsl:attribute>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:term>
                            </xsl:for-each>
                          </lido:rightsType>
                        </xsl:for-each>
                        <xsl:for-each select="lido:rightsDate">
                          <lido:rightsDate>
                            <xsl:for-each select="lido:earliestDate">
                              <xsl:if test="position() = 1">
                                <lido:earliestDate>
                                  <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:value-of select="."/>
                                </lido:earliestDate>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="lido:latestDate">
                              <xsl:if test="position() = 1">
                                <lido:latestDate>
                                  <xsl:for-each select="@lido:source">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                  </xsl:for-each>
                                  <xsl:value-of select="."/>
                                </lido:latestDate>
                              </xsl:if>
                            </xsl:for-each>
                          </lido:rightsDate>
                        </xsl:for-each>
                        <xsl:for-each select="lido:rightsHolder">
                          <lido:rightsHolder>
                            <xsl:for-each select="lido:legalBodyID">
                              <lido:legalBodyID>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:type">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:type">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:source">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:source">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:legalBodyID>
                            </xsl:for-each>
                            <xsl:for-each select="lido:legalBodyName">
                              <lido:legalBodyName>
                                <xsl:for-each select="lido:appellationValue">
                                  <lido:appellationValue>
                                    <xsl:for-each select="@lido:pref">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:appellationValue>
                                </xsl:for-each>
                                <xsl:for-each select="lido:sourceAppellation">
                                  <lido:sourceAppellation>
                                    <xsl:for-each select="@xml:lang">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:encodinganalog">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="@lido:label">
                                    <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="."/>
                                  </lido:sourceAppellation>
                                </xsl:for-each>
                              </lido:legalBodyName>
                            </xsl:for-each>
                            <xsl:for-each select="lido:legalBodyWeblink">
                              <lido:legalBodyWeblink>
                                <xsl:for-each select="@lido:pref">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:pref">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:formatResource">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:formatResource">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@xml:lang">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:encodinganalog">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:encodinganalog">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="@lido:label">
                                  <xsl:if test="position() = 1">
                                    <xsl:attribute name="lido:label">
                                    <xsl:value-of select="."/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="."/>
                              </lido:legalBodyWeblink>
                            </xsl:for-each>
                          </lido:rightsHolder>
                        </xsl:for-each>
                        <xsl:for-each select="lido:creditLine">
                          <lido:creditLine>
                            <xsl:for-each select="@xml:lang">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="xml:lang">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:encodinganalog">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:encodinganalog">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="@lido:label">
                              <xsl:if test="position() = 1">
                                <xsl:attribute name="lido:label">
                                  <xsl:value-of select="."/>
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>
                            <xsl:value-of select="."/>
                          </lido:creditLine>
                        </xsl:for-each>
                      </lido:rightsResource>
                    </xsl:for-each>
                  </lido:resourceSet>
                </xsl:for-each>
              </lido:resourceWrap>
            </xsl:for-each>
          </lido:administrativeMetadata>
        </xsl:for-each>
      </lido:lido>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
