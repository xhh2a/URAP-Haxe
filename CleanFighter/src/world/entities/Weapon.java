package world.entities;

import java.util.HashMap;

import world.World;

import com.badlogic.gdx.math.Vector2;

public class Weapon {
	/** A HashMap of Weapon Types to their Type loaded JSON object. */
	public static HashMap<String, loader.Type> LOADEDDATA;
	
	public int reloadCounter = 0;
	
	public void update(){
		this.reloadCounter -= 1;
		
		if (this.triggerDown){
			if (this.reloadCounter <= 0){
				this.fire();
			}
		}
		
	}

	public void fire(){	
		World world = player.getWorld();
		Soap soap = new Soap();
		soap.setPosition(new Vector2(player.getPosition()));
		
		Vector2 force = new Vector2(300,0);
		soap.receiveForce(force);
		
		world.addProjectile(soap);
		this.reload();
	}
	
	public void reload(){
		reloadCounter = this.getReloadTime();
	}
	
	public abstract int getReloadTime();
	
	public void pullTrigger(){
		this.triggerDown = true;
	}
	
	public void releaseTrigger(){
		this.triggerDown = false;
	}
	
	
	
}
