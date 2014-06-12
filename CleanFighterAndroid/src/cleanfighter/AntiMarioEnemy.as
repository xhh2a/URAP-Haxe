package cleanfighter 
{
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Missile;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import flash.geom.Point;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.math.MathVector;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class AntiMarioEnemy extends Enemy
	{
		
		public function AntiMarioEnemy(name:String, params:Object=null) 
		{
			super(name, params);
			_enemyClass = Missile;
			enemyKillVelocity = 1;
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (collider is _enemyClass)
			{
				hurt();
				Game._score++;
			}

			if (_body.GetLinearVelocity().x < 0 && (contact.GetFixtureA() == _rightSensorFixture || contact.GetFixtureB() == _rightSensorFixture))
			{
				return;
			}

			if (_body.GetLinearVelocity().x > 0 && (contact.GetFixtureA() == _leftSensorFixture || contact.GetFixtureB() == _leftSensorFixture))
			{
				return;
			}

			if (contact.GetManifold().m_localPoint)
			{

				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;

				if ((collider is Platform && collisionAngle != 90) || collider is Enemy)
				{
					turnAround();
				}
			}

		}
	}

}