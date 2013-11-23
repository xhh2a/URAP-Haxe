package core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import ICustomEntity;
import XmlLoader;

import flash.events.Event;
import flash.events.MouseEvent;


/**
 * ...
 * @author Kevin
 */
	
class Character extends Entity implements ICustomEntity
{
	//Stuff that will be used with XmlLoader
	public var _attribute: Map<String, Dynamic>; //Map that stores the attributes stored within a given variation in the XML
	public var _type:String; //the type specified in the type tag in the XML file
	var _assetManager:AssetManager;
	var _fileDirectory:Null<String>; //file directory as specified in the XML file
	var _fileName:Null<String>; //file name as specified in the XML file
	
	var _imageContainer:Sprite; //the Sprite class is technically just a container that holds an image to be displayed
	var _characterImage:Bitmap; //the image to be "contained" within _imageContainer
	var _characterImageData:BitmapData; //info about the image in _characterImage (ie. dimensions, its current location, etc.)
	
	//The (x,y) coordinates of our Character
	var _xCoordinate:Null<Float>;
	var _yCoordinate:Null<Float>;
	
	//Calculation of the x and y components
	//of the distance between the current mouse position and the top-left corner of our image
	//These will be used in when we do dragging
	//The reason why we care about the distance between the mouse position and the top-left corner of the image
	//is because when we do dragging, the distance between the mouse position and top-left corner of the image
	//should remain the same throughout the drag
	var _distanceFromTopLeftCornerOfImageX:Null<Float>;
	var _distanceFromTopLeftCornerOfImageY:Null<Float>;
	
	//Set to true when our image is being dragged and set to false when our image is not being dragged
	var _isBeingDragged:Bool;
	
	
	/**
	 * Initializes a Character, which is essentially a sprite, but I can't call name it Sprite because Sprite is already a built-in class
	 * Parameters with the question mark in front means it is optional
	 * NOTE: For the fileDirectory and fileName, these should be for the XML file, not the image!
	 * The image directory and name info should be included in the XML file
	 * @param	p_kernel The kernel of game (usually, passed in as _kernel)
	 * @param	assetManager The AssetManager (usually, passed in as _assetManager)
	 * @param	?fileDirectory The file directory of the XML file
	 * @param	?fileName The file name of the XML file
	 * @param	?xCoordinate The x coordinate for the image to start out at
	 * @param	?yCoordinate The y coordinate for the image to start out at
	 */
	public function new( p_kernel:IKernel, assetManager:AssetManager, ?fileDirectory:String, ?fileName:String, ?xCoordinate:Float, ?yCoordinate:Float ) 
	{
		_imageContainer = new Sprite();
		
		_assetManager = assetManager;
		
		_fileDirectory = fileDirectory;
		_fileName = fileName;		

		//If we decided NOT to pass in one of the initial coordinates, we'll use a default of 0.0 for that coordinate
		if (xCoordinate == null)
		{
			_xCoordinate = 0.0;			
		}
		else
		{
			_xCoordinate = xCoordinate;
		}
		if (yCoordinate == null)
		{
			_yCoordinate = 0.0;
		}
		else
		{
			_yCoordinate = yCoordinate;
		}
		
		_isBeingDragged = false;
		
		#if !html5
			//_imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			//_imageContainer.addEventListener(MouseEvent.MOUSE_UP, dragStop);
		#end
		
		super( p_kernel, _imageContainer );
	}
	
	/**
	 * More initialization
	 */
	override private function _init():Void 
	{
		super._init();
		// extend here
		
		//Checking to see whether the file directory and name was actually passed in
		if (_fileDirectory != null && _fileName != null)
		{
			var result:Map<String, Map<String, Map<String, Dynamic>>> = XmlLoader.loadFile(_fileDirectory, _fileName, _assetManager);
			_attribute = result.get("Character").get("Default");
			_characterImageData = _assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		}
		
		//These lines "create the image" based on _characterImageData (the information about the image)
		//then adds this created image into our image container
		//and then sets the position of the container to the initialized coordinates
		_characterImage = new Bitmap(_characterImageData);
		_imageContainer.addChild(_characterImage);
		_imageContainer.x = _xCoordinate;
		_imageContainer.y = _yCoordinate;
		
		_distanceFromTopLeftCornerOfImageX = null;
		_distanceFromTopLeftCornerOfImageY = null;
	}


	public function dragStart(e:Event):Void
	{
		if (_characterImageData.getPixel32(_kernel.inputs.mouse.x - cast(_xCoordinate, Int), _kernel.inputs.mouse.y - cast(_yCoordinate, Int)) != 0)
		{
			_imageContainer.startDrag();
		}
	}
	public function dragStop(e:Event):Void
	{
		_imageContainer.stopDrag();
	}

	/**
	 * Creates a new Character with the same _characterImageData and XML file as this one
	 */
	public function getCopy(?attribute:Map<String, Dynamic>):ICustomEntity
	{
		var copiedCharacter = new Character(_kernel, _assetManager);
		copiedCharacter._characterImageData = _characterImageData;
		copiedCharacter._fileName = _fileName;
		copiedCharacter._fileDirectory = _fileDirectory;
		
		return copiedCharacter;
	}

	/** Attempts to convert the value associated with KEY in _attribute to a Float if it exists. */
	private function attributeToFloat(key:String):Void {
		if (_attribute.exists(key)) {
			_attribute.set(key, Std.parseFloat(_attribute.get(key)));
		}
	}

	/** Attempts to convert the value associated with KEY in _attribute to a Int if it exists. */
	private function attributeToInt(key:String):Void {
		if (_attribute.exists(key)) {
			_attribute.set(key, Std.parseInt(_attribute.get(key)));
		}
	}

	private function attributeToBool(key:String):Void {
		//TODO: Figure out what String representation of Bool is, to reverse convert back.
	}

	/** Returns a copy of _attribute with all values converted to a new String. */
	private function getStringAttributeMap():Map<String, Dynamic> {
		var out:Map<String, Dynamic> = new Map<String, Dynamic>();
		for (akey in this._attribute.keys()) {
			var copyKey:String = new String(akey);
			var copyValue:String = Std.string(this._attribute[akey]);
			out.set(copyKey, copyValue);
		}
		return out;
	}
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here
		_xCoordinate = _imageContainer.x;
		_yCoordinate = _imageContainer.y;

		if (_kernel.inputs.mouse.getIsButtonDown())
		{
			if (_isBeingDragged || (_characterImageData.getPixel32(_kernel.inputs.mouse.x - cast(_xCoordinate, Int), _kernel.inputs.mouse.y - cast(_yCoordinate, Int)) != 0))
			{
				if (!_isBeingDragged)
				{
					_distanceFromTopLeftCornerOfImageX = _kernel.inputs.mouse.x - _imageContainer.x;
					_distanceFromTopLeftCornerOfImageY = _kernel.inputs.mouse.y - _imageContainer.y;
				}
				_isBeingDragged = true;
				
				_imageContainer.x = _kernel.inputs.mouse.x - _distanceFromTopLeftCornerOfImageX;
				_imageContainer.y = _kernel.inputs.mouse.y - _distanceFromTopLeftCornerOfImageY;
			}
		}
		else
		{
			_isBeingDragged = false;
			_distanceFromTopLeftCornerOfImageX = null;
			_distanceFromTopLeftCornerOfImageY = null;
		}	
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}