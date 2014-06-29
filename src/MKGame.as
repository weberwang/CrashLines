package
{
	import com.minko.delegate.IDirection;
	import com.minko.ui.MKDirectionControl;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import cn.sharesdk.ane.ShareSDKExtension;
	
	import feathers.controls.Label;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class MKGame extends Sprite implements IDirection
	{
		private var mCountX:int;
		private var mCountY:int; 
		private var mGridWidth:int = 4;
		private var mGridHeight:int = 4;
		private var mMaxX:int;
		private var mMinX:int;
		private var mMaxY:int;
		private var mMinY:int;
		private var mStartAX:int;
		private var mStartBX:int;
		private var mStartAY:int;
		private var mStartBY:int;
		
		
		private var _mGameOver:Boolean = false;
		private var mTowardA:String;
		private var mTowardB:String;
		
		private const RIGHT:String = "right";
		private const UP:String = "up";
		private const DOWN:String = "down";
		private const LEFT:String = "left";
		
		private var mNextAX:int = 0;
		private var mNextBX:int = 0;
		private var mNextBY:int = 0;
		private var mNextAY:int = 0;
		
		private var mSpeed:Number = 30;
		private var mTime:Timer;
		
		private var mPositionA:Vector.<Point>;
		private var mPositionB:Vector.<Point>;
		
		private var mBatch:QuadBatch;
		private var mTexture:Texture;
		
		private var GAP:int = 20;
		public function MKGame()
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
			setBlockTexture();
			initGridSize();
			restart();
			touchable = true;
			initUI();
			createStartTip();
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function initUI():void
		{
			// TODO Auto Generated method stub
			var controlA:MKDirectionControl = new MKDirectionControl();
			controlA.name = "A";
			controlA.x = GAP;
			controlA.y = stage.stageHeight - controlA.height - GAP;
			controlA.directionDelegate = this;
			addChild(controlA);
			
			var controlB:MKDirectionControl = new MKDirectionControl();
			controlB.name = "B";
			controlB.x = stage.stageWidth - controlB.width - GAP;
			controlB.y = stage.stageHeight - controlB.height - GAP;
			controlB.directionDelegate = this;
			addChild(controlB);
		}
		
		private function createStartTip():void
		{
			var timeLbl:Label = new Label();
			timeLbl.validate();
			timeLbl.alignPivot();
			timeLbl.text = "3";
			timeLbl.x = stage.stageWidth/2;
			timeLbl.y = stage.stageHeight/2;
			addChild(timeLbl);
			
			var fadeout:Tween = new Tween(timeLbl, 1);
			fadeout.repeatCount = 3;
			fadeout.scaleTo(2);
			fadeout.fadeTo(0);
			fadeout.onRepeatArgs = [timeLbl];
			fadeout.onRepeat = function (time:Label):void
			{
				time.text = (int(time.text) - 1).toString();
			};
			fadeout.onComplete = function (tween:Tween):void{
				onTouch();
				Starling.juggler.remove(tween);
			};
			fadeout.onCompleteArgs = [fadeout];
			Starling.juggler.add(fadeout);
		}
		
		private function setBlockTexture():void
		{
			// TODO Auto Generated method stub
			var sp:Shape = new Shape();
			var graphics:Graphics = sp.graphics;
			graphics.clear();
			graphics.drawRect(0, 0, mGridWidth, mGridHeight);
			graphics.endFill();
			var bitdata:BitmapData = new BitmapData(mGridHeight, mGridWidth);
			bitdata.draw(sp);
			mTexture = Texture.fromBitmapData(bitdata);
			bitdata.dispose();
			bitdata = null;
		
		}
		
		private function onTouch(e:TouchEvent = null):void
		{
			if(e)e.stopImmediatePropagation();
			if(!mGameOver)
			{
				if(!mTime)
				{
					mTime = new Timer(1000/mSpeed);
				}
				if(!mTime.hasEventListener(TimerEvent.TIMER))mTime.addEventListener(TimerEvent.TIMER, onTime);
				mTime.start();
			}
			else
			{
				restart();
				mTime.start();
			}
		}	
		
		protected function onTime(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			if(mGameOver)
			{
				mTime.stop();
				mTime.removeEventListener(TimerEvent.TIMER, onTime);
				mTime = null;
				return;
			}
			onFrame();
		}
		
		
		private function onFrame(e:Event = null):void
		{
			// TODO Auto Generated method stub
			if(mGameOver) return;
			switch(mTowardA)
			{
				case LEFT:
					mNextAX = -1;
					mNextAY = 0;
					break;
				case RIGHT:
					mNextAX = 1;
					mNextAY = 0;
					break;
				case UP:
					mNextAY = -1;
					mNextAX = 0;
					break;
				case DOWN:
					mNextAY = 1;
					mNextAX = 0;
					break;
			}
			
			switch(mTowardB)
			{
				case LEFT:
					mNextBX = -1;
					mNextBY = 0;
					break;
				case RIGHT:
					mNextBX = 1;
					mNextBY = 0;
					break;
				case UP:
					mNextBY = -1;
					mNextBX = 0;
					break;
				case DOWN:
					mNextBY = 1;
					mNextBX = 0;
					break;
			}
			mStartAX += mNextAX;
			mStartBX += mNextBX;
			mStartAY += mNextAY;
			mStartBY += mNextBY;
			createBlockA(mStartAX, mStartAY);
			createBlockB(mStartBX, mStartBY);
		}
		
		private function createBlockA(px:int, py:int):void
		{
			if(checkGameState(px, py))
			{
				return;
			}
			createBlockWithColor(px, py, Color.BLUE);
			mPositionA[mPositionA.length] = new Point(px, py);
		}
		
		private function createBlockB(px:int, py:int):void
		{
			if(checkGameState(px, py))
			{
				return;
			}
			createBlockWithColor(px, py, Color.RED)
			mPositionB[mPositionB.length] = new Point(px, py);
		}
		
		private function contatin(position:Vector.<Point>, px:int, py:int):Boolean
		{
			for each (var item:Point in position) 
			{
				if(item.x == px && item.y == py)
				{
					return true;
				}
			}
			return false;
		}
		
		private function hitWithBlock(px:int, py:int):Boolean
		{
			return contatin(mPositionA, px, py) || contatin(mPositionB, px, py);
		}
		
		
		private function checkGameState(px:int, py:int):Boolean
		{
			if(hitWithBlock(px, py) || outRange(px, py))
			{
				addEventListener(TouchEvent.TOUCH, onTouch);
				mGameOver = true;
				return mGameOver;
			}
			return false;
		}
		private function createBlockWithColor(px:int, py:int, color:uint):void
		{
			createWithTexture(px, py, color);
			//				createWithBitData(px, py, color);
		}
		
		
		private function createWithTexture(px:int, py:int, color:uint):void
		{
			if(!mBatch)
			{
				mBatch = new QuadBatch();
				mBatch.blendMode = BlendMode.MULTIPLY;
				addChild(mBatch);
			}
			var block:Image = new Image(mTexture);
			block.color = color;
			block.x = px * mGridWidth;
			block.y = py * mGridHeight;
			mBatch.addImage(block);
			block.dispose();
			block = null;
		}
		private function restart():void
		{
			// TODO Auto Generated method stub
			if(mBatch)
			{
				mBatch.reset();
			}
			initStartPoint();
			mTowardA = LEFT;
			mTowardB = RIGHT;
			mGameOver = false;
			if(!mPositionA)mPositionA = new Vector.<Point>();
			mPositionA.splice(0, mPositionA.length);
			if(!mPositionB)mPositionB = new Vector.<Point>();
			mPositionB.splice(0, mPositionB.length);
			createBlockA(mStartAX, mStartAY);
			createBlockB(mStartBX, mStartBY);
		}
		
		private function initStartPoint():void
		{
			// TODO Auto Generated method stub
			var startX:uint = int(mCountX/2);
			var startY:uint = int(mCountY/2);
			mStartAX = startX - 3;
			mStartBX = startX + 3;
			mStartBY = mStartAY = startY;
		}
		
		private function initGridSize():void
		{
			mCountX = int(stage.stageWidth/mGridWidth);
			mCountY = int(stage.stageHeight/mGridHeight);
			var width:Number = (stage.stageWidth - mCountX*mGridWidth);
			var height:Number = (stage.stageHeight - mCountY*mGridHeight);
			mMinX = width/2;
			mMaxX = stage.stageWidth - width/2;
			mMinY = height/2;
			mMaxY = stage.stageHeight - height/2;
		}
		
		
		private function outRange(px:int, py:int):Boolean
		{
			return px * mGridWidth > mMaxX || px * mGridWidth < mMinX || py * mGridHeight > mMaxY || py * mGridHeight < mMinY;
			
		}
		
		public function towordUp(e:TouchEvent):void
		{
			switch(getTargetName(e))
			{
				case "A":
					mTowardA = UP;
					break;
				case "B":
					mTowardB = UP;
					break;
			}
		}
		public function towordDown(e:TouchEvent):void
		{
			switch(getTargetName(e))
			{
				case "A":
					mTowardA = DOWN;
					break;
				case "B":
					mTowardB = DOWN;
					break;
			}
		}
		public function towordLeft(e:TouchEvent):void
		{
			switch(getTargetName(e))
			{
				case "A":
					mTowardA = LEFT;
					break;
				case "B":
					mTowardB = LEFT;
					break;
			}
		}
		public function towordRight(e:TouchEvent):void
		{
			switch(getTargetName(e))
			{
				case "A":
					mTowardA = RIGHT;
					break;
				case "B":
					mTowardB = RIGHT;
					break;
			}
		}
		
		public function getTargetName(e:TouchEvent):String
		{
			e.stopImmediatePropagation();
			var direction:MKDirectionControl = e.currentTarget as MKDirectionControl;
			return direction.name;
		}
		
		public function get mGameOver():Boolean
		{
			return _mGameOver;
		}
		
		public function set mGameOver(value:Boolean):void
		{
			_mGameOver = value;
		}
		
	}
}