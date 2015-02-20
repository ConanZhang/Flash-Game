package FlashGame{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public class DebugScreen extends Sprite {
		//debug display
		private var xml:XML;
		private var style:StyleSheet;
		private var text:TextField;
		
		//fps
		private var fps:uint;
		private var ms:uint;
		private var updateDelay:uint;
		private var averageFPS:Vector.<uint>;//holds up to 60 fps values to average
		private var vectorLength:int;
		private var totalFPS:Number;//used to calculate average fps
		
		//memory usage
		private var maxMemUsed:Number;
		private var currentMemUsed:Number;
		private var objectAmount:int;
		
		private const MBConversion:int = 1048576;
		
		//update timer
		private var updateTimer:int;
		
		public function DebugScreen():void {		
			//initiate member variables
			fps = 0;
			averageFPS = new Vector.<uint>();
			vectorLength = averageFPS.length;
			totalFPS = 0;
			
			maxMemUsed = 0;
			
			xml =
				<display>
					<header>FPS DATA</header>
						<label>FPS: </label>
							<FPS>-</FPS>
						<label>Average FPS/Minute: </label>
							<averageFPS>-</averageFPS>
						<label>Milliseconds/Frame: </label>
							<msPerFrame>-</msPerFrame>
					<header>MEMORY USAGE (MB)</header>
						<label>Current: </label>
							<currentMemory>-</currentMemory>
						<label>Max: </label>
							<maxMemory>-</maxMemory>
						<label>Total: </label>
							<totalMemory>-</totalMemory>
						<label>Garbage: </label>
							<garbageMemory>-</garbageMemory>
						<label>Display Objects: </label>
							<objectAmount>-</objectAmount>
				</display>;
			
			style = new StyleSheet();
			style.setStyle("display",{fontSize:"9",fontFamily:"courier"});
			style.setStyle("header",{color:"#00FF00"});
			style.setStyle("label",{color:"#BBBBBB",display:"inline"});
			
			//FPS
			style.setStyle("FPS",{color:"#FFFFFF"});
			style.setStyle("averageFPS",{color:"#FFFFFF"});
			style.setStyle("msPerFrame",{color:"#FFFFFF"});
			
			//memory
			style.setStyle("currentMemory",{color:"#FFFFFF"});
			style.setStyle("maxMemory",{color:"#FFFFFF"});
			style.setStyle("totalMemory",{color:"#FFFFFF"});
			style.setStyle("garbageMemory",{color:"#FFFFFF"});
			style.setStyle("objectAmount",{color:"#FFFFFF"});
			
			/**Display*/
			text = new TextField();
			
			//visual
			text.alpha=0.5;
			text.autoSize=TextFieldAutoSize.LEFT;
			text.styleSheet=style;
			text.condenseWhite=true;
			text.background=true;
			text.backgroundColor=0x000000;
			
			//properties
			text.selectable=false;
			text.mouseEnabled=false;
			
			addChild(text);
			this.addEventListener(Event.ENTER_FRAME, updateDebug);
		}
		
		private function updateDebug(e:Event):void{
			updateTimer = getTimer();
			
			//if more than one second has passed
			if(updateTimer-1000 > updateDelay){
				xml.FPS = fps + " / " + stage.frameRate;

				/**Average FPS*/
				vectorLength = averageFPS.push(fps);//update length
				
				//only use 60 values to average fps over a minute
				if (vectorLength>60) {
					averageFPS.shift();
				}
				
				totalFPS =0;
				
				//total values of fps
				for (var i:uint = 0; i < averageFPS.length; i++) {
					totalFPS+=averageFPS[i];
				}
				
				totalFPS=totalFPS/averageFPS.length;
				
				xml.averageFPS=Math.round(totalFPS);
				
				/**Memory*/
				currentMemUsed = System.totalMemory;
				maxMemUsed=Math.max(currentMemUsed,maxMemUsed);
				
				xml.currentMemory= (currentMemUsed/MBConversion).toFixed(2);
				xml.maxMemory=(maxMemUsed/MBConversion).toFixed(2);
				xml.totalMemory = (System.privateMemory/MBConversion).toFixed(2);
				xml.garbageMemory = (System.freeMemory/MBConversion).toFixed(2);
				
				countObjects(stage);
				xml.objectAmount= objectAmount;
				
				/**Reset counters*/
				objectAmount=0;
				fps=0;
				updateDelay=updateTimer;
			}
			
			fps++;
			
			xml.msPerFrame=(updateTimer-ms);
			ms=updateTimer;
			
			text.htmlText=xml;
		}
		
		private function countObjects(stageP:DisplayObjectContainer):void{
			objectAmount += stageP.numChildren;
			
			//calculate the children of display objects in display objects
			for (var i:uint=0; i < stageP.numChildren; i++){
				if(stageP.getChildAt(i) is DisplayObjectContainer){
					countObjects( (DisplayObjectContainer)(stageP.getChildAt(i) ) );
				}
			}
		}
		
		public function destroy():void{
			this.removeEventListener(Event.ENTER_FRAME, updateDebug);
			this.parent.removeChild(this);
		}
	}
}