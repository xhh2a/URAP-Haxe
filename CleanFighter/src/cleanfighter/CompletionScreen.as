package cleanfighter 
{
	import citrus.core.starling.StarlingState;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Kevin
	 */
	public class CompletionScreen extends StarlingState
	{
		
		public function CompletionScreen() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//creates and adds the "you win" text
			addChild(new TextField(stage.stageWidth, 100, "You win! Your final score: " + Game._score, "Verdana", 40));
		}
	}

}