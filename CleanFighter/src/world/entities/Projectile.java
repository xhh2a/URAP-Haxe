package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

public class Projectile extends LivingObject {

	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static loader.Type LOADEDDATA;
	public HashMap<String, ArrayList<String>> affects;
	public LivingObject firedby;

	
	
}
