/**
 * Code to make ground
 */
package Assets {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Ground extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var groundClip:MovieClip;
		private var ground_Width:Number;
		private var ground_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var groundFixture:b2FixtureDef;
		private var ground_Friction:Number;
		private var ground_Density:Number;
		
		/**Constructor*/
		public function Ground(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			ground_Width = width;
			ground_Height = height;
			ground_Friction = 0.9;
			ground_Density = 0;
			
			groundFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Ground*/
		public function make():void{
			//Box2D shape
			var groundShape:b2PolygonShape = new b2PolygonShape();
			groundShape.SetAsBox(ground_Width/2, ground_Height/2);
			
			//Box2D shape properties
			groundFixture.shape = groundShape;
			groundFixture.friction = ground_Friction;
			groundFixture.density = ground_Density;
			
			//Box2D collision shape
			var groundCollision:b2BodyDef = new b2BodyDef();
			groundCollision.position.Set(position.x + ground_Width/2, position.y + ground_Height/2);
			
			collisionBody = world_Sprite.CreateBody(groundCollision);
			collisionBody.CreateFixture(groundFixture);
			super.body = collisionBody;
			
			//Sprite
			groundClip = new testGround();
			groundClip.stop();
			groundClip.width = ground_Width*metricPixRatio;
			groundClip.height = ground_Height*metricPixRatio;
			super.sprite = groundClip;
			Stage.sprites.addChild(groundClip);
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			ground_Width = width;
		}
		
		public function set height(height:Number):void{
			ground_Height = height;
		}
		
		public function set friction(friction:Number):void{
			ground_Friction = friction;
		}
		
		public function set density(density:Number):void{
			ground_Density = density;
		}
	}
}