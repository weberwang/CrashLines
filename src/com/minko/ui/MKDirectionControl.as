package com.minko.ui
{
	import feathers.controls.Button;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MKDirectionControl extends Sprite
	{
		
		private var mUpButton:Button;
		private var mDownButton:Button;
		private var mLeftButton:Button;
		private var mRightButton:Button;
		
		public var directionDelegate:IDirection;
		public function MKDirectionControl()
		{
			super();
			initView();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded():void
		{
			// TODO Auto Generated method stub
			mUpButton.x = mUpButton.width;
			mUpButton.y = 0;
		}
		
		private function initView():void
		{
			mUpButton = new Button();
			mUpButton.validate();
			mUpButton.label = "↑";
			mUpButton.x = mUpButton.width;
			mUpButton.y = 0;
			
			mDownButton = new Button();
			mDownButton.validate();
			mDownButton.label = "↓";
			mDownButton.x = mDownButton.width;
			mDownButton.y = mUpButton.height;
			
			mLeftButton = new Button();
			mLeftButton.validate();
			mLeftButton.label = "←"
			mLeftButton.x = 0;
			mLeftButton.y = mUpButton.height;
		
			mRightButton = new Button();
			mRightButton.validate();
			mRightButton.label = "→";
			mRightButton.x = mRightButton.width * 2;
			mRightButton.y = mRightButton.height;
			
			
			addChild(mUpButton);
			addChild(mDownButton);
			addChild(mLeftButton);
			addChild(mRightButton);
			
			
			initEvents();
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
	}
}