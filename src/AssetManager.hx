package ;
import awe6.core.AAssetManager;
import awe6.core.Context;
import awe6.core.View;
import awe6.extras.gui.BitmapDataScale9;
import awe6.interfaces.IView;
import flash.display.Bitmap;
import flash.display.BitmapData;
import openfl.Assets;
import flash.text.Font;

/**
 * ...
 * @author UC Berkeley
 */
typedef TextFringeElement = { xmlElement:Xml, searchfor:List<String> };

class AssetManager extends AAssetManager 
{	
	public var overlayBackground( default, null ):IView;
	public var overlayBackOver( default, null ):IView;
	public var overlayBackUp( default, null ):IView;
	public var overlayMuteOver( default, null ):IView;
	public var overlayMuteUp( default, null ):IView;
	public var overlayPauseOver( default, null ):IView;
	public var overlayPauseUp( default, null ):IView;
	public var overlayUnmuteOver( default, null ):IView;
	public var overlayUnmuteUp( default, null ):IView;
	public var overlayUnpauseOver( default, null ):IView;
	public var overlayUnpauseUp( default, null ):IView;
	public var font( default, null ):Font;
		
	private var _html5AudioExtension:String;
	
	override private function _init():Void 
	{
		super._init();
		overlayBackground = _createView( OVERLAY_BACKGROUND );
		overlayBackUp = _createView( OVERLAY_BACK_UP );
		overlayBackOver = _createView( OVERLAY_BACK_OVER );
		overlayMuteUp = _createView( OVERLAY_MUTE_UP );
		overlayMuteOver = _createView( OVERLAY_MUTE_OVER );
		overlayUnmuteUp = _createView( OVERLAY_UNMUTE_UP );
		overlayUnmuteOver = _createView( OVERLAY_UNMUTE_OVER );
		overlayPauseUp = _createView( OVERLAY_PAUSE_UP );
		overlayPauseOver = _createView( OVERLAY_PAUSE_OVER );
		overlayUnpauseUp = _createView( OVERLAY_UNPAUSE_UP );
		overlayUnpauseOver = _createView( OVERLAY_UNPAUSE_OVER );
		font = Assets.getFont( "assets/fonts/orbitron.ttf" );
		#if js
		_html5AudioExtension = untyped flash.media.Sound.nmeCanPlayType( "ogg" ) ? ".ogg" : ".mp3";
		#end
	}

	override public function getAsset( p_id:String, ?p_packageId:String, ?p_args:Array<Dynamic> ):Dynamic 
	{
		if ( p_packageId == null ) 
		{
			p_packageId = _kernel.getConfig( "settings.assets.packages.default" );
		}
		if ( p_packageId == null ) 
		{
			p_packageId = _PACKAGE_ID;
		}
		if ( ( p_packageId == _kernel.getConfig( "settings.assets.packages.audio" ) ) || ( p_packageId == "assets.audio" ) ) 
		{
			var l_extension:String = ".mp3";
			#if ( cpp || neko )
			l_extension = ".ogg"; // doesn't work on Macs?
			#elseif js
			l_extension = _html5AudioExtension;
			#end
			p_id += l_extension;
		}
		if ( ( p_packageId.length > 0 ) && ( p_packageId.substr( -1, 1 ) != "." ) ) 
		{
			p_packageId += ".";
		}
		var l_assetName:String = StringTools.replace( p_packageId, ".", "/" ) + p_id;
		var l_result:Dynamic = Assets.getSound( l_assetName );
		if ( l_result != null ) 
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getBitmapData( l_assetName );
		if ( l_result != null ) 
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getFont( l_assetName );
		if ( l_result != null ) 
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getText( l_assetName );
		if ( l_result != null ) 
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getBytes( l_assetName );
		if ( l_result != null ) 
		{
			return l_result;
		}
		return super.getAsset( p_id, p_packageId, p_args );
	}

