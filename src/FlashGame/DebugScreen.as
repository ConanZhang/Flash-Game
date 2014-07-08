package FlashGame
{
	import Parents.Stage;
	import Assets.Player;
	import Assets.Weapon;
	
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
		//debug display
		public var debug:TextField;
		
		
		private var screen:Sprite;
		
		/**Constructor*/
		public function DebugScreen(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
			
			//initialize class member variables
			start = getTimer();//MILLISECONDS
			FPS = new TextField();
			FPS.textColor = 0xff0000;
			FPS.selectable = false;
			this.addChild(FPS);
			
			debug = new TextField();
			debug.width = 250;
			debug.height = stage.stageHeight;
			debug.y = FPS.y + 30;
			debug.textColor = 0xff0000;
			debug.selectable = false;
			this.addChild(debug);
			
			this.addEventListener(Event.ENTER_FRAME, countFPS);
			this.addEventListener(Event.ENTER_FRAME, debugGet);
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
		public function debugGet(e:Event):void{
			debug.text = 		"Player X: " + Stage.player.GetPosition().x + "\n" +
							  	"Player Y: " + Stage.player.GetPosition().y + "\n" + "\n" +
							   	"Player Animation State: " + Player.STATE 	+ "\n" + "\n" +
								"Player X Velocity: " + Stage.horizontalSpeed + "\n" + 
								"Player Y Velocity: " + Stage.verticalSpeed + "\n" + "\n" +
								"Player Jumps Remaining: " + Stage.jumpAmount + "\n" +
								"Jumping/Airbourne: " + Stage.isJumping + "\n" + 
								"Jump Time: " + Stage.jumpTime + "\n" + "\n" +
								"Right Wall: " + Stage.rightContact + "\n" +
								"Left Wall: " + Stage.leftContact + "\n" + "\n" +
								"Slow Motion: " + Stage.usingSlowMotion + "\n" +
								"Slow Meter: " + Stage.slowMotionAmount + "\n" + "\n" +
								"Player Health: " + Player.playerHealth + "\n" + 
								"Invulnerable Time: " + Player.playerInvulnerable + "\n" +
								"Stun Time: " + Stage.flinchTime+ "\n" + "\n" +
								"Collidable Body Count: " + (Stage.world.GetBodyCount()-5);
		}
	}
}