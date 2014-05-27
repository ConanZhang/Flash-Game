package FlashGame
{
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class DebugScreen extends MovieClip
	{
		/**Class Member Variables*/
		//begin timing
		public var start:Number;
		//counter
		public var frameRate:Number;
		//display counter
		public var FPS:TextField;
		//player location display
		public var playerPos:TextField;
		
		
		private var screen:Sprite;
		
		/**Constructor*/
		public function DebugScreen(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
			
			//initialize class member variables
			start = getTimer();//MILLISECONDS
			FPS = new TextField();
			this.addChild(FPS);
			
			playerPos = new TextField();
			playerPos.width = 200;
			playerPos.y = FPS.y + 15;
			this.addChild(playerPos);
			
			this.addEventListener(Event.ENTER_FRAME, countFPS);
			this.addEventListener(Event.ENTER_FRAME, playerPosition);
		}
		
		/**Get & Display FPS*/
		public function countFPS(e:Event):void{
			var current:Number = (getTimer() - start)/1000;
			
			frameRate++;
			
			if(current > 1){
				//calculate
				FPS.text = "FPS: " + ( Math.floor( (frameRate/current)*10)/10 );
				
				//reset
				start = getTimer();
				frameRate = 0;
			}
		}
		
		/**Get & Display Player Position*/
		public function playerPosition(e:Event):void{
			playerPos.text = "Player X: " + Stage.player.GetPosition().x + "\n" +
							 "Player Y: " + Stage.player.GetPosition().y;
		}
	}
}