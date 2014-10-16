/**
 * Code for Box2D contact listener.
 */
package FlashGame
{
	import Assets.Player;
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		/**Constructor DOES NOTHING*/
		public function ContactListener(){}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			/**Jumping*/
			if(userDataB != "ENEMY" && 
			   userDataB != "HEART" &&
			   userDataB != "PISTOL_AMMO" &&
			   userDataB != "SHOTGUN_AMMO" &&
			   userDataB != "MACHINEGUN_AMMO" &&
			   userDataB != "DEAD"){
				
				if(userDataA == "FOOT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Player.STATE = Player.IDLE;
				}
				else if(userDataA == "RIGHT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.rightWall = true;
					Player.STATE = Player.R_WALL;
				}
				else if(userDataA == "LEFT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.leftWall = true;
					Player.STATE = Player.L_WALL;
				}
			}
			else if(userDataA != "ENEMY" && 
					userDataA != "HEART" &&
					userDataA != "PISTOL_AMMO" &&
					userDataA != "SHOTGUN_AMMO" &&
					userDataA != "MACHINEGUN_AMMO" &&
					userDataA != "DEAD"){
				
				if(userDataB == "FOOT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Player.STATE = Player.IDLE;
				}
				else if(userDataB == "RIGHT"){
					Stage.jumping = false;
					Stage.airJumping = false;
					Stage.jumpTime = 0;
					Stage.jumpAmount = Stage.defaultJumpAmount;
					Stage.rightWall = true;
					Player.STATE = Player.R_WALL;
				}
				else if(userDataB == "LEFT"){
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
				//take away health
				if(Player.playerInvulnerable == 0 && !Stage.slowMotion && Player.playerHealth != 0){
					Player.playerInvulnerable = 50;
					Player.playerHealth--;
					PlayerHUD.heartDamaged = true;;
					
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
						PlayerHUD.heartDamaged = true;;

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
				else{
					return;
				}
			}
			else if(userDataA == "ENEMY" && userDataB == "PLAYER"){
				//take away health
				if(Player.playerInvulnerable == 0 && !Stage.slowMotion && Player.playerHealth != 0){
					Player.playerInvulnerable = 50;
					Player.playerHealth--;
					PlayerHUD.heartDamaged = true;;
					
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
						PlayerHUD.heartDamaged = true;;

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
				else{
					return;
				}
			}
			
			/**Bullet Damage*/
			if(contact.GetFixtureA().GetUserData()[0] == "PISTOL_BULLET"){
				contact.GetFixtureA().GetUserData()[0] ="DEAD";
				if(contact.GetFixtureB().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureB().GetUserData().push(1);
				}
			}
			else if(contact.GetFixtureB().GetUserData()[0] == "PISTOL_BULLET"){
				contact.GetFixtureB().GetUserData()[0] ="DEAD";
				if(contact.GetFixtureA().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureA().GetUserData().push(1);
				}
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "SHOTGUN_BULLET"){
				contact.GetFixtureA().GetUserData()[0] ="DEAD";
				if(contact.GetFixtureB().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureB().GetUserData().push(2);
				}
			}
			else if(contact.GetFixtureB().GetUserData()[0] == "SHOTGUN_BULLET"){
				contact.GetFixtureB().GetUserData()[0] = "DEAD";
				if(contact.GetFixtureA().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureA().GetUserData().push(2);
				}
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "MACHINEGUN_BULLET"){
				contact.GetFixtureA().GetUserData()[0] ="DEAD";
				if(contact.GetFixtureB().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureB().GetUserData().push(1);
				}
			}
			else if(contact.GetFixtureB().GetUserData()[0] == "MACHINEGUN_BULLET"){
				contact.GetFixtureB().GetUserData()[0] = "DEAD";
				if(contact.GetFixtureA().GetUserData()[0] == "ENEMY"){
					contact.GetFixtureA().GetUserData().push(1);
				}
			}
			
			/**Item Drop Collected*/
			if(contact.GetFixtureA().GetUserData()[0] == "HEART" && contact.GetFixtureB().GetUserData()[0] == "PLAYER" ||
					contact.GetFixtureA().GetUserData()[0] == "PISTOL_AMMO" && contact.GetFixtureB().GetUserData()[0] == "PLAYER" ||
					contact.GetFixtureA().GetUserData()[0] == "SHOTGUN_AMMO" && contact.GetFixtureB().GetUserData()[0] == "PLAYER"||
					contact.GetFixtureA().GetUserData()[0] == "MACHINEGUN_AMMO" && contact.GetFixtureB().GetUserData()[0] == "PLAYER"){
				contact.GetFixtureA().GetUserData()[0] = "DEAD";
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "HEART" ||
					contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "PISTOL_AMMO" ||
					contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "SHOTGUN_AMMO"||
					contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "MACHINEGUN_AMMO"){
				contact.GetFixtureB().GetUserData()[0] ="DEAD";
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			if(userDataB != "ENEMY" && 
			   userDataB != "NO_JUMP" && 
			   userDataB != "DEAD"){
				
				if(userDataA == "FOOT"){
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
				else if(userDataA == "RIGHT"){
					Stage.rightWall = false;
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
				else if(userDataA == "LEFT"){
					Stage.leftWall = false;
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
			}
			else if(userDataA != "ENEMY" && 
				userDataA != "NO_JUMP" && 
				userDataA != "DEAD"){
				
				if(userDataB == "FOOT"){
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
				else if(userDataB == "RIGHT"){
					Stage.rightWall = false;
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
				else if(userDataB == "LEFT"){
					Stage.leftWall = false;
					Stage.jumping = true;
					Player.STATE = Player.JUMPING;
				}
			}
			
			
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			//disable contact between player and enemy for invulne
			if(userDataA == "PLAYER" && userDataB == "ENEMY" ||
			   userDataA == "ENEMY" && userDataB == "PLAYER"){
				
				contact.SetEnabled(false);
			}
		}
	}
}