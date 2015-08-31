package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Parents.Stage;
	
	public class PauseMenu extends MovieClip
	{
		//old stuff
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		public var lastButtonClicked:MovieClip;
		//screen stuff
		private var screen:Stage;
		private var buttonContainer: Sprite;
		//sprite container and buttons
		private var backButton:Sprite;
		private var newOptionsContainer:Sprite;
		private var optionsContainer: Sprite;
		private var restart: Sprite;
		private var resume: Sprite;
		private var optionsPause: Sprite;
		private var exit: Sprite;	
		//options menu text object
		private var optionsMenu:OptionsMenu;
		
		public function PauseMenu(screenP: Stage, x:int, y:int)
		{
			screen = screenP;
			screen.addChild(this);
			buttons = new Array();
			buttonContainer = new Sprite();
			lastButtonClicked = null;
			this.x = x;
			this.y = y;
			
			
			optionsContainer = new Options_Container;
			resume = new Resume;
			restart = new Restart;
			optionsPause = new Options_Pause;
			exit = new Exit;
			
			this.addChild(optionsContainer);
			optionsContainer.x = 0;
			optionsContainer.y = 0;
			
			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.x = 0;
			buttonContainer.y = 0;
			
			buttonContainer.addChild(restart);
			restart.x = 80;
			restart.y = -80;
			
			buttonContainer.addChild(resume);
			resume.x = -80;
			resume.y = -80;
			
			buttonContainer.addChild(optionsPause);
			optionsPause.x = -80;
			optionsPause.y = 80;
			
			buttonContainer.addChild(exit);
			exit.x = 80;
			exit.y = 80;
			
			buttons = [restart, resume, optionsPause, exit];
			
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.CLICK, buttonClicked);
			addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		protected function mouseOver(event:MouseEvent):void
		{
			if(activeBack == null){
				if(buttons.indexOf(event.target) != -1){
					activeButton = event.target as MovieClip;
					buttonContainer.setChildIndex(activeButton, numChildren - 1);
				}
			}
		}
		
		protected function mouseOut(event:MouseEvent):void
		{
			if(event.target == activeButton){
				activeButton = null;
			}
		}
		
		protected function buttonClicked(event:MouseEvent):void
		{
			if(activeButton == null)
				return;
			
			//keep track of last button clicked
			lastButtonClicked = activeButton;
			
			if(activeButton.toString() == "[object Resume]"){
				Stage.paused = false;
				//resume game
				destroy();
			}
			else if(activeButton.toString() == "[object Restart]"){
				//restart game
				//exit game
				Stage.paused = false;
				destroy();
				screen.destroy();
				screen.screen.restart();
			}
			else if(activeButton.toString() == "[object Options_Pause]"){
				
				//create a new blank background on top of everything to hold the options text?
				newOptionsContainer = new Options_Container;
				buttonContainer.addChild(newOptionsContainer);
				newOptionsContainer.x = optionsContainer.x;
				newOptionsContainer.y = optionsContainer.y;
				
				//put the options text on top of that?
				optionsMenu = new OptionsMenu(this, -325,-225);
				
				backButton = new Back;
				buttonContainer.addChild(backButton);
				
				backButton.x = 300;
				backButton.y = -200;
				
				buttons.push(backButton);
				
			}
			else if(activeButton.toString() == "[object Exit]"){
				//exit game
				Stage.paused = false;
				destroy();
				screen.destroy();
			}		
			else if(activeButton.toString() == "[object Back]"){
				//exit game
				buttonContainer.removeChild(newOptionsContainer);
				optionsMenu.destroy();
				buttonContainer.removeChild(backButton);
				buttons.pop();
			}		
		}
		
		protected function update(event:Event):void
		{
			//adjust size of button
			for each (var button:MovieClip in buttons) {
				if(button == activeButton){
					if(button.scaleX <= 1.5){
						button.scaleX +=0.1;
						button.scaleY +=0.1;
					}
				}else{
					if(button.scaleX >= 1){
						button.scaleX -=0.1;
						button.scaleY -=0.1;
					}
				}
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.CLICK, buttonClicked);
			this.removeEventListener(Event.ENTER_FRAME, update);
			screen.removeChild(this);
		}
		
	}
}