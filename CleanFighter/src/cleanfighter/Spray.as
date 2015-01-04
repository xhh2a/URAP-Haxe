package cleanfighter 
{
	import citrus.objects.platformer.box2d.Missile;
	import starling.display.Image;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Spray extends Missile
	{
		protected var timer:Timer;
		
		//assumes that the view passed in is an Image
		public function Spray(name:String, params:Object=null) 
		{
			super(name, params);
			timer = new Timer(500);
		}
		
		//In addition to doing what the original Missile class did, this class also makes it so that our Spray gradually fades
		//over time until the moment it disappears		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (!timer.running)
			{
				timer.start();
			}
			Image(view).alpha = 1 - ((timer.currentCount * timer.delay) / fuseDuration);
		}
		
	}

}