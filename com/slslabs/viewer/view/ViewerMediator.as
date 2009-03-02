package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	
	import flash.display.AVM1Movie;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.controls.Alert;
	
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
		
		/* --- Public Accessors --- */
		
		public function get app():PDFViewer { return viewComponent as PDFViewer; }
		
		public function get swfAsMovieClip():MovieClip { return app.loader.content as MovieClip; }
		
		/* === Public Accessors === */
		
	}
	
}
