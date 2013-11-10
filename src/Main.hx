import core.Factory;
import flash.Lib;
import haxe.Log;
import haxe.PosInfos;
import haxe.Resource;

/**
 * ...
 * @author UC Berkeley
 */

class Main 
{	
	static function main() 
	{
		#if debug
		var l_isDebug:Bool = true;
		#else
		var l_isDebug:Bool = false;
		#end
		if ( !l_isDebug ) 
		{
			Log.trace = function( v:Dynamic, ?infos:PosInfos ):Void {};
		}
		var l_factory = new Factory( Lib.current, l_isDebug, Resource.getString( "config" ) );
	}
	
	public function new() 
	{
		// needed for good form
	}
}
