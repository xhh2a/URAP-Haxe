package core;

import awe6.core.Entity;
import awe6.interfaces.IKernel;

import XmlLoader;
import ICustomEntity;

import flash.display.Bitmap;

import awe6.core.Context;

class Projectile extends Character {

	public function new (p_kernel:IKernel, assetManager:AssetManager,
						 ?xCoordinate:Float, ?yCoordinate:Float) {
		// TODO: what if the optional param is not provided
		// instance variable defaults to be initialized?
		if (p_kernel == null || assetManager == null)
			throw "Invalid Argument Exception at Projectile.new";
		super (p_kernel, assetManager, xCoordinate, yCoordinate);
	}

	override public function checkCollision(?types:Map < String, List<String> > ): List<Character> {
		//TODO: This function no longer valid.
		/**
		var collision: List<Character> = super.checkCollision();

		// remove any projectile from the collision list
		// TODO: grammar check
		return collision.filter(
			function(aCharacter: Character): Bool {return aCharacter._attribute.get('type') =="Projectile";}
		);
		*/
		return null;
	}

	override public function getCopy(?attribute:Map<String, Dynamic>, ?char:ICustomEntity):ICustomEntity {
		var copiedProjectile:Projectile;
		if (char == null) {
			copiedProjectile = new core.Projectile(_kernel, _assetManager);
		} else {
			copiedProjectile = cast(char, Projectile);
		}
		copiedProjectile = cast(super.getCopy(attribute, copiedProjectile), Projectile);
		copiedProjectile.updateAttributes();
		return copiedProjectile;
	}

	override private function _updater (p_deltaTime:Int = 0):Void {
		// calculate the pseudo-speed of this projectile
		var func_x: String, func_y: String;
		var pos_x: Int, pos_y: Int;
		// func_x = new String(_xMovement);
		// func_y = new String(_yMovement);
		func_x = _attribute.get("xMovement");
		func_y = _attribute.get("yMovement");
        func_x = func_x.split("$1").join(Std.string(p_deltaTime));
        func_y = func_y.split("$1").join(Std.string(p_deltaTime));
        // TODO: how to make parse works
        //pos_x = Context.parse(func_x, Context.currentPos());
        //pos_y = Context.parse(func_y, Context.currentPos());
        //setSpeed(pos_x - _xCoordinate, pos_y - _yCoordinate);

        // use the super method to complete the update
        super._updater(p_deltaTime);
	}

	// TODO: where is the resolveDamage function in Character?
	/*override public function resolveDamage(damage: Int): Void {
		throw "resolveDamage should not be called on a Projectile instance";
	}*/

	// TODO: where is the onCollide function in Character?
	private function onCollide(collisions: List<Character>): Void {
		for (hitObject in collisions.iterator()) {
			// contains method for List?
			if (_attribute.get("affects").contains(hitObject._attribute.get('type'))) {
				var damage: Int = _attribute.get("damage");
                // damage *= multipliers.get('damage').get(this.type);
                // damage *= multipliers.get('damage').get('global');
                // damage += additive.get('damage').get(this.type);
                //hitObject.resolveDamage(damage);
			}
		}
	}

}
