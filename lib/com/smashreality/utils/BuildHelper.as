package com.smashreality.utils
{
	import flash.system.Capabilities;
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class BuildHelper
	{
		
		public static function isIDEMode():Boolean {
			return (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone");
		}
		
		///hello world
		public static function IDEMode(ifIDEMode:String, ifNotIDEMode:String):String {
			
			if (isIDEMode())
			 return ifIDEMode;
			
			return ifNotIDEMode;

		}
		
		public static function tokenizer(object:Object, content:String, delim:String = "^^"):String 
		{
			
			for (var token:Object in object) {
				content = BuildHelper.replace(content, delim + token.toString() + delim , object[token]);
			}
			
			return content;
		}
		
		public static function replace(org:String, fnd:String, rpl:String):String
		{
			return org.split(fnd).join(rpl);
		}
		
		public static function externalParam(mc:MovieClip, externalParam:String, defaultValue:String = null):String {
			
			if (mc == null) return defaultValue;
			
			var paramObj:Object = LoaderInfo(mc.root.loaderInfo).parameters;
			
			if (paramObj == null) return defaultValue;
			
			if (paramObj[externalParam] != null) {
				return String(paramObj[externalParam]);
			}
			
			return defaultValue
		}
	}
}