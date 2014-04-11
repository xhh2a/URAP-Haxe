package  
{
	import Box2D.Collision.b2AABB;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	/**
	 * ...
	 * @author Kevin
	 */
	public class Game extends StarlingState
	{
		[Embed(source = "../assets/circle.png")]
		private var _circleImg:Class;
		
		public function Game() 
		{
			super();
		}
		override public function initialize():void
		{
			super.initialize();
			var box2D:Box2D = new Box2D("The Box2D physics stuff");
			box2D.visible = false;
			add(box2D);
			
			add(new Platform("Ground", { x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, height: 50 } ));
			
			var circle:Hero = new Hero("Circle", { x: 200, y: 120, width: 50, height: 50, view: _circleImg } );
			add(circle);
		}
	}

}