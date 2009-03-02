package com.slslabs.viewer.model {
	
	import com.slslabs.viewer.ViewerFacade;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * Viewer proxy.
	 *
	 * @langversion ActionScript 3.0
	 * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
	 * @date 03/02/2009
	 * @version 0.1
	 */
	public class ViewerProxy extends Proxy {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "ViewerProxy";
		
		/**
		 * Path from which to load the SWF.
		 */
		public var swfPath:String;
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param data data model for proxy
		 */
		public function ViewerProxy() {
			super(NAME);
			swfPath = "";
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		//addfunctions
		
		/* === Functions === */
		
		/* --- Public Accessors --- */
		
		//public function get dataObject():Object { return data; }
		
		/* === Public Accessors === */
		
	}
	
}
