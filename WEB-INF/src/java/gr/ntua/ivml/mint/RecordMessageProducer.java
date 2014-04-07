package gr.ntua.ivml.mint;

import gr.ntua.ivml.mint.pi.messages.ItemMessage;

import java.io.IOException;

import org.apache.thrift.TException;
import org.apache.thrift.TSerializer;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.MessageProperties;

public class RecordMessageProducer {

	private ConnectionFactory factory;
	private Connection connection;
	private Channel channel;
	//private BasicProperties pros;
	//private Builder builder;
	private String exchangeName;
	private String hostName;
	private TSerializer ts;
	
	public RecordMessageProducer(String queueHost, String exchangeName) throws Exception {
		this.hostName = queueHost;
		this.exchangeName = exchangeName;
		this.ts = new TSerializer();
		
		//builder = new Builder();
		factory = new ConnectionFactory();
		factory.setHost(hostName);
		
		
			connection = factory.newConnection();
			channel = connection.createChannel();
			channel.exchangeDeclare(this.exchangeName, "topic", true);
	}
	
	public void send(ItemMessage msg, String routingKey) throws Exception {
			channel.basicPublish(this.exchangeName, routingKey, MessageProperties.PERSISTENT_BASIC, this.ts.serialize(msg));
	}
	
	public void close() throws Exception {
			channel.close();
			connection.close();
	}
}
