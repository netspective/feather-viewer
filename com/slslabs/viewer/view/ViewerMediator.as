package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.model.utils.ImageUtils;
	
	import flash.display.AVM1Movie;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.SWFLoader;
	import mx.events.ResizeEvent;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Viewer mediator.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class ViewerMediator extends Mediator {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "ViewerMediator";
		
		/**
		 * Indicates the loaded movie may be navigated.
		 */
		protected var canNavMovie:Boolean;
		
		// local variables for panning
		private var isPanning:Boolean;
		private var panningStartX:Number;
		private var panningStartY:Number;
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param viewComponent view component for mediator
		 */
		public function ViewerMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			canNavMovie = false;
			
			facade.registerMediator( new ViewerToolbarMediator(app.toolbar) );
			
			// Prevent the view stack from displaying anything until the initial resize and
			// centering are complete.
			app.loaderViewStack.visible = false;

			app.loaderViewStack.addEventListener(Event.INIT, onSWFInit);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case ViewerFacade.CHANGE_PAGE:
					changePage(note.getBody().goForward);
					sendNotification(ViewerFacade.UPDATE_PAGES,
						{currentPage: getCurrentFrame(), totalPages: countTotalFrames()});
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				ViewerFacade.CHANGE_PAGE
			];
		}
				
		private function getCurrentFrame():int {
			var currentFrame:int = countTotalFrames(app.loaderViewStack.selectedIndex);
			currentFrame += canNavMovie ? swfAsMovieClip.currentFrame : 1;
			return currentFrame;
		}
		
		private function changePage(goForward:Boolean):void {
			if(withinNavigableMovie(goForward)) {
				goForward ? swfAsMovieClip.nextFrame() : swfAsMovieClip.prevFrame();
			} else if(hasOtherMovie(goForward)) {
				app.loaderViewStack.selectedIndex += goForward ? 1 : -1;
				openNewSWF(goForward);
			}
		}
		
		private function hasOtherMovie(goForward:Boolean):Boolean {
			return (goForward && app.loaderViewStack.selectedIndex + 1 < app.loaderViewStack.swfLoaders.length)
				|| (!goForward && app.loaderViewStack.selectedIndex > 0);
		}
		
		private function withinNavigableMovie(goForward:Boolean):Boolean {
			if(!canNavMovie) 
				return false;
			return (goForward && swfAsMovieClip.currentFrame < swfAsMovieClip.totalFrames)
				|| (!goForward && swfAsMovieClip.currentFrame > 1);
		}
		
		private function getSWFLoaderRectangle():Rectangle {
			return new Rectangle(0, 0, app.loaderViewStack.width, app.loaderViewStack.height); 
		}		
		
		private function openNewSWF(openFirst:Boolean=true):void {
			canNavMovie = false;
			if(app.loaderViewStack.content is MovieClip) {
				canNavMovie = true;
				swfAsMovieClip.gotoAndStop(openFirst ? 1 : swfAsMovieClip.totalFrames);
			}
			else if(app.loaderViewStack.content is AVM1Movie) {
				Alert.show("SWFs loaded must be Flash 9 or later.  Flash 8 and earlier SWFs cannot be controlled.", "Incompatible SWF", Alert.OK);
			}	
			resizeSWF();	
			centerSWFAbsolute();
		}
		
		private function countTotalFrames(upToIndex:int=-1):int {
			var frameCount:int = 0;
			if(upToIndex == -1)
				upToIndex = app.loaderViewStack.swfLoaders.length;
			for(var i:int = 0; i < upToIndex; i++) {
				var loader:SWFLoader = app.loaderViewStack.swfLoaders[i] as SWFLoader;
				frameCount += loader.content is MovieClip ? MovieClip(loader.content).totalFrames : 1;
			}
			return frameCount;
		}
		
		private function resizeSWF():void {
			var scale:Number = ImageUtils.scaleDownValue2(getSWFLoaderRectangle(), app.loaderViewStack.content);
			trace("ViewerMediator:onLoaderContentComplete scale==" + scale);
			this.scale *= scale;
			sendNotification(ViewerFacade.SCALE_CHANGED, this.scale);
		}
		
		private function centerContainer(oldWidth:Number, oldHeight:Number):void {
			if(oldWidth == 0 || oldHeight == 0)
				return;
				
			var expanding:Boolean = oldWidth < app.loaderViewStack.content.width;
				
			if(expanding) {
				centerContainerRelativeToSWF(oldWidth, "width");
				centerContainerRelativeToSWF(oldHeight, "height");
			} else {
				centerContainerOnShrink(oldWidth, oldHeight);
			}
		}
		
		private function centerContainerRelativeToSWF(oldDimensionValue:Number, dimension:String):void {
			var containerDimensionTotal:Number = app.loaderViewStack[dimension];
			var contentDimensionTotal:Number = app.loaderViewStack.content[dimension];
			var axis:String = dimension == "width" ? "x" : "y";
			var position:Number = app.loaderViewStack.content[axis];
			
			// We want to keep the center of the container over the center of the visible part of the content
			// from before the zoom happened.
			// It's therefore necessary to find the ratio of the position of the center of the 
			// container to the total length of the content in that dimension.
			// (Subtracting the container dimensions because all the coordinates will be negative.)
			var posToTotalRatio:Number = (position - containerDimensionTotal/2)/oldDimensionValue;

			// Find the new position of the center, and then find the position of the upper left corner
			// of the content.
			var newPosition:Number = posToTotalRatio * contentDimensionTotal + containerDimensionTotal/2;
			app.loaderViewStack.content[axis] = newPosition;
		}
		
		private function centerContainerOnShrink(oldWidth:Number, oldHeight:Number):void {
			// If the content fits within the container in a dimension, we want to center it relative to the
			// container.
			// Otherwise, we want to move the content so that the same point is in the center as before the zoom,
			// while making sure that the content stays flush with the borders.
			if(contentDimensionFitsInContainer("height")) {
				centerHeightAbsolute();
			} else {
				centerContainerRelativeToSWF(oldHeight, "height");
				snapContentSides("height");
			}
			
			if(contentDimensionFitsInContainer("width")) {
				centerWidthAbsolute();
			} else {
				centerContainerRelativeToSWF(oldWidth, "width");
				snapContentSides("width");
			}
		}
		
		private function snapContentSides(dimension:String):void {
			var axis:String = dimension == "width" ? "x" : "y";
			var axisValue:Number = app.loaderViewStack.content[axis];
			var containerDimension:Number = app.loaderViewStack[dimension];
			var contentDimension:Number = app.loaderViewStack.content[dimension];
			if(axisValue > 0) {
				trace("ViewerMediator:snapContentSides " + dimension);
				app.loaderViewStack.content[axis] = 0;
			} 
			if(axisValue + contentDimension < containerDimension) {
				trace("ViewerMediator:snapContentSides " + dimension);
				app.loaderViewStack.content[axis] = containerDimension - contentDimension;
			}
		}
		
		private function contentDimensionFitsInContainer(dimension:String):Boolean {
			var containerDimension:Number = app.loaderViewStack[dimension];
			var contentDimension:Number = app.loaderViewStack.content[dimension];
			return containerDimension >= contentDimension;
		}
		
		private function centerSWFAbsolute():void {
			centerHeightAbsolute();
			centerWidthAbsolute();
		}
		
		private function centerHeightAbsolute():void {
			trace("ViewerMediator:centerHeightAbsolute");
			var loaderHeight:Number = app.loaderViewStack.height;
			var contentHeight:Number = app.loaderViewStack.content.height;
			app.loaderViewStack.content.y = (loaderHeight - contentHeight)/2;			
		}
		
		private function centerWidthAbsolute():void {
			trace("ViewerMediator:centerWidthAbsolute");
			var loaderWidth:Number = app.loaderViewStack.width;	
			var contentWidth:Number = app.loaderViewStack.content.width;	
			app.loaderViewStack.content.x = (loaderWidth - contentWidth)/2;	
		}
		
		private function pan(dimension:String, evt:MouseEvent):void {
			var axis:String = dimension == "width" ? "x" : "y";
			var panningStartAxisValue:Number = this["panningStart" + axis.toUpperCase()];
			var localAxisValue:Number = evt["local" + axis.toUpperCase()];
			// only allow panning in the dimension in which the content is larger than the container
			if(app.loaderViewStack.content[dimension] > app.loaderViewStack[dimension]) {
					var delta:Number = localAxisValue - panningStartAxisValue;
					// don't allow panning past any edge of the content
					if(app.loaderViewStack.content[axis] + delta <= 0 
						&& app.loaderViewStack.content[axis] + delta + app.loaderViewStack.content[dimension] >= app.loaderViewStack[dimension]) {
						app.loaderViewStack.content[axis] += delta;
						this["panningStart" + axis.toUpperCase()] = localAxisValue;
					}
			}
		}		
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onSWFInit(evt:Event):void {
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOrOut);
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);	
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_OUT, onMouseUpOrOut);					
			
			openNewSWF();
			sendNotification(ViewerFacade.SWF_FRAME_DATA, countTotalFrames());
			app.loaderViewStack.visible = true;
		}
		
		
		private function onMouseDown(evt:MouseEvent):void {
			trace("ViewerMediator:onMouseMove");
			isPanning = true;
			panningStartX = evt.localX;
			panningStartY = evt.localY;
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			if(isPanning) {
				pan("height", evt);
				pan("width", evt);
			}
		}
		
		private function onMouseUpOrOut(evt:MouseEvent):void {
			isPanning = false;
		}		
		
		/* --- Public Accessors --- */
		
		public function get app():PDFViewer { return viewComponent as PDFViewer; }
		
		public function get swfAsMovieClip():MovieClip { return app.loaderViewStack.content as MovieClip; }
		
		public function get scale():Number {
			return app.loaderViewStack.content.scaleX;			
		}		
		
		public function set scale(scale:Number):void {
			var oldHeight:Number = app.loaderViewStack.content.height;
			var oldWidth:Number = app.loaderViewStack.content.width;
			app.loaderViewStack.content.scaleX = scale;
			app.loaderViewStack.content.scaleY = scale;
			centerContainer(oldWidth, oldHeight);
		}
		
		/* === Public Accessors === */
		
	}
	
}
