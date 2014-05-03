package world.entities;

import loader.Type;

import com.badlogic.gdx.math.Vector2;

import world.World;

public class Player extends LivingObject {
	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static loader.Type LOADEDDATA;
	/** Change in speed on input */
	public float speed = 25f;
	public float maxJumpHeight = 10.0f;
	public float currJumpHeight = 0.0f;
	public boolean isFalling = false;
	protected Weapon weapon;
	public World myWorld;

	public Player(loader.Variation data, World theWorld){
		super(data);
		if (data.floats.containsKey("speed")) {
			this.speed = data.floats.get("speed");
		}
		if (data.floats.containsKey("jumpHeight")) {
			this.maxJumpHeight = data.floats.get("jumpHeight");
		}
		if (data.strings.containsKey("weaponType")) {
			String variation = "default";
			if (data.strings.containsKey("weaponVariation")) {
				variation = data.strings.get("weaponVariation");
			}
			this.weapon = new Weapon(Weapon.LOADEDDATA.get(data.strings.get("weaponType")).variations.get(variation), this);
		}
		myWorld = theWorld;
	}
	
	/**
	 * Makes this Player fall until the ground is reached
	 */
	public void fall() {
		Vector2 res = Vector2.Zero.cpy();
		//here we're assuming the ground is at the bottom of the screen;
		//might change this later
		if (this.position.y == this.myWorld.ground)
		{
			isFalling = false;
		}
		if (isFalling)
		{
			System.out.println("here");
			res.add(new Vector2(0,-this.speed));
			this.setVelocity(res);
		}

	}
	
	
	
	/**
	 * Method to call when the player is pressing the fire button.
	 */
	public void pullTrigger(){
		this.weapon.fire = true;
	}

	/**
	 * Method to call when the player has released the fire button.
	 */
	public void releaseTrigger(){
		this.weapon.fire = false;
	}

	@Override
	public void update(float delta) {
		super.update(delta);
		this.weapon.update(delta);
		//this.fall();
	}
	
	@Override
	/** No-op, should be handled by enemy and projectile to avoid double checking. */
	protected void checkCollision(float t) {
		return;
	}

}
