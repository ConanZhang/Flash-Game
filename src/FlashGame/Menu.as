package FlashGame
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		private var play:MovieClip;
		private var options:MovieClip;
		private var credits:MovieClip;
		
		private var screen:Sprite;
		
		public function Menu(screenP:Sprite)
		{
			screen = screenP;
			screen.addChildAt(this, 0);
			
			//initialization
			speed = 20;
			buttonContainer = new Sprite();
			buttons = new Array();
			play = new Play;
			options = new Options;
			credits = new Credits;
			
			//add container sprite to stage
			this.addChild(buttonContainer);
			
			//add buttons to container sprite, with positions
			buttonContainer.addChild(play);
			play.x = 150;
			play.y = 150;
			
			buttonContainer.addChild(options);
			options.x = 325;
			options.y = 150;
			
			buttonContainer.addChild(credits);
			credits.x = 415;
			credits.y = 75;
			
			//fill array(s?)
			buttons = [play, options, credits];
			
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
			
			
			//move screen by a little bit here?		
			
			
		}
		
		
		
	}
}