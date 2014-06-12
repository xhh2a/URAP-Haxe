package cleanfighter 
{
	import citrus.objects.platformer.box2d.Hero;
	import citrus.physics.box2d.Box2DShapeMaker;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import flash.geom.Point;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.Box2DPhysicsObject;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Player extends Hero
	{
		protected const _reloadTime:uint = 1500;
		protected var _canFire:Boolean;
		
		public static var _origHealth:Number = 100;
		public static var _currHealth:Number;
		
		protected var _shotHole:Point;
		
		protected var _shotWidth:Number;
		
		protected var _shotHeight:Number;
		
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
			
			_canFire = true;
			
			_currHealth = _origHealth;	
			_shotHole = new Point(40, -30);
			
			//set these to the width and height of the default ammo's view
			_shotWidth = 128;
			_shotHeight = 83;
		}
		
		protected function fire():void
		{
			var bomb:Bomb;

			if (_inverted)
			{
				trace("inverted");
				//edit this
				bomb = new Bomb("bomb", { speed: -4, x: x - width - _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: EmbeddedAssets.soap } );
			}
			else
			{
				trace("NOT inverted");

				trace("_width = " + _width);
				trace("width = " + width);
				trace("height = " + height);
				
				bomb = new Bomb("bomb", { speed: 4, x: x + width + _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: EmbeddedAssets.soap } );
			}
			
			_canFire = false;
			setTimeout(canFire, _reloadTime);
			_ce.state.add(bomb);
			bomb.onExplode.addOnce(_damage);
		}
		
		protected function canFire():void
		{
			_canFire = true;
		}
		
		override public function destroy():void
		{
			clearTimeout(_reloadTime);
			clearTimeout(_hurtTimeoutID);
			onJump.removeAll();
			onGiveDamage.removeAll();
			onTakeDamage.removeAll();
			onAnimationChange.removeAll();
			view = null;
			
			super.destroy();
		}
		
		protected function _damage(missile:Missile, contact:Box2DPhysicsObject):void
		{
			if (contact != null)
			{
				onGiveDamage.dispatch(contact);
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_currHealth <= 0)
			{
				Game.endGame();
				destroy();
			}
			
			// we get a reference to the actual velocity vector
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (controlsEnabled)
			{
				if (_canFire && _ce.input.justDid("shoot", inputChannel))
				{
					fire();
				}
				
				var moveKeyPressed:Boolean = false;
				
				if (_ce.input.isDoing("right", inputChannel))
				{
					velocity.Add(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDoing("left", inputChannel))
				{
					velocity.Subtract(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
				//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (_onGround && _ce.input.justDid("jump", inputChannel))
				{
					velocity.y = -jumpHeight;
					onJump.dispatch();
					_onGround = false; // also removed in the handleEndContact. Useful here if permanent contact e.g. box on hero.
				}
				
				if (_springOffEnemy != -1)
				{
					if (_ce.input.isDoing("jump", inputChannel))
					{
						velocity.y = -enemySpringJumpHeight;
					}
					else
					{
						velocity.y = -enemySpringHeight;
					}
					_springOffEnemy = -1;
				}
				
				//Cap velocities
				if (velocity.x > (maxVelocity))
				{
					velocity.x = maxVelocity;
				}
				else if (velocity.x < ( -maxVelocity))
				{
					velocity.x = -maxVelocity;
				}
			}
			
			updateAnimation();
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (_enemyClass && collider is _enemyClass)
			{
				hurt();

				//fling the hero
				var hurtVelocity:b2Vec2 = _body.GetLinearVelocity();
				hurtVelocity.y = -hurtVelocityY;
				hurtVelocity.x = hurtVelocityX;
				if (collider.x > x)
					hurtVelocity.x = -hurtVelocityX;
				_body.SetLinearVelocity(hurtVelocity);
			}

			//Collision angle if we don't touch a Sensor.
			if (contact.GetManifold().m_localPoint && !(collider is Sensor)) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{	
				var collisionAngle:Number = Math.atan2(contact.normal.y, contact.normal.x);

				if (collisionAngle >= Math.PI*.25 && collisionAngle <= 3*Math.PI*.25 ) // normal angle between pi/4 and 3pi/4
				{
					_groundContacts.push(collider.body.GetFixtureList());
					_onGround = true;
					updateCombinedGroundAngle();
				}
			}
		}
		
		override public function hurt():void
		{
			super.hurt();
			_currHealth -= 10;
		}
		
		override protected function updateAnimation():void
		{
			//Everything here was from the Citrus Engine source code, except I took some stuff out
			
			var prevAnimation:String = _animation;

			var walkingSpeed:Number = getWalkingSpeed();

			if (walkingSpeed < -acceleration)
			{
				_inverted = true;
				_animation = "walk";
			}
			else if (walkingSpeed > acceleration)
			{
				_inverted = false;
				_animation = "walk";
			}
			else
			{
				_animation = "idle";
			}

			if (prevAnimation != _animation)
			{
				onAnimationChange.dispatch();
			}
		}
	}
}