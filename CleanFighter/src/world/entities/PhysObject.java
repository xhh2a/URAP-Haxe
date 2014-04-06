package world.entities;

import world.World;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

public class PhysObject {
	/** Current speed. */
	protected Vector2 velocity;
	/** Queued acceleration on the object */
	protected Vector2 acceleration;
	protected Texture texture;
	public Vector2 position;
	public World world;
	public float mass;
	public float SIZE = 6f;
	public boolean shouldExist = true;
	public final float MAXSPEED = 500f;

	public String imageFile;
	
	public static Vector2 gravity = new Vector2(0f,-0f);

	/**
	 * Initialize the object with a null texture.
	 */
	public PhysObject(){
		this.position = new Vector2();
		this.velocity = new Vector2();
		this.acceleration = new Vector2();
		this.loadTexture();
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
	 * Loads the texture in PATH
	 */
	public void loadTexture(String path){
		this.texture = new Texture(Gdx.files.internal(path));
	}

	/**
	 * Loads the texture in this.imageFile. If it is null, loads images/null.png.
	 */
	public void loadTexture() {
		String aFilePath = (this.imageFile == null) ? "images/null.png" : this.imageFile;
		this.loadTexture(aFilePath);
	}
	
	public Texture getTexture(){
		return this.texture;
	}

	public void setTexture(Texture t){
		this.texture = t;
	}

	public Rectangle getBounds(){
		return new Rectangle(this.position.x,this.position.y, this.getWidth(),this.getHeight());
	}
	
	private float getWidth() {
		return this.texture.getWidth();
	}
	private float getHeight() {
		return this.texture.getHeight();
	}

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

	public void drawSelf(SpriteBatch spritebatch){
		spritebatch.draw(this.texture, this.position.x, this.position.y);
	}

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
		ans.setTexture(texture);
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
