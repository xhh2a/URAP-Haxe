package cleanfighter 
{
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author Kevin
	 */
	public class DangerSource extends GenericEnemy
	{
		protected var _productThatGetsProduced:GenericEnemy;
		protected var _productTimer:Timer;
		public var productionPoints:Array;
		public var productionDelayTime:Number;
		
		public function DangerSource(name:String, passedInLevel:Level, productThatGetsProduced:GenericEnemy, params:Object=null) 
		{
			super(name, passedInLevel, params);
			
			_productThatGetsProduced = productThatGetsProduced;
			if (!productionDelayTime)
			{
				productionDelayTime = 3000;
			}
			_productTimer = new Timer(productionDelayTime);
			_productTimer.start();
			_productTimer.addEventListener(TimerEvent.TIMER, periodicProduceProduct);
			
			if (!productionPoints)
			{
				productionPoints = new Array();
				productionPoints.push(new Point(x + width, y - (height / 2)));
			}
		}
		
		public function produceProduct():void
		{
			for each (var productionPoint:Point in productionPoints)
			{
				_productThatGetsProduced.clone(productionPoint.x, productionPoint.y);
			}
		}
		
		public function periodicProduceProduct(event:TimerEvent):void
		{
			produceProduct();
		}
		
	}

}