package cleanfighter 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.utils.Dictionary;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class HeadsUpDisplay extends Sprite
	{
		protected var weaponToImageDict:Dictionary;
		protected var weaponImg:Image;
		protected var weaponArray:Array;
		protected var boxContainer:Sprite;
		
		//The HeadsUpDisplay will show the weapon the person is currently wielding, which will be determined by whatever is stored in
		//the weaponToImageDict
		public function HeadsUpDisplay(xCoordinate:Number, yCoordinate:Number, width:Number, height:Number, thickness:Number=1) 
		{
			//creates four lines to make a box
			var upperHorizBoxLine:Quad = new Quad(width, thickness, 0xff0000);
			upperHorizBoxLine.x = xCoordinate;
			upperHorizBoxLine.y = yCoordinate;
			var lowerHorizBoxLine:Quad = new Quad(width, thickness, 0xff0000);
			lowerHorizBoxLine.x = upperHorizBoxLine.x;
			lowerHorizBoxLine.y = upperHorizBoxLine.y + height;
			var leftVertBoxLine:Quad = new Quad(thickness, height, 0xff0000);
			leftVertBoxLine.x = upperHorizBoxLine.x;
			leftVertBoxLine.y = upperHorizBoxLine.y;
			var rightVertBoxLine:Quad = new Quad(thickness, height + thickness, 0xff0000);
			rightVertBoxLine.x = leftVertBoxLine.x + width;
			rightVertBoxLine.y = leftVertBoxLine.y;
			
			boxContainer = new Sprite();
			boxContainer.addChild(upperHorizBoxLine);
			boxContainer.addChild(lowerHorizBoxLine);
			boxContainer.addChild(leftVertBoxLine);
			boxContainer.addChild(rightVertBoxLine);
			addChild(boxContainer);
			
			//putting weapon images in our weaponToImageDict
			//weaponToImageDict = new Dictionary();
			//weaponToImageDict["soap"] = Image.fromBitmap(new EmbeddedAssets.soap());
			//weaponToImageDict["soap"].width *= 0.35;
			//weaponToImageDict["soap"].height *= 0.35;
			//weaponToImageDict["bug spray"] = Image.fromBitmap(new EmbeddedAssets.bugSprayHUD());
			
			//TODO: instead of the above dict stuff, use indexed array below and store object
			//that stores img and string (the name of the weapon)
			
			//initializing our weaponArray
			weaponArray = new Array( { img: Image.fromBitmap(new EmbeddedAssets.soap()), name: "soap" } );
			weaponArray[0].img.width *= 0.35;
			weaponArray[0].img.height *= 0.35;
			weaponArray[1] = { img: Image.fromBitmap(new EmbeddedAssets.bugSprayHUD()), name: "bug spray" };
			weaponArray[1].img.width *= 0.25;
			weaponArray[1].img.height *= 0.25;
			
			//putting the image of the default weapon (the soap) into the box
			weaponImg = weaponArray[0].img;
			weaponImg.alpha = 0.5;
			weaponImg.x = xCoordinate + 5; //making the weapon image be 5 pixels right of the top-left corner of the box
			weaponImg.y = yCoordinate + 10; //making the weapon image be 10 pixels below the top-left corner of the box
			boxContainer.addChild(weaponImg);
		}
		
		//will change the displayed weapon in the box
		public function changeDisplayedWeapon():void
		{
			
		}
		
	}

}