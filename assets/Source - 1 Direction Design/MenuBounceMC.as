package{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MenuBounceMC extends MovieClip{
		public var activeSquare:MovieClip;
		public var activeBack:MovieClip;
		public var squaresArray:Array = new Array();
		public var backsArray:Array = new Array();
		public var speed:Number = 20;
		
		public function MenuBounceMC(){
			squaresArray = [square0, square1, square2, square3];
			backsArray = [back0, back1, back2, back3];
			addEventListener(MouseEvent.MOUSE_OVER, bounceOver);
			addEventListener(MouseEvent.MOUSE_OUT, bounceOut);
			addEventListener(MouseEvent.CLICK, bounceClick);
			addEventListener(Event.ENTER_FRAME, bounceUpdate);
		}
		public function bounceOver(event:MouseEvent):void {
			if(activeBack == null){ 
				if(squaresArray.indexOf(event.target) != -1){
					activeSquare = event.target as MovieClip;
					activeSquare.gotoAndStop(2);
					setChildIndex(activeSquare, numChildren - 1);
				}
			}
		}
		public function bounceOut(event:MouseEvent):void {
			if(event.target == activeSquare){
				activeSquare.gotoAndStop(1);
				activeSquare = null;
			}
		}
		public function bounceClick(event:MouseEvent):void {
			if(activeBack == null){
				if(squaresArray.indexOf(event.target) != -1){
					activeBack = backsArray[squaresArray.indexOf(event.target)] as MovieClip;
					setChildIndex(activeBack, numChildren - 1);
				}
			}else{
				activeBack = null;
			}
		}
		public function bounceUpdate(event:Event):void {
			for each (var square in squaresArray) {
				if(square == activeSquare){
					if(square.scaleX <= 1.5){
						square.scaleX +=0.05;
						square.scaleY +=0.05;
					}
				}else{
					if(square.scaleX >= 1){
						square.scaleX -=0.05;
						square.scaleY -=0.05;
					}
				}
		 	}
			/*************   DESIGN WITH BACKS MOVING FROM 1 DIRECTION   **************/
			for each (var back in backsArray){
				if(back == activeBack){
					if(back.y > 0){
						back.y -= speed;
					}
				}else{
					if(back.y < 300){
						back.y += speed;
					}
				}
		 	}
		}
	}
}