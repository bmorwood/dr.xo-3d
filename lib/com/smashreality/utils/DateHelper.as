package com.smashreality.utils 
{
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class DateHelper
	{
		public static function getNumberOrdinalSuffix(day:int):String {
				
			var suffix = "";
			
			if(Math.floor(day/10)%10===1)return "th";
			day %= 10;
			if(day>3 || day===0) suffix = "th";
			if(day===1) suffix =  "st";
			if (day === 2) suffix =  "nd";
			
			return suffix;
		}
		
		public static function getDayOfTheWeekName(d:Date):String {
			switch(d.getDay()) {
				case 0:
					return "Sunday";
					break;
				
				case 1:
					return "Monday";
					break;
				
				case 2:
					return "Tuesday";
					break;
				
				case 3:
					return "Wednesday";
					break;
				
				case 4:
					return "Thursday";
					break;
				
				case 5:
					return "Friday";
					break;
								
				case 6:
					return "Saturday";
					break;
				default:
					return "";
					break;
			}
		}
		
		public static function getMonthName(d:Date):String {
			switch(d.getMonth()) {
				case 0:
					return "January";
					break;
				
				case 1:
					return "Febuary";
					break;
				
				case 2:
					return "March";
					break;
				
				case 3:
					return "April";
					break;
				
				case 4:
					return "May";
					break;
				
				case 5:
					return "June";
					break;
								
				case 6:
					return "July";
					break;
					
				case 7:
					return "August";
					break;
					
				case 8:
					return "September";
					break;
					
				case 9:
					return "October";
					break;
					
				case 10:
					return "November";
					break;
					
				case 11:
					return "December";
					break;
					
				default:
					return "";
					break;
			}
		}
	}
}