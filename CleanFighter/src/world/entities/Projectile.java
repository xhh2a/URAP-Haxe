package world.entities;

import java.util.ArrayList;
import world.World;
import java.util.HashMap;

public class Projectile extends LivingObject {

	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static HashMap<String, loader.Type> LOADEDDATA;
	/** Damage of this projectile. */
	protected float damage;
	/** Speed of this projectile at creation. */
	protected float spawnSpeed;

	/** A constructor for a predefined projectile in JSON. */
	public Projectile(loader.Variation data, World parent){
		super(data, parent);
		if (data != null) {
			if (data.floats.containsKey("damage")) {
				this.damage = data.floats.get("damage");
			}
			if (data.floats.containsKey("spawnSpeed")) {
				this.spawnSpeed = data.floats.get("spawnSpeed");
			}
		} else {
			System.err.println("[WARNING] Projectile Constructor called with null variation data.");
		}
	}

	/** A constructor for a generic projectile. */
	public Projectile(float amount, World parent) {
		super();
		this.damage = amount;
		this.type = "projectile";
		this.variation = "default";
		this.world = parent;
	}

	/** A constructor for a non-loaded projectile. ATYPE and AVARIATION and IMAGEPATH can be null, will use
	 *  defaults "projectile" and "default" and the null image. DAMAGEAMOUNT is used
	 *  to track damage. */
	public Projectile(float damageAmount, String atype, String avariation, String imagepath, World parent) {
		super();
		this.damage = damageAmount;
		this.type = (atype != null) ? atype : "projectile";
		this.variation = (avariation != null) ? avariation : "default";
		this.imageFile = imagepath;
		this.loadSprite();
		this.world = parent;
	}

	protected void resolveCollision(float t, LivingObject collidedwith) {
		collidedwith.receiveDamage(this.damage, this);
	}
	
}
