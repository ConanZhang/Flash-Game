/**
 * Main Class to Initiate World
 */
package
{
	import FlashGame.TestWorld;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**SWF Options*/
	[SWF(backgroundColor="#FFFFFF", width="800", height="600", frameRate="30")]
	
	public class FlashGame extends Sprite
	{
		/**Class Member Variables*/
		private var test:MovieClip;
		
		/**Constructor*/
		public function FlashGame()
		{
			//create new test world
			test = new TestWorld(this);
			test.stage.addEventListener(KeyboardEvent.KEY_DOWN, test.keyPressed, false, 0, true);
			test.stage.addEventListener(KeyboardEvent.KEY_UP, test.keyReleased, false, 0, true);
		}
	}
}