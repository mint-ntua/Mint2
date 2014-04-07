package gr.ntua.ivml.mint.rdf.thesauri;

import gr.ntua.ivml.mint.rdf.Repository;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.ResultSetFormatter;

public class SKOSThesaurus {
	
	static String SKOS = "PREFIX skos:<http://www.w3.org/2004/02/skos/core#>\n";
	
	/**
	 * repository - the SPARQL endpoint
	 */
	protected String repository = null;
	/**
	 * conceptScheme - the resource of the concept scheme to be examined in the query
	 */
	protected String conceptScheme = null; 
	/**
	 * language - the language selected for the labels
	 */
	protected String language = null; 
	/**
	 * rdfDatasets - the list of RDFDatasets (graphs)
	 */
	protected String[] rdfDatasets = null; 
	/**
	 * collections - the resulting terms of a query are checked for membership status (boolean) in this list of collections.
	 */
	protected String[] collections = null;
	/**
	 * includeDefault - If true, the repository's default graph is included in the search; if false the repository's default graph is not included in the search 
	 */
	protected boolean defaultIncluded = true;
	protected int limit = 0;
	protected int offset = 0;
	protected String like = null;
	protected String concept = null;
	
	
	public SKOSThesaurus(){}
	
	public SKOSThesaurus(String repository, String[] collections,String[] rdfDatasets, 
			String language, String conceptScheme, boolean defaultIncluded){
		this.repository = repository;
		this.collections = collections;
		this.rdfDatasets = rdfDatasets;
		this.language = language;
		this.conceptScheme = conceptScheme;
		this.defaultIncluded = defaultIncluded;
	}
	
