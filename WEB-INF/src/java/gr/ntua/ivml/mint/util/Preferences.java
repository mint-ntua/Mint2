package gr.ntua.ivml.mint.util;

import net.sf.json.JSONObject;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Meta;
import gr.ntua.ivml.mint.persistent.User;

/**
 * Class to handle access to user preferences
 * @author Fotis Xenikoudakis
 *
 */
public class Preferences {
	private static final String PREFERENCES = "preferences";

	/**
	 * Generate the meta property key used to store the preferences.
	 * Add "preferences." prefix to the original key.
	 * Do not use with get and put methods, it is applied automatically.
	 * @param original
	 * @return
	 */
	public static String generateKey(String original) {
		return PREFERENCES + "." + original;
	}
	
	/**
	 * Get user preferences specified by key. 
	 * @param user The user.
	 * @param key  The preferences key (i.e AbstractMappingManager.PREFERENCES for mapping editor preferences)
	 * @return     The preferences
	 */
	public static String get(User user, String key) {
		return Meta.get(user, Preferences.generateKey(key));
	}
	
	/**
	 * Save user preferences specified by key 
	 * @param user			The user
	 * @param key			The preferences key (i.e AbstractMappingManager.PREFERENCES for mapping editor preferences)
	 * @param preferences	The preferences string
	 */
	public static void put(User user, String key, String preferences) {
		DB.getStatelessSession().beginTransaction();
		Meta.put(user, Preferences.generateKey(key), preferences);
	}

	/**
	 * Save user preferences specified by key. Preferences are defined by a json object. 
	 * @param user			The user
	 * @param key			The preferences key (i.e AbstractMappingManager.PREFERENCES for mapping editor preferences)
	 * @param preferences	The preferences json object
	 */
	public static void put(User user, String key, JSONObject preferences) {
		Preferences.put(user, key, preferences.toString());
	}
}
