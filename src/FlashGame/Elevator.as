/**
 * World for Elevator stage in game.
 */
package FlashGame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
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
	
	public class Elevator extends Stage
	{
		private var screen:Sprite;
		private var background:Background;
		private var rain:Rain;
		private var elevator:Platform;
		private var goingUp:Boolean;
		
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function Elevator(screenP:Sprite, debugging:Boolean)
		{
			super(debugging, 150, 7);
			
			screen = screenP;
			screen.addChild(this);
			
			this.addEventListener(Event.ENTER_FRAME, elevatorMovement, false, 0, true);
		
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			
			//ELEVATOR & CEILING
			elevator = new Platform(7, 15, 275, 15, "b_wide");
			goingUp = true;
			
			var ceiling:Platform = new Platform(7, -950, 275, 15, "b_wide");
			
			//WALLS
			var leftWall:Platform = new Platform(-5,-950, 30, 1000, "b_tall");
			var rightWall:Platform = new Platform(250,-950, 30, 1000, "b_tall");
			
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
		
		private function elevatorMovement(e:Event):void{
			//Apply slow motion if necessary
			if(Stage.slowMotion && Stage.slowAmount >= 0){
				if(goingUp){
					elevator.body.SetLinearVelocity(new b2Vec2(0, -11));		
				}
				else{
					elevator.body.SetLinearVelocity(new b2Vec2(0, 21));		
				}
			}
			else{
				if(goingUp){
					elevator.body.SetLinearVelocity(new b2Vec2(0, -22));		
				}
				else{
					elevator.body.SetLinearVelocity(new b2Vec2(0, 42));		
				}
			}
			
			//Set if elevator is going up or down
			if(elevator.body.GetPosition().y <= -900){
				goingUp = false;
			}
			else if(elevator.body.GetPosition().y >= 15){
				if(player.body.GetPosition().y >= 7){
					goingUp = true;
				}
				else if(!goingUp){
					elevator.body.SetLinearVelocity(new b2Vec2(0, 0));			
				}
			}
			
			//reset player if too far from world
			if(player.body.GetPosition().x < -30 || player.body.GetPosition().y > 50 || player.body.GetPosition().x > 330){
				player.body.SetPosition(new b2Vec2(100, -10) );
				PlayerHUD.heartDamaged = true;
				Player.playerHealth--;
			}
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemies
			if(!Stage.paused && Player.playerHealth > 0){
				if(Stage.flyCount < 10){
					var randomAdd:Number = Math.random();
					
					if(randomAdd > 0.66){
						var testEnemy1:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-900, 2, 3);
					}
					else if(randomAdd > 0.33){
						var testEnemy2:BigFlyingEnemy = new BigFlyingEnemy(Math.random()*190 + 40, Math.random()*-900, 4, 5);
					}
					else{
						var testEnemy3:SmallFlyingEnemy = new SmallFlyingEnemy(Math.random()*190 + 40, Math.random()*-900, 1.5, 1.5);
					}
				}
				
				if(Stage.platformCount < 10){
					randomAdd = Math.random();
					
					if(randomAdd > 0.66){
						//circles left
						if(Math.random() > 0.5){
							var testEnemy4:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 4, 4, 1);
						}
							//circles right
						else{
							var testEnemy5:PlatformEnemy = new PlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 4, 4, 2);
						}
					}
					else if(randomAdd > 0.33){
						//circles left
						if(Math.random() > 0.5){
							var testEnemy6:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 5, 5, 1);
						}
							//circles right
						else{
							var testEnemy7:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 5, 5, 2);
						}
					}
					else{
						if(Math.random() > 0.5){
							var testEnemy8:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 2.25,2.5, 1);
						}
						else{
							var testEnemy9:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*190 + 40, Math.random()*-900, 2.25,2.5, 2);
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
					var pistolDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-900, 1.5,1.5, 2);	
				}
					//shotgun ammo
				else if(randomDrop > 0.6 && randomDrop < 0.8){
					var shotgunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-900, 2.5,2.5, 3);	
				}
					//machinegun ammo
				else if(randomDrop > 0.8 && randomDrop < 1){
					var machinegunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-900, 2,2, 4);	
				}
			}
		}
	}
}