package com.slslabs.viewer.model.utils {
	
	/**
	 * Scale related utility functions.
	 * 
	 * @langversion ActionScript 3.0
	 * @author Srdan Bejakovic &lt;srdan&#64;smartlogicsolutions.com&gt;
	 * @date 03/05/2009
	 * @version 0.1
	 */
	public class ScaleUtils {
		
		/* --- Variables --- */
		
		public static const SCALE_GROUPS:Array = [
			{ceiling:1, scale:.1},
			{ceiling:2, scale:.25},
			{ceiling:4, scale:.5},
			{ceiling:16, scale:1}
		];

		/**
		 * Maximum allowed scale level.
		 */
		public static const MAX_SCALE:Number = 16;
		
		/**
		 * Minimum allowed scale level.
		 */
		public static const MIN_SCALE:Number = .1;
		
		/* === Variables === */
		
		/* --- Functions --- */
		
		/**
		 * Ensures the entered value remains in the valid range.
		 * 
		 * <p>If a value is entered outside of the range, the scale
		 * will be set to the appropriate minumum or maximum value.
		 */
		public static function clipValue(scale:Number):Number {
			if(scale < MIN_SCALE)
				return MIN_SCALE;
			else if(scale > MAX_SCALE)
				return MAX_SCALE;
			return scale;
		}
		
		/* === Functions === */

	}
	
}