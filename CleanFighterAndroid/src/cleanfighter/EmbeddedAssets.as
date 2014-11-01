package cleanfighter 
{
	/**
	 * ...
	 * @author Kevin
	 */
	public class EmbeddedAssets 
	{
		
		[Embed(source = "/../assets/circle.png")]
		public static const circleImg:Class;
		
		[Embed(source = "/../assets/playerSheet.png")]
		public static const playerSheet:Class;
		
		[Embed(source = "/../assets/playerSheet.xml", mimeType="application/octet-stream")]
		public static const playerSheetXml:Class;
		
		[Embed(source = "/../assets/lameBackground.png")]
		public static const background:Class;
		
		[Embed(source = "/../assets/soap.png")]
		public static const soap:Class;
		
		[Embed(source = "/../assets/germ.png")]
		public static const germ:Class;
	}

}