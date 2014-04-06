package loader;

import java.util.HashMap;

/**
 * Used for JSON Loading to store information from the file.
 */
public class Variation {
	/**
	 * The type of this variation. This should be auto-set by the loader
	 * and does not need to be re-defined in the file.
	 */
	public String type;
	/**
	 * The variation of this object. This should be auto-set by the loader and
	 * does not need to be re-defined in the file.
	 */
	public String variation;
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
	/** Initializes empty hashmaps. */
	public Variation() {
		this.integers = new HashMap<String, Integer>();
		this.strings = new HashMap<String, String>();
		this.floats = new HashMap<String, Float>();
		this.data = new HashMap<String, Object>();
	}
}
