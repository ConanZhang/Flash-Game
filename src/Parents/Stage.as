/**
 * Parent class for all stages
 */
package Parents
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import Assets.Bullet;
	import Assets.Player;
	import Assets.Weapon;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import Game.ContactListener;
	import Game.PauseMenu;
	import Game.PlayerHUD;
	
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
		//world is in slow motion
		public static var slowMotion:Boolean;
		//amount of slow motion
		public static var slowAmount:Number;
		//paused or playing
		public static var paused:Boolean;
		//flying enemy count
		public var flyCount:int;
		//flying enemy count
		public var smallFlyCount:int;
		//flying enemy count
		public var bigFlyCount:int;
		//platform enemy count
		public var platformCount:int;
		//platform enemy count
		public var smallPlatformCount:int;
		//platform enemy count
		public var bigPlatformCount:int;
		//ammunition count
		public  var ammunitionCount:int;
		//array to hold key presses
		private var keyPresses:Array;
		
		/**WORLD*/
		//world for all objects to exist in
		private static var worldStage:b2World;
		//variable for all images to be held in for camera movement
		private static var images:Sprite;
		//HUD
		private var gameHUD:PlayerHUD;
		//speed world is; slow motion or normal
		private var speed:Number;
		//screen
		public var screen:FlashGame;
		
		/**GAME*/
		//delay controls
		private var beginTimer:Timer;
		//pause
		private var pauseMenu:PauseMenu;
		//rain
		public var hasRain:Boolean;
		
		/**PLAYER*/
		//player
		private var player:Player;
		//player body for collision detection
		public static var playerBody:b2Body;
		//the last position the player was (for speed calculation)
		private var lastPos:Point;
		//horizontal speed
		private var horizontal:Number;
		//vertical speed
		private var vertical:Number;
		//acceleration
		private var acceleration:Number;
		//is the player jumping
		public static var jumping:Boolean;
		//is the player air jumping
		public var airJumping:Boolean;
		//is the player wall jumping from the right
		public var rightWall:Boolean;
		//is the player wall jumping from the left
		public var leftWall:Boolean;
		//is the player standing
		public var floor:Boolean;
		//how long have they been jumping
		public var jumpTime:int;
		//limit to length of jumping
		public var jumpLimit:int;
		//current number of times player can jump
		public const defaultJumpAmount:int = 2;
		//current number of times player can jump
		public var jumpAmount:int;
		//fix player rotation speed after slow motion is over
		private var slowRotation:Boolean;
		//flinching
		public static var flinchTime:int;
		
		/**WEAPON*/
		private var weapon:Weapon;
		public static var machineFire:Boolean;
		private var machineDelay:int;
		
		private var pacifistState:Boolean;
		private var worldState:int;
		private var difficultyState:int;
		
		/**AUDIO**/
		private var musicChannel:SoundChannel;
		
		private var stageMusic:Sound;
		private var settings:SharedObject;
		private var keybindings:Object;
		
		private var backgroundBlock:Shape;
		
		/**Constructor*/
		public function Stage(screenP:FlashGame, debugging:Boolean, playerX:Number, playerY:Number, pacifist:Boolean, world:int, difficulty:int, _musicChannel:SoundChannel,  _settings:SharedObject, _HUD:PlayerHUD, _keybindings:Object, _player:Player, _weapon:Weapon)
		{
			screen = screenP;
			pacifistState = pacifist;
			worldState = world;
			difficultyState = difficulty;
			
			settings = _settings;
			settings = SharedObject.getLocal("Settings");
			keybindings = _keybindings;
			musicChannel = _musicChannel;
			
			stageMusic = new MenuMusic;
			musicChannel = stageMusic.play(0, int.MAX_VALUE);
			musicChannel.soundTransform = new SoundTransform(settings.data.musicVolume);
			
			backgroundBlock = new Shape();
			backgroundBlock.graphics.beginFill(0x080808); 
			backgroundBlock.graphics.drawRect(-700, 0, 2100, 525);
			backgroundBlock.graphics.endFill(); 
			
			if(settings.data.night != null){
				if(settings.data.night == "true"){
					addChildAt(backgroundBlock, 0);
				}
			}
			else{
				settings.data.night = "false";
				settings.flush();
			}
			
			/**BOX2D*/
			//initiate time
			iterations = 10;
			timeStep = 1/30;
						
			/**LOGIC*/
			keyPresses = new Array();
			flyCount = 0;
			smallFlyCount = 0;
			bigFlyCount = 0;
			platformCount = 0;
			smallPlatformCount = 0;
			bigPlatformCount = 0;
			ammunitionCount = 0;
			
			/**VISUAL*/
			//initiate images
			images = new Sprite();
			this.addChild(images);
			
			/**EVENT*/
			paused = false;
			
			//HUD
			slowAmount = 225;
			gameHUD = _HUD;
			this.addChild(gameHUD);
			
			/**WORLD*/
			var gravity:b2Vec2 = new b2Vec2(0, 85);
			var doSleep:Boolean = true;//don't simulate sleeping bodies
			worldStage = new b2World(gravity, doSleep);
			
			//PLAYER
			player = _player;
			player.position = new Point(playerX, playerY);
			player.stage_Sprite = images;
			player.world_Sprite = worldStage;
			player.make();
			this.setPlayer(player.body);
			player.playerInvulnerable = 100;
			
			weapon = _weapon;
			weapon.weaponRotation = 0;
			weapon.position = new Point(15, 7);
			weapon.stage_Sprite = images;
			weapon.world_Sprite = worldStage;
			weapon.make();
			
			worldStage.SetContactListener(new ContactListener(this, settings, gameHUD, player) );
			slowMotion = false;
			speed = 1;
			
			/**PLAYER*/
			lastPos = new Point();

			horizontal = 0;
			vertical = 0;
			acceleration = 0;
			jumping = false;
			airJumping = false;
			rightWall = false;
			leftWall = false;
			floor = false;
			jumpTime = 0;
			jumpLimit = 5;
			jumpAmount = defaultJumpAmount;
			slowRotation = false;
			flinchTime = 0;
			
			//WEAPON
			machineFire = false;
			machineDelay = 2;
			
			//delay controls
			beginTimer = new Timer(3000, 1);
			beginTimer.addEventListener(TimerEvent.TIMER, addControls);
			beginTimer.start();
			
			/**DEBUGGING*/
			if(debugging){
				debugDrawing();
			}
			
		}
		
		/**Stages can update their properties*/
		public function update():void{
			if(!paused){
				//clear sprites from last frame
				sprites.graphics.clear();
				
				/**CAMERA*/
				centerScreen(playerBody.GetPosition().x, playerBody.GetPosition().y);
				
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
							case keybindings.fall:
								//downward velocity in air
								if(jumping){
									direction.Set(0, 180);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction, playerBody.GetPosition() );
									if(player.STATE != player.DODGE ){
										player.STATE = player.FAST_FALL;
									}
								}
								break;
							case keybindings.jump:
								//initial jump
								if(jumping == false && !rightWall && !leftWall){
									jumping = true;
									direction.Set(0,-25);
									playerBody.SetAwake(true);
									playerBody.ApplyImpulse(direction, playerBody.GetPosition() );
									if(player.STATE != player.DODGE ){
										player.STATE = player.JUMPING;
									}
								}
									//continuing initial jump
								else if(jumping == true && 
									jumpTime <= jumpLimit && 
									jumpAmount == defaultJumpAmount){
									jumpTime++;
									direction.Set(0,-500);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction, playerBody.GetPosition() );
								}
									//air jump initial
								else if(jumping == true &&
									jumpAmount < defaultJumpAmount && 
									jumpAmount > 0 &&
									!airJumping){
									jumpTime = 0;
									airJumping = true;
									direction.Set(playerBody.GetLinearVelocity().x,-25);
									playerBody.SetLinearVelocity(direction);
								}
									//continuing air jump
								else if(airJumping == true && 
									jumpTime <= jumpLimit && 
									jumpAmount > 0){
									jumpTime++;
									direction.Set(0,-500);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction, playerBody.GetPosition() );
								}
									//hover
								else if(jumpTime == jumpLimit+1 && playerBody.GetLinearVelocity().y > 0 || jumpAmount == 0){
									direction.Set(0,-150);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction, playerBody.GetPosition() );
									if(player.STATE != player.DODGE){
										player.STATE = player.HOVER;
									}
								}
									//initial jump off right wall
								else if(rightWall){
									jumping = true;
									rightWall = false;
									direction.Set(-90,-43);
									playerBody.SetAwake(true);
									playerBody.ApplyImpulse(direction, playerBody.GetPosition() );
									if(player.STATE != player.DODGE && !floor){
										player.STATE = player.JUMPING;
									}
								}
									//initial jump off left wall
								else if(leftWall){
									jumping = true;
									leftWall = false;
									direction.Set(90,-43);
									playerBody.SetAwake(true);
									playerBody.ApplyImpulse(direction, playerBody.GetPosition() );
									if(player.STATE != player.DODGE && !floor){
										player.STATE = player.JUMPING;
									}
								}
								break;	
							case keybindings.left:
								//limit speed
								if(horizontal>-2){
									direction.Set(-250*speed,0);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction,playerBody.GetPosition());
									if(slowMotion && slowAmount > 0){
										player.playerRotation = -20;
									}
									else{
										player.playerRotation = -40;
									}
								}
								//animation
								if(player.STATE != player.DODGE && player.STATE != player.R_WALK && player.STATE != player.R_WALK_SLOW){
									if(!jumping && !leftWall && !rightWall && !slowMotion && floor || !jumping && !leftWall && !rightWall && slowMotion && slowAmount <= 0 && floor){
										player.STATE = player.L_WALK;
									}
									else if(!jumping && !leftWall && !rightWall && slowMotion && slowAmount > 0 && floor){
										player.STATE = player.L_WALK_SLOW;
									}
									else if(leftWall){
										player.STATE = player.L_WALL;
									}
								}
								else if(player.STATE != player.DODGE && player.STATE == player.R_WALK || player.STATE == player.R_WALK_SLOW){
									player.STATE = player.IDLE;
								}
								break;
							case keybindings.right:
								//limit speed
								if(horizontal<2){
									direction.Set(250*speed,0);
									playerBody.SetAwake(true);
									playerBody.ApplyForce(direction,playerBody.GetPosition());
									if(slowMotion && slowAmount > 0){
										player.playerRotation = 20;
									}
									else{
										player.playerRotation = 40;
									}
								}
								//animation
								if(player.STATE != player.DODGE && player.STATE != player.L_WALK && player.STATE != player.L_WALK_SLOW){
									if(!jumping && !rightWall && !leftWall && !slowMotion && floor || !jumping && !rightWall && !leftWall && slowMotion && slowAmount <= 0 && floor){
										player.STATE = player.R_WALK;
									}
									else if(!jumping && !rightWall && !leftWall && slowMotion && slowAmount > 0 && floor){
										player.STATE = player.R_WALK_SLOW;
									}
									else if(rightWall){
										player.STATE = player.R_WALL;
									}
								}
								else if(player.STATE != player.DODGE && player.STATE == player.L_WALK || player.STATE == player.L_WALK_SLOW){
									player.STATE = player.IDLE;
								}
								break;
							case keybindings.slow:
								if(slowMotion == false && slowAmount > 0 && player.playerHealth > 0){
									slowMotion = true;
									jumpLimit = 12;
									if(player.playerRotation > 0){
										player.playerRotation = 20;
									}
									else{
										player.playerRotation = -20;
									}
									slowRotation = true;
									speed = 0.75;
									if(jumpTime == 6){
										jumpTime = 13;
									}
								}
								else if(slowAmount > 0 && player.playerHealth > 0){
									slowAmount-=3.375;
								}
								break;
						}
					}
					
				}
				
				//get current physics
				var currentPos:Point = new Point(playerBody.GetPosition().x, playerBody.GetPosition().y);
				var currentVelocity:Number = currentPos.x - lastPos.x;
				
				//update forces and positions
				acceleration = currentVelocity - horizontal;
				horizontal = currentVelocity;
				vertical = currentPos.y - lastPos.y;
				lastPos = currentPos;
				
				//slow meter
				if(slowAmount < 225 && !slowMotion){
					slowAmount+= 2.25;
				}
				else if(slowAmount <= 0 && slowMotion){
					jumpLimit = 5;
					speed = 1;
				}
				
				//fix rotation if necessary
				if(slowAmount <= 0 && slowRotation){
					slowRotation = false;
					player.playerRotation = 40;
				}
				
				//flinch
				if(flinchTime > 1){
					flinchTime--;
				} 	
				else if(flinchTime == 1){
					flinchTime--;
					if(jumping){
						player.STATE = player.JUMPING;
					}
					else{
						player.STATE = player.IDLE;
					}
				}
				
				var mouseDirectionX:Number = mouseX - stage.stageWidth/2;
				var mouseDirectionY:Number = mouseY - stage.stageHeight/2;
				
				weapon.weaponRotation = Math.atan2(mouseDirectionY, mouseDirectionX);
				
				//fire machine gun
				if(machineFire == true){
					if(machineDelay == 2){
						var machineBullet:Bullet = new Bullet(playerBody.GetPosition().x + 3 * Math.cos(weapon.weaponRotation), playerBody.GetPosition().y + 3 * Math.sin(weapon.weaponRotation),0.3,0.3, weapon);
						weapon.machinegunAmmo--;
						machineDelay = 0;
					}
					else{
						machineDelay++;
					}
					
					if(weapon.machinegunAmmo <= 0){
						machineFire = false;
						machineDelay = 2;
					}
				}
				
				//HUD
				gameHUD.updateHUD();
				
			}
			
			if(pauseMenu != null){
				pauseMenu.update();
			}
		}
		
		/**Stages always center the screen on the player*/
		private function centerScreen(xPos:Number, yPos:Number):void{
			//get player position and screen size
			var x_Pos:Number = xPos*metricPixRatio;
			var y_Pos:Number = yPos*metricPixRatio;
			var stageHeight:Number = stage.stageHeight;
			var stageWidth:Number = stage.stageWidth;
			
			//center screen
			images.x = -1*x_Pos + stageWidth/2;
			images.y = -1*y_Pos + stageHeight/2;
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
			if(e.keyCode == keybindings.pause){
				if(paused == false){
					pauseMenu = new PauseMenu(this, 350, 260, pacifistState, worldState, difficultyState, musicChannel, settings, keybindings);
					paused = true;
				}
				else if(paused == true){
					pauseMenu.destroy();
					pauseMenu = null;
					
					paused = false;
				}
				
				var menuSelect:Sound = new MenuSelect;
				menuSelect.play(0,0, new SoundTransform(settings.data.effectsVolume));
			}
			//change weapon
			else if(e.keyCode == keybindings.weaponLeft){
				if(weapon.weaponType == 1 && weapon.machinegunAmmo > 0){
					weapon.weaponType = 3;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 1 && weapon.machinegunAmmo <= 0 && weapon.shotgunAmmo > 0){
					weapon.weaponType = 2;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 2 && weapon.pistolAmmo > 0){
					weapon.weaponType = 1;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 2 && weapon.pistolAmmo <= 0 && weapon.machinegunAmmo > 0){
					weapon.weaponType = 3;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 3 && weapon.shotgunAmmo > 0){
					weapon.weaponType = 2;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 3 && weapon.shotgunAmmo <= 0 && weapon.pistolAmmo > 0){
					weapon.weaponType = 1;
					weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == keybindings.weaponRight){
				if(weapon.weaponType == 1 && weapon.shotgunAmmo > 0){
					weapon.weaponType = 2;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 1 && weapon.shotgunAmmo <= 0 && weapon.machinegunAmmo > 0){
					weapon.weaponType = 3;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 2 && weapon.machinegunAmmo > 0){
					weapon.weaponType = 3;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 2 && weapon.machinegunAmmo <= 0 && weapon.pistolAmmo > 0){
					weapon.weaponType = 1;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 3 && weapon.pistolAmmo > 0){
					weapon.weaponType = 1;
					weapon.changeWeapon = true;
				}
				else if(weapon.weaponType == 3 && weapon.pistolAmmo <= 0 && weapon.shotgunAmmo > 0){
					weapon.weaponType = 2;
					weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == keybindings.pistol){
				if(weapon.pistolAmmo > 0){
					weapon.weaponType = 1;
					weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == keybindings.shotgun){
				if(weapon.shotgunAmmo > 0){
					weapon.weaponType = 2;
					weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode == keybindings.machinegun){
				if(weapon.machinegunAmmo > 0){
					weapon.weaponType = 3;
					weapon.changeWeapon = true;
				}
			}
			else if(e.keyCode ==keybindings.rain){
				removeAddRain();
			}
			else if(e.keyCode == keybindings.night){
				if(settings.data.night == "true"){
					removeChild(backgroundBlock);
					settings.data.night = "false";
				}
				else{
					settings.data.night = "true";
					addChildAt(backgroundBlock, 0);	
				}
				settings.flush();
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
			if(e.keyCode == keybindings.jump){
				airJumping = false;
				if(jumpAmount > 0){
					jumpAmount--;
				}
				
				if(player.STATE == player.HOVER){
					player.STATE = player.JUMPING;
				}
			}
			else if(e.keyCode ==keybindings.fall){
				if(player.STATE == player.FAST_FALL){
					player.STATE = player.JUMPING;
				}
			}
			//movement
			else if(e.keyCode ==keybindings.right && !jumping && !rightWall || e.keyCode == keybindings.left && !jumping && !leftWall){
				player.STATE = player.IDLE;
			}
			//slow motion
			else if(e.keyCode == keybindings.slow){
				if(slowMotion == true){
					slowMotion = false;
					jumpLimit = 5;
					if(player.playerRotation > 0){
						player.playerRotation = 40;	
					}
					else{
						player.playerRotation = -40;							
					}
					speed = 1;
				}
			}
		}
		
		/**Stages can detect left clicks*/
		public function leftClick(e:MouseEvent):void{
			if(weapon.holdingWeapon && !paused && player.playerHealth > 0){
				if(weapon.weaponType == 1 && weapon.pistolAmmo > 0){
					if(weapon.weaponRotation > -1.5 && weapon.weaponRotation < 1.5 && weapon.weaponClip.endFire){
						weapon.rightFire = true;
						weapon.weaponClip.endFire = false;
						
						var pistolRight:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	
						weapon.pistolAmmo--;
					}
					else if(!weapon.leftFire && weapon.weaponClip.endFire){
						weapon.leftFire = true;
						weapon.weaponClip.endFire = false;
						
						var pistolLeft:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	
						weapon.pistolAmmo--;
					}
				}
				else if(weapon.weaponType == 2 && weapon.shotgunAmmo > 0){
					if(weapon.weaponRotation > -1.5 && weapon.weaponRotation < 1.5 && weapon.weaponClip.endFire){
						weapon.rightFire = true;
						weapon.weaponClip.endFire = false;
							
						var shotgunRight1:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);
						var shotgunRight2:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	
						var shotgunRight3:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	

						weapon.shotgunAmmo--;
					}
					else if(!weapon.leftFire && weapon.weaponClip.endFire){
						weapon.leftFire = true;
						weapon.weaponClip.endFire = false;
						
						var shotgunLeft1:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	
						var shotgunLeft2:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	
						var shotgunLeft3:Bullet = new Bullet(playerBody.GetPosition().x + Math.cos(weapon.weaponRotation), playerBody.GetPosition().y +Math.sin(weapon.weaponRotation),0.3,0.3, weapon);	

						weapon.shotgunAmmo--;
					}
				}
				else if(weapon.weaponType == 3 && weapon.machinegunAmmo > 0){
					if(weapon.weaponRotation > -1.5 && weapon.weaponRotation < 1.5){
						machineFire = true;
						weapon.rightFire = true;						
					}
					else{
						machineFire = true;
						weapon.leftFire = true;
					}
				}
			}
		}
		
		/**Stages can detect left mouse lifts*/
		public function leftUp(e:MouseEvent):void{
			if(weapon.weaponType == 3){
				machineFire = false;
				weapon.rightFire = false;
				weapon.leftFire = false;
				machineDelay = 2;
			}
		}
		
		/**Stage can detect mouse wheels*/
		public function mouseWheeled(e:MouseEvent):void{
			if(weapon.holdingWeapon && !paused && player.playerHealth != 0){
				weapon.changeWeapon = true;

				//up wheel
				if(e.delta > 0){
					if(weapon.weaponType == 1 && weapon.shotgunAmmo > 0){
						weapon.weaponType = 2;
					}
					else if(weapon.weaponType == 1 && weapon.shotgunAmmo <= 0 && weapon.machinegunAmmo > 0){
						weapon.weaponType = 3;
					}
					else if(weapon.weaponType == 2 && weapon.machinegunAmmo > 0){
						weapon.weaponType = 3;
					}
					else if(weapon.weaponType == 2 && weapon.machinegunAmmo <= 0 && weapon.pistolAmmo > 0){
						weapon.weaponType = 1;
					}
					else if(weapon.weaponType == 3 && weapon.pistolAmmo > 0){
						weapon.weaponType = 1;
					}
					else if(weapon.weaponType == 3 && weapon.pistolAmmo <= 0 && weapon.shotgunAmmo > 0){
						weapon.weaponType = 2;
					}
				}
				//down wheel
				else{
					if(weapon.weaponType == 1 && weapon.machinegunAmmo > 0){
						weapon.weaponType = 3;
					}
					else if(weapon.weaponType == 1 && weapon.machinegunAmmo <= 0 && weapon.shotgunAmmo > 0){
						weapon.weaponType = 2;
					}
					else if(weapon.weaponType == 2 && weapon.pistolAmmo > 0){
						weapon.weaponType = 1;
					}
					else if(weapon.weaponType == 2 && weapon.pistolAmmo <= 0 && weapon.machinegunAmmo > 0){
						weapon.weaponType = 3;
					}
					else if(weapon.weaponType == 3 && weapon.shotgunAmmo > 0){
						weapon.weaponType = 2;
					}
					else if(weapon.weaponType == 3 && weapon.shotgunAmmo <= 0 && weapon.pistolAmmo > 0){
						weapon.weaponType = 1;
					}
				}
			}
		}
		
		/**Add Controls to Stage*/
		private function addControls(e:TimerEvent):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, leftClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, leftUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheeled);
			beginTimer.removeEventListener(TimerEvent.TIMER, addControls);
			beginTimer.stop();
		}
		
		/**Destroy Stage*/
		public function destroy():void{
			gameHUD.destroy();
			
			musicChannel.stop();
			
			this.removeChild(images);
		
			pauseMenu = null;
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, leftClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, leftUp);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheeled);
			
			childDestroy();
			
			screen.removeChild(this);
		}
		
		/**Worlds remove differently*/
		public function childDestroy():void{}
		
		/**Remove or Add Rain*/
		public function removeAddRain():void{}
		
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
			playerBody = playerP;
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