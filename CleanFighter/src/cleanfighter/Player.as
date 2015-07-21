package cleanfighter 
{
	import citrus.core.CitrusObject;
	import citrus.objects.platformer.box2d.Hero;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.view.starlingview.AnimationSequence;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.Box2DPhysicsObject;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.display.DisplayObject;
	import starling.filters.BlurFilter;
	import flash.display.MovieClip;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Player extends Hero implements Person
	{		
		protected const _reloadTime:uint = 1500;
		protected const _invincibilityAfterHurtTime:uint = 2000;
		protected var _canFire:Boolean;
		protected var _isInvincible:Boolean;
		protected var _numberOfDangersTouching:Number;
		
		public static var _origHealth:Number = 100;
		public static var _currHealth:Number;
		
		protected var _shotHole:Point;
		
		protected var _shotWidth:Number;		
		protected var _shotHeight:Number;
		
		protected var _currWeaponName:String;
		protected var _currWeaponKills:String;
		
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
			
			maxVelocity = 3; //setting the maximum velocity we can travel at
			_canFire = true; //initially, we can go ahead and fire if we want
			_isInvincible = false; //setting ourselves to not be invincible
			_numberOfDangersTouching = 0; //counter to see how many dangers we're touching

			//if we have not already initialized health, initialized _currHealth to whatever _origHealth is
			if (!_currHealth)
			{
				_currHealth = _origHealth;	
			}
			
			//the location where our ammo comes out of (aka the location of the gun's barrel)
			_shotHole = new Point(40, -30);
			
			//set these to the width and height of the ammo's view (for simplicity, for now, we'll have all ammo be the same size)
			_shotWidth = 64;
			_shotHeight = 41.5;
			
			//setting our current weapon to be whatever is the current weapon set in the headsUp
			_currWeaponName = Game.headsUp.getCurrWeaponArrayInfo().name;
			
			_currWeaponKills = Game.headsUp.getCurrWeaponArrayInfo().kills;
		}
		
		public function isInvincible():Boolean
		{
			return _isInvincible;
		}

		protected function fire():void
		{			
			var missile:NonPushMissile;

			if (_inverted)
			{					
				missile = new NonPushMissile(_currWeaponName, { speed: -(maxVelocity + 2), explodeDuration: 0, x: x - width - _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight), kills: _currWeaponKills } );
			}
			else
			{					
				missile = new NonPushMissile(_currWeaponName, { speed: maxVelocity + 2, explodeDuration: 0, x: x + width + _shotHole.x, y: y + _shotHole.y, width: _shotWidth, height: _shotHeight, view: Game.headsUp.createNewImgInstance(NaN, _shotWidth, _shotHeight), kills: _currWeaponKills } );
			}
			
			_canFire = false;
			setTimeout(canFire, _reloadTime);
			
			_ce.state.add(missile);
			missile.onExplode.addOnce(_damage);
			
			
		}
		
		//Sets _canFire to true
		//The only reason why we have this here is so that we can use it with the setTimeout function, since setTimeout
		//requires that we pass in a function
		protected function canFire():void
		{
			_canFire = true;
		}
		
		//Essentially kills and removes this Player
		override public function destroy():void
		{
			clearTimeout(_reloadTime);
			view = null;
			
			super.destroy();
		}
		
		//To be used when we shoot ammo; when ammo hits something, it deals damage (if any)
		//And when I say "deals damage", I mean kill
		//This is copied and pasted from Citrus Engine's built in Cannon class
		protected function _damage(missile:Missile, contact:Box2DPhysicsObject):void
		{
			if (contact != null)
			{
				onGiveDamage.dispatch(contact);
			}
		}
		
		//To be passed into a setTimeout call
		//Example usage: setTimeout(stopInvincibility, timeInMillisecondsThatInvincibilityLasts);
		protected function stopInvincibility():void
		{
			_isInvincible = false;
			
			if (view)
			{
				DisplayObject(view).filter = null;
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
			
			if ((_numberOfDangersTouching < 1) && view)
			{
				DisplayObject(view).filter = null;
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
					_currWeaponKills = Game.headsUp.getCurrWeaponArrayInfo().kills;
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
			
			//if we have a non-null _enemyClass (which, by default, is the case) AND if this Player collides with that whatever is
			//defined to be the _enemyClass (which, by default, is an Enemy, which of course, includes GenericEnemy)
			if (_enemyClass && (collider is _enemyClass))
			{
				//if this Player is currently not invincible, then the Player gets hurt
				if (!_isInvincible)
				{
					_numberOfDangersTouching++;
					if (view)
					{
						DisplayObject(view).filter = BlurFilter.createGlow(0xff0000);
					}
				}
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			//if we have a non-null _enemyClass (which, by default, is the case) AND if this Player collides with that whatever is
			//defined to be the _enemyClass (which, by default, is an Enemy, which of course, includes GenericEnemy)
			if (_enemyClass && (collider is _enemyClass))
			{
				//if this Player is currently not invincible, then the Player gets hurt
				if (!_isInvincible)
				{
					_numberOfDangersTouching--;
				}
			}
		}
		
		override public function hurt():void
		{
			getHurt();
		}		
		
		public function getHurt(hurtAmount:Number=1):void
		{
			_currHealth -= hurtAmount;
		}
		
		override protected function updateAnimation():void
		{
			//Everything here was from the Citrus Engine source code, except I took some stuff out
			
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