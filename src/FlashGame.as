/**
 * Main Class to Initiate World
 */
package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.text.Font;
	import flash.ui.Mouse;
	
	import Game.DodgeWorld;
	import Game.Menu;
	import Game.MovementWorld;
	import Game.OptionsMenu;
	import Game.PlayerHUD;
	import Game.SmallWorld;
	import Game.TestWorld;
	import Game.WallJumpingWorld;
	import Game.WeaponWorld;
	
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
		private var small:SmallWorld;
		private var tutorial:MovementWorld;
		private var dodge:DodgeWorld;
		private var weapon:WeaponWorld;
		
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
		public const testWorld:int = 1;
		public const wallWorld:int = 2;
		public const smallWorld:int = 3;
		public const dodgeWorld:int = 4;
		public const weaponWorld:int = 5;

		
		//settings
		private var settings:SharedObject;
		private var hasRain:Boolean;
		private var musicChannel:SoundChannel;

		private var gameHUD:PlayerHUD;
		
		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			this.addEventListener(Event.ENTER_FRAME, moveReticule);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, options);
			this.addEventListener(Event.REMOVED, testingRemove);

			//hide cursor
			Mouse.hide();
			
			//display reticule
			gameReticule = new reticule();
			gameReticule.width = 25;
			gameReticule.height = 25;
			
			world = 1;
			pacifist = false;
			difficulty = beginner;
			
			this.addChild(gameReticule);
			
			settings = SharedObject.getLocal("Settings");
			
			
			if(settings.data.quality != null){
				if(settings.data.quality == "medium"){
					stage.quality = StageQuality.MEDIUM;
				}
				else if(settings.data.quality == "low"){
					stage.quality = StageQuality.LOW;
				}
				else{
					stage.quality = StageQuality.HIGH;
				}
			}
			else{
				settings.data.quality = "medium";
				stage.quality = StageQuality.MEDIUM;
			}
			
			if(settings.data.hasRain != null){
				if(settings.data.hasRain == "true"){
					hasRain = true;
				}
				else{
					hasRain = false;
				}
			}
			else{
				hasRain = false;
			}
			
			if(settings.data.musicVolume == null &&
				settings.data.effectsVolume == null){
				
				settings.data.musicVolume = 0.75;
				settings.data.effectsVolume = 0.5;
			}
			
			settings.flush();
						
			musicChannel = new SoundChannel();
			
			menu = new Menu(this, musicChannel, settings);
		}
		
		private function testingRemove(event:Event):void{
			if(settings.data.hasRain == "true"){
				hasRain = true;
			}
			else{
				hasRain = false;
			}
			
			if(event.target is Menu){		
				menu = null;
				if(world == testWorld){
					gameHUD = new PlayerHUD(pacifist, testWorld,difficulty);
					test = new TestWorld(this, false, pacifist, testWorld, difficulty, hasRain, settings, musicChannel, gameHUD);
				} 
				else if(world == wallWorld){
					gameHUD = new PlayerHUD(pacifist, wallWorld,difficulty);
					walls = new WallJumpingWorld(this, false, pacifist, wallWorld,difficulty, hasRain, settings, musicChannel, gameHUD);	
				}
				else if(world == tutorialWorld){
					gameHUD = new PlayerHUD(pacifist, tutorialWorld,difficulty);
					tutorial = new MovementWorld(this, false, pacifist, tutorialWorld, hasRain, settings, musicChannel, gameHUD);	
				}
				else if(world == smallWorld){
					gameHUD = new PlayerHUD(pacifist, smallWorld,difficulty);
					small = new SmallWorld(this, false, pacifist, smallWorld, difficulty, hasRain, settings, musicChannel, gameHUD);	 
				}
				else if(world == dodgeWorld){
					gameHUD = new PlayerHUD(pacifist, dodgeWorld,difficulty);
					dodge = new DodgeWorld(this, false, pacifist, dodgeWorld, hasRain, settings, musicChannel, gameHUD);	
				}
				else{
					gameHUD = new PlayerHUD(pacifist, weaponWorld,difficulty);
					weapon = new WeaponWorld(this, false, pacifist, weaponWorld, hasRain, settings, musicChannel, gameHUD);	
				}
			}
			else if(event.target is MovementWorld || 
				event.target is WallJumpingWorld || 
				event.target is TestWorld || 
				event.target is SmallWorld|| 
				event.target is DodgeWorld|| 
				event.target is WeaponWorld){
				
				test = null;
				walls = null;
				tutorial = null;
				small = null;
				dodge = null;
				weapon = null;
				
				menu = new Menu(this, musicChannel, settings);
			} 
		}

		private function moveReticule(event:Event):void{
			//reticule
			gameReticule.x = this.mouseX;
			gameReticule.y = this.mouseY;
			
			if(world == testWorld && test != null){
				test.update();
			} 
			else if(world == wallWorld && walls != null){
				walls.update();
			}
			else if(world == tutorialWorld && tutorial != null){
				tutorial.update();
			}
			else if(world == smallWorld && small != null){
				small.update();
			}
			else if(world == dodgeWorld && dodge != null){
				dodge.update();
			}
			else if(world == weaponWorld && weapon != null){
				weapon.update();
			}
			else if(menu != null){
				menu.update();
			}
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
					settings.data.quality = "medium";
				}
				else if(stage.quality == "MEDIUM"){
					stage.quality = StageQuality.HIGH;
					settings.data.quality = "high";
				}
				else if(stage.quality == "HIGH" ){
					stage.quality = StageQuality.LOW;					
					settings.data.quality = "low";
				}
				
				settings.flush();
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