package cleanfighter 
{
	import citrus.core.starling.StarlingState;
	import citrus.view.starlingview.StarlingTileSystem;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import flash.display.Bitmap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import citrus.view.starlingview.AnimationSequence;
	import starling.display.BlendMode;
	/**
	 * ...
	 * @author Kevin
	 */
	public class Level extends Game
	{
		private var _levelKillCount:Number;
		protected var _killsNeeded:Number;
		protected var _nextState:StarlingState;
		
		public function Level()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//adding the background			
			var tileSprite:CitrusSprite = new CitrusSprite("Background", { x: 0, y: 0 } );
			var tiles:Array = new Array();
			for each (var element:* in EmbeddedAssets.grassArr)
			{
				tiles.push(element);
			}
			var tileSystem:StarlingTileSystem = new StarlingTileSystem(tiles);
			tileSystem.name = "tileSystem";
			tileSystem.init();
			tileSprite.view = tileSystem;
			tileSystem.blendMode = BlendMode.AUTO;
			add(tileSprite);
			
			//the "wall" that keeps our player from going off the bottom of the screen
			add(new Platform("BottomBound", { x: stage.stageWidth / 2, y: 2 * stage.stageHeight, width: stage.stageWidth * 4, height: 1 } ));
			
			//the "wall" that keeps our player from going off the left side of the screen
			add(new Platform("LeftBound", { x: 0, y: stage.stageHeight / 2, width: 1, height: 3 * stage.stageHeight } ));
			
			//the "wall" that keeps our player from going off the right side of the screen
			add(new Platform("RightBound", { x: 2 * stage.stageWidth, y: stage.stageHeight / 2, width: 1, height: 3 * stage.stageHeight } ));
			
			//the "wall" that keeps our player from going off the top of the screen
			add(new Platform("TopBound", { x: stage.stageWidth / 2, y: 0, width: 4 * stage.stageWidth, height: 140 } ));
			
			_levelKillCount = 0;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_levelKillCount >= _killsNeeded)
			{
				Game.removeVjAndVb();
				_engine.state = _nextState;
			}
		}
		
		public function isGoalDone():Boolean
		{
			return false;
		}
		
		
		public function increaseKillCount():void
		{
			_levelKillCount++;
		}
	}

}