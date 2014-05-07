package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import world.behavior.Behavior;


/**
 * The base class for all objects.
 */
public class LivingObject extends PhysObject {
	/**
	 * Defaults to 20f.
	 */
	public float health = 20f;
	
	/**
	 * The string representation of the type of LivingObject that this will spawn.
	 * Used by the spawn behavior
	 */
	public String spawnType;
	/**
	 * Damage on the stack.
	 */
	private float damageStack = 0;

	/**
	 * Whether or not this object is alive.
	 */
	public boolean isAlive = true;

	/**
	 * What type of object this is.
	 */
	public String type;
	/**
	 * What variation of the object this is.
	 */
	public String variation;

	/**
	 * List of things to check on collision.
	 * If the TYPE keyword "all" is present, then other TYPES will be IGNORED. It will check ALL
	 * instances.
	 * If the VARIATION keyword "all" is present, then it will check all variations.
	 */
	public HashMap<String, ArrayList<String>> affects = new HashMap<String, ArrayList<String>>();

	/**
	 * A list of behaviors for this object.
	 */
	protected ArrayList<Behavior> behaviors = new ArrayList<Behavior>();


	/**
	 * This is the constructor that should be used!
	 * This handles PhysObject variable updates.
	 * The reason for doing so here is because PhysObject is also used
	 * when calculating if things will intercept and thus
	 * we split the attributes off to avoid unnecessary overhead.
	 */
	public LivingObject(loader.Variation data){
		super();
		if (data != null) {
			if (data.type != null) {
				this.type = data.type;
			} else {
				System.err.println("[WARNING] Missing type in JSON data. Stacktrace: ");
				Thread.currentThread().dumpStack();
			}
			if (data.variation != null) {
				this.variation = data.variation;
			} else {
				System.err.println("[WARNING] Missing variation in JSON data. Stacktrace: ");
				Thread.currentThread().dumpStack();
			}
			if (data.floats.containsKey("health")) {
				this.health = data.floats.get("health");
			}
			if (data.strings.containsKey("imageFile")) {
				this.imageFile = data.strings.get("imageFile");
				this.loadSprite();
			}
			if (data.floats.containsKey("mass")) {
				this.mass = data.floats.get("mass");
			}
			if (data.data.containsKey("behaviors")) {
				for (String b : (ArrayList<String>) data.data.get("behaviors")) {
					
					Behavior res = this.world.installedbehaviors.get(b);
					if (res != null) {
						this.behaviors.add(res);
					} else {
						System.err.println("[WARNING] Behavior requested in object is not installed in the world. Stacktrace:");
						Thread.currentThread().dumpStack();
					}
				}
			}
			if (data.data.containsKey("affects")) {
				this.affects = (HashMap<String, ArrayList<String>>) data.data.get("affects");
			}
		}
	}

	/**
	 * Apparently required for static variables.
	 */
	public LivingObject() {
		super();
	}

	/** Adds damage D to the stack from a given SOURCE*/
	public void receiveDamage(float d, LivingObject source){
		this.damageStack += lookupDamageModifiers(d);
	}

	/** This calculates the damage to put on the stack. */
	protected float lookupDamageModifiers(float i) {
		return i; //TODO Actually look up modifiers
	}

	/** Resolves damage on the stack. T is time passed since last update
	 *  this is currently ignored, but may be used in the future for
	 *  poison or something
	 */
	protected void resolveDamage(float t) {
		this.health -= this.damageStack; //TODO Do more than just remove health from stack.
		this.damageStack = 0;
		if (this.health <= 0) {
			this.destroy();
		}
	}

	/**
	 * Action on every update that checks for collisions in the list of things
	 * this object affects. Calls resolveCollision. Ideally
	 * this method does not need to be overridden, unless you want it
	 * to be a no-op.
	 * 
	 * If you want to check for if there is a collision between two objects,
	 * use PhysObject.intersects.
	 * @param t Time delta
	 */
	protected void checkCollision(float t) {
		if (this.affects.containsKey("all")) {
			for (HashMap<String, ArrayList<LivingObject>> atype: world.instances.values()) {
				for (ArrayList<LivingObject> avalue: atype.values()) {
					for (LivingObject entry: avalue) {
						if ((this != entry) && (this.intersects(entry))) {
							this.resolveCollision(t, entry);
						}
					}
				}
			}
		} else {
			for(String atype: this.affects.keySet()) {
				if (world.instances.containsKey(atype)) {
					checkCollisionHelper(t, atype);
				}
			}
		}
		return;
	}

	private void checkCollisionHelper(float t, String atype) {
		if (this.affects.get(atype).contains("all")) {
			for (ArrayList<LivingObject> typelist: world.instances.get(atype).values()) {
				for (LivingObject entry: typelist) {
					if ((this != entry) && (this.intersects(entry))) {
						this.resolveCollision(t, entry);
					}
				}
			}
		} else {
			for (String avalue: this.affects.get(atype)) {
				for (LivingObject entry: world.instances.get(atype).get(avalue)) {
					if ((this != entry) && (this.intersects(entry))) {
						this.resolveCollision(t, entry);
					}
				}
			}
		}
	}

	/**
	 * Method called to resolve a collision, should be overridden.
	 * Note that this instance should not be removed from the list of
	 * instances to avoid concurrent access errors. Instead, destroy()
	 * should be called. The World will take care of removing this from
	 * the list of instances.
	 * @param t Time delta
	 * @param collidedwith object we have a collision with.
	 */
	protected void resolveCollision(float t, LivingObject collidedwith) {
		return;
	}

	@Override
	/** Common update behavior. */
	public void update(float delta){
		super.update(delta); //Resolve movement.
		for(Behavior b: this.behaviors) {
			b.run(this);
		}
		this.resolveDamage(delta); //Resolve damage.
		this.checkCollision(delta); //Check for collisions.
	}

	/** Destroy this object. This should not
	 *  remove itself from world.instances, the world will do so using
	 *  iter.remove. Removing itself from world.instances will result in
	 *  concurrent access exceptions. */
	public void destroy(){
		this.shouldExist = false;
		//TODO: Actually implement this and make the enemy leave the world
	}


}
