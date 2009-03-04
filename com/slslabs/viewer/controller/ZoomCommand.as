package com.slslabs.viewer.controller {

	//pmvcgen:insert imports
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.view.ViewerMediator;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * Zoom command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Srdan Bejakovic  srdan@smartlogicsolutions.com
	 * @date 03/04/2009
	 * @version 0.1
	 */
	public class ZoomCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			trace("ZoomCommand:execute");
			var mediator:ViewerMediator = facade.retrieveMediator(ViewerMediator.NAME) as ViewerMediator;
			var params:Object = mediator.app.parameters;
			var zoomStep:Number = params.hasOwnProperty("zoomStep") ? params.zoomStep : ViewerFacade.DEFAULT_ZOOM_STEP;
			var zoomDirection:String = note.getName();
			mediator.zoomContent(zoomDirection, zoomStep);
		}
		
	}
	
}
