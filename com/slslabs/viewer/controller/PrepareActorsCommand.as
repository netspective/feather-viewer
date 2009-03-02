package com.slslabs.viewer.controller {

	import com.slslabs.viewer.model.*;
	import com.slslabs.viewer.view.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * PrepareActors command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class PrepareActorsCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			//pmvcgen:register proxies
            
            //pmvcgen:register mediators
		}
		
	}
	
}
