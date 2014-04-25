package  
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	/**
	 * ...
	 * @author Kevin
	 */
	public class JsonMaster 
	{
		//private var loader:URLLoader;
		public function JsonMaster(fileName:String) 
		{
			//var loader:URLLoader = new URLLoader(new URLRequest(fileName));
			trace(File.applicationDirectory.nativePath);
			trace(File.applicationStorageDirectory.nativePath);
			trace(File.applicationDirectory.resolvePath("../assets/circle.json").name);
			
		}
		
	}

}