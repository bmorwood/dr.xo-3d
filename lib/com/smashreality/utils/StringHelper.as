package com.smashreality.utils 
{
	/**
	 * ...
	 * @author Barry Morwood
	 */
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class StringHelper
	{
		
		public static function isNullOrEmpty(value:String):Boolean {
			
			if (value == "")
				return true;
			 
			if (value == null)
				return true;
			
			return false
		}
		
		public static function stringToBoolean(value:String):Boolean
		{
			if (value == null)
				return Boolean(value);
			
			return (value.toLowerCase() == "true" || value.toLowerCase() == "1");
		} 
		
		public static function wordWrap(value:String, maxLength:int):String {
			var words:Array = value.split(/[\r\s]+/);
			var foundLongWord:Boolean = false;
			var tempSentence:String = "";
						
			//var regEx:RegExp = new RegExp("[\r\s]");
			//var result:Object = regEx.exec(value);	
			//trace(result[0]);
			
			for (var i:int = 0; i < words.length; i++ ) {
				if (String(words[i]).length > maxLength) {
					
					tempSentence +=  String(words[i]).substring(0, maxLength) + "\r" + String(words[i]).substring(maxLength, String(words[i]).length ) + " ";
					foundLongWord = true;
					continue;
				}
				
				tempSentence += String(words[i]) + " ";
			}
			
			
			if (foundLongWord)
				return wordWrap(tempSentence,maxLength);

				return tempSentence;
		}
		
		/** Checks if the given string is a valid email address.
		*  @param email The email address as a String
		*  @return True if the given string is a valid email address, false otherwise.
		*/
		public static function isValidEmail(email : String):Boolean {
				// permissive, will allow quite a few non matching email addresses
			var EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
			return Boolean(email.match(EMAIL_REGEX));
		}
		
		public static function format(pattern:String, objects:Array):String {
			for (var i:Number = 0; i <= objects.length; i++) {
				pattern=pattern.replace("{"+i+"}",objects[i]);
			}
			
			return pattern;
		}
		
	}

}