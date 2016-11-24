package com.smashreality.utils 
{
	
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class SwearWordFilter
	{
		
		public static function isSwearWord(word:String, exactMatch:Boolean = true):Boolean
		{
			var swearWordBank:Array = new Array("ass", "asshole", "anus", "bastard", "bitch", "blowjob", "boner", "buttplug", "carpet muncher", "chink", "clit", "cum", "chode", "cock", "cunt", "dick", "douche", "dyke", "dildo", "fag", "fellatio", "fuck", "fudgepacker", "flamer", "gooch", "gook", "gay", "guido", "gringo", "hoe", "homo", "heeb", "handjob", "honkey",  "jackass", "jerk", "jap", "jiggaboo", "jizz", "junglebunny", "kike", "kooch", "lesbo", "muff", "motherfucker", "muffdiver", "nig", "nigger", "nutsack", "negro", "pussy", "prick", "porchmonkey", "paki", "penis", "poon", "piss", "polesmoker", "queer", "queef", "rimjob", "raghead", "retard", "rimjob", "scrotum", "shit", "schlong", "skank", "slut", "spic", "splooge", "snatch", "twat", "tit", "testicle", "vag", "wop", "whore", "wank");
			
			for (var i:Number = 0; i < swearWordBank.length; i++) {
				if(exactMatch){
					if (swearWordBank[i].toLowerCase() == word.toLowerCase()) {
						return true;
					}
				}
				else {
					if (word.toLowerCase().indexOf(swearWordBank[i].toLowerCase()) > -1) {
						return true;
					}
				}
			}
			
			return false;
			
		}
		
		public static function containsSwearWord(message:String, exactMatch:Boolean = true):Boolean {
			
			if (message == null)
				return false;
			
			var words:Array = message.split(" ");
			
			for (var i:Number = 0; i < words.length; i++) {
				if (isSwearWord(words[i],exactMatch)) {
					return true;
				}
			}
			
			return false;
		}
		
	}

}