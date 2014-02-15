package core;
import awe6.core.Entity;
import awe6.interfaces.IKernel;

class NPC extends Character
{
	//Kevin TODO: do xml stuff for template
	public function new(p_kernel:IKernel, assetManager:AssetManager, ?fileDirectory:String, ?fileName:String, ?xCoordinate:Int, ?yCoordinate:Int )
	{
		//TODO: Test if this throws Null Exceptions if one of the optionals is not given, SHOULD not occur.
		super(p_kernel, assetManager, fileDirectory, fileName, xCoordinate, yCoordinate);
	}

	public function fire():Void {
		//TODO: Create new Projectile.
	}

	/** Converts String values in _attribute to their proper type. */
	public function updateAttributes():Void {
		attributeToFloat('health');
	}

	private function shouldFire():Bool {
		if(this._attribute.exists('fire')) {
			return Context.parse(this._attribute.get('fire'), Context.currentPos());
		} else {
			return false;
		}
	}

	private function onScreen():Bool {
		return (this._xCoordinate <= Globals.MAXX) && (this._xCoordinate >= Globals.MINX) && (this._yCoordinate <= Globals.MAXY) && (this._yCoordinate >= Globals.MINY)
	}

	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime ); //Movement Code in parent.
		//TODO: Some way of not deleting the template version.
		if (!onScreen() || (this._attribute['health'] <= 0)) {
			this._disposer();
		}
		if (this.shouldFire()) {
			this.fire();
		}
	}

	override public function getCopy(?attribute:Map<String, Dynamic>, ?char:ICustomEntity):ICustomEntity
	{
		var copiedNPC;
		if (char == null) {
			copiedNPC = new core.NPC(_kernel, _assetManager);
		} else {
			copiedNPC = char;
		}
		copiedNPC = super.getCopy(attribute, copiedNPC);
		copiedNPC.updateAttributes();
		return copiedNPC;
	}
}