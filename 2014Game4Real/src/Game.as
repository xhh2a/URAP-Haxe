package  
{
	import Box2D.Collision.b2AABB;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import starling.utils.AssetManager;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Kevin
	 */
	public class Game extends StarlingState
	{		
		public var assetManager:AssetManager;
		
		public function Game() 
		{
			//mandatory initializer
			super();
		}
		override public function initialize():void
		{
			//mandatory initializer
			super.initialize();
			
			assetManager = new AssetManager();
			assetManager.verbose = true;
			
			//the engine is the thing that runs the game
			var engine:CitrusEngine = CitrusEngine.getInstance();
			
			//accessing the keyboard controls and changing the default jump button from the space bar to the up arrow key
			var keyboard:Keyboard = engine.input.keyboard;
			keyboard.removeKeyActions(Keyboard.SPACE);
			keyboard.addKeyAction("jump", Keyboard.UP);
			
			//physics engine stuff for doing stuff like collisions, gravity, etc.
			var box2D:Box2D = new Box2D("The Box2D physics stuff");
			box2D.visible = false;
			add(box2D);
			
			assetManager.enqueue(EmbeddedAssets);
			
			//adding ground to stand on top of
			add(new Platform("Ground", { x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, height: 50 } ));
			
			//Creating the "hero" that we will control
			var circle:Hero = new Hero("Circle", { x: 200, y: 120, width: 50, height: 50, view: EmbeddedAssets.circleImg } );
			add(circle);
			
			//assetManager.enqueue("circle.json");
			//trace(assetManager.getObject('circle'));
			//var jsonLoader:JsonMaster = new JsonMaster("../assets/circle.json");
		}
	}

}