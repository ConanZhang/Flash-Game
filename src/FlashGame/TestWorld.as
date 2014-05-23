/**
 * World for testing Box2D
 */
package FlashGame
{
	import Assets.Ground;
	import Assets.Player;
	
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
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
			
			//PLAYER
			var testPlayer:Player = new Player(10, 7, 5, 5);
			testPlayer.setPlayer();
			
			//GROUND
			var testGround:Ground = new Ground(7, 15, 13, 1);
		}
	}
}