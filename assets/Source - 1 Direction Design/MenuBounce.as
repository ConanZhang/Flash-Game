package{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	
	public class MenuBounce extends MovieClip{
		public var menuBounceMC:MenuBounceMC = new MenuBounceMC();
		
		public function MenuBounce(){
			addChild(menuBounceMC);
			
		}
	}
}