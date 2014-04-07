<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" doctype-system="about:legacy-compat"/>
<xsl:variable name="vallAbouts" select="/rdf:RDF/edm:ProvidedCHO/@rdf:about"/>
<xsl:template match="/">
<!--[if IE 8]><html xmlns:cc="http://creativecommons.org/ns#" xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xhv="http://www.w3.org/1999/xhtml/vocab#" class="ie ie8" lang=""><![endif]-->
<!--[if IE 9]><html xmlns:cc="http://creativecommons.org/ns#" xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xhv="http://www.w3.org/1999/xhtml/vocab#" class="ie ie9" lang=""><![endif]-->
<!--[if !IE]>-->
<html>
<!--<![endif]-->
<head>
<link rel="stylesheet" href="css/europeana/common.css"/>
<link rel="stylesheet" href="css/europeana/fulldoc.css"/>
<!--[if IE 8]><link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/ie8.min.css"/>
 <![endif]-->
 
<!--[if IE 9]><link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/ie9.min.css"/><![endif]-->
 
<style>	@media all and (min-width: 20em){		.euresponsive {			width: 0px;		}	}	@media all and (min-width:30em){		.euresponsive {			width: 1px;		}	}	@media all and (min-width:47em){		.euresponsive {			width: 2px;		}	}	@media all and (min-width:49em){		.euresponsive {			width: 3px;		}	}</style>
 
<!--[if IE]><link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/ie.min.css"/><![endif]-->
<!--[if lte IE 7]><link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/ie7.min.css"/><![endif]-->
 
<!--[if lte IE 8]>
<link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/ie8.min.css"/><![endif]-->
 
<noscript>
<link rel="stylesheet" href="http://www.europeana.eu/portal/themes/default/css/min/noscript.min.css"/>
</noscript>
<link rel="apple-touch-icon" href="http://www.europeana.eu/portal/themes/default/images/apple-touch-icon.png"/>
</head>
 
