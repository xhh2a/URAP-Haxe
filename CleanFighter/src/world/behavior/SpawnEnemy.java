package world.behavior;

import java.util.HashMap;

import com.badlogic.gdx.math.Vector2;

import world.World;
import world.entities.Enemy;
import world.entities.LivingObject;


public class SpawnEnemy extends Behavior {

	private HashMap<LivingObject,Integer> spawn_timers = new HashMap<LivingObject, Integer>();
	@Override
	public void run(LivingObject caller) {
		// TODO Auto-generated method stub
		if (!spawn_timers.containsKey(caller)){
			spawn_timers.put(caller, new Integer(caller.spawnTime));
		}
		
		spawn_timers.put(caller, new Integer(spawn_timers.get(caller).intValue()-1));
		
		if (spawn_timers.get(caller) <= 0){
			World world = caller.world;
			LivingObject spawn = new LivingObject(Enemy.LOADEDDATA.get(caller.spawnType).variations.get("default"));
			world.addInstance(spawn);
			spawn.position.set(new Vector2(caller.position)); //TODO: Does this make them reference the same position?
			spawn_timers.put(caller, new Integer(caller.spawnTime));
		}
		
		
	}

}
