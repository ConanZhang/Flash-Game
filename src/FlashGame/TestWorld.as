/**
 * World for testing Box2D
 */
package FlashGame
{
	import Assets.*;
	
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
			var testPlayer:Player = new Player(15, 7, 3.5);
			testPlayer.setPlayer();
			
			//GROUND
			var testGround:Ground = new Ground(7, 15, 200, 15);

			//WALLS
			var leftWall:Ground = new Ground(7,-85, 2.5, 125);
			var rightWall:Ground = new Ground(23,-85, 2.5, 125);
			
			//PLATFORMS
			for(var i:int = 0; i < 8; i++){
				var platform:Ground = new Ground(50+(i*20), 5,10, 3);
			}
			
			//test enemy
			var testEnemy:FlyingEnemy = new FlyingEnemy(35,10, 2, 3);
		}
	}
}