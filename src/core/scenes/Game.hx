package core.scenes;

/**
 * ...
 * @author Kevin
 */

import core.Character; 
 
class Game extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
		
		//The boolean "true" at the end controls whether or not to show the entity (in this case, the Character)
		
		
		addEntity(new Character(_kernel, _assetManager, "assets.data", "Goku.xml"), true);
		addEntity(new Character(_kernel, _assetManager, "assets.data", "Circle.xml", 100.0, 100.0), true);
	}

}
