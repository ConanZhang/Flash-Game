/**
 * Code for Box2D contact listener.
 */
package FlashGame
{
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
			//fixture A is foot sensor
			if(contact.GetFixtureA().GetUserData() == "foot"){
				Player.jumping = false;
				trace("contact A");
			}
			//fixture B is foot sensor
			else if(contact.GetFixtureB().GetUserData() == "foot"){
				Player.jumping = false;
				trace("contact B");
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			//fixture A is foot sensor
			if(contact.GetFixtureA().GetUserData() == "foot"){
				Player.jumping = true;
				trace("remove A");
			}
				//fixture B is foot sensor
			else if(contact.GetFixtureB().GetUserData() == "foot" ){
				Player.jumping = true;
				trace("remove B");
			}
		}
	}
}