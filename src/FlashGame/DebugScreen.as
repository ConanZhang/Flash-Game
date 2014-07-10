package FlashGame{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public class DebugScreen extends Sprite {
		/**Class Member Variables*/
		private var xml:XML;
		
		private var text:TextField;
		
		//fps
		private var fps:uint;
		private var ms:uint;
		private var updateTime:uint;
		private var averageFPS:Vector.<uint>;//holds FPS values up to a minute to average

		//memory usage
		private var maxMemUsed:Number;
		private var childrenCount:int;
		
		public function DebugScreen(screenP:Sprite):void {		
			//initiate class member variables
			fps = 0;
			maxMemUsed = 0;
			averageFPS = new Vector.<uint>();
			
			xml =
				<xml>
				<sectionTitle>FPS DISPLAY</sectionTitle>
				<sectionLabel>FPS: </sectionLabel>
				<framesPerSecond>-</framesPerSecond>
				<sectionLabel>Average FPS/Minute: </sectionLabel>
				<averageFPS>-</averageFPS>
				<sectionLabel>Milliseconds/Frame: </sectionLabel>
				<msFrame>-</msFrame>
				<sectionTitle>MEMORY DISPLAY</sectionTitle>
				<sectionLabel>Current: </sectionLabel>
				<directMemory>-</directMemory>
				<sectionLabel>Max: </sectionLabel>
				<directMemoryMax>-</directMemoryMax>
				<sectionLabel>Total: </sectionLabel>
				<veryTotalMemory>-</veryTotalMemory>
				<sectionLabel>Garbage: </sectionLabel>
				<garbageMemory>-</garbageMemory>
				<sectionTitle>STAGE DISPLAY</sectionTitle>
				<sectionLabel>Width: </sectionLabel>
				<widthPx>-</widthPx>
				<sectionLabel>Height: </sectionLabel>
				<heightPx>-</heightPx>
				<sectionLabel>Children: </sectionLabel>
				<nChildren>-</nChildren>
				</xml>;
			var style:StyleSheet = new StyleSheet();
			style.setStyle("xml",{fontSize:"9px",fontFamily:"arial"});
			style.setStyle("sectionTitle",{color:"#FFAA00"});
			style.setStyle("sectionLabel",{color:"#CCCCCC",display:"inline"});
			style.setStyle("framesPerSecond",{color:"#FFFFFF"});
			style.setStyle("msFrame",{color:"#FFFFFF"});
			style.setStyle("averageFPS",{color:"#FFFFFF"});
			style.setStyle("directMemory",{color:"#FFFFFF"});
			style.setStyle("veryTotalMemory",{color:"#FFFFFF"});
			style.setStyle("garbageMemory",{color:"#FFFFFF"});
			style.setStyle("directMemoryMax",{color:"#FFFFFF"});
			style.setStyle("widthPx",{color:"#FFFFFF"});
			style.setStyle("heightPx",{color:"#FFFFFF"});
			style.setStyle("nChildren",{color:"#FFFFFF"});
			text = new TextField();
			text.alpha=0.8;
			text.autoSize=TextFieldAutoSize.LEFT;
			text.styleSheet=style;
			text.condenseWhite=true;
			text.selectable=false;
			text.mouseEnabled=false;
			text.background=true;
			text.backgroundColor=0x000000;
			addChild(text);
			addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void {
			var timer:int=getTimer();
			if (timer-1000>updateTime) {
				var vectorLength:int=averageFPS.push(fps);
				if (vectorLength>60) {
					averageFPS.shift();
				}
				var vectorAverage:Number=0;
				for (var i:Number = 0; i < averageFPS.length; i++) {
					vectorAverage+=averageFPS[i];
				}
				vectorAverage=vectorAverage/averageFPS.length;
				xml.averageFPS=Math.round(vectorAverage);
				var directMemory:Number=System.totalMemory;
				maxMemUsed=Math.max(directMemory,maxMemUsed);
				xml.directMemory=(directMemory/1048576).toFixed(3);
				xml.directMemoryMax=(maxMemUsed/1048576).toFixed(3);
				xml.veryTotalMemory = (System.privateMemory/1048576).toFixed(3);
				xml.garbageMemory = (System.freeMemory/1048576).toFixed(3);
				xml.framesPerSecond=fps+" / "+stage.frameRate;
				xml.widthPx=stage.width+" / "+stage.stageWidth;
				xml.heightPx=stage.height+" / "+stage.stageHeight;
				childrenCount=0;
				countDisplayList(stage);
				xml.nChildren=childrenCount;
				fps=0;
				updateTime=timer;
			}
			fps++;
			xml.msFrame=(timer-ms);
			ms=timer;
			text.htmlText=xml;
		}
		private function countDisplayList(container:DisplayObjectContainer):void {
			childrenCount+=container.numChildren;
			for (var i:uint=0; i < container.numChildren; i++) {
				if (container.getChildAt(i) is DisplayObjectContainer) {
					countDisplayList(DisplayObjectContainer(container.getChildAt(i)));
				}
			}
		}
	}
}