package com.slslabs.viewer.controller {
	
	import com.slslabs.viewer.model.ViewerProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * Initialize command.
	 * 
	 * <p>The initialize command is responsible for parsing the
	 * FlashVars to load the SWF/PDF and process the other
	 * customization options.</p>
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class InitializeCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var params:Object = note.getBody().parameters;
			var viewerProxy:ViewerProxy = facade.retrieveProxy(ViewerProxy.NAME) as ViewerProxy;
			
			// check for swfs
			if( params.hasOwnProperty("swfs") ) {
				viewerProxy.swfPaths = params.swfs.split(",");
			}
		}
		
	}
	
}
