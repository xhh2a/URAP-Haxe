package world;

import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

import world.entities.Player;



public class WorldController {
	World world;
	Player player;

	enum Keys {
		LEFT, RIGHT, UP, DOWN, FIRE
	}
	
	
	static HashMap<Keys, Boolean> keys = new HashMap<WorldController.Keys, Boolean>();
	static {
		keys.put(Keys.LEFT, false);
		keys.put(Keys.RIGHT, false);
		keys.put(Keys.UP, false);
		keys.put(Keys.DOWN, false);
		keys.put(Keys.FIRE, false);
	};
	
	public WorldController(World world) {
		this.world = world;
		this.player = world.player;
	}

	// ** Key presses and touches **************** //
	
	public void leftPressed() {
		keys.put(Keys.LEFT, true);
	}

	public void rightPressed() {
		keys.put(Keys.RIGHT, true);
	}
	
	public void upPressed() {
		keys.put(Keys.UP, true);
	}

	public void downPressed() {
		keys.put(Keys.DOWN, true);
	}

	public void firePressed() {
		keys.put(Keys.FIRE, true);
	}

	public void leftReleased() {
		keys.put(Keys.LEFT, false);
	}

	public void rightReleased() {
		keys.put(Keys.RIGHT, false);
	}

	public void upReleased() {
		keys.put(Keys.UP, false);
	}
	
	public void downReleased() {
		keys.put(Keys.DOWN, false);
	}
	
	public void fireReleased() {
		keys.put(Keys.FIRE, false);
	}
	
	/** The main update method **/
	public void update(float delta) {
		processInput();
		world.update(delta);
	}

	public void processInput(){
		this.player.setVelocity(Vector2.Zero.cpy());
		Vector2 res = Vector2.Zero.cpy();
		/////////////////////////
		if (keys.get(Keys.LEFT)){
			res.add(new Vector2(-this.player.speed,0));
		}
		if (keys.get(Keys.RIGHT)){
			res.add(new Vector2(this.player.speed,0));
		}
		//////////////////////////
		if (keys.get(Keys.UP)){
			res.add(new Vector2(0,this.player.speed));
		}
		if (keys.get(Keys.DOWN)){
			res.add(new Vector2(0,-this.player.speed));
		}
		System.out.println(keys);
		this.player.setVelocity(res);


		///////////////////////////
		//TODO: Move this directly to the release/pressed areas to avoid duplicate calls.
		if (keys.get(Keys.FIRE)){
			this.player.pullTrigger();
		}
		
		if (!keys.get(Keys.FIRE)){
			this.player.releaseTrigger();
		}

	}
}
