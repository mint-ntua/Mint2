package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.concurrent.Itemizer
import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.Dataset;

for( DataUpload du: DB.dataUploadDAO.findAll() ) {
  def holder = du.getByPath( "/lidoWrap/lido" )
  if( holder != null ) {
	 du.setItemRootXpath(holder)
	 du.setItemLabelXpath(du.getByPath("/lidoWrap/lido/descriptiveMetadata/objectIdentificationWrap/titleWrap/titleSet/appellationValue/text()"))
	 du.setItemizerStatus(Dataset.ITEMS_NOT_APPLICABLE)
	 DB.commit()
	def items = new Itemizer( du )
	Queues.queue( items, "db" )
	log.info( "Queued dataset ${du.name} in ${du.organization.englishName} with ${holder.count} items." )
 }
}
