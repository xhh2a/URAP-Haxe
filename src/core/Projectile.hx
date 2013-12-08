package core;

import awe6.core.Entity;
import awe6.interfaces.IKernel;
import ICustomEntity;
import XmlLoader;

import haxe.macro.Context;

class Projectile extends Character {

	// // private fields
	// public var _damage: Int;
	// // Array compatibility
	// public var _affectTypes: Array<String>;
	// public var _xMovement: Null<String>;
	// public var _yMovement: Null<String>;

	// pasted here as reference
	// public var _attribute:Map<String, Dynamic>; 
	// public var _type:String; 
	// public var _variationId:String; 
	// public var _loadedXmlInfo:Map<String,Map<String,Map<String,Dynamic>>>;
	
	// public var _assetManager:AssetManager;
	// public var _fileDirectory:Null<String>; 
	// public var _fileName:Null<String>;
	
	// public var _imageContainer:Sprite; 
	// public var _characterImage:Bitmap; 
	// public var _characterImageData:BitmapData; 
	
	// public var _xCoordinate:Null<Int>;
	// public var _yCoordinate:Null<Int>;
	
	// public var _speedX:Int;
	// public var _speedY:Int;

	public function new (p_kernel:IKernel, assetManager:AssetManager, 
						 ?fileDirectory:String, ?fileName:String, 
						 ?xCoordinate:Int, ?yCoordinate:Int) {
		// TODO: coordinate in float? or int?
		// TODO: what if the optional param is not provided
		// TODO: how super works?
		// instance variable defaults to be initialized?
		if (IKernel == null || assetManager == null)
			throw "Invalid Argument Exception at Projectile.new"
		super (p_kernel, _imageContainer, fileDirectory, fileName, xCoordinate);
	}

	// override private function _init():Void {
	// 	super._init();

	// 	// _attribute should be initialized by super
	// 	if (_attribute != null) {
	// 		_damage = _attribute.get("damage");
	// 		_xMovement = _attribute.get("xMovement");
	// 		_yMovement = _attribute.get("yMovement");
	// 		// TODO: compatibility String.split
	// 		_affectTypes = _attribute.get("affects").split(",");
	// 	}
	// }

	override public function checkCollision(): List<Character> {
		var collision: List<Character> = super.checkCollision();

		// remove any projectile from the collision list
		// TODO: grammar check
		return collision.filter(
			function(in: Character): Bool {return in._type.equals("Projectile");}
		);
	}

	override public function getCopy(?attribute:Map<String, Dynamic>):ICustomEntity {
		var copiedCharacter = new Projectile(_kernel, _assetManager);

		// don't know if the copy-and-paste can be avoided
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

	override private function _updater (p_deltaTime:Int = 0):Void {
		// calculate the pseudo-speed of this projectile
		var func_x: String, func_y: String;
		var pos_x: Int, pos_y: Int;
		// func_x = new String(_xMovement);
		// func_y = new String(_yMovement);
		func_x = _attribute.get("xMovement");
		func_y = _attribute.get("yMovement");
        func_x.split("$1").join(String(p_deltaTime));
        func_y.split("$1").join(String(p_deltaTime));
        // TODO: how to make parse works
        pos_x = cast(Context.parse(func_x, Context.currentPos(), Int);
        pos_y = cast(Context.parse(func_y, Context.currentPos(), Int);
        setSpeed(pos_x - _xCoordinate, pos_y - _yCoordinate);

        // use the super method to complete the update
        super._updater(p_deltaTime);
	}

	// TODO: where is the resolveDamage function in Character?
	override public function resolveDamage(damage: Int): Void {
		throw "resolveDamage should not be called on a Projectile instance";
	}

	// TODO: where is the onCollide function in Character?
	override private function onCollide(collisions: List<Character>): Void {
		for (hitObject in collisions.elements()) {
			// contains method for List?
			if (_attribute.get("affects").contains(hitObject._type)) {
				var damage: Int = _attribute.get("damage");
                // damage *= multipliers.get('damage').get(this.type);
                // damage *= multipliers.get('damage').get('global');
                // damage += additive.get('damage').get(this.type);
                hitObject.resolveDamage(damage);
			}
		}
	}

}
