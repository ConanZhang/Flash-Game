/**
 * Code for Box2D contact listener.
 */
package Game
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import Assets.Player;
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		private var settings:SharedObject;
		
		/**Constructor DOES NOTHING*/
		public function ContactListener( _settings:SharedObject)
		{
			settings = _settings;
		}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			/**Jumping*/
			if(userDataA == "PLAYER" &&
			   userDataB != "ENEMY" && 
			   userDataB != "ITEM" &&
			   userDataB != "DEAD" &&
			   userDataB != "NO_JUMP"){
				var playerDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(playerDataA == "FOOT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.floor = true;
					Player.STATE = Player.IDLE;
				}
				else if(playerDataA == "RIGHT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.rightWall = true;
					Player.STATE = Player.R_WALL;
				}
				else if(playerDataA == "LEFT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.leftWall = true;
					Player.STATE = Player.L_WALL;
				}
			}
			else if(userDataB == "PLAYER" &&
				    userDataA != "ENEMY" && 
					userDataA != "ITEM" &&
					userDataA != "DEAD" &&
					userDataA != "NO_JUMP"){
				
				var playerDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				if(playerDataB == "FOOT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.floor = true;
					Player.STATE = Player.IDLE;
				}
				else if(playerDataB == "RIGHT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.rightWall = true;
					Player.STATE = Player.R_WALL;
				}
				else if(playerDataB == "LEFT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.leftWall = true;
					Player.STATE = Player.L_WALL;
				}
			}
			
			/**Enemy contact*/
			if(userDataA == "PLAYER" && userDataB == "ENEMY"){
				if(contact.GetFixtureA().GetUserData()[1] == "BODY"){
					//take away health
					if(Player.playerInvulnerable == 0 && !Stage.slowMotion && Player.playerHealth != 0){
						Player.playerInvulnerable = 50;
						Player.playerHealth--;
						PlayerHUD.heartDamaged = true;
						
						var hit1:Sound = new Hit;
						hit1.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						
						//flinch
						if(contact.GetFixtureA().GetBody().GetPosition().x < contact.GetFixtureB().GetBody().GetPosition().x){
							Stage.playerBody.SetLinearVelocity( new b2Vec2(-75, 0) );
							Stage.flinchTime = 12;
							Player.STATE = Player.FLINCH;
						}
						else if(contact.GetFixtureA().GetBody().GetPosition().x > contact.GetFixtureB().GetBody().GetPosition().x){
							Stage.playerBody.SetLinearVelocity( new b2Vec2(75, 0) );
							Stage.flinchTime = 12;
							Player.STATE = Player.FLINCH;
						}
						
					}
						//if using slow motion, but don't have any
					else if(Stage.slowMotion && Stage.slowAmount <=0){
						if(Player.playerInvulnerable == 0 && Player.playerHealth != 0){
							Player.playerInvulnerable = 50;
							Player.playerHealth--;
							PlayerHUD.heartDamaged = true;
							
							var hit2:Sound = new Hit;
							hit2.play(0, 0, new SoundTransform(settings.data.effectsVolume));
							
							//flinch
							if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
								Stage.playerBody.SetLinearVelocity( new b2Vec2(-75, 0) );
								Stage.flinchTime = 12;
								Player.STATE = Player.FLINCH;
							}
							else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
								Stage.playerBody.SetLinearVelocity( new b2Vec2(75, 0) );
								Stage.flinchTime = 12;
								Player.STATE = Player.FLINCH;
							}
						}
					}
					else if(Stage.slowMotion && Stage.slowAmount > 0){
						Player.STATE = Player.DODGE;
					}
				}
				
			}
			else if(userDataA == "ENEMY" && userDataB == "PLAYER"){
				if(contact.GetFixtureB().GetUserData()[1] == "BODY"){
					//take away health
					if(Player.playerInvulnerable == 0 && !Stage.slowMotion && Player.playerHealth != 0){
						Player.playerInvulnerable = 50;
						Player.playerHealth--;
						PlayerHUD.heartDamaged = true;
						
						var hit3:Sound = new Hit;
						hit3.play(0, 0, new SoundTransform(settings.data.effectsVolume));

						//flinch
						if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
							Stage.playerBody.SetLinearVelocity( new b2Vec2(-75, 0) );
							Stage.flinchTime = 12;
							Player.STATE = Player.FLINCH;
						}
						else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
							Stage.playerBody.SetLinearVelocity( new b2Vec2(75, 0) );
							Stage.flinchTime = 12;
							Player.STATE = Player.FLINCH;
						}
						
					}
						//if using slow motion, but don't have any
					else if(Stage.slowMotion && Stage.slowAmount <=0){
						if(Player.playerInvulnerable == 0 && Player.playerHealth != 0){
							Player.playerInvulnerable = 50;
							Player.playerHealth--;
							PlayerHUD.heartDamaged = true;
							
							var hit4:Sound = new Hit;
							hit4.play(0, 0, new SoundTransform(settings.data.effectsVolume));

							//flinch
							if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
								Stage.playerBody.SetLinearVelocity( new b2Vec2(-75, 0) );
								Stage.flinchTime = 12;
								Player.STATE = Player.FLINCH;
							}
							else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
								Stage.playerBody.SetLinearVelocity( new b2Vec2(75, 0) );
								Stage.flinchTime = 12;
								Player.STATE = Player.FLINCH;
							}
						}
					}
					else if(Stage.slowMotion && Stage.slowAmount > 0){
						Player.STATE = Player.DODGE;
					}
				}
			}
			
			/**Platform Enemy AI*/
			if(userDataA == "ENEMY" &&
				userDataB != "ITEM" &&
				userDataB != "DEAD"){
				var enemyDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(userDataB != "GROUND" && userDataB != "NO_JUMP"){
					if(enemyDataA == "BOTTOM"){
						contact.GetFixtureA().GetUserData()[1] ="BOTTOM_ON";
					}
					else if(enemyDataA == "TOP"){
						contact.GetFixtureA().GetUserData()[1] ="TOP_ON";
					}
					else if(enemyDataA == "RIGHT"){
						contact.GetFixtureA().GetUserData()[1] ="RIGHT_ON";
					}
					else if(enemyDataA == "LEFT"){
						contact.GetFixtureA().GetUserData()[1] ="LEFT_ON";
					}
				}
				else{					
					if(enemyDataA == "BOTTOM"){
						contact.GetFixtureA().GetUserData()[1] ="BOTTOM_S";
					}
					else if(enemyDataA == "TOP"){
						contact.GetFixtureA().GetUserData()[1] ="TOP_S";
					}
					else if(enemyDataA == "RIGHT"){
						contact.GetFixtureA().GetUserData()[1] ="RIGHT_S";
					}
					else if(enemyDataA == "LEFT"){
						contact.GetFixtureA().GetUserData()[1] ="LEFT_S";
					}				
				}
								
			}
			else if(userDataB == "ENEMY" &&
				userDataA != "ITEM" &&
				userDataA != "DEAD"){
				
				var enemyDataB:* = contact.GetFixtureA().GetUserData()[1];

				if(userDataA != "GROUND" && userDataA != "NO_JUMP"){
					
					if(enemyDataB == "BOTTOM"){
						contact.GetFixtureB().GetUserData()[1] ="BOTTOM_ON";
					}
					else if(enemyDataB == "TOP"){
						contact.GetFixtureB().GetUserData()[1] ="TOP_ON";
					}
					else if(enemyDataB == "RIGHT"){
						contact.GetFixtureB().GetUserData()[1] ="RIGHT_ON";
					}
					else if(enemyDataB == "LEFT"){
						contact.GetFixtureB().GetUserData()[1] ="LEFT_ON";
					}
				}
				else{
					if(enemyDataB == "BOTTOM"){
						contact.GetFixtureB().GetUserData()[1] ="BOTTOM_S";
					}
					else if(enemyDataB == "TOP"){
						contact.GetFixtureB().GetUserData()[1] ="TOP_S";
					}
					else if(enemyDataB == "RIGHT"){
						contact.GetFixtureB().GetUserData()[1] ="RIGHT_S";
					}
					else if(enemyDataB == "LEFT"){
						contact.GetFixtureB().GetUserData()[1] ="LEFT_S";
					}
				}
				
			}
			
			/**Bullet Damage*/
			if(userDataA == "BULLET"){
				var bulletDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				//1 damage
				if(bulletDataA == "PISTOL" || bulletDataA == "MACHINEGUN"){
					contact.GetFixtureA().GetUserData()[0] ="DEAD";
					if(userDataB == "ENEMY"){
						contact.GetFixtureB().GetUserData().push(1);
					}
				}
				//2 damage
				else if(bulletDataA == "SHOTGUN"){
					contact.GetFixtureA().GetUserData()[0] ="DEAD";
					if(userDataB == "ENEMY"){
						contact.GetFixtureB().GetUserData().push(2);
					}
				}
			}
			else if(userDataB == "BULLET"){
				var bulletDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				//1 damage
				if(bulletDataB == "PISTOL" || bulletDataB == "MACHINEGUN"){
					contact.GetFixtureB().GetUserData()[0] ="DEAD";
					if(userDataA == "ENEMY"){
						contact.GetFixtureA().GetUserData().push(1);
					}
				}
				//2 damage
				else if(bulletDataB == "SHOTGUN"){
					contact.GetFixtureB().GetUserData()[0] ="DEAD";
					if(userDataA == "ENEMY"){
						contact.GetFixtureA().GetUserData().push(2);
					}
				}
			}
			
			/**Item Drop Collected*/
			if(userDataA == "ITEM" && userDataB == "PLAYER"){
				contact.GetFixtureA().GetUserData()[0] = "DEAD";
			}
			else if(userDataA == "PLAYER" && userDataB == "ITEM"){
				contact.GetFixtureB().GetUserData()[0] ="DEAD";
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			/**Jumping*/
			if(userDataA == "PLAYER" &&
			   userDataB != "ENEMY" && 
			   userDataB != "NO_JUMP" && 
			   userDataB != "DEAD"){
				
				var playerDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(playerDataA == "FOOT"){
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
					Stage.floor = false;
				}
				else if(playerDataA == "RIGHT"){
					Stage.rightWall = false;
					if(!Stage.floor){
						Stage.jumping = true;
						Player.STATE = Player.JUMPING;
					}
				}
				else if(playerDataA == "LEFT"){
					Stage.leftWall = false;
					if(!Stage.floor){
						Stage.jumping = true;
						Player.STATE = Player.JUMPING;
					}
				}
			}
			else if(userDataB == "PLAYER" &&
					userDataA != "ENEMY" && 
					userDataA != "NO_JUMP" && 
					userDataA != "DEAD"){
				
				var playerDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				if(playerDataB == "FOOT"){
					Stage.jumping = true;
					Stage.floor = false;
					Player.STATE = Player.JUMPING;
				}
				else if(playerDataB == "RIGHT"){
					Stage.rightWall = false;
					if(!Stage.floor){
						Stage.jumping = true;
						Player.STATE = Player.JUMPING;
					}
				}
				else if(playerDataB == "LEFT"){
					Stage.leftWall = false;
					Stage.jumping = true;
					if(!Stage.floor){
						Stage.jumping = true;
						Player.STATE = Player.JUMPING;
					}
				}
			}
			
			/**Platform Enemy AI*/
			if(userDataA == "ENEMY" &&
				userDataB != "ITEM" &&
				userDataB != "DEAD"){
				
				var enemyDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(enemyDataA == "BOTTOM_ON" || enemyDataA == "BOTTOM_S"){
					contact.GetFixtureA().GetUserData()[1] ="BOTTOM";
				}
				else if(enemyDataA == "RIGHT_ON" || enemyDataA == "RIGHT_S"){
					contact.GetFixtureA().GetUserData()[1] ="RIGHT";
				}
				else if(enemyDataA == "LEFT_ON" || enemyDataA == "LEFT_S"){
					contact.GetFixtureA().GetUserData()[1] ="LEFT";
				}
				else if(enemyDataA == "TOP_ON" || enemyDataA == "TOP_S"){
					contact.GetFixtureA().GetUserData()[1] ="TOP";
				}
			}
			else if(userDataB == "ENEMY" &&
				userDataA != "ITEM" &&
				userDataA != "DEAD"){
				
				var enemyDataB:* = contact.GetFixtureA().GetUserData()[1];
				
				if(enemyDataB == "BOTTOM_ON" || enemyDataB == "BOTTOM_S"){
					contact.GetFixtureB().GetUserData()[1] ="BOTTOM";
				}
				else if(enemyDataB == "RIGHT_ON" || enemyDataB == "RIGHT_S"){
					contact.GetFixtureB().GetUserData()[1] ="RIGHT";
				}
				else if(enemyDataB == "LEFT_ON" || enemyDataB == "LEFT_S"){
					contact.GetFixtureB().GetUserData()[1] ="LEFT";
				}
				else if(enemyDataB == "TOP_ON" || enemyDataB == "TOP_S"){
					contact.GetFixtureB().GetUserData()[1] ="TOP";
				}
			}
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			//disable contact between player and enemy for invulnerability
			if(userDataA == "PLAYER" && userDataB == "ENEMY" ||
			   userDataA == "ENEMY" && userDataB == "PLAYER"){
				
				contact.SetEnabled(false);
			}
		}
	}
}