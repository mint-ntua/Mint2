package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.report.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.io.InputStream;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;




import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRXhtmlExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;


import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletResponseAware;

import com.rabbitmq.client.GetResponse;
import com.sun.mail.iap.Response;



@SuppressWarnings("serial")

@Results({
	@Result(name="download", type="stream", params={"inputName", "inputStream", "contentType","${contentType}",
			"contentDisposition", "attachment; filename=${filename}", "contentLength", "${filesize}"})
})

//"application/pdf",
public class DownloadReport extends GeneralAction{
	protected final Logger log = Logger.getLogger(getClass());
	private String contentType;
	private int filesize = -1;
	private InputStream inputStream;

	private Long organizationId;
	private String output; 


	private String fromDate;
	private String toDate;

	private Date startDate = new Date(0);
	private Date endDate = new Date();
	private String reportRange = null;

	private String detail;


	private String reportsPath;  
	private String projectName;
	private Map parameters = new HashMap();
	private  InputStream jasperfile;
	private ByteArrayOutputStream baos = new ByteArrayOutputStream();

	private JRBeanCollectionDataSource datacollection;



	public String getDetail() {
		return detail;
	}


	public void setDetail(String detail) {
		this.detail = detail;
	}


	public void setInputStream(InputStream is) {
		this.inputStream = is;
	}


	public String getOutput() {
		return output;
	}


	public void setOutput(String output) {
		this.output = output;
	}


	public Long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(Long organizationId) {
		this.organizationId = organizationId;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}




