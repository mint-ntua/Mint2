package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.XMLNode;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import org.compass.core.xml.XmlObject;
import org.hibernate.Query;
import org.hibernate.ScrollMode;
import org.hibernate.ScrollableResults;
import org.hibernate.StatelessSession;
import org.xml.sax.ContentHandler;

public class XMLNodeDAO extends DAO<XMLNode, Long> {

	
	public static interface NodeIndexer {
		public void index( XMLNode x ) throws Exception;
	}
	
	/**
	 * suffers from long time skipping to the offset "from", has to sort everything
	 * and then start skipping nodes.
	 * @param xp
	 * @param from
	 * @param count
	 * @return
	 */
	public List<XMLNode> getByXpathHolder( XpathHolder xp, long from, long count ) {
		return getSession().createSQLQuery( "select * from " +
				xp.getDataset().resolveNodeIndex() +
				" where xpath_summary_id = :xpath and dataset_id = :xo " +
				"order by xml_node_id asc")
			.addEntity( XMLNode.class )
			.setEntity("xpath", xp)
			.setEntity( "xo", xp.getDataset())
			.setMaxResults((int)count)
			.setFirstResult((int)from)
			.list();
	}
	
	public List<XMLNode> getStatelessByXpathHolder( XpathHolder xp, long from, long count ) {
		List<XMLNode> l =  DB.getStatelessSession().createSQLQuery( "select * from " +
				xp.getDataset().resolveNodeIndex() +
				" where xpath_summary_id = :xpath and dataset_id = :xo " +
				"order by xml_node_id asc")
			.addEntity( XMLNode.class )
			.setEntity("xpath", xp)
			.setEntity( "xo", xp.getDataset())
			.setMaxResults((int)count)
			.setFirstResult((int)from)
			.list();
		for( XMLNode node: l ) {
			node.setXpathHolder(xp);
			node.setDataset(xp.getDataset());
		}
		return l;
	}
	/**
	 * Maybe this performs better, pass the last node you were working on and this
	 * should be quick.
	 * @param xp
	 * @param start
	 * @param count
	 * @return
	 */
	public List<XMLNode> getByXpathHolder( XpathHolder xp, XMLNode start, long count ) {
		return getSession().createSQLQuery( "select * from " +
				xp.getDataset().resolveNodeIndex() +
				" where xpath_summary_id = :xpath and dataset_id = :xo " +
				" and xml_node_id>:nodeId" +
				" order by xml_node_id asc")
			.addEntity( XMLNode.class )
			.setEntity("xpath", xp)
			.setEntity( "xo", xp.getDataset())
			.setLong("nodeId", start.getNodeId())
			.setMaxResults((int)count)
			.list();
	}
	
	
	
	public List<XMLNode> getStatelessByXpathHolder( XpathHolder xp, XMLNode start, long count ) {
		List<XMLNode> l =  DB.getStatelessSession().createSQLQuery( "select * from " +
				xp.getDataset().resolveNodeIndex() +
				" where xpath_summary_id = :xpath and dataset_id = :xo " +
				" and xml_node_id>:nodeId" +
				" order by xml_node_id asc")
			.addEntity( XMLNode.class )
			.setEntity("xpath", xp)
			.setEntity( "xo", xp.getDataset())
			.setLong("nodeId", start.getNodeId())
			.setMaxResults((int)count)
			.list();
		for( XMLNode node: l ) {
			node.setXpathHolder(xp);
			node.setDataset(xp.getDataset());
		}
		return l;
	}
	

