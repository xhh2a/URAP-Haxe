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
		var globalData : Map < String, List<Dynamic> > = new Map < String, List<Dynamic> > ();
		/**
		 * Helper function that does the actual XML parsing.
		 */
		/*
		var parseFile = function (xmlElement: Xml) {
			var defaultValues: Map<String, Dynamic> = new Map<String, Dynamic>();
			var variationSubElement :Null<Xml> = null; //There can only ever be one of these in an XML!
			for (child in xmlElement.elements()) { //Parse all default values.
				var tagAttrib:String = child.nodeName;
				if (tagAttrib.toLowerCase != Globals.XMLLEVELSEPARATOR) {
					defaultValues.set(tagAttrib, child.firstChild().nodeValue);
				} else {
					if (vairationSubElement != null) {
						throw manager.getText("xmlloader.exception.invalidvariation", [xmlName, xmlSubdirectory] );
					}
					variationSubElement = child;
				}
			}
			var dataArray: Array<Dynamic> = new Array();
			for (level in testElement.elements()) {
				var templateTower = new Tower();
				for (key in defaultValues.keys()) {
					templateTower.setAttribute(key, defaultValues[key]);
				}
				for (overwrite in level.elements()) {
					var key:Attribute = Globals.toAttribute(overwrite.nodeName);
					templateTower.setAttribute(key, overwrite.firstChild().nodeValue);
				}
				dataArray.push(templateTower);
			}
			if (defaultValues.exists(type)) {
				globalTowerData[Std.string(defaultValues[type])] = dataArray;
			} else {
				throw "Invalid XML";
			}
		}
		*/
		//var temp:Xml = Xml.parse(manager.getAsset(xmlName, xmlSubdirectory));
		if (validator != null) {
			//validator(temp);
		}
		//parseFile(temp.firstElement());
		trace("Test File Name: " + xmlName + " Test Subdirectory: " + xmlSubdirectory);
	}

	
}