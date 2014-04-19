package world.entities;

public abstract class Behavior {

	protected LivingObject parent;

	/** A behavior object called by CALLER */
	public Behavior(LivingObject caller) {
		this.parent = caller;
	}

	/** The actual command. */
	public void run() {
		return;
	}

}
