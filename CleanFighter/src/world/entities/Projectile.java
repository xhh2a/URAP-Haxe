package world.entities;

import java.util.HashMap;

public class Projectile extends LivingObject {

	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static HashMap<String, loader.Type> LOADEDDATA;
	protected float damage;

	/** A constructor for a predefined projectile in JSON. */
	public Projectile(loader.Variation data){
		super(data);
		if (data != null) {
			if (data.floats.containsKey("damage")) {
				this.damage = data.floats.get("damage");
			}
		} else {
			System.err.println("[WARNING] Projectile Constructor called with null variation data.");
		}
	}

	/** A constructor for a generic projectile. */
	public Projectile(float amount) {
		super();
		this.damage = amount;
		this.type = "projectile";
		this.variation = "default";
	}

	/** A constructor for a non-loaded projectile. ATYPE and AVARIATION and IMAGEPATH can be null, will use
	 *  defaults "projectile" and "default" and the null image. */
	public Projectile(float amount, String atype, String avariation, String imagepath) {
		super();
		this.damage = amount;
		this.type = (atype != null) ? atype : "projectile";
		this.variation = (avariation != null) ? avariation : "default";
		this.imageFile = imagepath;
		this.loadSprite();
	}

	protected void resolveCollision(float t, LivingObject collidedwith) {
		collidedwith.receiveDamage(this.damage, this);
	}
	
}
