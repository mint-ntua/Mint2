package gr.ntua.ivml.mint;

import java.util.ArrayList;

import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.transport.TFastFramedTransport;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransportException;

import gr.ntua.ivml.mint.OAIServer;
import gr.ntua.ivml.mint.ProgressResponse;

public class OAIServiceClient {
	
	private OAIServer.Client client;
	private TFastFramedTransport transport;
	private TSocket socket;
	private TBinaryProtocol protocol;
	
	public OAIServiceClient(String host, int port){
		socket = new TSocket(host, port);
		transport = new TFastFramedTransport(socket);
		protocol = new TBinaryProtocol(transport);
		client = new OAIServer.Client(protocol);
		try {
			transport.open();
		} catch (TTransportException e) {
			e.printStackTrace();
		}
	}
	
	public void unpublishRecordsByDatasetId(int orgId, int userId,
			String projectName, int datasetId){
		try {
			client.unpublishRecordsByDatasetId(orgId, userId, projectName, datasetId);
		} catch (TException e) {
			e.printStackTrace();
		}
	}
	
	
	public String createReport(String projectName, int userId, int orgId, ArrayList<Integer> datasets){
		String res = null;
		try {
			res = client.createReport(projectName, userId, orgId, datasets);
		} catch (TException e) {
			e.printStackTrace();
		}
		
		return res;
	}
	
	public void closeReport(String reportId){
		try {
			client.closeReport(reportId);
		} catch (TException e) {
			e.printStackTrace();
		}
	}
	
	public ProgressResponse getProgress(String reportId){
		ProgressResponse resp = null;
		try {
			resp = client.getProgress(reportId);
		} catch (TException e) {
			e.printStackTrace();
		}
		return resp;
	}
	
	public String fetchReport(String reportId){
		String res = "";
		try {
			res = client.fetchReport(reportId);
		} catch (TException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	public void initIndex(String projectName){
		try {
			client.initIndex(projectName);
		} catch (TException e) {
			e.printStackTrace();
		}
	}
	
	public void close(){
		this.transport.close();
	}
}
