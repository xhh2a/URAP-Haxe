package org.berkeley.health.core.sprites;

import org.flixel.FlxSprite;
import org.berkeley.health.core.Globals;
/**
 * This is a base Tower object which is both a tower and
 * @author UC Berkeley URAP
 */
class Tower extends FlxSprite {
	
	public var towerAttribs: Map<Attribute, Dynamic>;

	public function new() 
	{
		super();
		this.towerAttribs = new Map<Attribute, Dynamic>();
	}

	/**
	 * Sets KEY to VALUE. Key should be a core.Globals Attribute ENUM.
	 */
	public function setAttribute(key: Attribute, value) {
		this.towerAttribs[key] = value;
	}

	/**
	 * Gets a value associated with KEY. Key should be a core.Globals Attribute ENUM.
	 */
	public function getAttribute(key: Attribute) {
		return this.towerAttribs[key];
	}

	/**
	 * Returns a copy of the given tower.
	 */
	public function getCopy() {
		var out = new Tower();
		for (key in this.towerAttribs.keys()) {
			out.setAttribute(key, this.getAttribute(key));
		}
		return out;
	}
}