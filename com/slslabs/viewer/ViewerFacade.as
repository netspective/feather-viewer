package com.slslabs.viewer {
	
	import com.slslabs.viewer.controller.*;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * Application Facade.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class ViewerFacade extends Facade {
	   
		/* --- Variables --- */
		
		public static const STARTUP:String = "startup";
		
		public static const CHANGE_PAGE:String = "changePage";

		public static const SWF_FRAME_DATA:String = "swfFrameData";
		
		public static const SWF_LOADED:String = "swfLoaded";
		
		public static const UPDATE_PAGES:String = "updatePages";
		
		/* === Variables === */
		
		/* --- Functions --- */
		
		public static function getInstance():ViewerFacade {
			if(instance == null)
				instance = new ViewerFacade();
			return instance as ViewerFacade;
		}
		
		/**
		 * Starts up PDFViewer.
		 *
		 * @param app reference to the application
		 */
		public function startup(app:PDFViewer):void {
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
	        registerCommand(SWF_FRAME_DATA, SetSWFFrameDataCommand);
		}
		
		/* === Functions === */
		
	}
	
}