import gr.ntua.ivml.mint.concurrent.Queues;

// Show the state of all queues

dbe = Queues.queues["db"]
dbq = dbe.getQueue()
nete = Queues.queues["net"]
netq = nete.getQueue()
singe = Queues.queues["single"]
singq = singe.getQueue()


print String.format( "%10s%10s%10s\n","Name","pending","running" )
print String.format( "%10s%10d%10d\n","db",dbq.size(), dbe.getActiveCount()  )
print String.format( "%10s%10d%10d\n","net",netq.size(), nete.getActiveCount() )
print String.format( "%10s%10d%10d\n","single",singq.size(), singe.getActiveCount() )

