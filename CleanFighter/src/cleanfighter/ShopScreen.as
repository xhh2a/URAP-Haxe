package cleanfighter 
{
	import citrus.core.starling.StarlingState;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.display.Button;
	import starling.textures.Texture;
	import citrus.core.CitrusEngine;
	/**
	 * ...
	 * @author Kevin
	 */
	public class ShopScreen extends StarlingState
	{
		protected var _nextState:StarlingState;
		
		public function ShopScreen(stateAfterLeaveShop:StarlingState) 
		{
			super();
			
			_nextState = stateAfterLeaveShop;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			addChild(new TextField(stage.stageWidth, 100, "Shop", "Verdana", 40));
			
			var items:Array = [new Sprite(), new Sprite(),
				new Sprite(), new Sprite(),
				new Sprite(), new Sprite(),
				new Sprite(), new Sprite()];
	
			items[0].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.soap(), true, false, 2), "Soap"));
			items[1].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Two"));
			items[2].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Three"));
			items[3].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Four"));
			items[4].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Five"));
			items[5].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Six"));
			items[6].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Seven"));
			items[7].addChild(new Button(Texture.fromBitmap(new EmbeddedAssets.dirtyHand(), true, false, 2), "Eight"));

			items[0].getChildAt(0).textBounds = newTextBound(items[0].getChildAt(0).textBounds);
			items[1].getChildAt(0).textBounds = newTextBound(items[1].getChildAt(0).textBounds);
			items[2].getChildAt(0).textBounds = newTextBound(items[2].getChildAt(0).textBounds);
			items[3].getChildAt(0).textBounds = newTextBound(items[3].getChildAt(0).textBounds);
			items[4].getChildAt(0).textBounds = newTextBound(items[4].getChildAt(0).textBounds);
			items[5].getChildAt(0).textBounds = newTextBound(items[5].getChildAt(0).textBounds);
			items[6].getChildAt(0).textBounds = newTextBound(items[6].getChildAt(0).textBounds);
			items[7].getChildAt(0).textBounds = newTextBound(items[7].getChildAt(0).textBounds);
			
			items[0].addEventListener(Event.TRIGGERED, buyAction("soap", 10));
			items[1].addEventListener(Event.TRIGGERED, buyAction("thingy", 22));
			items[2].addEventListener(Event.TRIGGERED, buyAction("blah", 32));
			items[3].addEventListener(Event.TRIGGERED, buyAction("rawr", 432));
			items[4].addEventListener(Event.TRIGGERED, buyAction("grr", 543));
			items[5].addEventListener(Event.TRIGGERED, buyAction("yeah", 342));
			items[6].addEventListener(Event.TRIGGERED, buyAction("ooga booga", 111));
			items[7].addEventListener(Event.TRIGGERED, buyAction("stuff", 43));
			
			items[0].x = stage.stageWidth / 4;
			items[0].y = 100;
			items[1].x = 10 + items[0].x + items[0].getChildAt(0).width;
			items[1].y = 100;
			items[2].x = 10 + items[1].x + items[1].getChildAt(0).width;
			items[2].y = 100;
			items[3].x = 10 + items[2].x + items[2].getChildAt(0).width;
			items[3].y = 100;
			items[4].x = items[0].x;
			items[4].y = 10 + items[0].y + items[0].getChildAt(0).height;
			items[5].x = 10 + items[4].x + items[4].getChildAt(0).width;;
			items[5].y = 10 + items[1].y + items[1].getChildAt(0).height;
			items[6].x = 10 + items[5].x + items[5].getChildAt(0).width;;
			items[6].y = 10 + items[2].y + items[2].getChildAt(0).height;
			items[7].x = 10 + items[6].x + items[6].getChildAt(0).width;
			items[7].y = 10 + items[3].y + items[3].getChildAt(0).height;
			
			for each (var item:Sprite in items)
			{
				addChild(item);
			}
			
			var exitShopButton:Button = new Button(Texture.fromBitmap(new EmbeddedAssets.checkmark(), true, false, 4), "Exit shop");
			exitShopButton.x = 100;
			exitShopButton.y = stage.stageHeight - exitShopButton.height - 30;
			exitShopButton.textBounds = newTextBound(exitShopButton.textBounds);
			exitShopButton.addEventListener(Event.TRIGGERED, exitShopAction);
			addChild(exitShopButton);
		}
		
		protected function newTextBound(textBound:Rectangle):Rectangle
		{
			return new Rectangle(0, (textBound.height / 2) + 10, textBound.width, textBound.height);
		}
		
		protected function buyAction(itemName:String, price:Number):Function
		{
			return function(event:Event):void
			{
				if (Game._score >= price)
				{
					trace("bought " + itemName + " for " + price + " dollars");
					Game._score -= price;
				}
				else
				{
					trace("not enough money to buy " + itemName);
				}
			}
		}
		
		protected function exitShopAction(event:Event):void
		{
			CitrusEngine.getInstance().state = _nextState;
		}
	}

}