package gr.ntua.ivml.mint.rdf.thesauri;

import gr.ntua.ivml.mint.rdf.Repository;
import gr.ntua.ivml.mint.util.JSONUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.ResultSetFormatter;
import com.hp.hpl.jena.sparql.resultset.JSONOutputResultSet;

/**
 * @author nsimou
 *
 */
public class Thesaurus {

	static String SKOS = "PREFIX skos:<http://www.w3.org/2004/02/skos/core#>\n";

	/**
	 * Evaluates the RDFDatasets of the given repository
	 * @param repository - the SPARQL endpoint
	 * @return a list of Strings with the RDFDatasets of the given repository
	 */
	public static List<String> getRDFDatasets(String repository) {
		String query = 
				"SELECT DISTINCT ?g WHERE { GRAPH ?g { ?s ?p ?o . } }";
		return Repository.queryList(repository, query);
	}

	/**
	 * Evaluates the ConceptSchemes of the given repository. Only the default repository is examined
	 * @param repository - the SPARQL endpoint
	 * @return a list of Strings with the resources of type skos:ConceptSchemes of the given repository
	 * @see #getConceptSchemes(String, String, boolean) 
	 * @see #getConceptSchemes(String, java.util.List, boolean)
	 */
	public static List<String> getConceptSchemes(String repository) {
		return getConceptSchemes(repository, new ArrayList<String>(), true);
	}

	/**
	 * Evaluates the ConceptSchemes of the given repository and RDFDataset
	 * @param repository - the SPARQL endpoint
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query 
	 * @return a list of Strings with the resources of type skos:ConceptSchemes of the given repository and RDFDataset
	 * @see #getConceptSchemes(String) 
	 * @see #getConceptSchemes(String, java.util.List, boolean)
	 */
	public static List<String> getConceptSchemes(String repository, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getConceptSchemes(repository, rdfDatasets, includeDefault);
	}

	/**
	 * Evaluates the ConceptSchemes of the given repository and RDFDatasets
	 * @param repository - the SPARQL endpoint
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query 
	 * @return a list of Strings with the resources of type skos:ConceptSchemes of the given repository and RDFDataset
	 * @see #getConceptSchemes(String) 
	 * @see #getConceptSchemes(String, String, boolean) 
	 */
	public static List<String> getConceptSchemes(String repository, List<String> rdfDatasets, boolean includeDefault) {
		String select = "SELECT ?conceptScheme \n";
		String condition = "{ ?conceptScheme a skos:ConceptScheme } \n";
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}

	/**
	 * Evaluates the Collections of the given repository. Only the default repository is examined
	 * @param repository - the SPARQL endpoint
	 * @return a list of Strings with the resources of type skos:Collection of the given repository
	 */
	public static List<String> getCollections(String repository) {
		return getCollections(repository, new ArrayList<String>(), true);
	}

	/**
	 * Evaluates the Collections of the given repository and RDFDataset
	 * @param repository - the SPARQL endpoint
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a list of Strings with the resources of type skos:Collection of the given repository
	 */
	public static List<String> getCollections(String repository, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getCollections(repository, rdfDatasets, includeDefault);
	}

	/**
	 * Evaluates the Collections of the given repository
	 * @param repository - the SPARQL endpoint
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a list of Strings with the resources of type skos:Collection of the given repository
	 */
	public static List<String> getCollections(String repository, List<String> rdfDatasets, boolean includeDefault) {
		String select = "SELECT ?collection \n";
		String condition = "{ ?collection a skos:Collection } \n";
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}

	/**
	 * Evaluates the Ordered Collections of the given repository. Only the default repository is examined
	 * @param repository - the SPARQL endpoint
	 * @return a list of Strings with the resources of type skos:OrderedCollection of the given repository
	 */
	public static List<String> getOrderedCollections(String repository) {
		return getOrderedCollections(repository, new ArrayList<String>(), true);
	}

	/**
	 * Evaluates the Ordered Collections of the given repository and RDFDataset
	 * @param repository - the SPARQL endpoint
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a list of Strings with the resources of type skos:OrderedCollection of the given repository
	 */
	public static List<String> getOrderedCollections(String repository, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getOrderedCollections(repository, rdfDatasets, includeDefault);
	}

	/**
	 * Evaluates the Ordered Collections of the given repository
	 * @param repository - the SPARQL endpoint
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a list of Strings with the resources of type skos:OrderedCollection of the given repository
	 */
	public static List<String> getOrderedCollections(String repository, List<String> rdfDatasets, boolean includeDefault) {
		String select = "SELECT ?orderedCollection \n";
		String condition = "{ ?orderedCollection a skos:OrderedCollection } \n";
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}



