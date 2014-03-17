package world.entities;

public class Fly extends Enemy {
	public String getImageName(){
		return "Fly.jpeg";
	}
	public boolean isVulnerableTo(Projectile p){
		return (p instanceof Net);
	}
}
