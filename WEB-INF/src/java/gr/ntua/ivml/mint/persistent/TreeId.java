package gr.ntua.ivml.mint.persistent;

import java.util.ArrayList;
import java.util.Arrays;

import org.apache.log4j.Logger;
/*
 * Binary tree index on xml nodes
 *  - use postgres bytes column and probably access it with encode / decode
 *  - number your nodes with 1-251 normally
 *  - use 252,253,254,255 for announcing a 2 byte 3 byte 4 byte 8 byte value
 *  - use a 0x00 to separate child key from parent key
 *  - omit the ox00 in the coding makes 0xff the tree level delimiter
 * to insert a sibling just start a new number without separator 
 *  - 1 0 1; 2 0 1; 1 1 0 1 is insert between 1 255 and 2 255 
 *  You can always find the parent id by stripping from the end the last 255 
 *    and everything behind 
*/
public class TreeId implements Comparable<TreeId> {
	public byte[] id;
	private static long[] basenums = { 251l, 255l*255l+251l, 251l + 255l*255L + 255l*255l*255l, 
		251l+ 255l*255l + 255l*255l*255l + 255l*255l*255l*255l 
	};
	// cache, can be calculated from tree_id
	// maybe we dont need the separators ??
	
	public short parentLen;
	public static final Logger log = Logger.getLogger( TreeId.class );
	/**
	 * Use a String to make a nodeId
	 * @param id
	 */
	public TreeId( String id ) {
		ArrayList<Byte> result = new ArrayList<Byte>();
		String[] levels = id.split("\\.");
		boolean firstLevel = true;
		for( String level: levels ) {
			if( firstLevel ) firstLevel = false;
			else result.add((byte) 0x00 );
			String[] nums = level.split( "-" );
			for( String num: nums ) {
				long n = sortableStringToLong(num );
				byte[] res = longToNodeNum(n);
				for( byte b: res ) result.add(b);
			}
		}
		this.id = new byte[result.size()];
		int i = 0;
		for( Byte b: result) this.id[i++] = b;
	}
	
	public TreeId( byte[] init ) {
		this.id = init;
		parentLen = -1;
		parentLen = (short) getParentCount();
	}
	
	public TreeId(){
		parentLen = -1;
	}
	
	public TreeId( TreeId copy ) {
		this.id = Arrays.copyOf(copy.id, copy.id.length);
		parentLen = copy.parentLen;
	}
	
	
	public byte[] getId() {
		return id;
	}

	public void setId(byte[] id) {
		this.id = id;
	}

	
	public short getParentLen() {
		return parentLen;
	}

	public void setParentLen(short parentLen) {
		this.parentLen = parentLen;
	}

	public TreeId insertBefore(  TreeId before ) {
		if( compareTo( before ) != -1 ) return null;
		TreeId next = nextId();
		if( next.compareTo( before ) == -1 ) return next;
		if( next.compareTo( before) == 0 ) {
			// simple extension
			byte[] newId= Arrays.copyOf( id, id.length+1);
			newId[id.length] = (byte)125;
			return new TreeId( newId );
		} else {
			// just return one before before node
			return before.previousId();
 		}
	}
	
	
	/**
	 * Never end in a 0, thats all that matters, since we can't insert before that.
	 * @return
	 */
	public TreeId previousId() {
		byte[] result = null;
		byte[] newLast = null;
		
		int lastOffset = toLastNum();
		long num = nodeNumToLong( lastOffset );
		num -= 1;
		if( num < 1 ) {
			// we should extend
			// ideally depending on how many extensions we already have
			// but for now just
			
			newLast = new byte[] {1,120};
			
		} else {
			newLast = longToNodeNum(num);
		}
		result = new byte[ lastOffset + newLast.length  ];
		int i=0;
		for( ; i<lastOffset; i++ ) result[i] = this.id[i];
		for( byte b: newLast ) result[i++] = b;
		return new TreeId( result ); 
		
	}
	
	public TreeId nextId() {
		byte[] result = null;
		
		int lastOffset = toLastNum();
		long num = nodeNumToLong( lastOffset );
		num += 1;
		
		byte[] newLast = longToNodeNum(num);
		result = new byte[ lastOffset + newLast.length  ];
		int i=0;
		for( ; i<lastOffset; i++ ) result[i] = this.id[i];
		for( byte b: newLast ) result[i++] = b;
		return new TreeId( result ); 
	}

	public TreeId firstChild() {
		byte[] result = Arrays.copyOf(id, id.length+2 );
		result[ id.length ] = (byte) 0;
		result[ id.length + 1 ] = 120;
		return new TreeId( result );
	}
	
	public boolean isChildOf( TreeId parent ) {
		// they start the same, then a 0x00 and then no more of that
		if( id.length <= parent.id.length ) return false;
		
		for( int i=0; i<id.length; i++ ) {
			if( i<parent.id.length ) {
				if( id[i] != parent.id[i]) return false;
			} else if( i==parent.id.length ) {
				if(( id[i] != (byte) 0 ) && ( i>0)) return false;
			} else {
				if( id[i] == ( byte ) 0 ) return false;
			}
		}
		return true;
	}
	
	public boolean isParentOf(TreeId child) {
		return child.isChildOf( this );
	}