	private function _createView( p_type:EAsset ):IView 
	{
		var l_context:Context = new Context();
		var l_bitmap:Bitmap = new Bitmap();
		l_context.addChild( l_bitmap );
		switch( p_type ) 
		{
			case OVERLAY_BACKGROUND :
			#if !js
				l_bitmap.bitmapData = new BitmapDataScale9( Assets.getBitmapData( "assets/overlay/OverlayBackground.png" ), 110, 20, 550, 350, _kernel.factory.width, _kernel.factory.height, true );
			#else
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/OverlayBackground.png" );
			#end
			case OVERLAY_BACK_UP :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/BackUp.png" );
			case OVERLAY_BACK_OVER :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/BackOver.png" );
			case OVERLAY_MUTE_UP :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/MuteUp.png" );
			case OVERLAY_MUTE_OVER :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/MuteOver.png" );
			case OVERLAY_UNMUTE_UP :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnmuteUp.png" );
			case OVERLAY_UNMUTE_OVER :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnmuteOver.png" );
			case OVERLAY_PAUSE_UP :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/PauseUp.png" );
			case OVERLAY_PAUSE_OVER :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/PauseOver.png" );
			case OVERLAY_UNPAUSE_UP :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnpauseUp.png" );
			case OVERLAY_UNPAUSE_OVER :
				l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnpauseOver.png" );
		}
		return new View( _kernel, l_context );
	}

	/**
	 * This should be initialized by the preloader. See LanguageLoader.hx 
	 */
	public var loadedLanguageStrings:Null<Xml> = null;
	

	/**
	 * Returns the text from the currently loaded language file corresponding to KEY.
	 * KEY will be split by the '.' character to filter sub elements of the XML language file.
	 * This function uses an iterative tree search.
	 * 
	 * Implementation details for future maintainers:
	 * *List is faster than Array if the iterable needs to be modified. However, it uses Arrays as the undelying implementation.
	 * *Array<Dynamic> is required if the elements inside are of different types. Therefore, this must be List<Dynamic>
	 * *See SugarList and FastList for potential optimizations.
	 */
	public function getText(key:String) {
		var fringe:List<Dynamic> = new List<Dynamic>();
		if (loadedLanguageStrings == null) {
			throw "[FATAL] Attempted to get a string prior to loading the language files.";
		}
		var searchfor:List<String> = new List<String>();
		for (el in key.split(".")) {
			searchfor.add(el);
		}
		var nextEle:TextFringeElement = { xmlElement: loadedLanguageStrings, searchfor: searchfor };
		fringe.push( nextEle );
		var result:String = key + ": UNDEFINED";
		/**
		 * The iterative helper.
		 */
		var treesearch = function(thefringe:List<Dynamic> ) {
			var nextElement:TextFringeElement = fringe.pop();
			var nextTarget:String = nextElement.searchfor.first();
			var remainingTargets:List<String> = Reflect.copy(nextElement.searchfor);
			remainingTargets.remove(nextTarget);
			if (nextElement.searchfor.isEmpty()) {
				result = nextElement.xmlElement.firstChild().nodeValue;
			} else {
				if (nextElement.xmlElement.nodeName.toLowerCase() == nextTarget.toLowerCase()) {
					for (foundChild in nextElement.xmlElement.elementsNamed(nextTarget)) {
						var childEle:TextFringeElement = { xmlElement: foundChild, searchfor: remainingTargets };
						fringe.push(childEle);
					}
				}
			}
		}
		while (!fringe.isEmpty()) {
			treesearch(fringe);
		}
		return result;
	}
}

enum EAsset 
{
	OVERLAY_BACKGROUND;
	OVERLAY_BACK_UP;
	OVERLAY_BACK_OVER;
	OVERLAY_MUTE_UP;
	OVERLAY_MUTE_OVER;
	OVERLAY_UNMUTE_UP;
	OVERLAY_UNMUTE_OVER;
	OVERLAY_PAUSE_UP;
	OVERLAY_PAUSE_OVER;
	OVERLAY_UNPAUSE_UP;
	OVERLAY_UNPAUSE_OVER;
}

