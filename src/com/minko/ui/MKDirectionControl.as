package com.minko.ui
{
	import com.minko.delegate.IDirection;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class MKDirectionControl extends Sprite
	{
		
		private var mUpButton:Button;
		private var mDownButton:Button;
		private var mLeftButton:Button;
		private var mRightButton:Button;
		private const GAP:int = 20;
		private var _isTop:Boolean = false;
		
		public var directionDelegate:IDirection;
		public function MKDirectionControl()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			this.alpha = 0.3;
			mUpButton = new Button();
			mUpButton.scaleX = 2;
			mUpButton.scaleY = 2;
			mUpButton.validate();
			mUpButton.label = "↑";
			
			
			mDownButton = new Button();
			mDownButton.scaleX = 2;
			mDownButton.scaleY = 2;
			mDownButton.validate();
			mDownButton.label = "↓";
			
			
			mLeftButton = new Button();
			mLeftButton.scaleX = 2;
			mLeftButton.scaleY = 2;
			mLeftButton.validate();
			mLeftButton.label = "←"
			
		
			mRightButton = new Button();
			mRightButton.scaleX = 2;
			mRightButton.scaleY = 2;
			mRightButton.validate();
			mRightButton.label = "→";
			
			addChild(mUpButton);
			addChild(mDownButton);
			addChild(mLeftButton);
			addChild(mRightButton);
			setBottomLayout();
			initEvents();
		}
		
		public function set isTop(value:Boolean):void
		{
			if(_isTop == value) return;
			_isTop = value;
			if(_isTop)
			{
				setTopLayout();
			}
			else
			{
				setBottomLayout();
			}
		}
		
		private function setBottomLayout():void
		{
			mUpButton.x = mUpButton.width + GAP;
			mUpButton.y = 0;
			
			mDownButton.x = mUpButton.width + GAP;
			mDownButton.y = mUpButton.height + GAP;
			
			mLeftButton.x = 0;
			mLeftButton.y = mUpButton.height + GAP;
			
			mRightButton.x = (mUpButton.width + GAP) * 2;
			mRightButton.y = mUpButton.height + GAP;
		}
		
		private function setTopLayout():void
		{
			mUpButton.x = mUpButton.width + GAP;
			mUpButton.y = 0;
			
			mDownButton.x = mUpButton.width + GAP;
			mDownButton.y = mUpButton.height + GAP;
			
			mLeftButton.x = 0;
			mLeftButton.y = 0;
			
			mRightButton.x = (mUpButton.width + GAP) * 2;
			mRightButton.y = 0;
		}
		
		private function initEvents():void
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			e.stopImmediatePropagation();
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED)
			{
				var local:Point = touch.getLocation(this);
				if(mUpButton.bounds.containsPoint(local))
				{
					directionDelegate.towordUp(e);
				}
				else if(mDownButton.bounds.containsPoint(local))
				{
					directionDelegate.towordDown(e);
				}
				else if(mLeftButton.bounds.containsPoint(local))
				{
					directionDelegate.towordLeft(e);
				}
				else if(mRightButton.bounds.containsPoint(local))
				{
					directionDelegate.towordRight(e);
				}
			}
		}

		public function get isTop():Boolean
		{
			return _isTop;
		}

	}
}