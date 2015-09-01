/**
 * World for testing Box2D
 */
package Game
{
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import Assets.BigFlyingEnemy;
	import Assets.BigPlatformEnemy;
	import Assets.FlyingEnemy;
	import Assets.ItemDrop;
	import Assets.Platform;
	import Assets.PlatformEnemy;
	import Assets.Player;
	import Assets.Rain;
	import Assets.SmallFlyingEnemy;
	import Assets.SmallPlatformEnemy;
	
	import Parents.Stage;
	
	public class TestWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;
		
		private var ammoAdd:Timer;
		private var enemyAdd:Timer;
		
		private var settings:SharedObject;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function TestWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, difficulty:int, _hasRain:Boolean, _settings:SharedObject)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 150, 7, pacifist, world, difficulty);
			
			//BACKGROUND
			background = new Background("test");
			
			settings = _settings;
			
			//RAIN
			hasRain = _hasRain;
			
			if(hasRain){
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			}
			
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
			
			//SPIKES
			var spike1:Platform = new Platform(25, 12.5,10, 3, "enemy");
			var spike2:Platform = new Platform(240, 12.5,10, 3, "enemy");
			
			//ENEMY
			//Beginner
			if(difficulty == 0){
				enemyAdd = new Timer(7500);
			}
			//Apprentice
			else if(difficulty == 1){
				enemyAdd = new Timer(5000);
			}
			//Master
			else if(difficulty == 2){
				enemyAdd = new Timer(3500);
			}			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.start();
		
			if(!pacifist){
				//AMMO
				var beginAmmoDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2);	
				
				ammoAdd = new Timer(15000);
				ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.start();
			}
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemies
			if(!Stage.paused && Player.playerHealth > 0){
				if(Stage.flyCount < 10){
					var randomAdd:Number = Math.random();
					
					if(randomAdd > 0.66){
						var testEnemy1:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 2, 3);
					}
					else if(randomAdd > 0.33){
						var testEnemy2:BigFlyingEnemy = new BigFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 5);
					}
					else{
						var testEnemy3:SmallFlyingEnemy = new SmallFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 1.5, 1.5);
					}
				}
				
				if(Stage.platformCount < 10){
					randomAdd = Math.random();
					
					var randomType:Number = Math.random();
					var randomDirection:int;
					if(Math.random() > 0.5){
						randomDirection = 1;
					}
					else{
						randomDirection = 2;
					}
					
					if(randomAdd > 0.66){
						//floats
						if(randomType > 0.66){
							var testEnemy4:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 0, randomDirection);
						}
						//goes up and down
						else if(randomType > 0.33){
							var testEnemy5:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 1, randomDirection);
						}
						//goes left and right
						else{
							var testEnemy6:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 2, randomDirection);
						}
					}
					else if(randomAdd > 0.33){
						//floats
						if(randomType > 0.66){
							var testEnemy7:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 0, randomDirection);
						}
							//goes up and down
						else if(randomType > 0.33){
							var testEnemy8:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 1, randomDirection);
						}
							//goes left and right
						else{
							var testEnemy9:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 2, randomDirection);
						}
					}
					else{
						//floats
						if(randomType > 0.66){
							var testEnemy10:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 0, randomDirection);
						}
							//goes up and down
						else if(randomType > 0.33){
							var testEnemy11:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 1, randomDirection);
						}
							//goes left and right
						else{
							var testEnemy12:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 2, randomDirection);
						}
					}
				}
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
		
		public override function removeAddRain():void{
			if(hasRain){
				rain.destroy();
				hasRain = false;
				settings.data.hasRain = "false";
			}
			else{
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
				hasRain = true;
				settings.data.hasRain = "true";
			}
			
			settings.flush();
		}
		
		public override function childDestroy():void{
			if(ammoAdd != null){
				ammoAdd.removeEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.stop();	
			}
			enemyAdd.removeEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.stop();
		}
	}
}