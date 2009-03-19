package com.netspective.viewer.controller {
	
	import com.netspective.viewer.model.ViewerProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * LoadSWF command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class LoadSWFCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var app:FeatherViewer = note.getBody() as FeatherViewer;
			var viewerProxy:ViewerProxy = facade.retrieveProxy(ViewerProxy.NAME) as ViewerProxy;
			
			if(viewerProxy.swfPaths) {
				app.loaderViewStack.srcPaths = viewerProxy.swfPaths;
			}
		}
		
	}
	
}
