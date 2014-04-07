package gr.ntua.ivml.mint.uim.queue.strategies;

import gr.ntua.ivml.mint.concurrent.Queues;
import gr.ntua.ivml.mint.concurrent.UploadIndexer;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.uim.messages.schema.CreateImportAction;
import gr.ntua.ivml.mint.uim.messages.schema.CreateImportCommand;
import gr.ntua.ivml.mint.uim.messages.schema.CreateImportResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;
import gr.ntua.ivml.mint.util.Config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;

import javax.xml.bind.JAXBElement;

import org.apache.log4j.Logger;

public class CreateImportStrategy implements MessageConsumerStrategy{

	private static final Logger log = Logger.getLogger( CreateImportStrategy.class );
	
	@Override
	public StrategyResponse consume(JAXBElement message) {
		/*CreateImportComplexType command = (CreateImportComplexType) message.getValue();
		CreateImportCommandComplexType importCommand = command.getCreateImportCommand();*/
		CreateImportAction command = (CreateImportAction) message.getValue();
		CreateImportCommand importCommand = command.getCreateImportCommand();
		//do something on mint
		long userId = -1;
		try{
			userId = Long.parseLong(importCommand.getUserId());
		}catch(Exception e){
			JAXBElement el = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(el);
			return resP;
		}
		String repoxUrl = Config.get("repox.url");
		String repoxUserName = Config.get("repox.user");
		String repoxUserPassword = Config.get("repox.password");
		String repoxSetName = importCommand.getRepoxTableName();


		try {
			DB.getSession().beginTransaction();
			User u = DB.getUserDAO().findById(userId, false);
			
			
			DataUpload du;
			
			du = DB.getDataUploadDAO().findByName("Repox Import " + repoxSetName);
			
			// enable reuse of old uploads
			if( du != null ) du.clean();
			else {
				du = (DataUpload) new DataUpload().init(u);
				du.setName("Repox Import " + repoxSetName);
			}

			du.setUploadMethod(DataUpload.METHOD_REPOX);
			du.setStructuralFormat(DataUpload.FORMAT_XML);

			log.debug( "Import " + repoxSetName + " for Organization " + u.getOrganization().getEnglishName());
			du.setOrganization(u.getOrganization());
			du.setOriginalFilename(repoxSetName);


			DB.getDataUploadDAO().makePersistent(du);
			DB.commit();

			String importId = Long.toString(du.getDbID());
			//DataUpload duTmp = DB.getDataUploadDAO().getById(du.getDbID(), false);
			Connection c = DriverManager.getConnection(repoxUrl, repoxUserName, repoxUserPassword );
			//c.prepareStatement("SET bytea_output to escape").execute();

			UploadIndexer ui = new UploadIndexer( du, c, repoxSetName );

			Queues.queue(ui, "now" );
			Queues.join( ui );
			Queues.join( ui );

			DB.commit();

			//response
			ObjectFactory factory = new ObjectFactory();
			CreateImportResponse importRes = factory.createCreateImportResponse();
			importRes.setImportId(importId);
			CreateImportAction importA = factory.createCreateImportAction();
			importA.setCreateImportResponse(importRes);
			JAXBElement elem = factory.createCreateImport(importA);
			StrategyResponse sRes = new StrategyResponse();
			sRes.setPayload(elem);
			sRes.setHasError(false);
			return sRes;

		} catch (SQLException e) {
			e.printStackTrace();
			JAXBElement el = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(el);
			return resP;
		} catch (Exception e) {
			e.printStackTrace();
			JAXBElement el = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(el);
			return resP;
		} finally {
			DB.closeSession();
			DB.closeStatelessSession();
		}
	}

	private JAXBElement createErrorMessage(String commandName, String message){
		ObjectFactory factory = new ObjectFactory();
		ErrorResponse resp = factory.createErrorResponse();
		resp.setCommand(commandName);
		resp.setErrorMessage(message);
		CreateImportAction responseA = factory.createCreateImportAction();
		responseA.setError(resp);
		JAXBElement response = factory.createCreateImport(responseA);
		return response;
	}

}
