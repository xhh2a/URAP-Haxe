package ;

/**
 * ...
 * @author Kevin
 */

 //I don't really need this... I'll probably get rid of this class some time later
 
class MapList<ValueType>
{
	public var _size:Int;
	public var _map:Map<Int, ValueType>;
	
	public function new() 
	{
		_size = 0;
		_map = new Map<Int, ValueType>();
	}
	
	public function size():Int
	{
		return _size;
	}
	
	public function getItemAt(index:Int):ValueType
	{
		return _map.get(index);
	}
	
	public function add(item:ValueType):Void
	{
		_map.set(_size, item);
		
		//We do this check so that we only increase the size of the MapList if the add was actually successful
		if (_map.exists(_size))
		{
			_size++;
		}
	}
	
	public function removeItemAt(index:Int):Bool
	{
		var hadValueAtSpecifiedIndex:Bool = _map.remove(index);
		
		if (hadValueAtSpecifiedIndex)
		{
			_size--;
		}
		
		return hadValueAtSpecifiedIndex;
	}
	
	public function removeLastItem():Bool
	{
		return removeItemAt(_size - 1);
	}
	
	public function removeFirstItem():Bool
	{
		return removeItemAt(0);
	}
}