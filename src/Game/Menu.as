package Game
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Menu extends MovieClip
	{
		//already there
		public var activeButton:MovieClip;
		public var activeBack:MovieClip;
		public var buttons:Array;
		public var lastButtonClicked:MovieClip;
		//added stuff
		private var buttonContainer: Sprite;
		private var containerGoalY: Number;
		private var scrollSpeed: Number;
		private var layer: int;
		private var backgroundTexture: Sprite;
		private var title: Sprite;
		//0 = beginner, 1 = apprentice, 2 = master
		private var difficultyInt:int;
		private var pacifistBoolean:Boolean;
		private var standardBoolean:Boolean;
		private var back:MovieClip;	
		private var play:MovieClip;
		private var highscore:MovieClip;
		private var difficulty:MovieClip;
		private var beginner:MovieClip;
		private var apprentice:MovieClip;
		private var master:MovieClip;
		private var mode:MovieClip;
		private var tutorial:MovieClip;
		private var tutorials:MovieClip;
		private var movementTutorial:MovieClip;
		private var dodgeTutorial:MovieClip;
		private var weaponTutorial:MovieClip;
		private var weapons:MovieClip;
		private var pacifist:MovieClip;
		private var arena:MovieClip;
		private var standard:MovieClip;
		private var walls:MovieClip;
		private var small:MovieClip;
		private var options:MovieClip;
		private var credits:MovieClip;
		private var art:MovieClip;
		private var georbec:MovieClip;
		private var programming:MovieClip;
		private var conan:MovieClip;
		private var copyright:MovieClip;
		private var testers:MovieClip;
		private var objective:MovieClip;
		
		private var displayField:TextField;
		private var displayFormat:TextFormat;
		
		private var highscoreFormat:TextFormat;
		private var pacifistLabel:TextField;
		private var weaponsLabel:TextField;
		private var beginnerLabel:TextField;
		private var apprenticeLabel:TextField;
		private var masterLabel:TextField;
		private var earthLabel1:TextField;
		private var waterLabel1:TextField;
		private var airLabel1:TextField;
		private var earthLabel2:TextField;
		private var waterLabel2:TextField;
		private var airLabel2:TextField;
		
		private var pacifistBeginnerStandard:String;
		private var pacifistBeginnerWall:String;
		private var pacifistBeginnerSmall:String;
		private var pacifistApprenticeStandard:String;
		private var pacifistApprenticeWall:String;
		private var pacifistApprenticeSmall:String;
		private var pacifistMasterStandard:String;
		private var pacifistMasterWall:String;
		private var pacifistMasterSmall:String;
		
		private var weaponsBeginnerStandard:String;
		private var weaponsBeginnerWall:String;
		private var weaponsBeginnerSmall:String;
		private var weaponsApprenticeStandard:String;
		private var weaponsApprenticeWall:String;
		private var weaponsApprenticeSmall:String;
		private var weaponsMasterStandard:String;
		private var weaponsMasterWall:String;
		private var weaponsMasterSmall:String;
		
		private var screen:FlashGame;
		private var optionsMenu:OptionsMenu;
		
		private var highScore:SharedObject;
		
		private var musicChannel:SoundChannel;

		private var musicVolume:Number;
		
		private var settings:SharedObject;
		
		private var menuMusic:Sound;
		private var keybindings:Object;
		
		public function Menu(screenP:FlashGame, _musicChannel:SoundChannel, _settings:SharedObject, _keybindings:Object)
		{			
			screen = screenP;
			screen.addChildAt(this, 0);
			buttons = new Array();
			buttonContainer = new Sprite();
			lastButtonClicked = null;
			containerGoalY = 0;
			scrollSpeed = 50;
			layer = 0;
			musicChannel = _musicChannel;
			
			settings = _settings;
			keybindings = _keybindings;
			musicVolume = settings.data.musicVolume;
			
			menuMusic = new MenuMusic;
			
			var musicTransform:SoundTransform = new SoundTransform(musicVolume);
			musicChannel = menuMusic.play(0, int.MAX_VALUE);
			musicChannel.soundTransform = musicTransform;
						
			displayFormat = new TextFormat();
			displayFormat.size = 50;
			displayFormat.align = "left";
			displayFormat.font = "Zenzai Itacha";
			
			displayField = new TextField();
			displayField.name = "display";
			displayField.x = 75;
			displayField.y = 400;
			displayField.width = 600;
			displayField.embedFonts = true;
			displayField.defaultTextFormat = displayFormat;
			displayField.textColor = 0xff0000;
			displayField.selectable = false;
			displayField.text = "";
			
			//texture
			backgroundTexture = new background_texture;
			this.addChild(backgroundTexture);
			backgroundTexture.x = 0;
			backgroundTexture.y = 2100;
			backgroundTexture.scaleX = 0.45;
			backgroundTexture.scaleY = 0.45;
			//title
			title = new Title;
			this.addChild(title);
			title.x = 400;
			title.y = 280;
			title.scaleX = 0.35;
			title.scaleY = 0.35;
			back = new Back;
			play = new Play;
			highscore = new High_Scores;
			difficulty = new Difficulty;
			tutorial = new Tutorial;
			tutorials = new Tutorials;
			dodgeTutorial = new Tutorial_Enemies;
			weaponTutorial = new Tutorial_Weapons;
			movementTutorial = new TutorialMovement;
			beginner = new Beginner;
			apprentice = new Apprentice;
			master = new Master;
			mode = new Mode;
			weapons = new Weapons;
			pacifist = new Pacifist;
			arena = new Arena;
			standard = new Earth;
			walls = new Water;	
			small = new Air;
			options = new Options;	
			credits = new Credits;
			art = new Art;
			georbec = new Georbec;
			programming = new Programming;
			conan = new Conan;
			copyright = new Copyright;	
			testers = new Testers;
			objective = new Objective;
			//add container sprite to stage, starting position
			this.addChild(buttonContainer);
			buttonContainer.y = containerGoalY;	
			/**
			 * Layer 0 / Main Menu / y = 0
			 * Layer 1 / Difficulty / y = 500
			 * Layer 2 / Modes / y = 1000
			 * Layer 3 / Stages / y = 1500
			 * Layer 4 / Options / y = 2000
			 * Layer 5 / Credits / y = 2500
			 * Layer 6 / Highscores / y = 3000
			 * Layer 7 / Tutorials / y = 3500
			 */
			buttonContainer.addChild(back);
			back.x = 50;
			back.y = 50;
			buttonContainer.addChild(play);
			play.x = 150;
			play.y = 150;
			buttonContainer.addChild(highscore);
			highscore.x = 150;
			highscore.y = 275	;
			buttonContainer.addChild(difficulty);
			difficulty.x = 350;
			difficulty.y = 600;
			buttonContainer.addChild(beginner);
			beginner.x = 150;
			beginner.y = 850;
			buttonContainer.addChild(apprentice);
			apprentice.x = 350;
			apprentice.y = 900;
			buttonContainer.addChild(master);
			master.x = 525;
			master.y = 850;
			buttonContainer.addChild(tutorial); 	
			tutorial.x = 350;
			tutorial.y = 750;
			buttonContainer.addChild(tutorials); 	
			tutorials.x = 350;
			tutorials.y = 3600;
			buttonContainer.addChild(objective);
			objective.x = 350;
			objective.y = 3750;
			buttonContainer.addChild(dodgeTutorial);
			dodgeTutorial.x = 350;
			dodgeTutorial.y = 3900;
			buttonContainer.addChild(weaponTutorial);
			weaponTutorial.x = 550;
			weaponTutorial.y = 3850;
			buttonContainer.addChild(movementTutorial);
			movementTutorial.x = 150;
			movementTutorial.y = 3850;
			buttonContainer.addChild(mode);
			mode.x = 350;
			mode.y = 1125;
			buttonContainer.addChild(weapons);
			weapons.x = 150;
			weapons.y = 1275;
			buttonContainer.addChild(pacifist);
			pacifist.x = 450;
			pacifist.y = 1325;
			buttonContainer.addChild(arena);
			arena.x = 350;
			arena.y = 1625;
			buttonContainer.addChild(standard);
			standard.x = 150;
			standard.y = 1776;
			buttonContainer.addChild(walls);
			walls.x = 350;
			walls.y = 1800;
			buttonContainer.addChild(small);
			small.x = 525;
			small.y = 1775;
			buttonContainer.addChild(options);
			options.x = 325;
			options.y = 150;
			buttonContainer.addChild(credits);
			credits.x = 415;
			credits.y = 75;
			buttonContainer.addChild(art);
			art.x = 225;
			art.y = 2600;
			buttonContainer.addChild(georbec);
			georbec.x = 450;
			georbec.y = 2600;
			buttonContainer.addChild(programming);
			programming.x = 250;
			programming.y = 2750;
			buttonContainer.addChild(conan);
			conan.x = 500;
			conan.y = 2750;
			buttonContainer.addChild(copyright);
			copyright.x = 600;
			copyright.y = 2825;
			buttonContainer.addChild(testers);
			testers.x = 300;
			testers.y = 2900;
			
			highScore = SharedObject.getLocal("HighScore");
			
			var scores:Array;
			
			if(highScore.data.pacifistBeginnerStandard != null &&
				highScore.data.pacifistBeginnerWall != null &&
				highScore.data.pacifistBeginnerSmall != null &&
				highScore.data.pacifistApprenticeStandard != null &&
				highScore.data.pacifistApprenticeWall != null &&
				highScore.data.pacifistApprenticeSmall != null &&
				highScore.data.pacifistMasterStandard != null &&
				highScore.data.pacifistMasterWall != null &&
				highScore.data.pacifistMasterSmall != null &&
				highScore.data.weaponsBeginnerTutorial != null &&
				highScore.data.weaponsBeginnerDodge != null &&
				highScore.data.weaponsBeginnerWeapon != null &&
				highScore.data.weaponsBeginnerStandard != null &&
				highScore.data.weaponsBeginnerWall != null &&
				highScore.data.weaponsBeginnerSmall != null &&
				highScore.data.weaponsApprenticeStandard != null &&
				highScore.data.weaponsApprenticeWall != null &&
				highScore.data.weaponsApprenticeSmall != null &&
				highScore.data.weaponsMasterStandard != null &&
				highScore.data.weaponsMasterWall != null &&
				highScore.data.weaponsMasterSmall != null){
				
				scores = highScore.data.pacifistBeginnerStandard;
				if(scores[1] < 10){
					pacifistBeginnerStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistBeginnerStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistBeginnerWall;
				if(scores[1] < 10){
					pacifistBeginnerWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistBeginnerWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistBeginnerSmall;
				if(scores[1] < 10){
					pacifistBeginnerSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistBeginnerSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistApprenticeStandard;
				if(scores[1] < 10){
					pacifistApprenticeStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistApprenticeStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistApprenticeWall;
				if(scores[1] < 10){
					pacifistApprenticeWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistApprenticeWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistApprenticeSmall;
				if(scores[1] < 10){
					pacifistApprenticeSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistApprenticeSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistMasterStandard;
				if(scores[1] < 10){
					pacifistMasterStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistMasterStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistMasterWall;
				if(scores[1] < 10){
					pacifistMasterWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistMasterWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.pacifistMasterSmall;
				if(scores[1] < 10){
					pacifistMasterSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					pacifistMasterSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsBeginnerStandard;
				if(scores[1] < 10){
					weaponsBeginnerStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsBeginnerStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsBeginnerWall;
				if(scores[1] < 10){
					weaponsBeginnerWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsBeginnerWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsBeginnerSmall;
				if(scores[1] < 10){
					weaponsBeginnerSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsBeginnerSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsApprenticeStandard;
				if(scores[1] < 10){
					weaponsApprenticeStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsApprenticeStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsApprenticeWall;
				if(scores[1] < 10){
					weaponsApprenticeWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsApprenticeWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsApprenticeSmall;
				if(scores[1] < 10){
					weaponsApprenticeSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsApprenticeSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsMasterStandard;
				if(scores[1] < 10){
					weaponsMasterStandard = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsMasterStandard = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsMasterWall;
				if(scores[1] < 10){
					weaponsMasterWall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsMasterWall = scores[0].toString() + " i " + scores[1].toString();	
				}
				
				scores = highScore.data.weaponsMasterSmall;
				if(scores[1] < 10){
					weaponsMasterSmall = scores[0].toString() + " i 0" + scores[1].toString();
				}
				else{
					weaponsMasterSmall = scores[0].toString() + " i " + scores[1].toString();	
				}
			}
			else{
				scores = [0,0];
				
				highScore.data.pacifistBeginnerStandard = scores;
				highScore.data.pacifistBeginnerWall = scores;
				highScore.data.pacifistBeginnerSmall = scores;
				highScore.data.pacifistApprenticeStandard = scores;
				highScore.data.pacifistApprenticeWall = scores;
				highScore.data.pacifistApprenticeSmall = scores;
				highScore.data.pacifistMasterStandard = scores;
				highScore.data.pacifistMasterWall = scores;
				highScore.data.pacifistMasterSmall = scores;
				highScore.data.weaponsBeginnerTutorial = scores;
				highScore.data.weaponsBeginnerDodge = scores;
				highScore.data.weaponsBeginnerWeapon = scores;
				highScore.data.weaponsBeginnerStandard = scores;
				highScore.data.weaponsBeginnerWall = scores;
				highScore.data.weaponsBeginnerSmall = scores;
				highScore.data.weaponsApprenticeStandard = scores;
				highScore.data.weaponsApprenticeWall = scores;
				highScore.data.weaponsApprenticeSmall = scores;
				highScore.data.weaponsMasterStandard = scores;
				highScore.data.weaponsMasterWall = scores;
				highScore.data.weaponsMasterSmall = scores;
			
				pacifistBeginnerStandard= "0 i 00";
				pacifistBeginnerWall= "0 i 00";
				pacifistBeginnerSmall= "0 i 00";
				pacifistApprenticeStandard= "0 i 00";
				pacifistApprenticeWall= "0 i 00";
				pacifistApprenticeSmall= "0 i 00";
				pacifistMasterStandard= "0 i 00";
				pacifistMasterWall= "0 i 00";
				pacifistMasterSmall= "0 i 00";
				
				weaponsBeginnerStandard= "0 i 00";
				weaponsBeginnerWall= "0 i 00";
				weaponsBeginnerSmall= "0 i 00";
				weaponsApprenticeStandard= "0 i 00";
				weaponsApprenticeWall= "0 i 00";
				weaponsApprenticeSmall= "0 i 00";
				weaponsMasterStandard= "0 i 00";
				weaponsMasterWall= "0 i 00";
				weaponsMasterSmall= "0 i 00";
				
				highScore.flush();
			}
			
			highscoreFormat = new TextFormat();
			highscoreFormat.size = 30;
			highscoreFormat.align = "left";
			highscoreFormat.font = "Zenzai Itacha";
			
			pacifistLabel = new TextField();
			pacifistLabel.name = "pacifistLabel";
			pacifistLabel.x = 330;
			pacifistLabel.y = 3280;
			pacifistLabel.embedFonts = true;
			pacifistLabel.defaultTextFormat = highscoreFormat;
			pacifistLabel.textColor = 0xff0000;
			pacifistLabel.selectable = false;
			pacifistLabel.text = "Pacifist";
			
			weaponsLabel = new TextField();
			weaponsLabel.name = "weaponsLabel";
			weaponsLabel.x = 330;
			weaponsLabel.y = 3075;
			weaponsLabel.embedFonts = true;
			weaponsLabel.defaultTextFormat = highscoreFormat;
			weaponsLabel.textColor = 0xff0000;
			weaponsLabel.selectable = false;
			weaponsLabel.text = "Weapons";
			
			beginnerLabel = new TextField();
			beginnerLabel.name = "beginnerLabel";
			beginnerLabel.x = 130;
			beginnerLabel.y = 3030;
			beginnerLabel.embedFonts = true;
			beginnerLabel.defaultTextFormat = highscoreFormat;
			beginnerLabel.textColor = 0xff0000;
			beginnerLabel.selectable = false;
			beginnerLabel.text = "Beginner";
			
			apprenticeLabel = new TextField();
			apprenticeLabel.name = "apprenticeLabel";
			apprenticeLabel.x = 330;
			apprenticeLabel.y = 3030;
			apprenticeLabel.embedFonts = true;
			apprenticeLabel.defaultTextFormat = highscoreFormat;
			apprenticeLabel.textColor = 0xff0000;
			apprenticeLabel.selectable = false;
			apprenticeLabel.text = "Apprentice";
			
			masterLabel = new TextField();
			masterLabel.name = "masterLabel";
			masterLabel.x = 530;
			masterLabel.y = 3030;
			masterLabel.embedFonts = true;
			masterLabel.defaultTextFormat = highscoreFormat;
			masterLabel.textColor = 0xff0000;
			masterLabel.selectable = false;
			masterLabel.text = "Master";
			
			earthLabel1 = new TextField();
			earthLabel1.name = "earthLabel1";
			earthLabel1.x = 60;
			earthLabel1.y = 3335;
			earthLabel1.width = 600;
			earthLabel1.embedFonts = true;
			earthLabel1.defaultTextFormat = highscoreFormat;
			earthLabel1.textColor = 0xff0000;
			earthLabel1.selectable = false;
			earthLabel1.text = "Earth" + "       " +pacifistBeginnerStandard + "                       " + pacifistApprenticeStandard + "                        " + pacifistMasterStandard;

			waterLabel1 = new TextField();
			waterLabel1.name = "waterLabel1";
			waterLabel1.x = 60;
			waterLabel1.y = 3385;
			waterLabel1.width = 600;
			waterLabel1.embedFonts = true;
			waterLabel1.defaultTextFormat = highscoreFormat;
			waterLabel1.textColor = 0xff0000;
			waterLabel1.selectable = false;
			waterLabel1.text = "Water" + "   " +pacifistBeginnerWall + "                       " + pacifistApprenticeWall + "                        " + pacifistMasterWall;

			airLabel1 = new TextField();
			airLabel1.name = "airLabel1";
			airLabel1.x = 60;
			airLabel1.y = 3435;
			airLabel1.width = 600;
			airLabel1.embedFonts = true;
			airLabel1.defaultTextFormat = highscoreFormat;
			airLabel1.textColor = 0xff0000;
			airLabel1.selectable = false;
			airLabel1.text = "Air" + "       " +pacifistBeginnerSmall + "                       " + pacifistApprenticeSmall + "                        " + pacifistMasterSmall;
			
			earthLabel2 = new TextField();
			earthLabel2.name = "earthLabel2";
			earthLabel2.x = 60;
			earthLabel2.y = 3130;
			earthLabel2.width = 600;
			earthLabel2.embedFonts = true;
			earthLabel2.defaultTextFormat = highscoreFormat;
			earthLabel2.textColor = 0xff0000;
			earthLabel2.selectable = false;
			earthLabel2.text = "Earth" + "       " +weaponsBeginnerStandard + "                       " + weaponsApprenticeStandard + "                        " + weaponsMasterStandard;
			
			waterLabel2 = new TextField();
			waterLabel2.name = "waterLabel2";
			waterLabel2.x = 60;
			waterLabel2.y = 3180;
			waterLabel2.width = 600;
			waterLabel2.embedFonts = true;
			waterLabel2.defaultTextFormat = highscoreFormat;
			waterLabel2.textColor = 0xff0000;
			waterLabel2.selectable = false;
			waterLabel2.text = "Water" + "   " +weaponsBeginnerWall + "                       " + weaponsApprenticeWall + "                        " + weaponsMasterWall;
			
			airLabel2 = new TextField();
			airLabel2.name = "airLabel2";
			airLabel2.x = 60;
			airLabel2.y = 3230;
			airLabel2.width = 600;
			airLabel2.embedFonts = true;
			airLabel2.defaultTextFormat = highscoreFormat;
			airLabel2.textColor = 0xff0000;
			airLabel2.selectable = false;
			airLabel2.text = "Air" + "       " +weaponsBeginnerSmall + "                       " + weaponsApprenticeSmall + "                        " + weaponsMasterSmall;
			
			buttonContainer.addChild(pacifistLabel);
			buttonContainer.addChild(weaponsLabel);
			buttonContainer.addChild(beginnerLabel);
			buttonContainer.addChild(apprenticeLabel);
			buttonContainer.addChild(masterLabel);
			buttonContainer.addChild(earthLabel1);
			buttonContainer.addChild(waterLabel1);
			buttonContainer.addChild(airLabel1);
			buttonContainer.addChild(earthLabel2);
			buttonContainer.addChild(waterLabel2);
			buttonContainer.addChild(airLabel2);
			
			//fill array(s?)
			buttons = [back, play, highscore, difficulty, tutorial, tutorials, objective, movementTutorial, dodgeTutorial, weaponTutorial, beginner, apprentice, master, mode, weapons, pacifist, arena, standard, walls, small, options, credits, art, georbec, programming, conan, copyright, testers];
			
			//add listeners to buttons
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.CLICK, buttonClicked);
			
			optionsMenu = new OptionsMenu(this, 0, 2000, displayField, musicChannel, settings, true, "", "", "", activeButton, keybindings);
			addChild(displayField);
		}
		private function mouseOver(event:MouseEvent):void
		{
			if(activeBack == null){
				if(buttons.indexOf(event.target) != -1){
					activeButton = event.target as MovieClip;
					buttonContainer.setChildIndex(activeButton, numChildren - 1);
				}
			}
		}
		private function mouseOut(event:MouseEvent):void
		{
			if(event.target == activeButton){
				activeButton = null;
			}
		}
		private function buttonClicked(event:MouseEvent):void
		{	
			if(activeButton == null)
			{
				return;
			}
			else{
				var menuSelect:Sound = new MenuSelect;
				menuSelect.play(0, 0, new SoundTransform(settings.data.effectsVolume));
			}
			/**
			 * Layer 0 / Main Menu / y = 0
			 * Layer 1 / Difficulty / y = 500
			 * Layer 2 / Modes / y = 1000
			 * Layer 3 / Stages / y = 1500
			 * Layer 4 / Options / y = 2000
			 * Layer 5 / Credits / y = 2500
			 * Layer 6 / Highscore / y = 3000
			 * Layer 7 / Highscore / y = 3500
			 */
			//keep track of last button clicked
			lastButtonClicked = activeButton;
			//determine which button clicked, assign layer to a value
			if(activeButton.toString() == "[object Back]"){
				if(layer >= 1 && layer < 4)
					layer = layer-1;
				else if(layer == 4)
					layer = 0;
				else if(layer == 5)
					layer = 0;
				else if(layer == 6)
					layer = 0;
				else if(layer == 7)
					layer = 1;
			}
			else if(activeButton.toString() == "[object Play]"){
				layer = 1;
			}
			else if(activeButton.toString() == "[object High_Scores]"){
				layer = 6;
			}
			else if(activeButton.toString() == "[object Tutorial]"){
				layer = 7;
			}
			else if(activeButton.toString() == "[object TutorialMovement]"){
				screen.setDifficulty(0);
				screen.setPacifist(false);
				screen.setWorld(0);
				destroy();
			}
			else if(activeButton.toString() == "[object Tutorial_Enemies]"){
				screen.setDifficulty(0);
				screen.setPacifist(false);
				screen.setWorld(4);
				destroy();
			}
			else if(activeButton.toString() == "[object Tutorial_Weapons]"){
				screen.setDifficulty(0);
				screen.setPacifist(false);
				screen.setWorld(5);
				destroy();				
			}
			else if(activeButton.toString() == "[object Beginner]"){
				screen.setDifficulty(0);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Apprentice]"){
				screen.setDifficulty(1);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Master]"){
				screen.setDifficulty(2);
				layer = 2;
			}
			else if(activeButton.toString() == "[object Weapons]"){
				screen.setPacifist(false);
				layer = 3;
			}
			else if(activeButton.toString() == "[object Pacifist]"){
				screen.setPacifist(true);
				layer = 3;
			}
			else if(activeButton.toString() == "[object Earth]"){
				screen.setWorld(1);				
				destroy();
			}
			else if(activeButton.toString() == "[object Water]"){
				screen.setWorld(2);
				destroy();
			}
			else if(activeButton.toString() == "[object Air]"){
				screen.setWorld(3);
				destroy();
			}
			else if(activeButton.toString() == "[object Options]"){
				layer = 4;
			}
			else if(activeButton.toString() == "[object Credits]"){
				layer = 5;
			}
			//determine where to move the container using layer
			switch(layer){
				case 0: //Main Menu
					containerGoalY = 0;
					break;
				case 1: //Difficulty
					containerGoalY = 500;
					break;
				case 2: //Mode
					containerGoalY = 1000;
					break;
				case 3: //Stages
					containerGoalY = 1500;
					break;
				case 4: //Options
					containerGoalY = 2000;
					break;
				case 5: //Credits
					containerGoalY = 2500;
					break;
				case 6: //Highscore
					containerGoalY = 3000;
					break;
				case 7: //Tutorial
					containerGoalY = 3500;
					break;
			}
		}
		
		public function destroy():void{
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.CLICK, buttonClicked);
			optionsMenu.destroy();
			optionsMenu = null;
			
			musicChannel.stop();
			screen.removeChild(this);
		}
		
		public function update():void
		{
			if(optionsMenu != null){
				optionsMenu.update();
			}
			
			//adjust size of button
			for each (var button:MovieClip in buttons) {
				if(button == activeButton){
					
					if(button.scaleX <= 1.5){
						button.scaleX +=0.1;
						button.scaleY +=0.1;
					}
					
					if(activeButton.toString() == "[object Back]"){
						if(layer == 0){
							displayField.text = "No more tofu";
						}
						else if(layer == 3){
							displayField.text = "Tofu do not  live inFire";
						}
						else{
							displayField.text = "Previous tofu";
						}
					}
					else if(activeButton.toString() == "[object Play]"){
						displayField.text = "Become the tofu of  time"
					}
					else if(activeButton.toString() == "[object High_Scores]"){
						displayField.text = "Admire your tofu"
					}
					else if(activeButton.toString() == "[object Options]"){
						displayField.text = "Customize your tofu"
					}
					else if(activeButton.toString() == "[object Credits]"){
						displayField.text = "Appreciate the tofu"
					}
					else if(activeButton.toString() == "[object Art]"){
						displayField.text = "Subjective tofu"
					}
					else if(activeButton.toString() == "[object Programming]"){
						displayField.text = "Tofu technology"
					}
					else if(activeButton.toString() == "[object Georbec]"){
						displayField.text = "Tofu Prophet"
					}
					else if(activeButton.toString() == "[object Conan]"){
						displayField.text = "Tofu Wizard"
					}
					else if(activeButton.toString() == "[object Copyright]"){
						displayField.text = "Tofu Birthday"
					}
					else if(activeButton.toString() == "[object Testers]"){
						displayField.text = "Tofu Disciples"
					}
					else if(activeButton.toString() == "[object Tutorial]"){
						displayField.text = "Learn the theory of  tofu"
					}
					else if(activeButton.toString() == "[object Objective]"){
						displayField.text = "Scavenge for Ammo and Survive"
					}
					else if(activeButton.toString() == "[object TutorialMovement]"){
						displayField.text = "The grace of  tofu"
					}
					else if(activeButton.toString() == "[object Tutorials]"){
						displayField.text = "Select your tofu major"
					}
					else if(activeButton.toString() == "[object Tutorial_Enemies]"){
						displayField.text = "The skill of  tofu";
					}
					else if(activeButton.toString() == "[object Tutorial_Weapons]"){
						displayField.text = "The power of  tofu";
					}
					else if(activeButton.toString() == "[object Difficulty]"){
						displayField.text = "Select your tofu level";
					}
					else if(activeButton.toString() == "[object Beginner]"){
						displayField.text = "Start your tofu journey";
					}
					else if(activeButton.toString() == "[object Apprentice]"){
						displayField.text = "Continue your tofu studies";
					}
					else if(activeButton.toString() == "[object Master]"){
						displayField.text = "Prove your f luency in tofunese";
					}
					else if(activeButton.toString() == "[object Mode]"){
						displayField.text = "Select your tofu way";
					}
					else if(activeButton.toString() == "[object Weapons]"){
						displayField.text = "Tofu of War uses guns";
					}
					else if(activeButton.toString() == "[object Pacifist]"){
						displayField.text = "Tofu of Peace only Avoids";
					}
					else if(activeButton.toString() == "[object Arena]"){
						displayField.text = "Select your tofu home";
					}
					else if(activeButton.toString() == "[object Earth]"){
						displayField.text = "Tofu Dwelling";
					}
					else if(activeButton.toString() == "[object Water]"){
						displayField.text = "Tofu Paradise";
					}
					else if(activeButton.toString() == "[object Air]"){
						displayField.text = "Tofu Nightmare";
					}
				}
				else{
					if(button.scaleX >= 1){
						button.scaleX -=0.1;
						button.scaleY -=0.1;
						displayField.text = "";
					}
				}
			}
			//animate screen change
			if(Math.abs(buttonContainer.y) < containerGoalY){
				buttonContainer.y -= scrollSpeed;
				backgroundTexture.y -= scrollSpeed;
				optionsMenu.y -= scrollSpeed;
				title.y -= scrollSpeed;
			}
			//clicking back button to go in the reverse direction
			if(lastButtonClicked != null && lastButtonClicked.toString() == "[object Back]")
			{
				//scroll in reverse until layer is met
				if(Math.abs(buttonContainer.y) > containerGoalY){
					buttonContainer.y += scrollSpeed;
					backgroundTexture.y += scrollSpeed;
					optionsMenu.y += scrollSpeed;
					title.y += scrollSpeed;

				}
			}
			//move back button with container
			back.y = Math.abs(buttonContainer.y) + 50;
		}
	}
}