/**
 * World for testing Box2D
 */
package FlashGame
{
	import flash.display.Sprite;

	import Assets.Platform;
	import Assets.Rain;
	
	import Parents.Stage;
	
	public class TutorialWorld extends Stage
	{
		private var screen:Sprite;
		private var background:Background;
		private var rain:Rain;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function TutorialWorld(screenP:Sprite, debugging:Boolean, pacifist:Boolean, nonStop:Boolean)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 30, 7, pacifist, nonStop);
			
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			
			//GROUND & SKY
			var tutorialGround:Platform = new Platform(7, 15, 275, 15, "b_wide");
			var tutorialSky:Platform = new Platform(7, -120, 275, 15, "b_wide");

			//WALLS
			var tutorialLeftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var tutorialRightWall:Platform = new Platform(250,-170, 30, 200, "b_tall");

			//PLATFORMS
			var lowJump:Platform = new Platform(40, 10.5, 10, 2, "wide");
			var highJump:Platform = new Platform(55, 5, 10, 2, "wide");
			var hoverJump:Platform = new Platform(80, 5, 0.5, 0.5, "square");
			var doubleJump:Platform = new Platform(95, -7, 10, 2, "wide");
			var doubleHoverJump:Platform = new Platform(120, -15, 0.5, 0.5, "square");

		}
	}
}