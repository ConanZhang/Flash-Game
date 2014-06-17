/**
 *	Class to hold variables which aid in determining when an animation is finished.
 */
package  {
	
	public class EndAnimation {
		/**Class Member Variables*/
		public static var endPlayerDeath:Boolean;
		public static var endEnemyDeath:Boolean;
		public static var endGunFire:Boolean;
		
		/**Constructor*/
		public function EndAnimation() {
			//default values of animations
			endPlayerDeath = false;
			endEnemyDeath = false;
			endGunFire = false;
		}

	}
	
}
