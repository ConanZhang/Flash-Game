/**
 * World for testing Box2D
 */
package FlashGame
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Assets.FlyingEnemy;
	import Assets.ItemDrop;
	import Assets.Platform;
	import Assets.Player;
	import Assets.Rain;
	
	import Parents.Stage;
	import Assets.PlatformEnemy;
	
	public class TestWorld extends Stage
	{
		private var screen:Sprite;
		private var background:Background;
		private var rain:Rain;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function TestWorld(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
			
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			rain = new Rain(this, 100,900,525,100, 15, 5, "left");
			
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
			var enemyAdd:Timer = new Timer(3500);
			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.start();
			
			//AMMO
			var beginAmmoDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2);	
			
			var ammoAdd:Timer = new Timer(15000);
			ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
			ammoAdd.start();
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemy
			if(!Stage.paused && Stage.world.GetBodyCount() < 120 && Player.playerHealth != 0){
//				var testEnemy:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 2, 3);
				var testEnemy:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 3, 3);
			}
		}
		
		private function addAmmo(e:TimerEvent):void{
			if(!Stage.paused && Player.playerHealth != 0){
				var randomDrop: Number = Math.random();
				//pistol ammo
				if(randomDrop < 0.6){
					var pistolDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2);	
				}
				//shotgun ammo
				else if(randomDrop > 0.6 && randomDrop < 0.8){
					var shotgunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2.5,2.5, 3);	
				}
				//machinegun ammo
				else if(randomDrop > 0.8 && randomDrop < 1){
					var machinegunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2,2, 4);	
				}
			}
		}
	}
}