	/**
	 * Evaluates the top concepts of a concept scheme, in the given repository existing in the in the default repository. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @return a List<Map<String, String>> containing the top concept resources of the given repository and RDFDataset along with their preferred labels in the language specified
	 */
	public static List<Map<String, String>> getTopConcepts(String repository, String conceptScheme, String language) {
		return getTopConcepts(repository, conceptScheme, language, new ArrayList<String>(), new ArrayList<String>(), true);
	}
	
	public static List<Map<String, String>> getTopConcepts(String repository, String conceptScheme, String collection, String language) {
		ArrayList<String> collections = new ArrayList<String>();
		collections.add(collection);
		return getTopConcepts(repository, conceptScheme, language, new ArrayList<String>(), collections, true);
	}
	
	public static List<Map<String, String>> getTopConcepts(String repository, String conceptScheme, List<String> collections, String language) {
		return getTopConcepts(repository, conceptScheme, language, new ArrayList<String>(), collections, true);
	}

	/**
	 * Evaluates the top concepts of a concept scheme, in the given repository existing in the given repository and RDFDataset. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a List<Map<String, String>> containing the top concept resources of the given repository and RDFDataset along with their preferred labels in the language specified
	 */
	public static List<Map<String, String>> getTopConcepts(String repository, String conceptScheme, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getTopConcepts(repository, conceptScheme, language, rdfDatasets, new ArrayList<String>(), includeDefault);
	}

	/**
	 * Evaluates the top concepts of a concept scheme, in the given repository existing in the given repository and RDFDatasets. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a List<Map<String, String>> containing the top concept resources of the given repository and RDFDatasets along with their preferred labels in the language specified
	 */
	public static List<Map<String, String>> getTopConcepts(String repository, String conceptScheme, String language, List<String> rdfDatasets, List<String> collections, boolean includeDefault) {
		String select = "SELECT distinct ?concept (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		
		
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.size(); i++){
				String collection = collections.get(i);
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		String condition = "	{\n" +
				"		{\n" +
				"			?concept skos:topConceptOf <"+conceptScheme+"> ;\n" +
				"			skos:prefLabel ?prefLabel. \n"+
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelLang.\n"+ 
				"				FILTER ( lang(?prefLabelLang) = \""+language+"\" )\n"+
				"			}\n"+
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelNoLang.\n"+ 
				"				FILTER ( lang(?prefLabelNoLang) = \"\" )\n"+
				"			}\n"+
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			<"+conceptScheme+"> skos:hasTopConcept ?concept .\n" +
				"			?concept skos:prefLabel ?prefLabel. \n"+
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelLang.\n"+ 
				"				FILTER ( lang(?prefLabelLang) = \""+language+"\" )\n"+
				"			}\n"+
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelNoLang.\n"+ 
				"				FILTER ( lang(?prefLabelNoLang) = \"\" )\n"+
				"			}\n"+
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			?concept a skos:Concept; \n"+
				"			skos:prefLabel ?prefLabel; \n" +
				"			skos:inScheme <"+conceptScheme+">.\n" +
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelLang.\n"+ 
				"				FILTER ( lang(?prefLabelLang) = \""+language+"\" )\n"+
				"			}\n"+
				"			OPTIONAL { \n" +
				"				?concept skos:prefLabel ?prefLabelNoLang.\n"+ 
				"				FILTER ( lang(?prefLabelNoLang) = \"\" )\n"+
				"			}\n"+
				"			MINUS { ?concept skos:broaderTransitive ?o . }\n" +
				"			MINUS { ?concept skos:broader ?o1 . } \n" +
				"			MINUS { ?s skos:narrowerTransitive ?concept . }\n" +
				"			MINUS { ?s1 skos:narrower ?concept . } \n" +
				"		}\n" +
				"	}\n";
		String filter = "FILTER  (langMatches( lang(?prefLabel) , \"en\")) ";
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + collectionsStr +
				"WHERE \n{\n" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n" + filter +
				"}ORDER BY ?label";
		

		
		return Repository.queryMapList(repository, query);
		
		
	}

