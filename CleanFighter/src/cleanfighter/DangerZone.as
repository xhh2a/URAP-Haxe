package cleanfighter 
{
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Sensor;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.utils.Timer;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	/**
	 * ...
	 * @author Kevin
	 */
	public class DangerZone extends Sensor
	{
		private var _timer:Timer;
		private var _currentTime:Number;
		
		public function DangerZone(name:String, params:Object) 
		{
			super(name, params);
			_timer = new Timer(1000);
			updateCallEnabled = true;
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (collider is Hero)
			{
				_timer.start();
				_currentTime = 0;
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (collider is Hero)
			{
				_timer.stop();
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);

			if (_timer.running && (_timer.currentCount != _currentTime))
			{
				_currentTime = _timer.currentCount;
				
				Player._currHealth -= 10;
				if (Player._currHealth <= 0)
				{
					_timer.stop();
				}
			}
		}
	}

}