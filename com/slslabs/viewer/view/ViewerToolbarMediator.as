package com.slslabs.viewer.view {
	
	import com.slslabs.viewer.ViewerFacade;
	import com.slslabs.viewer.view.components.ViewerToolbar;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.events.ItemClickEvent;
	import mx.formatters.NumberFormatter;
	
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
		
		private var numberFormatter:NumberFormatter;
		
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
			view.scaleTI.addEventListener(KeyboardEvent.KEY_DOWN, onScaleChange);
			
			numberFormatter = new NumberFormatter();
			numberFormatter.precision = 0;
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
		
		private function onScaleChange(evt:KeyboardEvent):void {
			if(evt.charCode == Keyboard.ENTER || evt.charCode == Keyboard.TAB)
				sendNotification(ViewerFacade.SCALE_CHANGED, view.scaleTI.text);
		}
		
		/* === Event Handlers === */
		
		/* --- Public Accessors --- */
		
		public function get view():ViewerToolbar { return viewComponent as ViewerToolbar; }
		
		public function set scale(scale:Number):void {
			view.scaleTI.text = numberFormatter.format(scale*100) + "%";
		}
		
		/* === Public Accessors === */
		
	}
	
}
