package com.smashreality.game.drmario.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author barry morwood
	 */
	public class NewEvent extends Event 
	{
		
		public function NewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new NewEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NewEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}