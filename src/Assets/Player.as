/**
 * Code to make player.
 */
package Assets
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	
	import flash.display.MovieClip;
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
		private var playerClip:MovieClip;
		private var player_Width:Number;
		private var player_Height:Number;
		
		//ANIMATION STATES
		private var   STATE   :int;
		private const IDLE    :int = 0;
		private const R_WALK  :int = 1;
		private const L_WALK  :int = 2;
		private const JUMPING :int = 3;		
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var playerFixture:b2FixtureDef;
		private var playerFootSensor:b2Fixture;
		private var playerJoints:b2RevoluteJointDef;
		private var player_Friction:Number;
		private var player_Density:Number;
		private var player_Restitution:Number;
		private var player_LinearDamping:Number;
		
		public static var footContacts:int;
		
		/**Constructor*/
		public function Player(xPos:Number, yPos:Number, size:Number)
		{
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			player_Width = size;
			player_Height = size;
			player_Friction = 0.5;
			player_Density = 0.22;
			player_Restitution = 0.1;
			player_LinearDamping = 1.75;
			
			playerFixture = new b2FixtureDef();
			playerJoints = new b2RevoluteJointDef();
			
			STATE = IDLE;
			
			footContacts = 0;
			
			make();
		}
		
		/**Makes Player*/
		public function make():void{
			
			/**Head*/
			//Box2D shape
			var playerShape:b2PolygonShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/3.75, player_Height/3.75);
			
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
			playerCollision.fixedRotation = true;
			
			collisionBody = world_Sprite.CreateBody(playerCollision);
			collisionBody.CreateFixture(playerFixture);
			super.body = collisionBody;
			
			/**Feet*/
			playerShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/3.74, player_Height/8.1);

			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			playerCollision.position.Set(position.x + player_Width/2, position.y + player_Height/1.15);
			var feet:b2Body = world_Sprite.CreateBody(playerCollision);
			feet.CreateFixture(playerFixture);
			
			/**Connecting body*/
			//head to feet
			playerJoints.enableLimit = true;
			
			playerJoints.lowerAngle = -90/(180/Math.PI);
			playerJoints.upperAngle = 90/(180/Math.PI);
			
			playerJoints.Initialize(collisionBody, feet, new b2Vec2(position.x + player_Width/2, position.y + player_Height/2) );
			world_Sprite.CreateJoint(playerJoints);
			
			/**Sensor*/
			playerShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width*2, player_Height*2);
			playerCollision.position.Set(position.x + player_Width/2, position.y + player_Height/2);
			
			playerFixture.isSensor = true;
			
			playerFootSensor = collisionBody.CreateFixture(playerFixture);
			playerFootSensor.SetUserData(3);
			
			
			
			//Sprite
			playerClip = new MovieClip();
//			playerClip = new player_walking();
			playerClip.width = player_Width*metricPixRatio;
			playerClip.height = player_Height*metricPixRatio;
			super.sprite = playerClip;
			Stage.sprites.addChild(playerClip);
		}
		
		/**Child Update [called by Object's update]**/
		public override function childUpdate():void
		{
			
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