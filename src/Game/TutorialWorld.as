/**
 * World for testing Box2D
 */
package Game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Assets.FlyingEnemy;
	import Assets.ItemDrop;
	import Assets.Platform;
	import Assets.Rain;
	
	import Parents.Stage;
	
	public class TutorialWorld extends Stage
	{
		private var screen:Sprite;
		private var background:Background;
		private var rain:Rain;
		
		private var enemyAdded:Boolean;
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function TutorialWorld(screenP:Sprite, debugging:Boolean, pacifist:Boolean, world:int)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			super(screen,debugging, 30, 7, pacifist, world, 0);
			
			this.addEventListener(Event.ENTER_FRAME, addEnemy, false, 0, true);
			enemyAdded = false;
			
			//BACKGROUND
			background = new Background("test");
			
			//RAIN
			rain = new Rain(this, 100,900,525,50, 15, 5, "left");
			
			//GROUND & SKY
			var ground:Platform = new Platform(7, 15, 300, 15, "b_wide");
			var sky:Platform = new Platform(7, -110, 275, 15, "b_wide");

			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(300,-170, 30, 200, "b_tall");

			//PLATFORMS
			var lowJump:Platform = new Platform(40, 10, 10, 2, "wide");
			var highJump:Platform = new Platform(55, 5, 10, 2, "wide");
			var hoverJump:Platform = new Platform(80, 5, 0.5, 0.5, "square");
			var doubleJump:Platform = new Platform(95, -7, 10, 2, "wide");
			var doubleHoverJump:Platform = new Platform(117, -17, 0.5, 0.5, "square");
			
			var levelOne:Platform = new Platform(100, -2, 121, 20, "b_wide");
			var levelTwo:Platform = new Platform(125, -22, 96, 25, "b_wide");

			var rightWallJump:Platform = new Platform(135, -40, 2, 10, "tall");
			var leftWallJump:Platform = new Platform(120, -50, 2, 10, "tall");
			var endWallJump:Platform = new Platform(131, -47, 10, 2, "wide");
			var singleWallJump:Platform = new Platform(143, -82, 2, 30, "tall");
			
			var leftCeilingJump:Platform = new Platform(155, -100, 3, 15, "tall");
			var middleCeilingJump:Platform = new Platform(180, -100, 3, 15, "tall");
			var rightCeilingJump:Platform = new Platform(205, -100, 3, 15, "tall");
			
			var levelThree:Platform = new Platform(150, -65, 71, 45, "b_wide");

			var channelLeft:Platform = new Platform(220,-87, 2, 120, "b_tall");
			var channelRight:Platform = new Platform(230,-120, 2, 100, "b_tall");
		}
		
		private function addEnemy(event:Event):void
		{
			if(player.body.GetPosition().x >= 235 && player.body.GetPosition().y >= 7 && !enemyAdded){
				var starterEnemy:FlyingEnemy = new FlyingEnemy(250, -20, 2,3);
				enemyAdded = true;
				var pistol:ItemDrop = new ItemDrop(270, 10, 1.5, 1.5, 2);
			}
		}
		
		public override function childDestroy():void{
			this.removeEventListener(Event.ENTER_FRAME, addEnemy);
		}
	}
}