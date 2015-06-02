package cleanfighter 
{
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.math.MathVector;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.b2Manifold;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Kevin
	 */
	//By default, every Enemy in the Citrus Engine gets killed when you jump (or fall) on it.
	//(Citrus Engine games by default have jumping and gravity enabled; but obviously, we're disabling jumping/gravity in our game)
	//HOWEVER, we only want an Enemy to die when the right type of ammo hits it.
	//This GenericEnemy class essentially a regular Enemy, but replaces the "die by getting jumped on" stuff with
	//"die by getting hit with the right type of ammo" stuff
	public class GenericEnemy extends Enemy
	{
		protected var _damageTicker:Timer;
		
		protected var _up:Boolean = false;
		
		[Inspectable(defaultValue="up",enumeration="up,down")]
		public var startingDirectionY:String = "up";
		
		[Inspectable(defaultValue="-100000")]
		public var upBound:Number = -100000;
		
		[Inspectable(defaultValue="100000")]
		public var downBound:Number = 100000;
		
		[Inspectable(defaultValue=true)]
		public var horizMovement:Boolean = true;
		
		[Inspectable(defaultValue=false)]
		public var vertMovement:Boolean = false;
		
		public var damageStrength:Number = 1;
		
		private var _goodGuySensorFixtureDef:b2FixtureDef;
		private var _goodGuySensorFixture:b2Fixture;
		
		private var _victimList:SimpleLinkedList;
		
		private var _whenDead:Signal;
		private var _whichLevel:Level;
		
		public function GenericEnemy(name:String, passedInLevel:Level, params:Object=null) 
		{
			super(name, params);
			_enemyClass = Missile;
			
			if (startingDirectionY == "up")
			{
				_up = true;
			}
			
			_victimList = new SimpleLinkedList();
			
			_damageTicker = new Timer(1000);
			_damageTicker.addEventListener(TimerEvent.TIMER, periodicDoDamage);
			
			_whenDead = new Signal();
			_whichLevel = passedInLevel;
			_whenDead.addOnce(_whichLevel.increaseKillCount);
			_whenDead.addOnce(increaseGameScore);
			
			_endContactCallEnabled = true;
		}
		
		protected function periodicDoDamage(e:TimerEvent):void
		{
			//on every tick, call the getHurt of all "Players"
			
			var currNode:Object = _victimList.getFirst();
			
			while (currNode)
			{
				if (!Person(currNode.data).isInvincible())
				{
					Person(currNode.data).getHurt(damageStrength);
				}
				currNode = currNode.next;
			}
			
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if ((!_damageTicker.running) && (_victimList.getLength() != 0))
			{
				_damageTicker.start();
			}
			else if ((_damageTicker.running) && (_victimList.getLength() == 0))
			{
				_damageTicker.reset();
			}
			
			var position:b2Vec2 = _body.GetPosition();
			
			//if horizontal movment is enabled, turn around when we go past the left bound or right bound
			if (horizMovement)
			{
				if ((_inverted && position.x * _box2D.scale < leftBound) || (!_inverted && position.x * _box2D.scale > rightBound))
				{
					_inverted = !_inverted;
				}
			}
			
			//if vertical movment is enabled, turn around when we go past the up bound or down bound
			if (vertMovement)
			{
				if ((_up && position.y * _box2D.scale < upBound) || (!_up && position.y * _box2D.scale > downBound))
				{
					_up = !_up;
				}
			}
			
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (!_hurt)
			{
				if (horizMovement)
				{
					velocity.x = _inverted ? -speed : speed;
				}
				else
				{
					velocity.x = 0;
				}
				if (vertMovement)
				{
					velocity.y = _up ? -speed : speed;
				}
				else
				{
					velocity.y = 0;
				}
			}
			else
			{			
				velocity.x = 0;
				velocity.y = 0;
			}
			
			updateAnimation();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("GoodGuys", "BadGuys");
			
			_goodGuySensorFixtureDef = new b2FixtureDef();
			_goodGuySensorFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_goodGuySensorFixtureDef.isSensor = true;
			_goodGuySensorFixtureDef.shape = _fixtureDef.shape;
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			_goodGuySensorFixture = body.CreateFixture(_goodGuySensorFixtureDef);
		}
		
		override protected function endHurtState():void
		{
			_whenDead.dispatch();
			
			super.endHurtState();
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			//To be used for checking collisions
			//collider refers to a thing that collides with this Enemy
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			
			//This if statement is somewhat copied and pasted from the orignal Enemy class, with the addition
			//of a few extra things to handle score and being killed only when the correct ammo hits it
			if ((collider is _enemyClass) && (name == Game.headsUp.getCurrWeaponArrayInfo().kills))
			{
				hurt();
			}
			
			else if (collider is Person)
			{
				if (!Person(collider).isInvincible())
				{
					Person(collider).getHurt(damageStrength);
				}
				_victimList.append(collider);
			}

			//The following three if-statements are copied and pasted from the original Enemy class
			//(except for the if-statement within the third if-statement)
			//They handle the collisions that are NOT collisions with fired ammo
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

				if (collider is Platform)
				{
					if (horizMovement && (collisionAngle == 0 || collisionAngle == 180))
					{
						_inverted = !_inverted;
					}
					if (vertMovement && (collisionAngle == 90 || collisionAngle == -90))
					{
						_up = !_up;
					}

				}

			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (collider is Person)
			{
				_victimList.removeData(collider);
			}
		}
		
		public function increaseGameScore():void
		{
			Game._score += 10;
		}
		
		public function clone(newPosX:Number=NaN, newPosY:Number=NaN):void
		{
			var cloneParams:Object = _params;
			
			if (newPosX)
			{
				cloneParams.x = newPosX;
			}
			
			if (newPosY)
			{
				cloneParams.y = newPosY;
			}
			
			_whichLevel.add(new GenericEnemy(name, _whichLevel, cloneParams));
		}
	}

}