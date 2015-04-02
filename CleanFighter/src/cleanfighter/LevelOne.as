package cleanfighter 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import citrus.view.starlingview.AnimationSequence;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Kevin
	 */
	public class LevelOne extends Level
	{
		
		public function LevelOne() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var testDirtySpot:DangerZone = new DangerZone("testDirtySpot", this, { x: 300, y: 550, width: 254, height: 233, damageStrength: 2, view: EmbeddedAssets.dirtySpot } );
			add(testDirtySpot);
			
			//adding in the sprite sheet for our player
			//this will be used for displaying our player while showing the player's animated movements
			var playerSheetBitmap:Bitmap = new EmbeddedAssets.playerSheet();			
			var playerSheetTexture:Texture = Texture.fromBitmap(playerSheetBitmap, true, false, 2); //argument of 2 scales down by half
			var playerSheetXml:XML = XML(new EmbeddedAssets.playerSheetXml());
			var playerScaledWidth:Number = playerSheetXml.SubTexture[0].attribute("width") / playerSheetTexture.scale;
			var playerScaledHeight:Number = playerSheetXml.SubTexture[0].attribute("height") / playerSheetTexture.scale;
			_playerSheetAtlas = new TextureAtlas(playerSheetTexture, playerSheetXml);
			
			//creating and adding in the player
			var myPlayer:Player = new Player("myPlayer", { x: 200, y: 150, width: playerScaledWidth, height: playerScaledHeight, view: new AnimationSequence(_playerSheetAtlas, ["walk", "idle"], "idle") } );
			add(myPlayer);
			
			//creates and adds coin
			var testCoin:GameCoin = new GameCoin("testCoin", { x: 300, y: 300, width: 50, height: 50, view: EmbeddedAssets.coin }, 150 );
			add(testCoin);
			
			//creates and adds a germ
			var germBitmap:Bitmap = new EmbeddedAssets.germ();
			var germTexture:Texture = Texture.fromBitmap(germBitmap, true, false, 3);
			add(new GenericEnemy("germ", this, { x: 500, y: 400, width: germTexture.width, height: germTexture.height, horizMovement: true, vertMovement: true, damageStrength: 10, view: germTexture } ));
			
			//creates and adds mosquito
			var mosquitoBitmap:Bitmap = new EmbeddedAssets.mosquito();
			var mosquitoTexture:Texture = Texture.fromBitmap(mosquitoBitmap, true, false, 4);
			add(new GenericEnemy("mosquito", this, { x: 600, y: 600, width: mosquitoTexture.width, height: mosquitoTexture.height, horizMovement: true, vertMovement: false, view: mosquitoTexture } ));
			
			//setting up the "camera", which makes the "scrolling" of the screen happen
			view.camera.setUp(myPlayer, new Rectangle(0, 0, 2 * stage.stageWidth, 2 * stage.stageHeight));
			view.camera.easing = new Point(1, 1);
			
			_killsNeeded = 2;
			_nextLevel = new LevelTwo();
		}
	}

}