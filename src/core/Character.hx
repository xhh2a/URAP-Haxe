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
import Globals;

/**
 * @attributes
 * 'type' The type of the character. Note an actual character (not subclass) has type 'player'
 * 'id' The variation of this instance. Note an actual character (not subclass) has variations for difficulty.
 * 'fileName' The fileName to look for the image.
 * 'fileDirectory' The directory to look under for the image.
 * 'movementX' Arbitrary Haxe Code to evaluate for movement, x
 * 'movementY' Arbitrary Haxe Code to evaluate for movement, y
 * 'speedX' Speed multiplier, x movement
 * 'speedY' Speed multiplier, y movement
 * 'weaponType' Weapon (Projectile) Type for the character to use
 * 'weaponVariation' Weapon (Projectile) Variation for the character to use.
 */
class Character extends Entity implements ICustomEntity
{
    //Stuff that will be used with XmlLoader
    public var _attribute:Map<String, Dynamic>; //Map that stores the attributes stored within a given variation in the XML, see @attributes at the top.
    public var _assetManager:AssetManager;
    //The scene that this Character is currently in
    public var _scene:Scene;

    public var _imageContainer:Sprite; //the Sprite class is technically just a container that holds an image to be displayed
    public var _characterImage:Bitmap; //the image to be "contained" within _imageContainer
    public var _characterImageData:BitmapData; //info about the image in _characterImage (ie. dimensions, its current location, etc.)

    //The (x,y) coordinates of our Character
    public var _xCoordinate:Null<Float> = 0;
    public var _yCoordinate:Null<Float> = 0;

    //Whether we are able to drag this character or not
    //Set to true if we can drag this character, set to false otherwise
    public var _draggable:Bool = false;

    //Calculation of the x and y components
    //of the distance between the current mouse position and the top-left corner of our image
    //These will be used in when we do dragging
    //The reason why we care about the distance between the mouse position and the top-left corner of the image
    //is because when we do dragging, the distance between the mouse position and top-left corner of the image
    //should remain the same throughout the drag
    public var _distanceFromTopLeftCornerOfImageX:Null<Float> = null;
    public var _distanceFromTopLeftCornerOfImageY:Null<Float> = null;

    //Set to true when our image is being dragged and set to false when our image is not being dragged
    public var _isBeingDragged:Bool;


    //A higher layer appears in front
    public var _layer:Null<Int>;

    //The damage on the stack
    public var _unresolvedDamage:Float;
    
    //The current weapon that this Character is using
    //Points to a template instance of a projectile inside the AssetManager
    public var _currentWeapon:Projectile;

	private var _collisionFilter:Null < Map < String, List<String> >> = null;
	
	//TODO: put a bool field here to indicate whether this is a template or not
	//preloader should set that field to true, whereas when you create an instance from a template, you set that bool to false
	//when you do getCopy
	//Status: Just added
	public var _isTemplate:Bool = false;

