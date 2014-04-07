package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.rdf.thesauri.SKOSThesaurus;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.JSONUtils;

import net.sf.json.*;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class Thesaurus extends GeneralAction {

	public static final Logger log = Logger.getLogger(Thesaurus.class); 
	public JSONObject json;
	private String repository = null;
	private String conceptScheme = null;
	private String concept = null;
	private int limit = 0;
	private int offset = 0;
	private String like = null;
	private String language = "en";
	private boolean defaultIncluded = true;
	

	private String[] collections = null;
	private String[] graphs = null;
	private JSONObject jsonResult(JSONArray concepts) {
		return this.jsonResult(concepts, -1);
	}

	private JSONObject jsonResult(JSONArray concepts, int total) {
		JSONObject result = new JSONObject();
		result.put("repository", this.getRepository());
		result.put("collections", this.getCollections());
		result.put("graphs", this.getGraphs());
		result.put("language", this.getLanguage());
		result.put("total", (total < 0)?concepts.size():total);
		if(this.getConceptScheme() != null) result.put("conceptScheme", this.getConceptScheme());
		result.put("concepts", concepts);
		return result;
	}
	
	private SKOSThesaurus getSKOSThesaurus() {
		return new SKOSThesaurus(this.getRepository(),this.getCollections(),
				this.getGraphs(),this.getLanguage(),this.getConceptScheme(),this.isDefaultIncluded());
	}

	@Action(value="Thesaurus")
	public String execute() {
		json = new JSONObject();
		JSONArray conceptSchemes = new JSONArray();
		//query params
		SKOSThesaurus skos = this.getSKOSThesaurus();
		conceptSchemes.addAll(skos.getConceptSchemes());
		json.put("repository", this.getRepository());
		json.put("conceptSchemes", conceptSchemes);
		return SUCCESS;
	}
	
	@Action(value="Thesaurus_languages")
	public String languages() {
		json = new JSONObject();
		JSONArray languages = new JSONArray();
		SKOSThesaurus skos = this.getSKOSThesaurus();
		languages.addAll(skos.getLanguages());
		json.put("repository", this.getRepository());
		if(this.getConceptScheme() != null) json.put("conceptScheme", this.getConceptScheme());
		json.put("languages", languages);

		return SUCCESS;
	}
	
	@Action(value="Thesaurus_topConcepts")
	public String topConcepts() {
		json = new JSONObject();
		SKOSThesaurus skos = this.getSKOSThesaurus();
		
		JSONArray concepts = JSONUtils.toJSON(skos.getTopConcepts());
		int total = concepts.size();
		json = this.jsonResult(concepts, total);
		
		return SUCCESS;
	}

	@Action(value="Thesaurus_concepts")
	public String concepts() {
		SKOSThesaurus skos = this.getSKOSThesaurus();
		skos.setLike(this.getLike());
		skos.setLimit(this.getLimit());
		skos.setOffset(this.getOffset());
		
		JSONArray concepts = JSONUtils.toJSON(skos.getConcepts());
		json = this.jsonResult(concepts);
		
		return SUCCESS;
	}

	@Action(value="Thesaurus_narrower")
	public String narrower() {
		SKOSThesaurus skos = this.getSKOSThesaurus();
		skos.setConcept(this.getConcept());
		
		JSONArray concepts = JSONUtils.toJSON(skos.getNarrowerConcepts());
		json = this.jsonResult(concepts);

		return SUCCESS;
	}
	
	@Action(value="Thesaurus_broader")
	public String broader() {
		SKOSThesaurus skos = this.getSKOSThesaurus();
		skos.setConcept(this.getConcept());
		
		JSONArray concepts = JSONUtils.toJSON(skos.getBroaderConcepts());
		json = this.jsonResult(concepts);

		return SUCCESS;
	}
	
	@Action(value="Thesaurus_related")
	public String related() {
		SKOSThesaurus skos = this.getSKOSThesaurus();
		skos.setConcept(this.getConcept());
		
		JSONArray concepts = JSONUtils.toJSON(skos.getRelatedConcepts());
		json = this.jsonResult(concepts);

		return SUCCESS;
	}

	@Action(value="Thesaurus_notes")
	public String notes() {
		json = new JSONObject();
		
		SKOSThesaurus skos = this.getSKOSThesaurus();
		skos.setConcept(this.getConcept());
		
		json.element("conceptScheme", this.getConceptScheme());
		json.element("concept", this.getConcept());
		json.element("scopeNote", JSONUtils.toJSON(skos.getNotes("scopeNote")));
		json.element("note", JSONUtils.toJSON(skos.getNotes("note")));
		json.element("notation", JSONUtils.toJSON(skos.getNotes("notation")));
		json.element("altLabel", JSONUtils.toJSON(skos.getNotes("altLabel")));
//		System.out.println(json);
		return SUCCESS;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}

	public JSONObject getJson() {
		return json;
	}

	public String getRepository() {
		if(this.repository == null) {
			if(Config.has("mint.rdf.thesauri")) return Config.get("mint.rdf.thesauri");
			else return Config.get("mint.rdf.repository");
		}
		
		return this.repository;
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

	public String getConcept() {
		return concept;
	}

	public void setConcept(String concept) {
		this.concept = concept;
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

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
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

	public void setDefaultIncluded(boolean defaultIncluded) {
		this.defaultIncluded = defaultIncluded;
	}
	
//	private List<String> getCollectionsList() {
//		if(this.getCollections() == null) return new ArrayList<String>();
//		return Arrays.asList(this.getCollections());
//	}

	public String[] getGraphs() {
		return this.graphs;
	}

	public void setGraphs(String[] graphs) {
		this.graphs = graphs;
	}
	
//	private List<String> getGraphsList() {
//		if(this.getGraphs() == null) return new ArrayList<String>();
//		return Arrays.asList(this.getGraphs());
//	}
}