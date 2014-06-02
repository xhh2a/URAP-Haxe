package cleanfighter 
{
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Missile;
	import Box2D.Common.Math.b2Vec2;
	import flash.utils.clearTimeout;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Bomb extends Missile
	{
		public function Bomb(name:String, params:Object=null) 
		{
			super(name, params);
			speed = 3;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);

			var gravity:b2Vec2 = new b2Vec2();
			gravity.Add(_box2D.world.GetGravity());
			gravity.Multiply(body.GetMass());
			_body.ApplyForce(gravity, _body.GetWorldCenter());
			
			if (_exploded)
			{
				_body.SetLinearVelocity(new b2Vec2());
			}
			else
			{
				_body.SetLinearVelocity(_velocity);
			}
		}
		
		override public function explode():void
		{
			_exploded = true; //left this in case for some reason we decide to make use of the _exploded field

			updateAnimation(); //left this here in case for some reason we want to animate our ammo in the future

			clearTimeout(_fuseDurationTimeoutID);
			
			killMissile();
		}
	}

}