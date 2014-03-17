package world.entities;

import com.badlogic.gdx.math.Vector2;

public abstract class Enemy extends LivingObject {
	
	public abstract boolean isVulnerableTo(Projectile p);
	
}
