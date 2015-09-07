package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	public class OptionsMenu extends MovieClip
	{
		//old stuff
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		
		//screen stuff
		private var screen:Sprite;
		private var buttonContainer: Sprite;
		
		//sprite container and buttons
		private var audio: MovieClip;
		private var controls: MovieClip;
		
		//options menu text object
		private var optionsMenu:OptionsMenu;
		
		private var onMenu:Boolean;
		
		//keybindings
		public var keybindings:Object;
		private var bindings:SharedObject;
		private var currentKey:int;
		
		private const jump:int = 1;
		private const left:int = 2;
		private const fall:int = 3;
		private const right:int = 4;
		private const slow:int = 5;
		private const weaponLeft:int = 6;
		private const weaponRight:int = 7;
		private const pistol:int = 8;
		private const shotgun:int = 9;
		private const machinegun:int = 10;
		private const pause:int = 11;
		private const fullscreen:int = 12;
		private const quality:int = 13;
		private const rain:int = 14;
		private const night:int = 15;
		
		//Text format
		private var textFormat:TextFormat;
		
		//Keys
		private var jumpField:TextField;
		private var leftField:TextField;
		private var fallField:TextField;
		private var rightField:TextField;
		private var slowField:TextField;
		private var weaponLeftField:TextField;
		private var weaponRightField:TextField;
		private var pistolField:TextField;
		private var shotgunField:TextField;
		private var machinegunField:TextField;
		private var pauseField:TextField;
		private var fullscreenField:TextField;
		private var qualityField:TextField;
		private var rainField:TextField;
		private var nightField:TextField;
		
		private var keyCodeStrings:Dictionary;
		
		private var displayField:TextField;
		private var worldState:String;
		private var pacifistState:String;
		private var difficultyState:String;
		
		// Music
		private var musicKnob:MovieClip;
		private var musicSlide:MovieClip;
		
		private var effectsKnob:MovieClip;
		private var effectsSlide:MovieClip;
		
		private var dragging:Boolean;
		private var sliderLength:Number;
		private var musicBox:Rectangle;
		private var musicChannel:SoundChannel;
		private var effectsBox:Rectangle;
		private var musicField:TextField;
		private var effectsField:TextField;
		
		private var settings:SharedObject;

		public function OptionsMenu(screenP: Sprite, x:int, y:int, display:TextField, _musicChannel:SoundChannel, _settings:SharedObject, _onMenu:Boolean, _worldState:String, _pacifistState:String, _difficultyState:String, _activeButton:MovieClip, _keybindings:Object)
		{
			screen = screenP;
			screen.addChild(this);
			buttons = new Array();
			buttonContainer = new Sprite();
			musicChannel = _musicChannel;
			activeButton = _activeButton;
			
			settings = _settings;
						
			this.x = x;
			this.y = y;
						
			displayField = display;
			worldState = _worldState;
			pacifistState = _pacifistState;
			difficultyState = _difficultyState;
			
			settings = SharedObject.getLocal("Settings");
			
			currentKey = 0;
			
			audio = new Audio;
			controls = new Controls;
			musicSlide = new volume_line;
			musicKnob = new volume_slider;
			effectsSlide = new volume_line;
			effectsKnob = new volume_slider;
			onMenu = _onMenu;
			
			sliderLength = 270;
			
			keyCodeStrings = keyCodeToString();			

			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.x = 0;
			buttonContainer.y = 0;
			
			buttonContainer.addChild(audio);
			audio.x = 150;
			audio.y = 400;
			
			buttonContainer.addChild(controls);
			controls.x = 150;
			controls.y = 100;
			
			buttonContainer.addChild(musicSlide);
			musicSlide.x = 475;
			musicSlide.y = 355;
			
			buttonContainer.addChild(musicKnob);
			musicKnob.x = (settings.data.musicVolume*sliderLength)+380;
			musicKnob.y = 355;
			
			buttonContainer.addChild(effectsSlide);
			effectsSlide.x = 475;
			effectsSlide.y = 405;
			
			buttonContainer.addChild(effectsKnob);
			effectsKnob.x = (settings.data.effectsVolume*sliderLength)+380;
			effectsKnob.y = 405;
			
			buttons = [audio, controls];
			
			bindings = SharedObject.getLocal("Bindings");
			keybindings = _keybindings;
			
			textFormat = new TextFormat();
			textFormat.size = 25;
			textFormat.align = "center";
			textFormat.font = "Zenzai Itacha";
			
			jumpField = new TextField();
			jumpField.name = "jump";
			jumpField.x = 250;
			jumpField.y = 50;
			jumpField.width = 200;
			jumpField.embedFonts = true;
			jumpField.defaultTextFormat = textFormat;
			jumpField.textColor = 0xff0000;
			jumpField.selectable = false;
			jumpField.type= TextFieldType.INPUT;
			jumpField.text = "Jump and Hover i " + keyCodeStrings[keybindings.jump];
			
			leftField = new TextField();
			leftField.name = "left";
			leftField.x = 170;
			leftField.y = 110;
			leftField.width = 200;
			leftField.embedFonts = true;
			leftField.defaultTextFormat = textFormat;
			leftField.textColor = 0xff0000;
			leftField.selectable = false;
			leftField.type= TextFieldType.INPUT;
			leftField.text = "Left i " + keyCodeStrings[keybindings.left];

			fallField = new TextField();
			fallField.name = "fall";
			fallField.x = 440;
			fallField.y = 50;
			fallField.width = 200;
			fallField.embedFonts = true;
			fallField.defaultTextFormat = textFormat;
			fallField.textColor = 0xff0000;
			fallField.selectable = false;
			fallField.type= TextFieldType.INPUT;
			fallField.text = "Fast Fall i " + keyCodeStrings[keybindings.fall];
			
			rightField = new TextField();
			rightField.name = "right";
			rightField.x = 280;
			rightField.y = 110;
			rightField.width = 200;
			rightField.embedFonts = true;
			rightField.defaultTextFormat = textFormat;
			rightField.textColor = 0xff0000;
			rightField.selectable = false;
			rightField.type= TextFieldType.INPUT;
			rightField.text = "Right i " + keyCodeStrings[keybindings.right];
			
			slowField = new TextField();
			slowField.name = "slow";
			slowField.x = 30;
			slowField.y = 170;
			slowField.width = 250;
			slowField.embedFonts = true;
			slowField.defaultTextFormat = textFormat;
			slowField.textColor = 0xff0000;
			slowField.selectable = false;
			slowField.type= TextFieldType.INPUT;
			slowField.text = "Invincibility i " + keyCodeStrings[keybindings.slow];
			
			weaponLeftField = new TextField();
			weaponLeftField.name = "weaponLeft";
			weaponLeftField.x = 460;
			weaponLeftField.y = 110;
			weaponLeftField.width = 200;
			weaponLeftField.embedFonts = true;
			weaponLeftField.defaultTextFormat = textFormat;
			weaponLeftField.textColor = 0xff0000;
			weaponLeftField.selectable = false;
			weaponLeftField.type= TextFieldType.INPUT;
			weaponLeftField.text = "Next Weapon Left i " + keyCodeStrings[keybindings.weaponLeft];
			
			weaponRightField = new TextField();
			weaponRightField.name = "weaponRight";
			weaponRightField.x = 290;
			weaponRightField.y = 170;
			weaponRightField.width = 200;
			weaponRightField.embedFonts = true;
			weaponRightField.defaultTextFormat = textFormat;
			weaponRightField.textColor = 0xff0000;
			weaponRightField.selectable = false;
			weaponRightField.type= TextFieldType.INPUT;
			weaponRightField.text = "Next Weapon Right i " + keyCodeStrings[keybindings.weaponRight];
			
			pistolField = new TextField();
			pistolField.name = "pistol";
			pistolField.x = 30;
			pistolField.y = 230;
			pistolField.width = 200;
			pistolField.embedFonts = true;
			pistolField.defaultTextFormat = textFormat;
			pistolField.textColor = 0xff0000;
			pistolField.selectable = false;
			pistolField.type= TextFieldType.INPUT;
			pistolField.text = "Pistol i " + keyCodeStrings[keybindings.pistol];
			
			shotgunField = new TextField();
			shotgunField.name = "shotgun";
			shotgunField.x = 240;
			shotgunField.y = 230;
			shotgunField.width = 200;
			shotgunField.embedFonts = true;
			shotgunField.defaultTextFormat = textFormat;
			shotgunField.textColor = 0xff0000;
			shotgunField.selectable = false;
			shotgunField.type= TextFieldType.INPUT;
			shotgunField.text = "Shotgun i " + keyCodeStrings[keybindings.shotgun];
			
			machinegunField = new TextField();
			machinegunField.name = "machinegun";
			machinegunField.x = 70;
			machinegunField.y = 280;
			machinegunField.width = 250;
			machinegunField.height = 50;
			machinegunField.embedFonts = true;
			machinegunField.defaultTextFormat = textFormat;
			machinegunField.textColor = 0xff0000;
			machinegunField.selectable = false;
			machinegunField.type= TextFieldType.INPUT;
			machinegunField.text = "Machine gun i " + keyCodeStrings[keybindings.machinegun];

			pauseField = new TextField();
			pauseField.name = "pause";
			pauseField.x = 460;
			pauseField.y = 170;
			pauseField.width = 200;
			pauseField.embedFonts = true;
			pauseField.defaultTextFormat = textFormat;
			pauseField.textColor = 0xff0000;
			pauseField.selectable = false;
			pauseField.type= TextFieldType.INPUT;
			pauseField.text = "Pause i " + keyCodeStrings[keybindings.pause];
			
			fullscreenField = new TextField();
			fullscreenField.name = "fullscreen";
			fullscreenField.x = 440;
			fullscreenField.y = 230;
			fullscreenField.width = 120;
			fullscreenField.embedFonts = true;
			fullscreenField.defaultTextFormat = textFormat;
			fullscreenField.textColor = 0xff0000;
			fullscreenField.selectable = false;
			fullscreenField.type= TextFieldType.INPUT;
			fullscreenField.text = "Fullscreen i " + keyCodeStrings[keybindings.fullscreen];
			
			qualityField = new TextField();
			qualityField.name = "quality";
			qualityField.x = 460;
			qualityField.y = 280;
			qualityField.width = 200;
			qualityField.height = 50;
			qualityField.embedFonts = true;
			qualityField.defaultTextFormat = textFormat;
			qualityField.textColor = 0xff0000;
			qualityField.selectable = false;
			qualityField.type= TextFieldType.INPUT;
			qualityField.text = "Quality i " + keyCodeStrings[keybindings.quality];
			
			rainField = new TextField();
			rainField.name = "rain";
			rainField.x = 310;
			rainField.y = 280;
			rainField.width = 200;
			rainField.height = 50;
			rainField.embedFonts = true;
			rainField.defaultTextFormat = textFormat;
			rainField.textColor = 0xff0000;
			rainField.selectable = false;
			rainField.type= TextFieldType.INPUT;
			rainField.text = "Rain i " + keyCodeStrings[keybindings.rain];
			
			nightField = new TextField();
			nightField.name = "night";
			nightField.x = 550;
			nightField.y = 230;
			nightField.width = 100;
			nightField.height = 50;
			nightField.embedFonts = true;
			nightField.defaultTextFormat = textFormat;
			nightField.textColor = 0xff0000;
			nightField.selectable = false;
			nightField.type= TextFieldType.INPUT;
			nightField.text = "Night i " + keyCodeStrings[keybindings.night];
			
			addChild(jumpField);
			addChild(fallField);
			addChild(leftField);
			addChild(rightField);
			addChild(slowField);
			addChild(weaponLeftField);
			addChild(weaponRightField);
			addChild(pistolField);
			addChild(shotgunField);
			addChild(machinegunField);
			addChild(pauseField);
			addChild(fullscreenField);
			addChild(qualityField);
			addChild(rainField);
			addChild(nightField);

			// Music
			musicField = new TextField();
			musicField.name = "music";
			musicField.x = 230;
			musicField.y = 330;
			musicField.width = 150;
			musicField.height = 50;
			musicField.embedFonts = true;
			musicField.defaultTextFormat = textFormat;
			musicField.textColor = 0xff0000;
			musicField.selectable = false;
			musicField.text = "Music i ";
			
			// Music
			effectsField = new TextField();
			effectsField.name = "effects";
			effectsField.x = 210;
			effectsField.y = 380;
			effectsField.width = 150;
			effectsField.height = 50;
			effectsField.embedFonts = true;
			effectsField.defaultTextFormat = textFormat;
			effectsField.textColor = 0xff0000;
			effectsField.selectable = false;
			effectsField.text = "Sound FX i ";

			addChild(musicField);
			addChild(effectsField);
			
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			jumpField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			jumpField.addEventListener(MouseEvent.CLICK, mouseClick);
			leftField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			leftField.addEventListener(MouseEvent.CLICK, mouseClick);
			fallField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			fallField.addEventListener(MouseEvent.CLICK, mouseClick);
			rightField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			rightField.addEventListener(MouseEvent.CLICK, mouseClick);
			slowField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			slowField.addEventListener(MouseEvent.CLICK, mouseClick);
			weaponLeftField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			weaponLeftField.addEventListener(MouseEvent.CLICK, mouseClick);
			weaponRightField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			weaponRightField.addEventListener(MouseEvent.CLICK, mouseClick);
			pistolField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			pistolField.addEventListener(MouseEvent.CLICK, mouseClick);
			shotgunField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			shotgunField.addEventListener(MouseEvent.CLICK, mouseClick);
			machinegunField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			machinegunField.addEventListener(MouseEvent.CLICK, mouseClick);
			pauseField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			pauseField.addEventListener(MouseEvent.CLICK, mouseClick);
			fullscreenField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			fullscreenField.addEventListener(MouseEvent.CLICK, mouseClick);
			qualityField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			qualityField.addEventListener(MouseEvent.CLICK, mouseClick);
			rainField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			rainField.addEventListener(MouseEvent.CLICK, mouseClick);
			nightField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			nightField.addEventListener(MouseEvent.CLICK, mouseClick);
			
			dragging = false;
			
			musicBox = new Rectangle(380, 355, sliderLength, 0);
			effectsBox = new Rectangle(380, 405, sliderLength, 0);

			musicKnob.addEventListener(MouseEvent.MOUSE_DOWN, dragMusicKnob);
			effectsKnob.addEventListener(MouseEvent.MOUSE_DOWN, dragEffectsKnob);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseKnob);
			addEventListener(MouseEvent.CLICK, buttonClicked);
		}
		
		protected function buttonClicked(event:MouseEvent):void
		{
			if(activeButton == null)
			{
				return;
			}
			else{
				var menuSelect:Sound = new MenuSelect;
				menuSelect.play(0,0, new SoundTransform(settings.data.effectsVolume));
			}
		}
		
		protected function dragEffectsKnob(event:MouseEvent):void
		{
			effectsKnob.startDrag(false, effectsBox);
			dragging = true;
			effectsKnob.addEventListener(Event.ENTER_FRAME, adjustEffectsVolume);
		}
		
		protected function adjustEffectsVolume(event:Event):void
		{
			var effectsVolume:Number = (effectsKnob.x - 380)/sliderLength; 
			settings.data.effectsVolume = effectsVolume;
			settings.flush();
		}
		
		protected function releaseKnob(event:MouseEvent):void
		{
			if (dragging) { 
				musicKnob.stopDrag(); 
				effectsKnob.stopDrag(); 
				dragging=false;
				musicKnob.removeEventListener(Event.ENTER_FRAME, adjustMusicVolume);
				effectsKnob.removeEventListener(Event.ENTER_FRAME, adjustEffectsVolume);
				var menuSelect:Sound = new MenuSelect;
				menuSelect.play(0,0, new SoundTransform(settings.data.effectsVolume));
			} 			
		}
		
		protected function dragMusicKnob(event:MouseEvent):void
		{
			musicKnob.startDrag(false, musicBox);
			dragging = true;
			musicKnob.addEventListener(Event.ENTER_FRAME, adjustMusicVolume);
		}
		
		protected function adjustMusicVolume(event:Event):void
		{			
			var _musicVolume:Number=(musicKnob.x - 380)/sliderLength; 
			var musicTransform:SoundTransform =new SoundTransform(_musicVolume); 
			musicChannel.soundTransform=musicTransform;   
			
			settings.data.musicVolume = _musicVolume;
			settings.flush();
		}
		
		protected function mouseClick(event:MouseEvent):void
		{

			if(currentKey != 0){
				if(currentKey == jump){
					currentKey = 0;
					jumpField.textColor = 0xff0000;
				}
				else if(currentKey == left){
					currentKey = 0;
					leftField.textColor = 0xff0000;
				}
				else if(currentKey == fall){
					currentKey = 0;
					fallField.textColor = 0xff0000;
				}
				else if(currentKey == right){
					currentKey = 0;
					rightField.textColor = 0xff0000;
				}
				else if(currentKey == slow){
					currentKey = 0;
					slowField.textColor = 0xff0000;
				}
				else if(currentKey == weaponLeft){
					currentKey = 0;
					weaponLeftField.textColor = 0xff0000;
				}
				else if(currentKey == weaponRight){
					currentKey = 0;
					weaponRightField.textColor = 0xff0000;
				}
				else if(currentKey == pistol){
					currentKey = 0;
					pistolField.textColor = 0xff0000;
				}
				else if(currentKey == shotgun){
					currentKey = 0;
					shotgunField.textColor = 0xff0000;
				}
				else if(currentKey == machinegun){
					currentKey = 0;
					machinegunField.textColor = 0xff0000;
				}
				else if(currentKey == pause){
					currentKey = 0;
					pauseField.textColor = 0xff0000;
				}
				else if(currentKey == fullscreen){
					currentKey = 0;
					fullscreenField.textColor = 0xff0000;
				}
				else if(currentKey == quality){
					currentKey = 0;
					qualityField.textColor = 0xff0000;
				}
				else if(currentKey == rain){
					currentKey = 0;
					rainField.textColor = 0xff0000;
				}
				else if(currentKey == night){
					currentKey = 0;
					rainField.textColor = 0xff0000;
				}
			}
			
			//Change font to indicate focus
			if(event.currentTarget.name == "jump"){
				currentKey = jump;
				jumpField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "left"){
				currentKey = left;
				leftField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "fall"){
				currentKey = fall;
				fallField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "right"){
				currentKey = right;
				rightField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "slow"){
				currentKey = slow;
				slowField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "weaponLeft"){
				currentKey = weaponLeft;
				weaponLeftField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "weaponRight"){
				currentKey = weaponRight;
				weaponRightField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "pistol"){
				currentKey = pistol;
				pistolField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "shotgun"){
				currentKey = shotgun;
				shotgunField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "machinegun"){
				currentKey = machinegun;
				machinegunField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "pause"){
				currentKey = pause;
				pauseField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "fullscreen"){
				currentKey = fullscreen;
				fullscreenField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "quality"){
				currentKey = quality;
				qualityField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "rain"){
				currentKey = rain;
				rainField.textColor = 0xffffff;
			}
			else if(event.currentTarget.name == "night"){
				currentKey = night;
				nightField.textColor = 0xffffff;
			}
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			if(currentKey == jump){
				keybindings.jump = e.keyCode;
				jumpField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == left){
				keybindings.left = e.keyCode;
				leftField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == fall){
				keybindings.fall = e.keyCode;
				fallField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == right){
				keybindings.right = e.keyCode;
				rightField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == slow){
				keybindings.slow = e.keyCode;
				slowField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == weaponLeft){
				keybindings.weaponLeft = e.keyCode;
				weaponLeftField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == weaponRight){
				keybindings.weaponRight = e.keyCode;
				weaponRightField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == pistol){
				keybindings.pistol = e.keyCode;
				pistolField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == shotgun){
				keybindings.shotgun = e.keyCode;
				shotgunField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == machinegun){
				keybindings.machinegun = e.keyCode;
				machinegunField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == pause){
				keybindings.pause = e.keyCode;
				pauseField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == fullscreen){
				keybindings.fullscreen = e.keyCode;
				fullscreenField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == quality){
				keybindings.quality = e.keyCode;
				qualityField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == rain){
				keybindings.rain = e.keyCode;
				rainField.textColor = 0xff0000;
				currentKey = 0;
			}
			else if(currentKey == night){
				keybindings.night = e.keyCode;
				nightField.textColor = 0xff0000;
				currentKey = 0;
			}
			
			
			bindings.data.bindings = keybindings;
			bindings.flush();
		} 
		
		protected function mouseOver(event:MouseEvent):void
		{
			if(buttons.indexOf(event.target) != -1){
				activeButton = event.target as MovieClip;
			}
		}
		protected function mouseOut(event:MouseEvent):void
		{
			if(event.target == activeButton){
				activeButton = null;
			}
		}
		
		public function update():void
		{
			//adjust size of button
			for each (var button:MovieClip in buttons) {
				if(button == activeButton){
					if(button.scaleX <= 1.5){
						button.scaleX +=0.1;
						button.scaleY +=0.1;
					}
					
					if(activeButton.toString() == "[object Controls]"){
						displayField.text = "C hange how you tofu";
					}
					else if(activeButton.toString() == "[object Audio]"){
						displayField.text = "Rave with your tofu";
					}
				}
				else{
					if(button.scaleX >= 1){
						button.scaleX -=0.1;
						button.scaleY -=0.1;
						
						if(onMenu){
							displayField.text = "";
						}
						else{
							displayField.text = "Arena i " + worldState + "   Difficulty i " + difficultyState + "  Mode i " + pacifistState;
						}
					}
				}
			}
			
			jumpField.text = "Jump and Hover i " + keyCodeStrings[keybindings.jump];
			leftField.text = "Left i " + keyCodeStrings[keybindings.left];
			fallField.text = "Fast Fall i " + keyCodeStrings[keybindings.fall];
			rightField.text = "Right i " + keyCodeStrings[keybindings.right];
			slowField.text = "Invincibility i " + keyCodeStrings[keybindings.slow];
			weaponLeftField.text = "Next Weapon Left i " + keyCodeStrings[keybindings.weaponLeft];
			weaponRightField.text = "Next Weapon Right i " + keyCodeStrings[keybindings.weaponRight];
			pistolField.text = "Pistol i " + keyCodeStrings[keybindings.pistol];
			shotgunField.text = "Shotgun i " + keyCodeStrings[keybindings.shotgun];
			machinegunField.text = "Machine gun i " + keyCodeStrings[keybindings.machinegun];
			pauseField.text = "Pause i " + keyCodeStrings[keybindings.pause];
			fullscreenField.text = "Fullscreen i " + keyCodeStrings[keybindings.fullscreen];
			qualityField.text = "Quality i " + keyCodeStrings[keybindings.quality];
			rainField.text = "Rain i " + keyCodeStrings[keybindings.rain];
			nightField.text = "Night i " + keyCodeStrings[keybindings.night];
		}
		
		public function destroy():void
		{
			activeButton = null;
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.removeEventListener(MouseEvent.CLICK, buttonClicked);

			musicKnob.removeEventListener(MouseEvent.MOUSE_DOWN, dragMusicKnob);
			effectsKnob.removeEventListener(MouseEvent.MOUSE_DOWN, dragEffectsKnob);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseKnob);
			
			jumpField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			jumpField.removeEventListener(MouseEvent.CLICK, mouseClick);
			leftField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			leftField.removeEventListener(MouseEvent.CLICK, mouseClick);
			fallField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			fallField.removeEventListener(MouseEvent.CLICK, mouseClick);
			rightField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			rightField.removeEventListener(MouseEvent.CLICK, mouseClick);
			slowField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			slowField.removeEventListener(MouseEvent.CLICK, mouseClick);
			weaponLeftField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			weaponLeftField.removeEventListener(MouseEvent.CLICK, mouseClick);
			weaponRightField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			weaponRightField.removeEventListener(MouseEvent.CLICK, mouseClick);
			pistolField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			pistolField.removeEventListener(MouseEvent.CLICK, mouseClick);
			shotgunField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			shotgunField.removeEventListener(MouseEvent.CLICK, mouseClick);
			machinegunField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			machinegunField.removeEventListener(MouseEvent.CLICK, mouseClick);
			pauseField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			pauseField.removeEventListener(MouseEvent.CLICK, mouseClick);
			fullscreenField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			fullscreenField.removeEventListener(MouseEvent.CLICK, mouseClick);
			qualityField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			qualityField.removeEventListener(MouseEvent.CLICK, mouseClick);
			rainField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			rainField.removeEventListener(MouseEvent.CLICK, mouseClick);
			nightField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			nightField.removeEventListener(MouseEvent.CLICK, mouseClick);
			
			screen.removeChild(this);
		}
		
		private function keyCodeToString():Dictionary {
			var keyCodeDescription:XML = describeType(Keyboard);
			var keyNames:XMLList = keyCodeDescription..constant.@name;
			
			var keyCodeDictionary:Dictionary = new Dictionary();
			
			var length:int = keyNames.length();
			for(var i:int = 0; i < length; i++) {
				keyCodeDictionary[Keyboard[keyNames[i]]] = keyNames[i];
			}
			
			return keyCodeDictionary;
		}
	}
}