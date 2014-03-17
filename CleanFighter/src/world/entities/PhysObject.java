package world.entities;

import world.World;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

public class PhysObject {
	private Vector2 position;
	private Vector2 velocity;
	private Vector2 acceleration;
	private World world;
	private Texture texture;
	private float mass;
	public float SIZE = 6f;
	public boolean shouldExist = true;
	
	public static Vector2 gravity = new Vector2(0f,-0f);
	
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
	
	public float getMaxSpeed(){
		return 500f;
	}
	
	public void update(float delta){
		//System.out.println("The thing updating:\t" + this + "\tacceleration:\t" + acceleration);
		position.add(velocity.cpy().scl(delta));
		velocity.add(acceleration);
		//velocity.add(gravity);
		this.setAcceleration(Vector2.Zero);
		//TODO: Velocity and acceleration
		//System.out.println("The thing updating:\t" + this + "\tacceleration:\t" + acceleration);
	}
	
	public void setVelocity(Vector2 v){
		
		this.velocity = v.clamp(0, this.getMaxSpeed());
	}
	
	public void setMass(float f) {
		this.mass = f;
	}
	
	public void addVelocity(Vector2 v){
		this.setVelocity(this.velocity.add(v));
	}
	
	public Vector2 getVelocity(){
		return this.velocity;
	}
	
	public Vector2 getPosition(){
		return this.position;
	}
	
	public void receiveForce(Vector2 force){
		//System.out.println("The thing receiving force:\t" + this + "\tForce:\t" + force);
		force.x /= this.mass;
		force.y /= this.mass;
		this.acceleration.add(force);
	}
	
	public void setPosition(Vector2 v){
		this.position = v;
	}
	
	public void setWorld(World w){
		this.world = w;
	}
	
	public World getWorld(){
		return this.world;
	}
	
	public String getImageName(){
		return "null.png";
	}
	
	public void loadTexture(){
		this.texture = new  Texture(Gdx.files.internal("images/" + this.getImageName()));
	}
	
	public Texture getTexture(){
		return this.texture;
	}
	public Rectangle getBounds(){
		return new Rectangle(this.getPosition().x,this.getPosition().y, this.getWidth(),this.getHeight());
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
		spritebatch.draw(this.texture, this.getPosition().x, this.getPosition().y);
	}
	
	public PhysObject clone(){
		PhysObject ans = new PhysObject();
		ans.setPosition(position);
		ans.setVelocity(velocity);
		ans.setAcceleration(acceleration);
		ans.setWorld(world);
		ans.setMass(mass);
		ans.setTexture(texture);
		
		return ans;
	}
	
	public void setAcceleration(Vector2 v){
		this.acceleration = v;
	}
	
	public void setTexture(Texture t){
		this.texture = t;
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
