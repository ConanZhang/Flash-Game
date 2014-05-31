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
			var testPlayer:Player = new Player(10, 7, 5);
			testPlayer.setPlayer();
			
			//GROUND
			var testGround:Ground = new Ground(7, 15, 300, 5);
		
			//WALLS
			var leftWall:Ground = new Ground(7,-100, 5, 100);
			var rightWall:Ground = new Ground(30,-100, 5, 100);
			
			//PLATFORMS
			for(var i:int = 0; i < 7; i++){
				var topPlatform:Ground = new Ground(50+(i*40), -55, 20, 4);
				var middlePlatform:Ground = new Ground(80+(i*40), -30, 20, 4);
				var bottomPlatform:Ground = new Ground(50+(i*40), -5, 20, 4);
			}
		}
	}
}