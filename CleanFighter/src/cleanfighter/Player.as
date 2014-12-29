package cleanfighter 
{
	import citrus.objects.platformer.box2d.Hero;
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
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Player extends Hero
	{
		//TODO: make spray cloud "go through" stuff instead of being "just a block"
		
		protected const _reloadTime:uint = 1500;
		protected var _canFire:Boolean;
		
		public static var _origHealth:Number = 100;
		public static var _currHealth:Number;
		
		protected var _shotHole:Point;
		
		protected var _shotWidth:Number;		
		protected var _shotHeight:Number;
		
		protected var _currWeaponName:String;
		
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
			
			maxVelocity = 3;
			_canFire = true;
			
			_currHealth = _origHealth;	
			_shotHole = new Point(40, -30);		
			
			//set these to the width and height of the ammo's view (for simplicity, for now, we'll have all ammo be the same size)
			_shotWidth = 64;
			_shotHeight = 41.5;
			
			_currWeaponName = Game.headsUp.getCurrWeaponArrayInfo().name;
		}
		
		//TODO: make a "cloud" type for bug spray
		//look up the maskbits filter
		//http://www.aurelienribon.com/blog/2011/07/box2d-tutorial-collision-filtering/
		protected function fire():void
		{			
			//missile type weapons
			if (_currWeaponName == "soap")
			{
				var missile:Missile;

				if (_inverted)
				{					
					missile = new Missile("Missile", { speed: -(maxVelocity + 2), x: x - width - _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight) } );
				}
				else
				{					
					missile = new Missile("Missile", { speed: maxVelocity + 2, x: x + width + _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight) } );
				}
				
				_canFire = false;
				setTimeout(canFire, _reloadTime);
				
				_ce.state.add(missile);
				missile.onExplode.addOnce(_damage);
			}
			//spray type weapons
			else if (_currWeaponName == "bug spray")
			{
				var spray:Missile;

				if (_inverted)
				{
					spray = new Missile("Spray", { speed: -4, x: x - width - _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight) } );
				}
				else
				{
					spray = new Missile("Spray", { speed: 4, x: x + width + _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight) } );
				}
				
				_canFire = false;
				setTimeout(canFire, _reloadTime);
				_ce.state.add(spray);
				spray.onExplode.addOnce(_damage);
			}
			
			
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

				var leftPressed:Boolean = false;
				var rightPressed:Boolean = false;
				var upPressed:Boolean = false;
				var downPressed:Boolean = false;
				
				if (_ce.input.isDoing("right", inputChannel))
				{
					velocity.x += 1;
					rightPressed = true;
				}
				
				if (_ce.input.isDoing("left", inputChannel))
				{
					velocity.x -= 1;
					leftPressed = true;
				}
				
				if (_ce.input.isDoing("down", inputChannel))
				{
					velocity.y += 1;
					downPressed = true;
				}
				
				if (_ce.input.isDoing("up", inputChannel))
				{
					velocity.y -= 1;
					upPressed = true;
				}
				
				if (_ce.input.justDid("switch weapon", inputChannel))
				{
					Game.headsUp.changeDisplayedWeapon();
					_currWeaponName = Game.headsUp.getCurrWeaponArrayInfo().name;
				}
				
				if (!rightPressed && velocity.x > 0)
				{
					velocity.x -= 1;
					if (velocity.x < 0)
					{
						velocity.x = 0;
					}
				}
				else if (!leftPressed && velocity.x < 0)
				{
					velocity.x += 1;
					if (velocity.x > 0)
					{
						velocity.x = 0;
					}
				}
				if (!downPressed && velocity.y > 0)
				{
					velocity.y -= 1;
					if (velocity.y < 0)
					{
						velocity.y = 0;
					}
				}
				else if (!upPressed && velocity.y < 0)
				{
					velocity.y += 1;
					if (velocity.y > 0)
					{
						velocity.y = 0;
					}
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
				if (velocity.y > (maxVelocity))
				{
					velocity.y = maxVelocity;
				}
				else if (velocity.y < ( -maxVelocity))
				{
					velocity.y = -maxVelocity;
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
			//Everything here was from the Citrus Engine source code, except I took some stuff out and changed a few things
			
			var prevAnimation:String = _animation;

			var walkingSpeed:Number = getWalkingSpeed();
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();

			if (velocity.x < -acceleration)
			{
				_inverted = true;
				_animation = "walk";
			}
			else if (velocity.x > acceleration)
			{
				_inverted = false;
				_animation = "walk";
			}
			else if ((velocity.y > acceleration) || (velocity.y < -acceleration))
			{
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