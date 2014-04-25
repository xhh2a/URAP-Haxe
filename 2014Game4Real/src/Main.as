package 
{
	import citrus.core.starling.StarlingCitrusEngine;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Main extends StarlingCitrusEngine 
	{
		
		public function Main():void 
		{
			
		}
		override public function initialize():void
		{
			setUpStarling(true);
		}
		override public function handleStarlingReady():void
		{
			state = new Game();
		}
	}
	
}