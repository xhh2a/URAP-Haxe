package ;

import awe6.core.Context;
import awe6.core.Entity;
import awe6.interfaces.IKernel;

/**
 * All Entity classes should now extend Character.
 * @author UC Berkeley
 */
interface ICustomEntity
{
	//static var _assetManager : AssetManager;
	var _attribute: Map<String, Dynamic>;

	/** This is the proper constructor for an entity. If you need to overwrite the constructor, use this as a template. */
	/*public function new(p_kernel:IKernel, ?manager:AssetManager, ?p_id:String, ?p_context:Context)
	{
		if (manager != null) {
			_assetManager = manager;
		}
		super(p_kernel, p_id, p_context);
	}*/

	/** Returns a copy of this with the existing _attribute, or the passed in ATTRIBUTE. */
	function getCopy(?attribute:Map < String, Dynamic>, ?char:ICustomEntity):ICustomEntity; /*{
	} */

	/** To be used in conjunction with getCopy() or the initializer. What getCopy() does is set String values in the _attribute map to their correct type.
	 *  The programmer needs to define which variables are what types, and this is where they do so. See NPC for an example. */
	function updateAttributes():Void;

	/** If you want to run setup code, below is an example call to get the results from a XML file parsing. You then need to parse
	 *  those results to get what you want. See XmlLoader for details on what the call returns. */
	/* public staticn function __init__() {
		//var result = XmlLoader.loadFile(FILEDIRECTORY, FILENAME, _assetManager, ?_validator());
	}*/

}

/** Abstract Class */
/*
class ACustomEntity extends Entity implements ICustomEntity {
	public var _attribute: Map<String, Dynamic>;
	public var _type:String;
	public function getCopy(?attribute:Map < String, Dynamic > ):ICustomEntity {
		return new ACustomEntity(_kernel);
	}
}
*/