package com.slslabs.viewer.view.components {
	import mx.containers.VBox;
	import mx.controls.SWFLoader;
	import mx.core.ScrollPolicy;


	public class SWFLoaderContainer extends VBox {
		public var loader:SWFLoader;
	
		public function SWFLoaderContainer() {
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			setStyle("horizontalAlign", "center");
			setStyle("verticalAlign", "middle");			

			loader = new SWFLoader();
			addChild(loader);
		}
		
		public function set scale(scale:Number):void {
			scaleX = scale;
			scaleY = scale;
			loader.scaleX = scale;
			loader.scaleY = scale;
		}
		
		public function get scale():Number {
			return scaleX;
		}
	}
}