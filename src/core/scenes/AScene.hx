package awe6test2.scenes;
import awe6.core.Scene;
import awe6.extras.gui.Text;
import awe6.interfaces.ETextStyle;
import awe6test2.AssetManager;
import awe6test2.Session;

/**
 * ...
 * @author Kevin
 */

class AScene extends Scene 
{
	private var _assetManager:AssetManager;
	private var _session:Session;
	private var _title:Text;
	
	override private function _init():Void 
	{
		super._init();
		_assetManager = cast( _kernel.assets, AssetManager );
		_session = cast( _kernel.session, Session );
		addEntity( _title = new Text( _kernel, _kernel.factory.width - 10, 35, "", _kernel.factory.createTextStyle( ETextStyle.HEADLINE ) ), true );
		_title.setPosition( 10, _kernel.factory.height - _title.height );
	}

}
