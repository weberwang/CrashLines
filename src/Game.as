package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getSize;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.RectangleUtil;
	
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
			
//		private var mBit:Bitmap;
		private var mBitData:BitmapData;
		private var mBlockSp:Shape;
		private var mRender:RenderTexture;
		
		private var mPause:Boolean = true;
		private var mTowardA:String;
		private var mTowardB:String;
		
		private const RIGHT:String = "right";
		private const UP:String = "up";
		private const DOWN:String = "down";
		private const LEFT:String = "left";
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
			stage.color = 0xCCCCCC;
			initGridSize();
			drawGrid();
			initStartPoint();
			restart();
			touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			if(e.touches[0].phase == TouchPhase.ENDED)
			{
				mPause = !mPause;
				if(mPause)
				{
					removeEnterFrame();
				}
				else
				{
					initEnterFrame();
				}
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
		
		private function onFrame():void
		{
			// TODO Auto Generated method stub
			var nextAX:int = 0;
			var nextBX:int = 0;
			var nextBY:int = 0;
			var nextAY:int = 0;
			switch(mTowardA)
			{
				case LEFT:
					nextAX = -1;
					break;
				case RIGHT:
					nextAX = 1;
					break;
				case UP:
					nextAY = -1;
					break;
				case DOWN:
					nextAY = 1;
					break;
			}
			
			switch(mTowardB)
			{
				case LEFT:
					nextBX = -1;
					break;
				case RIGHT:
					nextBX = 1;
					break;
				case UP:
					nextBY = -1;
					break;
				case DOWN:
					nextBY = 1;
					break;
			}
			mStartAX += nextAX;
			mStartBX += nextBX;
			mStartAY += nextAY;
			mStartBY += nextBY;
			createBlockA(mStartAX, mStartAY);
			createBlockB(mStartBX, mStartBY);
		}
		
		private function createBlockA(px:int, py:int):void
		{
			createBlockWithColor(px, py, Color.BLUE);
		}
		
		private function createBlockB(px:int, py:int):void
		{
			createBlockWithColor(px, py, Color.RED)
		}
		
		private var mCount:int = 0;
		private function createBlockWithColor(px:int, py:int, color:uint):void
		{
			mCount ++;
			if(!mBitData)
			{
				mBitData = new BitmapData(mMaxX - mMinX, mMaxY - mMinY);
			}
			var graphics:Graphics;
			if(!mBlockSp)
			{
				mBlockSp = new Shape();
				graphics = mBlockSp.graphics;
				graphics.lineStyle();
			}
			if(!graphics)graphics = mBlockSp.graphics;
			graphics.beginFill(color);
			graphics.drawRect(px * mGridWidth, py * mGridHeight, mGridWidth, mGridHeight);
			graphics.endFill();
			
			mBitData.draw(mBlockSp);
			
			var texture:Texture = Texture.fromBitmapData(mBitData);
			var mBlock:Image = new Image(texture);
			mRender.clear();
			mRender.draw(mBlock);
			texture.dispose();
			mBlock.dispose();
		}
		
		private function restart():void
		{
			// TODO Auto Generated method stub
			mTowardA = LEFT;
			mTowardB = RIGHT;
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
			if(!mBlockSp)
			{
				mBlockSp = new Shape();
			}
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
			mBitData = new BitmapData(mMaxX - mMinX, mMaxY - mMinY);
			mBitData.draw(mBlockSp);
			var texture:Texture = Texture.fromBitmapData(mBitData);
			var bg:Image = new Image(texture);
			mRender = new RenderTexture(mMaxX - mMinX, mMaxY - mMinY);
			var mBlock:Image = new Image(mRender);
			addChild(mBlock);
			mRender.draw(bg);
			bg.dispose();
			texture.dispose();
			mBlock.dispose();
		}
	}
}