	// basic number representation
	public long nodeNumToLong( int offset ) {
		
		int numlen = nodeNumLen( offset );
		long base = 0l;
		switch( numlen ) {
		case 3: 
			base = basenums[0];
			return base+rebase255( id, offset+1, 2);
		case 4: 
			base = basenums[1];
			return base+rebase255( id, offset+1, 3);
		case 5: 
			base = basenums[2];
			return base+rebase255( id, offset+1, 4);
		case 9:
			base = basenums[3];
			return base+rebase255( id, offset+1, 8);
		default:
			return (long)((id[offset]&0xff)-1);
		}
	}
	
	/**
	 * How long is the num on given offset.
	 * @param nodeNum
	 * @param offset
	 * @return
	 */
	public int nodeNumLen( int offset ) {
		switch( id[offset ] & 0xff ) {
		case 252: return 3;
		case 253: return 4;
		case 254: return 5;
		case 255: return 9;
		}
		return 1;
	}
	
	/**
	 * Basic number representation.
	 * @param nodeNum
	 * @return
	 */
	public static byte[] longToNodeNum( long nodeNum ) {
		byte[] result = null;
		long base = 0l;
		if( nodeNum < basenums[0]) {
			return new byte[] { (byte)(nodeNum+1) };
		} else if( nodeNum< basenums[1]) {
			result = new byte[3];
			result[0] = (byte)252;
			base = basenums[0];
		} else if( nodeNum<basenums[2]) {
			result = new byte[4];
			result[0] = (byte)253;
			base = basenums[1];
		} else if( nodeNum<basenums[3]) {
			result = new byte[5];
			result[0] = (byte)254;
			base = basenums[2];
		} else {
			result = new byte[9];
			result[0] = (byte)255;
			base = basenums[3];
		}
		rebase255( nodeNum-base, result, 1, result.length-1 );
		return result;
	}
	
	// helper
    private static void rebase255( long val, byte[] inHere, int offset, int len ) {
        for( int i=offset+len-1; i>=offset; i-- ) {
            inHere[i] = (byte)(( val%255 ) + 1 );
            val /= 255;
        }
    }
    
    private static long rebase255( byte[] fromHere, int offset, int len  ) {
        long res = 0l;
        for( int i=offset; i<offset+len; i++ )
            res = (res*255l + (long) ((fromHere[i]&0xff) - 1 ));
        return res;    
    }

	
	/**
	 * Look in the byte[] id for the last numbers offset.
	 * @param nodeId
	 * @return
	 */
	public int toLastNum( ) {
		int res = 0;
		int i = 0;
		while( i<id.length ) {
			res = i;
			i+=nodeNumLen( i );
		}
		return res;
	}
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		int i = 0;
		while( i < id.length ) {
			if( (id[i] &0xff) == 0 ) {
				sb.append( "." );
				i+= 1;
			} else {
				long num = nodeNumToLong( i);
				i+= nodeNumLen( i );

				if( sb.length() > 0 && sb.charAt(sb.length()-1)!= '.' )
					sb.append( "-");
				sb.append( longToSortableString(num));
			}
		}
		return sb.toString();
	}
	
	public int compareTo( TreeId ni ) {
		for( int i=0; i<id.length; i++ ) {
			if( i<ni.id.length ) {
				if( id[i] < ni.id[i] ) return -1;
				if( id[i] > ni.id[i] ) return 1;
			} else return 1;
		}
		if( ni.id.length > id.length ) return -1;
		return 0;
	}
	
	public TreeId getParent() {
		return new TreeId( Arrays.copyOf( id, getParentCount()));
	}
	
	/**
	 * Query database from id (inclusive) to upperBound (exclusive) to get the whole subtree
	 * @return
	 */
	public byte[] getUpperBound() {
		byte[] result = Arrays.copyOf(id, id.length+1);
		result[ result.length-1] = 1;
		return result;		
	}
	
	public int getParentCount() {
		if( parentLen < 0 ) {
			int i = id.length-1;
			for( ; i >=0; i-- ) {
				if((id[i]&0xff)==0) break;
			}
			if( i>0 ) parentLen = (short)i;
			else parentLen = 0;
		}
		return parentLen;
	}
	
	public boolean isAncestor( TreeId decendant ) {
		if( id.length >= decendant.id.length ) return false;
		for( int i=0; i<id.length; i++ ) {
			if( id[i] != decendant.id[i] ) return false;
		}
		if( decendant.id[ id.length ] != (byte) 0 ) return false;
		return true;
	}
	
	@Override
	public boolean equals( Object o ) {
		TreeId b = null ;
		if( o instanceof TreeId ) b = (TreeId ) o;
		if( b.id.length != id.length ) return false;

		for( int i=0;i<id.length; i++ ) {
			if( id[i] != b.id[i] ) return false;
 		}
		return true;
	}
	
	public void toHex( StringBuilder sb ) {
		for( byte b: id ) sb.append( String.format("%02x", b));
	}
	
	public String toHex() {
		StringBuilder sb = new StringBuilder();
		toHex( sb );
		return sb.toString();
	}

	public static String longToSortableString( long num ) {
		StringBuilder sb = new StringBuilder();
		sb.append( num );
		int len = sb.length();
		char prefix = (char)((int)'a'+len-1);
		sb.insert(0, prefix);
		return sb.toString();
	}
	
	public static long sortableStringToLong( String num ) {
		// just strip the letter at start.
		return Long.parseLong(num.substring(1));
	}
}
