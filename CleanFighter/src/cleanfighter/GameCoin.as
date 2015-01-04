package cleanfighter 
{
	import citrus.objects.platformer.box2d.Coin;
	/**
	 * ...
	 * @author Kevin
	 */
	public class GameCoin extends Coin
	{
		public var _value:Number;
		
		public function GameCoin(name:String, params:Object, value:Number=100) 
		{
			super(name, params);
			_value = value;
			collectorClass = "cleanfighter.Player";
		}
		
		override public function destroy():void
		{
			super.destroy();
			Game._score += _value;
		}
		
	}

}