<body class="locale-en">
<xsl:for-each select="$vallAbouts">
<xsl:variable name="thisabout" select="."/>
<xsl:for-each select="/rdf:RDF/edm:ProvidedCHO[@rdf:about=$thisabout]">
<xsl:variable name="title">
<xsl:call-template name="doctitle">
<xsl:with-param name="mynode" select="current()"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="alternative">
<xsl:call-template name="alttitle">
<xsl:with-param name="mynode" select="current()"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="description">
<xsl:if test="current()/dc:description[1]">
<xsl:value-of select="current()/dc:description[1]"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="creator">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:creator"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="contributor">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:contributor"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="coverage">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:coverage"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="place">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:spatial"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="date">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:date"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:created"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="itemtype">
<xsl:if test="current()/edm:type">
<xsl:value-of select="current()/edm:type/text()"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="europeanaim">
<xsl:choose>
<xsl:when test="contains(lower-case($itemtype),'text')">
<xsl:value-of select="'http://europeanastatic.eu/api/image?type=TEXT'"/>
</xsl:when>
<xsl:when test="contains(lower-case($itemtype),'video')">
<xsl:value-of select="'http://europeanastatic.eu/api/image?type=VIDEO'"/>
</xsl:when>
<xsl:when test="contains(lower-case($itemtype),'image')">
<xsl:value-of select="'http://europeanastatic.eu/api/image?type=IMAGE'"/>
</xsl:when>
<xsl:when test="contains(lower-case($itemtype),'sound')">
<xsl:value-of select="'http://europeanastatic.eu/api/image?type=SOUND'"/>
</xsl:when>
<xsl:when test="contains(lower-case($itemtype),'3d')">
<xsl:value-of select="'http://europeanastatic.eu/api/image?type=3D'"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="temporal">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:temporal"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="issued">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:issued"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="type">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:type"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="format">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:format"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:medium"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:extent"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="subject">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:subject"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="identifier">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:identifier"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="relation">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:relation"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:references"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isReferencedBy"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isReplacedBy"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isRequiredBy"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:replaces"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isVersionOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:hasVersion"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:conformsTo"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:hasFormat"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isFormatOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:currentLocation"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:hasMet"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:hasType"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:incorporates"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isDerivativeOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isRelatedTo"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isRepresentationOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isSimilarTo"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isSuccessorOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="' '"/>
</xsl:call-template>
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:realizes"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="partof">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:isPartOf"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="haspart">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:hasPart"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="nsequence">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/edm:isNextInSequence"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="language">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:language"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="dcrights">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:rights"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="provenance">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dcterms:provenance"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="publisher">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:publisher"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="source">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="current()/dc:source"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:for-each select="/rdf:RDF/ore:Aggregation/edm:aggregatedCHO[@rdf:resource=$thisabout]">
<xsl:variable name="dataprovider">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="../edm:dataProvider"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="provider">
<xsl:call-template name="buildelems">
<xsl:with-param name="mynode" select="../edm:provider"/>
<xsl:with-param name="separator" select="' '"/>
<xsl:with-param name="breakafter" select="''"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="imagesource">
<xsl:choose>
<xsl:when test="../edm:object/@rdf:resource">
<xsl:value-of select="../edm:object/@rdf:resource"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../edm:isShownBy/@rdf:resource"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="rights">
<xsl:choose>
<xsl:when test="../edm:rights/@rdf:resource">
<xsl:value-of select="../edm:rights/@rdf:resource"/>
</xsl:when>
<xsl:when test="../edm:rights/text()">
<xsl:value-of select="../edm:rights/text()"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'http://www.europeana.eu/rights/unknown/'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="rightstitle">
<xsl:if test="contains($rights, 'europeana.eu/rights')">
<xsl:choose>
<xsl:when test="contains($rights, '/rr-f')">
<xsl:value-of select="'Rights Reserved - Free access'"/>
</xsl:when>
<xsl:when test="contains($rights, '/rr-p')">
<xsl:value-of select="'Rights Reserved - Paid access'"/>
</xsl:when>
<xsl:when test="contains($rights, '/rr-r')">
<xsl:value-of select="'Rights Reserved - Restricted access'"/>
</xsl:when>
<xsl:when test="contains($rights, '/unknown')">
<xsl:value-of select="'Unknown'"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="contains($rights, 'creativecommons.org')">
<xsl:choose>
<xsl:when test="contains($rights, 'publicdomain/mark/1.0/')">
<xsl:value-of select="' Public Domain Mark - No Known Copyright'"/>
</xsl:when>
<xsl:when test="contains($rights, 'publicdomain/zero/1.0')">
<xsl:value-of select="'CC0 - No Rights Reserved'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by/')">
<xsl:value-of select="'Attribution'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-sa/')">
<xsl:value-of select="'Attribution-ShareAlike'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc/')">
<xsl:value-of select="'Attribution, Non-Commercial'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nd/')">
<xsl:value-of select="'Attribution, No Derivatives'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc-nd/')">
<xsl:value-of select="'Attribution, Non-Commercial, No Derivatives'"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc-sa/')">
<xsl:value-of select="'Attribution, Non-Commercial, ShareAlike'"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="rightsspan">
<xsl:if test="contains($rights, 'europeana.eu/rights')">
<xsl:choose>
<xsl:when test="contains($rights, '/rr-f')">
<span class="rights-icon icon-copyright" title="Rights Reserved - Free access"/>
</xsl:when>
<xsl:when test="contains($rights, '/rr-p')">
<span class="rights-icon icon-copyright" title="Rights Reserved - Paid access"/>
</xsl:when>
<xsl:when test="contains($rights, '/rr-r')">
<span class="rights-icon icon-copyright" title="Rights Reserved - Restricted access"/>
</xsl:when>
<xsl:when test="contains($rights, '/unknown')">
<span class="rights-icon icon-unknown" title="Unknown"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="contains($rights, 'creativecommons.org')">
<xsl:choose>
<xsl:when test="contains($rights, 'publicdomain/mark/1.0/')">
<span class="rights-icon icon-pd" title="Public Domain marked"/>
</xsl:when>
<xsl:when test="contains($rights, 'publicdomain/zero/1.0')">
<span class="rights-icon icon-cczero" title="CC0"/>
</xsl:when>
<xsl:when test="contains($rights, '/by/')">
<span class="rights-icon icon-cc" title="CC BY"/>
 
<span class="rights-icon icon-by" title="CC BY"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-sa/')">
<span class="rights-icon icon-cc" title="CC BY-SA"/>
 
<span class="rights-icon icon-by" title="CC BY-SA"/>
 
<span class="rights-icon icon-sa" title="CC BY-SA"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc/')">
<span class="rights-icon icon-cc"/>
<span class="rights-icon icon-by"/>
<span class="rights-icon icon-sa"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nd/')">
<span class="rights-icon icon-cc" title="CC BY-ND"/>
 
<span class="rights-icon icon-by" title="CC BY-ND"/>
 
<span class="rights-icon icon-nd" title="CC BY-ND"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc-nd/')">
<span class="rights-icon icon-cc" title="CC BY-NC-ND"/>
 
<span class="rights-icon icon-by" title="CC BY-NC-ND"/>
 
