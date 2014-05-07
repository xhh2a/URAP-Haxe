package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import world.World;

import com.badlogic.gdx.math.Vector2;

/** A weapon class handles the creation of Projectiles. */
public class Weapon {
	/** A HashMap of Weapon Types to their Type loaded JSON object. */
	public static HashMap<String, loader.Type> LOADEDDATA;
	/** Whether the fire trigger is true or not */
	public boolean fire = false;
	/** Time remaining on reloading. */
	public float reloadCounter = 0;
	/** Time it takes to reload. */
	protected float reloadTime = 0;
	/** The parent object, required for access to world instance. */
	protected LivingObject parent;
	/** A string with the type of projectile. */
	protected String fireType;
	/** A string with the variation of the projectile. */
	protected String fireVariation;
	/** The damage of the projectile, used when type/variation is invalid. */
	protected float damage = 0;
	/** The speed of the projectile, used when type/variation is invalid. */
	protected float projectileSpeed = 0;
	/** The image file path for the projectile, used when type/variation is invalid. */
	protected String projectileImage;
	/** Used internally in fire() method, this is to cache and avoid duplicate lookups. */
	protected loader.Variation projectileVariation;
	//TODO: Potentially an image for the weapon for the GUI?

	/** Constructor for a given variation. Parent object PAR
	 *  which owns this must be passed in. */
	public Weapon(loader.Variation data, LivingObject par) {
		if (par == null) {
			System.err.println("[WARNING] Invalid Constructor call to Weapon, missing parent. Stacktrace: ");
			Thread.currentThread().dumpStack();
		}
		this.parent = par;
		if(data != null) {
			if (data.strings.containsKey("fireType")) {
				this.fireType = data.strings.get("fireType");
			}
			if (data.strings.containsKey("fireVariation")) {
				this.fireVariation = data.strings.get("fireVariation");
			}
			if (data.strings.containsKey("projectileImage")) {
				this.projectileImage = data.strings.get("projectileImage");
			}
			if (data.strings.containsKey("fireVariation")) {
				this.fireVariation = data.strings.get("fireVariation");
			}
			if (data.floats.containsKey("damage")) {
				this.damage = data.floats.get("damage");
			}
			if (data.floats.containsKey("reloadTime")) {
				this.reloadTime = data.floats.get("reloadTime");
			}
			if (data.floats.containsKey("projectileSpeed")) {
				this.projectileSpeed = data.floats.get("projectileSpeed");
			}
		}
		this.projectileVariation = lookupProjectile();
	}

	/** Constructor for a generic weapon. projectileImage PI can be null (will use
	 *  hardcoded null image). Damage D should not be null. 
	 *  Projectile speed PS should not be null.
	 *  PAR is the parent owner of this weapon.
	 */
	public Weapon(int d, int ps, String pi, LivingObject par) {
		this.damage = d;
		this.projectileSpeed = ps;
		this.projectileImage = pi;
		this.parent = par;
	}

	
	/**
	 * Update this weapon with time delta. NOTE that weapons should
	 * NOT be added to the list of instances since the parent object
	 * will call this update function.
	 */
	public void update(float delta){
		if ((this.reloadCounter > 0) && !this.fire) {
			this.reloadCounter = Math.max(this.reloadCounter - delta, 0);
		} else if (this.fire) {
			this.reloadCounter -= delta;
			while(this.reloadCounter <= 0){ //Fire all queued up.
				this.fire(-this.reloadCounter);
			}
		}
	}

	/**
	 * Internal use method. Looksup the Variation associated with the fireType and fireVariation.
	 */
	protected loader.Variation lookupProjectile() {
		if ((this.fireType != null) && (this.fireVariation != null)) {
			if (Projectile.LOADEDDATA.containsKey(this.fireType)) {
				return Projectile.LOADEDDATA.get(this.fireType).variations.get(this.fireVariation);
			}
		}
		return null;
	}

	/** 
	 * Fire the projectile, with time DELTA elapsed <i><b>since
	 * the projectile was supposed to have been fired!</b></i>
	 */
	public void fire(float delta){	
		World world = parent.world;
		Projectile output;
		float angle = parent.sprite.getRotation();
		Vector2 force;
		if (this.projectileVariation != null) {
			output = new Projectile(this.projectileVariation, this.parent.world);
			force = new Vector2(output.spawnSpeed, 0).rotate(angle);
		} else {
			output = new Projectile(this.damage, this.fireType, this.fireVariation, this.projectileImage, this.parent.world);
			force = new Vector2(this.projectileSpeed,0).rotate(angle);
		}
		output.receiveForce(force);
		output.position = new Vector2(parent.position);

		output.sprite.setRotation(angle);

		output.update(delta);
		world.addInstance(output);
		this.reload();
	}

	public void reload(){
		this.reloadCounter = Math.min(this.reloadCounter + this.reloadTime, this.reloadTime);
	}
	
}
