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
//import flash.Lib.trace;
import Utils;

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
	/**
	 * Contains a list of all entity objects initialized based on values from assets. New instances of an object should be copied
	 * from this list. The first level KEY is the TYPE of an entity. The second level is a map where the KEY is the ID of the variant.
	 */
	public var entityTemplates:Map<String, Map<String, CustomEntity>>;

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
		loadLanguage(Globals.SELECTEDLANGUAGE, Globals.LANGUAGEDIRECTORY);
		entityTemplates = new Map < String, Map < String, CustomEntity >> ();
		font = Assets.getFont( "assets/fonts/orbitron.ttf" );
		//Test Code
		CustomEntity.setAssetManager(this);
		var a:CustomEntity = new CustomEntity(this._kernel);
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
	 * This should be initialized by the preloader.
	 */
	public var loadedLanguageStrings:Null<Xml> = null;

	/** 
	 * Load the language from XMLLOCATION to the current ASSETMANAGER instance.
	 */
	public function loadLanguage(xmlFile:String, xmlSubdirectory:String) {
		loadedLanguageStrings = Xml.parse(getAsset(xmlFile, xmlSubdirectory)); //Strip the top level mandatory tag.
	}

	/**
	 * Returns the text from the currently loaded language file corresponding to KEY.
	 * KEY will be split by the '.' character to filter sub elements of the XML language file.
	 * You do not need to add data to this string, this function will add it automatically to the search if missing.
	 * This function uses an iterative tree search.
	 * 
	 * Since Haxe doesn't support a good built in string formatter function, you can pass in the arguments to this function.
	 * Ex in your language XML, define: "Print $1 and print $2". Pass in an Array<String> of ["a", "b"], and you will get out:
     * "Print a and print b"
	 * 
	 * Implementation details for future maintainers:
	 * *List is faster than Array if the iterable needs to be modified. However, it uses Arrays as the undelying implementation.
	 * *Array<Dynamic> is required if the elements inside are of different types. Therefore, this must be List<Dynamic>
	 * *See SugarList and FastList for potential optimizations.
	 * 
	 */
	public function getText(key:String, ?args:Array<String>) {
		var fringe:List<Dynamic> = new List<Dynamic>();
		if (loadedLanguageStrings == null) {
			throw "[FATAL] Attempted to get a string prior to loading the language files.";
		}
		var searchfor:List<String> = Utils.arrayToList(key.split("."));
		if (searchfor.first().toLowerCase() != "data") {
			searchfor.push("data");
		}
		var nextEle:TextFringeElement = { xmlElement: loadedLanguageStrings, searchfor: searchfor };
		fringe.push( nextEle );
		var result:String = key + ": UNDEFINED";
		/**
		 * Custom copy method
		 */
		var listCopy = function (aList:List<String>):List<String> {
			var output:List<String> = new List<String>();
			for (el in aList) {
				output.add(new String(el));
			}
			return output;
		}
		/**
		 * The iterative helper.
		 */
		var treesearch = function(thefringe:List<Dynamic> ) {
			var nextElement:TextFringeElement = fringe.pop();
			var nextTarget:Null<String> = nextElement.searchfor.first();
			var temp:List<String> = nextElement.searchfor;
			var remainingTargets:List<String> = listCopy(temp);
			remainingTargets.remove(nextTarget);
			if (nextTarget == null) {
				result = nextElement.xmlElement.firstChild().nodeValue;
			} else {
				if (nextElement.xmlElement.firstElement().nodeName.toLowerCase() == nextTarget.toLowerCase()) {
					for (foundChild in nextElement.xmlElement.elements()) { //ElementsNamed is broken.
						if (remainingTargets.first() == null) {
							result = foundChild.firstChild().nodeValue;
						} else if (foundChild.firstElement().nodeName.toLowerCase() == remainingTargets.first().toLowerCase()) {
							var childEle:TextFringeElement = { xmlElement: foundChild, searchfor: remainingTargets };
							fringe.push(childEle);
						}
					}
				}
			}
		}
		while (!fringe.isEmpty()) {
			treesearch(fringe);
		}
		if (args != null) {
			var i:Int = 1;
			for (stringarg in args) {
				result = result.split("$" + i).join(stringarg);
				i += 1;
			}
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