<span class="rights-icon icon-nceu" title="CC BY-NC-ND"/>
 
<span class="rights-icon icon-nd" title="CC BY-NC-ND"/>
</xsl:when>
<xsl:when test="contains($rights, '/by-nc-sa/')">
<span class="rights-icon icon-cc" title="CC BY-NC-SA"/>
 
<span class="rights-icon icon-by" title="CC BY-NC-SA"/>
 
<span class="rights-icon icon-nceu" title="CC BY-NC-SA"/>
 
<span class="rights-icon icon-sa" title="CC BY-NC-SA"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="viewat">
<xsl:if test="../edm:isShownAt/@rdf:resource">
<xsl:value-of select="../edm:isShownAt/@rdf:resource"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="viewprovider">
<xsl:choose>
<xsl:when test="../edm:dataProvider/text()">
<xsl:value-of select="../edm:dataProvider/text()"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../edm:provider/text()"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<div class="containereuropeana">
<div id="ajax-feedback"/>
<div id="content" class="row"> 
<div class="twelve columns">
<div class="row">
<xsl:call-template name="additionalinfo">
<xsl:with-param name="title" select="$title"/>
<xsl:with-param name="imagesrc" select="$imagesource"/>
<xsl:with-param name="rights" select="$rights"/>
<xsl:with-param name="rightsspan" select="$rightsspan"/>
<xsl:with-param name="rightstitle" select="$rightstitle"/>
<xsl:with-param name="viewat" select="$viewat"/>
<xsl:with-param name="viewprovider" select="$viewprovider"/>
<xsl:with-param name="europeanaim" select="$europeanaim"/>
</xsl:call-template>
<div class="nine-cols-fulldoc" id="main-fulldoc-area">
<div id="excerpt">
<div id="item-details">
<div class="sidebar-right hide-on-x"> 
<div>
<strong>Search also for:</strong>
 </div>
<xsl:if test="string-length($title)>0">
<strong>Title</strong>
<ul> 
<li>
<xsl:variable name="titlehref">http://www.europeana.eu/portal/search.html?query=title%3a%22
<xsl:value-of select="$title"/>
%22&amp;rows=24</xsl:variable>
<a>
<xsl:attribute name="href">
<xsl:copy-of select="$titlehref"/>
</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:copy-of select="$title"/>
</a>
</li>
</ul>
</xsl:if>
<xsl:if test="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:creator/text() or ../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:contributor/text()">
<strong>Who</strong>
 
<ul>
<xsl:for-each select="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:creator/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=who%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
<xsl:for-each select="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:contributor/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=who%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
</ul>
</xsl:if>
<xsl:if test="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:subject/text() or ../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:format/text() or ../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:type/text()">
<strong>What</strong>
 
<ul>
<xsl:for-each select="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:type/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=what%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
<xsl:for-each select="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:subject/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=what%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
<xsl:for-each select="../../edm:ProvidedCHO[@rdf:about=$thisabout]/dc:format/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=what%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
</ul>
</xsl:if>
<xsl:if test="../edm:dataProvider or ./edm:provider">
<strong>Provider</strong>
 
<ul>
<xsl:for-each select="../edm:dataProvider/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=DATA_PROVIDER%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
<xsl:for-each select="../edm:provider/text()">
<li>
<a>
<xsl:attribute name="href">http://www.europeana.eu/portal/search.html?query=PROVIDER%3a%22
<xsl:value-of select="."/>
%22&amp;rows=24</xsl:attribute>
<xsl:attribute name="class">europeana</xsl:attribute>
<xsl:value-of select="."/>
</a>
</li>
</xsl:for-each>
</ul>
</xsl:if>
</div>
<h1 class="hide-on-phones" property="http://purl.org/dc/elements/1.1/title name dc:title">
<xsl:copy-of select="$title"/>
</h1>
<xsl:if test="string-length($alternative)>0">
<div class="item-metadata">
<span class="bold">Alternative Title: </span>
<xsl:copy-of select="$alternative"/>
</div>
</xsl:if>
<xsl:if test="string-length($description)>0">
<div id="item-description" class="item-metadata"> 
<span class="bold">Description: </span>
<xsl:copy-of select="$description"/>
</div>
</xsl:if>
<xsl:if test="string-length($subject)>0">
<div id="item-subject" class="item-metadata">
<span class="bold notranslate">Subject: </span>
<xsl:copy-of select="$subject"/>
</div>
</xsl:if>
<xsl:if test="string-length($creator)>0">
<div class="item-metadata">
<span class="bold">Creator: </span>
<xsl:copy-of select="$creator"/>
</div>
</xsl:if>
<xsl:if test="string-length($contributor)>0">
<div class="item-metadata"> 
<span class="bold">Contributor: </span>
<xsl:copy-of select="$contributor"/>
</div>
</xsl:if>
<xsl:if test="string-length($coverage)>0">
<div class="item-metadata"> 
<span class="bold">Place/Period: </span>
 
