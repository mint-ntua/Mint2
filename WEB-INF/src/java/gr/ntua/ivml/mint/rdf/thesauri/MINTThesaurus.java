package gr.ntua.ivml.mint.rdf.thesauri;

import gr.ntua.ivml.mint.rdf.Repository;

import java.util.List;
import java.util.Map;

public class MINTThesaurus extends SKOSThesaurus {
	
	public MINTThesaurus(String repository, String[] collections,String[] rdfDatasets, 
			String language, String conceptScheme, boolean defaultIncluded){
		super(repository, collections,rdfDatasets, language, conceptScheme,defaultIncluded);
	}
	
	/**
	 * Evaluates the top concepts of a concept scheme, in the given repository existing in the given repository and RDFDatasets. The preferred labels are returned in the selected language
	 * @return a List<Map<String, String>> containing the top concept resources of the given repository and RDFDatasets along with their preferred labels in the language specified
	 */
	public List<Map<String, String>> getTopConcepts(String rangeOfProperyAsValue) {
		String select = "SELECT distinct ?concept (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("concept", "prefLabel");
		String condition = "	{\n" +
				"		{\n" +
				"			?conceptID skos:topConceptOf <"+conceptScheme+"> ;\n" +
				"			<"+rangeOfProperyAsValue+"> ?concept ;\n" +
				"			skos:prefLabel ?prefLabel. \n"+
							otherLangs +
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			<"+conceptScheme+"> skos:hasTopConcept ?conceptID .\n" +
				"			?conceptID skos:prefLabel ?prefLabel. \n"+
				"			?conceptID <"+rangeOfProperyAsValue+"> ?concept .\n" +
							otherLangs +
				"		}\n" +
				"		UNION\n" +
				"		{\n" +
				"			?conceptID a skos:Concept; \n"+
				"			<"+rangeOfProperyAsValue+"> ?concept ;\n" +
				"			skos:prefLabel ?prefLabel; \n" +
				"			skos:inScheme <"+conceptScheme+">.\n" +
							otherLangs +
				"			MINUS { ?conceptID skos:broaderTransitive ?o . ?conceptID <"+rangeOfProperyAsValue+"> ?concept . ?o skos:inScheme <"+conceptScheme+"> }\n" +
				"			MINUS { ?conceptID skos:broader ?o1 . ?conceptID <"+rangeOfProperyAsValue+"> ?concept . ?o1 skos:inScheme <"+conceptScheme+"> } \n" +
				"			MINUS { ?s skos:narrowerTransitive ?conceptID . ?conceptID <"+rangeOfProperyAsValue+"> ?concept . ?s skos:inScheme <"+conceptScheme+"> }\n" +
				"			MINUS { ?s1 skos:narrower ?conceptID . ?conceptID <"+rangeOfProperyAsValue+"> ?concept . ?s1 skos:inScheme <"+conceptScheme+"> } \n" +
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
	public List<Map<String, String>> getConcepts(String rangeOfProperyAsValue) {
		String select = "SELECT distinct ?concept (str(?prefLabelLang) as ?label) (str(?prefLabel) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String select2 = "SELECT distinct ?concept (str(?prefLabel) as ?label) (str(?prefLabelLang) as ?enlabel) (str(?prefLabelNoLang) as ?labelNolang) \n";
		String collectionsStr = initCollections();
		String otherLangs = otherLangs("concept", "prefLabel");
		String condition = 		"{\n" +
				((conceptScheme != null)?"	?conceptID skos:inScheme <" + conceptScheme + "> .\n":"") +
				"	?conceptID a skos:Concept  .\n" +
				"	?conceptID skos:prefLabel ?prefLabel .\n" +
				"	?conceptID <"+rangeOfProperyAsValue+"> ?concept .\n" +
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
	
	public List<Map<String, String>> getNotes(String property) {

		String select = "SELECT (str(?"+property+") as ?label) (str(?"+property+"En) as ?enlabel) (str(?"+property+"NoLang) as ?labelNoLang)\n";
		String condition = "{\n" +
				"	<" + concept + "> skos:"+property+" ?"+property+"NoLang.\n"+
				"	<" + concept + "> a skos:Concept.\n"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:"+property+" ?"+property+"."+ 
				"		FILTER ( lang(?"+property+") = \""+language+"\" )"+
				"	}"+
				"	OPTIONAL { " +
				"		<" + concept + "> skos:"+property+" ?"+property+"En."+ 
				"		FILTER ( lang(?"+property+"En) = \"en\" )"+
				"	}"+
				"}\n";
		String filter = "FILTER ( lang(?"+property+"NoLang) = \"\" )\n";	
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
	public static void main(String[] args){
		String repository = "http://panic.image.ece.ntua.gr:3030/mint/sparql";
		String conceptScheme = "http://mint.image.ece.ntua.gr/Vocabularies/Languages/LangThesaurus";//only one top
		int limit = 0;
		int offset = 0;
		String like = null;
		String language = "en";
		String property = "http://mint.image.ece.ntua.gr/properties/iso_639_1";
		boolean defaultIncluded = true;
		String[] graphs = new String[2];
		graphs[0] = "http://lod.image.ntua.gr/ConceptScheme1";
		
		MINTThesaurus skos = new MINTThesaurus(repository,null,
				graphs,language,conceptScheme,defaultIncluded);
		
//		skos.setLike(like);
//		skos.setLimit(limit);
//		skos.setOffset(offset);
		skos.setConcept("http://mint.image.ece.ntua.gr/Vocabularies/Languages/43");
		
//		System.out.println(skos.getConceptSchemes());//OK
//		System.out.println(skos.getLanguages());//OK
//		System.out.println(skos.getTopConcepts());//OK
//		System.out.println(skos.getTopConcepts(property));//OK
//		System.out.println(skos.getConcepts());//OK
		System.out.println(skos.getConcepts(property));//OK
//		System.out.println(skos.getNarrowerConcepts());//OK
//		System.out.println(skos.getBroaderConcepts());//OK
//		System.out.println(skos.getNotes("scopeNote"));
//		System.out.println(skos.getNotes("note"));
//		System.out.println(skos.getNotes("notation"));
//		System.out.println(skos.getNotes("altLabel"));
	}

}
