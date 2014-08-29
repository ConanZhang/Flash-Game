/**
 * Background of stages.
 */
package FlashGame
{
	import flash.display.Sprite;
	
	import Assets.BackgroundObject;

	public class Background extends Sprite
	{
		private var background:String;
		
		/**Constructor*/
		public function Background(_background:String)
		{
			background = _background;
			if(background == "test"){
				test();
			}
		}
		
		/**Test background*/
		public function test():void{
			var testMountain:BackgroundObject = new BackgroundObject(130, -7, 10, 10, "mountain");
		}
	}
}