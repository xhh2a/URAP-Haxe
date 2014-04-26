package world.entities;

import java.util.HashMap;

import world.World;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.Sprite;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

//TODO: Potentially requires extending Disposable?
public class PhysObject {
	//TODO: Extend Sprite class and move velocity and acceleration into that or figure out how to avoid double track of x/y.
	/** Current speed. */
	protected Vector2 velocity;
	/** Queued acceleration on the object */
	protected Vector2 acceleration;
	//TODO: Potentially does not require a copy of the sprite per instance, investigate SpriteCache.
	protected Sprite sprite;
	public Vector2 position;
	public World world;
	public float mass;
	public float SIZE = 6f;

	public boolean shouldExist = true;
	public final float MAXSPEED = 500f;
	//TODO: Switch to using TextureAtlas as the backing for Sprites, see https://github.com/alistairrutherford/netthreads-libgdx/blob/master/src/main/java/com/netthreads/libgdx/texture/TextureCache.java
	//TODO: And related SpriteCache.
	//TODO: Allow animation.
	protected static HashMap<String, Sprite> spritecache = new HashMap<String, Sprite>();

	public String imageFile;
	
	public static Vector2 gravity = new Vector2(0f,-0f);

	/**
	 * Initialize the object with a null texture.
	 */
	public PhysObject(){
		this.position = new Vector2();
		this.velocity = new Vector2();
		this.acceleration = new Vector2();
		this.loadSprite(); //TODO: Use TexturePacker or SpritePacker
		this.mass = 1;
	}
	
	public PhysObject(Vector2 position, float mass, World w){
		this();
		this.position = position;
		this.world = w;
		this.mass = mass;
	}
	public PhysObject(Vector2 position, Vector2 velocity, Vector2 acceleration, float m, World w){
		this(position,m,w);
		this.velocity = velocity;
		this.acceleration = acceleration;
	}
	
	public void update(float delta){
		this.position.add(this.velocity.cpy().scl(delta));
		this.velocity.add(this.acceleration);
		this.velocity.clamp(0, this.MAXSPEED);
		this.acceleration = Vector2.Zero.cpy();
		//TODO: Potentially required, look at how origin stuff is calculated.
		//this.sprite.setX(this.position.x);
		//this.sprite.setY(this.position.y);
		//TODO: Update acceleration possibly
	}
	
	public void setVelocity(Vector2 v){
		this.velocity = v.clamp(0, this.MAXSPEED);
	}
	
	public void addVelocity(Vector2 v){
		this.velocity = this.velocity.add(v);
	}
	
	public Vector2 getVelocity(){
		return this.velocity;
	}
	
	public void receiveForce(Vector2 force){
		force.x /= this.mass;
		force.y /= this.mass;
		this.acceleration.add(force);
	}

	public Vector2 getAcceleration() {
		return this.acceleration;
	}

	/**
	 * Loads the sprite in PATH, checks the cache first. If not there, does
	 * an IO, and puts into cache. If it is, sets the sprite to be a COPY
	 * of the stored sprite.
	 */
	public void loadSprite(String path){
		if (spritecache.containsKey(path)) {
			this.sprite = new Sprite(spritecache.get(path));
		} else {
			this.sprite = new Sprite(new Texture(Gdx.files.internal(path)));
			spritecache.put(path, new Sprite(this.sprite));
		}
	}

	/**
	 * Loads the sprite in this.imageFile. If it is null, loads images/null.png.
	 */
	public void loadSprite() {
		String aFilePath = (this.imageFile == null) ? "images/null.png" : this.imageFile;
		this.loadSprite(aFilePath);
	}
	
	public Sprite getSprite(){
		return this.sprite;
	}

	public void setSprite(Sprite t){
		this.sprite = t;
	}

	public Rectangle getBounds(){
		return new Rectangle(this.position.x,this.position.y, this.getWidth(),this.getHeight());
	}
	
	protected float getWidth() {
		return this.sprite.getWidth();
	}

	protected float getHeight() {
		return this.sprite.getHeight();
	}

	/**
	 * Returns true if this object intersects (collides with another object.
	 */
	public boolean intersects(PhysObject other){
		return this.getBounds().overlaps(other.getBounds());
	}
	
	public boolean willIntersect(PhysObject other, float delta){
		PhysObject newMe = this.clone();
		PhysObject newOther = other.clone();
		newMe.update(delta);
		newOther.update(delta);
		return newMe.intersects(newOther);
	}
	//draw(TextureRegion region, float x, float y, float originX, float originY, float width, float height, float scaleX, float scaleY, float rotation)
	public void drawSelf(SpriteBatch spritebatch){
		//Verify this actually uses rotation, scale, etc, the sourcecode doesn't seem to do so.
		//this.sprite.draw(spritebatch);
		//So much stupid stuff that shouldn't need to be passed in. Bad design by libgdx.
		spritebatch.draw(this.sprite, this.position.x, this.position.y, this.sprite.getRegionWidth()/2.0f, this.sprite.getRegionHeight()/2.0f, this.sprite.getWidth(), this.sprite.getHeight(), this.sprite.getScaleX(), this.sprite.getScaleY(), this.sprite.getRotation());
	}

	@Override
	/**
	 * Creates a temporary copy of this Physical Object to check
	 * for if intersections will occur on the next frame for
	 * the willIntersect call.
	 */
	public PhysObject clone(){
		PhysObject ans = new PhysObject();
		ans.position = this.position;
		ans.setVelocity(velocity);
		ans.acceleration = this.acceleration;
		ans.world = this.world;
		ans.mass = this.mass;
		ans.setSprite(this.sprite);
		return ans;
	}
	
	public void collide(PhysObject other){
		//TODO: Fix this
		Vector2 force1 = this.velocity.scl(-1).scl(this.mass);
		Vector2 force2 = new Vector2(-other.velocity.x*other.mass, -other.velocity.y*other.mass);
		System.out.println("Force1:\t" + force1);
		System.out.println("Force2:\t" + force2);
		//this.receiveForce(force1);
		//other.receiveForce(force2.scl(-1));
		other.receiveForce(force1.add(force2));
		this.receiveForce(force1.add(force2).scl(-1));
	}
	
}
