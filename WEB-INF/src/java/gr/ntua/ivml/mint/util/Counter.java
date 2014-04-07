package gr.ntua.ivml.mint.util;

public class Counter {
	int value;
	public int get() { return value; }
	public void inc() { value++; }
	public Counter() {value =1 ;}
	public Counter set( int i ) { value=i; return this; }
}