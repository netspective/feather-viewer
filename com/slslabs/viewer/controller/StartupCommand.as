package com.slslabs.viewer.controller {
	
	import com.slslabs.viewer.controller.PrepareActorsCommand;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * Startup command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class StartupCommand extends MacroCommand {
	   
		override protected function initializeMacroCommand():void {
			addSubCommand(PrepareActorsCommand);
		}
		
	}
	
}
