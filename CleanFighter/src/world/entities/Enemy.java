package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

public class Enemy extends LivingObject {
	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static HashMap<String, loader.Type> LOADEDDATA;
	protected Weapon weapon;

	@Override
	public void update(float delta){
		super.update(delta); // Update Movement and damage check
		this.weapon.update(delta);
	}

}
