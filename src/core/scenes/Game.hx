package awe6test2.scenes;

/**
 * ...
 * @author Kevin
 */

import awe6test2.Character; 
 
class Game extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
		
		//addEntity(new Character(_kernel, _assetManager.circle, 100.0, 100.0), true);
		
		addEntity(new Character(_kernel, _assetManager, "assets.data", "Circle.xml", _assetManager.circle, 100.0, 100.0), true);
	}

}
