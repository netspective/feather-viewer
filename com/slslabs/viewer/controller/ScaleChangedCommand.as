package com.slslabs.viewer.controller {

	//pmvcgen:insert imports
	
	import com.slslabs.viewer.model.utils.ScaleUtils;
	import com.slslabs.viewer.view.ViewerMediator;
	import com.slslabs.viewer.view.ViewerToolbarMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ScaleChanged command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Srdan Bejakovic
	 * @date 03/05/2009
	 * @version 0.1
	 */
	public class ScaleChangedCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var viewerMediator:ViewerMediator = facade.retrieveMediator(ViewerMediator.NAME) as ViewerMediator;
			var toolbarMediator:ViewerToolbarMediator = facade.retrieveMediator(ViewerToolbarMediator.NAME) as ViewerToolbarMediator;
	
			var scale:Number = ScaleUtils.parseScale( note.getBody() );
			
			if( !isNaN(scale) ) {
				viewerMediator.scale = ScaleUtils.clipValue(scale);
			}
			toolbarMediator.scale = viewerMediator.scale;
		}
		
	}
	
}
