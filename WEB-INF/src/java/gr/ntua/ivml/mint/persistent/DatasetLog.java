package gr.ntua.ivml.mint.persistent;

import java.util.Date;

public class DatasetLog {
	private Long dbID;
	private Dataset dataset;
	private String message;
	private String detail;
	private User user;
	private Date entryTime;

	//
	// There is no logic, this is just a data object
	//
	

	//
	// convenience Methods
	//
	
	public static DatasetLog create( Dataset dataset, String message, String detail, User user ) {
		DatasetLog result = new DatasetLog();
		result.init( dataset, message, detail, user );
		return result;
	}
	
	public void init( Dataset dataset, String message, String detail ) {
		setMessage( message );
		setDetail(detail);
		setDataset(dataset);
		setEntryTime(new Date());
	}
	
	public void init( Dataset dataset, String message, String detail, User user ) {
		if( user != null ) setUser( user );
		init( dataset, message, detail );
	}
	
	//
	//  The generated getters / setters
	//
	
	public Long getDbID() {
		return dbID;
	}
	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}
	public Dataset getDataset() {
		return dataset;
	}
	public void setDataset(Dataset dataset) {
		this.dataset = dataset;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Date getEntryTime() {
		return entryTime;
	}
	public void setEntryTime(Date entryTime) {
		this.entryTime = entryTime;
	}
}
