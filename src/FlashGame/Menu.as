package FlashGame
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *   get back button to move with screen somehow
	 * 
	 *   get screen scrolling
	 * 
	 * 
	*/
	
	
	public class Menu extends MovieClip
	{
		//already there
		public var activeButton:MovieClip;
		public var activeBack:MovieClip; //????????????
		public var buttons:Array;
		public var backsArray:Array = new Array(); //?????????????
		public var speed:Number;
		
		//added stuff
		private var buttonContainer: Sprite;
		private var containerY: Number;
		
		private var back:MovieClip;
		private var backX:Number;
		private var backY:Number;
		
		private var play:MovieClip;
		private var difficulty:MovieClip;
		private var beginner:MovieClip;
		private var apprentice:MovieClip;
		private var master:MovieClip;
		private var mode:MovieClip;
		private var tutorial:MovieClip;
		private var normal:MovieClip;
		private var endless:MovieClip;
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
		
		public function Menu(screenP:Sprite)
		{
			screen = screenP;
			screen.addChildAt(this, 0);
			
			//initialization
			speed = 20;
			buttons = new Array();
			buttonContainer = new Sprite();
			containerY = 0;
			
			back = new Back;
			backX = 50;
			backY = 50;
			
			play = new Play;
			difficulty = new Difficulty;
			beginner = new Beginner;
			apprentice = new Apprentice;
			master = new Master;
			mode = new Mode;
			tutorial = new Tutorial;
			normal = new Normal;
			endless = new Endless;
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
			buttonContainer.y = containerY;					
			
			//add buttons to container sprite, with positions
			buttonContainer.addChild(back);
			back.x = backX;
			back.y = backY;
			
			buttonContainer.addChild(play);
			play.x = 150;
			play.y = 150;
			
			buttonContainer.addChild(difficulty);
			difficulty.x = 350;
			difficulty.y = 600;
			
			buttonContainer.addChild(beginner);
			beginner.x = 100;
			beginner.y = 700;
			
			buttonContainer.addChild(apprentice);
			apprentice.x = 325;
			apprentice.y = 750;
			
			buttonContainer.addChild(master);
			master.x = 525;
			master.y = 700;
			
			buttonContainer.addChild(mode);
			mode.x = 350;
			mode.y = 1200;
			
			buttonContainer.addChild(tutorial);
			tutorial.x = 150;
			tutorial.y = 1400;
			
			buttonContainer.addChild(normal);
			normal.x = 250;
			normal.y = 1500;
			
			buttonContainer.addChild(endless);
			endless.x = 450;
			endless.y = 1450;
			
			buttonContainer.addChild(pacifist);
			pacifist.x = 600;
			pacifist.y = 1400;
			
			buttonContainer.addChild(arena);
			arena.x = 350;
			arena.y = 1900;
			
			buttonContainer.addChild(standard);
			standard.x = 175;
			standard.y = 2150;
			
			buttonContainer.addChild(walls);
			walls.x = 500;
			walls.y = 2050;
			//=======================options=========================			
			buttonContainer.addChild(options);
			options.x = 325;
			options.y = 150;
			
			buttonContainer.addChild(audio);
			audio.x = 250;
			audio.y = 2400;
			
			buttonContainer.addChild(controls);
			controls.x = 250;
			controls.y = 2600;
			//======================credits==========================
			buttonContainer.addChild(credits);
			credits.x = 415;
			credits.y = 75;
			
			buttonContainer.addChild(art);
			art.x = 200;
			art.y = 3050;
			
			buttonContainer.addChild(georbec);
			georbec.x = 450;
			georbec.y = 3050;
			
			buttonContainer.addChild(programming);
			programming.x = 200;
			programming.y = 3250;
			
			buttonContainer.addChild(conan);
			conan.x = 500;
			conan.y = 3250;
			
			buttonContainer.addChild(copyright);
			copyright.x = 350;
			copyright.y = 3350;
			
			
			//fill array(s?)
			buttons = [back, play, difficulty, beginner, apprentice, master, mode, tutorial, normal, endless, pacifist, arena, standard, walls, options, audio, controls, credits, art, georbec, programming, conan, copyright];
			
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.CLICK, buttonClicked);
			addEventListener(Event.ENTER_FRAME, update);			
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
			
			if(activeButton.toString() == "[object Play]"){
				trace("play button was clicked");
				screen.removeChild(this);
			}
			
			if(activeButton.toString() == "[object Options]"){
				trace("options button was clicked");
				
				containerY = 300;

			}
			
			if(activeButton.toString() == "[object Credits]"){
				trace("credits button was clicked");
			}


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
			if(Math.abs(buttonContainer.y) < containerY){
				buttonContainer.y -= 5;
			}
			
			
			
			//clicking back button to go in the reverse direction
//			if(buttonContainer.y > containerY)
//				buttonContainer.y += 5;			
			
		}
		
		
		
	}
}