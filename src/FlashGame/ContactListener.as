/**
 * Code for Box2D contact listener.
 */
package FlashGame
{
	import Assets.Player;
	import Assets.FlyingEnemy;
	
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Common.Math.b2Vec2;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		/**Constructor DOES NOTHING*/
		public function ContactListener(){}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			if(contact.GetFixtureA().GetUserData() == "FOOT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Player.STATE = Player.IDLE;
			}
			else if(contact.GetFixtureA().GetUserData() == "RIGHT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.rightWall = true;
				Player.STATE = Player.R_WALL;
			}
			else if(contact.GetFixtureA().GetUserData() == "LEFT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.leftWall = true;
				Player.STATE = Player.L_WALL;
			}
			
			//enemy contact
			if(contact.GetFixtureA().GetUserData() == "PLAYER" && contact.GetFixtureB().GetUserData() == "ENEMY"){
				//take away health
				if(Player.playerInvulnerable == 0 && !Stage.usingSlowMotion && Player.playerHealth != 0){
					Player.playerInvulnerable = 50;
					Player.playerHealth--;
					
					//flinch
					if(contact.GetFixtureA().GetBody().GetPosition().x < contact.GetFixtureB().GetBody().GetPosition().x){
						Stage.player.SetLinearVelocity( new b2Vec2(-75, 0) );
						Stage.flinchTime = 12;
					}
					else if(contact.GetFixtureA().GetBody().GetPosition().x > contact.GetFixtureB().GetBody().GetPosition().x){
						Stage.player.SetLinearVelocity( new b2Vec2(75, 0) );
						Stage.flinchTime = 12;
					}
					
				}
				//if using slow motion, but don't have any
				else if(Stage.usingSlowMotion && Stage.slowMotionAmount <=0){
					if(Player.playerInvulnerable == 0 && Player.playerHealth != 0){
						Player.playerInvulnerable = 50;
						Player.playerHealth--;
					}
				}
				else{
					return;
				}
			}
			else if(contact.GetFixtureA().GetUserData() == "ENEMY" && contact.GetFixtureB().GetUserData() == "PLAYER"){
				//take away health
				if(Player.playerInvulnerable == 0 && !Stage.usingSlowMotion && Player.playerHealth != 0){
					Player.playerInvulnerable = 50;
					Player.playerHealth--;
					
					//flinch
					if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
						Stage.player.SetLinearVelocity( new b2Vec2(-75, 0) );
						Stage.flinchTime = 12;
					}
					else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
						Stage.player.SetLinearVelocity( new b2Vec2(75, 0) );
						Stage.flinchTime = 12;
					}
					
				}
					//if using slow motion, but don't have any
				else if(Stage.usingSlowMotion && Stage.slowMotionAmount <=0){
					if(Player.playerInvulnerable == 0 && Player.playerHealth != 0){
						Player.playerInvulnerable = 50;
						Player.playerHealth--;
					}
				}
				else{
					return;
				}
			}
			//destroy bullet
			else if(contact.GetFixtureA().GetUserData() == "BULLET"){
				contact.GetFixtureA().SetUserData("DEAD");
				if(contact.GetFixtureB().GetUserData() == "ENEMY"){
					contact.GetFixtureB().SetUserData("DAMAGE");
				}
			}
			else if(contact.GetFixtureB().GetUserData() == "BULLET"){
				contact.GetFixtureB().SetUserData("DEAD");
				if(contact.GetFixtureA().GetUserData() == "ENEMY"){
					contact.GetFixtureA().SetUserData("DAMAGE");
				}
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			if(contact.GetFixtureA().GetUserData() == "FOOT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData() == "RIGHT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.rightWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData() == "LEFT" && contact.GetFixtureB().GetUserData() != "ENEMY"){
				Stage.leftWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			if(contact.GetFixtureA().GetUserData() == "PLAYER" && contact.GetFixtureB().GetUserData() == "ENEMY" ||
			   contact.GetFixtureA().GetUserData() == "ENEMY" && contact.GetFixtureB().GetUserData() == "PLAYER"){
				
				contact.SetEnabled(false);
			}
		}
	}
}