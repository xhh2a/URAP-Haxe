package cleanfighter 
{
	import citrus.core.starling.StarlingState;
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	import flash.display.Bitmap;
	import starling.text.TextField;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import citrus.objects.CitrusSprite;
	
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
			
			vj = new VirtualJoystick("joystick",{radius:100, x: 100, y: stage.stageHeight - 100});
			vj.circularBounds = true;
			
			vb = new VirtualButton("button",{buttonradius:40, x: stage.stageWidth - 100, y: stage.stageHeight - 100});
			vb.buttonAction = "shoot";
			
			//the engine is the thing that runs the game
			_engine = CitrusEngine.getInstance();
			
			
			var playerSheetBitmap:Bitmap = new EmbeddedAssets.playerSheet();
			var playerSheetTexture:Texture = Texture.fromBitmap(playerSheetBitmap);
			var playerSheetXml:XML = XML(new EmbeddedAssets.playerSheetXml());
			_playerSheetAtlas = new TextureAtlas(playerSheetTexture, playerSheetXml);

			
			//accessing the keyboard controls and changing the default jump button from the space bar to the up arrow key
			//and then setting the space bar to be the button you press to shoot
			keyboard = _engine.input.keyboard;
			keyboard.removeKeyActions(Keyboard.SPACE);
			keyboard.addKeyAction("jump", Keyboard.UP);
			keyboard.addKeyAction("shoot", Keyboard.SPACE);
			
			//setting the "C" key to be the key that you press to switch weapon
			keyboard.addKeyAction("switch weapon", Keyboard.C);
			
			//adding the background
			add(new CitrusSprite("Background", { x: 0, y: -380, view: EmbeddedAssets.background } ));
			
			//physics engine stuff for doing stuff like collisions, gravity, etc.
			var box2D:Box2D = new Box2D("The Box2D physics stuff");
			box2D.visible = false;
			add(box2D);
			
			//adding ground to stand on top of
			add(new Platform("Ground", { x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth * 4, height: 50 } ));
			
			//the "wall" that keeps our player from going off the left side of the screen
			add(new Platform("LeftWall", { x: 0, y: stage.stageHeight / 2, width: 1, height: stage.stageHeight } ));
			
			//the "wall" that keeps our player from going off the right side of the screen
			add(new Platform("RightWall", { x: 2000, y: stage.stageHeight / 2, width: 1, height: stage.stageHeight } ));

			
			var myPlayer:Player = new Player("myPlayer", { x: 200, y: 120, width: 65, height: 220  } );
			myPlayer.view = new AnimationSequence(_playerSheetAtlas, ["idle", "walk"], "idle");
			add(myPlayer);
			
			view.camera.setUp(myPlayer, new Rectangle(0, 0, 2000, stage.stageHeight));
			
			_score = 0;
			_healthAndScoreText = new TextField(stage.stageWidth, 30, "Score: " + _score.toString() + ", Health: " + Player._currHealth);
			addChild(_healthAndScoreText);
			
			headsUp = new HeadsUpDisplay(10, 10, 50, 50, 3);
			addChild(headsUp);
			
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
					add(new AntiMarioEnemy("germ", { x: 500, y: 110, width: 183, height: 183, view: EmbeddedAssets.germ } ));
				}
				//trace(currentTime);
			}			
		}
	}

}