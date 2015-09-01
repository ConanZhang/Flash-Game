/**
 * Wall jumping stage for game.
 */
package Game
{
	import flash.events.Event;
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
	
	import Box2D.Common.Math.b2Vec2;
	
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
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function SmallWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean,world:int, difficulty:int, _hasRain:Boolean, _settings:SharedObject)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 139, -200, pacifist, world, difficulty);
			
			this.addEventListener(Event.ENTER_FRAME, stageBoundary, false, 0, true);
			
			//BACKGROUND
			background = new Background("test");
			
			settings = _settings;
			
			//RAIN
			hasRain = _hasRain;
			
			if(hasRain){
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			}
			
			//Platform player starts on
			startPlatform = new Platform(131, -192, 20, 3, "ground");
			
			//PLATFORMS
			for(var i:int = 0; i < 12; i++){
				var row20:Platform = new Platform(53+(i*25), -185,0.5, 0.5, "square");
				var row19:Platform = new Platform(41+(i*25), -175,0.5, 0.5, "square");
				var row18:Platform = new Platform(53+(i*25), -165,0.5, 0.5, "square");
				var row17:Platform = new Platform(41+(i*25), -155,0.5, 0.5, "square");
				var row16:Platform = new Platform(53+(i*25), -145,0.5, 0.5, "square");
				var row15:Platform = new Platform(41+(i*25), -135,0.5, 0.5, "square");
				var row14:Platform = new Platform(53+(i*25), -125,0.5, 0.5, "square");
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
			
			//WALLS
			var leftWall:Platform = new Platform(-70,-250, 30, 300, "b_tall");
			var rightWall:Platform = new Platform(400,-250, 30, 300, "b_tall");
			
			//FLOOR & CEILING
			var floor:Platform = new Platform(-70, 45, 500, 15, "b_wide");
			var ceiling:Platform = new Platform(-70, -235, 500, 15, "b_wide");
			
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
		
		/**Computes the bottom boundary of the stage and resets player if necessary*/
		private function stageBoundary(e:Event):void{
			//Fade out starting platform
			if(startPlatform.sprite.alpha > 0)
			{
				startPlatform.sprite.alpha -= 0.005;
			}
				//Delete it once it complete fades away
			else if(startPlatform.sprite.alpha == 0){
				startPlatform.destroyBody();
			}
			
			//create new starting platform for player
			if(reset){
				startPlatform.destroyAll();
				startPlatform = new Platform(player.body.GetPosition().x - 10, 15, 20, 3, "ground");
				reset = false;
			}
			
			//reset player if too far from world
			if(player.body.GetPosition().y > 30){
				player.body.SetPosition(new b2Vec2(130, -75));
				reset = true;
				PlayerHUD.heartDamaged = true;
				Player.playerHealth--;
				Player.playerInvulnerable = 50;
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
			this.removeEventListener(Event.ENTER_FRAME, stageBoundary);
			if(ammoAdd != null){
				ammoAdd.removeEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.stop();	
			}
			enemyAdd.removeEventListener(TimerEvent.TIMER, addEnemy);
			enemyAdd.stop();
		}
	}
}