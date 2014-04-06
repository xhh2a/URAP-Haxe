package world.entities;

import java.util.HashMap;

import com.badlogic.gdx.utils.Json;

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
	 * Attributes for this object.
	 */
	public HashMap<String, Object> attributeMap;
	
	/**
	 * Attribute map can be null. Sort of like using Object ... params for varargs.
	 * @param health The starting hitpoints for this object
	 * @param isAlive Whether or not this object is alive.
	 */
	public LivingObject(HashMap<String, Object> attributeMap){
		super();
		if ((attributeMap != null) && attributeMap.containsKey("health")) {
			this.health = (float) attributeMap.get("health");
		}
		if ((attributeMap != null) && attributeMap.containsKey("isAlive")) {
			this.isAlive = (boolean) attributeMap.get("isAlive");
		}
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
