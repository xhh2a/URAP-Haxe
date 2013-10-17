package ;

import AssetManager;
import Globals;
/**
 * ...
 * @author UC Berkeley
 */

typedef ENTITYRESULT = { type:String, entityMap:Map<String, Dynamic>, variationRoot:Xml };

typedef VARIANTRESULT = { id:String, attributeMap:Map<String, Dynamic>};

//TODO: Improve error messaging to show lines and/or parent node name.
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
		/**
		 * Helper function that does the actual XML parsing.
		 */
		var parseEntity = function(xmlEntity:Xml):ENTITYRESULT {
			var entityDefaults: Map<String, Dynamic> = new Map<String, Dynamic>();
			var variationSubElement :Null<Xml> = null; //There can only ever be one of these in an XML!
			var entityType:Null<String> = null;
			for (entity in xmlEntity.elements()) { //Parse all default values.
				var tagAttrib:String = entity.nodeName;
				if (tagAttrib.toLowerCase() == Globals.XMLVARIANTSEPARATOR.toLowerCase()) {
					if (variationSubElement != null) {
						throw manager.getText("xmlloader.exception.invalidvariation", [xmlName, xmlSubdirectory] );
					}
					variationSubElement = entity;
				} else if (tagAttrib.toLowerCase() == Globals.XMLENTITYTYPE.toLowerCase()) {
					if (entityType != null) {
						throw manager.getText("xmlloader.exception.invalidtype", [xmlName, xmlSubdirectory] );
					}
					entityType = entity.firstChild().nodeValue;
				} else {
					entityDefaults.set(tagAttrib, entity.firstChild().nodeValue);
				}
			}
			if (entityType == null) {
				throw manager.getText("xmlloader.exception.missingtype", [xmlName, xmlSubdirectory] );
			}
			var output:ENTITYRESULT = { type:entityType, entityMap: entityDefaults, variationRoot: variationSubElement };
			return output;
		}
		var parseVariation = function(xmlVariant:Xml, defaults:Map<String, Dynamic> ):VARIANTRESULT {
			var overwriteArray: Map<String, Dynamic> = new Map<String, Dynamic>();
			var id:Null<Dynamic> = null;
		 	for (key in defaults.keys()) {
				overwriteArray.set(key, defaults.get(key));
			}
			for (overwriteAttribute in xmlVariant.elements()) {
				var key:String = overwriteAttribute.nodeName;
				if (key.toLowerCase() == Globals.XMLVARIANTID.toLowerCase()) {
					if (id != null) {
						throw manager.getText("xmlloader.exception.invalidid", [xmlName, xmlSubdirectory] );
					}
					id = overwriteAttribute.firstChild().nodeValue;
				} else {
					overwriteArray.set(key, overwriteAttribute.firstChild().nodeValue);
				}
			}
			if (id == null) {
				throw manager.getText("xmlloader.exception.missingid", [xmlName, xmlSubdirectory] );
			}
			var output:VARIANTRESULT = { id: id, attributeMap: overwriteArray };
			return output;
		}
		var parseFile = function (xmlRoot: Xml) {
			var outMap: Map < String, Map < String, Map < String, Dynamic >>> = new Map < String, Map < String, Map < String, Dynamic >>> ();
			for (entity in xmlRoot.elements()) {
				var entityOutMap: Map < String, Map < String, Dynamic >> = new Map < String, Map < String, Dynamic >> ();
				var entityResult:ENTITYRESULT = parseEntity(entity);
				for (variation in entityResult.variationRoot.elements()) {
					var variantresult:VARIANTRESULT = parseVariation(variation, entityResult.entityMap);
					entityOutMap.set(variantresult.id, variantresult.attributeMap);
				}
				outMap.set(entityResult.type, entityOutMap);
			}
			return outMap;
		}
		
		var temp:Xml = Xml.parse(manager.getAsset(xmlName, xmlSubdirectory));
		if (validator != null) {
			validator(temp);
		}
		return parseFile(temp.firstElement());
	}

	
}