<xsl:copy-of select="$coverage"/>
</div>
</xsl:if>
<xsl:if test="string-length($place)>0">
<div class="item-metadata"> 
<span class="bold">Place: </span>
<xsl:copy-of select="$place"/>
</div>
</xsl:if>
<xsl:if test="string-length($date)>0">
<div class="item-metadata"> 
<span class="bold">Date: </span>
<xsl:copy-of select="$date"/>
</div>
</xsl:if>
<xsl:if test="string-length($temporal)>0">
<div class="item-metadata">
<span class="bold">Time Period: </span>
  
<xsl:copy-of select="$temporal"/>
</div>
</xsl:if>
<xsl:if test="string-length($issued)>0">
<div class="item-metadata">
<span class="bold">Publication date: </span>
 
<xsl:copy-of select="$issued"/>
</div>
</xsl:if>
<xsl:if test="string-length($type)>0">
<div class="item-metadata">
<span class="bold">Type: </span>
<xsl:copy-of select="$type"/>
</div>
</xsl:if>
<xsl:if test="string-length($format)>0">
<div class="item-metadata">
<span class="bold">Format: </span>
<xsl:copy-of select="$format"/>
</div>
</xsl:if>
<xsl:if test="string-length($identifier)>0">
<div class="item-metadata">
<span class="bold">Identifier: </span>
  
<xsl:copy-of select="$identifier"/>
</div>
</xsl:if>
<xsl:if test="string-length($relation)>0">
<div class="item-metadata">
<span class="bold">Relation: </span>
<xsl:copy-of select="$relation"/>
</div>
</xsl:if>
<xsl:if test="string-length($partof)>0">
<div class="item-metadata">
<span class="bold">Is part of: </span>
<xsl:copy-of select="$partof"/>
</div>
</xsl:if>
<xsl:if test="string-length($haspart)>0">
<div class="item-metadata">
<span class="bold">Has part: </span>
 
<xsl:copy-of select="$haspart"/>
</div>
</xsl:if>
<xsl:if test="string-length($nsequence)>0">
<div class="item-metadata">
<span class="bold">Next in sequence: </span>
<xsl:copy-of select="$nsequence"/>
</div>
</xsl:if>
<xsl:if test="string-length($language)>0">
<div class="item-metadata">
<span class="bold">Language: </span>
<xsl:copy-of select="$language"/>
</div>
</xsl:if>
<xsl:if test="string-length($dcrights)>0">
<div class="item-metadata">
<span class="bold">Rights: </span>
<xsl:copy-of select="$dcrights"/>
</div>
</xsl:if>
<xsl:if test="string-length($provenance)>0">
<div class="item-metadata">
<span class="bold">Provenance: </span>
<xsl:copy-of select="$provenance"/>
</div>
</xsl:if>
<xsl:if test="string-length($publisher)>0">
<div class="item-metadata">
<span class="bold">Publisher: </span>
<xsl:copy-of select="$publisher"/>
</div>
</xsl:if>
<xsl:if test="string-length($source)>0">
<div class="item-metadata">
<span class="bold">Source: </span>
<xsl:copy-of select="$source"/>
</div>
</xsl:if>
<xsl:if test="string-length($dataprovider)>0">
<div class="item-metadata">
<span class="bold">Data provider: </span>
<xsl:copy-of select="$dataprovider"/>
</div>
</xsl:if>
<xsl:if test="string-length($provider)>0">
<div class="item-metadata">
<span class="bold">Provider: </span>
<xsl:copy-of select="$provider"/>
</div>
</xsl:if>
</div>
 </div>
 </div>
 </div>
</div>
 </div>
</div>
</xsl:for-each>
<!-- ore:Aggregation -->
</xsl:for-each>
  
