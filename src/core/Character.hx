package core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.core.Scene;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import ICustomEntity;
import XmlLoader;

/**
 * ...
 * @author Kevin
 */
	
class Character extends Entity implements ICustomEntity
{
	//Stuff that will be used with XmlLoader
	public var _attribute:Map<String, Dynamic>; //Map that stores the attributes stored within a given variation in the XML
	public var _type:String; //the type specified in the type tag in the XML file
	public var _variationId:String; //the String contained within the id tag in one of the variations in the XML file
	public var _loadedXmlInfo:Map < String, Map < String, Map < String, Dynamic > > >;
	
	public var _assetManager:AssetManager;
	public var _fileDirectory:Null<String>; //file directory as specified in the XML file
	public var _fileName:Null<String>; //file name as specified in the XML file
	
	public var _imageContainer:Sprite; //the Sprite class is technically just a container that holds an image to be displayed
	public var _characterImage:Bitmap; //the image to be "contained" within _imageContainer
	public var _characterImageData:BitmapData; //info about the image in _characterImage (ie. dimensions, its current location, etc.)
	
	//The (x,y) coordinates of our Character
	public var _xCoordinate:Null<Float>;
	public var _yCoordinate:Null<Float>;
	
	//The x and y components of this Character's speed (how much we add/subtract to the character's position on each update)
	public var _speedX:Float;
	public var _speedY:Float;
	
	//Whether we are able to drag this character or not
	//Set to true if we can drag this character, set to false otherwise
	public var _draggable:Bool;
	
	//Calculation of the x and y components
	//of the distance between the current mouse position and the top-left corner of our image
	//These will be used in when we do dragging
	//The reason why we care about the distance between the mouse position and the top-left corner of the image
	//is because when we do dragging, the distance between the mouse position and top-left corner of the image
	//should remain the same throughout the drag
	public var _distanceFromTopLeftCornerOfImageX:Null<Float>;
	public var _distanceFromTopLeftCornerOfImageY:Null<Float>;
	
	//Set to true when our image is being dragged and set to false when our image is not being dragged
	public var _isBeingDragged:Bool;

	//The scene that this Character is currently in
	public var _scene:Scene;
	
	//A Map of all Characters that have been initialized (including this Character)
	//This Map is organized by the Character _type and _variationId
	public static var _allCharacters:Map<String, Map<String, MapList<Character>>>;
	
	//The index of this Character in its corresponding MapList in _allCharacters
	public var _index:Int;
	
	//This tells you "how much in front" this Character is
	//The higher the value of this frontness, the more in front this Character will be
	//For example, a Character with a frontness of 5 will be more in front than Characters with frontnesses 1 or 2
	//If you're still confused, think of it this way: If Character A stands in front of Character B,
	//then Character A will have a greater frontness value than Character B
	//The smallest frontness possible is 1 (a frontness of 1 means that the Character will show up most behind, as in behind EVERYTHING)
	public var _frontness:Null<Int>;
	
	//The default value for _frontness that this Character will have when it is added
	//The default value will increase every time a Character is added
	//So by default, every new Character you add appear in front of the other Characters you previously added
	public static var _defaultFrontness:Null<Int>;
	
	/**
	 * Initializes a Character, which is essentially a sprite, but I can't call name it Sprite because Sprite is already a built-in class
	 * Parameters with the question mark in front means it is optional
	 * NOTE: For the fileDirectory and fileName, these should be for the XML file, not the image!
	 * The image directory and name info should be included in the XML file
	 * @param	p_kernel	The kernel of game (usually, passed in as _kernel)
	 * @param	assetManager	The AssetManager (usually, passed in as _assetManager)
	 * @param	?fileDirectory	The file directory of the XML file
	 * @param	?fileName	The file name of the XML file
	 * @param	?xCoordinate	The x coordinate for the image to start out at
	 * @param	?yCoordinate	The y coordinate for the image to start out at
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
		
		//Initially, we'll have this character NOT moving
		_speedX = 0.0;
		_speedY = 0.0;
		
		_draggable = true;
		_isBeingDragged = false;
		
		if (_allCharacters == null)
		{			
			_allCharacters = new Map<String, Map<String, MapList<Character>>>();
		}
		
		_frontness = null;
		
		if (_defaultFrontness == null)
		{
			_defaultFrontness = 1;
		}
		
		super( p_kernel, _imageContainer );
	}
	
	/**
	 * More initialization
	 */
	override private function _init():Void 
	{
		super._init();
		// extend here
		
		//Checking to see whether the file directory and name was actually passed in (or set)
		if (_fileDirectory != null && _fileName != null)
		{
			//Loading the XML file and then retrieving the information we want from it
			_loadedXmlInfo = XmlLoader.loadFile(_fileDirectory, _fileName, _assetManager);
			_type = _loadedXmlInfo.keys().next();
			_variationId = _loadedXmlInfo.get(_type).keys().next();
			_attribute = _loadedXmlInfo.get(_type).get(_variationId);
			_characterImageData = _assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		
			//These lines "create the image" based on _characterImageData (the information about the image)
			//then adds this created image into our image container
			_characterImage = new Bitmap(_characterImageData);
			_imageContainer.addChild(_characterImage);
		}
		
		//If our _allCharacters Map does not already contain a key for this Character's _type, then we create it
		if (!_allCharacters.exists(_type))
		{
			_allCharacters.set(_type, new Map < String, MapList<Character> > () );			
		}
		//If our _allCharacters Map does not already contain a key for this Character's _variationId under its _type,
		//then we create it
		if (!_allCharacters.get(_type).exists(_variationId))
		{
			_allCharacters.get(_type).set(_variationId, new MapList<Character>());
		}
		
		//Now that we insured that our _allCharacters Map contains a key for this Character's _type and _variationId,
		//we store the _index number for this Character
		//then add this Character to _allCharacters into
		//the MapList reserved for Characters of this Character's _type and _variationId
		_index = _allCharacters.get(_type).get(_variationId).size();
		_allCharacters.get(_type).get(_variationId).add(this);
		
		
		//Sets the position of the image container to the initialized coordinates
		_imageContainer.x = _xCoordinate;
		_imageContainer.y = _yCoordinate;
		
		//Setting these to null because we don't care about these at this point
		//We will start caring about these when dragging happens
		_distanceFromTopLeftCornerOfImageX = null;
		_distanceFromTopLeftCornerOfImageY = null;
	}

