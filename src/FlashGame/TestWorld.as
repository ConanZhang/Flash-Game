/**
 * World for testing Box2D
 */
package FlashGame
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class TestWorld extends Stage
	{
		private var screen:Sprite;
		
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function TestWorld(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
		}
	}
}