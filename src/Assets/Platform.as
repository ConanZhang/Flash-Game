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
	
	public class Platform extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var platformClip:MovieClip;
		private var platform_Width:Number;
		private var platform_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var platformFixture:b2FixtureDef;
		private var platform_Friction:Number;
		private var platform_Density:Number;
		
		/**Constructor*/
		public function Platform(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			platform_Width = width;
			platform_Height = height;
			platform_Friction = 0.7;
			platform_Density = 0;
			
			platformFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Ground*/
		public function make():void{
			//Box2D shape
			var groundShape:b2PolygonShape = new b2PolygonShape();
			groundShape.SetAsBox(platform_Width/2, platform_Height/4);
			
			//Box2D shape properties
			platformFixture.shape = groundShape;
			platformFixture.friction = platform_Friction;
			platformFixture.density = platform_Density;
			platformFixture.userData = "PLATFORM";
			
			//Box2D collision shape
			var platformCollision:b2BodyDef = new b2BodyDef();
			platformCollision.position.Set(position.x + platform_Width/2, position.y + platform_Height/2);
			platformCollision.type = b2Body.b2_kinematicBody;
			
			collisionBody = world_Sprite.CreateBody(platformCollision);
			collisionBody.CreateFixture(platformFixture);
			super.body = collisionBody;
			
			//Sprite
			platformClip = new ground();
			platformClip.stop();
			platformClip.width = platform_Width*metricPixRatio;
			platformClip.height = platform_Height*metricPixRatio;
			super.sprite = platformClip;
			Stage.sprites.addChild(platformClip);
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			platform_Width = width;
		}
		
		public function set height(height:Number):void{
			platform_Height = height;
		}
		
		public function set friction(friction:Number):void{
			platform_Friction = friction;
		}
		
		public function set density(density:Number):void{
			platform_Density = density;
		}
	}
}