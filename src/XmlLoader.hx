package ;

import AssetManager;
import Globals;
/**
 * ...
 * @author UC Berkeley
 */
class XmlLoader
{

	/**
	 * Loads information from XMLNAME located in XMLSUBDIRECTORY to MANAGER. Returns a Map<String, Map<String, Map<String, Dynamic>>>.
	 * 
	 * The first level of the Map has the Entity TYPE as the key for each Entity defined in an XML.
	 * 
	 * The second level of the Map has the Variation ID as the key for each Variation of an entity defined in an XML.
	 * 
	 * The third level of the Map has the Attribute STRING as they key and the Dynamic value as the value.
	 * 
	 * VALIDATOR is an optional function that takes the XML file (<data> tag is the top level) found and validates it, returning true if it validates and false if not.
	 */
	public static function loadFile(xmlSubdirectory:String, xmlName:String, manager:AssetManager, ?validator:Xml->Bool):Map<String, Map<String, Map<String, Dynamic>>> {
		var output: Map < String, Map < String, Map < String, Dynamic >>> = new Map < String, Map < String, Map < String, Dynamic >>> ();
		/**
		 * Helper function that does the actual XML parsing.
		 */
		var parseFile = function (xmlRoot: Xml) {
			var parseEntity = function(xmlEntity:Xml) {
				var entityDefaults: Map<String, Dynamic> = new Map<String, Dynamic>();
				var variationSubElement :Null<Xml> = null; //There can only ever be one of these in an XML!
				for (entity in xmlEntity.elements()) { //Parse all default values.
					var tagAttrib:String = child.nodeName;
					if (tagAttrib.toLowerCase != Globals.XMLVARIANTSEPARATOR) {
						defaultValues.set(tagAttrib, child.firstChild().nodeValue);
					} else {
						if (vairationSubElement != null) {
							throw manager.getText("xmlloader.exception.invalidvariation", [xmlName, xmlSubdirectory] );
						}
						variationSubElement = child;
					}
				}
				return [ entityDefaults, variationSubElement ];
			}
			var parseVariation = function(xmlVariant:Xml, defaults:Map<String, Dynamic> ) {
				var overwriteArray: Map<String, Dynamic> = new Map<String, Dynamic>();
				var id:Null<Dynamic> = null;
		 		for (key in defaults.keys()) {
					overwriteArray[key] = defaults[key];
				}
				for (overwriteAttribute in xmlVariant.elements()) {
					var key:String = overwrite.nodeName;
					if (key.toLowerCase() == Globals.XMLVARIANTID.toLowerCase()) {
						if (id != null) {
							throw manager.getText("xmlloader.exception.invalidid", [xmlName, xmlSubdirectory] );
						}
						id = overwrite.firstChild().nodeValue;
					} else {
						overwriteArray[key] = overwrite.firstChild().nodeValue;
					}
				}
				return [id, overwriteArray] ;
			}
			for (entity in xmlRoot) {
				var result = parseEntity(xmlRoot);
				for (variation in result[1]) {
					var variantresult = parseVariation(result[1], result[0]);
					
				}
			}
		}
		
		var temp:Xml = Xml.parse(manager.getAsset(xmlName, xmlSubdirectory));
		if (validator != null) {
			validator(temp);
		}
		parseFile(temp.firstElement());
		//trace("Test File Name: " + xmlName + " Test Subdirectory: " + xmlSubdirectory);
		return output;
	}

	
}