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
			var testPlayer:Player = new Player(130, 7, 3.5);
			testPlayer.setPlayer();
			
			//GROUND & SKY
			var testGround:Platform = new Platform(7, 15, 275, 15, "b_wide");
			var testSky:Platform = new Platform(7, -120, 275, 15, "b_wide");

			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(250,-170, 30, 200, "b_tall");
			
			//PLATFORMS
			for(var i:int = 0; i < 8; i++){
				var topWallPlatform:Platform = new Platform(40+(i*25), -35,3, 15, "tall");
				var middleTopWallPlatform:Platform = new Platform(53+(i*25), -25,3, 15, "tall");
				var middleWallPlatform:Platform = new Platform(40+(i*25), -15,3, 15, "tall");
				var bottomPlatform:Platform = new Platform(49+(i*25), 5,10, 2, "wide");
			}
			for(var j:int = 0; j < 16; j++){
				var topSquarePlatform:Platform = new Platform(44+(j*12), -72,3, 3, "square");
				var middleSquarePlatform:Platform = new Platform(38+(j*12), -60,3, 3, "square");
				var bottomSquarePlatform:Platform = new Platform(44+(j*12), -48,3, 3, "square");
			}
			
			//ENEMY
			var enemyAdd:Timer = new Timer(4000);
			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.start();
			
			//AMMO
			var ammoAdd:Timer = new Timer(15000);
			ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
			ammoAdd.start();
			
			//WEAPON
			var testWeapon:Weapon = new Weapon(15, 7,2,1, "Pistol");
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemy
			if(!Stage.paused && Stage.world.GetBodyCount() < 120){
				var testEnemy:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 2, 3);
			}
		}
		
		private function addAmmo(e:TimerEvent):void{
			if(!Stage.paused){
				var itemDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2);	
			}
		}
	}
}