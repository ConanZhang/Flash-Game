/**
 * World for testing Box2D
 */
package Game
{
	
	import flash.net.SharedObject;
	
	import Assets.Platform;
	import Assets.Rain;
	
	import Parents.Stage;
	
	public class DodgeWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;	
		
		private var enemyAdded:Boolean;
		
		private var settings:SharedObject;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function DodgeWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, _hasRain:Boolean, _settings:SharedObject)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 30, 7, pacifist, world, 0);
			
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			settings = _settings;
			
			hasRain = _hasRain;
			if(hasRain){
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			}
			
			//GROUND & SKY
			var ground:Platform = new Platform(7, 15, 300, 15, "b_wide");
			var sky:Platform = new Platform(7, -110, 300, 15, "b_wide");
			
			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(300,-170, 30, 200, "b_tall");
		}
		
		public override function removeAddRain():void{
			if(hasRain){
				rain.destroy();
				hasRain = false;
				settings.data.hasRain = "false";
			}
			else{
				rain = new Rain(this, 100,900,525,50, 15, 5, "left");
				hasRain = true;
				settings.data.hasRain = "true";
			}
			
			settings.flush();
		}
		
		public override function childDestroy():void{
		}
	}
}