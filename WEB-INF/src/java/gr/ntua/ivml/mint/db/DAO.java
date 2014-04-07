package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.util.ApplyI;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.CacheMode;
import org.hibernate.Criteria;
import org.hibernate.LockMode;
import org.hibernate.NonUniqueObjectException;
import org.hibernate.ScrollMode;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.hibernate.StatelessSession;
import org.hibernate.Transaction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Example;
import org.hibernate.exception.ConstraintViolationException;

public class DAO<T, ID extends Serializable> {

    protected Class<T> persistentClass;
    static Logger daoLog = Logger.getLogger( DAO.class );
    
    Logger log;
    public DAO() {
        this.persistentClass = (Class<T>) ((ParameterizedType) getClass()
                                .getGenericSuperclass()).getActualTypeArguments()[0];
        log = Logger.getLogger( this.getClass() );
     }


    public Transaction beginTransaction() {
    	return getSession().beginTransaction();
    }
    
    public Session getSession() {
    	return DB.getSession();
    }

    public Class<T> getPersistentClass() {
        return persistentClass;
    }

    public void deleteAll() {
  	  boolean commit = false;
	  Transaction t = getSession().getTransaction();
	  if( !t.isActive()) {
		  t=getSession().beginTransaction();
		  commit = true;
	  }
	  getSession().createQuery(
			    "delete from " + getPersistentClass().getCanonicalName())
			    .executeUpdate();
	  if( commit )
		  t.commit();
    }
    
    /**
     * This method doesn't check if the object is in the database.  
     * @param id
     * @param lock
     * @return
     */
    @SuppressWarnings("unchecked")
    public T findById(ID id, boolean lock) {
        T entity;
        if (lock)
            entity = (T) getSession().load(getPersistentClass(), id, LockMode.UPGRADE);
        else
            entity = (T) getSession().load(getPersistentClass(), id);

        return entity;
    }

    /**
     * This method goes to the DB and checks if the object is actually there.
     * @param id
     * @param lock
     * @return
     */
    @SuppressWarnings("unchecked")
    public T getById(ID id, boolean lock) {
        T entity;
        if (lock)
            entity = (T) getSession().get(getPersistentClass(), id, LockMode.UPGRADE);
        else
            entity = (T) getSession().get(getPersistentClass(), id);

        return entity;
    }
    

    @SuppressWarnings("unchecked")
    public List<T> findAll() {
        return findByCriteria();
    }

    @SuppressWarnings("unchecked")
    public List<T> pageAll(int start, int count) {
        return pageByCriteria( start, count);
    }

    public ScrollableResults scrollAll() {
        Criteria crit = getSession().createCriteria(getPersistentClass());
        return crit.scroll(ScrollMode.FORWARD_ONLY);
    }
    
    /**
     * Iterate through everything and modify, put back in the database.
	 * The loop items live in their own Session and 
	 * you can choose wether you want all changes be thrown away if your 
	 * operation throws.
	 *  
     * @param op
     * @param condition
     * @throws Exception
     */
    public void onAll( ApplyI<T> op, String condition, boolean allOrNothing ) throws Exception {
		ScrollableResults sr=null;
		Session freshSession = null;
		
		try {
			freshSession = DB.freshSession();
			freshSession.beginTransaction();
			sr =  freshSession.createQuery( " from " + getPersistentClass().getName() +
	    			(condition==null?"":" where " + condition ))
	 				.setFetchSize(100)
					.scroll(ScrollMode.FORWARD_ONLY);
			freshSession.setCacheMode(CacheMode.IGNORE);
			while( sr.next()) {
				T i = (T) sr.get()[0];
				op.apply(i);
				freshSession.flush();
				freshSession.evict( i );
			}	
			freshSession.getTransaction().commit();
		} catch( Throwable th ) {
			log.error( "Iterate over " +  getPersistentClass().getName() +" problem!",  th);
			if( freshSession != null )
				if( allOrNothing ) 
					freshSession.getTransaction().rollback();
				else 
					freshSession.getTransaction().commit();
			throw new Exception( th );
		} finally {
			if( sr != null ) sr.close();
			if( freshSession != null ) {
				freshSession.close();
			}
		}
	}

    /**
     * Operate on all queries things. Things are retreived stateless, no hibernate magic.
     * Cursors are used. Should work for arbitrary size of results. Works on a new connection,
     * so you can commit your stuff normally.
     * @param op
     * @param condition
     * @throws Exception
     */
    public void onAllStateless( ApplyI<T> op, String condition ) throws Exception {
		ScrollableResults sr=null;
		StatelessSession ss = DB.freshStatelessSession();

		try {
			ss.beginTransaction();
			sr =  ss.createQuery( " from " + getPersistentClass().getName() +
    			(condition==null?"":" where " + condition ))
 				.setFetchSize(100)
				.scroll(ScrollMode.FORWARD_ONLY);

			while( sr.next()) {
				T i = (T) sr.get()[0];
				op.apply(i);
			}
			ss.getTransaction().commit();
		} catch( Throwable th ) {
			log.error( "Iterate over " +  getPersistentClass().getName() +" problem!",  th);
			ss.getTransaction().rollback();
			throw new Exception( th );
		} finally {
			if( sr != null ) sr.close();
			if( ss != null ) {
				Connection c = ss.connection();
				ss.close();
				if( !c.isClosed()) c.close();
			}
		}
	}

    
    
