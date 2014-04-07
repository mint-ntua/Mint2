package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.concurrent.Itemizer
import gr.ntua.ivml.mint.db.DB

def du = DB.datasetDAO.simpleGet( "dbID=1002" )
DB.getSession().beginTransaction()
if( du != null  ) {
	du.setItemRootXpath( du.getByPath("/adlibXML/recordList/record"))
	du.setItemNativeIdXpath(du.getByPath("/adlibXML/recordList/record/priref/text()"))
	du.setItemLabelXpath(du.getByPath("/adlibXML/recordList/record/monument.name/text()"))
	DB.commit()
	def itemizer = new Itemizer( du )
	itemizer.runInThread()
}
DB.commit()

DB.closeSession()
DB.closeStatelessSession()
