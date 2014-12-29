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
	import Box2D.Common.Math.b2Vec2;
	
	/**
	 * ...
	 * @author Kevin
	 */
	//What is an AntiMarioEnemy? It's basically an Enemy that you can't kill by jumping on it.
	//Why is this necesary? Because by default, every Enemy in the Citrus Engine gets killed when you jump (or fall) on it.
	//However, we only want an Enemy to die when the right type of ammo hits it.
	//This AntiMarioEnemy class essentially a regular Enemy, but replaces the "die by getting jumped on" stuff with
	//"die by getting hit with the right type of ammo" stuff
	public class AntiMarioEnemy extends Enemy
	{
		
		public function AntiMarioEnemy(name:String, params:Object=null) 
		{
			super(name, params);
			_enemyClass = Missile;
			enemyKillVelocity = 1;
		}
		
		//change this later to have enemy follow player
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var position:b2Vec2 = _body.GetPosition();
			
			//Turn around when they pass their left/right bounds
			if ((_inverted && position.x * _box2D.scale < leftBound) || (!_inverted && position.x * _box2D.scale > rightBound))
				turnAround();
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (!_hurt)
				velocity.x = _inverted ? -speed : speed;
			else
				velocity.x = 0;
			
			updateAnimation();
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if ((collider is _enemyClass) && (name == Game.headsUp.getCurrWeaponArrayInfo().kills))
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