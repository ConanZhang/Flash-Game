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
			var testMountain:BackgroundObject = new BackgroundObject(130, -7, 30, 30, "mountain");
			var testCloud1:BackgroundObject = new BackgroundObject(80, -50, 10, 10, "cloud1");
			var testCloud2:BackgroundObject = new BackgroundObject(100, -50, 10, 10, "cloud2");
			var testCloud3:BackgroundObject = new BackgroundObject(200, -50, 10, 10, "cloud3");
			var testCloud4:BackgroundObject = new BackgroundObject(150, -55, 10, 10, "cloud4");
			var testCloud5:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud5");
			var testBird1:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "bird1");
			var testBird2:BackgroundObject = new BackgroundObject(130, -80, 5, 5, "bird2");
			var testBird3:BackgroundObject = new BackgroundObject(60, -780, 5, 5, "bird3");

		}
	}
}