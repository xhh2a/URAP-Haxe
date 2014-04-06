package loader;

import java.util.HashMap;

/**
 * Used for JSON Loading to store information from the file.
 */
public class Type {
	/**
	 * The type of this object.
	 */
	public String type;
	/**
	 * A Hashmap of integer variables. Also used for booleans.
	 */
	public HashMap<String, Integer> integers;
	/**
	 * A Hashmap of string variables.
	 */
	public HashMap<String, String> strings;
	/**
	 * A Hashmap of float variables.
	 */
	public HashMap<String, Float> floats;
	/**
	 * Other data (needs to be cast).
	 */
	public HashMap<String, Object> data;
	/**
	 * A HashMap of variations by their variation id.
	 */
	public HashMap<String, Variation> variations;

	/** Initializes empty hashmaps. */
	public Type() {
		this.integers = new HashMap<String, Integer>();
		this.strings = new HashMap<String, String>();
		this.floats = new HashMap<String, Float>();
		this.data = new HashMap<String, Object>();
	}

	/**
	 * This should be called after loading to ensure information is properly propagated to children.
	 * This updates variations to include parent information. This also sets type
	 * and variation variables in the Variation objects, so it contains all information necessary
	 * to be passed in to a LivingObject constructor.
	 * Also creates the default variation if not found.
	 */
	public Type update() {
		if (!variations.containsKey("default")) {
			this.variations.put("default", new Variation());
		}
		for (String akey: variations.keySet()) {
			Variation avar = variations.get(akey);
			avar.type = this.type;
			avar.variation = akey;
			for (String ikey: this.integers.keySet()) {
				if (!avar.integers.containsKey(ikey)) {
					avar.integers.put(ikey, this.integers.get(ikey));
				}
			}
			for (String ikey: this.floats.keySet()) {
				if (!avar.floats.containsKey(ikey)) {
					avar.floats.put(ikey, this.floats.get(ikey));
				}
			}
			for (String ikey: this.strings.keySet()) {
				if (!avar.strings.containsKey(ikey)) {
					avar.strings.put(ikey, this.strings.get(ikey));
				}
			}
			for (String ikey: this.data.keySet()) {
				if (!avar.data.containsKey(ikey)) {
					avar.data.put(ikey, this.data.get(ikey));
				}
			}
		}
		return this;
	}

}
