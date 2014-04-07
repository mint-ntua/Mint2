package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Reporting;
import gr.ntua.ivml.mint.db.Reporting.Country;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	  @Result(name="input", location="report.jsp"),
	  @Result(name="error", location="report.jsp"),
	  @Result(name="success", location="report.jsp" ),
	  @Result(name="countrydetail", location="reportcountry.jsp" )
	})

public class ReportSummary extends GeneralAction {
	public static final Logger log = Logger.getLogger(ReportSummary.class );
	private List<Reporting.Country> countries=new ArrayList<Reporting.Country>();
	private List<Reporting.Organization> orgs=new ArrayList<Reporting.Organization>();
	String coname="";
	String orgId;
	String repaction;
	
	public String getOrgId() {
		return orgId;
	}

	

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}


	public List<Organization> getOrganizations() {
		return  user.getAccessibleOrganizations();
	}
	
	
	public List<Reporting.Country> getCountries(){
		countries = Reporting.getCountries();
		return countries;
	}

	public void setConame(String coname){
		this.coname=coname;
	}
	
	public  Reporting.Country getCountryByName(){
		
		for(Country co:countries){
			if(co.name.equals(coname)){
				return co;
			}
		}
		return(new Country());
	}

	
	public List<Reporting.Organization> getOrgsByCountry(){
		Map orgs=Reporting.getOrganizations();
		ArrayList<Reporting.Organization> countryorgs = (ArrayList)orgs.get(coname);
		return countryorgs;
	}
	
	public String getAction(){
		return repaction;
	}
	
	public void setAction(String repaction){
		this.repaction=repaction;
	}
	
	@Action("ReportSummary")
	public String execute() {
		if(repaction.equalsIgnoreCase("bycountry")){
			return "countrydetail";
		}
		return "success";
	}
	
	@Action("ReportSummary_input")
	@Override
	public String input() throws Exception {
		return "success";
	}
	
}
