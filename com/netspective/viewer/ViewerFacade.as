package com.netspective.viewer {
	
	import com.netspective.viewer.controller.*;
	
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
		
		public static const ZOOM_IN:String = "zoomIn";
		
		public static const ZOOM_OUT:String = "zoomOut";
		
		public static const SCALE_CHANGED:String = "scaleChanged";
		
		public static const ENABLE_FORWARD_BTN:String = "enableForwardBtn";
		
		public static const ENABLE_BACK_BTN:String = "enableBackBtn";		
		
		public static const FIT_CONTENT:String = "fitContent";
		

		/* === Variables === */
		
		/* --- Functions --- */
		
		public static function getInstance():ViewerFacade {
			if(instance == null)
				instance = new ViewerFacade();
			return instance as ViewerFacade;
		}
		
		/**
		 * Starts up FeatherViewer.
		 *
		 * @param app reference to the application
		 */
		public function startup(app:FeatherViewer):void {
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
	        registerCommand(SWF_FRAME_DATA, SetSWFFrameDataCommand);
	        registerCommand(ZOOM_IN, ZoomCommand);
	        registerCommand(ZOOM_OUT, ZoomCommand);
	        registerCommand(SCALE_CHANGED, ScaleChangedCommand);
	        registerCommand(ENABLE_BACK_BTN, EnableNavigationButtonCommand);
	        registerCommand(ENABLE_FORWARD_BTN, EnableNavigationButtonCommand);	        
		}
		
		/* === Functions === */
		
	}
	
}
