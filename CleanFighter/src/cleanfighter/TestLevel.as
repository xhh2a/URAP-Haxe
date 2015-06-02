package cleanfighter 
{
	import flash.display.Bitmap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import citrus.view.starlingview.AnimationSequence;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Kevin
	 */
	public class TestLevel extends Level
	{
		
		public function TestLevel() 
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
			
			var poopBitmap:Bitmap = new EmbeddedAssets.poop();
			var poopTexture:Texture = Texture.fromBitmap(poopBitmap, true, false, 2);
			add(new DangerSource("poop", this, new GenericEnemy("poop", this, { x: 100, y: 500, width: poopTexture.width, height: poopTexture.height, horizMovement: true, vertMovement: false, startingDirection: "right", view: poopTexture } ), { x: 100, y: 500, width: poopTexture.width, height: poopTexture.height, horizMovement: false, vertMovement: false, view: poopTexture }));

			
			_killsNeeded = 1;
			_nextState = new ShopScreen(new CompletionScreen());
		}
	}

}