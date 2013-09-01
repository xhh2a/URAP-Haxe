package org.berkeley.health.core.load;

import flash.utils.ByteArray;
import openfl.Assets;
import flash.Lib;
import org.berkeley.health.core.sprites.Tower;
import org.berkeley.health.core.Globals;

class LoadData{
	public static var globalTowerData : Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
	/**
	 * Loads tower information
	 * TODO v1.5: Verify input XML is valid.
	 */
	public static function loadTowers() {
		/**
		 * Create a new instance of each tower level based on the data in XMLELEMENT
		 */
		var parseTower = function (xmlElement: Xml) {
			var defaultValues: Map<Attribute, Dynamic> = new Map<Attribute, Dynamic>();
			var testElement :Null<Xml> = null;
			for (child in xmlElement.elements()) { //Parse all default values.
				var tagAttrib:Attribute = Globals.toAttribute(child.nodeName);
				if (tagAttrib != levels) {
					defaultValues.set(tagAttrib, child.firstChild().nodeValue);
				} else {
					testElement = child;
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
				throw "Invalid Tower XML in assets/config/towers.xml: missing type";
			}
		}
		var temp = Xml.parse(Assets.getText("assets/config/towers.xml"));
		for (entry in temp.firstElement().elements()) {
			if (entry.nodeName == "tower") {
				parseTower(entry);
			} else {
				throw "Invalid Tower XML in assets/config/towers.xml: unrecognized child tag under data";
			}
		}
		Lib.trace("Done");
	}
}