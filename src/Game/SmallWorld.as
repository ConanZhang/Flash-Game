/**
 * Wall jumping stage for game.
 */
package Game
{
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
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
	
	public class SmallWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;
		
		private var startPlatform:Platform;
		private var reset:Boolean;
		
		private var enemyAdd:Timer;
		private var ammoAdd:Timer;
		
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function SmallWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean,world:int, difficulty:int, _hasRain:Boolean, _settings:SharedObject , _musicChannel:SoundChannel, _HUD:PlayerHUD, _keybindings:Object)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			settings = _settings;
			HUD = _HUD;
			super(screen,debugging, 139.5, -123, pacifist, world, difficulty, _musicChannel, settings, HUD, _keybindings);
						
			//BACKGROUND
			background = new Background("test");
			
			settings = _settings;
			
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
			
			//PLATFORMS
			for(var i:int = 0; i < 12; i++){
				var row13:Platform = new Platform(41+(i*25), -115,0.5, 0.5, "square");
				var row12:Platform = new Platform(53+(i*25), -105,0.5, 0.5, "square");
				var row11:Platform = new Platform(41+(i*25), -95,0.5, 0.5, "square");
				var row10:Platform = new Platform(53+(i*25), -85,0.5, 0.5, "square");
				var row9:Platform = new Platform(41+(i*25), -75,0.5, 0.5, "square");
				var row8:Platform = new Platform(53+(i*25), -65,0.5, 0.5, "square");
				var row7:Platform = new Platform(41+(i*25), -55,0.5, 0.5, "square");
				var row6:Platform = new Platform(53+(i*25), -45,0.5, 0.5, "square");
				var row5:Platform = new Platform(41+(i*25), -35,0.5, 0.5, "square");
				var row4:Platform = new Platform(53+(i*25), -25,0.5, 0.5, "square");
				var row3:Platform = new Platform(41+(i*25), -15,0.5, 0.5, "square");
				var row2:Platform = new Platform(53+(i*25), -5,0.5, 0.5, "square");
				var row1:Platform = new Platform(41+(i*25), 5,0.5, 0.5, "square");
			}
			
			//SPIKES
			for(var j:int = 0; j < 30; j++){
				var spike:Platform = new Platform(15+(j*11), 2.5,10, 3, "enemy");
			}
			
			//WALLS
			var leftWall:Platform = new Platform(-15,-250, 30, 300, "b_tall");
			var rightWall:Platform = new Platform(345,-250, 30, 300, "b_tall");
			
			//FLOOR & CEILING
			var floor:Platform = new Platform(-70, 5, 500, 15, "b_wide");
			var ceiling:Platform = new Platform(-70, -165, 500, 15, "b_wide");
			
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
				var beginAmmoDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2, settings, HUD);	
				
				ammoAdd = new Timer(15000);
				ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.start();	
			}
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemies
			if(!paused && Player.playerHealth > 0){
				var randomAdd:Number = Math.random();
				
				if(randomAdd > 0.66 && flyCount < 4){
					var testEnemy1:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 2, 3, settings, HUD);
				}
				else if(randomAdd > 0.33 && bigFlyCount < 3){
					var testEnemy2:BigFlyingEnemy = new BigFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 5, settings, HUD);
				}
				else if(smallFlyCount < 3){ 
					var testEnemy3:SmallFlyingEnemy = new SmallFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 1.5, 1.5, settings, HUD);
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
					var testEnemy4:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 0, randomDirection,  settings, HUD);
				}
					//goes up and down
				else if(randomType > 0.33){
					var testEnemy5:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 1, randomDirection,  settings, HUD);
				}
					//goes left and right
				else{
					var testEnemy6:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 4, 2, randomDirection,  settings, HUD);
				}
			}
			else if(randomAdd > 0.33 && bigPlatformCount < 3){
				//floats
				if(randomType > 0.66){
					var testEnemy7:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 0, randomDirection,  settings, HUD);
				}
					//goes up and down
				else if(randomType > 0.33){
					var testEnemy8:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 1, randomDirection,settings, HUD);
				}
					//goes left and right
				else{
					var testEnemy9:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 5, 5, 2, randomDirection,settings, HUD);
				}
			}
			else if(smallPlatformCount < 3){
				//floats
				if(randomType > 0.66){
					var testEnemy10:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 0, randomDirection,  settings, HUD);
				}
					//goes up and down
				else if(randomType > 0.33){
					var testEnemy11:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 1, randomDirection,  settings, HUD);
				}
					//goes left and right
				else{
					var testEnemy12:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-90, 2.25, 2.5, 2, randomDirection,  settings, HUD);
				}
			}	
		}
		
		private function addAmmo(e:TimerEvent):void{
			if(!paused && Player.playerHealth != 0){
				var randomDrop: Number = Math.random();
				
				if(ammunitionCount < 10){
					//pistol ammo
					if(randomDrop < 0.4){
						var pistolDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2, settings, HUD);	
					}
						//shotgun ammo
					else if(randomDrop > 0.4 && randomDrop < 0.65){
						var shotgunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2.5,2.5, 3,  settings, HUD);	
					}
						//machinegun ammo
					else if(randomDrop > 0.65 && randomDrop < 0.9){
						var machinegunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2,2, 4, settings, HUD);	
					}
					else{
						var heartDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 1, settings, HUD);	
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