    /**
     * Initializes a Character, which is essentially a sprite, but I can't call name it Sprite because Sprite is already a built-in class
     * Parameters with the question mark in front means it is optional
     * NOTE: For the fileDirectory and fileName, these should be for the XML file, not the image!
     * The image directory and name info should be included in the XML file
     * @param   p_kernel        The kernel of game (usually, passed in as _kernel)
     * @param   assetManager    The AssetManager (usually, passed in as _assetManager)
     * @param   ?xCoordinate    The x coordinate for the image to start out at
     * @param   ?yCoordinate    The y coordinate for the image to start out at
	 * @param   ?attribute      An attribute map to pass in (optional)
	 * @param   ?isTemplate     If this is a template
     */
	public function new( p_kernel:IKernel, assetManager:AssetManager, ?isTemplate:Bool, ?xCoordinate:Float, ?yCoordinate:Float, ?attribute:Map<String, Dynamic> ) {
		_imageContainer = new Sprite();
		_assetManager = assetManager;
		_kernel = p_kernel;
		if (xCoordinate != null)
		{
			_xCoordinate = xCoordinate;
		}
		if (yCoordinate != null)
		{
			_yCoordinate = yCoordinate;
		}
		if (attribute != null) {
			_attribute = attribute;
		} else {
			_attribute = new Map<String, Dynamic>();
		}
		if (isTemplate != null) {
			_isTemplate = isTemplate;
		}

		_imageContainer.x = Math.round(_xCoordinate);
		_imageContainer.y = Math.round(_yCoordinate);

		//These lines "create the image" based on _characterImageData (the information about the image)
		//then adds this created image into our image container
		if (_attribute.exists("fileName") && _attribute.exists("fileDirectory")) {
			_characterImageData = _assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));	
			_characterImage = new Bitmap(_characterImageData);
			_imageContainer.addChild(_characterImage);
		}

		//TODO: Handle missing character image data.
		//Status: Just added below
		else if (!_isTemplate)
		{
			//trace("Missing image data for Character");
		}
		
		if(_attribute.exists('draggable') && _attribute.get('draggable')) {
			_draggable = true;
		}

		_isBeingDragged = false;
		
		//We initially set the _layer to null because at this point this Character hasn't been added to the screen yet
		//and therefore, it wouldn't make sense for it to hold a layer value because it's not even visible!
		_layer = null;
	
		super( p_kernel, _imageContainer );
	}

	/** Calls xmlLoader and creates a template for every variation inside the file and stores it in the AssetManager */
	public function preloader(xmlDirectory:String, xmlName:String):Void {
		//Loading the XML file and then retrieve the information we want from it
		var _loadedXmlInfo:Map < String, Map < String, Map < String, Dynamic >>> = XmlLoader.loadFile(xmlDirectory, xmlName, _assetManager);
		//trace("Loaded");
		//trace(_loadedXmlInfo.toString());
		for (type in _loadedXmlInfo.keys()) {
			if (!_assetManager.entityTemplates.exists(type)) {
					_assetManager.entityTemplates.set(type, new Map<String, Character>());
				}
			var _storageTypeMap:Map<String, Character> = _assetManager.entityTemplates.get(type);
			var _typeMap = _loadedXmlInfo.get(type);
			for (variation in _typeMap.keys()) {
				if (!_storageTypeMap.exists(variation)) {
					_storageTypeMap.set(variation, new Character(_kernel, _assetManager, null, null, _typeMap.get(variation)));
				} //Else ignore, potentially print an error message.
			}
		}
		//trace(_assetManager.entityTemplates.toString());
		//trace(_assetManager.entityTemplates.get('Goku').get('Adult Goku')._attribute.toString());
	}

    /**
     * Adds this Character to a Scene that we pass in
     * If you decide not to pass in a layer value, it will by default make this Character in front of everything
     * @param   scene   The specific Scene that we want to add this Character to
     * @param   ?layer  The frontness value that you want to set
     */
	public function addCharacterToScene(scene:Scene, ?layer:Int):Void
	{
		if (layer != null)
		{
			_layer = layer;
			if (_layer >= Globals.nextLayer) {
				Globals.nextLayer = _layer + 1;
			}
		}
		else
		{
			_layer = Globals.nextLayer;
			Globals.nextLayer += 1;
		}
		//adding this Character to the passed in Scene
		//The second parameter indicates whether or not we should make the Character visible on the screen
		scene.addEntity(this, true, _layer);
		_scene = scene;
	}

	//Has not been fully implemented yet
	public function getCollision(?types:Map<String, List<String>>):List<Character>
	{
		var collisions:List<Character> = new List<Character>();
		
		//TODO: A change in how all items are stored in AssetManager means that filtering should be done before hand.
		//This is because after thinking about it, I believe it is more efficient to filter before hand rather than to check everything.
		for (type in _assetManager.allCharacters.keys()) {
			if ((types == null) || (types.exists(type))) {
				var _typeMap: Map<String, List<Character>> = _assetManager.allCharacters.get(type);
				var _filterVariation:List<String> = new List<String>();
				if (types != null) {
					_filterVariation = types.get(type);
				}
				for (variation in _typeMap.keys()) {
					if ((types == null) || Lambda.has(_filterVariation, 'all') || Lambda.has(_filterVariation, variation)) {
						for (testCharacter in _typeMap.get(variation)) {
							if (testCharacter != this) {
								if (_characterImage.hitTestObject(testCharacter._characterImage)) {
									var currentCharacterImageBoundingRect:Rectangle = _characterImage.getBounds(Lib.current);
									var testCharacterImageBoundingRect:Rectangle = testCharacter._characterImage.getBounds(Lib.current);
									var boundingRectIntersection:Rectangle = currentCharacterImageBoundingRect.intersection(testCharacterImageBoundingRect);					
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
										//trace("possibleCollision width is " + possibleCollision.width);
										if (possibleCollision.width != 0)
										{
											//trace(testCharacter._attribute.get('type'));
											//trace("here");
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
					}
				}
			}
		}
		return collisions;
	}

	/**
	 * Creates a new Character with the same _characterImageData and XML file as this one
	 */
	public function getCopy(?attribute:Map<String, Dynamic>, ?char:ICustomEntity):ICustomEntity
	{
		var copiedCharacter:Character;
		if (char == null) {
			//copiedCharacter = new Character(_kernel, _assetManager, isTemplate = false); WRONG
			copiedCharacter = new Character(_kernel, _assetManager, false);
		} else {
			copiedCharacter = cast(char, Character); //for stuff that extends Character
		}
		if (attribute == null) {
			copiedCharacter._attribute = this.getStringAttributeMap();
		} else {
			copiedCharacter._attribute = attribute;
		}
		copiedCharacter.updateAttributes();
		//TODO: Check if this is correct, see if there is a way to copy the memory without disk I/O
		copiedCharacter._characterImageData = copiedCharacter._assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		copiedCharacter._characterImage = new Bitmap(_characterImageData);
		copiedCharacter._imageContainer.addChild(copiedCharacter._characterImage);
		if (!_assetManager.allCharacters.exists(_attribute.get('type'))) {
			_assetManager.allCharacters.set(_attribute.get('type'), new Map < String, List<Character> > ());
		}
		var _allCharType:Map < String, List<Character> > = _assetManager.allCharacters.get(_attribute.get('type'));
		if (!_allCharType.exists(_attribute.get('id'))) {
			_allCharType.set(_attribute.get('id'), new List<Character>());
		}
		var _allInstanceList: List<Character> = _allCharType.get(_attribute.get('id'));
		_allInstanceList.add(this);
		return copiedCharacter;
	}

	//parses Strings in an attribute map
	public function updateAttributes():Void {
		//TODO
	}
	
	/** 
	 * Puts DAMAGEAMOUNT onto stack, amount varies based on the multiplier/additive values in AssetManager for SOURCE.
	 * @upgrades
	 * 'immune' Take no damage from the source, return immediatly.
	 * @modifiers
	 * 'damage' *= or += damage in AssetManager.multipliers and AssetManager.additive
	 * @attribute
	 * 'resistance' Resistance to a certain types of enemies, /=
	 * */
    public function addDamage(damageAmount:Float, source:Character):Void
    {
        var damage:Float = source._attribute.get('damage');
		var sourceAttribute:String = source._attribute.get('type');
		if (_assetManager.modifiers.exists('immune') && _assetManager.modifiers.get('immune').exists(this._attribute.get('type')) && _assetManager.modifiers.get('immune').get(this._attribute.get('type')).get(sourceAttribute)) {
			return;
		}
		if (_assetManager.multipliers.exists('damage')) {
			var innerMap:Map < String, Float > = _assetManager.multipliers.get('damage');
			if (innerMap.exists(sourceAttribute)) {
				damage *= innerMap.get(sourceAttribute);
			}
			if (innerMap.exists('global')) {
				damage *= innerMap.get('global');
			}
		}
		if (_assetManager.additive.exists('damage')) {
			var innerMap:Map < String, Float > = _assetManager.additive.get('damage');
			if (innerMap.exists(sourceAttribute)) {
				damage += innerMap.get(sourceAttribute);
			}
			if (innerMap.exists('global')) {
				damage += innerMap.get('global');
			}
		}
		if (_attribute.exists('resistance') && Lambda.has(_attribute.get('resistance').keys(), source._attribute.get('type'))) {
			damage /= _attribute.get('resistance').get(source._attribute.get('type'));
		}
        this._unresolvedDamage += damage;
    }

	/** Resolves damage on the stack */
    private function _updateHealth():Void {
        var damage:Float = this._unresolvedDamage;
		if (_assetManager.multipliers.exists('resistance')) {
			var innerMap:Map < String, Float > = _assetManager.multipliers.get('resistance');
			if (innerMap.exists(_attribute.get('type'))) {
				damage /= innerMap.get(_attribute.get('type'));
			}
			if (innerMap.exists('global')) {
				damage /= innerMap.get('global');
			}
		}
		if (_assetManager.additive.exists('resistance')) {
			var innerMap:Map < String, Float > = _assetManager.additive.get('resistance');
			if (innerMap.exists(_attribute.get('type'))) {
				damage -= innerMap.get(_attribute.get('type'));
			}
			if (innerMap.exists('global')) {
				damage -= innerMap.get('global');
			}
		}
        this._attribute.set('health', this._attribute.get('health') - damage);
        if (this._attribute.get('health') <= 0) {
            _disposer();
		}
    }

    /** Checks if this object should fire, and if so, does. */
	//TODO: Incomplete
    public function shouldFire(p_deltaTime:Int=0):Bool {
        var shouldFire:Bool;
		if (this._attribute.get('type') != 'player') {
			//TODO Evaluate arbitrary Haxe Boolean Code
			
			//For default, just fire every X seconds
		} else {
			//TODO See if fire button is clicked;
		}
		return false;
    }

	private function _fireFunction():Void {
		var weapon: Character;
		var copy: Projectile;
        if (this._attribute.get('type') == 'player') {
            weapon = _currentWeapon;
            copy = cast(weapon.getCopy(), Projectile); //Create instance from template
            //TODO Set X/Y coords, speed, etc on weapon by modifying copy._attribute
		} else if (this._attribute.exists('weaponType') && this._attribute.exists('weaponVariation')) {
			weapon = _assetManager.entityTemplates.get(this._attribute.get('weaponType')).get(this._attribute.get('weaponVariation'));
			copy = cast(weapon.getCopy(), Projectile);
		} else {
			//Undefined, throw an error, OR use a default type.
		}
		//TODO Set X/Y coords, speed, etc on weapon by modifying copy._attribute
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
			var copyValue:String = Std.string(this._attribute.get(akey));
			out.set(copyKey, copyValue);
		}
		return out;
	}

	/** 
	 * Defining this variable as a function allows child classes to overwrite this.
	 * This is passed into getCollusion() by _updated
	 * This should be overriden by child classes.
	 */
	private function _generateCollisionFilter(): Void {
		_collisionFilter = new Map < String, List<String> > (); //Return an empty list, let the other types deal with it.
	}

	/**
	 * This method takes care of movement update logic.
	 */
	private function _moveFunction(p_deltaTime:Int = 0): Void {
		//TODO
		if ((!_attribute.exists("movementX")) && (!_attribute.exists("movementY")))
		{
			//default stuff goes here
			//maybe add a check to see if this Character is controlled by the player?
		}
		else
		{
			//add stuff to parse the movement code from attribute here
			//Utils._moveContext(this);
		}
	}



	//going to get overrided by things that extend Character
	private function _onCollision(with :List<Character>):Void {
		return; //Don't do anything, let the other function deal with it.
	}

	/**
	 * Updates the properties of our character (ie. position, whether it's being dragged, etc.) while our game is still open
	 */
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		_moveFunction(p_deltaTime);
		if (_collisionFilter == null) {
			_generateCollisionFilter();
		}
		_onCollision(getCollision(_collisionFilter));
		_updateHealth();
		if (shouldFire(p_deltaTime)) {
			_fireFunction();
		}
		super._updater( p_deltaTime );

		// extend here
		/*
		//Moving our Character according to the current speed that's stored
		_imageContainer.x += _attribute.get('speedX');
		_imageContainer.y += _attribute.get('speedY');

		//Setting x-coordinates and y-coordinates (yes, this is apparently necessary)
		_xCoordinate = cast(_imageContainer.x, Int);
		_yCoordinate = cast(_imageContainer.y, Int);

		//The following if/else statments control the dragging
		
		//TODO: We should not be checking on every instance of a character! Potentially move to Game or AScene
		if (_draggable && _kernel.inputs.mouse.getIsButtonDown() && ((_characterThatIsBeingDraggedRightNow == null) || (_characterThatIsBeingDraggedRightNow == this)))
		{
			if (!_isBeingDragged && (_characterImageData.getPixel32(_kernel.inputs.mouse.getButtonLastClickedX() - Math.round(_xCoordinate), _kernel.inputs.mouse.getButtonLastClickedY() - Math.round(_yCoordinate)) != 0))
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
								if (aCharacter._frontness > characterWithHighestFrontness._layer)
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
		*/
	}

	/**
	 * Disposes (removes) our Character
	 */
	override private function _disposer():Void {
		// TODO: Implement game over for player here.
		_assetManager.allCharacters.get(_attribute.get('type')).get(_attribute.get('id')).remove(this);
		removeEntity(this, true);
		super._disposer();
	}

	/**
	 * Calls the private _disposer() method (which I don't think I can make public because it overrides a private method)
	 */
	public function disposeCharacter():Void	{
		_disposer();
	}
	
}