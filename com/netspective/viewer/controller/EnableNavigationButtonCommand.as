package com.netspective.viewer.controller {

	//pmvcgen:insert imports
	
	import com.netspective.viewer.ViewerFacade;
	import com.netspective.viewer.view.ViewerToolbarMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * EnableNavigationButton command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Srdan Bejakovic srdan@smartlogicsolutions.com
	 * @date 03/18/2009
	 * @version 0.1
	 */
	public class EnableNavigationButtonCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var mediator:ViewerToolbarMediator = facade.retrieveMediator(ViewerToolbarMediator.NAME) as ViewerToolbarMediator;
			if(note.getName() == ViewerFacade.ENABLE_BACK_BTN) {
				mediator.enableBackBtn(note.getBody());
			} else {
				mediator.ensableForwardBtn(note.getBody());
			}
		}
		
	}
	
}
