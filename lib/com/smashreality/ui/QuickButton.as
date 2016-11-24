package com.smashreality.ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class QuickButton
	{
		public var vars:Object;
		public var target:Object;
		
		public var traceShape:Shape;
		public var filters:Array;
		
		protected static var _masterList:Dictionary = new Dictionary(false); 
		
		public function QuickButton(target:Object, vars:Object):void 
		{
			
			this.vars = validOptions(vars || { });
			this.target = target;
			
			this.traceShape = new Shape();
			
			var qb:QuickButton = _masterList[target] as QuickButton;
			
			_masterList[target] = this;
			
			update();
		}
		
		private function update():void 
		{
			if(this.vars.up)
				target.addEventListener(MouseEvent.MOUSE_UP, this.vars.up);
			
			if(this.vars.down)
				target.addEventListener(MouseEvent.MOUSE_DOWN, this.vars.down);
			
			if(this.vars.over)
				target.addEventListener(MouseEvent.MOUSE_OVER, this.vars.over);
			
			if(this.vars.out)
				target.addEventListener(MouseEvent.MOUSE_OUT, this.vars.out);
				
			target.buttonMode = this.vars.buttonMode;
			target.mouseChildren = this.vars.mouseChildren;
			target.useHandCursor = this.vars.useHandCursor;
			target.mouseEnabled = this.vars.mouseEnabled;
		}
		
		public static function disable(target:Object, greyOut:Boolean = false):void 
		{
			if (target in _masterList) {
				var qb:QuickButton = QuickButton(_masterList[target]);
				qb.vars.mouseEnabled = false;
				qb.update();
				
				if(qb.filters)
					qb.target.filters = qb.filters;
				
				if(qb.vars.up)
					qb.target.removeEventListener(MouseEvent.MOUSE_UP, qb.vars.up);
				
				if(qb.vars.down)
					qb.target.removeEventListener(MouseEvent.MOUSE_DOWN, qb.vars.down);
				
				if(qb.vars.over)
					qb.target.removeEventListener(MouseEvent.MOUSE_OVER, qb.vars.over);
				
				if(qb.vars.out)
					qb.target.removeEventListener(MouseEvent.MOUSE_OUT, qb.vars.out);

				var rLum:Number = 0.2225;
				var gLum:Number = 0.7169;
				var bLum:Number = 0.0606; 
				
				var matrix:Array = [rLum, gLum, bLum, 0, 0,
					rLum, gLum, bLum, 0, 0,
					rLum, gLum, bLum, 0, 0,
					0,    0,    0,    1, 0 ];
			
				var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				qb.filters = qb.target.filters;
				
				if(greyOut)
					qb.target.filters = [filter];
			
			}	
		}
		
		public static function enable(target:Object):void 
		{
			if (target in _masterList) {
				var qb:QuickButton = QuickButton(_masterList[target]);
				qb.vars.mouseEnabled = true;
				qb.update();
				
				if(qb.filters)
					qb.target.filters = qb.filters;
			}
		}
		
		public static function draw(target:Object, vars:Object):QuickButton 
		{
			var qb:QuickButton = new QuickButton(target, vars);
			
			qb.traceShape.graphics.beginFill(0xeaed12);
			qb.traceShape.graphics.lineStyle(2, 0xeaed12); 
			qb.traceShape.graphics.drawRect(0, 0, qb.vars.width, qb.vars.height);
			qb.traceShape.graphics.endFill(); 
			
			qb.target.addChild(qb.traceShape);
			
			return qb;
			
		}
		
		public static function add(target:Object, vars:Object):QuickButton 
		{
			return new QuickButton(target, vars);
		}
		
		public static function remove(target:Object) : void {
									
			if (target in _masterList) {
				
				var qb:QuickButton = QuickButton(_masterList[target]);
				
				for (var i:int =  qb.target.numChildren - 1; i >= 0; i--)	{
					if(qb.target.getChildAt(i) == qb.traceShape)
						qb.target.removeChildAt(i);
				}
				
				qb.target.filters = qb.filters;
				
				if(qb.vars.up)
					target.removeEventListener(MouseEvent.MOUSE_UP, qb.vars.up);
				
				if(qb.vars.down)
					target.removeEventListener(MouseEvent.MOUSE_DOWN, qb.vars.down);
				
				if(qb.vars.over)
					target.removeEventListener(MouseEvent.MOUSE_OVER, qb.vars.over);
				
				if(qb.vars.out)
					target.removeEventListener(MouseEvent.MOUSE_OUT, qb.vars.out);
					
				target.mouseChildren = false;
				target.useHandCursor = false;
				target.buttonMode = false;
				target.mouseEnabled = false;
		
				delete _masterList[target];
			}
			
		}
		
		private static function validOptions(options:Object):Object 
		{	
			
			options = options || { };
			options = (options is Function) ? { all:options } : options;
			
			if (options.all is Function )
				options.up = options.down = options.over = options.out = options.all;
				
			if (!options.up || typeof options.up != "function" )
				options.up = null;
				
			if (!options.down || typeof options.down != "function" )
				options.down = null;
			
			if (!options.over || typeof options.over != "function" )
				options.over = null;
			
			if (!options.out || typeof options.out != "function" )
				options.out = null;
				
			if (!options.mouseChildren || !(options.mouseChildren is Boolean))
				options.mouseChildren = true;
				
			if (!options.useHandCursor || !(options.mouseChildren is Boolean))
				options.useHandCursor = true;
				
			if (!options.buttonMode || !(options.mouseChildren is Boolean))
				options.buttonMode = true;
				
			if (!options.mouseEnabled || !(options.mouseEnabled is Boolean))
				options.mouseEnabled = true;
				
			if (!options.width || !(options.width is Number))
				options.width = 100;
				
			if (!options.height || !(options.height is Number))
				options.height = 100;
				
			return options;
		}
	}

}