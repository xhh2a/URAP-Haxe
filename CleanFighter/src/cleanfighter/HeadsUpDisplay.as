package cleanfighter 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Kevin
	 */
	public class HeadsUpDisplay extends Sprite
	{
		protected var weaponImg:Image;
		protected var weaponQuantityText:TextField;
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
			
			//"groups" the four lines created above into a "container" that is then added to the screen for display
			boxContainer = new Sprite();
			boxContainer.addChild(upperHorizBoxLine);
			boxContainer.addChild(lowerHorizBoxLine);
			boxContainer.addChild(leftVertBoxLine);
			boxContainer.addChild(rightVertBoxLine);
			addChild(boxContainer);
			//TODO: create a removeWeapon function
			weaponArray = new Array();
			addWeapon(Image.fromBitmap(new EmbeddedAssets.soap()), EmbeddedAssets.soap, "soap", "dirty hand", 100, 0.15, xCoordinate + thickness + 2, yCoordinate + thickness + 2);
			addWeapon(Image.fromBitmap(new EmbeddedAssets.bugSprayHUD()), EmbeddedAssets.sprayCloud, "bug spray", "mosquito", 50, 0.15, xCoordinate + thickness + 2, yCoordinate + thickness + 2);
			
			//putting the image of the default weapon (the soap) into the box
			weaponImg = weaponArray[0].img;
			weaponQuantityText = new TextField(width, height, weaponArray[0].quantity.toString(), "Verdana", 12, 0xff0000, true);
			weaponQuantityText.x = width - weaponQuantityText.textBounds.width - thickness;
			weaponQuantityText.y = height - (1.5 * weaponQuantityText.textBounds.height) - thickness;
			boxContainer.addChild(weaponImg);
			boxContainer.addChild(weaponQuantityText);
			currWeaponArrayIndex = 0;
		}
		
		public function addWeapon(imgToAdd:Image, embeddedActualImgToAdd:Class, nameToAdd:String, killsToAdd:String, quantityToAdd:Number, scale:Number, xPosition:Number, yPosition:Number):void
		{
			var index:Number = weaponArray.push( { img: imgToAdd, embeddedActualImg: embeddedActualImgToAdd, name: nameToAdd, kills: killsToAdd, quantity: quantityToAdd } ) - 1;
			weaponArray[index].img.width *= scale;
			weaponArray[index].img.height *= scale;
			(weaponArray[index].img).x = xPosition;
			(weaponArray[index].img).y = yPosition;
		}
		
		public function removeWeapon(weaponName:String):void
		{			
			for (var i:Number = 0; i < weaponArray.length; i++)
			{
				if (weaponArray[i].name == weaponName)
				{
					weaponArray.splice(i, 1);
				}
			}
			refreshWeaponDisplay();
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
			
			refreshWeaponDisplay();
		}
		
		public function refreshWeaponDisplay():void
		{
			weaponImg = weaponArray[currWeaponArrayIndex].img;
			weaponQuantityText.text = weaponArray[currWeaponArrayIndex].quantity;
			boxContainer.removeChildAt(4);
			boxContainer.removeChildAt(4);
			boxContainer.addChild(weaponImg);
			boxContainer.addChild(weaponQuantityText);
		}
		
		//returns to you necessary properties about the weapon that is currently selected
		public function getCurrWeaponArrayInfo():Object
		{
			return weaponArray[currWeaponArrayIndex];
		}
		
		//returns to you the index of the weapon that is currently selected
		public function getCurrWeaponArrayIndex():Number
		{
			return currWeaponArrayIndex;
		}
		
		public function createNewImgInstance(index:Number=NaN, width:Number=NaN, height:Number=NaN):Image
		{
			if (isNaN(index))
			{
				index = currWeaponArrayIndex;
			}
			var imgToReturn:Image = Image.fromBitmap(new weaponArray[index].embeddedActualImg());
			
			if (!isNaN(width))
			{
				imgToReturn.width = width;
			}
			
			if (!isNaN(height))
			{
				imgToReturn.height = height;
			}
			
			return imgToReturn;
		}
	}

}