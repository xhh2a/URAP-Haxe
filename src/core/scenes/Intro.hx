package core.scenes;

/**
 * ...
 * @author Kevin
 */
import awe6.core.Context;

class Intro extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		// extend / addentities
		
		_title.text = "INTRO";
		var _temp = new Character(_kernel, _assetManager, 10, 10);
		_temp.preloader("assets.data", "Goku.xml");
		var _goku = cast(_assetManager.entityTemplates.get('Goku').get('Adult Goku').getCopy(), Character);
		trace("Works");
		_goku.addCharacterToScene(this, 1);

	}

	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		
		//so far, what this part does is switch to the Game scene (Game.hx) when you press the Space bar
		//it can be changed later if we want
		if ( _kernel.inputs.keyboard.getIsKeyRelease( _kernel.factory.keyNext ) ) 
		{
			_kernel.scenes.next();
		}
	}
}
