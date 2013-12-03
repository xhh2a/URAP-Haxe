package core.scenes;

/**
 * ...
 * @author Kevin
 */

import core.Character; 
 
class Game extends AScene 
{
	var _goku:Character;
	var _circle:Character;
	
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
		
		_goku = new Character(_kernel, _assetManager, "assets.data", "Goku.xml", 10, 10);
		_circle = new Character(_kernel, _assetManager, "assets.data", "Circle.xml", 100, 102);
		_goku.addCharacterToScene(this);
		_circle.addCharacterToScene(this);
	}
	
	//Do game loop stuff here
	override private function _updater(p_deltaTime:Int = 0):Void 
	{
		super._updater(p_deltaTime);
		
		trace(_goku.checkCollision());
	}

}
