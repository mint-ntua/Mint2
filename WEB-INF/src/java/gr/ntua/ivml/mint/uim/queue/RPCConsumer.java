package gr.ntua.ivml.mint.uim.queue;

import gr.ntua.ivml.mint.uim.queue.strategies.MessageConsumerStrategy;
import gr.ntua.ivml.mint.util.Config;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.ConsumerCancelledException;
import com.rabbitmq.client.QueueingConsumer;
import com.rabbitmq.client.ShutdownSignalException;
import com.rabbitmq.client.AMQP.BasicProperties;

public class RPCConsumer implements Runnable{

	
	private String queueHost;
	private String queueName;
	private ConnectionFactory factory;
	private Connection connection;
	private Channel channel;
	private QueueingConsumer consumer;
	private QueueingConsumer.Delivery delivery;
	private JAXBContext jc;
	private Unmarshaller u;
	private ClassLoader classLoader;
	private MessageProcessingContext context;
	private boolean running = true;
	private BasicProperties props;
	private BasicProperties replyProps;
	private JAXBContext jaXcontext;
	private Marshaller m;
	
	public RPCConsumer(){
		System.out.println("Instantiated!!!");
		factory = new ConnectionFactory();
		queueHost = Config.get("queue.host");
		queueName = Config.get("queue.rpc.name");
		
		classLoader = InboundConsumer.class.getClassLoader();
		context = new MessageProcessingContext();
		
	    factory.setHost(queueHost);
	    
	    try {
			connection = factory.newConnection();
		    channel = connection.createChannel();
		    channel.basicQos(1);
		    consumer = new QueueingConsumer(channel);
		    channel.basicConsume(queueName, false, consumer);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {
			jc = JAXBContext.newInstance( "gr.ntua.ivml.mint.uim.messages.schema" );
			u = jc.createUnmarshaller();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		try {
			jaXcontext =
			    JAXBContext.newInstance( "gr.ntua.ivml.mint.uim.messages.schema" );
			m = jaXcontext.createMarshaller();
		    m.setProperty( Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE );
		} catch (JAXBException e1) {
			e1.printStackTrace();
		}
	}
	
	public void close(){
		try {
			this.channel.close();
			this.connection.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private JAXBElement unmarshalMessage(byte[] bytes){
		JAXBElement res = null;
		try {
			ByteArrayInputStream is = new ByteArrayInputStream(bytes);
			JAXBElement elem = (JAXBElement) u.unmarshal(is);
			res = elem;
			//System.out.println(elem.getName());
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return res;
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
	
	@Override
	public void run() {
		while(running){
			try {
				delivery = consumer.nextDelivery();
				JAXBElement command = unmarshalMessage(delivery.getBody());
				String commandClass = Config.get("uim.strategy." + command.getName().toString());
				@SuppressWarnings("unchecked")
				Class<MessageConsumerStrategy> claz = (Class<gr.ntua.ivml.mint.uim.queue.strategies.MessageConsumerStrategy>) classLoader.loadClass(commandClass);
				context.setStrategy(claz.newInstance());
				StrategyResponse sRes = context.executeStrategy(command);
				HashMap<String, Object> header = new HashMap<String, Object>();
				header.put("hasError", sRes.getHasError());
				props = delivery.getProperties();
				replyProps = new BasicProperties
                .Builder()
				.headers(header)
                .correlationId(props.getCorrelationId())
                .build();
				byte[] responseBytes = this.marshalXMLObject(sRes.getPayload());
				channel.basicPublish( "", props.getReplyTo(), replyProps, responseBytes);
				
				channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
			} catch (ShutdownSignalException e) {
				e.printStackTrace();
			} catch (ConsumerCancelledException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				Thread.currentThread().interrupt();
				break;
			} catch (IOException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
	}

}
