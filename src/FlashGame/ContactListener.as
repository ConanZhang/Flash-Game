/**
 * Code for Box2D contact listener.
 */
package FlashGame
{
	import Assets.Platform;
	import Assets.Player;
	
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		/**Constructor DOES NOTHING*/
		public function ContactListener(){}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			if(contact.GetFixtureA().GetUserData() == "FOOT"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Player.STATE = Player.IDLE;
			}
			else if(contact.GetFixtureA().GetUserData() == "RIGHT"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.rightWall = true;
			}
			else if(contact.GetFixtureA().GetUserData() == "LEFT"){
				Stage.jumping = false;
				Stage.airJumping = false;
				Stage.jumpTime = 0;
				Stage.jumpAmount = Stage.defaultJumpAmount;
				Stage.leftWall = true;
			}
			
			if(contact.GetFixtureB().GetUserData() == "PLATFORM"){
				trace("platform");
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			if(contact.GetFixtureA().GetUserData() == "FOOT"){
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData() == "RIGHT"){
				Stage.rightWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
			else if(contact.GetFixtureA().GetUserData() == "LEFT"){
				Stage.leftWall = false;
				Stage.jumping = true;
				Player.STATE = Player.JUMPING;
			}
		}
	}
}