package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.view.components.ViewerToolbar;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ViewerToolbar mediator.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class ViewerToolbarMediator extends Mediator {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "ViewerToolbarMediator";
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param viewComponent view component for mediator
		 */
		public function ViewerToolbarMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
		}

		override public function listNotificationInterests():Array {
			return [
			];
		}
		
		/* === Functions === */
		
		/* --- Public Accessors --- */
		
		public function get view():ViewerToolbar { return viewComponent as ViewerToolbar; }
		
		/* === Public Accessors === */
		
	}
	
}
