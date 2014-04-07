package gr.ntua.ivml.mint.uim.queue;


import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import gr.ntua.ivml.mint.uim.queue.strategies.MessageConsumerStrategy;
import gr.ntua.ivml.mint.util.Config;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.ConsumerCancelledException;
import com.rabbitmq.client.QueueingConsumer;
import com.rabbitmq.client.ShutdownSignalException;

public class InboundConsumer implements Runnable{
	private String queueHost;
	private String queueName;
	private ConnectionFactory factory;
	private Connection connection;
	private Channel channel;
	private QueueingConsumer consumer;
	private QueueingConsumer.Delivery delivery;
	private OutboundProducer prod;
	private JAXBContext jc;
	private Unmarshaller u;
	private ClassLoader classLoader;
	private MessageProcessingContext context;
	private boolean running = true;
	
	public InboundConsumer(){
		factory = new ConnectionFactory();
		queueHost = Config.get("queue.host");
		queueName = Config.get("queue.inbound.name");
		
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		prod = new OutboundProducer();
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
				StrategyResponse res = context.executeStrategy(command);
				//JAXBElement response = res.getPayload();
				String corId = delivery.getProperties().getCorrelationId();
				prod.sendItem(res, corId);
				channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
			} catch (ShutdownSignalException e) {
				e.printStackTrace();
			} catch (ConsumerCancelledException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				Thread.currentThread().interrupt();
				break;
				//e.printStackTrace();
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
