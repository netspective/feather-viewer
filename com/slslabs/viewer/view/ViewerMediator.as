package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.utils.ImageUtils;
	
	import flash.display.AVM1Movie;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
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
			
			app.loaderViewStack.addEventListener(Event.INIT, onSWFInit);
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			app.loaderViewStack.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
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
			var width:Number = app.width - app.getStyle("paddingLeft") - app.getStyle("paddingRight");
			var height:Number = app.height - app.toolbar.height - app.getStyle("paddingTop") - app.getStyle("paddingBottom");
			return new Rectangle(0, 0, width, height); 
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
		
		private function resizeSWF(evt:Event=null):void {
			var scale:Number = ImageUtils.scaleDownValue2(getSWFLoaderRectangle(), app.loaderViewStack.content);
			trace("ViewerMediator:onLoaderContentComplete scale==" + scale);
			app.loaderViewStack.content.scaleX *= scale;
			app.loaderViewStack.content.scaleY *= scale;
			sendNotification(ViewerFacade.SCALE_CHANGED, this.scale);
		}
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onSWFInit(evt:Event):void {
			openNewSWF();
			sendNotification(ViewerFacade.SWF_FRAME_DATA, countTotalFrames());
		}
		
		
		private function onMouseDown(evt:MouseEvent):void {
			isPanning = true;
			panningStartX = evt.localX;
			panningStartY = evt.localY;
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			if(isPanning) {
				var deltaX:Number = evt.localX - panningStartX;
				var deltaY:Number = evt.localY - panningStartY;
				app.loaderViewStack.content.x += deltaX;
				app.loaderViewStack.content.y += deltaY;
				panningStartX = evt.localX;
				panningStartY = evt.localY;
			}
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			isPanning = false;
		}		
		
		/* --- Public Accessors --- */
		
		public function get app():PDFViewer { return viewComponent as PDFViewer; }
		
		public function get swfAsMovieClip():MovieClip { return app.loaderViewStack.content as MovieClip; }
		
		public function get scale():Number {
			return app.loaderViewStack.content.scaleX;			
		}		
		
		public function set scale(scale:Number):void {
			app.loaderViewStack.content.scaleX = scale;
			app.loaderViewStack.content.scaleY = scale;
		}
		
		/* === Public Accessors === */
		
	}
	
}
