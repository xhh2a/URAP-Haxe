package cleanfighter
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
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
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}