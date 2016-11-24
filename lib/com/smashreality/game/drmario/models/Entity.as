package com.smashreality.game.drmario.models 
{
	import com.smashreality.game.drmario.enums.BlockType;
	/**
	 * ...
	 * @author barry morwood
	 */
	public class Entity 
	{
		
		public var x:int;
		public var y:int;
		public var type:String;
		public var pill_rotation:String;
		public var assetID:uint;
		public var partner:Entity;
		public var guid:Number;
		
		public function Entity() 
		{
			guid = Math.random() * 9999999;
		}
		
	}

}