	/**
	 * Evaluates the ConceptSchemes of the object 
	 * @return a list of Strings with the resources of type skos:ConceptSchemes of the given repository and RDFDataset
	 */
	public List<String> getConceptSchemes() {
		String select = "SELECT ?conceptScheme \n";
		String condition = "{ ?conceptScheme a skos:ConceptScheme } \n";
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((defaultIncluded)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}
	
	/**
	 * Evaluates the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	* @return a list of Strings with the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	 */
	public List<String> getLanguages() {
		String select = "SELECT distinct (lang(?o) as ?language) \n";
		String condition = "{	?concept ?p ?o .\n" +
				((conceptScheme != null)?"	?concept skos:inScheme <" + conceptScheme + "> \n":"") +
				"	FILTER ( lang(?o) != \"\" ) \n" +
				"}";
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((defaultIncluded)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}
	
	/**
	 * Evaluates the top concepts of a concept scheme, in the given repository existing in the given repository and RDFDatasets. The preferred labels are returned in the selected language
	 * @return a List<Map<String, String>> containing the top concept resources of the given repository and RDFDatasets along with their preferred labels in the language specified
	 */
	public List<Map<String, String>> getTopConcepts() {
		String select = "SELECT distinct ?concept (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("concept", "prefLabel");
		String condition = "	{\n" +
				"		{\n" +
				"			?concept skos:topConceptOf <"+conceptScheme+"> ;\n" +
				"			skos:prefLabel ?prefLabel. \n"+
							otherLangs +
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			<"+conceptScheme+"> skos:hasTopConcept ?concept .\n" +
				"			?concept skos:prefLabel ?prefLabel. \n"+
							otherLangs +
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			?concept a skos:Concept; \n"+
				"			skos:prefLabel ?prefLabel; \n" +
				"			skos:inScheme <"+conceptScheme+">.\n" +
							otherLangs +
				"			MINUS { ?concept skos:broaderTransitive ?o . ?o skos:inScheme <"+conceptScheme+"> }\n" +
				"			MINUS { ?concept skos:broader ?o1 . ?o1 skos:inScheme <"+conceptScheme+"> } \n" +
				"			MINUS { ?s skos:narrowerTransitive ?concept . ?s skos:inScheme <"+conceptScheme+"> }\n" +
				"			MINUS { ?s1 skos:narrower ?concept . ?s1 skos:inScheme <"+conceptScheme+"> } \n" +
				"		}\n" +
				"	}\n";
		String filter = "FILTER  (langMatches( lang(?prefLabel) , \"en\")) ";
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select + collectionsStr +
				"WHERE \n{\n" + 
				((defaultIncluded)?condition:"") 
				+ graphs + "\n" + filter +
				"}ORDER BY ?label";		
//		System.out.println(query);
		return Repository.queryMapList(repository, query);	
	}
	
	

	/**
	 * Gets the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 * @return the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 */
	public List<Map<String, String>> getConcepts() {
		String select = "SELECT distinct ?concept (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String select2 = "SELECT distinct ?concept (str(?prefLabel) as ?label) (str(?prefLabelLang) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("concept", "prefLabel");
		String condition = 		"{\n" +
				((conceptScheme != null)?"	?concept skos:inScheme <" + conceptScheme + "> .\n":"") +
				"	?concept a skos:Concept  .\n" +
				"	?concept skos:prefLabel ?prefLabel .\n" +
				((like == null)? otherLangs :"" )+
				"}\n";
		String filter = "FILTER( \n" +
				"	langMatches( lang(?prefLabel), \"" +
				((like != null)? language:"en")+
				"\" ) \n" +
				((like != null)?"			&& contains(?prefLabel, \"" + like + "\" ) \n":"") +
				") \n";	
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				((like == null)? select : select2) +
				collectionsStr +
				"WHERE \n{\n" + 
				((defaultIncluded)?condition:"") 
				+ graphs + "\n" + filter +
				"}ORDER BY ?label \n" +
				((limit > 0)?"LIMIT " + limit + "\n":"") +
				((offset > 0)?"OFFSET " + offset + "\n":"");

//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}
	
	public List<Map<String, String>> getNarrowerConcepts() {
		String select = "SELECT distinct (?narrower as ?concept) (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang)\n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("narrower", "prefLabel");
		String condition = "{{\n" +
				"	<" + concept + "> skos:narrower ?narrower.\n"+
				"	?narrower skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?narrower skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION" +
				"{\n" +
				"	<" + concept + "> skos:narrowerTransitive ?narrower.\n"+
				"	?narrower skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?narrower skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?narrower skos:broader <" + concept + ">.\n"+
				"	?narrower skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?narrower skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION" +
				"{\n" +
				"	?narrower skos:broaderTransitive <" + concept + ">.\n"+
				"	?narrower skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?narrower skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}}\n";
		String filter = "FILTER ( lang(?prefLabel) = \"en\" )\n";	
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((defaultIncluded)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}
	
	public List<Map<String, String>> getBroaderConcepts() {
		String select = "SELECT distinct (?broader as ?concept) (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang)\n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("broader", "prefLabel"); 
		String condition = "{{\n" +
				"	<" + concept + "> skos:broader ?broader.\n"+
				"	?broader skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?broader skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION" +
				"{\n" +
				"	<" + concept + "> skos:broaderTransitive ?broader.\n"+
				"	?broader skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?broader skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?broader skos:narrower <" + concept + ">.\n"+
				"	?broader skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?broader skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION" +
				"{\n" +
				"	?broader skos:narrowerTransitive <" + concept + ">.\n"+
				"	?broader skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?broader skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}}\n";
		String filter = "FILTER ( lang(?prefLabel) = \"en\" )\n";	
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((defaultIncluded)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}
	
	public List<Map<String, String>> getRelatedConcepts() {
		String select = "SELECT distinct (?related as ?concept) (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang)\n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("related", "prefLabel"); 
		String condition = "{{\n" +
				"	<" + concept + "> skos:related ?related.\n"+
				"	?related skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?related skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?related skos:related <" + concept + ">.\n"+
				"	?related skos:prefLabel ?prefLabel.\n"+
				((conceptScheme != null)?"	?related skos:inScheme <" + conceptScheme + "> \n":"") +
					otherLangs +
				"}}\n";
		String filter = "FILTER ( lang(?prefLabel) = \"en\" )\n";	
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((defaultIncluded)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}
	
	public List<Map<String, String>> getNotes(String property) {

		String select = "SELECT (str(?"+property+") as ?label) (str(?"+property+"En) as ?enlabel) (str(?"+property+"NoLang) as ?labelNoLang)\n";
//		String select = "SELECT ?"+property+" (str(?"+property+"En) as ?enlabel) (str(?"+property+"NoLang) as ?labelNoLang)\n";
		String condition = "{\n" +
				"	<" + concept + "> skos:"+property+" ?"+property+"En.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:"+property+" ?"+property+"."+ 
				"		FILTER ( lang(?"+property+") = \""+language+"\" )"+
				"	}"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:"+property+" ?"+property+"NoLang."+ 
				"		FILTER ( lang(?"+property+"NoLang) = \"\" )"+
				"	}"+
				"}\n";
		String filter = "FILTER ( lang(?"+property+"En) = \"en\" )\n";	
		String graphs = getFromGraphs(condition);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((defaultIncluded)?condition:"")+
				graphs + filter +
				"}\n";
//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}
	
	/**
	 * Creates a string in SPARQL syntax with the unions of graphs, when a query is performed to more than one dataset (graph) 
	 * @param condition - the condition to be checked in the various graphs 
	 */
	protected String getFromGraphs(String condition) {
		String graphs = "";
		if(rdfDatasets != null){
			for(int i = 0; i < rdfDatasets.length; i++)
				graphs = graphs + "	UNION \n" +
						"	{ \n" +
						"		GRAPH <" + rdfDatasets[i] + "> \n" +
						"		" + condition + "" +
						"	} \n";
		}
		if(!defaultIncluded)
			graphs = graphs.replaceFirst("	UNION ", "");
		return graphs;
	}
	
	protected String initCollections() {
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.length; i++){
				String collection = collections[i];
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		return collectionsStr;
	}
	protected String otherLangs(String conceptParam, String property){
		String otherLangs = 
				"	OPTIONAL { \n" +
				"		?"+conceptParam+" skos:"+property+" ?"+property+"Lang.\n"+ 
				"		FILTER ( lang(?"+property+"Lang) = \""+language+"\" )\n"+
				"	}\n"+
				"	OPTIONAL { \n" +
				"		?"+conceptParam+" skos:"+property+" ?"+property+"NoLang.\n"+ 
				"		FILTER ( lang(?"+property+"NoLang) = \"\" )\n"+
				"	}\n";
		return otherLangs;
	}
	public String getRepository() {
		return repository;
	}
	public void setRepository(String repository) {
		this.repository = repository;
	}
	public String getConceptScheme() {
		return conceptScheme;
	}
	public void setConceptScheme(String conceptScheme) {
		this.conceptScheme = conceptScheme;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String[] getRdfDatasets() {
		return rdfDatasets;
	}
	public void setRdfDatasets(String[] rdfDatasets) {
		this.rdfDatasets = rdfDatasets;
	}
	public String[] getCollections() {
		return collections;
	}
	public void setCollections(String[] collections) {
		this.collections = collections;
	}
	public boolean isDefaultIncluded() {
		return defaultIncluded;
	}
	public void setDefaultIncluded(boolean includeDefault) {
		this.defaultIncluded = includeDefault;
	}
	
	public static String getSKOS() {
		return SKOS;
	}

	public static void setSKOS(String sKOS) {
		SKOS = sKOS;
	}

	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public String getLike() {
		return like;
	}

	public void setLike(String like) {
		this.like = like;
	}
	
	public String getConcept() {
		return concept;
	}

	public void setConcept(String concept) {
		this.concept = concept;
	}

	public void resetAll() {	
		setRepository(null);
		setConceptScheme(null); 
		setLanguage(null); 
		setRdfDatasets(null);
		setCollections(null);
		setDefaultIncluded(true);
	}
	
	public static void main(String[] args){
		String repository = "http://panic.image.ece.ntua.gr:3030/thesauri/sparql";
//		String conceptScheme = "http://partage.vocnet.org/Materials";//only one top
//		String conceptScheme = "http://lod.image.ntua.gr/A-ConceptScheme";
		String conceptScheme = "";
//		String conceptScheme = "http://partage.vocnet.org/StylesAndPeriods";//many top concepts
//		String concept = "http://partage.vocnet.org/part00229";//hasNarrower
//		String concept = "http://partage.vocnet.org/part00565";//hasBroader
//		String concept = "http://lod.image.ntua.gr/A-Concept1";
		int limit = 0;
		int offset = 0;
		String like = null;
//		like = "tein";
		String language = "en";
		boolean defaultIncluded = true;
//		String[] collections = new String[2];
//		collections[0] = "http://lod.image.ntua.gr/A-CollectionEven";
//		collections[0] = "http://partage.vocnet.org/IndexingConcepts";
//		collections[1] = "http://partage.vocnet.org/NonIndexingConcepts";
		String[] graphs = new String[2];
		graphs[0] = "http://lod.image.ntua.gr/ConceptScheme1";
//		graphs[1] = "http://lod.image.ntua.gr/ConceptScheme2";
		
//		SKOSThesaurus skos = new SKOSThesaurus(repository,collections,
//				graphs,language,conceptScheme,defaultIncluded);
		
		SKOSThesaurus skos = new SKOSThesaurus(repository,null,
				graphs,language,conceptScheme,defaultIncluded);
		
//		skos.setLike(like);
//		skos.setLimit(limit);
//		skos.setOffset(offset);
//		skos.setConcept(concept);
		
//		System.out.println(skos.getConceptSchemes());//OK
//		System.out.println(skos.getLanguages());//OK
//		System.out.println(skos.getTopConcepts());//OK
//		System.out.println(skos.getConcepts());//OK
//		System.out.println(skos.getNarrowerConcepts());//OK
//		System.out.println(skos.getBroaderConcepts());//OK
//		System.out.println(skos.getNotes("scopeNote"));
//		System.out.println(skos.getNotes("note"));
//		System.out.println(skos.getNotes("notation"));
//		System.out.println(skos.getNotes("altLabel"));
	}

	

}
