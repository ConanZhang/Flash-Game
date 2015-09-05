package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		
		private var displayField:TextField;
		private var displayFormat:TextFormat;
		
		private var pacifist:Boolean;
		private var world:int;
		private var difficulty:int;
		
		public const tutorialWorld:int = 0;
		public const testWorld:int = 1;
		public const wallWorld:int = 2;
		public const smallWorld:int = 3;
		public const dodgeWorld:int = 4;
		public const weaponWorld:int = 5;
		
		public const beginner:int = 0;
		public const apprentice:int = 1;
		public const master:int = 2;
		
		private var pacifistState:String;
		private var worldState:String;
		private var difficultyState:String;
		
		private var musicChannel:SoundChannel;
		private var effectsChannel:SoundChannel;
		
		private var settings:SharedObject
		public function PauseMenu(screenP: Stage, x:int, y:int, _pacifist:Boolean, _world:int, _difficulty:int, _musicChannel:SoundChannel, _effectsChannel:SoundChannel, _settings:SharedObject)
		{
			screen = screenP;
			screen.addChild(this);
			buttons = new Array();
			buttonContainer = new Sprite();
			lastButtonClicked = null;
			this.x = x;
			this.y = y;
			pacifist = _pacifist;
			world = _world;
			difficulty = _difficulty;
			
			settings = _settings;
			
			musicChannel = _musicChannel;
			effectsChannel = _effectsChannel;
			
			optionsContainer = new Options_Container;
			resume = new Resume;
			restart = new Restart;
			optionsPause = new Options_Pause;
			exit = new Exit;
			
			this.addChild(optionsContainer);
			optionsContainer.x = 0;
			optionsContainer.y = 0;
			
			optionsContainer.width = 1200;
			optionsContainer.height = 800;
			
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
			
			displayFormat = new TextFormat();
			displayFormat.size = 30;
			displayFormat.align = "left";
			displayFormat.font = "Zenzai Itacha";
			
			displayField = new TextField();
			displayField.name = "display";
			displayField.x = -225;
			displayField.y = 150;
			displayField.width = 600;
			displayField.multiline = true;
			displayField.embedFonts = true;
			displayField.defaultTextFormat = displayFormat;
			displayField.textColor = 0xff0000;
			displayField.selectable = false;
			
			if(pacifist){
				pacifistState = "Pacifist";
			}
			else{
				pacifistState = "Weapons";
			}
			
			if(difficulty == 0){
				difficultyState = "Beginner";
			}
			else if(difficulty == 1){
				difficultyState = "Apprentice";
			}
			else{
				difficultyState = "Master";
			}
			
			if(world == tutorialWorld){
				worldState = "Movement";
			}
			else if(world == dodgeWorld){
				worldState = "Enemies";
			}
			else if(world == weaponWorld){
				worldState = "Weapons";
			}
			else if(world == testWorld){
				worldState = "Earth";
			}
			else if(world == wallWorld){
				worldState = "Water";
			}
			else if(world == smallWorld){
				worldState = "Air";
			}
				
			displayField.text = "Arena i " + worldState + "   Difficulty i " + difficultyState + "  Mode i " + pacifistState;
			
			addChild(displayField);
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
				optionsMenu = new OptionsMenu(this, -360,-275, displayField, musicChannel, effectsChannel, settings, false, worldState, pacifistState, difficultyState);
				
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
				if(optionsMenu != null){
					//exit game
					buttonContainer.removeChild(newOptionsContainer);
					optionsMenu.destroy();
					optionsMenu = null;
					buttonContainer.removeChild(backButton);
					buttons.pop();
					displayField.text = "Arena i " + worldState + "   Difficulty i " + difficultyState + "  Mode i " + pacifistState;
				}
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
					
					if(activeButton.toString() == "[object Resume]"){
						displayField.text = "Return to your tofu";
					}
					else if(activeButton.toString() == "[object Restart]"){
						displayField.text = "Turn back time";
					}
					else if(activeButton.toString() == "[object Options_Pause]"){
						displayField.text = "Customize your tofu on the f ly";
					}
					else if(activeButton.toString() == "[object Exit]"){
						displayField.text = "Leave your tofu to die";
					}
					else if(activeButton.toString() == "[object Back]"){
						displayField.text = "Finish repairing your tofu";
					}
				}
				else{
					if(button.scaleX >= 1){
						button.scaleX -=0.1;
						button.scaleY -=0.1;
						displayField.text = "Arena i " + worldState + "   Difficulty i " + difficultyState + "  Mode i " + pacifistState;
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