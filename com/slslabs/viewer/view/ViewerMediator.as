package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param viewComponent view component for mediator
		 */
		public function ViewerMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			facade.registerMediator( new ViewerToolbarMediator(app.toolbar) );
			
			app.loader.addEventListener(Event.INIT, onSWFInit);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case ViewerFacade.CHANGE_PAGE:
					note.getBody().goForward ? swfAsMovieClip.nextFrame() : swfAsMovieClip.prevFrame();
					sendNotification(ViewerFacade.UPDATE_PAGES,
						{currentPage: swfAsMovieClip.currentFrame, totalPages: swfAsMovieClip.totalFrames});
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
			if(app.loader.content is MovieClip) {
				swfAsMovieClip.gotoAndStop(1);
				sendNotification(ViewerFacade.SWF_FRAME_DATA, swfAsMovieClip.totalFrames);
			}
		}
		
		/* --- Public Accessors --- */
		
		public function get app():PDFViewer { return viewComponent as PDFViewer; }
		
		public function get swfAsMovieClip():MovieClip { return app.loader.content as MovieClip; }
		
		/* === Public Accessors === */
		
	}
	
}
