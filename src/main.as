package
{
	
	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", width="768", height="1024")]
	public class main extends Sprite
	{
		private var mStarling:Starling;
		public function main()
		{
			super();
			
			Starling.multitouchEnabled = true;
			
			var ios:Boolean = Capabilities.os.indexOf("ios") != -1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !ios;
			mStarling = new Starling(Welcome, stage);
			mStarling.addEventListener(Event.ROOT_CREATED, onCreateed);
		}
		
		private function onCreateed(e:Event):void
		{
			// TODO Auto Generated method stub
			mStarling.showStats = true;
			mStarling.start();
		}
	}
}