package world.behavior;

import world.entities.LivingObject;

public abstract class Behavior {

	protected LivingObject parent;

	/** A behavior object*/
	public Behavior() {
		
	}

	/** The actual command called by CALLER  */
	public abstract void run(LivingObject caller);

}
