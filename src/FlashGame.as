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
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.text.Font;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import Assets.Player;
	import Assets.Weapon;
	
	import Game.DodgeWorld;
	import Game.Menu;
	import Game.MovementWorld;
	import Game.PlayerHUD;
	import Game.SmallWorld;
	import Game.EarthWorld;
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
		private var earth:EarthWorld; 
		private var walls:WallJumpingWorld;
		private var small:SmallWorld;
		private var tutorial:MovementWorld;
		private var dodge:DodgeWorld;
		private var weapon:WeaponWorld;
		
		//Menu
		private var menu:Menu;
				
		//Difficulties
		public var difficulty:int;
		public const beginner:int = 0;
		public const apprentice:int = 1;
		public const master:int = 2;
		
		//Mode
		public var pacifist:Boolean;
		
		//World
		public var world:int;
		
		public const tutorialWorld:int = 0;
		public const earthWorld:int = 1;
		public const wallWorld:int = 2;
		public const smallWorld:int = 3;
		public const dodgeWorld:int = 4;
		public const weaponWorld:int = 5;

		
		//settings
		private var settings:SharedObject;
		private var bindings:SharedObject;
		private var hasRain:Boolean;
		private var musicChannel:SoundChannel;

		private var gameHUD:PlayerHUD;
		private var keybindings:Object;
		private var player:Player;
		private var weaponEquip:Weapon;
		
		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			this.addEventListener(Event.ENTER_FRAME, updateGame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, options);
			this.addEventListener(Event.REMOVED, removedMenu);

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
						
			bindings = SharedObject.getLocal("Bindings");
			
			if(bindings.data.bindings != null){
				keybindings = bindings.data.bindings;
			}
			else{
				keybindings = {
					jump : Keyboard.W,
						left : Keyboard.A,
						fall : Keyboard.S,
						right: Keyboard.D,
						slow : Keyboard.SPACE,
						weaponLeft: Keyboard.Q,
						weaponRight: Keyboard.E,
						pistol : Keyboard.NUMBER_1,
						shotgun : Keyboard.NUMBER_2,
						machinegun : Keyboard.NUMBER_3,
						pause: Keyboard.P,
						fullscreen: Keyboard.F,
						quality: Keyboard.C,
						rain: Keyboard.Z,
						night: Keyboard.X
				};
				
				bindings.data.bindings = keybindings;
				
				bindings.flush();
			}
			
			player = new Player(3.5, settings);
			weaponEquip = new Weapon(1, player);
			
			musicChannel = new SoundChannel();
			menu = new Menu(this, musicChannel, settings, keybindings);
		}
		
		private function removedMenu(event:Event):void{
			if(settings.data.hasRain == "true"){
				hasRain = true;
			}
			else{
				hasRain = false;
			}
			
			if(event.target is Menu){		
				menu = null;
				if(world == earthWorld){
					gameHUD = new PlayerHUD(pacifist, earthWorld,difficulty, player, weaponEquip);
					earth = new EarthWorld(this, false, pacifist, earthWorld, difficulty, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);
				} 
				else if(world == wallWorld){
					gameHUD = new PlayerHUD(pacifist, wallWorld,difficulty, player, weaponEquip);
					walls = new WallJumpingWorld(this, false, pacifist, wallWorld,difficulty, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);	
				}
				else if(world == tutorialWorld){
					gameHUD = new PlayerHUD(pacifist, tutorialWorld,difficulty, player, weaponEquip);
					tutorial = new MovementWorld(this, false, pacifist, tutorialWorld, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);	
				}
				else if(world == smallWorld){
					gameHUD = new PlayerHUD(pacifist, smallWorld,difficulty, player, weaponEquip);
					small = new SmallWorld(this, false, pacifist, smallWorld, difficulty, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);	 
				}
				else if(world == dodgeWorld){
					gameHUD = new PlayerHUD(pacifist, dodgeWorld,difficulty, player, weaponEquip);
					dodge = new DodgeWorld(this, false, pacifist, dodgeWorld, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);	
				}
				else{
					gameHUD = new PlayerHUD(pacifist, weaponWorld,difficulty, player, weaponEquip);
					weapon = new WeaponWorld(this, false, pacifist, weaponWorld, hasRain, settings, musicChannel, gameHUD, keybindings, player, weaponEquip);	
				}
			}
			else if(event.target is MovementWorld || 
				event.target is WallJumpingWorld || 
				event.target is EarthWorld || 
				event.target is SmallWorld|| 
				event.target is DodgeWorld|| 
				event.target is WeaponWorld){
				
				earth = null;
				walls = null;
				tutorial = null;
				small = null;
				dodge = null;
				weapon = null;
				
				menu = new Menu(this, musicChannel, settings, keybindings);
			} 
		}

		private function updateGame(event:Event):void{
			//reticule
			gameReticule.x = this.mouseX;
			gameReticule.y = this.mouseY;
			
			if(world == earthWorld && earth != null){
				earth.update();
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
			if(e.keyCode == keybindings.fullscreen){
				if(stage.displayState == StageDisplayState.NORMAL){
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				else{
					stage.displayState = StageDisplayState.NORMAL;				
				}
			}
				//quality
			else if(e.keyCode == keybindings.quality){
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
		
		public function setPacifist(_pacifist:Boolean):void{
			pacifist = _pacifist;
		}
		
		public function setWorld(_world:int):void{
			world = _world;
		}
		
		public function setDifficulty(_difficulty:int):void
		{
			difficulty = _difficulty;			
		}
	}
}