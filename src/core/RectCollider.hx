package core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */

 
//We might not need this...
class RectCollider extends Entity 
{
	public var _associatedCharacter:Character;
	
	public var _xCoordinate:Int;
	public var _yCoordinate:Int;
	
	public var _width:Int;
	public var _height:Int;	
	
	public var _matrix:Matrix;
	
	public var _debugDisplay:Context;
	public var _showDebugDisplay:Bool;
	
	//FUCK: add parameter to make it an option as to whether to show the debug display
	
	public function new( p_kernel:IKernel, associatedCharacter:Character, xCoordinate:Int, yCoordinate:Int, width:Int, height:Int ) 
	{
		_associatedCharacter = associatedCharacter;
		
		_xCoordinate = xCoordinate;
		_yCoordinate = yCoordinate;
		
		_width = width;
		_height = height;
		
		_debugDisplay = new Context();
		_debugDisplay.x = _xCoordinate;
		_debugDisplay.y = _yCoordinate;

		super( p_kernel, _debugDisplay );
	}
	
	override private function _init():Void 
	{
		super._init();
		
		// extend here
		#if debug
			_showDebugDisplay = true;			
		#else
			_showDebugDisplay = false;
		#end
		
		_associatedCharacter._scene.addEntity(this, true, _tools.BIG_NUMBER);
	}
	
	/*private function findPerpendicular():Array<Int>
	{
		
	}*/
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );

		// extend here
		if (_showDebugDisplay)
		{
			var colliderBounds:Rectangle = _debugDisplay.getBounds(_debugDisplay.parent);
			//KEVIN: add on to this later
			
			_debugDisplay.graphics.lineStyle(1, 0x00FF00);
			_debugDisplay.rotation = 20;
			_debugDisplay.graphics.drawRect(_xCoordinate, _yCoordinate, _width, _height);
			
		}
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}