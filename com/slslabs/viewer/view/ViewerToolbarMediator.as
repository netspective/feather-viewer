package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.view.components.ViewerToolbar;
	
	import flash.events.MouseEvent;
	
	import mx.events.ItemClickEvent;
	
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
			
			view.addEventListener(MouseEvent.CLICK, onClick);
			view.zoomBar.addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case ViewerFacade.UPDATE_PAGES:
					updatePagesLabel(note.getBody().currentPage, note.getBody().totalPages);
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				ViewerFacade.UPDATE_PAGES
			];
		}
		
		public function updatePagesLabel(currentPage:uint, totalPages:uint):void {
			view.pagesLbl.text = currentPage + "/" + totalPages;
		}
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onClick(evt:MouseEvent):void {
			switch(evt.target) {
				case view.backBtn:
				case view.fwdBtn:
					sendNotification(ViewerFacade.CHANGE_PAGE, {goForward: evt.target == view.fwdBtn});
					break;
			}
		}
		
		private function onItemClick(evt:ItemClickEvent):void {
			sendNotification(evt.item.type);
		}
		
		/* === Event Handlers === */
		
		/* --- Public Accessors --- */
		
		public function get view():ViewerToolbar { return viewComponent as ViewerToolbar; }
		
		/* === Public Accessors === */
		
	}
	
}
