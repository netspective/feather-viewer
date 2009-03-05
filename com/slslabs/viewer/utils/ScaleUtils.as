package com.slslabs.viewer.utils
{
	public class ScaleUtils
	{
		public static const SCALE_GROUPS:Array = [
			{ceiling:1, scale:.1},
			{ceiling:2, scale:.25},
			{ceiling:4, scale:.5},
			{ceiling:16, scale:1}
			];

		public static const MAX_SCALE:Number = 16;
		
		public static const MIN_SCALE:Number = .1;
		
		public static function isValid(scale:Number):Boolean {
			if(!scale || isNaN(scale))
				return false;
			return MIN_SCALE <= scale && scale <= MAX_SCALE;
		}

	}
}