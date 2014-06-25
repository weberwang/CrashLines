package
{
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(frameRate="60"]
	public class main extends Sprite
	{
		private var mStarling:Starling;
		public function main()
		{
			super();
			var stageWidth:int  = 1024;
			var stageHeight:int = 768;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL, iOS);
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			//			var appDir:File = File.applicationDirectory;
			//			var assets:AssetManager = new AssetManager(scaleFactor);
			//			
			//			assets.verbose = Capabilities.isDebugger;
			//			assets.enqueue(
			//				appDir.resolvePath("../demo/assets/audio"),
			//				appDir.resolvePath(formatString("../demo/fonts/{0}x", scaleFactor)),
			//				appDir.resolvePath(formatString("../demo/textures/{0}x", scaleFactor))
			//			);
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			//			var backgroundClass:Class = scaleFactor == 1 ? Background : BackgroundHD;
			//			var background:Bitmap = new backgroundClass();
			//			Background = BackgroundHD = null; // no longer needed!
			//			
			//			background.x = viewPort.x;
			//			background.y = viewPort.y;
			//			background.width  = viewPort.width;
			//			background.height = viewPort.height;
			//			background.smoothing = true;
			//			addChild(background);
			
			// launch Starling
			
			mStarling = new Starling(Welcome, stage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
			mStarling.showStats = true;
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				//				removeChild(background);
				//				background = null;
				
				mStarling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(true); });
		}
				
	}
}