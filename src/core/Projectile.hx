package core;

import awe6.core.Entity;
import awe6.interfaces.IKernel;

import XmlLoader;
import ICustomEntity;
import Utils;

import flash.display.Bitmap;

import awe6.core.Context;

/**
 * @attribute
 * 'affects' Map<String, String>, Map<Type, Variant>, defined via <affects type="variant;variant2;variant3;variantN"/>
 */
class Projectile extends Character {

	public function new (p_kernel:IKernel, assetManager:AssetManager,
						 ?xCoordinate:Float, ?yCoordinate:Float) {
		// TODO: what if the optional param is not provided
		// instance variable defaults to be initialized?
		if (p_kernel == null || assetManager == null)
			throw "Invalid Argument Exception at Projectile.new";
		super (p_kernel, assetManager, xCoordinate, yCoordinate);
	}

	override private function _generateCollisionFilter(): Void {
		var output:Map < String, List<String> > = new Map < String, List<String> > ();
		if (_attribute.get('affects').exists('player')) {
			var templist:List<String> = new List<String>();
			templist.add('all');
			output.set('player', templist);
		} else {
			var typelist: Map<String, String> = _attribute.get('affects');
			for (type in typelist.keys()) {
				var templist:List<String> = Utils.arrayToList(_attribute.get('affects').get(type).split(';'));
				output.set(type, templist);
			}
		}
		_collisionFilter = output;
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

	override private function _moveFunction(p_deltaTime:Int = 0):Void {
		var func_x: String, func_y: String;
		var pos_x: Int, pos_y: Int;
		func_x = _attribute.get("xMovement");
		func_y = _attribute.get("yMovement");
        func_x = func_x.split("$1").join(Std.string(p_deltaTime));
        func_y = func_y.split("$1").join(Std.string(p_deltaTime));
		//pos_x = Context.parse(func_x, Context.currentPos());
        //pos_y = Context.parse(func_y, Context.currentPos());
        //setSpeed(pos_x - _xCoordinate, pos_y - _yCoordinate);
	}
    override public function addDamage(damageAmount:Float, source:Character):Void
    {
		throw "addDamage should not be called on a Projectile instance";
	}

	override private function _updateHealth():Void
	{
		return;
	}

	override public function shouldFire():Bool {
		return false;
	}

	override private function _fireFunction():Void {
		throw "fireFunction should not be called on a Projectile instance";
	}

	override private function _onCollision(collisions: List<Character>): Void {
		for (hitObject in collisions.iterator()) {
			// contains method for List?
			if (Lambda.has(_attribute.get("affects"), hitObject._attribute.get('type'))) {
				var damage: Int = _attribute.get("damage");
                // damage *= multipliers.get('damage').get(this.type);
                // damage *= multipliers.get('damage').get('global');
                // damage += additive.get('damage').get(this.type);
                //hitObject.resolveDamage(damage);
			}
		}
	}

}
