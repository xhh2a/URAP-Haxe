package world.entities;

import com.badlogic.gdx.math.Vector2;

import world.World;

public class Player extends LivingObject {
	
	private Weapon weapon;
	
	public Player(){
		this.weapon = new SoapShooter(this);
	}
	
	public String getImageName(){
		return "ondaboat.gif";
	}
	
	public void pullTrigger(){
		weapon.pullTrigger();
	}
	
	public void releaseTrigger(){
		weapon.releaseTrigger();
	}
	
	
	public void update(float delta){
		super.update(delta);
		this.weapon.update();
		
	}
	
	

}