	/**
	 * Gets the concepts of the specified repository conceptScheme. The preferred labels are returned in English
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @return the concepts of the specified repository conceptScheme. The preferred labels are returned in English
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme) {
		return Thesaurus.getConcepts(repository, conceptScheme, "en", 0, 0, null, new ArrayList<String>(), new ArrayList<String>(), true);
	}

	/**
	 * Gets the concepts of the specified repository conceptScheme. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @return the concepts of the specified repository conceptScheme. The preferred labels are returned in the selected language
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language) {
		return Thesaurus.getConcepts(repository, conceptScheme, language, 0, 0, null, new ArrayList<String>(), new ArrayList<String>(), true);
	}

	/**
	 * Gets the concepts of the specified repository conceptScheme that their prefLabel matches string like. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param like - a sting to be searched in prefLabels of the concepts, if null then the string matching with prefLabel is ignored
	 * @return the concepts of the specified repository conceptScheme that their prefLabel matches string like. The preferred labels are returned in the selected language
	 * @see #getConcepts(String, String, String)
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, String like) {
		return Thesaurus.getConcepts(repository, conceptScheme, language, 0, 0, like, new ArrayList<String>(), new ArrayList<String>(), true);
	}
	/**
	 * Gets the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param limit - the limit of the results, if 0 limit is ignored
	 * @param offset - the offset of the results, if 0 offset is ignored
	 * @param like - a sting to be searched in prefLabels of the concepts, if null then the string matching with prefLabel is ignored
	 * @return the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, int limit, int offset, String like) {
		return getConcepts(repository, conceptScheme, language, limit, offset, like, new ArrayList<String>(), new ArrayList<String>(), true); 
	}
	
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, String collection, int limit, int offset, String like) {
		ArrayList<String> collections = new ArrayList<String>();
		collections.add(collection);
		return getConcepts(repository, conceptScheme, language, limit, offset, like, new ArrayList<String>(), collections, true); 
	}
	
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, List<String> collections, int limit, int offset, String like) {
		return getConcepts(repository, conceptScheme, language, limit, offset, like, new ArrayList<String>(), collections, true); 
	}

	/**
	 * Gets the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param limit - the limit of the results, if 0 limit is ignored
	 * @param offset - the offset of the results, if 0 offset is ignored
	 * @param like - a sting to be searched in prefLabels of the concepts, if null then the string matching with prefLabel is ignored
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, int limit, int offset, String like, String rdfDataset, boolean includeDefault) {
		ArrayList<String> dataset = new ArrayList<String>();
		dataset.add(rdfDataset);
		return getConcepts(repository, conceptScheme, language, limit, offset, like, dataset, new ArrayList<String>(), includeDefault);
	}


	/**
	 * Gets the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined, if null then concept scheme is ignored
	 * @param language - the language selected for the preferred labels, set to "" for literals with lang attribute
	 * @param limit - the limit of the results, if 0 limit is ignored
	 * @param offset - the offset of the results, if 0 offset is ignored
	 * @param like - a sting to be searched in prefLabels of the concepts, if null then the string matching with prefLabel is ignored
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return the concepts of the specified repository conceptScheme and RDFDatasets. The preferred labels are returned in the selected language
	 */
	public static List<Map<String, String>> getConcepts(String repository, String conceptScheme, String language, int limit, int offset, String like, List<String> rdfDatasets, List<String> collections, boolean includeDefault) {
		String select = "SELECT distinct ?concept (str(?prefLabel) as ?label) \n";
		
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.size(); i++){
				String collection = collections.get(i);
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		
		String condition = 		"{\n" +
				((conceptScheme != null)?"	?concept skos:inScheme <" + conceptScheme + "> .\n":"") +
				"	?concept a skos:Concept  .\n" +
				"	?concept skos:prefLabel ?prefLabel .\n" +
				"}\n";
		String filter = "FILTER( \n" +
				"	langMatches( lang(?prefLabel), \"" + language +"\" ) \n" +
				((like != null)?"			&& contains(?prefLabel, \"" + like + "\" ) \n":"") +
				") \n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + collectionsStr +
				"WHERE \n{\n" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n" + filter +
				"}ORDER BY ?label \n" +
				((limit > 0)?"LIMIT " + limit + "\n":"") +
				((offset > 0)?"OFFSET " + offset + "\n":"");

//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}

	//TODO Add Javadoc
	public static int getConceptsCount(String repository, String conceptScheme, String language, String like, List<String> rdfDatasets, boolean includeDefault) {
		String select = "SELECT (STR(COUNT(distinct ?concept)) as ?count) \n";
		String condition = 		"{\n" +
				((conceptScheme != null)?"	?concept skos:inScheme <" + conceptScheme + "> .\n":"") +
				"	?concept a skos:Concept  .\n" +
				"	?concept skos:prefLabel ?prefLabel .\n" +
				"}\n";
		String filter = "FILTER( \n" +
				"	langMatches( lang(?prefLabel), \"" + language +"\" ) \n" +
				((like != null)?"			&& contains(?prefLabel, \"" + like + "\" ) \n":"") +
				") \n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select +
				"WHERE \n{\n" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n" + filter + "\n}";

		return Integer.parseInt(Repository.queryFirst(repository, query));
	}

