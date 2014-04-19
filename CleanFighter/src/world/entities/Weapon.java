package world.entities;

import java.util.HashMap;

import world.World;

import com.badlogic.gdx.math.Vector2;

public class Weapon {
	/** A HashMap of Weapon Types to their Type loaded JSON object. */
	public static HashMap<String, loader.Type> LOADEDDATA;
	public boolean fire = false;
	public int reloadCounter = 0;
	protected LivingObject parent;
	protected String fireType;
	protected String fireInstance;
	
	public void update(float delta){
		this.reloadCounter -= delta; //TODO: Proper reload check	
		if (this.fire){
			if (this.reloadCounter <= 0){
				this.fire();
			}
		}

	}

	public void fire(){	
		World world = parent.world;
		Projectile output = new Projectile();
		output.position = new Vector2(parent.position);
		
		Vector2 force = new Vector2(300,0); //TODO: Remove this and replace with JSON stuff
		output.receiveForce(force);
		
		world.addInstance(output);
		this.reload();
	}
	
	public void reload(){
		return; //TODO: Actually do.
	}
	
}
