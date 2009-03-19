package com.netspective.viewer.controller {
	
	import com.netspective.viewer.model.ViewerProxy;
	import com.netspective.viewer.view.ViewerToolbarMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * SetSWFFrameData command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class SetSWFFrameDataCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var viewerProxy:ViewerProxy = facade.retrieveProxy(ViewerProxy.NAME) as ViewerProxy;
			var toolbarMediator:ViewerToolbarMediator = facade.retrieveMediator(ViewerToolbarMediator.NAME) as ViewerToolbarMediator;
			viewerProxy.numFrames = uint( note.getBody() );
			toolbarMediator.updatePagesLabel(1, viewerProxy.numFrames);
		}
		
	}
	
}