	//TODO Add Javadoc
	public static int getConceptsCount(String repository, String conceptScheme, String language, String like) {
		return getConceptsCount(repository, conceptScheme, language, like, new ArrayList<String>(),true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getPrefLabels(String repository, String concept, String language) {
		return getPrefLabels(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getPrefLabels(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getPrefLabels(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getPrefLabels(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNoLang)\n";
		String condition = "{\n" +
				"	<" + concept + "> skos:prefLabel ?prefLabel.\n"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:prefLabel ?prefLabelLang."+ 
				"		FILTER ( lang(?prefLabelLang) = \""+language+"\" )"+
				"	}"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:prefLabel ?prefLabelNoLang."+ 
				"		FILTER ( lang(?prefLabelNoLang) = \"\" )"+
				"	}"+
				"	<" + concept + "> a skos:Concept.\n"+
				"}\n";
		String filter = "FILTER ( lang(?prefLabel) = \"en\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";

		return Repository.queryMapList(repository, query);
	}

	//TODO Add Javadoc
	public static List<String> getAltLabels(String repository, String concept, String language) {
		return getAltLabels(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<String> getAltLabels(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getAltLabels(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<String> getAltLabels(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?altLabel) as ?label) \n";
		String condition = "{\n" +
				"	<" + concept + "> skos:altLabel ?altLabel.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"}\n";
		String filter = "FILTER ( lang(?altLabel) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";
		return Repository.queryList(repository, query);
	}

	//TODO Add Javadoc
	public static List<String> getHiddenLabels(String repository, String concept, String language) {
		return getHiddenLabels(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<String> getHiddenLabels(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getHiddenLabels(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<String> getHiddenLabels(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?hiddenLabel) as ?label) \n";
		String condition = "{\n" +
				"	<" + concept + "> skos:hiddenLabel ?hiddenLabel.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"}\n";
		String filter = "FILTER ( lang(?hiddenLabel) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";
		return Repository.queryList(repository, query);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getScopeNote(String repository, String concept, String language) {
		return getScopeNote(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getScopeNote(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getScopeNote(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getScopeNote(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?scopeNote) as ?label) (str(?scopeNoteEn) as ?enlabel) (str(?scopeNoteNoLang) as ?labelNoLang)\n";
		String condition = "{\n" +
				"	<" + concept + "> skos:scopeNote ?scopeNoteEn.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:scopeNote ?scopeNote."+ 
				"		FILTER ( lang(?prefLabelLang) = \""+language+"\" )"+
				"	}"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:scopeNote ?scopeNoteNoLang."+ 
				"		FILTER ( lang(?prefLabelNoLang) = \"\" )"+
				"	}"+
				"}\n";
		String filter = "FILTER ( lang(?scopeNoteEn) = \"en\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";
		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}

	//TODO Add Javadoc
	public static List<String> getNote(String repository, String concept, String language) {
		return getNote(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<String> getNote(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getNote(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<String> getNote(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?note) as ?label) \n";
		String condition = "{\n" +
				"	<" + concept + "> skos:note ?note.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"}\n";
		String filter = "FILTER ( lang(?note) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";
		return Repository.queryList(repository, query);
	}

	//TODO Add Javadoc
	public static List<String> getNotation(String repository, String concept, String language) {
		return getNotation(repository, concept,  language, new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<String> getNotation(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getNotation(repository, concept,  language, rdfDatasets, includeDefault);
	}

	//TODO Add Javadoc
	public static List<String> getNotation(String repository, String concept, String language, List<String> rdfDatasets, boolean includeDefault) {

		String select = "SELECT (str(?notation) as ?label) \n";
		String condition = "{\n" +
				"	<" + concept + "> skos:notation ?notation.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"}\n";
		String filter = "FILTER ( lang(?notation) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + 
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n";
		return Repository.queryList(repository, query);
	}

	public static List<Map<String, String>> getBroaderConcepts(String repository, String concept, String collection, String language) {
		ArrayList<String> collections = new ArrayList<String>();
		collections.add(collection);
		return getBroaderConcepts( repository,  concept,  language,  new ArrayList<String>(), collections, true);
	}
	
	public static List<Map<String, String>> getBroaderConcepts(String repository, String concept, List<String> collections, String language) {
		return getBroaderConcepts( repository,  concept,  language,  new ArrayList<String>(), collections, true);
	}
	
	//TODO Add Javadoc
	public static List<Map<String, String>> getBroaderConcepts(String repository, String concept, String language) {
		return getBroaderConcepts( repository,  concept,  language,  new ArrayList<String>(), new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getBroaderConcepts(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getBroaderConcepts( repository,  concept,  language,  rdfDatasets, new ArrayList<String>(), includeDefault);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getBroaderConcepts(String repository, String concept, String language, List<String> rdfDatasets, List<String> collections, boolean includeDefault) {
		String select = "SELECT distinct  (?broader as ?concept) (str(?broaderLabel) as ?label) \n";
		
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.size(); i++){
				String collection = collections.get(i);
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		
		String condition = "{{\n" +
				"	<" + concept + "> skos:broader ?broader.\n"+
				"	?broader skos:prefLabel ?broaderLabel.\n"+
				"}\n" +
				"UNION" +
				"{\n" +
				"	<" + concept + "> skos:broaderTransitive ?broader.\n"+
				"	?broader skos:prefLabel ?broaderLabel.\n"+
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?broader skos:narrower <" + concept + ">.\n"+
				"	?broader skos:prefLabel ?broaderLabel.\n"+
				"}\n" +
				"UNION" +
				"{\n" +
				"	?broader skos:narrowerTransitive <" + concept + ">.\n"+
				"	?broader skos:prefLabel ?broaderLabel.\n"+
				"}}\n";
		String filter = "FILTER ( lang(?broaderLabel) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
		return Repository.queryMapList(repository, query);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getNarrowerConcepts(String repository, String concept, String language) {
		return getNarrowerConcepts( repository,  concept,  language,  new ArrayList<String>(), new ArrayList<String>() , true);
	}
	
	public static List<Map<String, String>> getNarrowerConcepts(String repository, String concept, String collection, String language) {
		ArrayList<String> collections = new ArrayList<String>();
		collections.add(collection);
		return getNarrowerConcepts( repository,  concept,  language,  new ArrayList<String>(), collections , true);
	}
	
	public static List<Map<String, String>> getNarrowerConcepts(String repository, String concept, List<String> collections, String language) {
		return getNarrowerConcepts( repository,  concept,  language,  new ArrayList<String>(), collections , true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getNarrowerConcepts(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getNarrowerConcepts( repository,  concept,  language,  rdfDatasets, new ArrayList<String>(),  includeDefault);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getNarrowerConcepts(String repository, String concept, String language, List<String> rdfDatasets, List<String> collections, boolean includeDefault) {
		String select = "SELECT distinct (?narrower as ?concept) (str(?narrowerLabel) as ?label) \n";
		
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.size(); i++){
				String collection = collections.get(i);
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		
		String condition = "{{\n" +
				"	<" + concept + "> skos:narrower ?narrower.\n"+
				"	?narrower skos:prefLabel ?narrowerLabel.\n"+
				"}\n" +
				"UNION" +
				"{\n" +
				"	<" + concept + "> skos:narrowerTransitive ?narrower.\n"+
				"	?narrower skos:prefLabel ?narrowerLabel.\n"+
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?narrower skos:broader <" + concept + ">.\n"+
				"	?narrower skos:prefLabel ?narrowerLabel.\n"+
				"}\n" +
				"UNION" +
				"{\n" +
				"	?narrower skos:broaderTransitive <" + concept + ">.\n"+
				"	?narrower skos:prefLabel ?narrowerLabel.\n"+
				"}}\n";
		String filter = "FILTER ( lang(?narrowerLabel) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
//		System.out.println(query);
		return Repository.queryMapList(repository, query);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getRelatedConcepts(String repository, String concept, List<String> collections, String language) {
		return getRelatedConcepts( repository,  concept,  language,  new ArrayList<String>(), collections, true);
	}
	
	//TODO Add Javadoc
	public static List<Map<String, String>> getRelatedConcepts(String repository, String concept, String collection, String language) {
		ArrayList<String> collections = new ArrayList<String>();
		collections.add(collection);
		return getRelatedConcepts( repository,  concept,  language,  new ArrayList<String>(), collections, true);
	}
	
	
	//TODO Add Javadoc
	public static List<Map<String, String>> getRelatedConcepts(String repository, String concept, String language) {
		return getRelatedConcepts( repository,  concept,  language,  new ArrayList<String>(), new ArrayList<String>(), true);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getRelatedConcepts(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getRelatedConcepts( repository,  concept,  language,  rdfDatasets,  new ArrayList<String>(), includeDefault);
	}

	//TODO Add Javadoc
	public static List<Map<String, String>> getRelatedConcepts(String repository, String concept, String language, List<String> rdfDatasets, List<String> collections, boolean includeDefault) {
		String select = "SELECT distinct  (?related as ?concept) (str(?relatedLabel) as ?label) \n";
		
		String collectionsStr = "";
		if(collections != null){
			for(int i = 0; i < collections.size(); i++){
				String collection = collections.get(i);
				if(collection != null) {
					collectionsStr = collectionsStr+"(str(EXISTS {<"+collection+"> skos:member ?concept}) as ?list"+i+") \n";
				}
			}
		}
		
		String condition = "{{\n" +
				"	<" + concept + "> skos:related ?related.\n"+
				"	?related skos:prefLabel ?relatedLabel.\n"+
				"}\n" +
				"UNION\n" +
				"{\n" +
				"	?related skos:related <" + concept + ">.\n"+
				"	?related skos:prefLabel ?relatedLabel.\n"+
				"}}\n";
		String filter = "FILTER ( lang(?relatedLabel) = \"" + language + "\" )\n";	
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select + collectionsStr +
				"WHERE\n{"+
				((includeDefault)?condition:"")+
				graphs + filter +
				"}\n ORDER BY ?label";
		return Repository.queryMapList(repository, query);
	}
	
	//TODO Add Javadoc
		public static List<Map<String, String>> getCollectionConcepts(String repository, String concept, String language) {
			return getCollectionConcepts( repository,  concept,  language,  new ArrayList<String>(),  true);
		}

		//TODO Add Javadoc
		public static List<Map<String, String>> getCollectionConcepts(String repository, String concept, String language, String rdfDataset, boolean includeDefault) {
			ArrayList<String> rdfDatasets = new ArrayList<String>();
			rdfDatasets.add(rdfDataset);
			return getCollectionConcepts( repository,  concept,  language,  rdfDatasets,  includeDefault);
		}

		//TODO Add Javadoc
		public static List<Map<String, String>> getCollectionConcepts(String repository, String collection, String language, List<String> rdfDatasets, boolean includeDefault) {
			String select = "SELECT distinct ?concept (str(?prefLabel) as ?label) \n";
			String condition = "{\n" +
					"	<" + collection + "> skos:member ?concept.\n"+
					"	?concept skos:prefLabel ?prefLabel.\n"+
					"}\n";
			String filter = "FILTER ( lang(?prefLabel) = \"" + language + "\" )\n";	
			String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
			String query = SKOS +
					select + 
					"WHERE\n{"+
					((includeDefault)?condition:"")+
					graphs + filter +
					"}\n ORDER BY ?label";
			return Repository.queryMapList(repository, query);
		}

	public static void deleteConceptScheme(String updateEndpoint, String conceptScheme){
		String query = SKOS + 
				"DELETE\n"+ 
				"	{?s ?p ?o}\n" +
				"WHERE\n" +
				"{" +
				"	{\n" +
				"		 ?s skos:inScheme <" +conceptScheme + ">;\n" +	
				"   		 ?p ?o.\n" +
				"	}\n" +
				"	UNION\n" +
				"	{\n" +
				"		?s a skos:ConceptScheme.\n"+
				"		FILTER (?s = <" +conceptScheme + ">)\n"+
				"		?s ?p ?o.\n"+
				"	}"+
				"}";
//		System.out.println(query);
//		Repository.update(updateEndpoint,query);
	}

	/**
	 * Evaluates the languages used in literals of the given conceptScheme existing in the default repository
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @return a list of Strings with the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	 */
	public static List<String> getLanguages(String repository, String conceptScheme) {
		return getLanguages(repository, conceptScheme, new ArrayList<String>(), true);
	}

	/**
	 * Evaluates the languages used in literals of the given conceptScheme existing in the given repository and RDFDataset
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query	 
	 * @return a list of Strings with the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	 */
	public static List<String> getLanguages(String repository, String conceptScheme, String rdfDataset, boolean includeDefault) {
		ArrayList<String> rdfDatasets = new ArrayList<String>();
		rdfDatasets.add(rdfDataset);
		return getLanguages(repository, conceptScheme, rdfDatasets, includeDefault);
	}

	/**
	 * Evaluates the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	 * @param repository - the SPARQL endpoint
	 * @param conceptScheme - the resource of the concept scheme to be examined
	 * @param rdfDatasets - the list of RDFDatasets (graphs)
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query	 
	 * @return a list of Strings with the languages used in literals of the given conceptScheme existing in the given repository and RDFDatasets
	 */
	public static List<String> getLanguages(String repository, String conceptScheme, List<String> rdfDatasets, boolean includeDefault) {
		String select = "SELECT distinct (lang(?o) as ?language) \n";
		String condition = "{	?concept ?p ?o .\n" +
				((conceptScheme != null)?"	?concept skos:inScheme <" + conceptScheme + "> \n":"") +
				"	FILTER ( lang(?o) != \"\" ) \n" +
				"}";
		String graphs = getFromGraphs(rdfDatasets,condition,includeDefault);
		String query = SKOS +
				select +
				"WHERE \n{\n	" + 
				((includeDefault)?condition:"") 
				+ graphs + "\n}";
		return Repository.queryList(repository, query);
	}



	public static void reload(){
//		String updateEndpoint = "http://panic.image.ece.ntua.gr:3030/thesauri/update";
//		String ip = "192.168.0.4";
//		//		Sting ip = "147.102.11.183"
//		Repository.update(updateEndpoint, "DROP GRAPH <http://lod.image.ntua.gr/ConceptScheme1>");
//		Repository.update(updateEndpoint, "DROP GRAPH <http://lod.image.ntua.gr/ConceptScheme2>");
//		Repository.update(updateEndpoint, "DROP GRAPH <http://lod.image.ntua.gr/ConceptScheme3>");
//		Repository.update(updateEndpoint, "DROP GRAPH <http://lod.image.ntua.gr/ConceptScheme4>");
//		Thesaurus.deleteConceptScheme(updateEndpoint, "http://lod.image.ntua.gr/ConceptScheme");
//
//		//They should work but they don't
//		//		Repository.update(updateEndpoint, "LOAD <file:/Users/nsimou/Desktop/TestThesauri1.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme1>");
//		//		Repository.update(updateEndpoint, "LOAD <http://localhost:8080/TestThesauri/TestThesauri1.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme1>");
//
//		//Load to default repository
//		Repository.update(updateEndpoint, "LOAD <http://" + ip + ":8080/TestThesauri/TestThesauri.rdf>");
//		//Load to the http://lod.image.ntua.gr/ConceptScheme1
//		Repository.update(updateEndpoint, "LOAD <http://" + ip + ":8080/TestThesauri/TestThesauri1.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme1>");
//		Repository.update(updateEndpoint, "LOAD <http://" + ip + ":8080/TestThesauri/TestThesauri2.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme2>");
//		Repository.update(updateEndpoint, "LOAD <http://" + ip + ":8080/TestThesauri/TestThesauri3.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme3>");
//		Repository.update(updateEndpoint, "LOAD <http://" + ip + ":8080/TestThesauri/TestThesauri4.rdf> INTO <http://lod.image.ntua.gr/ConceptScheme4>");
	}

	/**
	 * Creates a string in SPARQL syntax with the unions of graphs, when a query is performed to more than one dataset (graph) 
	 * @param rdfDataset - the RDFDataset (graph)
	 * @param condition - the condition to be checked in the various graphs
	 * @param includeDefault - If true, includes the repository's default graph in the query; if false the repository's default graph is not included in the query
	 * @return a string in SPARQL syntax containing the unions of graphs  
	 */
	private static String getFromGraphs(List<String> rdfDatasets, String condition, boolean includeDefault) {
		String graphs = "";
		if(rdfDatasets != null){
			for(Iterator<String> it = rdfDatasets.iterator(); it.hasNext();)
				graphs = graphs + "	UNION \n" +
						"	{ \n" +
						"		GRAPH <" + it.next() + "> \n" +
						"		" + condition + "" +
						"	} \n";
		}
		if(!includeDefault)
			graphs = graphs.replaceFirst("	UNION ", "");
		return graphs;
	}
	
	private static void testFotisJSON(String repository, String conceptScheme, String collection, String lang){
		JSONObject json = new JSONObject();

		JSONArray concepts = JSONUtils.toJSON(gr.ntua.ivml.mint.rdf.thesauri.Thesaurus.getTopConcepts(repository, conceptScheme, collection, lang));
		json.put("repository", repository);
		json.put("collection", collection);
		json.put("conceptScheme", conceptScheme);
		json.put("concepts", concepts);
		System.out.println(json);
		
	}

	public static void main(String[] args) {
		String semNative = "http://panic.image.ece.ntua.gr:8080/openrdf-sesame/repositories/NativeThesauri";
		String sesPostgres = "http://panic.image.ece.ntua.gr:8080/openrdf-sesame/repositories/PostgresThesauri"; 
		String fuseki = "http://panic.image.ece.ntua.gr:3030/thesauri/sparql";
		String repository = fuseki;

		//		Thesaurus.reload();
		//Thesaurus.deleteConceptScheme(fuseki, "http://www.europeanafashion.eu/fashionVocabulary/Accesories");
		
		System.out.println(Thesaurus.getTopConcepts(repository, "http://lod.image.ntua.gr/ConceptScheme", "el"));//OK
		Thesaurus.testFotisJSON(repository, "http://lod.image.ntua.gr/ConceptScheme", "", "el");
//		System.out.println(Thesaurus.getPrefLabels(repository, "http://partage.vocnet.org/part00769", "sl", "", true));
//		System.out.println(Thesaurus.getScopeNote(repository, "http://partage.vocnet.org/part00769", "en", "", true));
		
//		System.out.println();
//		//Testing Thesaurus methods
		System.out.println(Thesaurus.getRDFDatasets(repository));//OK
//		System.out.println(Thesaurus.getConceptSchemes(repository));//OK
////		System.out.println(Thesaurus.getConceptSchemes(repository,"http://lod.image.ntua.gr/ConceptScheme1",true));//OK
////		System.out.println(Thesaurus.getConceptSchemes(repository,Thesaurus.getRDFDatasets(repository),false));//OK
		System.out.println(Thesaurus.getCollections(repository));//OK
////		System.out.println(Thesaurus.getCollections(repository,"http://lod.image.ntua.gr/ConceptScheme1",true));//Add a collection to Dataset ConceptScheme 1
////		System.out.println(Thesaurus.getCollections(repository,Thesaurus.getRDFDatasets(repository),false));
////		System.out.println(Thesaurus.getOrderedCollections(repository));
////		System.out.println(Thesaurus.getOrderedCollections(repository,"http://lod.image.ntua.gr/ConceptScheme1",true));//Add an ordered collection to Dataset ConceptScheme 1
////		System.out.println(Thesaurus.getOrderedCollections(repository,Thesaurus.getRDFDatasets(repository),false));
////		System.out.println(Thesaurus.getLanguages(repository, "http://www.imj.org.il/imagine/thesaurus/places/PlaceAuthority"));//OK
////		System.out.println(Thesaurus.getLanguages(repository,"http://lod.image.ntua.gr/ConceptScheme1","http://lod.image.ntua.gr/ConceptScheme1",false));//OK
////		System.out.println(Thesaurus.getLanguages(repository,"http://lod.image.ntua.gr/ConceptScheme1",Thesaurus.getRDFDatasets(repository),false));//OK
		
//		System.out.println(Thesaurus.getTopConcepts(repository, "http://lod.image.ntua.gr/ConceptScheme1", "en", "http://lod.image.ntua.gr/ConceptScheme1",false));//OK
//		
		
////		System.out.println(Thesaurus.getTopConcepts(repository, "http://lod.image.ntua.gr/ConceptScheme1", "en", Thesaurus.getRDFDatasets(repository),false));//OK
////	System.out.println(Thesaurus.getConcepts(repository, null,"",0,0,"Con",Thesaurus.getRDFDatasets(repository),true));//OK
////		System.out.println(Thesaurus.getConceptsCount(repository,null, "", "Con"));
////		System.out.println(Thesaurus.getConceptsCount(repository,null, "", "A-Con",Thesaurus.getRDFDatasets(repository),false));
////		System.out.println(Thesaurus.getConceptsCount(repository,null, "", "Con",Thesaurus.getRDFDatasets(repository),true));
		
//		System.out.println(Thesaurus.getAltLabels(repository, "http://lod.image.ntua.gr/A-Concept1", "en", Thesaurus.getRDFDatasets(repository), true));
//		System.out.println(Thesaurus.getHiddenLabels(repository, "http://lod.image.ntua.gr/A-Concept1", "en", Thesaurus.getRDFDatasets(repository), true));
//		System.out.println(Thesaurus.getNotation(repository, "http://lod.image.ntua.gr/A-Concept1", "en", Thesaurus.getRDFDatasets(repository), true));
//		System.out.println(Thesaurus.getNote(repository, "http://lod.image.ntua.gr/A-Concept1", "en", Thesaurus.getRDFDatasets(repository), true));
//		
//		System.out.println(Thesaurus.getBroaderConcepts(repository, "http://lod.image.ntua.gr/Concept1", "en"));
//		System.out.println(Thesaurus.getBroaderConcepts(repository, "http://lod.image.ntua.gr/Concept2", "en"));
//		System.out.println(Thesaurus.getBroaderConcepts(repository, "http://lod.image.ntua.gr/Concept3", "en"));
//		System.out.println(Thesaurus.getBroaderConcepts(repository, "http://lod.image.ntua.gr/Concept4", "en"));
//		System.out.println(Thesaurus.getBroaderConcepts(repository, "http://lod.image.ntua.gr/A-Concept2", "en", Thesaurus.getRDFDatasets(repository) ,false));
//		System.out.println(Thesaurus.getNarrowerConcepts(repository, "http://lod.image.ntua.gr/Concept1", "en"));
//		System.out.println(Thesaurus.getNarrowerConcepts(repository, "http://lod.image.ntua.gr/Concept2", "en"));
//		System.out.println(Thesaurus.getNarrowerConcepts(repository, "http://lod.image.ntua.gr/Concept3", "en"));
//		System.out.println(Thesaurus.getNarrowerConcepts(repository, "http://lod.image.ntua.gr/Concept4", "en"));
//		System.out.println(Thesaurus.getNarrowerConcepts(repository, "http://lod.image.ntua.gr/A-Concept1", "en", Thesaurus.getRDFDatasets(repository) ,false));
//		System.out.println(Thesaurus.getRelatedConcepts(repository, "http://lod.image.ntua.gr/Concept5", "en", Thesaurus.getRDFDatasets(repository) ,true));
//		System.out.println(Thesaurus.getRelatedConcepts(repository, "http://lod.image.ntua.gr/A-Concept6", "en", Thesaurus.getRDFDatasets(repository) ,false));
//		System.out.println(Thesaurus.getRelatedConcepts(repository, "http://lod.image.ntua.gr/A-Concept6", "en", Thesaurus.getRDFDatasets(repository) ,false));
		
//		System.out.println(Thesaurus.getConcepts(repository, "http://lod.image.ntua.gr/ConceptScheme","en", "http://lod.image.ntua.gr/CollectionEven", 0, 0, "Con"));//OK
		
//		System.out.println(Thesaurus.getTopConcepts(repository, "http://terminology.lido-schema.org", "http://terminology.lido-schema.org/IndexingConcepts", "en"));
	}

}
