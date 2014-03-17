package world.entities;

public class Poop extends Enemy {
	
	public Poop(){
		this.setHealth(100f);
		this.setMass(3f);
	}
	@Override
	public boolean isVulnerableTo(Projectile p) {
		if (p instanceof Soap){
			return true;
		}
		return false;
	}
	
	public String getImageName(){
		return "poop.png";
	}

}
