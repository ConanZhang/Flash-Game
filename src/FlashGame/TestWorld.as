/**
 * World for testing Box2D
 */
package FlashGame
{
	import Assets.*;
	
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
				var highestPlatform:Ground = new Ground(40+(i*25), -40,15, 5);
				var topPlatform:Ground = new Ground(50+(i*25), -25,15, 5);
				var middlePlatform:Ground = new Ground(40+(i*25), -10,15, 5);
				var bottomPlatform:Ground = new Ground(50+(i*25), 5,15, 5);
			}
			
			//ENEMY
			var testEnemy:FlyingEnemy = new FlyingEnemy(0, -20, 2, 3);

			var enemyAdd:Timer = new Timer(3000, 30);
			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.start();
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemy
			var testEnemy:FlyingEnemy = new FlyingEnemy(Math.random()*230, Math.random()*-55, 2, 3);
		}
	}
}