package Game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class OptionsMenu extends MovieClip
	{
		private var screen:Sprite;
		
		private var labelFormat:TextFormat;

		private var controlsLabelText:TextField;	
		private var audioLabelText:TextField;		
		private var systemLabelText:TextField;
		
		public function OptionsMenu(screenP:Sprite, offset:int)
		{
			screen = screenP;
			screen.addChild(this);
			
			labelFormat = new TextFormat();
			labelFormat.size = 35;
			labelFormat.align = "right";
			labelFormat.font = "Zenzai Itacha";
			
			//controls
			controlsLabelText = new TextField();
			controlsLabelText.embedFonts = true;
			controlsLabelText.defaultTextFormat = labelFormat;
			controlsLabelText.x = 150;
			controlsLabelText.y = 25+offset;
			controlsLabelText.textColor = 0xff0000;
			controlsLabelText.selectable = false;	
			
			controlsLabelText.text = "Controls";
			this.addChild(controlsLabelText);
			
			//audio		
			audioLabelText = new TextField();
			audioLabelText.embedFonts = true;
			audioLabelText.defaultTextFormat = labelFormat;
			audioLabelText.x = 450;
			audioLabelText.y = 250+offset;
			audioLabelText.textColor = 0xff0000;
			audioLabelText.selectable = false;	
			
			audioLabelText.text = "Audio";
			this.addChild(audioLabelText);
			
			//system
			systemLabelText = new TextField();
			systemLabelText.embedFonts = true;
			systemLabelText.defaultTextFormat = labelFormat;
			systemLabelText.x = 450;
			systemLabelText.y = 25+offset;
			systemLabelText.textColor = 0xff0000;
			systemLabelText.selectable = false;	
			
			systemLabelText.text = "System";
			this.addChild(systemLabelText);
		}
	}
}