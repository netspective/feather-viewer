package com.netspective.viewer.controller {

	//pmvcgen:insert imports
	
	import com.netspective.viewer.ViewerFacade;
	import com.netspective.viewer.model.utils.ScaleUtils;
	import com.netspective.viewer.view.ViewerMediator;
	import com.netspective.viewer.view.ViewerToolbarMediator;
	
	import flash.utils.Dictionary;
	
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
			var viewerMediator:ViewerMediator = facade.retrieveMediator(ViewerMediator.NAME) as ViewerMediator;
			var toolbarMediator:ViewerToolbarMediator = facade.retrieveMediator(ViewerToolbarMediator.NAME) as ViewerToolbarMediator;

			var zoomIn:Boolean = note.getName() == ViewerFacade.ZOOM_IN;
			var scale:Number = getNewScale(viewerMediator.scale, zoomIn);

			if( !isNaN(scale) ) {
				viewerMediator.scale = ScaleUtils.clipValue(scale);
			}
			toolbarMediator.scale = viewerMediator.scale;
		}
		
		private function getNewScale(oldScale:Number, zoomIn:Boolean):Number {
			for each(var group:Object in ScaleUtils.SCALE_GROUPS) {
				if(oldScale < group.ceiling || (oldScale == group.ceiling && !zoomIn)) {
					var step:Number = group.scale;
					return zoomIn ? oldScale + step : oldScale - step;
				}
			}
			return oldScale;
		}		
		
		private function atOrBelowCeiling(scale:Number, ceiling:Number, zoomIn:Boolean):Boolean {
			return scale < ceiling || (scale == ceiling && !zoomIn);
		}	
	}
	
}
