package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class Menu extends MovieClip
	{
		//already there
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		public var lastButtonClicked:MovieClip;
		//added stuff
		private var buttonContainer: Sprite;
		private var containerGoalY: Number;
		private var scrollSpeed: Number;
		private var layer: int;
		private var backgroundTexture: Sprite;
		private var title: Sprite;
		//0 = beginner, 1 = apprentice, 2 = master
		private var difficultyInt:int;
		private var pacifistBoolean:Boolean;
		private var standardBoolean:Boolean;
		private var back:MovieClip;	
		private var play:MovieClip;
		private var difficulty:MovieClip;
		private var beginner:MovieClip;
		private var apprentice:MovieClip;
		private var master:MovieClip;
		private var mode:MovieClip;
		private var tutorial:MovieClip;
		private var weapons:MovieClip;
		private var pacifist:MovieClip;
		private var arena:MovieClip;
		private var standard:MovieClip;
		private var walls:MovieClip;
		private var options:MovieClip;
		private var audio:MovieClip;
		private var controls:MovieClip;
		private var credits:MovieClip;
		private var art:MovieClip;
		private var georbec:MovieClip;
		private var programming:MovieClip;
		private var conan:MovieClip;
		private var copyright:MovieClip;
		
		private var screen:Sprite;
		private var optionsMenu:OptionsMenu;
		
		public function Menu(screenP:Sprite)
		{			
			screen = screenP;
			screen.addChildAt(this, 0);
			buttons = new Array();
			buttonContainer = new Sprite();
			lastButtonClicked = null;
			containerGoalY = 0;
			scrollSpeed = 50;
			layer = 0;
			//texture
			backgroundTexture = new background_texture;
			this.addChild(backgroundTexture);
			backgroundTexture.x = 0;
			backgroundTexture.y = 2100;
			backgroundTexture.scaleX = 0.45;
			backgroundTexture.scaleY = 0.45;
			//title
			title = new Title;
			this.addChild(title);
			title.x = 375;
			title.y = 270;
			title.scaleX = 0.65;
			title.scaleY = 0.65;
			back = new Back;
			play = new Play;
			difficulty = new Difficulty;
			tutorial = new Tutorial;
			beginner = new Beginner;
			apprentice = new Apprentice;
			master = new Master;
			mode = new Mode;
			weapons = new Weapons;
			pacifist = new Pacifist;
			arena = new Arena;
			standard = new Standard;
			walls = new Walls;	
			options = new Options;
			audio = new Audio;
			controls = new Controls;	
			credits = new Credits;
			art = new Art;
			georbec = new Georbec;
			programming = new Programming;
			conan = new Conan;
			copyright = new Copyright;	
			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.y = containerGoalY;	
			/**
			 * Layer 0 / Main Menu / y = 0
			 * Layer 1 / Difficulty / y = 500
			 * Layer 2 / Modes / y = 1000
			 * Layer 3 / Stages / y = 1500
			 * Layer 4 / Options / y = 2000
			 * Layer 5 / Credits / y = 2500
			 */
			buttonContainer.addChild(back);
			back.x = 50;
			back.y = 50;
			buttonContainer.addChild(play);
			play.x = 150;
			play.y = 150;
			buttonContainer.addChild(difficulty);
			difficulty.x = 350;
			difficulty.y = 600;
			buttonContainer.addChild(beginner);
			beginner.x = 150;
			beginner.y = 850;
			buttonContainer.addChild(apprentice);
			apprentice.x = 325;
			apprentice.y = 900;
			buttonContainer.addChild(master);
			master.x = 525;
			master.y = 850;
			buttonContainer.addChild(tutorial);
			tutorial.x = 100;
			tutorial.y = 700;
			buttonContainer.addChild(mode);
			mode.x = 350;
			mode.y = 1075;
			buttonContainer.addChild(weapons);
			weapons.x = 150;
			weapons.y = 1275;
			buttonContainer.addChild(pacifist);
			pacifist.x = 450;
			pacifist.y = 1325;
			buttonContainer.addChild(arena);
			arena.x = 350;
			arena.y = 1585;
			buttonContainer.addChild(standard);
			standard.x = 175;
			standard.y = 1776;
			buttonContainer.addChild(walls);
			walls.x = 450;
			walls.y = 1800;
			buttonContainer.addChild(options);
			options.x = 325;
			options.y = 150;
			buttonContainer.addChild(audio);
			audio.x = 150;
			audio.y = 2175;
			buttonContainer.addChild(controls);
			controls.x = 150;
			controls.y = 2375;
			buttonContainer.addChild(credits);
			credits.x = 415;
			credits.y = 75;
			buttonContainer.addChild(art);
			art.x = 200;
			art.y = 2650;
			buttonContainer.addChild(georbec);
			georbec.x = 450;
			georbec.y = 2650;
			buttonContainer.addChild(programming);
			programming.x = 200;
			programming.y = 2800;
			buttonContainer.addChild(conan);
			conan.x = 500;
			conan.y = 2800;
			buttonContainer.addChild(copyright);
			copyright.x = 350;
			copyright.y = 2950;
			//fill array(s?)
			buttons = [back, play, difficulty, tutorial, beginner, apprentice, master, mode, weapons, pacifist, arena, standard, walls, options, audio, controls, credits, art, georbec, programming, conan, copyright];
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.CLICK, buttonClicked);
			addEventListener(Event.ENTER_FRAME, update);
			
			optionsMenu = new OptionsMenu(this, 0);
		}
		private function mouseOver(event:MouseEvent):void
		{
			if(activeBack == null){
				if(buttons.indexOf(event.target) != -1){
					activeButton = event.target as MovieClip;
					buttonContainer.setChildIndex(activeButton, numChildren - 1);
				}
			}
		}
		private function mouseOut(event:MouseEvent):void
		{
			if(event.target == activeButton){
				activeButton = null;
			}
		}
		private function buttonClicked(event:MouseEvent):void
		{
			if(activeButton == null)
				return;
			/**
			 * Layer 0 / Main Menu / y = 0
			 * Layer 1 / Difficulty / y = 500
			 * Layer 2 / Modes / y = 1000
			 * Layer 3 / Stages / y = 1500
			 * Layer 4 / Options / y = 2000
			 * Layer 5 / Credits / y = 2500
			 */
			//keep track of last button clicked
			lastButtonClicked = activeButton;
			//determine which button clicked, assign layer to a value
			if(activeButton.toString() == "[object Back]"){
				if(layer >= 1 && layer < 4)
					layer = layer-1;
				else if(layer == 4)
					layer = 0;
				else if(layer == 5)
					layer = 0;
			}
			if(activeButton.toString() == "[object Play]"){
				layer = 1;
			}
			else if(activeButton.toString() == "[object Tutorial]"){
				FlashGame.setDifficulty(0);
				FlashGame.setPacifist(false);
				FlashGame.setWorld(0);
				this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				this.removeEventListener(MouseEvent.CLICK, buttonClicked);
				this.removeEventListener(Event.ENTER_FRAME, update);
				screen.removeChild(this);
			}
			else if(activeButton.toString() == "[object Beginner]"){
				FlashGame.setDifficulty(0);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Apprentice]"){
				FlashGame.setDifficulty(1);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Master]"){
				FlashGame.setDifficulty(2);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Weapons]"){
				FlashGame.setPacifist(false);
				layer = 3;
			}
			else if(activeButton.toString() == "[object Pacifist]"){
				FlashGame.setPacifist(true);
				layer = 3;
			}
			else if(activeButton.toString() == "[object Standard]"){
				FlashGame.setWorld(2);
				destroy();
			}
			else if(activeButton.toString() == "[object Walls]"){
				FlashGame.setWorld(1);
				destroy();
			}
			else if(activeButton.toString() == "[object Options]"){
				layer = 4;
			}
			else if(activeButton.toString() == "[object Credits]"){
				layer = 5;
			}
			//determine where to move the container using layer
			switch(layer){
				case 0: //Main Menu
					containerGoalY = 0;
					break;
				case 1: //Difficulty
					containerGoalY = 500;
					break;
				case 2: //Mode
					containerGoalY = 1000;
					break;
				case 3: //Stages
					containerGoalY = 1500;
					break;
				case 4: //Options
					containerGoalY = 2000;
					break;
				case 5: //Credits
					containerGoalY = 2500;
					break;
			}
		}
		
		public function destroy():void{
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.CLICK, buttonClicked);
			this.removeEventListener(Event.ENTER_FRAME, update);
			screen.removeChild(this);
		}
		
		private function update(event:Event):void
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
			//animate screen change
			if(Math.abs(buttonContainer.y) < containerGoalY){
				buttonContainer.y -= scrollSpeed;
				backgroundTexture.y -= scrollSpeed;
				optionsMenu.y -= scrollSpeed;
				title.y -= scrollSpeed;
			}
			//clicking back button to go in the reverse direction
			if(lastButtonClicked != null && lastButtonClicked.toString() == "[object Back]")
			{
				//scroll in reverse until layer is met
				if(Math.abs(buttonContainer.y) > containerGoalY){
					buttonContainer.y += scrollSpeed;
					backgroundTexture.y += scrollSpeed;
					optionsMenu.y += scrollSpeed;
					title.y += scrollSpeed;

				}
			}
			//move back button with container
			back.y = Math.abs(buttonContainer.y) + 50;
		}
	}
}