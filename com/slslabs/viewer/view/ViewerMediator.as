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
			
			app.loader.addEventListener(Event.INIT, onSWFInit);
			app.loader.addEventListener(ResizeEvent.RESIZE, onSWFLoaderResize);
			app.loader.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			app.loader.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case ViewerFacade.CHANGE_PAGE:
					if(canNavMovie) {
						note.getBody().goForward ? swfAsMovieClip.nextFrame() : swfAsMovieClip.prevFrame();
						sendNotification(ViewerFacade.UPDATE_PAGES,
							{currentPage: swfAsMovieClip.currentFrame, totalPages: swfAsMovieClip.totalFrames});
					}
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				ViewerFacade.CHANGE_PAGE
			];
		}
		
		public function zoomContent(zoomDirection:String, zoomStep:Number):void {
			var zoomFactor:Number = zoomDirection ==  ViewerFacade.ZOOM_IN ? zoomStep : -zoomStep;
			app.loader.content.scaleX += zoomFactor;
			app.loader.content.scaleY += zoomFactor;
		}
		
		private function getSWFLoaderRectangle():Rectangle {
			var width:Number = app.width - app.getStyle("paddingLeft") - app.getStyle("paddingRight");
			var height:Number = app.height - app.toolbar.height - app.getStyle("paddingTop") - app.getStyle("paddingBottom");
			return new Rectangle(0, 0, width, height); 
		}		
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onSWFInit(evt:Event):void {
			var info:LoaderInfo = app.loader.loaderInfo;
			canNavMovie = false;
			
			if(app.loader.content is MovieClip) {
				canNavMovie = true;
				swfAsMovieClip.gotoAndStop(1);
				sendNotification(ViewerFacade.SWF_FRAME_DATA, swfAsMovieClip.totalFrames);
			}
			else if(app.loader.content is AVM1Movie) {
				Alert.show("SWFs loaded must be Flash 9 or later.  Flash 8 and earlier SWFs cannot be controlled.", "Incompatible SWF", Alert.OK);
			}
		}
		
		private function onSWFLoaderResize(evt:Event):void {
			var scale:Number = ImageUtils.scaleDownValue2(getSWFLoaderRectangle(), app.loader.content);
			trace("ViewerMediator:onLoaderContentComplete scale==" + scale);
			app.loader.content.scaleX = scale;
			app.loader.content.scaleY = scale;
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			(app.loader.content as Sprite).startDrag();
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			(app.loader.content as Sprite).stopDrag();
		}		
		
		/* --- Public Accessors --- */
		
		public function get app():PDFViewer { return viewComponent as PDFViewer; }
		
		public function get swfAsMovieClip():MovieClip { return app.loader.content as MovieClip; }
		
		/* === Public Accessors === */
		
	}
	
}
