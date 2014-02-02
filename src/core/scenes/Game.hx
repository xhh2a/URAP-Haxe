package core.scenes;

/**
 * ...
 * @author Kevin
 */

import core.Character; 
import core.Projectile;
import core.RectCollider;
 
class Game extends AScene 
{
	var _goku:Character;
	var _circle:Character;
	
	var rectColliderTest:RectCollider;
	
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
		
		_goku = new Character(_kernel, _assetManager, "assets.data", "Goku.xml", 10, 10);
		_circle = new Character(_kernel, _assetManager, "assets.data", "Circle.xml", 100, 102);
		_goku.addCharacterToScene(this, 1);
		_circle.addCharacterToScene(this, 4);
		
		rectColliderTest = new RectCollider(_kernel, _goku, 100, 200, 50, 50);
		
		//var proj:Projectile = new Projectile(_kernel, _assetManager, "assets.data", "Circle.xml", 350, 350);
		//proj.addCharacterToScene(this);
		
	}
	
	//Do game loop stuff here
	override private function _updater(p_deltaTime:Int = 0):Void 
	{
		super._updater(p_deltaTime);
		//_goku.checkCollision();
		//trace(_goku.checkCollision());
	}

}
