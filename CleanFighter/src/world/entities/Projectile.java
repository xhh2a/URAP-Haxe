package world.entities;

import com.badlogic.gdx.math.Vector2;

public class Projectile extends PhysObject {
	
	public float getMaxSpeed(){
		return 200;
	}
	
	public void hit(Enemy badGuy){
		/**
		 * @param: badguy is just any sort of enemy
		 */
		//TODO: Fix this
		//this.collide(badGuy);
		
		//TODO: do this properly
		this.setPosition(new Vector2(0,-300));
		if (badGuy.isVulnerableTo(this)){
			badGuy.receiveDamage(this.getDamageAbility());
		}
	}
	
	public float getDamageAbility(){
		return 10f;
	}
	
	
}
