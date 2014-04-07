<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:edmfp="http://www.europeanafashion.eu/edmfp/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:gn="http://www.geonames.org/ontology#"
  xmlns:ore="http://www.openarchives.org/ore/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dpla="http://dp.la/about/map/"
  xmlns:dcmi="http://purl.org/dc/dcmitype/"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="html" doctype-system="about:legacy-compat" />

<xsl:template match="/">

<xsl:variable name="imagesource">
         <xsl:value-of select="rdf:RDF/ore:Aggregation/edm:object/@rdf:resource"/>
</xsl:variable>



<xsl:variable name="institution">
 <xsl:if test="rdf:RDF/ore:Aggregation/edm:dataProvider">
		<xsl:value-of select="rdf:RDF/ore:Aggregation/edm:dataProvider"/>
</xsl:if>
</xsl:variable>

<xsl:variable name="theurl">
 	<xsl:value-of select="rdf:RDF/ore:Aggregation/edm:isShownAt/@rdf:resource"/>
</xsl:variable>

<xsl:variable name="dataprovider">
 <xsl:if test="rdf:RDF/ore:Aggregation/edm:provider">
		<xsl:value-of select="rdf:RDF/ore:Aggregation/edm:provider"/>
</xsl:if>
</xsl:variable>

<xsl:variable name="provider">
 <xsl:if test="rdf:RDF/ore:Aggregation/edm:dataProvider">
    	<xsl:value-of select="rdf:RDF/ore:Aggregation/edm:dataProvider"/>
</xsl:if>
</xsl:variable>

<xsl:variable name="creator">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:creator">
		<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:variable>

<xsl:variable name="publisher">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:publisher">
		<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:variable>

<xsl:variable name="itemformat">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:format">
		<xsl:value-of select="concat(.,'&lt;br/&gt;')"/>
</xsl:for-each>
</xsl:variable>

<xsl:variable name="itemtype">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:type">
		<xsl:value-of select="concat(.,'&lt;br/&gt;')"/>
</xsl:for-each>
</xsl:variable>

<xsl:variable name="dplaim">
<xsl:choose>
<xsl:when test="contains(lower-case($itemtype),'text')"><xsl:value-of select="'http://dp.la/assets/icon-text.gif'"/></xsl:when>
		  <xsl:when test="contains(lower-case($itemtype),'video')"><xsl:value-of select="'http://dp.la/assets/icon-video.gif'"/></xsl:when>
		  <xsl:when test="contains(lower-case($itemtype),'image')"><xsl:value-of select="'http://dp.la/assets/icon-image.gif'"/></xsl:when>
		  <xsl:when test="contains(lower-case($itemtype),'sound')"><xsl:value-of select="'http://dp.la/assets/icon-sound.gif'"/></xsl:when>
          </xsl:choose>
</xsl:variable>

<xsl:variable name="ddate">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:date">
		<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:variable>





<xsl:variable name="docdesc">
	<xsl:variable name="endesc">
				<xsl:if test="/rdf:RDF/dpla:SourceResource/dc:description[@xml:lang='en']">
				<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:description[@xml:lang='en']">
				<xsl:value-of select="concat(.,'&lt;br/&gt;')"></xsl:value-of>
				</xsl:for-each>
				</xsl:if>
	</xsl:variable>
	<xsl:if test="string-length($endesc)&gt;0"><xsl:value-of select="$endesc"/>
				
				<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:description[not(@xml:lang='en')]">
				<xsl:value-of select="concat(.,'&lt;br/&gt;')"></xsl:value-of>
				</xsl:for-each>
			
	</xsl:if>
	
	<xsl:if  test="string-length($endesc)=0">
	    <xsl:if test="/rdf:RDF/dpla:SourceResource/dc:description[1]">
		<xsl:value-of select="concat(/rdf:RDF/dpla:SourceResource/dc:description[1],'&lt;br/&gt;')"/>
		</xsl:if>
		<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:description">
		<xsl:if test="position() &gt; 1"><xsl:value-of select="concat(.,'&lt;br/&gt;')"></xsl:value-of></xsl:if>
		</xsl:for-each>
		
	</xsl:if>
</xsl:variable>


<xsl:variable name="rights">
<xsl:for-each select="/rdf:RDF/dpla:SourceResource/dc:rights">
		<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:variable>


<xsl:variable name="doctitle">
<xsl:choose>
<xsl:when test="/rdf:RDF/dpla:SourceResource/dc:title[@xml:lang='en']"><xsl:value-of select="/rdf:RDF/dpla:SourceResource/dc:title[@xml:lang='en']"></xsl:value-of></xsl:when>
<xsl:otherwise><xsl:value-of select="/rdf:RDF/dpla:SourceResource/dc:title"></xsl:value-of></xsl:otherwise>
</xsl:choose>
</xsl:variable>


