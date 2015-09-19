/**
 * World for testing Box2D
 */
package Game
{	
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	
	import Assets.EasterEgg;
	import Assets.Platform;
	import Assets.Player;
	import Assets.Rain;
	import Assets.Weapon;
	
	import Parents.Stage;
	
	public class MovementWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;	
		
		private var enemyAdded:Boolean;
		
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		private var player:Player;
		private var weapon:Weapon;
		
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function MovementWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, _hasRain:Boolean, _settings:SharedObject,  _musicChannel:SoundChannel, _HUD:PlayerHUD, _keybindings:Object, _player:Player, _weapon:Weapon)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			settings = _settings;
			player = _player;
			weapon = _weapon;
			
			HUD = _HUD;
			super(screen,debugging, 30, 7, pacifist, world, 0, _musicChannel, settings, HUD, _keybindings, player, weapon);
						
			//BACKGROUND
			background = new Background("TutorialMovement");
			
			//RAIN
			settings = _settings;
			
			hasRain = _hasRain;
			if(hasRain){
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left", HUD);
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right", HUD);
				}
			}
			
			//GROUND & SKY
			var ground:Platform = new Platform(7, 15, 300, 15, "b_wide");
			var sky:Platform = new Platform(7, -110, 300, 15, "b_wide");

			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(300,-170, 30, 200, "b_tall");

			//PLATFORMS
			var lowJump:Platform = new Platform(40, 10, 10, 2, "wide");
			var highJump:Platform = new Platform(55, 5, 10, 2, "wide");
			var hoverJump:Platform = new Platform(79, 5, 3, 3, "square");
			var doubleJump:Platform = new Platform(95, -7, 10, 2, "wide");
			var doubleHoverJump:Platform = new Platform(115, -17, 3, 3, "square");
			
			var levelOne:Platform = new Platform(100, -2, 55, 20, "b_wide");
			var levelTwo:Platform = new Platform(125, -22, 31, 25, "b_wide");

			var rightWallJump:Platform = new Platform(135, -40, 2, 10, "tall");
			var leftWallJump:Platform = new Platform(120, -50, 2, 10, "tall");
			var endWallJump:Platform = new Platform(131, -47, 10, 2, "wide");
			var singleWallJump:Platform = new Platform(143, -82, 2, 30, "tall");
			
			var channelLeft:Platform = new Platform(155,-87, 2, 120, "b_tall");
			var channelRight:Platform = new Platform(165,-120, 2, 120, "b_tall");
			
			// Wall jumping
			for(var i:int = 0; i < 5; i++){
				var row9:Platform = new Platform(173+(i*25), -85,1, 10, "tall");
				var row8:Platform = new Platform(185+(i*25), -75,1, 10, "tall");
				var row7:Platform = new Platform(173+(i*25), -65,1, 10, "tall");
				var row6:Platform = new Platform(185+(i*25), -55,1, 10, "tall");
				var row5:Platform = new Platform(173+(i*25), -45,1, 10, "tall");
				var row4:Platform = new Platform(185+(i*25), -35,1, 10, "tall");
				var row3:Platform = new Platform(173+(i*25), -25,1, 10, "tall");
				var row2:Platform = new Platform(185+(i*25), -15,1, 10, "tall");
				var row1:Platform = new Platform(173+(i*25), 0,1, 10, "tall");
			}
			
			var egg:EasterEgg = new EasterEgg(272.5, -95, 2, 3);
		}
		
		public override function removeAddRain():void{
			if(hasRain){
				rain.destroy();
				hasRain = false;
				settings.data.hasRain = "false";
			}
			else{
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left", HUD);
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right", HUD);
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