package core;
import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import ICustomEntity;
import XmlLoader;

//just trying to see if these might solve our dragging problem in the HTML5 platform... still testing...
import js.html.EventListener;
import js.html.Image;
import js.html.ImageData;

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
	
	//might have to use these javascript classes? not sure yet though...
	var _jsImage:Image;
	var _jsImageData:ImageData;
	
	//Apparently, these two are needed in order to set the initial position of our Character and make dragging work
	var _xCoordinate:Null<Float>;
	var _yCoordinate:Null<Float>;
	
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

		//If we decided NOT to pass in one of the initial coordinates, we'll use a default of 0.0
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
			_attribute = result.get("Circle").get("Placeholder");
			_characterImageData = _assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		}
		
		//These lines "create the image" based on _characterImageData (the information about the image)
		//then adds this created image into our image container
		//and then sets the position of the container to the initialized coordinates
		_characterImage = new Bitmap(_characterImageData);
		_imageContainer.addChild(_characterImage);
		_imageContainer.x = _xCoordinate;
		_imageContainer.y = _yCoordinate;
		
		//These two lines are what will handle the dragging of our Character
		//For the HTML5 platform, these event listeners won't work, and instead, dragging for HTML5 will be dealt with below
		//Also note that dragging ignores transparent pixels, so even if you click on a transparent portion of the image,
		//the image will still drag
		_imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragStart); //starts dragging when the mouse is held down
		_imageContainer.addEventListener(MouseEvent.MOUSE_UP, dragStop); //stops dragging when you release the mouse
		
	}

	function dragStart(event:MouseEvent)
	{
		_imageContainer.startDrag();
	}
	
	function dragStop(event:MouseEvent)
	{
		_imageContainer.stopDrag();
	}
	
	public function getCopy(?attribute:Map < String, Dynamic>):ICustomEntity
	{
		var copiedCharacter = new Character(_kernel, _assetManager);
		copiedCharacter._characterImageData = _characterImageData;
		
		return new Character(_kernel, _assetManager);
	}
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here
		
		#if html5
			//Apparently debugging statements (including all variations of trace) don't work for HTML5, even in debug mode
			//still figuring out what to put here...
		#end
		
		//ignore these next commented out lines for now
		
/*		if (_kernel.inputs.mouse.getIsButtonDown())
		{
			_imageContainer.startDrag();
		}
		else
		{
			_imageContainer.stopDrag();
		}*/
		
		_xCoordinate = _imageContainer.x;
		_yCoordinate = _imageContainer.y;
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}