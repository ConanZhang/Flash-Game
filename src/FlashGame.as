/**
 * Main Class to Initiate World
 */
package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.Font;
	import flash.ui.Mouse;
	
	import Game.Menu;
	import Game.OptionsMenu;
	import Game.TestWorld;
	import Game.TutorialWorld;
	import Game.WallJumpingWorld;
	
	/**SWF Options*/
	//default color #C4A57C
	[SWF(backgroundColor="#C4A57C", width="700", height="525", frameRate="30")]

	public class FlashGame extends Sprite
	{
		//embed font
		[Embed(source="/Zenzai_Itacha.ttf", fontName="Zenzai Itacha", embedAsCFF="false")]
		private var Zenzai_Itacha:Class;
		
		/**Class Member Variables*/
		//Reticule
		private var gameReticule:Sprite;
		
		//Levels
		private var test:TestWorld;  
		private var walls:WallJumpingWorld;
		private var tutorial:TutorialWorld;
		
		//Menu
		private var menu:Menu;
				
		//Difficulties
		public static var difficulty:int;
		public const beginner:int = 0;
		public const apprentice:int = 1;
		public const master:int = 2;
		
		//Mode
		public static var pacifist:Boolean;
		
		//World
		public static var world:int;
		
		public const tutorialWorld:int = 0;
		public const wallWorld:int = 1;
		public const testWorld:int = 2;

		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			this.addEventListener(Event.ENTER_FRAME, moveReticule);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, options);
			this.addEventListener(Event.REMOVED, testingRemove);

			menu = new Menu(this);
			
			//hide cursor
			Mouse.hide();
			
			//display reticule
			gameReticule = new reticule();
			gameReticule.width = 25;
			gameReticule.height = 25;
			
			world = 2;
			pacifist = false;
			
			this.addChild(gameReticule);
		}
		
		private function testingRemove(event:Event):void{
			if(event.target is Menu){
				if(world == testWorld){
					test = new TestWorld(this, false, pacifist, testWorld, difficulty);
				}
				else if(world == wallWorld){
					walls = new WallJumpingWorld(this, false, pacifist, wallWorld, difficulty);	
				}
				else if(world == tutorialWorld){
					tutorial = new TutorialWorld(this, true, pacifist, tutorialWorld);	
				}
			}
			else if(event.target is TutorialWorld || event.target is WallJumpingWorld || event.target is TestWorld){
				menu = new Menu(this);
			} 
		}

		private function moveReticule(event:Event):void{
			//reticule
			gameReticule.x = this.mouseX;
			gameReticule.y = this.mouseY;
		}
		
		private function options(e:KeyboardEvent):void{
			//full screen
			if(e.keyCode == OptionsMenu.keybindings.fullscreen){
				if(stage.displayState == StageDisplayState.NORMAL){
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				else{
					stage.displayState = StageDisplayState.NORMAL;				
				}
			}
				//quality
			else if(e.keyCode == OptionsMenu.keybindings.quality){
				if(stage.quality == "LOW" ){
					stage.quality = StageQuality.MEDIUM;
				}
				else if(stage.quality == "MEDIUM"){
					stage.quality = StageQuality.HIGH;
				}
				else if(stage.quality == "HIGH" ){
					stage.quality = StageQuality.LOW;
				}
			}
		}
		
		public function restart():void{
			menu.destroy();
		}
		
		public static function setPacifist(_pacifist:Boolean):void{
			pacifist = _pacifist;
		}
		
		public static function setWorld(_world:int):void{
			world = _world;
		}
		
		public static function setDifficulty(_difficulty:int):void
		{
			difficulty = _difficulty;			
		}
	}
}