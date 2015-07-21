package cleanfighter 
{
	/**
	 * ...
	 * @author Kevin
	 */
	public class EmbeddedAssets 
	{
		//everything here is a bunch of images (and later, maybe sounds) that the game will use
		
		[Embed(source = "/../assets/playerSheet.png")]
		public static const playerSheet:Class;
		
		[Embed(source = "/../assets/playerSheet.xml", mimeType="application/octet-stream")]
		public static const playerSheetXml:Class;
		
		[Embed(source = "/../assets/greenGrass.jpg")]
		public static const grass:Class;
		public static const grassArr:Array = [[grass, grass, grass], [grass, grass, grass]];
		
		[Embed(source = "/../assets/coin.png")]
		public static const coin:Class;
		
		[Embed(source = "/../assets/dirtyspot.png")]
		public static const dirtySpot:Class;
		
		[Embed(source = "/../assets/cleanSoap.png")]
		public static const soap:Class;
		
		[Embed(source = "/../assets/dirtyHand.png")]
		public static const dirtyHand:Class;
		
		[Embed(source = "/../assets/mosquito.png")]
		public static const mosquito:Class;
		
		[Embed(source = "/../assets/bugsprayHUD.png")]
		public static const bugSprayHUD:Class;
		
		[Embed(source = "/../assets/spraycloud.png")]
		public static const sprayCloud:Class;
		
		[Embed(source = "/../assets/checkmark.png")]
		public static const checkmark:Class;
		
		[Embed(source = "/../assets/poop.png")]
		public static const poop:Class;
		
		[Embed(source = "/../assets/latrine.png")]
		public static const latrine:Class;
	}

}