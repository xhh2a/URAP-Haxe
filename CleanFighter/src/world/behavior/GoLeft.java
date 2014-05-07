package world.behavior;

import world.entities.LivingObject;

import com.badlogic.gdx.math.Vector2;

public class GoLeft extends Behavior {

	@Override
	public void run(LivingObject caller) {
		if (caller.velocity.x > -100){
			caller.receiveForce(new Vector2(-10,0));
		}

	}

}
