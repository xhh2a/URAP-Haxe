package world.entities;

public class LivingObject extends PhysObject {
	private float health;
	private boolean isAlive;
	
	public LivingObject(){
		super();
		this.health = this.getMaxHealth();
		this.isAlive = true;
	}
	
	public LivingObject(float health){
		this.health = health;
		this.isAlive = true;
	}
	
	public void setHealth(float h){
		this.health = h;
	}
	
	public float getHealth(){
		return this.health;
	}
	
	public boolean isAlive(){
		return this.isAlive;
	}
	
	public void receiveDamage(float d){
		this.setHealth(this.getHealth()-d);
		if (this.getHealth()<=0){
			this.die();
		}
	}
	
	public void die(){
		this.shouldExist = false;
		//TODO: Actually implement this and make the enemy leave the world
	}
	
	public float getMaxHealth(){
		return 20f;
	}
	
}
