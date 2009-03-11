package com.slslabs.viewer.view.components {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.SWFLoader;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;

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
	
		private var swfLoaderContainers:Array = [];
		
		private var initializedChildCount:int;
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		public function SWFLoaderViewStack() {
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
			var container:SWFLoaderContainer = new SWFLoaderContainer();
			this.addChild(container);
			swfLoaderContainers.push(container);
			swfLoaders.push(container.loader);
			container.loader.source = path;	
		}		
		
		/* === Functions === */
		
		/* --- Public Accessors --- */
		
		public function get content():DisplayObject {
			return numChildren > 0 ? swfLoaders[selectedIndex].content : null;
		}
		
		public function get contentContainer():SWFLoaderContainer {
			return numChildren > 0 ? swfLoaderContainers[selectedIndex] : null;
		}
		
		/* === Public Accessors === */
	}
}