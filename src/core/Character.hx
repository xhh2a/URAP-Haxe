package core;
import awe6.core.Entity;
import awe6.core.Scene;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.display.DisplayObject;

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
	public var _xCoordinate:Null<Int>;
	public var _yCoordinate:Null<Int>;
	
	//The x and y components of this Character's speed (how much we add/subtract to the character's position on each update)
	public var _speedX:Int;
	public var _speedY:Int;
	
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
	
	//Indicates which Character is currently being dragged; Only one Character can be dragged at a time
	public static var _characterThatIsBeingDraggedRightNow:Character;

	//The scene that this Character is currently in
	public var _scene:Scene;
	
	//A Map of all Characters that have been initialized (including this Character)
	//This Map is organized by the Character _type and _variationId
	//This is good for when you only want to pick out Characters that have a certain _type and/or _variationId
	public static var _allCharacters:Map<String, Map<String, MapList<Character>>>;
	
	//The index of this Character in its corresponding MapList in _allCharacters
	public var _index:Int;
	
	//A list of all Characters that have been initialized (including this Character)
	//This is good for when you have to iterate through ALL Characters to do something,
	//like when during the checkCollision() method
	public static var _iterableCharacterList:List<Character>;
	
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
	
	public static var _allColliders:Map<Character, List<Entity>>;
	
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
	public function new( p_kernel:IKernel, assetManager:AssetManager, ?fileDirectory:String, ?fileName:String, ?xCoordinate:Int, ?yCoordinate:Int ) 
	{
		_imageContainer = new Sprite();
		
		_assetManager = assetManager;
		
		_fileDirectory = fileDirectory;
		_fileName = fileName;

		//If we decided NOT to pass in one of the initial coordinates, we'll use a default of 0 for that coordinate
		if (xCoordinate == null)
		{
			_xCoordinate = 0;
		}
		else
		{
			_xCoordinate = xCoordinate;
		}
		if (yCoordinate == null)
		{
			_yCoordinate = 0;
		}
		else
		{
			_yCoordinate = yCoordinate;
		}
		
		//Initially, we'll have this character NOT moving
		_speedX = 0;
		_speedY = 0;
		
		_draggable = true;
		_isBeingDragged = false;
		
		if (_allCharacters == null)
		{			
			_allCharacters = new Map<String, Map<String, MapList<Character>>>();
		}
		
		if (_iterableCharacterList == null)
		{
			_iterableCharacterList = new List<Character>();
		}
		
		//We initially set the _frontness to null because at this point this Character hasn't been added to the screen yet
		//and therefore, it wouldn't make sense for it to hold a frontness value because it's not even visible!
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
		//we store the _index number for this Character,
		//then add this Character to _allCharacters into
		//the MapList reserved for Characters of this Character's _type and _variationId,
		//and then finally add that to our _unorganizedCharacterList
		_index = _allCharacters.get(_type).get(_variationId).size();
		_allCharacters.get(_type).get(_variationId).add(this);
		_iterableCharacterList.add(this);
		
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
			//In the next for-loop, after looping through all our present Characters and finding that one of them
			//has a _frontness value that is equal to the frontness that we want to assign to THIS Character when we add it,
			//we will bump up that Character's frontness by 1
			//and then change this needToDoShiftUp boolean to true to indicate that we should do the same for the Characters
			//with the higher frontness values
			var needToDoShiftUp:Bool = false;
			
			for (aCharacter in _iterableCharacterList)
			{
				if (needToDoShiftUp)
				{
					aCharacter._frontness++;
				}
				if (aCharacter._frontness == frontness)
				{
					aCharacter._frontness++;
					needToDoShiftUp = true;
				}			
			}
			
			_frontness = frontness;
		}
		else
		{
			_frontness = _defaultFrontness;
		}
		
		//adding this Character to the passed in Scene
		//The second parameter indicates whether or not we should make the Character visible on the screen
		scene.addEntity(this, true, _frontness);
		
		_scene = scene;
		_defaultFrontness++;
	}
	
	//Has not been fully implemented yet
	public function checkCollision():List<Character>
	{
		var collisions:List<Character> = new List<Character>();
		
		for (testCharacter in _iterableCharacterList.iterator())
		{
			if (testCharacter != this)
			{
				if (_characterImage.hitTestObject(testCharacter._characterImage))
				{
					//var coordinatesOfCurrentCharacterImage = new Point(_xCoordinate, _yCoordinate);
					//var coordinatesOfTestCharacterImage = new Point(testCharacter._xCoordinate, testCharacter._yCoordinate);
					
					var currentCharacterImageBoundingRect:Rectangle = _characterImage.getBounds(Lib.current);
					var testCharacterImageBoundingRect:Rectangle = testCharacter._characterImage.getBounds(Lib.current);
					var boundingRectIntersection:Rectangle = currentCharacterImageBoundingRect.intersection(testCharacterImageBoundingRect);
					
					//trace("boundingRectIntersection is " + boundingRectIntersection.isEmpty());
					
					if (!boundingRectIntersection.isEmpty())
					{
						var testArea:BitmapData = new BitmapData(cast(boundingRectIntersection.width, Int), cast(boundingRectIntersection.height, Int), false);
						
						var testMatrix:Matrix = _characterImage.transform.concatenatedMatrix;
						testMatrix.tx -= boundingRectIntersection.x;
						testMatrix.ty -= boundingRectIntersection.y;
						
						//var colorTransform:ColorTransform = new ColorTransform();
						//colorTransform.color = cast(4294967041, UInt);
						//testArea.draw(_characterImage, testMatrix, colorTransform);
						//trace(colorTransform.color);
						
						//orig
						//testArea.draw(_characterImage, testMatrix, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255));
						
						//test
						testArea.draw(_characterImage, testMatrix, new ColorTransform(0, 0, 0, 0, 255, 0, 0, 255));
						//var test:ColorTransform = new ColorTransform(0, 0, 0, 0, 255, -255, -255, 255);
						//trace("first one is " + test.color);
						
						testMatrix = testCharacter._characterImage.transform.concatenatedMatrix;
						testMatrix.tx -= boundingRectIntersection.x;
						testMatrix.ty -= boundingRectIntersection.y;
						
						//orig
						//testArea.draw(testCharacter._characterImage, testMatrix, new ColorTransform(1, 1, 1, 1, 255, 255, 255, 255), BlendMode.DIFFERENCE);
						
						//test
						testArea.draw(testCharacter._characterImage, testMatrix, new ColorTransform(0, 0, 0, 0, 255, 255, 255, 255), BlendMode.DIFFERENCE);
						//test = new ColorTransform(0, 0, 0, 0, 255, 255, 255, 255);
						//trace("second one is " + test.color);
						//orig
						//var possibleCollision:Rectangle = testArea.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
						
						//test
						var possibleCollision:Rectangle = testArea.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
						//var possibleCollision:Rectangle = testArea.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
						trace("possibleCollision width is " + possibleCollision.width);
						if (possibleCollision.width != 0)
						{
							trace(testCharacter._type);
							trace("here");
							collisions.add(testCharacter);
						}
					}
					
					//trace(boundingRectIntersection);
					
					/*if (_characterImageData.hitTest(coordinatesOfCurrentCharacterImage, 255, testCharacter._characterImage, coordinatesOfTestCharacterImage, 255))
					{
						trace(testCharacter._type);
						collisions.add(testCharacter);
					}*/
				}
			}
		}
		
		return collisions;
	}
	
	/**
	 * Sets a specific speed for this Character
	 * Default values are 0 for speedX and speedY
	 * If you don't pass in any arguments, this will set the speed to 0 for both directions, stopping our Character movement
	 * @param	speedX	The x-component of the speed
	 * @param	speedY	The y-component of the speed
	 */
	public function setSpeed(speedX:Int = 0, speedY:Int = 0):Void
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

	/** Attempts to convert the value associated with KEY in _attribute to a Bool if it exists. */
	private function attributeToBool(key:String):Void
	{
		if (_attribute.exists(key))
		{
			if (key == "true" || key == "1")
			{
				_attribute.set(key, true);
			}
			else if (key == "false" || key == "0")
			{
				_attribute.set(key, false);
			}
		}
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
		
		//Moving our Character according to the current speed that's stored
		_imageContainer.x += _speedX;
		_imageContainer.y += _speedY;

		//Setting x-coordinates and y-coordinates (yes, this is apparently necessary)
		_xCoordinate = cast(_imageContainer.x, Int);
		_yCoordinate = cast(_imageContainer.y, Int);

		//The following if/else statments control the dragging
		if (_draggable && _kernel.inputs.mouse.getIsButtonDown() && ((_characterThatIsBeingDraggedRightNow == null) || (_characterThatIsBeingDraggedRightNow == this)))
		{
			if (!_isBeingDragged && (_characterImageData.getPixel32(_kernel.inputs.mouse.getButtonLastClickedX() - _xCoordinate, _kernel.inputs.mouse.getButtonLastClickedY() - _yCoordinate) != 0))
			{
				var characterImagesUnderClickedPoint:Array<DisplayObject> = _imageContainer.parent.getObjectsUnderPoint(new Point(_kernel.inputs.mouse.getButtonLastClickedX(), _kernel.inputs.mouse.getButtonLastClickedY()));			
				var characterWithHighestFrontness:Character = this;
				
				for (aCharacterImage in characterImagesUnderClickedPoint)
				{
					for (aCharacter in _iterableCharacterList)
					{
						if ((aCharacterImage == aCharacter._characterImage) && (aCharacter._draggable))
						{
							if (aCharacter._characterImageData.getPixel32(_kernel.inputs.mouse.getButtonLastClickedX() - aCharacter._xCoordinate, _kernel.inputs.mouse.getButtonLastClickedY() - aCharacter._yCoordinate) != 0)
							{								
								if (aCharacter._frontness > characterWithHighestFrontness._frontness)
								{
									characterWithHighestFrontness = aCharacter;
								}
							}
							
							break;
						}
					}
				}				
				
				if (characterWithHighestFrontness == this)
				{
					_isBeingDragged = true;
					_characterThatIsBeingDraggedRightNow = this;
					_distanceFromTopLeftCornerOfImageX = _kernel.inputs.mouse.x - _imageContainer.x;
					_distanceFromTopLeftCornerOfImageY = _kernel.inputs.mouse.y - _imageContainer.y;
				}
				else
				{
					_isBeingDragged = false;
					_distanceFromTopLeftCornerOfImageX = null;
					_distanceFromTopLeftCornerOfImageY = null;
				}
			}
			if (_isBeingDragged)
			{
				_imageContainer.x = _kernel.inputs.mouse.x - _distanceFromTopLeftCornerOfImageX;
				_imageContainer.y = _kernel.inputs.mouse.y - _distanceFromTopLeftCornerOfImageY;
			}
		}
		else
		{
			_isBeingDragged = false;
			_distanceFromTopLeftCornerOfImageX = null;
			_distanceFromTopLeftCornerOfImageY = null;
			
			if (_characterThatIsBeingDraggedRightNow == this)
			{
				_characterThatIsBeingDraggedRightNow = null;
			}
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
	
	/**
	 * Calls the private _disposer() method (which I don't think I can make public because it overrides a private method)
	 */
	public function disposeCharacter():Void
	{
		_disposer();
	}
	
}