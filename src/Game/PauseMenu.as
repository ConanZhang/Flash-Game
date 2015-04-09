package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PauseMenu extends MovieClip
	{
		//old stuff
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		public var lastButtonClicked:MovieClip;
		//screen stuff
		private var screen:Sprite;
		private var buttonContainer: Sprite;
		//sprite container and buttons
		private var optionsContainer: Sprite;
		private var restart: Sprite;
		private var resume: Sprite;
		private var optionsPause: Sprite;
		private var exit: Sprite;	
		//options menu text object
		private var optionsMenu:OptionsMenu;
		
		public function PauseMenu(screenP: Sprite)
		{
			screen = screenP;
			screen.addChildAt(this, 0);
			buttons = new Array();
			buttonContainer = new Sprite();
			lastButtonClicked = null;
			
			optionsContainer = new Options_Container;
			resume = new Resume;
			restart = new Restart;
			optionsPause = new Options_Pause;
			exit = new Exit;
			
			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.x = 0;
			buttonContainer.y = 0;
			
			buttonContainer.addChild(optionsContainer);
			optionsContainer.x = 0;
			optionsContainer.y = 0;
			
			buttonContainer.addChild(restart);
			restart.x = 50;
			restart.y = 0;
			
			buttonContainer.addChild(resume);
			resume.x = 0;
			resume.y = 0;
			
			buttonContainer.addChild(optionsPause);
			optionsPause.x = 0;
			optionsPause.y = 50;
			
			buttonContainer.addChild(exit);
			exit.x = 50;
			exit.y = 50;
			
			buttons = [optionsContainer, restart, resume, optionsPause, exit];
			
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
				//resume game
			}
			else if(activeButton.toString() == "[object Restart]"){
				//restart game
			}
			else if(activeButton.toString() == "[object Options_Pause]"){
				
				//create a new blank background on top of everything to hold the options text?
				var newOptionsContainer = new Options_Container;
				buttonContainer.addChild(newOptionsContainer);
				newOptionsContainer.x = optionsContainer.x;
				newOptionsContainer.y = optionsContainer.y;
				
				//put the options text on top of that?
				optionsMenu = new OptionsMenu(this, 0);
				
				//put exit button on top so it is clickable and will close the pause menu?				
				buttonContainer.setChildIndex(exit, 0);				
				
			}
			else if(activeButton.toString() == "[object Exit]"){
				//exit game
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
		
	}
}