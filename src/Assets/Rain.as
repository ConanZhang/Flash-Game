/**
 * Class to make rain.
 */
package Assets
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Game.PlayerHUD;
		
	public class Rain extends MovieClip
	{
		private var stage:Sprite;
		
		private var areaOffset:int;//gets corners of area
		private var dropNumber:int;
		private var dropVector:Vector.<MovieClip>;
		
		private var fallSpeed:int;

		private var windSpeed:int;
		private var slowWind:int;
		private var HUD:PlayerHUD;
		
		/**Constructor*/
		public function Rain(_stage:Sprite, _areaOffset:int, areaHeight:int, areaWidth:int, _dropNumber:int, _fallSpeed:int, _windSpeed:int, direction:String, _HUD:PlayerHUD)
		{
			//class member variables to parameters
			stage = _stage;
			areaOffset = _areaOffset;
			dropNumber = _dropNumber;
			dropVector = new Vector.<MovieClip>();
			fallSpeed = _fallSpeed;
			HUD = _HUD;
			
			windSpeed = _windSpeed;
			slowWind = windSpeed*0.3;
			
			if(direction == "right"){
				areaOffset *= -1;
			}
			
			//create drops
			for(var i:int = 0; i<dropNumber;i++){
				
				//initiate drop vairiables
				var drop:MovieClip = new raindrop();
				drop.areaHeight = areaHeight;
				drop.areaWidth = areaWidth;
				drop.fallSpeed =fallSpeed*(Math.random()+0.7);
				drop.slowFall = drop.fallSpeed*0.1;
				drop.direction = direction;
				//position
				drop.x = Math.random()*areaWidth;
				drop.y = Math.random()*areaHeight;
				
				//size
				drop.scaleX = Math.round( ( (Math.random()*0.7) +0.3)*10 )/10;
				drop.scaleY = drop.scaleX;
				
				dropVector.push(drop);
				this.addChild(drop);
				
			}
			assignDirection();
			
			stage.addChild(this);
		}
		
		/**Movement*/
		private function assignDirection():void{
			for(var i:int = 0; i <dropNumber; i++){
				switch(dropVector[i].direction){
					case "left":
						dropVector[i].addEventListener(Event.ENTER_FRAME, moveLeft);
						break;
					case "right":
						dropVector[i].scaleX*=-1;
						dropVector[i].addEventListener(Event.ENTER_FRAME, moveRight);
						break;
				}
			}
			
		}
		
		public function destroy():void{
			for(var i:int = 0; i <dropNumber; i++){
				switch(dropVector[i].direction){
					case "left":
						dropVector[i].removeEventListener(Event.ENTER_FRAME, moveLeft);
						break;
					case "right":
						dropVector[i].removeEventListener(Event.ENTER_FRAME, moveRight);
						break;
				}
			}
			stage.removeChild(this);
		}
		
		private function moveLeft(e:Event):void{
			//slow motion or default movement
			if(HUD.slowMotion && HUD.slowAmount > 0){
				e.target.x -= slowWind;
				e.target.y += e.target.slowFall;
			}
			else{
				e.target.x -= windSpeed;
				e.target.y += e.target.fallSpeed;
			}
			
			//reset position if necessary
			if(e.target.y > e.target.areaWidth+e.target.height){
				e.target.x = Math.random()*(e.target.areaHeight + (areaOffset*2) ) - areaOffset;
				e.target.y= -e.target.height;
			}
		}
		
		private function moveRight(e:Event):void{
			//slow motion or default movement
			if(HUD.slowMotion && HUD.slowAmount > 0){
				e.target.x += slowWind;
				e.target.y += e.target.slowFall;
			}
			else{
				e.target.x += windSpeed;
				e.target.y += e.target.fallSpeed;
			}
			
			//reset position if necessary
			if(e.target.y > e.target.areaWidth+e.target.height){
				e.target.x = Math.random()*(e.target.areaHeight - areaOffset*2) + (areaOffset*2);
				e.target.y =- e.target.height;
			}
		}
	}
}