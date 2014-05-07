package world.behavior;

import world.entities.LivingObject;

import com.badlogic.gdx.math.Vector2;

public class MaintainHeightWobble extends Behavior {

	@Override
	public void run(LivingObject caller) {
		if (caller.velocity.y < -10){
			caller.receiveForce(new Vector2(0,10));
		}

	}

}
