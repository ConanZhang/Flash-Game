/**
 * Background of stages.
 */
package Game
{
	import flash.display.MovieClip;
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
			else if(background == "TutorialMovement"){
				tutorialMovement();
			}
		}
		
		private function tutorialMovement():void
		{
			var tutorialAD:BackgroundObject = new BackgroundObject(32, 9, 3, 3, "tutorialAD");
		}
		
		/**Test background*/
		public function test():void{
			/*
			var testMountain:BackgroundObject = new BackgroundObject(130, -7, 30, 30, "mountain");
			var testCloud1:BackgroundObject = new BackgroundObject(80, -50, 10, 10, "cloud1");
			var testCloud2:BackgroundObject = new BackgroundObject(100, -50, 10, 10, "cloud2");
			var testCloud3:BackgroundObject = new BackgroundObject(200, -50, 10, 10, "cloud3");
			var testCloud4:BackgroundObject = new BackgroundObject(150, -55, 10, 10, "cloud4");
			var testCloud5:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud5");
			var testCloud6:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud6");
			var testCloud7:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud7");
			var testCloud8:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud8");
			var testCloud9:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud9");
			var testCloud10:BackgroundObject = new BackgroundObject(160, -70, 10, 10, "cloud10");

			var testGrass1:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "grass1");
			var testGrass2:BackgroundObject = new BackgroundObject(130, -80, 5, 5, "grass2");
			var testGrass3:BackgroundObject = new BackgroundObject(60, -780, 5, 5, "grass3");
			
			var testTree1:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "tree1");
			var testTree2:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "tree2");
			var testTree3:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "tree3");
			var testTree4:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "tree4");
			var testTree5:BackgroundObject = new BackgroundObject(100, -80, 5, 5, "tree5");
			*/

		}
	}
}