/**
 * HUD for screen.
 */ 
package FlashGame
{
	import Assets.Player;
	
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class playerHUD extends Sprite
	{
		
		private var screen:Sprite;
		
		//health
		private var heart1:MovieClip;
		private var heart2:MovieClip;
		private var heart3:MovieClip;

		//slow motion bar
		private var slowMotionBar:Shape;
		
		//fade
		private var fade:Shape;
		
		/**Constructor*/
		public function playerHUD(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
			
			fade = new Shape();
			fade.graphics.beginFill(0x000000);
			fade.graphics.drawRect(0, 0, 700, 525);
			fade.graphics.endFill();
			
			fade.alpha = 0;
			
			this.addChild(fade);
			
			//health
			heart1 = new heart();
			heart2 = new heart();
			heart3 = new heart();
			
			heart1.height = 40;
			heart1.width = 40;
			heart2.height = 40;
			heart2.width = 40;
			heart3.height = 40;
			heart3.width = 40;
			
			heart1.x = 560;
			heart1.y = 75;
			heart2.x = 610;
			heart2.y = 75;
			heart3.x = 660;
			heart3.y = 75;
			
			this.addChild(heart1);
			this.addChild(heart2);
			this.addChild(heart3);
			
			//slow motion bar
			slowMotionBar = new Shape();
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
			
			this.addChild(slowMotionBar);
		}
		
		/**Called in stage update*/
		public function updateHUD():void{
			//VISUAL fade effect
			if(fade.alpha < 0.2 && Stage.usingSlowMotion && Stage.slowMotionAmount > 0){
				fade.alpha+=0.02;
			}
			else if(fade.alpha > 0 && !Stage.usingSlowMotion){
				fade.alpha-=0.02;
			}
			
			//health
			if(Player.playerHealth == 2){
				heart1.gotoAndStop("dying");
			}
			else if(Player.playerHealth == 1){
				heart2.gotoAndStop("dying");
			}
			else if(Player.playerHealth == 0){
				heart3.gotoAndStop("dying");
			}
			
			//slow motion bar
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
		}
	}
			
}