	/**
	 * The normal getById performs very badly, provide the xmlObject to find the
	 * node much quicker.
	 * @param id
	 * @param obj
	 * @return
	 */
	public XMLNode getByIdObject(Dataset obj, Long id ) {
		return (XMLNode) getSession().createSQLQuery( "select * from " +
				obj.resolveNodeIndex() +
				" where xml_node_id = :nodeId and dataset_id = :xo " )
			.addEntity( XMLNode.class )
			.setEntity( "xo", obj )
			.setLong("nodeId", id )
			.uniqueResult();
	}
	
	
	public XMLNode getStatelessByIdObject(Dataset ds, Long id ) {
		XMLNode x = (XMLNode) DB.getStatelessSession().createSQLQuery( "select * from " +
				ds.resolveNodeIndex() +
				" where xml_node_id = :nodeId and dataset_id = :ds" )
			.addEntity( XMLNode.class )
			.setLong("nodeId", id )
			.setLong("ds", ds.getDbID() )
			.uniqueResult();
		if( x != null ) x.setChildren(new ArrayList<XMLNode>());
		x.setXpathHolder(DB.getXpathHolderDAO().findById(x.getXpathHolder().getDbID(), false));
		x.setDataset(ds);
		return x;
	}

	
	@Override
	public XMLNode getById( Long  id, boolean lock ) {
		log.warn( "This performs badly, try getByIdObject() instead!");
		return super.getById( id, lock );
	}
	
	
	/**
	 * Ordered List of value, frequency for given xpath. Only given number of 
	 * values listed.
	 * @param xp
	 * @param limit
	 * @return
	 */
	public List<Object[]> getCountByValue( XpathHolder xp, int limit ) {
		if( xp.getName().equals("text()") || xp.getName().startsWith("@")) {
			List<Object[]> l = (List<Object[]>) getSession()
			.createQuery( "select content, count( * ) " + 
						"from " + xp.getDataset().resolveNodeIndex() + 
						" where xpathHolder = :xpath " + 
						"and dataset = :xo " +
						"group by content " +
						"order by count(*) desc")
			.setEntity("xpath", xp)
			.setEntity("xo", xp.getDataset())
			.setMaxResults(limit)
			.list();
			return l;
		} else 
			return Collections.emptyList();
	}
	
	
	/**
	 * Enables to page through the values of an xpath. If count < 1
	 * returns all of them. 
	 * @param xp
	 * @param start
	 * @param count
	 * @return
	 */
	public List<Object[]> getValues( XpathHolder xp, int start, int count ) {
		return getValues( xp, start, count, null );
	}
		
	public List<Object[]> getValues( XpathHolder xp, int start, int count, String filter  ) {
		List<Object[]> l = Collections.emptyList();
		String cond = null;
		if( filter!= null ) {
			cond = "and content like :filter ";
		}

		Query q = getSession()
		.createSQLQuery( "select content, count(*) " + 
				"from " + xp.getDataset().resolveNodeIndex() + " where xpath_summary_id = :xpath " + 
				(cond!=null?cond:"") +
				"group by content " +
		"order by content " )
		.setEntity("xpath", xp);

		if( count > 0 ) {
			q.setMaxResults(count)
			.setFirstResult(start);
		}

		if( cond != null ) {
			q.setString("filter", "%"+filter+"%" );
		}

		l =  q.list();
		return l;
	}

	/**
	 * Quickly build a dom tree. Use per item, not for trees with more than 
	 * 2000 nodes (or about that). The XMLNodes are not in the Hibernate session 
	 * and don't lazy load their parent or anything else. They should not need to, though.
	 * The attached XpathHolders are in the session and behave normally.
	 * @param parent
	 * @return
	 */
	public XMLNode getDOMTree( XMLNode parent ) {
		StatelessSession ss = DB.getStatelessSession();
		List<XMLNode> l;
		int maxNodes = 10000;
		if( parent.getSize()<maxNodes) maxNodes = (int)  parent.getSize();
		Stack<XMLNode> stack = new Stack<XMLNode>();
		HashMap<Long, XpathHolder> xpathCache = new HashMap<Long, XpathHolder>();
		l =  ss.createSQLQuery("select * from " +
				parent.getDataset().resolveNodeIndex() + 
		" where xml_node_id >= :parentId order by xml_node_id" )
		.addEntity(XMLNode.class )
		.setLong("parentId", parent.getNodeId() )
		.setMaxResults(maxNodes)
		.list();
		// now every node has the wrong parent and XpathHolder and no Children..
		for( XMLNode x: l ) {
			// find the right place in stack
			x.setChildren( new ArrayList<XMLNode>());
			while( !stack.isEmpty() ) {
				if( stack.peek().getNodeId() != x.getParentNode().getNodeId())
					stack.pop();
				else
					break;
			}
			if( !stack.isEmpty()) {
				x.setParentNode(stack.peek());
				stack.peek().getChildren().add( x );
			}
			stack.push(x);
			// now the xpathholder
			XpathHolder path = xpathCache.get(x.getXpathHolder().getDbID());
			if( path == null ) {
				path = DB.getXpathHolderDAO().findById(x.getXpathHolder().getDbID(), false);
				xpathCache.put( path.getDbID(), path);
			}
			x.setXpathHolder(path);
			x.setDataset(parent.getDataset());
		}
		if( l.size() > 0 ) return l.get(0);
		else return null;
	}

