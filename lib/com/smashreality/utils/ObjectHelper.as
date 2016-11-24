package com.smashreality.utils 
{
	
	import flash.sampler.NewObjectSample;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class ObjectHelper
	{
		
		public function ObjectHelper() 
		{
			
		}
		
		public static function bind(object:Object, baseObject:Object):Object {

			var objClass:Class = getDefinitionByName(getQualifiedClassName(baseObject)) as Class;
			var returnObject:Object = new(objClass)();
			
			var propertyMap:XML = describeType(returnObject);
			var propertyTypeClass:Class;
			if(propertyMap.variable.length() > 0){
			  for each (var property:XML in propertyMap.variable) {
					if ((object as Object).hasOwnProperty(property.@name)) {
						  propertyTypeClass = getDefinitionByName(property.@type) as Class;
						  //if (object[property.@name] is (propertyTypeClass)) {
						  if (propertyTypeClass == Date) {
							  returnObject[property.@name] = new Date(object[property.@name]);
						  }else{
							  returnObject[property.@name] = bind(object[property.@name] , propertyTypeClass) as propertyTypeClass;
						  }
						  //}
					}
			  }
			}else {
				returnObject = object
			}
		   
			return returnObject;
		}
		
	}

}