package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class Game extends Sprite
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
			
		
		private var mPause:Boolean = true;
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
		public function Game()
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
//			stage.color = 0xCCCCCC;
			setBlockTexture();
			initGridSize();
			drawGrid();
			restart();
			touchable = true;
//			addEventListener(TouchEvent.TOUCH, onTouch);
			addKeyEvent();
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
		
		private function onTouch():void
		{
			if(!mGameOver)
			{
				mPause = !mPause;
				if(mPause)
				{
//					removeEnterFrame();
					if(mTime)mTime.stop();
				}
				else if(!mGameOver)
				{
//					initEnterFrame();
					if(!mTime)
					{
						mTime = new Timer(1000/mSpeed);
					}
					if(!mTime.hasEventListener(TimerEvent.TIMER))mTime.addEventListener(TimerEvent.TIMER, onTime);
					mTime.start();
				}
			}
		}	
		
		protected function onTime(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			if(mPause || mGameOver)
			{
				mTime.stop();
				mTime.removeEventListener(TimerEvent.TIMER, onTime);
				return;
			}
			onFrame();
		}
		
		private function addKeyEvent():void
		{
			// TODO Auto Generated method stub
			addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		}
		
		private function onKeyUP(e:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			e.stopImmediatePropagation();
			switch(e.keyCode)
			{
				case Keyboard.UP:
					if(mTowardB != DOWN)
					{
						mTowardB = UP;
					}
					break;
				case Keyboard.DOWN:
					if(mTowardB != UP)
					{
						mTowardB = DOWN;
					}
					break;
				case Keyboard.LEFT:
					if(mTowardB != RIGHT)
					{
						mTowardB = LEFT;
					}
					break;
				case Keyboard.RIGHT:
					if(mTowardB != LEFT)
					{
						mTowardB = RIGHT;
					}
					break;
				case Keyboard.W:
					if(mTowardA != DOWN)
					{
						mTowardA = UP;
					}
					break;
				case Keyboard.S:
					if(mTowardA != UP)
					{
						mTowardA = DOWN;
					}
					break;
				case Keyboard.A:
					if(mTowardA != RIGHT)
					mTowardA = LEFT;
					break;
				case Keyboard.D:
					if(mTowardA != LEFT)
					{
						mTowardA = RIGHT;
					}
					break;
				case Keyboard.SPACE:
					if(mGameOver)
					{
						restart();
					}
					else
					{
						onTouch();
					}
					break;
			}
		}
		
		private function removeEnterFrame():void
		{
			// TODO Auto Generated method stub
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function initEnterFrame():void
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event = null):void
		{
			// TODO Auto Generated method stub
			if(mPause) return;
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
			mPause = true;
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
		
		private function drawGrid():void
		{
			var mBlockSp:Shape = new Shape();
			var graphics:Graphics = mBlockSp.graphics;
			graphics.clear();
			graphics.lineStyle(1, 0xCCCCCC);
			for (var i:int = 0; i < mCountY + mCountX; i++) 
			{
				if(i < mCountY)
				{
					graphics.moveTo(mMinX, mMinY + i * mGridHeight);
					graphics.lineTo(mMaxX, mMinY + i * mGridHeight);
				}
				else
				{
					graphics.moveTo(mMinX + (i - mCountY) * mGridWidth, mMinY);
					graphics.lineTo(mMinX + (i - mCountY) * mGridWidth, mMaxY);
				}
			}
			graphics.endFill();
			var mBitData:BitmapData = new BitmapData(mMaxX - mMinX, mMaxY - mMinY);
			mBitData.draw(mBlockSp);
			var texture:Texture = Texture.fromBitmapData(mBitData);
			var bg:Image = new Image(texture);
			addChild(bg);
		}

		private function outRange(px:int, py:int):Boolean
		{
			return px * mGridWidth > mMaxX || px * mGridWidth < mMinX || py * mGridHeight > mMaxY || py * mGridHeight < mMinY;
				
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