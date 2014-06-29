package
{
	import flash.system.Capabilities;
	
	import cn.sharesdk.ane.PlatformID;
	import cn.sharesdk.ane.ShareSDKExtension;
	
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MKWelcome extends Sprite
	{
		public function MKWelcome()
		{
			super();
			if(stage)
			{
				onAdded();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}
		
		private function onAdded(e:Event = null):void
		{
			new MetalWorksMobileTheme();
			
			var startBtn:Button = new Button();
			startBtn.validate();
			startBtn.name = "start";
			startBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			startBtn.alignPivot();
			startBtn.label = "开始游戏";
			startBtn.x = stage.stageWidth/2 - startBtn.width/2;
			startBtn.y = stage.stageHeight/2 - startBtn.height/2;
			addChild(startBtn);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase == TouchPhase.ENDED)
			{
				var child:DisplayObject = getChildByName("start");
				child.removeFromParent(true);
				var game:MKGame = new MKGame();
				addChild(game);
			}
		}
	}
}