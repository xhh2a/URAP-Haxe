package ;
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


}