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
	public int reloadCounter = 0;
	/** The parent object, required for access to world instance. */
	protected LivingObject parent;
	/** A string with the type of projectile. */
	protected String fireType;
	/** A string with the variation of the projectile. */
	protected String fireVariation;
	/** The damage of the projectile, used when type/variation is empty. */
	protected int damage = 0;
	/** The image file path for the projectile, used when type/variation is empty. */
	protected String projectileImage;
	//TODO: Potentially an image for the weapon for the GUI?

	/** Constructor for a given variation. */
	public Weapon(loader.Variation data) {
		if(data != null) {
			//TODO
		}
	}

	/** Constructor for a generic weapon. projectileImage PI can be null (will use
	 *  hardcoded null image). damage D should not be null.
	 */
	public Weapon(int d, String pi) {
		this.damage = d;
		this.projectileImage = pi;
	}

	
	/**
	 * Update this weapon with time delta. NOTE that weapons should
	 * NOT be added to the list of instances since the parent object
	 * will call this update function.
	 */
	public void update(float delta){
		this.reloadCounter -= delta; //TODO: Proper reload check	
		if (this.fire){
			if (this.reloadCounter <= 0){
				this.fire();
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

	public void fire(){	
		World world = parent.world;
		Projectile output;
		loader.Variation t = lookupProjectile();
		if (t != null) {
			output = new Projectile(t);
		} else {
			output = new Projectile(this.damage, this.fireType, this.fireVariation, this.projectileImage);
		}
		output.position = new Vector2(parent.position);
		
		Vector2 force = new Vector2(300,0); //TODO: Remove this and replace with JSON stuff
		output.receiveForce(force);
		
		world.addInstance(output);
		this.reload(); //This should be defined
	}

	public void reload(){
		return; //TODO: Actually do.
	}
	
}