	/**
	 * Retrieve the given node with subtree and all parent elements. No actual value wrapping is done in 
	 * this method! Only empty element wrapping to adjust for straight xpaths.
	 * @param parent
	 * @return
	 */
	public XMLNode wrappedDOMTree( XMLNode parent ) {
		XMLNode result = getDOMTree(parent);
		do {
			XpathHolder parentPath = result.getXpathHolder().getParent();
			if( parentPath == null ) break; //shouldnt happen
			if( parentPath.getParent() == null ) break; // this should happen
			XMLNode newParent = new XMLNode();
			newParent.getChildren().add( result );
			result.setParentNode(newParent);
			newParent.setDataset(result.getDataset());
			newParent.setXpathHolder(parentPath);
			result = newParent;
		} while( true );
		return result;
	}
	/**
	 * Very specifically get other siblings of the parent that have other xpaths, not the same as this
	 * @param tree
	 * @return
	 */
	public List<XMLNode> quickOtherSiblings( XMLNode tree ) {
		List<XMLNode> l = Collections.emptyList();
		try {
			l = getSession().createSQLQuery("select * from " +
					tree.getDataset().resolveNodeIndex() + 
					" where parent_node_id = :parent" + 
					" and (xpath_summary_id != :path " +
					" or xml_node_id = :id ) " + 
					"order by xml_node_id" )
			.addEntity(XMLNode.class )
			.setEntity("parent", tree.getParentNode() )
			.setEntity( "path", tree.getXpathHolder() )
			.setEntity( "id", tree )
			.list();
		} catch( Exception e ) {
			log.error( "Query failed with ", e );
		}
		return l;
	}
	
	/**
	 * Looks at content for simple nodes.
	 * @param xp
	 * @return
	 */
	public long countDistinct( XpathHolder xp ) {
		Long val = -1l;
		if( xp.getName().equals("text()") || xp.getName().startsWith("@"))
				val = (Long)  getSession()
				.createQuery( "select count( distinct content ) from "
						+ xp.getDataset().resolveNodeIndex() 
						+ " where xpathHolder = :xpath and dataset = :ds")
				.setEntity("xpath", xp)
				.setEntity("ds", xp.getDataset())
				.uniqueResult();
			
		return val.longValue();
	}

	public float getAvgLength(XpathHolder xpathHolder) {
		Double val;
		if( xpathHolder == null ) return -1f;
		if( ! ( xpathHolder.isTextNode() || xpathHolder.isAttributeNode())) {
			xpathHolder = xpathHolder.getTextNode();
			if( xpathHolder == null ) return -1f;			
		}
		val = (Double)  getSession()
		.createQuery( "select avg( length (content) ) from XMLNode " + 
		"where dataset = :xo and xpathHolder = :xp " )
		.setEntity("xo", xpathHolder.getDataset() )
		.setEntity( "xp", xpathHolder )
		.uniqueResult();
		return val.floatValue();
	}

	public Map<Long, Object[]> getStatsForXpaths( Dataset ds ) {
		List<Object[]> queryResult = getSession()
			.createSQLQuery( "select xpath_summary_id, avg( length( content )), count( distinct content )" +
					" from " + ds.resolveNodeIndex() + " group by xpath_summary_id")
			.list();
		Map<Long, Object[]> result = new HashMap<Long, Object[]>();
		for( Object[] oa: queryResult ) {
			if( oa[0] == null ) continue;
			Long xp = ((Integer) oa[0]).longValue();
			BigDecimal f = (BigDecimal) oa[1];
			BigInteger count = (BigInteger) oa[2];
			Object[] val = new Object[2];
			val[0] = (f==null?-1f:f.floatValue());
			val[1] = (count==null?-1l:count.longValue());
			result.put( xp, val);
		}
		return result;
	}
	
	/**
	 * Cursor over all nodes. (You still have to get XpathHolders the normal way)
	 * Call the index function on given object. Proceeds in node order.
	 * @param xo
	 * @param ni
	 */
	public void indexNodes( Dataset ds, NodeIndexer ni ) {
		StatelessSession ss = DB.getStatelessSession();
		Stack<XMLNode> stack = new Stack<XMLNode>();
		HashMap<Long, XpathHolder> xpathCache = new HashMap<Long, XpathHolder>();
		ScrollableResults sr=null;
		
		try {
			sr =  ss.createSQLQuery("select * from " +	
					ds.resolveNodeIndex() + " order by xml_node_id" )
					.addEntity(XMLNode.class )
					.scroll(ScrollMode.FORWARD_ONLY);

			while( sr.next()) {

				XMLNode x = (XMLNode) sr.get()[0];
				while( !stack.isEmpty() ) {
					if((x.getParentNode()==null) || ( stack.peek().getNodeId() != x.getParentNode().getNodeId()))
						stack.pop();
					else
						break;
				}
				stack.push(x);
				// now the xpathholder
				XpathHolder path = xpathCache.get(x.getXpathHolder().getDbID());
				if( path == null ) {
					path = DB.getXpathHolderDAO().findById(x.getXpathHolder().getDbID(), false);
					xpathCache.put( path.getDbID(), path);
				}
				x.setXpathHolder(path);
				x.setDataset( ds );
				// node ready to index
				ni.index(x);
			}
			ni.index( null );
		} catch( Exception e ) {
			log.error( "Error while scrolling XMLNodes for indexing.", e );
		} finally {
			if( sr != null ) sr.close();
		}
	}
}
