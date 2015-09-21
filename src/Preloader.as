package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	[SWF(backgroundColor="#C4A57C", width="700", height="525", frameRate="30")]
	public class Preloader extends Sprite
	{
		// Private
		private var slowBarClip:MovieClip;
		private var playerClip:MovieClip;
		private var _preloaderPercent:Shape;
		private var _checkForCacheFlag:Boolean = true;
		// Constants
		private static const MAIN_CLASS_NAME:String = "FlashGame";
		
		public function Preloader()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (slowBarClip)
			{
				removeChild(slowBarClip);
				slowBarClip = null;
			}
			
			if (playerClip)
			{
				removeChild(playerClip);
				playerClip = null;
			}
			if (_preloaderPercent)
			{
				removeChild(_preloaderPercent);
				_preloaderPercent = null;
			}
		}
		
		// Private functions
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_checkForCacheFlag == true)
			{
				_checkForCacheFlag = false;
				if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
				{
					finishedLoading();
				}
				else
					beginLoading();
			}
			else
			{
				if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
				{
					finishedLoading();
				}
				else
				{
					var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
					updateGraphic(percent);
				}
			}
		}
		
		private function beginLoading():void
		{
			// Might not be called if cached.
			// ------------------------------
			slowBarClip = new slowbar;
			slowBarClip.width = 230;
			slowBarClip.height = 30;
			slowBarClip.x = 350;
			slowBarClip.y = 260;
			
			playerClip = new player;
			playerClip.width = 3.5*20;
			playerClip.height = 3.5*20;
			playerClip.x = 550;
			playerClip.y = 260;
			playerClip.gotoAndStop("jumping");
			playerClip.rotation += 40;
			
			_preloaderPercent = new Shape();
			_preloaderPercent.graphics.clear();
			_preloaderPercent.graphics.beginFill(0xff0000);
			_preloaderPercent.graphics.drawRect(238,250,0,22);
			_preloaderPercent.graphics.endFill();
			
			addChild(_preloaderPercent);
			addChild(slowBarClip);
			addChild(playerClip);
		}
		
		private function updateGraphic(percent:Number):void
		{
			_preloaderPercent.graphics.clear();
			_preloaderPercent.graphics.beginFill(0xff0000);
			_preloaderPercent.graphics.drawRect(238,250,percent*225,22);
			_preloaderPercent.graphics.endFill();
			
			playerClip.rotation += 40;
		}
		
		private function finishedLoading():void
		{
			var MainClass:Class = getDefinitionByName(MAIN_CLASS_NAME) as Class;
			
			if (MainClass == null)
				throw new Error("Preloader: There is no class \"" + MAIN_CLASS_NAME + "\".");
			
			var main:DisplayObject = new MainClass() as DisplayObject;
			if (main == null)
				throw new Error("Preloader: The class \"" + MAIN_CLASS_NAME + "\" is not a Sprite or MovieClip.");
			
			addChild(main);
			dispose();
		}
	}
}