	/**
	 * Adds this Character to a Scene that we pass in
	 * If you decide not to pass in a frontness value, it will by default make this Character in front of everything
	 * @param	scene	The specific Scene that we want to add this Character to
	 * @param	?frontness	The frontness value that you want to set
	 */
	public function addCharacterToScene(scene:Scene, ?frontness:Int):Void
	{
		if (frontness != null)
		{
			_frontness = frontness;
		}
		else
		{
			_frontness = _defaultFrontness;
		}
		scene.addEntity(this, true, _frontness);
		_scene = scene;
		_defaultFrontness++;
	}
	
	//Has not been fully implemented yet
	public function checkCollision():List<Character>
	{
		var collisions:List<Character> = new List<Character>();
		
		return collisions;
	}
	
	/**
	 * Sets a specific speed for this Character
	 * Default values are 0.0 for speedX and speedY
	 * If you don't pass in any arguments, this will set the speed to 0.0 for both directions, stopping our Character movement
	 * @param	speedX	The x-component of the speed
	 * @param	speedY	The y-component of the speed
	 */
	public function setSpeed(speedX:Float = 0.0, speedY:Float = 0.0):Void
	{
		_speedX = speedX;
		_speedY = speedY;
	}
	
	/**
	 * Creates a new Character with the same _characterImageData and XML file as this one
	 */
	public function getCopy(?attribute:Map<String, Dynamic>):ICustomEntity
	{
		var copiedCharacter = new Character(_kernel, _assetManager);
		
		copiedCharacter._loadedXmlInfo = XmlLoader.loadFile(_fileDirectory, _fileName, _assetManager);
		copiedCharacter._fileName = new String(_fileName);
		copiedCharacter._fileDirectory = new String(_fileDirectory);
		copiedCharacter._type = new String(_type);
		copiedCharacter._variationId = new String(_variationId);		
		copiedCharacter._attribute = _loadedXmlInfo.get(_type).get(_variationId);
		copiedCharacter._characterImageData = copiedCharacter._assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		
		copiedCharacter._draggable = _draggable;
		
		copiedCharacter._characterImage = new Bitmap(_characterImageData);
		copiedCharacter._imageContainer.addChild(copiedCharacter._characterImage);
		
		return copiedCharacter;
	}
	
	/** Attempts to convert the value associated with KEY in _attribute to a Float if it exists. */
	private function attributeToFloat(key:String):Void
	{
		if (_attribute.exists(key)) {
			_attribute.set(key, Std.parseFloat(_attribute.get(key)));
		}
	}

	/** Attempts to convert the value associated with KEY in _attribute to a Int if it exists. */
	private function attributeToInt(key:String):Void
	{
		if (_attribute.exists(key)) {
			_attribute.set(key, Std.parseInt(_attribute.get(key)));
		}
	}

	private function attributeToBool(key:String):Void
	{
		//TODO: Figure out what String representation of Bool is, to reverse convert back.
	}

	/** Returns a copy of _attribute with all values converted to a new String. */
	private function getStringAttributeMap():Map<String, Dynamic>
	{
		var out:Map<String, Dynamic> = new Map<String, Dynamic>();
		for (akey in this._attribute.keys()) {
			var copyKey:String = new String(akey);
			var copyValue:String = Std.string(this._attribute[akey]);
			out.set(copyKey, copyValue);
		}
		return out;
	}
	
	/**
	 * Updates the properties of our character (ie. position, whether it's being dragged, etc.) while our game is still open
	 */
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here

		_imageContainer.x += _speedX;
		_imageContainer.y += _speedY;
		
		_xCoordinate = _imageContainer.x;
		_yCoordinate = _imageContainer.y;

		if (_kernel.inputs.mouse.getIsButtonDown())
		{	
			if (_isBeingDragged || (_characterImageData.getPixel32(_kernel.inputs.mouse.getButtonLastClickedX() - cast(_xCoordinate, Int), _kernel.inputs.mouse.getButtonLastClickedY() - cast(_yCoordinate, Int)) != 0))
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
	
	/**
	 * Disposes (removes) our Character
	 * Currently, this has not been tested yet
	 */
	override private function _disposer():Void 
	{
		// extend here
		
		_allCharacters.get(_type).get(_variationId).removeItemAt(_index);
		
		removeEntity(this, true);
		super._disposer();
	}
	
}