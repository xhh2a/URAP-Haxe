package ;
import core.Character;
//import haxe.macro.*;
/**
 * ...
 * @author UC Berkeley
 */
class Utils
{

	public static function arrayToList<T>(anArray:Array<T>):List<T> {
		var output:List<T> = new List<T>();
		for (el in anArray) {
			output.add(el);
		}
		return output;
	}

	/*
	macro private static function _moveContext(char:Character): List<Int> {
		var func_x: String, func_y: String;
		var pos_x: Int, pos_y: Int;
		if (_attribute.exists('movementX')) {
			func_x = _attribute.get("movementX");
			func_x = func_x.split("$1").join(Std.string(p_deltaTime));
			pos_x = Context.parse(func_x, Context.currentPos()); //this doesn't work despite the import
		}
		if (_attribute.exists('movementY')) {
			func_y = _attribute.get("movementY");
			func_y = func_y.split("$1").join(Std.string(p_deltaTime));
			pos_y = Context.parse(func_y, Context.currentPos()); //this doesn't work despite the import
		}
		var out = new List<Int>();
	}
	*/

}