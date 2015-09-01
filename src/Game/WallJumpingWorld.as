/**
 * Wall jumping stage for game.
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
	
	public class WallJumpingWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;
		
		private var startPlatform:Platform;
		private var reset:Boolean;
		
		private var enemyAdd:Timer;
		private var ammoAdd:Timer;
		
		private var settings:SharedObject;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function WallJumpingWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean,world:int, difficulty:int, _hasRain:Boolean, _settings:SharedObject)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 139.75, -15, pacifist, world, difficulty);
									
			//BACKGROUND
			background = new Background("test");
			
			settings = _settings;
			
			//RAIN
			hasRain = _hasRain;
			
			if(hasRain){
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			}

			//PLATFORMS
			for(var i:int = 0; i < 12; i++){
				var row10:Platform = new Platform(53+(i*25), -95,1, 10, "tall");
				var row9:Platform = new Platform(41+(i*25), -85,1, 10, "tall");
				var row8:Platform = new Platform(53+(i*25), -75,1, 10, "tall");
				var row7:Platform = new Platform(41+(i*25), -65,1, 10, "tall");
				var row6:Platform = new Platform(53+(i*25), -55,1, 10, "tall");
				var row5:Platform = new Platform(41+(i*25), -45,1, 10, "tall");
				var row4:Platform = new Platform(53+(i*25), -35,1, 10, "tall");
				var row3:Platform = new Platform(41+(i*25), -25,1, 10, "tall");
				var row2:Platform = new Platform(53+(i*25), -15,1, 10, "tall");
				var row1:Platform = new Platform(41+(i*25), -5,1, 10, "tall");
			}
			
			//SPIKES
			for(var j:int = 0; j < 40; j++){
				var spike1:Platform = new Platform(-40+(j*11), 10,10, 3, "enemy");
			}
			
			//WALLS
			var leftWall:Platform = new Platform(-70,-200, 30, 250, "b_tall");
			var rightWall:Platform = new Platform(400,-200, 30, 250, "b_tall");
			
			//FLOOR & CEILING
			var floor:Platform = new Platform(-70, 12.5, 500, 15, "b_wide");
			var ceiling:Platform = new Platform(-70, -135, 500, 15, "b_wide");
			
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
			}
			enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
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
				
				if(Stage.ammunitionCount < 20){
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