package cleanfighter 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import citrus.view.starlingview.AnimationSequence;
	import flash.display.Bitmap;
	
	import citrus.input.controllers.Keyboard;
	/**
	 * ...
	 * @author Kevin
	 */
	public class LevelTwo extends Level
	{
		
		public function LevelTwo() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//adding in the sprite sheet for our player
			//this will be used for displaying our player while showing the player's animated movements
			var playerSheetBitmap:Bitmap = new EmbeddedAssets.playerSheet();			
			var playerSheetTexture:Texture = Texture.fromBitmap(playerSheetBitmap, true, false, 2); //argument of 2 scales down by half
			var playerSheetXml:XML = XML(new EmbeddedAssets.playerSheetXml());
			var playerScaledWidth:Number = playerSheetXml.SubTexture[0].attribute("width") / playerSheetTexture.scale;
			var playerScaledHeight:Number = playerSheetXml.SubTexture[0].attribute("height") / playerSheetTexture.scale;
			_playerSheetAtlas = new TextureAtlas(playerSheetTexture, playerSheetXml);
			
			//creating and adding in the player
			var myPlayer:Player = new Player("myPlayer", { x: 300, y: 213, width: playerScaledWidth, height: playerScaledHeight, view: new AnimationSequence(_playerSheetAtlas, ["walk", "idle"], "idle") } );
			add(myPlayer);
			
			//setting up the "camera", which makes the "scrolling" of the screen happen
			view.camera.setUp(myPlayer, new Rectangle(0, 0, 2 * stage.stageWidth, 2 * stage.stageHeight));
			view.camera.easing = new Point(1, 1);

			
			_killsNeeded = 10;
			_nextLevel = new CompletionScreen();
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//if-statement that only allows stuff to be executed once every time tick
			if (currentTime != gameTimer.currentCount)
			{
				currentTime = gameTimer.currentCount;
				
				//spawn germ every 3 seconds
				if (currentTime % 3 == 0)
				{
					var germBitmap:Bitmap = new EmbeddedAssets.germ();
					var germTexture:Texture = Texture.fromBitmap(germBitmap, true, false, 3);
					add(new GenericEnemy("germ", this, { x: 101, y: 404, width: germTexture.width, height: germTexture.height, horizMovement: true, vertMovement: true, damageStrength: 10, view: germTexture } ));
				}
				
				//spawn mosquito every 4 seconds
				if (currentTime % 4 == 0)
				{
					var mosquitoBitmap:Bitmap = new EmbeddedAssets.mosquito();
					var mosquitoTexture:Texture = Texture.fromBitmap(mosquitoBitmap, true, false, 4);
					add(new GenericEnemy("mosquito", this, { x: 650, y: 900, width: mosquitoTexture.width, height: mosquitoTexture.height, horizMovement: true, vertMovement: true, view: mosquitoTexture } ));
				}
			}	
		}
		
	}

}