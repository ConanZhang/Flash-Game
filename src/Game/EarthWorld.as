/**
 * World for testing Box2D
 */
package Game
{
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import Assets.BigFlyingEnemy;
	import Assets.BigPlatformEnemy;
	import Assets.EasterEgg;
	import Assets.FlyingEnemy;
	import Assets.ItemDrop;
	import Assets.Platform;
	import Assets.PlatformEnemy;
	import Assets.Player;
	import Assets.Rain;
	import Assets.SmallFlyingEnemy;
	import Assets.SmallPlatformEnemy;
	import Assets.Weapon;
	
	import Parents.Stage;
	
	public class EarthWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;
		
		private var ammoAdd:Timer;
		private var enemyAdd:Timer;
		
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		private var player:Player;
		private var weapon:Weapon;
		
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function EarthWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, difficulty:int, _hasRain:Boolean, _settings:SharedObject,  _musicChannel:SoundChannel, _HUD:PlayerHUD, _keybindings:Object, _player:Player, _weapon:Weapon)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			settings = _settings;
			
			HUD = _HUD;
			player = _player;
			weapon = _weapon;
			super(screen,debugging, 115, 7, pacifist, world, difficulty, _musicChannel, settings, HUD, _keybindings, player, weapon);
			
			//BACKGROUND
			background = new Background("test");
						
			//RAIN
			hasRain = _hasRain;
			
			if(hasRain){
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
			}
			
			//GROUND & SKY
			var testGround:Platform = new Platform(7, 15, 275, 15, "b_wide");
			var testSky:Platform = new Platform(7, -110, 275, 15, "b_wide");

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
			var spike2:Platform = new Platform(36, 12.5,10, 3, "enemy");
			var spike3:Platform = new Platform(47, 12.5,10, 3, "enemy");
			var spike4:Platform = new Platform(240, 12.5,10, 3, "enemy");
			var spike5:Platform = new Platform(229, 12.5,10, 3, "enemy");
			var spike6:Platform = new Platform(218, 12.5,10, 3, "enemy");
			
			for(var k:int = 0; k < 6; k++){
				var spike7:Platform = new Platform(74+(k*25), 12.5,10, 3, "enemy");
			}
			
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
				var beginAmmoDrop:ItemDrop = new ItemDrop(this, Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2, settings, HUD, player, weapon);	
				
				ammoAdd = new Timer(15000);
				ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.start();
			}
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemies
			if(!paused && player.playerHealth > 0){
				var randomAdd:Number = Math.random();
				
				if(randomAdd > 0.66 && flyCount < 4){
					var testEnemy1:FlyingEnemy = new FlyingEnemy(this, Math.random()*190 + 40, Math.random()*-90, 2, 3, settings, HUD, player, weapon);
				}
				else if(randomAdd > 0.33 && bigFlyCount < 3){
					var testEnemy2:BigFlyingEnemy = new BigFlyingEnemy(this, Math.random()*190 + 40, Math.random()*-90, 4, 5, settings, HUD, player, weapon);
				}
				else if(smallFlyCount < 3){
					var testEnemy3:SmallFlyingEnemy = new SmallFlyingEnemy(this, Math.random()*190 + 40, Math.random()*-90, 1.5, 1.5, settings, HUD, player, weapon);
				}
			}
				
			randomAdd = Math.random();
			
			var randomType:Number = Math.random();
			var randomDirection:int;
			if(Math.random() > 0.5){
				randomDirection = 1;
			}
			else{
				randomDirection = 2;
			}
			
			if(randomAdd > 0.66 && platformCount < 4){
				//floats
				if(randomType > 0.66){
					var testEnemy4:PlatformEnemy = new PlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 4, 4, 0, randomDirection,settings, HUD, player, weapon);
				}
				//goes up and down
				else if(randomType > 0.33){
					var testEnemy5:PlatformEnemy = new PlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 4, 4, 1, randomDirection, settings, HUD, player, weapon);
				}
				//goes left and right
				else{
					var testEnemy6:PlatformEnemy = new PlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 4, 4, 2, randomDirection, settings, HUD, player, weapon);
				}
			}
			else if(randomAdd > 0.33 && bigPlatformCount < 3){
				//floats
				if(randomType > 0.66){
					var testEnemy7:BigPlatformEnemy = new BigPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 5, 5, 0, randomDirection,settings, HUD, player, weapon);
				}
					//goes up and down
				else if(randomType > 0.33){
					var testEnemy8:BigPlatformEnemy = new BigPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 5, 5, 1, randomDirection,  settings, HUD, player, weapon);
				}
					//goes left and right
				else{
					var testEnemy9:BigPlatformEnemy = new BigPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 5, 5, 2, randomDirection, settings, HUD, player, weapon);
				}
			}
			else if(smallPlatformCount < 3){
				//floats
				if(randomType > 0.66){
					var testEnemy10:SmallPlatformEnemy = new SmallPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 0, randomDirection,settings, HUD, player, weapon);
				}
					//goes up and down
				else if(randomType > 0.33){
					var testEnemy11:SmallPlatformEnemy = new SmallPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 1, randomDirection,  settings, HUD, player, weapon);
				}
					//goes left and right
				else{
					var testEnemy12:SmallPlatformEnemy = new SmallPlatformEnemy(this, Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 2, randomDirection, settings, HUD, player, weapon);
				}
			}	
		}
		
		private function addAmmo(e:TimerEvent):void{
			if(!paused && player.playerHealth != 0){
				var randomDrop: Number = Math.random();
				
				if(ammunitionCount < 10){
					//pistol ammo
					if(randomDrop < 0.4){
						var pistolDrop:ItemDrop = new ItemDrop(this, Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2,  settings, HUD, player, weapon);	
					}
						//shotgun ammo
					else if(randomDrop > 0.4 && randomDrop < 0.65){
						var shotgunDrop:ItemDrop = new ItemDrop(this, Math.random()*190 + 40, Math.random()*-90, 2.5,2.5, 3,  settings, HUD, player, weapon);	
					}
						//machinegun ammo
					else if(randomDrop > 0.65 && randomDrop < 0.9){
						var machinegunDrop:ItemDrop = new ItemDrop(this, Math.random()*190 + 40, Math.random()*-90, 2,2, 4,  settings, HUD, player, weapon);	
					}
					else{
						var heartDrop:ItemDrop = new ItemDrop(this, Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 1,  settings, HUD, player, weapon);	
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
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
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