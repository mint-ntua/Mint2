import net.sf.json.*;
import gr.ntua.ivml.mint.mapping.*;

// Get the mapping template handler for a schema

schema_name = "LIDO";

schema = DB.xmlSchemaDAO.simpleGet("name = '$schema_name'")
json = schema.jsonTemplate
object = JSONSerializer.toJSON(json)
handler = new JSONMappingHandler(object)
template = handler.getTemplate()
