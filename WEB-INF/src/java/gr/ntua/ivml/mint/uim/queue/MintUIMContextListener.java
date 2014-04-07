package gr.ntua.ivml.mint.uim.queue;

import gr.ntua.ivml.mint.util.Config;

import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class MintUIMContextListener implements ServletContextListener{
	private ArrayList<Thread> threads = null;
	private ArrayList<Thread> RPCThreads = null;
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		Iterator<Thread> it = threads.iterator();
		while(it.hasNext()){
			Thread thread2 = it.next();
			thread2.interrupt();
		}
		
		it = RPCThreads.iterator();
		while(it.hasNext()){
			Thread thread3 = it.next();
			thread3.interrupt();
		}
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		threads = new ArrayList<Thread>();
		int num = Integer.parseInt(Config.get("queue.consumers.No"));
		System.out.println("number:"+num);
		//System.out.println(Integer.parseInt(Config.get("The Number:"+"queue.consumers.No")));
		if(threads.size() == 0){
			for(int i = 0; i < num ;i++){
				InboundConsumer con1 = new InboundConsumer();
				Thread thread1 = new Thread(con1, "consumer #"+i);
				threads.add(thread1);
				thread1.start();
			}
		}
		
		RPCThreads = new ArrayList<Thread>();
		if(RPCThreads.size() == 0){
			//System.out.println(Integer.parseInt("The Number:"+Config.get("queue.consumers.No")));
			for(int i = 0; i < num;i++){
				RPCConsumer con2 = new RPCConsumer();
				Thread thread2 = new Thread(con2, "RPCconsumer #"+i);
				RPCThreads.add(thread2);
				thread2.start();
			}
		}
	}

}
