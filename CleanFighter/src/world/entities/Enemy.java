package world.entities;

import java.util.ArrayList;
import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

public class Enemy extends LivingObject {
	/**
	 * Data loaded from JSON is stored here so it can be referenced without reloading.
	 */
	public static loader.Type LOADEDDATA;
	protected Weapon weapon;
	protected ArrayList<Behavior> behaviors;

	public Enemy(loader.Variation data) {
		super(data);
	}

	@Override
	public void update(float delta){
		super.update(delta); // Update Movement and damage check
		for(Behavior b: this.behaviors) {
			b.run(this);
		}
		this.weapon.update(delta);
	}

}
