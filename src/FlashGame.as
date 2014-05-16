/**
 * Main Class to Initiate World
 */
package
{
	import FlashGame.TestWorld;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class FlashGame extends Sprite
	{
		/**Class Member Variables*/
		private var test:MovieClip;
		
		/**Constructor*/
		public function FlashGame()
		{
			//create new test world
			test = new TestWorld(this);
		}
	}
}