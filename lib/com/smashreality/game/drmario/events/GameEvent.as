package com.smashreality.game.drmario.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author barry morwood
	 */
	public class GameEvent extends Event
	{
		
		public static const GAME_OVER:String = "game_over";
	    public static const LEVEL_COMPLETE:String = "level_complete";
		public static const LEVEL_READY:String = "level_ready";
		public static const PAUSED:String = "paused";
		public static const GRID_ITEM_REMOVED:String = "grid_item_removed";
		
		public var item:Object;
		
		
		public function GameEvent(type:String, item:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.item = item;
			
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