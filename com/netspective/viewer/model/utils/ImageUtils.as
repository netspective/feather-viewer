package com.netspective.viewer.model.utils {
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * Utility image functions.
	 * 
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 01/09/08
	 * @version 1.0
	 */
	public class ImageUtils {
		
		/* --- Functions --- */
		
		/**
		 * Determines the scale factor necessary to fit the <code>content</code> within <code>frame</code>.
		 * 
		 * @param frame container that <code>content</code> needs to fit within
		 * @param content object that must fit within <code>frame</code>
		 * @return factor to scale <code>content</code> down by to fit within <code>frame</code>
		 */
		public static function scaleDownValue(frame:DisplayObject, content:DisplayObject):Number {
			return scaleDownValue2(new Rectangle(0, 0, frame.width, frame.height), content);
		}
		
		/**
		 * Determines the scale factor necessary to fit the <code>content</code> within <code>rectangle</code>.
		 * 
		 * @param bounds Rectangle that specifies width / height dimensions into which <code>content</code> needs to fit
		 * @param content object that must fit within the width / height dimensions of <code>bounds</code>
		 * @return factor to scale <code>content</code> down by to fit within the dimensions of <code>bounds</code>
		 */
		public static function scaleDownValue2(bounds:Rectangle, content:DisplayObject):Number {
			if(content.width > bounds.width || content.height > bounds.height) {
				return (content.width / bounds.width > content.height / bounds.height)
							? bounds.width  / content.width
							: bounds.height / content.height;
			}
			return 1.0;
		}
		
		/**
		 * Determines the scale factor necessary to shrink or expand the <code>content</code> so that it fills
		 * the <code>rectangle</code>.
		 * 
		 * @param bounds Rectangle that specifies width / height dimensions into which <code>content</code> needs to fit
		 * @param content object that must fit within the width / height dimensions of <code>bounds</code>
		 * @return factor to scale <code>content</code> by to fit within the dimensions of <code>bounds</code>
		 */		
		public static function fitToBounds(bounds:Rectangle, content:DisplayObject):Number {
			if(content.width > bounds.width || content.height > bounds.height) {
				return (content.width / bounds.width > content.height / bounds.height)
							? bounds.width  / content.width
							: bounds.height / content.height;
			} else {
				return (bounds.width / content.width < bounds.height / content.height)
							? bounds.width  / content.width
							: bounds.height / content.height;				
			}			
		}
		
		/* === Functions === */

	}
	
}