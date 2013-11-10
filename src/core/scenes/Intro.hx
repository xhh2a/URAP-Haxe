package awe6test2.scenes;

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
	}

	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// example:
		if ( _kernel.inputs.keyboard.getIsKeyRelease( _kernel.factory.keyNext ) ) 
		{
			_kernel.scenes.next();
		}
	}
}
