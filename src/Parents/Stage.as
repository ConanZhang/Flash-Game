/**
 * Parent class for all stages
 */
package Parents
{
	import Assets.Bullet;
	import Assets.Player;
	import Assets.Weapon;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import FlashGame.ContactListener;
	import FlashGame.PlayerHUD;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Stage extends MovieClip
	{
		/**Class Member Variables*/
		//constant to determine how much a pixel is in metric units
		public const metricPixRatio: uint = 20;
		
		/**BOX2D*/
		//number of checks over position and velocity
		private var iterations:int;
		//speed of checks
		private var timeStep:Number;
		
		/**LOGIC*/
		//array to hold key presses
		private var keyPresses:Array;
		//world is in slow motion
		public static var slowMotion:Boolean;
		//amount of slow motion
		public static var slowAmount:Number;
		//speed world is; slow motion or normal
		private var speed:Number;
		//bar width
		public static var slowBarWidth:Number;
		//HUD
		private var gameHUD:PlayerHUD;
		//paused or playing
		public static var paused:Boolean;
		//rotate weapon
		public static var weaponRotation:Number;
		
		/**WORLD*/
		//world for all objects to exist in
		private static var worldStage:b2World;
		//variable for all images to be held in for camera movement
		private static var images:Sprite;
		
		/**PLAYER*/
		//player body for collision detection
		public static var player:b2Body;
		//the last position the player was (for speed calculation)
		private var lastPos:Point;
		//horizontal speed
		private static var horizontal:Number;
		//vertical speed
		private static var vertical:Number;
		//acceleration
		private var acceleration:Number;
		//is the player jumping
		public static var jumping:Boolean;
		//is the player air jumping
		public static var airJumping:Boolean;
		//is the player wall jumping from the right
		public static var rightWall:Boolean;
		//is the player wall jumping from the left
		public static var leftWall:Boolean;
		//how long have they been jumping
		public static var jumpTime:int;
		//limit to length of jumping
		public static var jumpLimit:int;
		//current number of times player can jump
		public static const defaultJumpAmount:int = 2;
		//current number of times player can jump
		public static var jumpAmount:int;
		//fix player rotation speed after slow motion is over
		private var slowRotation:Boolean;
		//flinching
		public static var flinchTime:int;
		
		
		/**Constructor*/
		public function Stage()
		{
			/**BOX2D*/
			//initiate time
			iterations = 10;
			timeStep = 1/30;
						
			/**LOGIC*/
			keyPresses = new Array();
			weaponRotation = 0;
			
			/**VISUAL*/
			//initiate images
			images = new Sprite();
			this.addChild(images);
			
			/**EVENT*/
			//update every frame
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			/**WORLD*/
			var gravity:b2Vec2 = new b2Vec2(0, 85);
			var doSleep:Boolean = true;//don't simulate sleeping bodies
			worldStage = new b2World(gravity, doSleep);
			worldStage.SetContactListener(new ContactListener() );
			slowMotion = false;
			slowAmount = 150;
			speed = 1;
			slowBarWidth = 225;
			
			/**PLAYER*/
			lastPos = new Point();

			horizontal = 0;
			vertical = 0;
			acceleration = 0;
			jumping = false;
			airJumping = false;
			rightWall = false;
			leftWall = false;
			jumpTime = 0;
			jumpLimit = 5;
			jumpAmount = defaultJumpAmount;
			slowRotation = false;
			flinchTime = 0;
			
			gameHUD = new PlayerHUD(this);
			this.addChild(gameHUD);
			
			/**DEBUGGING*/
			debugDrawing();
		}
		
		/**Stages can update their properties*/
		public function update(e:Event):void{
			//clear sprites from last frame
			sprites.graphics.clear();
			
			/**CAMERA*/
			centerScreen(player.GetPosition().x, player.GetPosition().y);
			
			/**BOX2D*/
			world.Step(timeStep,iterations,iterations);
			world.ClearForces();
			world.DrawDebugData();
			
			/**OBJECTS*/
			for(var bodies:b2Body = world.GetBodyList(); bodies; bodies = bodies.GetNext() ){
				//if they exist update them
				if(bodies.GetUserData() != null){
					bodies.GetUserData().update();
					
					//slow motion
					var bodyVelocity:b2Vec2 = bodies.GetLinearVelocity();
					if(slowMotion == true && slowAmount > 0 ){
						var slowVelocity:b2Vec2 = new b2Vec2(bodyVelocity.x*0.5,bodyVelocity.y*0.5);
						
						bodies.SetLinearVelocity(slowVelocity);
					}
					else if(slowMotion == false){
						bodies.SetLinearVelocity(bodyVelocity);
					}
				}
			}
			
			/**FORCES & KEY PRESSES*/
			var direction:b2Vec2 = new b2Vec2();
			
			for(var i:uint = 0; i < keyPresses.length;i++){
				if(flinchTime == 0){
					switch(keyPresses[i]){
						case Keyboard.S:
							//downward velocity in air
							if(jumping){
								direction.Set(0, 180);
								player.SetAwake(true);
								player.ApplyForce(direction, player.GetPosition() );
								if(Player.STATE != Player.DODGE ){
									Player.STATE = Player.FAST_FALL;
								}
							}
							break;
						case Keyboard.W:
							//initial jump
							if(jumping == false && !rightWall && !leftWall){
								jumping = true;
								direction.Set(0,-25);
								player.SetAwake(true);
								player.ApplyImpulse(direction, player.GetPosition() );
								if(Player.STATE != Player.DODGE ){
									Player.STATE = Player.JUMPING;
								}
							}
								//continuing initial jump
							else if(jumping == true && 
								jumpTime <= jumpLimit && 
								jumpAmount == defaultJumpAmount){
								jumpTime++;
								direction.Set(0,-500);
								player.SetAwake(true);
								player.ApplyForce(direction, player.GetPosition() );
							}
								//air jump initial
							else if(jumping == true &&
								jumpAmount < defaultJumpAmount && 
								jumpAmount > 0 &&
								!airJumping){
								jumpTime = 0;
								airJumping = true;
								direction.Set(player.GetLinearVelocity().x,-25);
								player.SetLinearVelocity(direction);
							}
								//continuing air jump
							else if(airJumping == true && 
								jumpTime <= jumpLimit && 
								jumpAmount > 0){
								jumpTime++;
								direction.Set(0,-500);
								player.SetAwake(true);
								player.ApplyForce(direction, player.GetPosition() );
							}
								//hover
							else if(jumpTime == jumpLimit+1 && player.GetLinearVelocity().y > 0 || jumpAmount == 0){
								direction.Set(0,-150);
								player.SetAwake(true);
								player.ApplyForce(direction, player.GetPosition() );
								if(Player.STATE != Player.DODGE){
									Player.STATE = Player.HOVER;
								}
							}
								//initial jump off right wall
							else if(rightWall){
								jumping = true;
								rightWall = false;
								direction.Set(-90,-43);
								player.SetAwake(true);
								player.ApplyImpulse(direction, player.GetPosition() );
								if(Player.STATE != Player.DODGE){
									Player.STATE = Player.JUMPING;
								}
							}
								//initial jump off left wall
							else if(leftWall){
								jumping = true;
								leftWall = false;
								direction.Set(90,-43);
								player.SetAwake(true);
								player.ApplyImpulse(direction, player.GetPosition() );
								if(Player.STATE != Player.DODGE){
									Player.STATE = Player.JUMPING;
								}
							}
							break;	
						case Keyboard.A:
							//limit speed
							if(horizontal>-2){
								direction.Set(-250*speed,0);
								player.SetAwake(true);
								player.ApplyForce(direction,player.GetPosition());
								if(slowMotion && slowAmount > 0){
									Player.playerRotation = -20;
								}
								else{
									Player.playerRotation = -40;
								}
							}
							//animation
							if(Player.STATE != Player.DODGE){
								if(!jumping && !leftWall && !slowMotion || !jumping && !leftWall && slowMotion && slowAmount <= 0){
									Player.STATE = Player.L_WALK;
								}
								else if(!jumping && !leftWall && slowMotion && slowAmount > 0){
									Player.STATE = Player.L_WALK_SLOW;
								}
								else if(leftWall){
									Player.STATE = Player.L_WALL;
								}
							}
							break;
						case Keyboard.D:
							//limit speed
							if(horizontal<2){
								direction.Set(250*speed,0);
								player.SetAwake(true);
								player.ApplyForce(direction,player.GetPosition());
								if(slowMotion && slowAmount > 0){
									Player.playerRotation = 20;
								}
								else{
									Player.playerRotation = 40;
								}
							}
							//animation
							if(Player.STATE != Player.DODGE){
								if(!jumping && !rightWall && !slowMotion || !jumping && !rightWall && slowMotion && slowAmount <= 0 ){
									Player.STATE = Player.R_WALK;
								}
								else if(!jumping && !rightWall && slowMotion && slowAmount > 0){
									Player.STATE = Player.R_WALK_SLOW;
								}
								else if(rightWall){
									Player.STATE = Player.R_WALL;
								}
							}
							break;
						case Keyboard.SPACE:
							if(slowMotion == false && slowAmount > 0 && Player.playerHealth > 0){
								slowMotion = true;
								jumpLimit = 12;
								Player.playerRotation = 20;
								slowRotation = true;
								speed = 0.75;
								if(jumpTime == 6){
									jumpTime = 13;
								}
							}
							else if(slowAmount > 0 && slowBarWidth > 0 && Player.playerHealth > 0){
								slowAmount-=2.25;
								slowBarWidth-=3.375;
							}
							break;
					}
				}
				
			}
			
			//get current physics
			var currentPos:Point = new Point(player.GetPosition().x, player.GetPosition().y);
			var currentVelocity:Number = currentPos.x - lastPos.x;
			
			//update forces and positions
			acceleration = currentVelocity - horizontal;
			horizontal = currentVelocity;
			vertical = currentPos.y - lastPos.y;
			lastPos = currentPos;
			
			//slow meter
			if(slowAmount < 150 && !slowMotion && slowBarWidth < 225){
				slowAmount+= 1.5;
				slowBarWidth += 2.25;
			}
			else if(slowAmount <= 0 && slowMotion){
				jumpLimit = 5;
				speed = 1;
			}
			
			//fix rotation if necessary
			if(slowAmount <= 0 && slowRotation){
				slowRotation = false;
				Player.playerRotation = 40;
			}
			
			//flinch
			if(flinchTime > 1){
				flinchTime--;
			} 	
			else if(flinchTime == 1){
				flinchTime--;
				if(jumping){
					Player.STATE = Player.JUMPING;
				}
				else{
					Player.STATE = Player.IDLE;
				}
			}
			
			var mouseDirectionX:Number = mouseX - stage.stageWidth/2;
			var mouseDirectionY:Number = mouseY - stage.stageHeight/2;
			
			weaponRotation = Math.atan2(mouseDirectionY, mouseDirectionX);
			
			//HUD
			gameHUD.updateHUD();
		}
		
		/**Stages always center the screen on the player*/
		private function centerScreen(xPos:Number, yPos:Number):void{
			//get player position and screen size
			var xPos:Number = xPos*metricPixRatio;
			var yPos:Number = yPos*metricPixRatio;
			var stageHeight:Number = stage.stageHeight;
			var stageWidth:Number = stage.stageWidth;
			
			//center screen
			images.x = -1*xPos + stageWidth/2;
			images.y = -1*yPos + stageHeight/2;
		}
		
		/**Stages can detect key presses*/
		public function keyPressed(e:KeyboardEvent):void{
			var inArray:Boolean = false;
			//loop over key presses
			for(var i:uint =0; i< keyPresses.length; i++){
				//check if pressed key is same as a key in the array
				if(keyPresses[i] == e.keyCode){
					inArray = true;
				}
			}
			
			//add to array if wasn't in it
			if(!inArray){
				keyPresses.push(e.keyCode);
			}
			
			//pausing
			if(e.keyCode == Keyboard.P || e.keyCode == Keyboard.R){
				if(paused == false){
					PlayerHUD.countDownText.text = "Pause!";
					pause();
				}
				else if(paused == true){
					start();
				}
			}
			//full screen
			else if(e.keyCode == Keyboard.F){
				if(stage.displayState == StageDisplayState.NORMAL){
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				else{
					stage.displayState = StageDisplayState.NORMAL;				
				}
			}
			//quality
			else if(e.keyCode == Keyboard.C){
				if(stage.quality == "LOW" ){
					stage.quality = StageQuality.MEDIUM;
				}
				else if(stage.quality == "MEDIUM"){
					stage.quality = StageQuality.HIGH;
				}
				else if(stage.quality == "HIGH" ){
					stage.quality = StageQuality.LOW;
				}
			}
			//change weapon
			else if(e.keyCode == Keyboard.Q){
				if(Weapon.weaponType == 1 && Weapon.shotgunAmmo > 0){
					Weapon.weaponType = 2;
					Weapon.changeWeapon = true;
				}
				else if(Weapon.pistolAmmo > 0){
					Weapon.weaponType = 1;
					Weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == Keyboard.E){
				if(Weapon.weaponType == 1 && Weapon.shotgunAmmo > 0){
					Weapon.weaponType = 2;
					Weapon.changeWeapon = true;
				}
				else if(Weapon.pistolAmmo > 0){
					Weapon.weaponType = 1;
					Weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == Keyboard.NUMBER_1){
				if(Weapon.pistolAmmo > 0){
					Weapon.weaponType = 1;
					Weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == Keyboard.NUMBER_2){
				if(Weapon.shotgunAmmo > 0){
					Weapon.weaponType = 2;
					Weapon.changeWeapon = true;
				}
			}
		}
		
		/**Stages can detect key releases*/
		public function keyReleased(e:KeyboardEvent):void{
			//loop over key releases
			for(var i:uint=0; i<keyPresses.length;i++){
				//check if released key is in array
				if(keyPresses[i] == e.keyCode){
					//remove it
					keyPresses.splice(i,1);
					i--;
				}
			}
			
			//jumping
			if(e.keyCode == Keyboard.W){
				airJumping = false;
				if(jumpAmount > 0){
					jumpAmount--;
				}
				
				if(Player.STATE == Player.HOVER){
					Player.STATE = Player.JUMPING;
				}
			}
			else if(e.keyCode == Keyboard.S){
				if(Player.STATE == Player.FAST_FALL){
					Player.STATE = Player.JUMPING;
				}
			}
			//movement
			else if(e.keyCode == Keyboard.D && !jumping && !rightWall || e.keyCode == Keyboard.A && !jumping && !leftWall){
				Player.STATE = Player.IDLE;
			}
			//slow motion
			else if(e.keyCode == Keyboard.SPACE){
				if(slowMotion == true){
					slowMotion = false;
					jumpLimit = 5;
					Player.playerRotation = 40;
					speed = 1;
				}
			}
			
			//pausing
			if(e.keyCode == Keyboard.P || e.keyCode == Keyboard.R){
				if(paused == false){
					paused = true;
				}
				else if(paused == true){
					paused = false;
				}
			}
		}
		
		/**Stages can detect left clicks*/
		public function leftClick(e:MouseEvent):void{
			if(Weapon.holdingWeapon && !paused && Player.playerHealth > 0){
				if(Weapon.weaponType == 1){
					if(weaponRotation > -1.5 && weaponRotation < 1.5){
						Weapon.rightFire = true;
						var pistolRight:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
						Weapon.pistolAmmo--;
					}
					else if(!Weapon.leftFire){
						Weapon.leftFire = true;
						var pistolLeft:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
						Weapon.pistolAmmo--;
					}
					else if(Weapon.rightFire && !EndAnimation.endGunFire || Weapon.leftFire && !EndAnimation.endGunFire){
						EndAnimation.endGunFire = true;
						
						if(weaponRotation > -1.5 && weaponRotation < 1.5){
							var pistol_Right:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							Weapon.pistolAmmo--;
						}
						else{
							var pistol_Left:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							Weapon.pistolAmmo--;
						}
					}	
				}
				else if(Weapon.weaponType == 2){
					if(weaponRotation > -1.5 && weaponRotation < 1.5){
						Weapon.rightFire = true;
						
						var shotgunRight1:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);
						var shotgunRight2:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
						var shotgunRight3:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	

						Weapon.shotgunAmmo--;
					}
					else if(!Weapon.leftFire){
						Weapon.leftFire = true;
						
						var shotgunLeft1:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
						var shotgunLeft2:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
						var shotgunLeft3:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	

						Weapon.shotgunAmmo--;
					}
					else if(Weapon.rightFire && !EndAnimation.endGunFire || Weapon.leftFire && !EndAnimation.endGunFire){
						EndAnimation.endGunFire = true;
						
						if(weaponRotation > -1.5 && weaponRotation < 1.5){
							var shotgun_Right1:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							var shotgun_Right2:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							var shotgun_Right3:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							
							Weapon.shotgunAmmo--;
						}
						else{
							var shotgun_Left1:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							var shotgun_Left2:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							var shotgun_Left3:Bullet = new Bullet(player.GetPosition().x + Math.cos(weaponRotation), player.GetPosition().y +Math.sin(weaponRotation),0.3,0.3);	
							
							Weapon.shotgunAmmo--;
						}
					}	
				}
			}
		}
		
		/**Stage can detect mouse wheels*/
		public function mouseWheeled(e:MouseEvent):void{
			if(Weapon.holdingWeapon && !paused && Player.playerHealth != 0){
				Weapon.changeWeapon = true;

				//up wheel
				if(e.delta > 0){
					if(Weapon.weaponType == 1 && Weapon.shotgunAmmo > 0){
						Weapon.weaponType = 2;
					}
					else if(Weapon.pistolAmmo > 0){
						Weapon.weaponType = 1;
					}
				}
					//down wheel
				else{
					if(Weapon.weaponType == 1 && Weapon.shotgunAmmo > 0){
						Weapon.weaponType = 2;
					}
					else if(Weapon.pistolAmmo > 0){
						Weapon.weaponType = 1;
					}
				}
			}
		}
		
		/**Play*/
		public function start():void{
			stage.frameRate = 30;
		}
		
		/**Pause*/
		public function pause():void{
			stage.frameRate = 0;
		}
		
		/**Get and Set for stageWorld*/
		static public function get world():b2World{ return worldStage; }
		static public function set world(worldStageP:b2World):void{
			if(worldStage == null){
				worldStage = worldStageP;
			}
		}
		
		/**Get and Set for images*/
		static public function get sprites():Sprite{ return images; }
		static public function set sprites(imagesP:Sprite):void{
			if(images == null){
				images = imagesP;
			}
		}
		
		/**Set player*/
		protected function setPlayer(playerP:b2Body):void{
			player = playerP;
		}
		
		/**Draws Box2D collision shapes*/
		private function debugDrawing():void{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(images);
			debugDraw.SetDrawScale(metricPixRatio);
			debugDraw.SetAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			worldStage.SetDebugDraw(debugDraw);
		}
	}
}