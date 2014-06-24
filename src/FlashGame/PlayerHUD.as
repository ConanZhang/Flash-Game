/**
 * HUD for screen.
 */ 
package FlashGame
{
	import Assets.Player;
	import Assets.Weapon;
	
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class PlayerHUD extends Sprite
	{		
		private var screen:Sprite;
		
		//health
		private var heart1:MovieClip;
		private var heart2:MovieClip;
		private var heart3:MovieClip;
		private var heart4:MovieClip;
		private var heart5:MovieClip;
		private var heart6:MovieClip;
		
		private var heartXPosition:int;
		private var heartYPosition:int;
		private var heartSize:int;
		//slow motion bar
		private var slowMotionBar:Shape;
		private var slowBarClip:MovieClip;
		
		//fade
		private var fadeClip:MovieClip;
		
		//ammo
		private var ammoCount:TextField;
		private var ammoFormat:TextFormat;
		
		//reticule
		private var playerReticule:Sprite;
		
		//survive timer
		private var timerText:TextField;
		private var timerFormat:TextFormat;
		
		private var minuteDisplay:int;
		private var secondDisplay:Number;
		
		private var surviveTimer:Timer;
		
		//item collected
		public static var heartRevive:Boolean;
		public static var heartDamaged:Boolean;
		
		/**Constructor*/
		public function PlayerHUD(screenP:Sprite)
		{
			//initialize class member variables
			heartRevive = false;
			heartDamaged = false;
			
			heartXPosition = 460;
			heartYPosition = 70;
			heartSize = 35;
			
			screen = screenP;
			screen.addChild(this);
			
			fadeClip = new slowscreen();
			
			fadeClip.alpha = 0;
			
			fadeClip.width = 300;
			fadeClip.height = 300;
			
			fadeClip.x = 350;
			fadeClip.y = 262.5;
			
			this.addChild(fadeClip);
			
			//health
			heart1 = new heart();
			heart2 = new heart();
			heart3 = new heart();
			heart4 = new heart();
			heart5 = new heart();
			heart6 = new heart();
			
			heart1.height = heartSize;
			heart1.width = heartSize;
			heart2.height = heartSize;
			heart2.width = heartSize;
			heart3.height = heartSize;
			heart3.width = heartSize;
			heart4.height = heartSize;
			heart4.width = heartSize;
			heart5.height = heartSize;
			heart5.width = heartSize;
			heart6.height = heartSize;
			heart6.width = heartSize;
			
			heart1.x = heartXPosition;
			heart1.y = heartYPosition;
			heart2.x = heartXPosition + 40;
			heart2.y = heartYPosition;
			heart3.x = heartXPosition + 80;
			heart3.y = heartYPosition;
			heart4.x = heartXPosition + 120;
			heart4.y = heartYPosition;
			heart5.x = heartXPosition + 160;
			heart5.y = heartYPosition;
			heart6.x = heartXPosition + 200;
			heart6.y = heartYPosition;
			
			this.addChild(heart1);
			this.addChild(heart2);
			this.addChild(heart3);
			this.addChild(heart4);
			this.addChild(heart5);
			this.addChild(heart6);
			
			heart1.gotoAndStop("empty");
			heart2.gotoAndStop("empty");
			heart3.gotoAndStop("empty");
			heart4.gotoAndStop("idle");
			heart5.gotoAndStop("idle");
			heart6.gotoAndStop("idle");
			
			//reticule
			playerReticule = new reticule();
			playerReticule.width = 25;
			playerReticule.height = 25;
			
			this.addChild(playerReticule);
			
			//slow motion bar
			slowMotionBar = new Shape();
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
			
			this.addChild(slowMotionBar);
			
			slowBarClip = new slowbar();
			slowBarClip.width = 230;
			slowBarClip.height = 25;
			
			slowBarClip.x = 563;
			slowBarClip.y = 34;
			
			this.addChild(slowBarClip);
			
			ammoFormat = new TextFormat();
			ammoFormat.size = 30;
			ammoFormat.align = "right";
			ammoFormat.font = "Zenzai Itacha";
			
			//ammunition
			ammoCount = new TextField();
			ammoCount.embedFonts = true;
			ammoCount.defaultTextFormat = ammoFormat;
			ammoCount.height = 500;
			ammoCount.width = 150;
			ammoCount.x = 525;
			ammoCount.y = 350;
			ammoCount.textColor = 0xff0000;
			ammoCount.selectable = false;			
			this.addChild(ammoCount);
			
			//timer
			minuteDisplay = 0;
			secondDisplay = 0;
			
			timerFormat = new TextFormat();
			timerFormat.size = 30;
			timerFormat.align = "center";
			timerFormat.font = "Zenzai Itacha";
			
			timerText = new TextField();
			timerText.embedFonts = true;
			timerText.defaultTextFormat = timerFormat;
			timerText.text = "0 i 00";
			timerText.x = 250;
			timerText.y = 50;
			timerText.width = 275;
			timerText.textColor = 0xff0000;
			timerText.selectable = false;
			this.addChild(timerText);
			
			surviveTimer = new Timer(1000);
			surviveTimer.addEventListener(TimerEvent.TIMER, surviveCountDown);
			surviveTimer.start();
		}
		
		/**Called in stage update*/
		public function updateHUD():void{
			//VISUAL fade effect
			if(fadeClip.alpha < 0.3 && Stage.usingSlowMotion && Stage.slowMotionAmount > 0){
				fadeClip.alpha+=0.02;
			}
			else if(fadeClip.alpha > 0 && !Stage.usingSlowMotion || Stage.slowMotionAmount <= 0 && fadeClip.alpha > 0){
				fadeClip.alpha-=0.02;
			}
			
			//health
			if(heartRevive){
				if(Player.playerHealth == 2){
					heart5.gotoAndStop("revive");
				}
				else if(Player.playerHealth == 3){
					heart4.gotoAndStop("revive");
				}
				else if(Player.playerHealth == 4){
					heart3.gotoAndStop("revive");
				}
				else if(Player.playerHealth == 5){
					heart2.gotoAndStop("revive");
				}
				else if(Player.playerHealth == 6){
					heart1.gotoAndStop("revive");
				}
				heartRevive = false
			}
			else if(heartDamaged){
				if(Player.playerHealth == 5){
					heart1.gotoAndStop("dying");
				}
				else if(Player.playerHealth == 4){
					heart2.gotoAndStop("dying");
				}
				else if(Player.playerHealth == 3){
					heart3.gotoAndStop("dying");
				}
				else if(Player.playerHealth == 2){
					heart4.gotoAndStop("dying");
				}
				else if(Player.playerHealth == 1){
					heart5.gotoAndStop("dying");
				}
				else if(Player.playerHealth == 0){
					heart6.gotoAndStop("dying");
				}
				heartDamaged = false;
			}
			
			//reticule
			playerReticule.x = this.mouseX;
			playerReticule.y = this.mouseY;
			
			//slow motion bar
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
			
			//ammo
			ammoCount.text = "Weapon i " + Weapon.weaponType + "\n" +
							 "Ammo i " + Weapon.weaponAmmo;					
		}
		
		/**Count down timer*/
		private function surviveCountDown(e:TimerEvent):void{
			if(!Stage.paused){
				//slow down real time
				if(Stage.usingSlowMotion && Stage.slowMotionAmount > 0){
					surviveTimer.delay = 1500;
				}
				else{
					surviveTimer.delay = 1000;
				}
				
				//plus seconds
				if(secondDisplay < 59){
					secondDisplay++;
				}
				//minus minutes
				else{
					minuteDisplay++;
					secondDisplay = 0;
				}
			}
			
			//display new text
			timerText.text = minuteDisplay+" i "+(secondDisplay >= 10 ? secondDisplay:"0" + secondDisplay);
		}
	}
			
}
