import com.mchange.v2.c3p0.C3P0Registry;
import com.mchange.v2.c3p0.PooledDataSource;

// Print Connection Pool usage

pds = (PooledDataSource) C3P0Registry.getPooledDataSources().iterator().next();
println( "Connections in use " + pds.getNumBusyConnectionsDefaultUser());
println( "Idle connections " + pds.getNumIdleConnectionsDefaultUser());
println( "All connections " + pds.getNumConnectionsDefaultUser());
