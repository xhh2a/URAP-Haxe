package cleanfighter 
{
	import Box2D.Common.Math.b2Vec2;
	import citrus.core.starling.StarlingState;
	import citrus.core.CitrusEngine;
	import citrus.view.starlingview.StarlingArt;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	import feathers.display.TiledImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import citrus.objects.CitrusSprite;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingTileSystem;
	import starling.display.BlendMode;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.input.controllers.starling.VirtualButton;
	
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class Game extends StarlingState
	{
		//For the stuff that I made static: the reason I made them static is so we can "reuse" those things
		//Later on, I'm planning on putting in a check in the initialize() function that checks to see
		//if those static things have been initialized yet; if they're already initialized, we don't initialize them again
		
		protected static var _engine:CitrusEngine; //storing reference to game engine
		protected var _playerSheetAtlas:TextureAtlas; //texture atlas is a collection of smaller textures in one big image
		
		protected var gameTimer:Timer; //the timer that keeps track of time elapsed
		protected var currentTime:int; //variable that we'll use to compare with gameTimer.currentCount to keep track of each tick of the gameTimer
		
		public static var _score:Number; //score we got for the game (the number of points we have)
		protected var _healthAndScoreText:TextField; //text that displays the health and score we have
		
		//virtual joystick and button (for controlling in Android when that version gets completed)
		protected static var vj:VirtualJoystick;
		protected static var vb:VirtualButton;
		
		//keyboard control for computer keyboard control
		protected static var keyboard:Keyboard;
		
		//lets you know when game is over
		protected static var gameOver:Boolean;
		
		//see HeadsUpDisplay
		public static var headsUp:HeadsUpDisplay;
		
		public function Game() 
		{
			//mandatory initializer
			super();
			
		}
		override public function initialize():void
		{
			//mandatory initializer
			super.initialize();
			
			//Note: for the following if-statements, when you see "if (!something)", where "something" is some object,
			//that means "if something is not already initialized"
			//the purpose of these if-statements is so that we don't initialize stuff we already have initialized
			
			if (!vj)
			{
				//adding an on-screen joystick to the screen
				vj = new VirtualJoystick("joystick",{radius:100, x: 100, y: stage.stageHeight - 100});
				vj.circularBounds = true;
			}
			
			if (!vb)
			{
				//adding an on-screen "shoot" button to the screen
				vb = new VirtualButton("button",{buttonradius:40, x: stage.stageWidth - 100, y: stage.stageHeight - 100});
				vb.buttonAction = "shoot";
			}
			
			if (!_engine)
			{
				//the engine is the thing that runs the game
				_engine = CitrusEngine.getInstance();
			}
			
			if (!keyboard)
			{
				//accessing the keyboard controls and changing the default jump button from the space bar to the up arrow key
				//and then setting the space bar to be the button you press to shoot
				keyboard = _engine.input.keyboard;
				keyboard.removeKeyActions(Keyboard.SPACE);
				keyboard.addKeyAction("shoot", Keyboard.SPACE);
				keyboard.addKeyAction("up", Keyboard.UP);
				keyboard.addKeyAction("down", Keyboard.DOWN);
				
				//setting the "C" key to be the key that you press to switch weapon
				keyboard.addKeyAction("switch weapon", Keyboard.C);
			}
			
			//physics engine stuff for doing stuff like collisions, gravity, etc.
			var box2D:Box2D = new Box2D("The Box2D physics stuff");
			box2D.visible = false; //set to true to see collision bounds (for debugging use); set to false to not see these bounds
			box2D.gravity = new b2Vec2(0, 0); //turning off gravity (because we don't want things to fall)
			add(box2D); //adding the physics engine stuff to the game
			
			//adding a green box to the top (for the HeadsUpDisplay)
			addChild(new Quad(stage.stageWidth, 70, 0x00ff00));
			
			if (!_score)
			{
				//initializing score
				_score = 0;
			}
			
			//creating the text to display our health and score and then adding that text to the screen
			_healthAndScoreText = new TextField(stage.stageWidth, 30, "Score: " + _score.toString() + ", Health: " + Player._currHealth);
			addChild(_healthAndScoreText);
			
			//initializing our HeadsUpDisplay and adding that to the screen
			headsUp = new HeadsUpDisplay(10, 10, 50, 50, 3);
			addChild(headsUp);
			
			//game is not over yet because we just started it!
			gameOver = false;

			//creating the gameTimer, where it will tick every 1000 milliseconds (which is 1 second)
			//then initializing currentTime and starting the gameTimer
			gameTimer = new Timer(1000);
			currentTime = 0;
			gameTimer.start();
		}
		
		public static function endGame():void
		{
			//at this point, we set gameOver to true because the game is over
			gameOver = true;
			
			//removing the virtual joystick and button because we don't need them anymore
			vj.destroy();
			vb.destroy();

			//removing the shoot command because if we didn't do this, we would be able to "shoot while we're dead"
			keyboard.removeAction("shoot");
			
			//doing the same for switch weapon command
			keyboard.removeAction("switch weapon");
		}
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);			

			//if the game is over, we replace _healthAndScoreText with "game over" text and then stop the timer
			//otherwise, we just update the score and health
			if (gameOver)
			{
				_healthAndScoreText.text = "GAME OVER!!! Your Final Score: " + _score.toString();
				gameTimer.stop();
			}
			else
			{
				_healthAndScoreText.text = "Score: " + _score.toString() + ", Health: " + Player._currHealth;
			}			
		}
	}

}