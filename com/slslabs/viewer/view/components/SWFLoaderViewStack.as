package com.slslabs.viewer.view.components {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.containers.ViewStack;
	import mx.controls.SWFLoader;

	/**
	 * SWFLoaderViewStack. A view stack that holds SWFLoader instances.
	 *
	 * @langversion ActionScript 3.0
	 * @author Srdan Bejakovic  srdan@smartlogicsolutions.com
	 * @date 03/05/2009
	 * @version 0.1
	 */
	public class SWFLoaderViewStack extends ViewStack {
	
		/* --- Variables --- */
		
		public var swfLoaders:Array = [];
	
		private var initializedChildCount:int;
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		public function SWFLoaderViewStack() {
			resizeToContent = true;
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */

		public function set srcPaths(srcPaths:Array):void {
			initializedChildCount = 0;
			for each(var path:String in srcPaths) {
				addSWFLoader(path);
			}
		}
		
		private function onChildInit(evt:Event):void {
			initializedChildCount++;
			if(initializedChildCount == numChildren) {
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		private function addSWFLoader(path:String):void {
			var container:Canvas = new Canvas();
			var loader:SWFLoader = new SWFLoader();
			container.addChild(loader);
			this.addChild(container);
			swfLoaders.push(loader);
			loader.addEventListener(Event.INIT, onChildInit);		
			loader.source = path;			
		}
		
		/* === Functions === */
		
		/* --- Public Accessors --- */
		
		public function get content():DisplayObject {
			return numChildren > 0 ? swfLoaders[selectedIndex].content : null;
		}
		
		/* === Public Accessors === */
	}
}