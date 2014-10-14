package  {
	
	import flash.display.MovieClip;
	
	
	public class player extends MovieClip {
		
		public var dead: Boolean;		
		public var dodged: Boolean;
		
		public function player() {
			// constructor code
			dead = false;
			dodged = false;
		}
	}
	
}
