package gr.ntua.ivml.mint.util;

public class Label{
		public String lblname="";
		public String lblcolor="";
		
		public Label(String inputlbl){
			if(inputlbl==null){
				this.lblname="";
			     this.lblcolor="";
			}
			else if(inputlbl.indexOf("_#")>0){
				this.lblname=inputlbl.substring(0,inputlbl.indexOf("_#"));
				this.lblcolor=inputlbl.substring(inputlbl.indexOf("_#")+1, inputlbl.length());
				
			}
			else{this.lblname=inputlbl;
			     this.lblcolor="";
			}
		}
	}