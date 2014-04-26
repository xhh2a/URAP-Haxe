package world.entities;

public abstract class Behavior {

	protected LivingObject parent;

	/** A behavior object*/
	public Behavior() {
	}

	/** The actual command called by CALLER  */
	public void run(LivingObject caller) {
		return;
	}


}
