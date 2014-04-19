package world.entities;


/**
 * The base class for all objects.
 */
public class LivingObject extends PhysObject {
	/**
	 * Defaults to 20f.
	 */
	public float health = 20f;

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
			}
			if (data.variation != null) {
				this.variation = data.variation;
			}
			if (data.floats.containsKey("health")) {
				this.health = data.floats.get("health");
			}
			if (data.strings.containsKey("imageFile")) {
				this.imageFile = data.strings.get("imageFile");
				this.loadTexture();
			}
			if (data.floats.containsKey("mass")) {
				this.mass = data.floats.get("mass");
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
	public void receiveDamage(float d, Projectile source){
		this.damageStack += _lookupDamageModifiers(d);
	}

	/** This calculates the damage to put on the stack. */
	protected float _lookupDamageModifiers(float i) {
		return i; //TODO Actually look up modifiers
	}

	/** Resolves damage on the stack. T is time passed since last update
	 *  this is currently ignored, but may be used in the future for
	 *  poison or something
	 */
	protected void _resolveDamage(float t) {
		this.health -= this.damageStack; //TODO Do more than just remove health from stack.
		this.damageStack = 0;
		if (this.health <= 0) {
			this.destroy();
		}
	}

	/** Common update behavior. */
	public void update(float delta){
		super.update(delta); //Resolve movement.
		this._resolveDamage(delta); //Resolve damage.
	}

	/** Destroy this object. */
	public void destroy(){
		this.shouldExist = false;
		//TODO: Actually implement this and make the enemy leave the world
	}
	
}
