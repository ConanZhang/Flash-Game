/**
 * Parent class for all stages
 */
package FlashGame
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class Stage extends MovieClip
	{
		/**Class Member Variables**/
		
		/**Constructor*/
		public function Stage()
		{
		}
		
		/**Stages can update their properties*/
		public function update(e:Event):void{
			
		}
		
		/**Stages always center the screen on the player*/
		private function centerScreen(xPos:Number, yPos:Number):void{
			
		}
		
		/**Stages can detect key presses*/
		public function keyPressed(e:KeyboardEvent):void{
			
		}
		
		/**Stage can detect key releases*/
		public function keyReleased(e:KeyboardEvent):void{
			
		}
	}
}