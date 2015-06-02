package cleanfighter 
{
	import citrus.objects.platformer.box2d.Missile;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	/**
	 * ...
	 * @author Kevin
	 */
	public class NonPushMissile extends Missile
	{
		
		public function NonPushMissile(name:String, params:Object) 
		{
			super(name, params);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.isSensor = true;
		}
		
		override public function handleBeginContact(contact:b2Contact):void {
			
			_contact = Box2DUtils.CollisionGetOther(this, contact);
			
			if (!contact.GetFixtureB().IsSensor())
			{
				explode();
			}
		}
	}

}