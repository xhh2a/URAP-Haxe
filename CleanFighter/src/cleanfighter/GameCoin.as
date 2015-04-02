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
			_value = value; //how many points this coin will give
			collectorClass = "cleanfighter.Player"; //tells us who can collect the coin
		}
		
		//makes coin disappear on pick up
		override public function destroy():void
		{
			super.destroy();
			Game._score += _value; //increase score on pick-up
		}
		
	}

}