	public String getFromDate() {
		return fromDate;
	}


	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}


	public String getToDate() {
		return toDate;
	}


	public void setToDate(String toDate) {
		this.toDate = toDate;
	}


	private void setDates(){
		if (getFromDate() == null || getFromDate().equals("null")) {
			Date old = new Date(0);
			startDate=old;
		} 

		else{
			try {
				startDate = new SimpleDateFormat("dd-MM-yyyy").parse(getFromDate());
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.append("From");
				stringBuilder.append(" ");
				String datestring = String.format("%tB %<te  %<tY", startDate);
				stringBuilder.append(datestring);
				this.reportRange = stringBuilder.toString();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (getToDate() == null || getToDate().equals("null")) {
			endDate = new Date();
		} 
		else{
			try {
				endDate = new SimpleDateFormat("dd-MM-yyyy").parse(getToDate());
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.append(" ");
				stringBuilder.append("To");
				stringBuilder.append(" ");
				String datestring = String.format("%tB %<te %<tY", endDate);
				stringBuilder.append(datestring);
				this.reportRange += stringBuilder.toString();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}


	}

	@SuppressWarnings("unchecked")
	private void setreportParameters(){		 	 	

		setDates();
		projectName =  Config.get("mint.title");
		reportsPath = Config.getProjectRoot().getPath();
		reportsPath = reportsPath +"/WEB-INF/src/java/gr/ntua/ivml/mint/report/";
		parameters.put("title", projectName);
		parameters.put("SUBREPORT_DIR",reportsPath);
		parameters.put("range", reportRange);

	}

	private void readJasperFile(String choice){
		if (choice.equals("transformations")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2organization_transformation.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		else if (choice.equals("publications")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2organization_publication.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if (choice.equals("oaipublications")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2organization_oaipublication.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		else if (choice.equals("imports")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2organization_import.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}



		else if (choice.equals("details")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2OrgDetailsubreport.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		
		else if (choice.equals("progress")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2orgDetails3.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		else if (choice.equals("projectprogress")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2progress.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		else if (choice.equals("statistics")){

			try {
				jasperfile = new FileInputStream(new File(reportsPath+"mint2OrgStatsubreport.jasper"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}

	private void makeData(String choice){
	//	System.out.println("DEBUG, Startmaking data lists " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String orgid = null;
		if (organizationId != null)
		{
			orgid = organizationId.toString();
		}
		if (choice.equals("details")){
			OrganizationDetailsBeanFactory beanfactory = new OrganizationDetailsBeanFactory( orgid, startDate, endDate);
			List<OrganizationDetailsBean> beanCollection = null;
			beanCollection = beanfactory.getOrgDetailsBeans();			
			datacollection = new JRBeanCollectionDataSource(beanCollection);

		}
		else  if (choice.equals("publications")){
			PublicationDetailsBeanFactory pubbeanfactory = new PublicationDetailsBeanFactory(orgid, startDate, endDate);
			List<PublicationDetailsBean> beanCollection = null;
			beanCollection = pubbeanfactory.getPublications();
			datacollection = new JRBeanCollectionDataSource(beanCollection);		
		}
		else if (choice.equals("oaipublications")){
			OaiPublicationDetailsBeanFactory oaibeanfactory = new OaiPublicationDetailsBeanFactory(orgid, startDate, endDate);
			List<OaiPublicationDetailsBean> beanCollection = null;
			beanCollection = oaibeanfactory.getOaiPublicationDetailsBeans();
			datacollection = new JRBeanCollectionDataSource(beanCollection);		
		}

		else if (choice.equals("imports")){
			DataUploadDetailsBeanFactory upbeanfactory = new DataUploadDetailsBeanFactory(orgid, startDate, endDate);
			List<DataUploadDetailsBean> beanCollection = null;
			beanCollection = upbeanfactory.getUploads();
			datacollection = new JRBeanCollectionDataSource(beanCollection);
		}

		else if (choice.equals("transformations")){
			TransformationDetailsBeanFactory tbeanfactory = new TransformationDetailsBeanFactory(orgid, startDate, endDate);
			List<TransformationDetailsBean> beanCollection = null;
			beanCollection = tbeanfactory.getTransformations();			
			datacollection = new JRBeanCollectionDataSource(beanCollection);
		}
		else if (choice.equals("progress")){
			OrganizationProgressBeanFactory beanfactory = new OrganizationProgressBeanFactory(orgid, startDate, endDate);
			List<OrganizationProgressDetailsBean> beanCollection = null;
			beanCollection = beanfactory.getOrgProgressbeans();		
			datacollection = new JRBeanCollectionDataSource(beanCollection);	

		}
		else if (choice.equals("projectprogress")){
			ProjectGoalBeanFactory beanfactory = new ProjectGoalBeanFactory(startDate, endDate);
			List<OrganizationGoalsSummaryBean> beanCollection = null;
			beanCollection = beanfactory.getProjectGoalBeans();	
			datacollection = new JRBeanCollectionDataSource(beanCollection);	

		}
		else if (choice.equals("statistics")){
			OrganizationStatisticsBeanFactory beanfactory = new OrganizationStatisticsBeanFactory(startDate, endDate);
			List<OrganizationStatisticsBean> beanCollection = null;
			beanCollection = beanfactory.getOrgStatisticsBeans();
			datacollection = new JRBeanCollectionDataSource(beanCollection);
		}

		//System.out.println("DEBUG,Stopped making data lists " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
	}

	private JasperPrint fillReport() throws JRException{

	//	System.out.println("DEBUG, Start filling reports " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));		
		JasperPrint jasperPrint = JasperFillManager.fillReport(jasperfile,parameters, datacollection);
	//	System.out.println("DEBUG, Stopped filling reports " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		return jasperPrint;

	}

	private void export(JasperPrint jasperprint){
	//	System.out.println("DEBUG, Started exporting  reports to a file " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		if (output==null || output.equals("pdf")){
			setContentType("application/pdf");
			exportPdf(jasperprint);
		}
		else if (output.equals("xlsx")){
			setContentType("application/vnd.ms-excel");
			exportXlsx(jasperprint);

		}
		else if (output.equals("csv")){
			setContentType("text/csv");
			exportCsv(jasperprint);
		}
		else if (output.equals("xhtml")){
			setContentType("application/xhtml+xml");
			exportxHtml(jasperprint);
		}
		else if (output.equals("html")){
			setContentType("text/html");
			exportHtml(jasperprint);
		}
//		System.out.println("DEBUG, Stopped exporting  reports to a file " + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
	}

	private void exportPdf(JasperPrint jasperprint){
		try {
			JasperExportManager.exportReportToPdfStream(jasperprint,baos);
		} catch (JRException e) {
			e.printStackTrace();
			log.debug(e.getMessage());
		}
	}

	private void exportXlsx(JasperPrint jasperprint){
		JRXlsExporter exporterXLS = new JRXlsExporter();
		exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperprint);
		exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, baos);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
		try {
			exporterXLS.exportReport();
		} catch (JRException e) {
			e.printStackTrace();
		}
	}



	private void exportCsv(JasperPrint jasperprint){
		JRCsvExporter exporter = new JRCsvExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperprint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,baos);        
		try {
			exporter.exportReport();
		} catch (JRException e) {
			e.printStackTrace();
		}

	}

	private void exportxHtml(JasperPrint jasperprint){
		JRXhtmlExporter exporter = new JRXhtmlExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperprint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,baos);        
		try {
			exporter.exportReport();
		} catch (JRException e) {
			e.printStackTrace();
		}
	}

	private void exportHtml(JasperPrint jasperprint){

		JRHtmlExporter exporter = new JRHtmlExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperprint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,baos);        
		try {
			exporter.exportReport();
		} catch (JRException e) {
			e.printStackTrace();
		}
	}

	public boolean getDownload() {
		setreportParameters();		
		if (detail.equals("transformations")){				
			setOutput("xlsx");
			readJasperFile("transformations");
			makeData("transformations");
		}
		if (detail.equals("imports")){				
			setOutput("xlsx");
			readJasperFile("imports");
			makeData("imports");
		}
		if (detail.equals("publications")){				
			setOutput("xlsx");
			readJasperFile("publications");
			makeData("publications");
		}
		if (detail.equals("oaipublications")){				
			setOutput("xlsx");
			readJasperFile("oaipublications");
			makeData("oaipublications");
		}
		if (detail.equals("progress")){
			setOutput("pdf");
			readJasperFile("progress");
			makeData("progress");
		}
		if (detail.equals("projectprogress")){
			setOutput("pdf");
			readJasperFile("projectprogress");
			makeData("projectprogress");
		}
		if (detail.equals("details")){

			if (organizationId==null){		
				readJasperFile("statistics");
				makeData("statistics");

			}
			if  (organizationId !=null){

				readJasperFile("details");
				makeData("details");
			}
		}


		try {
			JasperPrint jasperprintreport = fillReport();
			export(jasperprintreport);
		} catch (JRException e1) {
			e1.printStackTrace();
			log.debug(e1.getMessage());
		}
		ByteArrayInputStream bis = new ByteArrayInputStream(baos.toByteArray());
		this.filesize = baos.size();
		setInputStream(bis);

		return true;
	}


	public int getFilesize() {
		return filesize;
	}


	public InputStream getInputStream()	{
		return inputStream;
	}

	public InputStream getStream(){
		return inputStream;
	}

	public String getFilename(){
		String name;
		name = Config.get("mint.title");
		if (organizationId !=null){
			name =  Config.get("mint.title");

			Organization org = DB.getOrganizationDAO().getById(organizationId, true);
			name =  name +"_"+ org.getEnglishName();
		}		
		if (detail!=(null)){
			if (detail.equals("transformations")){
				name = name +  "_transformations";
			}
			else if (detail.equals("imports")){
				name = name +  "_imports";
			}else if (detail.equals("publications")){
				name = name +  "_publications";
			}else if (detail.equals("oaipublications")){
				name = name +  "_oai_publications";
			}
			else if (detail.equals("progress")){
				name = name +  "_detailed";
			}
			else if (detail.equals("projectprogress")){
				name = name +  "_overall";
			}
		}
		else {
			name =name +  "_overall";
		}

		if (reportRange!=(null)){
			name =name + "_"+reportRange;
		}
		if (output==null || output.equals("pdf")){
			name = name +".pdf";
		}
		else if (output.equals("xlsx")){
			name = name+".xlsx";
		}
		else if (output.equals("csv")){
			name = name+".csv";
		}
		else if (output.equals("xhtml")){
			name = name+".xhtml";
		}
		else if (output.equals("html")){
			name = name+".html";
		}

		name = name.replace(' ' , '_');		
		return(name);

	}


	@Action(value="DownloadReport")
	public String execute() throws Exception {
		getDownload();
		if (organizationId == null ){
			return "download";
		}
		else if(DB.getOrganizationDAO().getById(organizationId, true) !=null) {
			return "download";
		}
		return ERROR;
	}




}