<!--[if lt IE 7]> <html class="no-js lt-ie9 ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]> <html class="no-js lt-ie9 ie8"> <![endif]-->
<!--[if IE 8]> <html class="no-js lt-ie9 ie8"> <![endif]-->
<!--[if gt IE 8]> <!-->
<html><!-- <![endif]--><head>
<!--[if lte IE 7]><script src="/assets/lte-ie7.js" type="text/javascript"></script><![endif]-->
<link href="//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.css" rel="stylesheet"/> 

<link href="css/dplacss/application.css" media="all" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="css/dplacss/javascript/jquery.moreless.js"></script>
</head>
<body data-twttr-rendered="true" class="items-controller">
<div class="containerdpla">
<header role="banner">
<a href="http://dp.la/" class="logo"><img alt="DPLA: Digital Public Library of America" src="css/dplacss/images/logo.png"/>
</a>
</header>
<div class="clear"></div>
<div class="layout">


<h1><xsl:value-of select="$doctitle"/></h1>

<div class="FeatureContent">
<div class="contentBox">
<a><xsl:attribute name="href"><xsl:value-of select="$theurl"/></xsl:attribute>
             <img>
		       <xsl:attribute name="src">
		       <xsl:choose>
				  <xsl:when test="string-length($imagesource)&gt; 0"><xsl:value-of select="$imagesource"/></xsl:when>
				  <xsl:otherwise><xsl:value-of select="$dplaim"/></xsl:otherwise></xsl:choose></xsl:attribute>
				  	  <xsl:attribute name="onerror">this.src='<xsl:value-of select="$dplaim"/>'</xsl:attribute>
			     <xsl:attribute name="target">_blank</xsl:attribute> 
		     </img>
</a>
<a><xsl:attribute name="href"><xsl:value-of select="$theurl"/></xsl:attribute>
				<xsl:attribute name="class">ViewObject</xsl:attribute>
		       <xsl:attribute name="target">_blank</xsl:attribute><font style="color:#DD4E00;">View Object  </font>
		       <span><i class="icon-external-link" style="color:#DD4E00;"></i></span>
      	           
</a>
</div>
<div class="table">
<xsl:if test="$creator">
<ul><li><h6>Creator</h6></li><li><font color="black"><xsl:value-of select="$creator"/></font></li></ul>
</xsl:if>
<xsl:if test="string-length($ddate)&gt;0">
<ul><li><h6>Created Date</h6></li><li><font color="black"><xsl:value-of select="$ddate"/></font></li></ul>
</xsl:if>
<xsl:if test="string-length($provider)&gt;0">
<ul><li><h6>Provider</h6></li><li><font color="black"><xsl:value-of select="$provider"/></font></li></ul>
</xsl:if>
<xsl:if test="string-length($institution)&gt;0">
<ul><li><h6>Owning Institution</h6></li><li><font color="black"><xsl:value-of select="$institution"/></font></li></ul>
</xsl:if>
<xsl:if test="string-length($publisher)&gt;0">
<ul><li><h6>Publisher</h6></li><li><font color="black"><xsl:value-of select="$publisher"/></font></li></ul>
</xsl:if>


</div>
<div class="detail-bottom">
<xsl:if test="string-length($docdesc)&gt;0">
<h6>Description</h6>


	
			<xsl:if test="string-length($docdesc)&gt;0">
			
			<div class="more-less">
            <div class="text-block">
           		<p><font color="black">
					<xsl:value-of disable-output-escaping="yes" select="$docdesc"/></font>
			</p></div></div>		
			</xsl:if>
			
						
			
</xsl:if>
            



</div>
</div>
<div class="table">
<xsl:if test="string-length($itemformat)&gt;0">
<ul><li><h6>Format</h6></li><li><font color="black"><xsl:value-of disable-output-escaping="yes"  select="$itemformat"/></font></li></ul></xsl:if>
<xsl:if test="string-length($itemtype)&gt;0">
<ul><li><h6>Type</h6></li><li><font color="black"><xsl:value-of disable-output-escaping="yes"  select="$itemtype"/></font></li></ul></xsl:if>
<xsl:if test="rdf:RDF/dpla:SourceResource/dc:subject">
<ul>
<li>
<h6>Subject</h6>
</li>

<li>
<xsl:for-each select="rdf:RDF/dpla:SourceResource/dc:subject">
<a><xsl:attribute name="href"><xsl:value-of select="concat('http://dp.la/search?subject=',.)"></xsl:value-of></xsl:attribute><font color="#DD4E00"><xsl:value-of select="."/></font></a><br/>
</xsl:for-each>
</li>


</ul>
</xsl:if>
<ul><li><h6>Rights</h6></li><li><font color="black"><xsl:value-of select="$rights"/></font></li></ul>
<ul><li><h6>URL</h6></li><li>
<a><xsl:attribute name="href"><xsl:value-of select="$theurl"/></xsl:attribute>
<xsl:attribute name="target">_blank</xsl:attribute>
<font color="#DD4E00"><xsl:value-of select="$theurl"/></font>
   </a>
</li></ul></div>

</div>

</div>

</body></html>
</xsl:template>
  
</xsl:stylesheet>
