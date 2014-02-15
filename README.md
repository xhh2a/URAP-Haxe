URAP-Haxe
=========

Rewrite of the URAP game project with Haxe

## Development Setup
* Download Haxe and Install <pre>http://haxe.org/download</pre>
* Open up a terminal (Shift+Right Click on Windows to get a 'Open a Command Line Here' option)
* Install OpenFl via terminal. <pre>http://www.openfl.org/download/</pre>
* Install HaxeFlixel via terminal. <pre>haxelib install flixel</pre>
* Download FlashDevelop **4.4.3** or above for Windows <pre>http://www.flashdevelop.org/</pre>
* OR Download Sublime Text for Mac/Linux <pre>http://haxeflixel.com/wiki/installing-sublime-text</pre>
* Download Awe6 Framework. <pre>haxelib install awe6</pre>
* Git Clone the new project
* Open the OpenFl.hxproj with FlashDevelop, use as you would Eclipse OR modify the source code under src

## Documentation
###Haxe Syntax and Built-ins.
*Make sure to only use built-ins that are supported for multiple platforms!*
<pre>http://haxe.org/doc</pre>

###OpenFl Library Documentation:
*Unfortunately the best documentation is usually found via google or looking at the source code, overall worse than HaxeFlixel*
<br/>Sample Code can be found at the OpenFl Github
https://github.com/openfl/openfl-samples

###Documentation On Classes:
*See the wiki for documentation on classes

###Design Notes:
* Haxe does not have inheritance of static [] in child. This is why we are using a very flat structure without many children (aka breaking OOP).<br/>
* You should initialize everything once from the XML assets to reduce disk I/O, then create a template for everything you need in AssetManager. Then you should create new instances of something by calling .getCopy()
* There are some predefined Lambda functions for things such as List.contains.
