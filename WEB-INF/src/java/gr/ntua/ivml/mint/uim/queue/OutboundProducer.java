package gr.ntua.ivml.mint.uim.queue;

import gr.ntua.ivml.mint.util.Config;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.AMQP.BasicProperties;
import com.rabbitmq.client.AMQP.BasicProperties.Builder;



public class OutboundProducer {

	private ConnectionFactory factory;
	private Connection connection;
	private Channel channel;
	private String queueHost;
	private String queueName;
	private BasicProperties pros;
	private Builder builder;
	private JAXBContext context;
	private Marshaller m;
	
	public OutboundProducer(){
		
		
		queueHost = Config.get("queue.host");
		queueName = Config.get("queue.outbound.name");
		
		builder = new Builder();
		factory = new ConnectionFactory();
		factory.setHost(queueHost);
		
		try {
			connection = factory.newConnection();
			channel = connection.createChannel();
			channel.queueDeclare(queueName, true, false, false, null);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {
			context =
			    JAXBContext.newInstance( "gr.ntua.ivml.mint.uim.messages.schema" );
			m = context.createMarshaller();
		    m.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );
		} catch (JAXBException e1) {
			e1.printStackTrace();
		}
	}
	
	public void sendItem(JAXBElement xmlObject){
		builder.deliveryMode(2);
		pros = builder.build();
		sendItem(marshalXMLObject(xmlObject));
	}
	
	public void sendItem(StrategyResponse resp, String correlationId){
		builder.deliveryMode(2);
		HashMap<String, Object> header = new HashMap<String, Object>();
		header.put("hasError", resp.getHasError());
		builder.headers(header);
		builder.correlationId(correlationId);
		pros = builder.build();
		sendItem(marshalXMLObject(resp.getPayload()));
	}
	
	private byte[] marshalXMLObject(JAXBElement xmlObject){
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		byte[] res = null;
		try {
			m.marshal(xmlObject, out);
			res = out.toByteArray();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	private void sendItem(byte[] bytes){
		try {
			channel.basicPublish( "", queueName, 
			        pros,
			        bytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void close(){
		try {
			channel.close();
			connection.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
