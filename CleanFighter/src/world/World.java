package world;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.files.FileHandle;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.utils.Json;

import world.behavior.*;
import world.entities.*;

/**
 * A world contains information about the current game state.
 */
public class World {
	/** 
	 * This keeps track of all instances of non player objects in a two level HashMap.
	 * *First level is the Object Type
	 * *Second level is the Object Variation
	 * *Third level is the list of instances.
	 */
	public HashMap<String, HashMap<String, ArrayList<LivingObject>>> instances = new HashMap<String, HashMap<String, ArrayList<LivingObject>>>();
	public Player player;
	public HashMap<String, Behavior> installedbehaviors = new HashMap<String, Behavior>();
	
	public float ground = 0;

	/**
	 * Constructor for a new world, creates a player object.
	 */
	public World(){
		
		this.installBehaviors();
		Weapon.LOADEDDATA = new HashMap<String, loader.Type>();
		Weapon.LOADEDDATA.put("soapWeapon", loadJSON("data/json/soapWeapon.json").update()); //TODO: Change this to a generic directory load.
		Player.LOADEDDATA = loadJSON("data/json/player.json").update();
		Projectile.LOADEDDATA = new HashMap<String, loader.Type>();
		Projectile.LOADEDDATA.put("soapProjectile", loadJSON("data/json/soapProjectile.json").update());
		//ArrayList<String> arg = new ArrayList<String>();
		//arg.add("all");
		//HashMap<String, ArrayList<String>> want = new HashMap<String, ArrayList<String>>();
		//want.put("poop", arg);
		//Projectile.LOADEDDATA.get("soapProjectile").data.put("affects", want);

		//System.out.println(new Json().toJson(Projectile.LOADEDDATA.get("soapProjectile"), loader.Type.class));
		Enemy.LOADEDDATA = new HashMap<String, loader.Type>();
		Enemy.LOADEDDATA.put("poop", loadJSON("data/json/poop.json").update());
		Enemy.LOADEDDATA.put("jar", loadJSON("data/json/jar.json").update());
		Enemy.LOADEDDATA.put("fly", loadJSON("data/json/fly.json").update());
		
		this.player = new Player(Player.LOADEDDATA.variations.get("default"), this);
		this.player.world = this;
		
		
		//HARDCODED TESTS
		Enemy poop = this.createEnemy("poop");
		poop.position = new Vector2(300,00);
	}
	
	public void installBehaviors(){
		this.installedbehaviors.put("SpawnEnemey", new SpawnEnemy());
		this.installedbehaviors.put("GoLeft", new GoLeft());
		this.installedbehaviors.put("MaintainHeightWobble", new MaintainHeightWobble());

	}

	/**
	 * Loads a JSON file in a given PATH and returns it. Must be a valid
	 * loader.Type object. You should call .update() afterward to propagate
	 * type data to variations.
	 */
	public loader.Type loadJSON(String path) {
		FileHandle file = Gdx.files.internal(path);
		String text = file.readString();
		Json json = new Json();
		return json.fromJson(loader.Type.class, text);
	}

	/**
	 * Iteratively calls update on all instance objects.
	 * @param delta The time difference since the last update.
	 */
	public void update(float delta){
		player.update(delta);
		//We want to use an iterator to avoid concurrent modification exceptions.
		Iterator<HashMap<String, ArrayList<LivingObject>>> iiter = instances.values().iterator();
		while (iiter.hasNext()) { //Iterate through the types.
			Iterator<ArrayList<LivingObject>> jiter = iiter.next().values().iterator();
			while (jiter.hasNext()) { //Iterate through the variations
				ArrayList<LivingObject> lol = jiter.next();
				if (lol != null) {
					Iterator<LivingObject> loliter = lol.iterator();
					while (loliter.hasNext()) {
						//Each LivingObject's Update function will handle updates!
						LivingObject lo = loliter.next();
						lo.update(delta);
						if (!lo.shouldExist) {
							loliter.remove();
						}
					}
				}
			}
		}
	}

	/**
	 * Calls spritebatch.draw() on protected variables of the PhysObject.
	 */
	public void drawSelf(SpriteBatch spritebatch){
		player.drawSelf(spritebatch);
		Iterator<HashMap<String, ArrayList<LivingObject>>> iiter = instances.values().iterator();
		while (iiter.hasNext()) {
			Iterator<ArrayList<LivingObject>> jiter = iiter.next().values().iterator();
			while (jiter.hasNext()) {
				ArrayList<LivingObject> lol = jiter.next();
				if (lol != null) {
					for (LivingObject lo : lol) {
						lo.drawSelf(spritebatch);
					}
				}

			}
		}
	}

	/**
	 * Adds a LIVINGOBJECT to the instances list.
	 * @param livingObject What to add.
	 * @return True on success, false otherwise.
	 * @param type Required to be in the attribute map.
	 * @param variation Required to be in the attribute map.
	 */
	public boolean addInstance(LivingObject livingObject) {
		if ((livingObject.type != null) && (livingObject.variation != null)) {
			if (!this.instances.containsKey(livingObject.type)) {
				this.instances.put(livingObject.type, new HashMap<String, ArrayList<LivingObject>>());
			}
			HashMap<String, ArrayList<LivingObject>> typemap = this.instances.get(livingObject.type);
			if (!typemap.containsKey(livingObject.variation)) {
				typemap.put(livingObject.variation, new ArrayList<LivingObject>());
			}
			ArrayList<LivingObject> variationlist = typemap.get(livingObject.variation);
			variationlist.add(livingObject);
			livingObject.world = this;
			return true;
		}
		//livingObject.world = this;
		return false;
	}
	
	/**
	 * This method declares and initializes an Enemy object. It also adds that Enemy to the world via addInstance
	 * @param this is the String representation of the enemy you are trying to make (e.g. "fly")
	 * @return The created Enemy object
	 */
	public Enemy createEnemy(String query){
		Enemy ans = new Enemy(Enemy.LOADEDDATA.get(query).variations.get("default"), this);
		this.addInstance(ans);
		return ans;
	}
}
