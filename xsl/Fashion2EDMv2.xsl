<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xml" version="2.0"
  xmlns:crm="http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:edmfp="http://www.europeanafashion.eu/edmfp/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:gr="http://www.heppnetz.de/ontologies/goodrelations/v1#"
  xmlns:mrel="http://id.loc.gov/vocabulary/relators/"
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
  
  <xsl:variable name="var1">
    <item>true</item>
  </xsl:variable>
  
    
  <xsl:function name="edmfp:replaceSpace">
    <xsl:param name="input"/>
        <xsl:value-of select="translate($input, ' ', '_')"/>
  </xsl:function>
  
  <xsl:template match="/">
    <xsl:apply-templates select="/rdf:RDF"/>
  </xsl:template>
  
  
  <xsl:template match="/rdf:RDF">
    <xsl:for-each select=".">
      <rdf:RDF>
      
        <!-- Identifiers for providedCHO  -->
        <xsl:for-each select="edm:ProvidedCHO">
          <edm:ProvidedCHO>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
            <dc:contributor>
              <xsl:if test="dc:contributor/edm:Agent/skos:prefLabel | dc:contributor/edm:Agent/skos:altLabel">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="dc:contributor/edm:Agent">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="concat('http://demoAgentURL',edmfp:replaceSpace(skos:prefLabel), '/', edmfp:replaceSpace(skos:altLabel))"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </dc:contributor>
            <dc:creator>
              <xsl:if test="dcterms:creator/edm:Agent/skos:prefLabel | dcterms:creator/edm:Agent/skos:altLabel">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="dcterms:creator/edm:Agent">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="concat('http://demoAgentURL',edmfp:replaceSpace(skos:prefLabel), '/', edmfp:replaceSpace(skos:altLabel))"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </dc:creator>
            <xsl:for-each select="dc:date">
              <dc:date>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:date>
            </xsl:for-each>
            <xsl:for-each select="dc:description">
              <dc:description>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:description>
            </xsl:for-each>
            <xsl:for-each select="dc:format">
              <dc:format>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:format>
            </xsl:for-each>
            <xsl:for-each select="dc:identifier">
              <dc:identifier>
                <xsl:value-of select="."/>
              </dc:identifier>
            </xsl:for-each>
            <xsl:for-each select="dc:language">
              <dc:language>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:language>
            </xsl:for-each>
            <xsl:for-each select="dc:relation">
              <dc:relation>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:relation>
            </xsl:for-each>
            <xsl:for-each select="dc:rights">
              <dc:rights>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:rights>
            </xsl:for-each>
            <xsl:for-each select="dc:subject">
              <dc:subject>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:subject>
            </xsl:for-each>
            <xsl:for-each select="dc:title">
              <dc:title>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:title>
            </xsl:for-each>
            <dc:type>
              <xsl:if test="dc:type/skos:Concept/@rdf:about">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="dc:type/skos:Concept/@rdf:about">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </dc:type>
            <xsl:for-each select="dcterms:alternative">
              <dcterms:alternative>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dcterms:alternative>
            </xsl:for-each>
            <xsl:for-each select="edm:type">
              <xsl:if test="position() = 1">
                <xsl:if test="index-of($var0/item, replace(.,'^\s*(.+?)\s*$', '$1')) > 0">
                  <edm:type>
                    <xsl:value-of select="."/>
                  </edm:type>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="owl:sameAs">
              <owl:sameAs>
                <xsl:if test="@rdf:resource">
                  <xsl:attribute name="rdf:resource">
                    <xsl:for-each select="@rdf:resource">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </owl:sameAs>
            </xsl:for-each>
          </edm:ProvidedCHO>
        </xsl:for-each>
        <xsl:for-each select="ore:Aggregation/edm:object/edm:WebResource">
          <edm:WebResource>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
          </edm:WebResource>
        </xsl:for-each>
        <xsl:for-each select="ore:Aggregation/edm:isShownBy/edm:WebResource">
          <edm:WebResource>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
          </edm:WebResource>
        </xsl:for-each>
        <xsl:for-each select="ore:Aggregation/edm:isShownAt/edm:WebResource">
          <edm:WebResource>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
          </edm:WebResource>
        </xsl:for-each>
        <xsl:for-each select="ore:Aggregation/edm:hasView/edm:WebResource">
          <edm:WebResource>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
          </edm:WebResource>
        </xsl:for-each>
        <xsl:for-each select="edm:ProvidedCHO/dc:contributor/edm:Agent | ore:Aggregation/edm:dataProvider/edm:Agent | edm:ProvidedCHO/dcterms:creator/edm:Agent">
          <edm:Agent>
            <xsl:if test="skos:prefLabel | skos:altLabel">
              <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat('http://demoAgentURL',edmfp:replaceSpace(skos:prefLabel), '/', edmfp:replaceSpace(skos:altLabel))"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="skos:prefLabel">
              <skos:prefLabel>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </skos:prefLabel>
            </xsl:for-each>
            <xsl:for-each select="skos:altLabel">
              <skos:altLabel>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </skos:altLabel>
            </xsl:for-each>
            <xsl:for-each select="dc:identifier">
              <dc:identifier>
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang">
                    <xsl:for-each select="@xml:lang">
                      <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </dc:identifier>
            </xsl:for-each>
            <xsl:for-each select="edm:begin">
              <xsl:if test="position() = 1">
                <edm:begin>
                  <xsl:value-of select="."/>
                </edm:begin>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="edm:end">
              <xsl:if test="position() = 1">
                <edm:end>
                  <xsl:value-of select="."/>
                </edm:end>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="rdaGr2:biographicalInformation">
              <xsl:if test="position() = 1">
                <rdaGr2:biographicalInformation>
                  <xsl:if test="@xml:lang">
                    <xsl:attribute name="xml:lang">
                      <xsl:for-each select="@xml:lang">
                        <xsl:if test="position() = 1">
                          <xsl:value-of select="."/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </rdaGr2:biographicalInformation>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="rdaGr2:gender">
              <xsl:if test="position() = 1">
                <rdaGr2:gender>
                  <xsl:value-of select="."/>
                </rdaGr2:gender>
              </xsl:if>
            </xsl:for-each>
            <owl:sameAs>
              <xsl:if test="owl:sameAs/@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="owl:sameAs/@rdf:resource">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </owl:sameAs>
          </edm:Agent>
        </xsl:for-each>
        <xsl:for-each select="edm:ProvidedCHO/dc:type/skos:Concept">
          <skos:Concept>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
          </skos:Concept>
        </xsl:for-each>
        <xsl:for-each select="ore:Aggregation">
         <!-- Identifiers for ore:Aggregation are predifined -->
          <ore:Aggregation>
            <xsl:if test="@rdf:about">
              <xsl:attribute name="rdf:about">
                <xsl:for-each select="@rdf:about">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:if>
            
            <!-- Identifiers for edm:aggregatedCHO are predifined -->
            <xsl:for-each select="edm:aggregatedCHO">
              <xsl:if test="position() = 1">
                <edm:aggregatedCHO>
                  <xsl:if test="@rdf:resource">
                    <xsl:attribute name="rdf:resource">
                      <xsl:for-each select="@rdf:resource">
                        <xsl:if test="position() = 1">
                          <xsl:value-of select="."/>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </edm:aggregatedCHO>
              </xsl:if>
            </xsl:for-each>
            <edm:dataProvider>
              <xsl:if test="edm:dataProvider/edm:Agent//skos:prefLabel | edm:dataProvider/edm:Agent//skos:altLabel">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:dataProvider/edm:Agent">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="concat('http://demoAgentURL',edmfp:replaceSpace(skos:prefLabel), '/', edmfp:replaceSpace(skos:altLabel))"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:dataProvider>
            <edm:hasView>
              <xsl:if test="edm:hasView/edm:WebResource/@rdf:about">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:hasView/edm:WebResource/@rdf:about">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:hasView>
            <edm:isShownAt>
              <xsl:if test="edm:isShownAt/edm:WebResource/@rdf:about">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:isShownAt/edm:WebResource/@rdf:about">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:isShownAt>
            <edm:isShownBy>
              <xsl:if test="edm:isShownBy/edm:WebResource/@rdf:about">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:isShownBy/edm:WebResource/@rdf:about">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:isShownBy>
            <edm:object>
              <xsl:if test="edm:object/edm:WebResource/@rdf:about">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:object/edm:WebResource/@rdf:about">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:object>
            <edm:provider>
                <xsl:value-of select='EuropeanaFashion'/>
            </edm:provider>
            <edm:rights>
              <xsl:if test="edm:rights/@rdf:resource">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select="edm:rights/@rdf:resource">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:rights>
            <xsl:for-each select="edm:ugc">
              <xsl:if test="position() = 1">
                <xsl:if test="index-of($var1/item, replace(.,'^\s*(.+?)\s*$', '$1')) > 0">
                  <edm:ugc>
                    <xsl:value-of select="."/>
                  </edm:ugc>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
          </ore:Aggregation>
        </xsl:for-each>
      </rdf:RDF>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