<!-- providedCHO -->
</xsl:for-each>
<xsl:variable name="theabouts">
<xsl:for-each select="/rdf:RDF/edm:ProvidedCHO/@rdf:about">
<xsl:value-of select="concat(.,',')"/>
</xsl:for-each>
</xsl:variable>
</body>
</html>
</xsl:template>
<xsl:template name="doctitle">
<xsl:param name="mynode"/>
<xsl:choose>
<xsl:when test="$mynode/dc:title"> 
<xsl:for-each select="$mynode/dc:title">
<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$mynode/dc:description[@xml:lang='en']">
<xsl:value-of select="dc:description[@xml:lang='en']"/>
</xsl:when>
<xsl:otherwise>
<xsl:if test="$mynode/dc:description[1]">
<xsl:if test="string-length( $mynode/dc:description[1] ) > 49">
<xsl:value-of select="concat(substring( $mynode/dc:description[1] ,0, 49 ),'...')"/>
</xsl:if>
<xsl:if test="string-length( $mynode/dc:description[1] ) &lt; 49">
<xsl:value-of select="$mynode/dc:description[1]"/>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="additionalinfo">
<xsl:param name="title"/>
<xsl:param name="imagesrc"/>
<xsl:param name="rights"/>
<xsl:param name="rightsspan"/>
<xsl:param name="rightstitle"/>
<xsl:param name="viewat"/>
<xsl:param name="viewprovider"/>
<xsl:param name="europeanaim"/>
<div class="three-cols-fulldoc-sidebar">
<div style="padding-top: 1em;" id="additional-info" class="sidebar">
<h2 id="phone-object-title" class="show-on-phones" aria-hidden="true">
<xsl:value-of select="$title"/>
</h2>
<div style="position: relative; text-align: center" id="carousel-1-img-measure">
<img>
<xsl:attribute name="src">
<xsl:choose>
<xsl:when test="string-length($imagesrc)> 0">
<xsl:value-of select="$imagesrc"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$europeanaim"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
<xsl:attribute name="style">cursor: pointer;max-width: 200px; height: auto;</xsl:attribute>
<xsl:attribute name="class"/>
</img>
<div style="display: none;" class="lb-trigger">
<span rel="#lightbox" title="View" class="icon-magplus label">View</span>
</div>
</div>
 
<div id="carousel-1" class="europeana-bordered"></div>
<div class="original-context">
<a>
<xsl:attribute name="href">
<xsl:value-of select="$rights"/>
</xsl:attribute>
<xsl:attribute name="target">_blank</xsl:attribute>
<xsl:attribute name="class">item-metadata  rights-badge</xsl:attribute>
<xsl:copy-of select="$rightsspan"/>
<span class="rights-text">
<xsl:value-of select="$rightstitle"/>
</span>
</a>
<div class="clear">View item at</div>
<a>
<xsl:attribute name="href">
<xsl:copy-of select="$viewat"/>
</xsl:attribute>
<xsl:attribute name="class">icon-external-right europeana underline external item-metadata</xsl:attribute>
<xsl:value-of select="$viewprovider"/>
</a>
<div class="clear"/>
</div>
<div class="actions"> 
<div class="action-link shares-link">
<span class="icon-share" title="Share item on Facebook, Twitter, etc.">
<span class="action-title" title="Share item on Facebook, Twitter, etc.">Share</span>
</span>
 </div>
<div> 
<a href="" id="citation-link" class="icon-cite action-link" title="Click to cite this object" rel="nofollow">
<span class="action-title">Cite on Wikipedia</span>
 </a>
 </div>
 
<div id="translate-container"> 
<span class="icon-translate"/>
<a class="disabled" href="" id="translate-item"> Translate details
<span class=""/>
 </a>
</div>
 </div>
 </div>
</div>
</xsl:template>
<xsl:template name="alttitle">
<xsl:param name="mynode"/>
<xsl:if test="$mynode/dcterms:alternative"> 
<xsl:for-each select="$mynode/dcterms:alternative">
<xsl:value-of select="concat(.,' ')"/>
</xsl:for-each>
</xsl:if>
</xsl:template>
<xsl:template name="buildelems">
<xsl:param name="mynode"/>
<xsl:param name="separator"/>
<xsl:param name="breakafter"/>
<xsl:if test="$mynode">
<xsl:for-each select="$mynode">
<xsl:variable name="textvar">
<xsl:if test="./text()">
<xsl:value-of select="."/>
</xsl:if>
</xsl:variable>
<xsl:variable name="link">
<xsl:if test="./@rdf:resource">
<xsl:value-of select="./@rdf:resource"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="textlink">
<xsl:choose>
<xsl:when test="string-length($textvar)>0">
<xsl:value-of select="$textvar"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$link"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string-length($link)>0">
<a>
<xsl:attribute name="href">
<xsl:value-of select="$link"/>
</xsl:attribute>
<xsl:value-of select="$textlink"/>
</a>
<xsl:value-of select="$separator"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$textvar"/>
<xsl:value-of select="$separator"/>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:value-of select="$breakafter"/>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
