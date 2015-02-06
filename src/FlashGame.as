/**
 * Main Class to Initiate World
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.ui.Mouse;
	
	import FlashGame.Menu;
	import FlashGame.TestWorld;
	import FlashGame.WallJumpingWorld;
	
	/**SWF Options*/
	[SWF(backgroundColor="#C4A57C", width="700", height="525", frameRate="30")]

	public class FlashGame extends Sprite
	{
		//embed font
		[Embed(source="/Zenzai_Itacha.ttf", fontName="Zenzai Itacha", embedAsCFF="false")]
		private var Zenzai_Itacha:Class;
		
		/**Class Member Variables*/
		//Levels
		private var test:TestWorld;  
		private var walls:WallJumpingWorld;
		
		//Menu
		private var menu:Menu;
				
		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			//hide cursor
			Mouse.hide();
			
			menu = new Menu(this);
			this.addEventListener(Event.REMOVED, testingRemove);

			//create new test world
			//test = new TestWorld(this, true);
			//
		}
		
		protected function testingRemove(event:Event):void
		{
			if(event.target is Menu){
				
				walls = new WallJumpingWorld(this, false);
			}
			else if(event.target is WallJumpingWorld){
				
				menu = new Menu(this);
			} 
		}
	}
}