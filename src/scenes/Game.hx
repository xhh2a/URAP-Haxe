package scenes;

/**
 * ...
 * @author UC Berkeley
 */

class Game extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "GAME";
	}

}
