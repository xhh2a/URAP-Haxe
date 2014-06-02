package cleanfighter
{
	import citrus.core.starling.StarlingCitrusEngine
	import starling.core.Starling;
	
	
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
			Starling.multitouchEnabled = true;
			
			//set the argument inside to true to enable debug mode, otherwise set to false (or leave blank) for non-debug mode
			setUpStarling(false);
		}
		
		override public function handleStarlingReady():void
		{
			state = new Game();
		}
	}
	
}