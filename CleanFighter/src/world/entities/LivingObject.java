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
	
	public void receiveDamage(float d){
		this.health -= d;
		if (this.health<=0){
			this.destroy();
		}
	}
	
	public void destroy(){
		this.shouldExist = false;
		//TODO: Actually implement this and make the enemy leave the world
	}
	
}
