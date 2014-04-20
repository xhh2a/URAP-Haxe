package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

public class Projectile extends LivingObject {

	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static loader.Type LOADEDDATA;
	protected float damage;

	/** A constructor for a predefined projectile in JSON. */
	public Projectile(loader.Variation data){
		super(data);
		if (data.floats.containsKey("damage")) {
			this.damage = data.floats.get("damage");
		}
	}

	/** A constructor for a generic projectile. */
	public Projectile(float amount) {
		this.damage = amount;
		this.type = "projectile";
		this.variation = "default";
	}

	/** A constructor for a non-loaded projectile. */
	public Projectile(float amount, String atype, String avariation) {
		this.damage = amount;
		this.type = atype;
		this.variation = avariation;
	}
	
	protected void resolveCollision(float t, LivingObject collidedwith) {
		collidedwith.receiveDamage(this.damage, this);
	}
	
}
