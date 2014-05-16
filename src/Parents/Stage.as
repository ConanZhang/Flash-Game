/**
 * Parent class for all stages
 */
package Parents
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class Stage extends MovieClip
	{
		/**Class Member Variables*/
		//constant to determine how much a pixel is in metric units
		public static const metricPixRatio: Number = 20;
		
		/**WORLD*/
		//world for all objects to exist in
		private static var worldStage:b2World;
		//variable for all images to be held in for camera movement
		private static var images:Sprite;
		
		/**PLAYER*/
		//player body for collision detection
		public static var player:b2Body;
		//is the player jumping?
		public static var jumping:Boolean;
		
		
		/**Constructor*/
		public function Stage()
		{
			/**VISUAL**/
			//initiate images
			images = new Sprite();
			this.addChild(images);
			
			/**EVENT**/
			//update every frame
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			/**WORLD**/
			//world's bounding box
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-5000/metricPixRatio, -5000/metricPixRatio);
			worldAABB.upperBound.Set(5000/metricPixRatio, 5000/metricPixRatio);
			
			var gravity:b2Vec2 = new b2Vec2(0, 9.8);
			var doSleep:Boolean = true;//don't simulate sleeping bodies
			worldStage = new b2World(gravity, doSleep);
			
			/**DEBUGGING**/
			//draws what Box2D sees
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(images);
			debugDraw.SetDrawScale(metricPixRatio);
			debugDraw.SetAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			worldStage.SetDebugDraw(debugDraw);
		}
		
		/**Stages can update their properties*/
		public function update(e:Event):void{
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
		}
		
		/**Stages always center the screen on the player*/
		private function centerScreen(xPos:Number, yPos:Number):void{
			
		}
		
		/**Stages can detect key presses*/
		public function keyPressed(e:KeyboardEvent):void{
			
		}
		
		/**Stage can detect key releases*/
		public function keyReleased(e:KeyboardEvent):void{
			
		}
		
		/**Get and Set for stageWorld*/
		static public function get world():b2World{ return worldStage; }
		static public function set world(worldStageP:b2World):void{
			if(worldStage == null){
				worldStage = worldStageP;
			}
		}
		
		/**Get and Set for images*/
		static public function get sprites():Sprite{ return images; }
		static public function set sprites(imagesP:Sprite):void{
			if(images == null){
				images = imagesP;
			}
		}
	}
}