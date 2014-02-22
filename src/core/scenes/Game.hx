package core.scenes;

/**
 * ...
 * @author Kevin
 */

import core.Character; 
import core.PlayerControl;
import core.Projectile;
import core.RectCollider;
import awe6.interfaces.EKey;
 
class Game extends AScene 
{
	var _goku:Character;
	var _circle:Character;
	
	var _playerControl:PlayerControl;
	
	var rectColliderTest:RectCollider;
	
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
		
		

		//_circle = new Character(_kernel, _assetManager, 100, 102);
		
		var _temp = new Character(_kernel, _assetManager, 10, 10);
		_temp.preloader("assets.data", "Goku.xml");
		_goku = cast(_assetManager.entityTemplates.get('Goku').get('Adult Goku').getCopy(), Character);
		trace("Works");
		_goku.addCharacterToScene(this, 1);
		trace(_assetManager.allCharacters);
		//_circle.addCharacterToScene(this, 4);
		
		_playerControl = new PlayerControl(_kernel, _goku);
		
		rectColliderTest = new RectCollider(_kernel, _goku, 100, 200, 50, 50);
		
		//var proj:Projectile = new Projectile(_kernel, _assetManager, "assets.data", "Circle.xml", 350, 350);
		//proj.addCharacterToScene(this);
		
	}
	
	//Do game loop stuff here
	override private function _updater(p_deltaTime:Int = 0):Void 
	{
		super._updater(p_deltaTime);
		_playerControl._updater(p_deltaTime);
	}

}
