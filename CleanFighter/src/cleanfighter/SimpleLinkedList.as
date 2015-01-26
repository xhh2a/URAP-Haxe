package cleanfighter 
{
	/**
	 * ...
	 * @author Kevin
	 */
	public class SimpleLinkedList 
	{
		protected var _length:Number;
		protected var _first:Object;
		protected var _last:Object;
		
		public function SimpleLinkedList() 
		{
			_length = 0;
			_first = null;
			_last = null;
		}
		
		public function getLength():Number
		{
			return _length;
		}
		
		public function append(dataToAppend:*):void
		{
			if (!_last)
			{
				_first = { data: dataToAppend, next: null };
				_last = _first;
			}
			else
			{
				_last.next = { data: dataToAppend, next: null };
				_last = _last.next;
			}
			
			_length++;
		}
		
		public function getFirst():Object
		{
			return _first;
		}
		
		public function getLast():Object
		{
			return _last;
		}
		
		//removes the first node in the list (starting from the front) that contains the specified data
		public function removeData(dataToRemove:*):void
		{
			var currNode:Object = _first;
			
			if (!currNode)
			{
				return;
			}
			
			if (currNode.data == dataToRemove)
			{
				_first = _first.next;
				if (!_first)
				{
					_last = _first;
				}
				_length--;
				
				return;				
			}
			
			while (currNode)
			{
				if (currNode.next && (currNode.next.data == dataToRemove))
				{
					currNode.next = currNode.next.next;
					_length--;
					return;
				}
				currNode = currNode.next;
			}

		}
		
	}

}