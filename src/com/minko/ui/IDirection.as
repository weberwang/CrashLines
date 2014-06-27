package com.minko.ui
{
	import starling.events.TouchEvent;

	public interface IDirection
	{
		function towordUp(e:TouchEvent):void;
		function towordDown(e:TouchEvent):void;
		function towordLeft(e:TouchEvent):void;
		function towordRight(e:TouchEvent):void;
	}
}