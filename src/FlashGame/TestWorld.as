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
			
			//WEAPON
			var testWeapon:Weapon = new Weapon(15, 7,2,1, "Pistol");
			
			//GROUND
			var testGround:Platform = new Platform(7, 15, 200, 15, "ground");

			//WALLS
			var leftWall:Platform = new Platform(7,-65, 2.5, 75, "tall");
			var rightWall:Platform = new Platform(23,-65, 2.5, 75, "tall");
			
			//PLATFORMS
			for(var i:int = 0; i < 8; i++){
				var topWallPlatform:Platform = new Platform(53+(i*25), -25,3, 15, "tall");
				var middleWallPlatform:Platform = new Platform(40+(i*25), -10,3, 15, "tall");
				var bottomPlatform:Platform = new Platform(48+(i*25), 7,10, 2, "wide");
			}
			for(var j:int = 0; j < 20; j++){
				var topSquarePlatform:Platform = new Platform(42+(j*12), -55,3, 3, "square");
				var middleSquarePlatform:Platform = new Platform(36+(j*12), -45,3, 3, "square");
				var bottomSquarePlatform:Platform = new Platform(42+(j*12), -35,3, 3, "square");
			}
			
			//ENEMY
//			var testEnemy:FlyingEnemy = new FlyingEnemy(0, -20, 2, 3);

//			var enemyAdd:Timer = new Timer(3000, 50);
//			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
//			enemyAdd.start();
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemy
			var testEnemy:FlyingEnemy = new FlyingEnemy(Math.random()*230, Math.random()*-55, 2, 3);
		}
	}
}