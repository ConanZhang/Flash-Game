package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	public class OptionsMenu extends MovieClip
	{
		//old stuff
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		
		//screen stuff
		private var screen:Sprite;
		private var buttonContainer: Sprite;
		
		//sprite container and buttons
		private var audio: MovieClip;
		private var controls: MovieClip;
		
		//options menu text object
		private var optionsMenu:OptionsMenu;
		
		//keybindings
		public static var keybindings:Object;
		
		public function OptionsMenu(screenP: Sprite, x:int, y:int)
		{
			screen = screenP;
			screen.addChild(this);
			buttons = new Array();
			buttonContainer = new Sprite();
			
			this.x = x;
			this.y = y;
			
			audio = new Audio;
			controls = new Controls;
			
			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.x = 0;
			buttonContainer.y = 0;
			
			buttonContainer.addChild(audio);
			audio.x = 150;
			audio.y = 400;
			
			buttonContainer.addChild(controls);
			controls.x = 150;
			controls.y = 100;
			
			buttons = [audio, controls];
			
			keybindings = {
				jump : Keyboard.W,
				left : Keyboard.A,
				fall : Keyboard.S,
				right: Keyboard.D,
				slow : Keyboard.SPACE,
				weaponLeft: Keyboard.Q,
				weaponRight: Keyboard.E,
				pistol : Keyboard.NUMBER_1,
				shotgun : Keyboard.NUMBER_2,
				machinegun : Keyboard.NUMBER_3,
				pause: Keyboard.P,
				fullscreen: Keyboard.F,
				quality: Keyboard.C
			};
			
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			keybindings.jump = e.keyCode;
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
			this.removeEventListener(Event.ENTER_FRAME, update);
			screen.removeChild(this);
		}
		
	}
}