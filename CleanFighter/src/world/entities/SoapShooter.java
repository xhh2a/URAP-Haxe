package world.entities;

public class SoapShooter extends Weapon {

	public SoapShooter(Player p) {
		super(p);
		
	}

	@Override
	public int getReloadTime() {
		
		return 12;
	}

}
