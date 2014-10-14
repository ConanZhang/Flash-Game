/**
 * Code for Box2D contact listener.
 */
package FlashGame
{
	import Assets.Player;
	
	import Box2D.Collision.b2Manifold;	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		/**Constructor DOES NOTHING*/
		public function ContactListener(){}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			if(contact.GetFixtureA().GetUserData()[0] == "FOOT" && 
			   contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
			   contact.GetFixtureB().GetUserData()[0] != "HEART" &&
			   contact.GetFixtureB().GetUserData()[0] != "PISTOL_AMMO" &&
			   contact.GetFixtureB().GetUserData()[0] != "SHOTGUN_AMMO" &&
			   contact.GetFixtureB().GetUserData()[0] != "MACHINEGUN_AMMO" &&
			   contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Player.STATE = Player.IDLE;
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "RIGHT" && 
				    contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
					contact.GetFixtureB().GetUserData()[0] != "NO_JUMP" && 
					contact.GetFixtureB().GetUserData()[0] != "HEART"&&
					contact.GetFixtureB().GetUserData()[0] != "PISTOL_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "SHOTGUN_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "MACHINEGUN_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.rightWall = true;
				Player.STATE = Player.R_WALL;
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "LEFT" && 
				    contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
					contact.GetFixtureB().GetUserData()[0] != "NO_JUMP" && 
					contact.GetFixtureB().GetUserData()[0] != "HEART"&&
					contact.GetFixtureB().GetUserData()[0] != "PISTOL_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "SHOTGUN_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "MACHINEGUN_AMMO" &&
					contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.leftWall = true;
				Player.STATE = Player.L_WALL;
			}
			/**Enemy contact*/
			else if(contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "ENEMY"){
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
			else if(contact.GetFixtureA().GetUserData()[0] == "ENEMY" && contact.GetFixtureB().GetUserData()[0] == "PLAYER"){
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
			//destroy bullet
			else if(contact.GetFixtureA().GetUserData()[0] == "PISTOL_BULLET"){
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
			//item
			else if(contact.GetFixtureA().GetUserData()[0] == "HEART" && contact.GetFixtureB().GetUserData()[0] == "PLAYER" ||
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
			if(contact.GetFixtureA().GetUserData()[0] == "FOOT" && 
			   contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
			   contact.GetFixtureB().GetUserData()[0] != "NO_JUMP" && 
			   contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "RIGHT" && 
				    contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
					contact.GetFixtureB().GetUserData()[0] != "NO_JUMP" && 
					contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.rightWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData()[0] == "LEFT" && 
				    contact.GetFixtureB().GetUserData()[0] != "ENEMY" && 
					contact.GetFixtureB().GetUserData()[0] != "NO_JUMP" && 
					contact.GetFixtureB().GetUserData()[0] != "DEAD"){
				Stage.leftWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			if(contact.GetFixtureA().GetUserData()[0] == "PLAYER" && contact.GetFixtureB().GetUserData()[0] == "ENEMY" ||
			   contact.GetFixtureA().GetUserData()[0] == "ENEMY" && contact.GetFixtureB().GetUserData()[0] == "PLAYER"){
				
				contact.SetEnabled(false);
			}
		}
	}
}