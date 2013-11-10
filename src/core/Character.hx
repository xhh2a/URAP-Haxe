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

/**
 * ...
 * @author Kevin
 */
	
class Character extends Entity implements ICustomEntity
{		
	public var _attribute: Map<String, Dynamic>;
	public var _type:String;
	
	var _assetManager:AssetManager;
	var _fileDirectory:Null<String>;
	var _fileName:Null<String>;
	
	var _imageContainer:Sprite;
	var _characterImage:Null<Bitmap>;
	var _characterImageData:Null<BitmapData>;
	
	var _xCoordinate:Null<Float>;
	var _yCoordinate:Null<Float>;
	
	public function new( p_kernel:IKernel, assetManager:AssetManager, ?fileDirectory:String, ?fileName:String, ?characterImageData:BitmapData, ?xCoordinate:Float, ?yCoordinate:Float ) 
	{
		_imageContainer = new Sprite();
		
		_assetManager = assetManager;
		
		_fileDirectory = fileDirectory;
		_fileName = fileName;
		

		_characterImageData = characterImageData;
		

		_xCoordinate = xCoordinate;
		_yCoordinate = yCoordinate;
		
		super( p_kernel, _imageContainer );
	}
	
	override private function _init():Void 
	{
		super._init();
		// extend here
		
		if (_fileDirectory != null && _fileName != null)
		{
			var result:Map<String, Map<String, Map<String, Dynamic>>> = XmlLoader.loadFile(_fileDirectory, _fileName, _assetManager);
			_attribute = result.get("Circle").get("Placeholder");
			_characterImageData = _assetManager.getAsset(_attribute.get("fileName"), _attribute.get("fileDirectory"));
		}
		
		
		_characterImage = new Bitmap(_characterImageData);
		_imageContainer.addChild(_characterImage);
		_imageContainer.x = _xCoordinate;
		_imageContainer.y = _yCoordinate;
		
		_imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
		_imageContainer.addEventListener(MouseEvent.MOUSE_UP, dragStop);
		
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
		return new Character(_kernel, _assetManager);
	}
	
	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// extend here
		
	
		_xCoordinate = _imageContainer.x;
		_yCoordinate = _imageContainer.y;
		
	}
	
	override private function _disposer():Void 
	{
		// extend here
		super._disposer();		
	}
	
}