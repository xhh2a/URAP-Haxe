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
	import flash.display.MovieClip;
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
		
		protected var _engine:CitrusEngine;
		protected var _playerSheetAtlas:TextureAtlas;
		
		protected var gameTimer:Timer;
		protected var currentTime:int;
		
		public static var _score:Number;
		protected var _healthAndScoreText:TextField;
		
		protected static var vj:VirtualJoystick;
		protected static var vb:VirtualButton;
		protected static var keyboard:Keyboard;
		
		protected static var gameOver:Boolean;
		
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
			
			//adding an on-screen joystick to the screen
			vj = new VirtualJoystick("joystick",{radius:100, x: 100, y: stage.stageHeight - 100});
			vj.circularBounds = true;
			
			//adding an on-screen "shoot" button to the screen
			vb = new VirtualButton("button",{buttonradius:40, x: stage.stageWidth - 100, y: stage.stageHeight - 100});
			vb.buttonAction = "shoot";
			
			//the engine is the thing that runs the game
			_engine = CitrusEngine.getInstance();
			
			//adding in the sprite sheet for our player
			//this will be used for displaying our player while showing the player's animated movements
			var playerSheetBitmap:Bitmap = new EmbeddedAssets.playerSheet();			
			var playerSheetTexture:Texture = Texture.fromBitmap(playerSheetBitmap, true, false, 2); //argument of 2 scales down by half
			var playerSheetXml:XML = XML(new EmbeddedAssets.playerSheetXml());
			_playerSheetAtlas = new TextureAtlas(playerSheetTexture, playerSheetXml);
			trace("player sheet orig width is " + playerSheetBitmap.width);
			trace("player sheet orig height is " + playerSheetBitmap.height);
			
			//accessing the keyboard controls and changing the default jump button from the space bar to the up arrow key
			//and then setting the space bar to be the button you press to shoot
			keyboard = _engine.input.keyboard;
			keyboard.removeKeyActions(Keyboard.SPACE);
			keyboard.addKeyAction("shoot", Keyboard.SPACE);
			keyboard.addKeyAction("up", Keyboard.UP);
			keyboard.addKeyAction("down", Keyboard.DOWN);
			
			//setting the "C" key to be the key that you press to switch weapon
			keyboard.addKeyAction("switch weapon", Keyboard.C);
			
			//adding the background			
			var tileSprite:CitrusSprite = new CitrusSprite("Background", { x: 0, y: 0 } );
			var tiles:Array = EmbeddedAssets.grassArr;
			var tileSystem:StarlingTileSystem = new StarlingTileSystem(tiles);
			tileSystem.name = "tileSystem";
			tileSystem.init();
			tileSprite.view = tileSystem;
			add(tileSprite);
			
			//physics engine stuff for doing stuff like collisions, gravity, etc.
			var box2D:Box2D = new Box2D("The Box2D physics stuff");
			box2D.visible = true; //set to true to see collision bounds (for debugging use); set to false for not see these bounds
			box2D.gravity = new b2Vec2(0, 0); //turning off gravity (because we don't want things to fall)
			add(box2D);
			
			//the "wall" that keeps our player from going off the bottom of the screen
			add(new Platform("BottomBound", { x: stage.stageWidth / 2, y: 2 * stage.stageHeight, width: stage.stageWidth * 4, height: 1 } ));
			
			//the "wall" that keeps our player from going off the left side of the screen
			add(new Platform("LeftBound", { x: 0, y: stage.stageHeight / 2, width: 1, height: 3 * stage.stageHeight } ));
			
			//the "wall" that keeps our player from going off the right side of the screen
			add(new Platform("RightBound", { x: 2 * stage.stageWidth, y: stage.stageHeight / 2, width: 1, height: 3 * stage.stageHeight } ));
			
			//the "wall" that keeps our player from going off the top of the screen
			add(new Platform("TopBound", { x: stage.stageWidth / 2, y: 0, width: 4 * stage.stageWidth, height: 140 } ));

			
			addChild(new Quad(stage.stageWidth, 70, 0x00ff00));
			
			_score = 0;
			_healthAndScoreText = new TextField(stage.stageWidth, 30, "Score: " + _score.toString() + ", Health: " + Player._currHealth);
			addChild(_healthAndScoreText);
			
			headsUp = new HeadsUpDisplay(10, 10, 50, 50, 3);
			addChild(headsUp);
			
			var myPlayer:Player = new Player("myPlayer", { x: 200, y: 150, width: 32.5, height: 110  } );
			myPlayer.view = new AnimationSequence(_playerSheetAtlas, ["walk", "idle"], "idle");
			add(myPlayer);
			
			//setting up the "camera", which makes the "scrolling" of the screen happen
			view.camera.setUp(myPlayer, new Rectangle(0, 0, 2 * stage.stageWidth, 2 * stage.stageHeight));
			view.camera.easing = new Point(1, 1);			
			
			
			
			//add(new AntiMarioEnemy("germ", { x: 1000, y: 110, width: 183, height: 183, view: EmbeddedAssets.germ } )); //DELETE LATER
			
			gameOver = false;

			gameTimer = new Timer(1000);
			currentTime = 0;
			gameTimer.start();
		}
		public static function endGame():void
		{
			gameOver = true;
			
			//removing the virtual joystick and button because we don't need them anymore
			vj.destroy();
			vb.destroy();
			
			//removing the shoot command because if we didn't do this, we would be able to "shoot while we're dead"
			keyboard.removeAction("shoot");
		}
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);			

			if (gameOver)
			{
				_healthAndScoreText.text = "GAME OVER!!! Your Final Score: " + _score.toString();
			}
			else
			{
				_healthAndScoreText.text = "Score: " + _score.toString() + ", Health: " + Player._currHealth;
			}			
			
			if (currentTime != gameTimer.currentCount)
			{
				currentTime = gameTimer.currentCount;
				if (currentTime % 3 == 0)
				{
					//add(new AntiMarioEnemy("germ", { x: 500, y: 110, width: 183, height: 183, view: EmbeddedAssets.germ } ));
				}
				//trace(currentTime);
			}			
		}
	}

}