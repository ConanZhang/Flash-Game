/**
 * Background of stages.
 */
package Game
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
			if(background == "Earth"){
				earth();
			}
			else if(background == "Air"){
				air();
			}
			else if(background == "Water"){
				water();
			}
			else if(background == "TutorialMovement"){
				tutorialMovement();
			}
			else if(background == "TutorialDodge"){
				tutorialDodge();
			}
			else if(background == "TutorialWeapons"){
				tutorialWeapons();
			}
		}
		
		private function tutorialWeapons():void
		{
			var tutorialR1:BackgroundObject = new BackgroundObject(32, 8, 4, 3, "tutorialP");
			var tutorialPistol:BackgroundObject = new BackgroundObject(41, 6, 5, 3, "tutorialPistol");
			var tutorialShotgun:BackgroundObject = new BackgroundObject(56.5, 6, 5, 3, "tutorialShotgun");
			var tutorialCycle:BackgroundObject = new BackgroundObject(68, 6, 8, 5, "tutorialCycle");
			var tutorialMachineGun:BackgroundObject = new BackgroundObject(81, 6, 6, 4, "tutorialMachineGun");
			var tutorialHeart:BackgroundObject = new BackgroundObject(96, 6, 5, 3, "tutorialHeart");
			var tutorialShoot:BackgroundObject = new BackgroundObject(111, 5, 7, 4, "tutorialShoot");
			var tutorialR2:BackgroundObject = new BackgroundObject(135, 5, 6, 7, "tutorialExit");
		}
		
		private function tutorialDodge():void
		{
			var tutorialR1:BackgroundObject = new BackgroundObject(43, 7, 6, 7, "tutorialExit");
			var tutorialSpace:BackgroundObject = new BackgroundObject(64, 9, 5, 3, "tutorialSpace");
			var tutorialBar:BackgroundObject = new BackgroundObject(54, 4, 6, 2, "tutorialBar");
			var tutorialHealth:BackgroundObject = new BackgroundObject(77, 5, 7, 4, "tutorialHealth");
			var tutorialR2:BackgroundObject = new BackgroundObject(88, 7, 6, 7, "tutorialExit");
		}
		
		private function tutorialMovement():void
		{
			var tutorialR1:BackgroundObject = new BackgroundObject(32, 7, 4, 3, "tutorialP");
			var tutorialAD:BackgroundObject = new BackgroundObject(32, 10, 3, 3, "tutorialAD");
			var tutorialW:BackgroundObject = new BackgroundObject(38, 9, 3, 3, "tutorialW");
			var tutorialLongJump:BackgroundObject = new BackgroundObject(50, 4, 5, 3, "tutorialLongJump");
			var tutorialHover:BackgroundObject = new BackgroundObject(73, 0, 6, 4, "tutorialHover");
			var tutorialDoubleJump:BackgroundObject = new BackgroundObject(87, -2, 6, 5, "tutorialDoubleJump");
			var tutorialDoubleJumpHover:BackgroundObject = new BackgroundObject(105, -12, 6, 5, "tutorialDoubleJumpHover");
			var tutorialWallJump:BackgroundObject = new BackgroundObject(129, -28, 7, 5, "tutorialWallJump");
			var tutorialNoJump:BackgroundObject = new BackgroundObject(148, -28, 6, 4, "tutorialNoJump");
			var tutorialSingleWallJump:BackgroundObject = new BackgroundObject(136, -54, 7, 4, "tutorialSingleWallJump");
			var tutorialWallHug:BackgroundObject = new BackgroundObject(137, -75, 7, 4, "tutorialWallHug");
			var tutorialFastFall:BackgroundObject = new BackgroundObject(148, -47, 8, 4, "tutorialFalling");
			var tutorialFalling:BackgroundObject = new BackgroundObject(156, -90, 4, 2, "tutorialFastFall");
			var tutorialR2:BackgroundObject = new BackgroundObject(164, 8, 6, 7, "tutorialExit");
		}
		
		public function earth():void{
		}
		
		public function water():void{
		}
		
		public function air():void{
		}
	}
}