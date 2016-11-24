package com.smashreality.utils 
{
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class KeyStroke 
	{
		private var _target:Object;
		private var _pattern:Array;
		private var _function:Function;
	
		private var _params:Array;
		
		protected static var _timer:Timer;
		protected static var _pressedKeys:Array;
		protected static var _record:Boolean;
		protected static var _masterList:Dictionary = new Dictionary(false); 
		
		// presets // 
		public static var KONAMICODE:Array =  ["38,38,40,40,37,39,37,39,66,65"];
		
		public function KeyStroke(uid:String, target:Object, pattern:Array, func:Function, params:Array) 
		{
			
			_pressedKeys = [];
			
			_pattern = pattern;
			_target = target;
			_function = func;
			_params = params;

			_masterList[uid] = this;
			
			if (!_target.hasEventListener(KeyboardEvent.KEY_DOWN)) {
				_target.addEventListener (KeyboardEvent.KEY_DOWN, KeyStroke.searchForPatternHandler);
			}
			
			var ks:KeyStroke = _masterList[uid] as KeyStroke;
			///ks.start();
			
			if(_timer == null){
				_timer = new Timer(1000);
				_timer.addEventListener(TimerEvent.TIMER, resetKeys);
				_timer.start();
			}
			
		}
		
		public function matched():void 
		{
			_function.apply(null, _params);
		}
		
		
		public static function start() 
		{	
			/*
			if(_timer == null){
				_timer = new Timer(1000);
				_timer.addEventListener(TimerEvent.TIMER, resetKeys);
				_timer.start();
			}
			*/
				
		}
		
		private static function resetKeys(e:TimerEvent):void 
		{
			_pressedKeys = [];
		}
		
		private static function searchForPatternHandler(e:KeyboardEvent = null):void 
		{
			_timer.stop();
		
			_pressedKeys.push( e.charCode);
			
			if(_record)
				trace("[" + _pressedKeys  + "]" );
				
				for each (var keyStroke:KeyStroke in _masterList) 
				{
					
					trace("[" + keyStroke.pattern +"]" + " " + "[" + _pressedKeys  + "]" );
					
					if ( _pressedKeys.toString().indexOf( keyStroke.pattern ) >= 0 ){
					    keyStroke.matched();
						KeyStroke.resetKeys(null);
					}
					
				}
			
			_timer.reset();
			_timer.start();

		}
		
		
		public static function stop():void {
			//_target.removeEventListener(KeyboardEvent.KEY_DOWN, searchForPatternHandler);
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, resetKeys);
		}
		
		
		public static function add(uid:String, target:Object, pattern:Object, func:Function, params:Array = null):KeyStroke 
		{
			
			if (pattern is String)
				return new KeyStroke(uid, target, KeyStroke.stringToPattern(pattern as String), func, params);
			
			return new KeyStroke(uid, target, pattern as Array, func, params);
		}
		
		public static function disable(uid:String):void 
		{
			if (uid in _masterList) {
				var ks:KeyStroke = KeyStroke(_masterList[uid]);
				//disable key logger
				//ks.stop();
			}	
		}
		
				
		public static function enable(uid:String):void 
		{
			if (uid in _masterList) {
				var ks:KeyStroke = KeyStroke(_masterList[uid]);
				////enable keystroke
				//ks.start();

			}
		}
		
		public static function remove(uid:String) : void {
							
			if (uid in _masterList) {
				var ks:KeyStroke = KeyStroke(_masterList[uid]);
				//ks.stop();
				delete _masterList[uid];
			}
			
		}
		
		public static function record(record:Boolean = false):void {
			_record = record;
		}
		
		public static function stringToPattern(criteria:String):Array 
		{
			var pattern:Array = new Array();
			
			for (var i:int = 0; i < criteria.length; i++)
				pattern.push(criteria.charCodeAt(i));
				
			return pattern;
		}
		
		public function get pattern():Array { return _pattern; }
		
	}

}