/**
 * Code to make flyingEnemy
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
	
	public class FlyingEnemy extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var flyingEnemyClip:MovieClip;
		private var flyingEnemy_Width:Number;
		private var flyingEnemy_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var flyingEnemyFixture:b2FixtureDef;
		private var flyingEnemy_Friction:Number;
		private var flyingEnemy_Density:Number;
		
		/**Constructor*/
		public function FlyingEnemy(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			flyingEnemy_Width = width;
			flyingEnemy_Height = height;
			flyingEnemy_Friction = 0.7;
			flyingEnemy_Density = 0;
			
			flyingEnemyFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes FlyingEnemy*/
		public function make():void{
			//Box2D shape
			var flyingEnemyShape:b2PolygonShape = new b2PolygonShape();
			flyingEnemyShape.SetAsBox(flyingEnemy_Width/2, flyingEnemy_Height/4);
			
			//Box2D shape properties
			flyingEnemyFixture.shape = flyingEnemyShape;
			flyingEnemyFixture.friction = flyingEnemy_Friction;
			flyingEnemyFixture.density = flyingEnemy_Density;
			
			//Box2D collision shape
			var flyingEnemyCollision:b2BodyDef = new b2BodyDef();
			flyingEnemyCollision.position.Set(position.x + flyingEnemy_Width/2, position.y + flyingEnemy_Height/2);
			
			collisionBody = world_Sprite.CreateBody(flyingEnemyCollision);
			collisionBody.CreateFixture(flyingEnemyFixture);
			super.body = collisionBody;
			
			//Sprite
			flyingEnemyClip = new enemy_flying;
			flyingEnemyClip.stop();
			flyingEnemyClip.width = flyingEnemy_Width*metricPixRatio;
			flyingEnemyClip.height = flyingEnemy_Height*metricPixRatio;
			super.sprite = flyingEnemyClip;
			Stage.sprites.addChild(flyingEnemyClip);
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			flyingEnemy_Width = width;
		}
		
		public function set height(height:Number):void{
			flyingEnemy_Height = height;
		}
		
		public function set friction(friction:Number):void{
			flyingEnemy_Friction = friction;
		}
		
		public function set density(density:Number):void{
			flyingEnemy_Density = density;
		}
	}
}