    @SuppressWarnings("unchecked")
    public List<T> findByExample(T exampleInstance, String[] excludeProperty) {
        Criteria crit = getSession().createCriteria(getPersistentClass());
        Example example =  Example.create(exampleInstance);
        for (String exclude : excludeProperty) {
            example.excludeProperty(exclude);
        }
        crit.add(example);
        return crit.list();
    }

    /**
     * Will return null if things didn't turn out well.
     * @param entity
     * @return
     */
    @SuppressWarnings("unchecked")
    public T makePersistent(T entity) {
    	boolean commit = false;

    	Transaction t = getSession().getTransaction();
    	if( !t.isActive()) {
    		t=getSession().beginTransaction();
    		commit = true;
    	}
    	try {
    		getSession().saveOrUpdate(entity);
    		getSession().flush();
        	if( commit )
        		t.commit();
    	} catch( ConstraintViolationException he ) {
    		t.rollback();
    		log.warn( "Session closed!");
    		getSession().close();
    		DB.removeSession();
    		DB.setSession( DB.newSession());
    		if( !commit )
    			getSession().beginTransaction();
    		commit = false;
    		entity = null;
    	} catch( NonUniqueObjectException nve ) {
    		// a different object with the same id was in session
    		log.warn( "A merge was issued, try to avoid creating objects from scratch!");
    		T newEntity = (T) getSession().merge(entity);
    		getSession().flush();
    		if( commit )
    			t.commit();
    		entity = newEntity;
    		// maybe we need to catch stuff here too
    	}
    	return entity;
    }

    
    /**
     * tried to catch the constraint violation exception and 
     * make a new session and transaction.
     * 
     * When this returns false you should not use any of the objects 
     * you retrieved during the running request.
     * 
     *  You have a new transaction running. All previously fetched objects 
     *  don't have "magic" any more (lazy loading etc)
     *  
     * @param entity
     * @return
     */
    public boolean makeTransient(T entity ) {
  	  boolean result = true;
	  boolean commit = false;
	  
	  // if the DAO is used in an environment where there is no transaction running
	  // It creates one automatically. 
	  Transaction t = getSession().getTransaction();
	  if( !t.isActive()) {
		  t=getSession().beginTransaction();
		  commit = true;
	  }

	  try {
		  getSession().delete(entity);
		  getSession().flush();
		  if( commit )
			  t.commit();
	  } catch(ConstraintViolationException he ) {
		  result = false;
		  t.rollback();
		  getSession().close();
		  DB.removeSession();
		  DB.setSession( DB.newSession());
		  if( !commit )
			  getSession().beginTransaction();
		  commit = false;
	  } finally {
		  // don't know, probably nothing
	  }
	  return result;
    }


    public long count( String simpleCondition ) {
    	Long count = (Long) getSession()
    	.createQuery("select count(*) from "+ getPersistentClass().getName() + 
    			(simpleCondition==null?"":(" where " + simpleCondition )))
    	.iterate().next();
    	return count.longValue();
    }
    
    
    public int delete( String simpleCondition ) {
    	int affectedEntities = getSession().createQuery( "delete from " + getPersistentClass().getName() +
    			(simpleCondition==null?"":(" where " + simpleCondition )))
    			.executeUpdate();
    	DB.commit();
    	return affectedEntities;
    }
    
    public long count() {
    	return count( null );
    }
   
    @SuppressWarnings("unchecked")
    public T simpleGet( String condition ) {
    	List<T> l = getSession().createQuery(" from " + getPersistentClass().getName() +
    			(condition==null?"":" where " + condition ))
    			.list();
    	if( l.size()> 0 ) {
    		return (T)l.get(0);
    	} else {
    		return null;
    	}    	
    }
    
    
    @SuppressWarnings("unchecked")
    public List<T> simpleList( String condition) {
    	List<T> l = getSession().createQuery(" from " + getPersistentClass().getName() +
    			(condition==null?"":" where " + condition ))
    			.list();
    	return l;
    }
    
     public void flush() {
        getSession().flush();
    }

    public void clear() {
        getSession().clear();
    }

    /**
     * Use this inside subclasses as a convenience method.
     */
    @SuppressWarnings("unchecked")
    protected List<T> findByCriteria(Criterion... criterion) {
        Criteria crit = getSession().createCriteria(getPersistentClass());
        for (Criterion c : criterion) {
            crit.add(c);
        }
        return crit.list();
   }
    
    protected List<T> pageByCriteria( int start, int count, Criterion... criterion ) {
        Criteria crit = getSession().createCriteria(getPersistentClass());
        for (Criterion c : criterion) {
            crit.add(c);
        }
        if( count > 0 )
        	return crit.setFirstResult(start).setMaxResults(count).list();  	
        else
        	return crit.setFirstResult(start).list();  	
    }
    
} 