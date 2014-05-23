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
			canJump(contact);
			super.BeginContact(contact);
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			Stage.jumping = false;
			super.EndContact(contact);
		}
		
		private function canJump(contact:b2Contact):void{
			
		}
	}
}