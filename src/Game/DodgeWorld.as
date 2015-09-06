/**
 * World for testing Box2D
 */
package Game
{
	
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	
	import Assets.BigFlyingEnemy;
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
		public function DodgeWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, _hasRain:Boolean, _settings:SharedObject,  _musicChannel:SoundChannel)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			settings = _settings;
			
			super(screen,debugging, 62, 7, pacifist, world, 0, _musicChannel, settings);
			
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			settings = _settings;
			
			hasRain = _hasRain;
			if(hasRain){
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
			}
			
			//GROUND & SKY
			var ground:Platform = new Platform(7, 15, 100, 15, "b_wide");
			var sky:Platform = new Platform(7, -110, 100, 15, "b_wide");
			
			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(100,-170, 30, 200, "b_tall");
			
			//PLATFORMS
			for(var i:int = 0; i < 4; i++){
				var row9:Platform = new Platform(41+(i*15), -80,0.5, 0.5, "square");
				var row8:Platform = new Platform(41+(i*15), -70,0.5, 0.5, "square");
				var row7:Platform = new Platform(41+(i*15), -60,0.5, 0.5, "square");
				var row6:Platform = new Platform(41+(i*15), -50,0.5, 0.5, "square");
				var row5:Platform = new Platform(41+(i*15), -40,0.5, 0.5, "square");
				var row4:Platform = new Platform(41+(i*15), -30,0.5, 0.5, "square");
				var row3:Platform = new Platform(41+(i*15), -20,0.5, 0.5, "square");
				var row2:Platform = new Platform(41+(i*15), -10,0.5, 0.5, "square");
				var row1:Platform = new Platform(41+(i*15), 0,0.5, 0.5, "square");
			}
			
			var practiceEnemy2:BigFlyingEnemy = new BigFlyingEnemy(60, -90, 4, 5,settings);
		}
		
		public override function removeAddRain():void{
			if(hasRain){
				rain.destroy();
				hasRain = false;
				settings.data.hasRain = "false";
			}
			else{
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
				hasRain = true;
				settings.data.hasRain = "true";
			}
			
			settings.flush();
		}
		
		public override function childDestroy():void{
		}
	}
}