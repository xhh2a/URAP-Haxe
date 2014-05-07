package world.behavior;

import com.badlogic.gdx.math.Vector2;

import world.World;
import world.entities.Enemy;
import world.entities.LivingObject;


public class SpawnEnemy extends Behavior {

	@Override
	public void run(LivingObject caller) {
		// TODO Auto-generated method stub
		World world = caller.world;
		LivingObject spawn = new LivingObject(Enemy.LOADEDDATA.get(caller.spawnType).variations.get("default"));
		world.addInstance(spawn);
		spawn.position.set(new Vector2(caller.position)); //TODO: Does this make them reference the same position?
	}

}
