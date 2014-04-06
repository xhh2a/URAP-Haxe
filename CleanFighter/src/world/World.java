package world;

import java.util.HashMap;
import java.util.Iterator;

import com.badlogic.gdx.graphics.g2d.SpriteBatch;

import world.entities.*;

/**
 * A world contains information about the current game state.
 */
public class World {
	/** 
	 * This keeps track of all instances of non player objects in a two level HashMap.
	 * *First level is the Object Type
	 * *Second level is the Object Variation
	 */
	public HashMap<String, HashMap<String, LivingObject>> instances = new HashMap<String, HashMap<String, LivingObject>>();
	public Player player;

	/**
	 * Constructor for a new world, creates a player object.
	 */
	public World(){
		this.player = new Player();
		this.player.world = this;
	}

	/**
	 * Iteratively calls update on all instance objects.
	 * @param delta The time difference since the last update.
	 */
	public void update(float delta){
		this.player.update(delta);
		//We want to use an iterator to avoid concurrent modification exceptions.
		Iterator<HashMap<String, LivingObject>> iiter = instances.values().iterator();
		while (iiter.hasNext()) {
			Iterator<LivingObject> jiter = iiter.next().values().iterator();
			while (jiter.hasNext()) {
				LivingObject lo = jiter.next();
				//Each LivingObject's Update function will handle updates!
				lo.update(delta);
				if (!lo.shouldExist) {
					jiter.remove();
				}
			}
		}
	}

	/**
	 * Calls spritebatch.draw() on protected variables of the PhysObject.
	 */
	public void drawSelf(SpriteBatch spritebatch){
		Iterator<HashMap<String, LivingObject>> iiter = instances.values().iterator();
		while (iiter.hasNext()) {
			Iterator<LivingObject> jiter = iiter.next().values().iterator();
			while (jiter.hasNext()) {
				LivingObject lo = jiter.next();
				lo.drawSelf(spritebatch);
			}
		}
		player.drawSelf(spritebatch);
	}

	/**
	 * Adds a LIVINGOBJECT to the instances list.
	 * @param livingObject What to add.
	 * @return True on success, false otherwise.
	 * @param type Required to be in the attribute map.
	 * @param variation Required to be in the attribute map.
	 */
	public boolean addInstance(LivingObject livingObject) {
		if (livingObject.attributeMap.containsKey("type") && livingObject.attributeMap.containsKey("variation")) {
			this.instances.get((String) livingObject.attributeMap.get("type"));
			livingObject.world = this;
			return true;
		}
		livingObject.world = this;
		return false;
	}
}
