/**
 * Code to make player.
 */
package Assets
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	import Parents.Objects;
	import Parents.Stage;

	public class Player extends Objects
	{
		/**Class Member Variables*/
		//STAGE
		public var stage_Sprite:Sprite;
		public var world_Sprite:b2World;
		
		//PROPERTIES
		public var position:Point;
		public var playerClip:MovieClip;
		private var player_Width:Number;
		private var player_Height:Number;
		public var playerRotation: int;
		public var playerHealth: int;
		public var playerInvulnerable:int;
		
		//ANIMATION STATES
		public var   STATE   	:int;
		public const IDLE    	:int = 0;
		public const R_WALK  	:int = 1;
		public const L_WALK 		:int = 2;
		public const R_WALK_SLOW :int = 3;
		public const L_WALK_SLOW :int = 4;
		public const JUMPING 	:int = 5;
		public const R_WALL		:int = 6;
		public const L_WALL		:int = 7;
		public const HOVER		:int = 8;
		public const FLINCH		:int = 9;
		public const DODGE		:int = 10;
		public const FAST_FALL	:int = 11;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var feet:b2Body;
		private var rightSensor:b2Body;
		private var leftSensor:b2Body;
		private var footSensor:b2Body;
		private var playerFixture:b2FixtureDef;
		private var playerJoints:b2RevoluteJointDef;
		private var player_Friction:Number;
		private var player_Density:Number;
		private var player_Restitution:Number;
		private var player_LinearDamping:Number;
		
		public var jumping:Boolean;
		private var player_size:Number;
		public var machineFire:Boolean;
		
		/**Constructor*/
		public function Player(size:Number)
		{
			player_size = size;
		}
		
		/**Makes Player*/
		public function make():void{
			//assign parameters to class member variables
			playerRotation = 40;
			
			//initialize default private variables
			player_Width = player_size;
			player_Height = player_size;
			player_Friction = 0.4;
			player_Density = 0.4;
			player_Restitution = 0;
			player_LinearDamping = 2;
			playerHealth = 3;
			playerInvulnerable = 0;
			
			playerFixture = new b2FixtureDef();
			playerJoints = new b2RevoluteJointDef();
			
			STATE = IDLE;
			
			/**Head*/
			//Box2D shape
			var playerShape:b2PolygonShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/3.75, player_Height/3.75);
			
			//Box2D shape properties
			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			playerFixture.userData = new Array("PLAYER");
			playerFixture.userData.push("BODY");
			
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
			playerShape.SetAsBox(player_Width/3.73, player_Height/8.1);

			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			playerCollision.position.Set(position.x + player_Width/2, position.y + player_Height/1.15);
			feet = world_Sprite.CreateBody(playerCollision);
			feet.CreateFixture(playerFixture);
			
			/**Foot Sensor*/
			playerShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/3.8, player_Height/100);
			
			playerFixture.isSensor = true;
			playerFixture.userData = new Array("PLAYER");
			playerFixture.userData.push("FOOT");
			
			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			playerCollision.position.Set(position.x + player_Width/2, position.y + player_Height);
			footSensor = world_Sprite.CreateBody(playerCollision);
			footSensor.CreateFixture(playerFixture);
			
			/**Right Side Sensor*/
			playerShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/100, player_Height/2.75);
			
			playerFixture.isSensor = true;
			playerFixture.userData = new Array("PLAYER");
			playerFixture.userData.push("RIGHT");
			
			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			playerCollision.position.Set(position.x + player_Width/1.285, position.y + player_Height/1.6);
			rightSensor = world_Sprite.CreateBody(playerCollision);
			rightSensor.CreateFixture(playerFixture);
			
			/**Left Side Sensor*/
			playerShape = new b2PolygonShape();
			playerShape.SetAsBox(player_Width/100, player_Height/2.75);
			
			playerFixture.isSensor = true;
			playerFixture.userData = new Array("PLAYER");
			playerFixture.userData.push("LEFT");
			
			playerFixture.shape = playerShape;
			playerFixture.friction = player_Friction;
			playerFixture.density = player_Density;
			playerFixture.restitution = player_Restitution;
			
			playerCollision.position.Set(position.x + player_Width/4.5, position.y + player_Height/1.6);
			leftSensor = world_Sprite.CreateBody(playerCollision);
			leftSensor.CreateFixture(playerFixture);
			
			/**Connecting body*/
			//head to feet
			playerJoints.enableLimit = true;
			
			playerJoints.lowerAngle = -90/(180/Math.PI);
			playerJoints.upperAngle = 90/(180/Math.PI);
			
			playerJoints.Initialize(collisionBody, feet, new b2Vec2(position.x + player_Width/2, position.y + player_Height/2) );
			world_Sprite.CreateJoint(playerJoints);
			
			//feet to sensor
			playerJoints.Initialize(feet, footSensor, new b2Vec2(position.x + player_Width/2, position.y + player_Height/2) );
			world_Sprite.CreateJoint(playerJoints);
			
			//head to right sensor
			playerJoints.Initialize(collisionBody, rightSensor, new b2Vec2(position.x + player_Width/2, position.y + player_Height/2) );
			world_Sprite.CreateJoint(playerJoints);
			
			//head to left sensor
			playerJoints.Initialize(collisionBody, leftSensor, new b2Vec2(position.x + player_Width/2, position.y + player_Height/2) );
			world_Sprite.CreateJoint(playerJoints);
			
			//Sprite
			playerClip = new player();
			playerClip.width = player_Width*metricPixRatio;
			playerClip.height = player_Height*metricPixRatio;
			super.sprite = playerClip;
			Stage.sprites.addChild(playerClip);
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{	
			if(STATE == R_WALK && playerHealth != 0){
				playerClip.gotoAndStop("walking_right");
				playerClip.rotation = 0;
			}
			else if(STATE == L_WALK && playerHealth != 0){
				playerClip.gotoAndStop("walking_left");		
				playerClip.rotation = 0;
			}
			else if(STATE == R_WALK_SLOW && playerHealth != 0){
				playerClip.gotoAndStop("walking_right_slow");
				playerClip.rotation = 0;
			}
			else if(STATE == L_WALK_SLOW && playerHealth != 0){
				playerClip.gotoAndStop("walking_left_slow");		
				playerClip.rotation = 0;
			}
			else if(STATE == JUMPING && playerHealth != 0){
				playerClip.gotoAndStop("jumping");
				playerClip.rotation += playerRotation;
			}
			else if(STATE == IDLE && playerHealth != 0){
				playerClip.gotoAndStop("idle");
				playerClip.rotation = 0;
			}
			else if(STATE == R_WALL && playerHealth != 0){
				playerClip.gotoAndStop("wall_right");
				playerClip.rotation = 0;
			}
			else if(STATE == L_WALL && playerHealth != 0){
				playerClip.gotoAndStop("wall_left");
				playerClip.rotation = 0;
			}
			else if(STATE == HOVER && playerHealth != 0){
				playerClip.gotoAndStop("hover");
				playerClip.rotation = 0;
			}
			else if(STATE == FLINCH && playerHealth != 0){
				playerClip.gotoAndStop("flinch");
				playerClip.rotation = 0;
			}
			else if(STATE == FAST_FALL && playerHealth != 0){
				playerClip.gotoAndStop("fall");
				playerClip.rotation = 0;
			}
			else if(STATE == DODGE && playerHealth != 0){
				playerClip.gotoAndStop("dodge");
				playerClip.rotation = 0;
				if(playerClip.dodged){
					playerClip.dodged = false;
					if(jumping){
						STATE = JUMPING;
					}
					else{
						STATE = IDLE;
					}
				}
			}
			else if(playerHealth == 0){
				playerClip.rotation = 0;
				playerClip.gotoAndStop("death");

				//remove yourself
				if(playerClip.dead){
					machineFire = false;
					destroyAll();
				}
			}
			
			//player hit
			if(playerInvulnerable > 0 && playerHealth != 0){
				playerInvulnerable--;
				playerClip.alpha = 0.7;
			}
			else{
				playerClip.alpha = 1;
			}
		}
		
		/**Child remove [called by destroy()]*/
		public override function childRemove():void{
			//remove body's components
			world_Sprite.DestroyBody(feet);
			world_Sprite.DestroyBody(footSensor);
			world_Sprite.DestroyBody(leftSensor);
			world_Sprite.DestroyBody(rightSensor);
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