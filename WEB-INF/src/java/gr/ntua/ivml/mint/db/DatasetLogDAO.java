package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.DatasetLog;
import gr.ntua.ivml.mint.persistent.Organization;

import java.util.List;

import org.apache.log4j.Logger;

public class DatasetLogDAO extends DAO<DatasetLog, Long> {
	public static final Logger log = Logger.getLogger(DatasetLogDAO.class);
		
	public List<DatasetLog> getByDataset( Dataset ds ) {
		List<DatasetLog> l = getSession().createQuery( "from DatasetLog where dataset = :ds order by entryTime DESC" )
			.setEntity("ds", ds)
			.list();
		return l;
	}

	public DatasetLog getLastByDataset(Dataset ds ) {
		DatasetLog dsl = (DatasetLog) getSession().createQuery( "from DatasetLog where dataset = :ds order by entryTime DESC" )
		.setEntity("ds", ds)
		.setMaxResults(1)
		.uniqueResult();
		return dsl;
	}
}
