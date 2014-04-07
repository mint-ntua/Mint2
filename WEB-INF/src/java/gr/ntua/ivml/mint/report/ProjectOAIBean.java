package gr.ntua.ivml.mint.report;

import java.util.List;

public class ProjectOAIBean {
	
	String projectName;
	Integer unique;
	Integer duplicates;
	Integer publications;
	List<String> types;

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public Integer getUnique() {
		return unique;
	}

	public void setUnique(Integer unique) {
		this.unique = unique;
	}

	public Integer getDuplicates() {
		return duplicates;
	}

	public void setDuplicates(Integer duplicates) {
		this.duplicates = duplicates;
	}

	public Integer getPublications() {
		return publications;
	}

	public void setPublications(Integer publications) {
		this.publications = publications;
	}

	public List<String> getTypes() {
		return types;
	}

	public void setTypes(List<String> types) {
		this.types = types;
	}

	public ProjectOAIBean(String projectName, Integer unique,
			Integer duplicates, Integer publications, List<String> types) {
		super();
		this.projectName = projectName;
		this.unique = unique;
		this.duplicates = duplicates;
		this.publications = publications;
		this.types = types;
	}
	
	
	
	

}
