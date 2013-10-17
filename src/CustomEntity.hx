package ;

import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import XmlLoader;

/**
 * All Entity classes should extend this!
 * @author UC Berkeley
 */
class CustomEntity extends Entity
{
	private static var _assetManager : AssetManager;
	public var _attribute: Map<String, Dynamic>;
	private static var _filename:String;
	private static var _filedirectory:String;
	private static var _validator:Null < Xml->Bool >;

	/** This is the proper constructor for an entity. If you need to overwrite the constructor, use this as a template. */
	public function new(p_kernel:IKernel, ?p_id:String, ?p_context:Context)
	{
		super(p_kernel, p_id, p_context);
	}

	/** This is called by the init function in AssetManager.hx */
	public static function setAssetManager(manager:AssetManager) {
		_assetManager = manager;
	}

	/** Returns a copy of this with the existing _attribute, or the passed in ATTRIBUTE. */
	public function getCopy(?attribute:Map < String, Dynamic>) {
		if (attribute == null) {
			var newattribute:Map<String, Dynamic> = new Map<String, Dynamic>();
			//TODO: deepcopy our current _attribute.
		}
		//TODO: Complete reflection code to create a new instance of the current class.
	}

	/** Overwrite this method with something that sets _filename and _firedirectory to what they should be, then call super()
	 *   Example:
	 * 	  public static override function __init__() {
	 *	     _filedirectory = FOO;
	 *	     _filename = BAR;
	 *	     super();
	 *    }
	 */
	public static function __init__() {
		var result = XmlLoader.loadFile(_filedirectory, _filename, _assetManager, _validator);
/*		for (entityType in result.keys()) {
			var variantMap;
			if (!_assetManager.entityTemplates.exists(entityType)) {
				variantMap = new Map<String, CustomEntity>();
			} else {
				variantMap = _assetManager.entityTemplates[entityType];
			}
			var variants = result.get(entityType);
			for (variantID in variants.keys()) {
				variantMap.set(variantID, getCopy(variants.get(variantID)));
			}
		}*/
		trace(result);
	}

}