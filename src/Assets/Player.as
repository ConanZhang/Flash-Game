/**
 * Code to make player.
 */
package Assets
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Player extends Objects
	{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var playerSprite:Sprite;
		private var player_Width:Number;
		private var player_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var playerFixture:b2FixtureDef;
		private var player_Friction:Number;
		private var player_Density:Number;
		private var player_Restitution:Number;
		private var player_LinearDamping:Number;
		
		/**Constructor*/
		public function Player(xPos:Number, yPos:Number, width:Number, height:Number)
		{
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			player_Width = width;
			player_Height = height;
			player_Friction = 1;
			player_Density = 0.5;
			player_Restitution = 0;
			player_LinearDamping =0;
			
			playerFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Ground*/
		public function make():void{
			//Box2D shape
			var playerShape:b2PolygonShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/2, player_Height/2);
			
			//Box2D shape properties
			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			//Box2D collision shape
			var playerCollision:b2BodyDef = new b2BodyDef();
			playerCollision.position.Set(position.x + player_Width/2, position.y + player_Height/2);
			playerCollision.linearDamping = player_LinearDamping;
			playerCollision.type = b2Body.b2_dynamicBody;
			
			collisionBody = world_Sprite.CreateBody(playerCollision);
			collisionBody.CreateFixture(playerFixture);
			super.body = collisionBody;
			
			//Sprite
			playerSprite = new testPlayer();
			playerSprite.width = player_Width*metricPixRatio;
			playerSprite.height = player_Height*metricPixRatio;
			super.sprite = playerSprite;
			Stage.sprites.addChild(playerSprite);
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			player_Width = width;
		}
		
		public function set height(height:Number):void{
			player_Height = height;
		}
		
		public function set friction(friction:Number):void{
			player_Friction = friction;
		}
		
		public function set density(density:Number):void{
			player_Density = density;
		}
		
		public function set linearDamping(linearDamping:Number):void{
			player_LinearDamping = linearDamping;
		}
		
		public function set restitution(restitution:Number):void{
			player_Restitution = restitution;
		}
	}
}