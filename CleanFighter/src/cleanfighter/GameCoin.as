package cleanfighter 
{
	import citrus.objects.platformer.box2d.Coin;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
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
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (_collectorClass && collider is _collectorClass)
			{
				kill = true;
				Game._score += _value; //increase score on pick-up
			}
		}
		
	}

}