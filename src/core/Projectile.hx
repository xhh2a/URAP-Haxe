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
						 ?xCoordinate:Float, ?yCoordinate:Float, ?attribute:Map<String, Dynamic>, ?isTemplate:Bool) {
		if (p_kernel == null || assetManager == null) {
			throw "Invalid Argument Exception at Projectile.new";
		}
		super (p_kernel, assetManager, xCoordinate, yCoordinate, attribute, isTemplate);
	}

	override private function _generateCollisionFilter(): Void {
		var output:Map < String, List<String> > = new Map < String, List<String> > ();
		if (_attribute.get('affects').exists('player')) {
			var templist:List<String> = new List<String>();
			templist.add('all');
			output.set('player', templist);
		} else {
			var typemap: Map<String, String> = _attribute.get('affects');
			for (type in typemap.keys()) {
				if (type != 'player') {
					var templist:List<String> = Utils.arrayToList(_attribute.get('affects').get(type).split(';'));
					output.set(type, templist);
				}
			}
		}
		_collisionFilter = output;
	}

	override public function getCopy(?attribute:Map<String, Dynamic>, ?char:ICustomEntity):ICustomEntity {
		var copiedProjectile:Projectile;
		if (char == null) {
			copiedProjectile = new core.Projectile(_kernel, _assetManager, isTemplate = false);
		} else {
			copiedProjectile = cast(char, Projectile);
		}
		copiedProjectile = cast(super.getCopy(attribute, copiedProjectile), Projectile);
		copiedProjectile.updateAttributes();
		return copiedProjectile;
	}

    override public function addDamage(damageAmount:Float, source:Character):Void
    {
		throw "addDamage should not be called on a Projectile instance";
	}

	override private function _updateHealth():Void
	{
		return;
	}

	override public function shouldFire(p_deltaTime:Int=0):Bool {
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
