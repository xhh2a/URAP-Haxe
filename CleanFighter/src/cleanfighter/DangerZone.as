package cleanfighter 
{
	import Box2D.Dynamics.b2Body
	/**
	 * ...
	 * @author Kevin
	 */
	public class DangerZone extends GenericEnemy
	{
		
		public function DangerZone(name:String, passedInLevel:Level, params:Object) 
		{
			super(name, passedInLevel, params);
			
			horizMovement = false;
			vertMovement = false;
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.type = b2Body.b2_staticBody;
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			_fixtureDef.isSensor = true;
		}
	}

}