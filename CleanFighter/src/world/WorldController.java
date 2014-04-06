package world;

import java.util.HashMap;
import java.util.Map;

import com.badlogic.gdx.math.Vector2;

import world.entities.Player;



public class WorldController {
	World world;
	Player player;
	
	enum Keys {
		LEFT, RIGHT, UP, DOWN, FIRE
	}
	
	
	static Map<Keys, Boolean> keys = new HashMap<WorldController.Keys, Boolean>();
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
		keys.get(keys.put(Keys.LEFT, true));
	}
	
	public void rightPressed() {
		keys.get(keys.put(Keys.RIGHT, true));
	}
	
	public void upPressed() {
		keys.get(keys.put(Keys.UP, true));
	}
	
	public void downPressed() {
		keys.get(keys.put(Keys.DOWN, true));
	}
	
	public void firePressed() {
		keys.get(keys.put(Keys.FIRE, true));
	}
	
	public void leftReleased() {
		keys.get(keys.put(Keys.LEFT, false));
	}
	
	public void rightReleased() {
		keys.get(keys.put(Keys.RIGHT, false));
	}
	
	public void upReleased() {
		keys.get(keys.put(Keys.UP, false));
	}
	
	public void downReleased() {
		keys.get(keys.put(Keys.DOWN, false));
	}
	
	public void fireReleased() {
		keys.get(keys.put(Keys.FIRE, false));
	}
	
	/** The main update method **/
	public void update(float delta) {
		processInput();
		world.update(delta);
	}
	
	public void processInput(){
		
		/////////////////////////
		if (keys.get(Keys.LEFT) == true){
			this.player.addVelocity(new Vector2(-this.player.MAXSPEED,0));
		}
		if (keys.get(Keys.RIGHT) == true){
			this.player.addVelocity(new Vector2(this.player.MAXSPEED,0));
		}
		if (!(keys.get(Keys.RIGHT) || keys.get(Keys.LEFT))){
			this.player.getVelocity().x = 0;
		}
		//////////////////////////
		//////////////////////////
		if (keys.get(Keys.UP) == true){
			
			this.player.addVelocity(new Vector2(0,this.player.MAXSPEED));
		}
		if (keys.get(Keys.DOWN) == true){
			this.player.addVelocity(new Vector2(0,-this.player.MAXSPEED));
		} 
		
		if (!(keys.get(Keys.UP) || keys.get(Keys.DOWN))){
			this.player.getVelocity().y = 0;
		}
		///////////////////////////
		
		if (keys.get(Keys.FIRE)){
			this.player.pullTrigger();
		}
		
		if (!keys.get(Keys.FIRE)){
			this.player.releaseTrigger();
		}
		
		
	}
}
