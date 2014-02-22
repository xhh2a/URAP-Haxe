package core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import awe6.interfaces.EKey;

/**
 * ...
 * @author Kevin
 */
	
class PlayerControl extends Entity 
{	
	private var _context:Context;
	
	public var leftPressed:Bool;
	public var rightPressed:Bool;
	public var upPressed:Bool;
	public var downPressed:Bool;
	public var attackPressed:Bool;
	
	public var _characterBeingControlled:Character;
	
	//TODO: add dragging stuff somewhere within this class
	
	/**
	 * This class handles the inputs from the player playing this game, including keyboard presses/screen taps and drags
	 * @param	p_kernel	The kernel
	 * @param	characterBeingControlled	The Character that the player of this game is currently controlling
	 */
	public function new( p_kernel:IKernel, characterBeingControlled:Character ) 
	{
		_kernel = p_kernel;
		
		_characterBeingControlled = characterBeingControlled;
		
		//setting default controls; these controls can be changed depending on the platform used or the player's preferences
		leftPressed = _kernel.inputs.keyboard.getIsKeyDown(EKey.LEFT);
		rightPressed = _kernel.inputs.keyboard.getIsKeyDown(EKey.RIGHT);
		upPressed = _kernel.inputs.keyboard.getIsKeyDown(EKey.UP);
		downPressed = _kernel.inputs.keyboard.getIsKeyDown(EKey.DOWN);
		attackPressed = _kernel.inputs.keyboard.getIsKeyDown(EKey.SPACE);

		_context = new Context();
		super( p_kernel, _context );
	}
	
	override private function _init():Void 
	{
		super._init();
		// extend here
		
	}
	
	public function handleInput():Void
	{
		if (_kernel.inputs.keyboard.getIsKeyDown(EKey.LEFT))
		{
			_characterBeingControlled._xCoordinate -= 1;
			_characterBeingControlled._characterImage.x -= 1;
		}
		if (_kernel.inputs.keyboard.getIsKeyDown(EKey.RIGHT))
		{
			_characterBeingControlled._xCoordinate += 1;
			_characterBeingControlled._characterImage.x += 1;
		}
		if (_kernel.inputs.keyboard.getIsKeyDown(EKey.UP))
		{
			_characterBeingControlled._yCoordinate -= 1;
			_characterBeingControlled._characterImage.y -= 1;
		}
		if (_kernel.inputs.keyboard.getIsKeyDown(EKey.DOWN))
		{
			_characterBeingControlled._yCoordinate += 1;
			_characterBeingControlled._characterImage.y += 1;
		}
		if (_kernel.inputs.keyboard.getIsKeyDown(EKey.SPACE))
		{
			//perform attacking here
		}
	}
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here
		handleInput();
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}