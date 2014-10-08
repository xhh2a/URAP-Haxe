package cleanfighter 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class HeadsUpDisplay extends Sprite
	{
		protected var weaponImg:Image;
		protected var weaponArray:Array;
		protected var currWeaponArrayIndex:Number;
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
			
			
			//initializing our weaponArray
			weaponArray = new Array( { img: Image.fromBitmap(new EmbeddedAssets.soap()), actualImg: Image.fromBitmap(new EmbeddedAssets.soap()), name: "soap", kills: "germ" } );
			weaponArray[0].img.width *= 0.35;
			weaponArray[0].img.height *= 0.35;
			(weaponArray[0].img).x = xCoordinate + 5;
			(weaponArray[0].img).y = xCoordinate + 10;
			weaponArray[1] = { img: Image.fromBitmap(new EmbeddedAssets.bugSprayHUD()), actualImg: Image.fromBitmap(new EmbeddedAssets.sprayCloud), name: "bug spray", kills: "mosquito" };
			weaponArray[1].img.width *= 0.25;
			weaponArray[1].img.height *= 0.25;
			(weaponArray[1].img).x = xCoordinate + 5;
			(weaponArray[1].img).y = xCoordinate + 10;
			
			//putting the image of the default weapon (the soap) into the box
			weaponImg = weaponArray[0].img;
			weaponImg.alpha = 0.5;
			boxContainer.addChild(weaponImg);
			currWeaponArrayIndex = 0;
		}
		
		//will change the displayed weapon in the box
		public function changeDisplayedWeapon():void
		{
			var updatedIndex:Number = currWeaponArrayIndex + 1;

			if (updatedIndex < weaponArray.length)
			{
				currWeaponArrayIndex = updatedIndex;				
			}
			else
			{
				currWeaponArrayIndex = 0;
			}
			
			weaponImg = weaponArray[currWeaponArrayIndex].img;
			boxContainer.removeChildAt(4);
			boxContainer.addChild(weaponImg);
		}
		
		public function getCurrWeaponArrayInfo():Object
		{
			return weaponArray[currWeaponArrayIndex];
		}
	}

}