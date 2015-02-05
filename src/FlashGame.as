/**
 * Main Class to Initiate World
 */
package
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.ui.Mouse;
	
	import FlashGame.FreefallWorld;
	import FlashGame.TestWorld;

	/**SWF Options*/
	[SWF(backgroundColor="#C4A57C", width="700", height="525", frameRate="30")]

	public class FlashGame extends Sprite
	{
		//embed font
		[Embed(source="/Zenzai_Itacha.ttf", fontName="Zenzai Itacha", embedAsCFF="false")]
		private var Zenzai_Itacha:Class;
		
		/**Class Member Variables*/
		private var test:TestWorld;  
		private var elevator:FreefallWorld;
		
		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			//hide cursor
			Mouse.hide();
			
			//create new test world
			//test = new TestWorld(this, true);
			elevator = new FreefallWorld(this, true);
		}
	}
}