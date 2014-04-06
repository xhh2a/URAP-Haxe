package world.entities;

import loader.Type;

import com.badlogic.gdx.math.Vector2;

import world.World;

public class Player extends LivingObject {
	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static loader.Type LOADEDDATA;

	private Weapon weapon;

	public Player(loader.Variation data){
		super(data);
		this.weapon = null; //TODO
	}

	public String getImageName(){
		return "ondaboat.gif";
	}

	// TODO: This needs to check for time delta.
	public void pullTrigger(){
		//weapon.pullTrigger();
	}
	
	public void releaseTrigger(){
		//weapon.releaseTrigger();
	}
	
	
	public void update(float delta){
		super.update(delta);
		//this.weapon.update();
		
	}
	
	

}
