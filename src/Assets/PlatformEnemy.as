/**
 * Code to make platformEnemy
 */
package Assets {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class PlatformEnemy extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
		//PROPERTIES
		private var position:Point;
		private var platformEnemyClip:MovieClip;
		private var platformEnemy_Width:Number;
		private var platformEnemy_Height:Number;
		private var platformEnemy_LinearDamping:Number;
		private var platformEnemyHealth:int;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var platformEnemyFixture:b2FixtureDef;
		private var platformEnemyJoints:b2RevoluteJointDef;

		//AI
		private var bottomSensor:b2Body;
		private var rightSensor:b2Body;
		private var leftSensor:b2Body;
		private var topSensor:b2Body;
		private var platformEnemyType:int;
		
		/**Constructor*/
		public function PlatformEnemy(xPos:Number, yPos:Number, width:Number, height:Number, type:int){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			platformEnemy_Width = width;
			platformEnemy_Height = height;
			platformEnemy_LinearDamping = 1;
			platformEnemyHealth = 2;
			platformEnemyType = type;
			
			platformEnemyFixture = new b2FixtureDef();
			platformEnemyJoints = new b2RevoluteJointDef();
			
			make();
		}
		
		/**Makes FlyingEnemy*/
		public function make():void{
			//Box2D shape
			var platformEnemyShape:b2PolygonShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/4, platformEnemy_Height/4);
			
			//Box2D shape properties
			platformEnemyFixture.shape = platformEnemyShape;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("PLATFORM");
			platformEnemyFixture.filter.categoryBits = 6;
			
			//Box2D collision shape
			var platformEnemyCollision:b2BodyDef = new b2BodyDef();
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4);
			platformEnemyCollision.type = b2Body.b2_dynamicBody;
			platformEnemyCollision.linearDamping = platformEnemy_LinearDamping;
			
			collisionBody = world_Sprite.CreateBody(platformEnemyCollision);
			collisionBody.CreateFixture(platformEnemyFixture);
			super.body = collisionBody;
			
			/**Bottom Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/3, platformEnemy_Height/15);
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("BOTTOM");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/1.75);
			bottomSensor = world_Sprite.CreateBody(platformEnemyCollision);
			bottomSensor.CreateFixture(platformEnemyFixture);
			
			/**Right Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/15, platformEnemy_Height/3);
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("RIGHT");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/2, position.y + platformEnemy_Height/4);
			rightSensor = world_Sprite.CreateBody(platformEnemyCollision);
			rightSensor.CreateFixture(platformEnemyFixture);
			
			/**Left Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/15, platformEnemy_Height/3);
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("LEFT");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/3, position.y + platformEnemy_Height/4);
			leftSensor = world_Sprite.CreateBody(platformEnemyCollision);
			leftSensor.CreateFixture(platformEnemyFixture);
			
			/**Top Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/3, platformEnemy_Height/15);
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("TOP");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y);
			topSensor = world_Sprite.CreateBody(platformEnemyCollision);
			topSensor.CreateFixture(platformEnemyFixture);
			
			/**Connecting body*/
			//head to feet
			platformEnemyJoints.enableLimit = true;
			
			platformEnemyJoints.lowerAngle = -90/(180/Math.PI);
			platformEnemyJoints.upperAngle = 90/(180/Math.PI);
			
			//bottom to body
			platformEnemyJoints.Initialize(collisionBody, bottomSensor, new b2Vec2(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4) );
			world_Sprite.CreateJoint(platformEnemyJoints);
			
			//right to body
			platformEnemyJoints.Initialize(collisionBody, rightSensor, new b2Vec2(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4) );
			world_Sprite.CreateJoint(platformEnemyJoints);
			
			//left to body
			platformEnemyJoints.Initialize(collisionBody, leftSensor, new b2Vec2(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4) );
			world_Sprite.CreateJoint(platformEnemyJoints);
			
			//top to body
			platformEnemyJoints.Initialize(collisionBody, topSensor, new b2Vec2(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4) );
			world_Sprite.CreateJoint(platformEnemyJoints);
			
			//Sprite
			platformEnemyClip = new enemy_platform;
			platformEnemyClip.dead = false;
			platformEnemyClip.stop();
			platformEnemyClip.width = platformEnemy_Width*metricPixRatio;
			platformEnemyClip.height = platformEnemy_Height*metricPixRatio;
			super.sprite = platformEnemyClip;
			Stage.sprites.addChild(platformEnemyClip);
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			var direction:b2Vec2 = new b2Vec2();
			
			var bottomData:* = bottomSensor.GetFixtureList().GetUserData()[1];
			var rightData:* = rightSensor.GetFixtureList().GetUserData()[1];
			var leftData:* = leftSensor.GetFixtureList().GetUserData()[1];
			var topData:* = topSensor.GetFixtureList().GetUserData()[1];
			
			/**Circle objects*/
			//on top
			if(bottomData == "BOTTOM_ON" && leftData == "LEFT_ON" && rightData == "RIGHT_ON"){
				if(platformEnemyType == 1){
					direction.Set(-200, 0);
				}
				else{
					direction.Set(200, 0);
				}
				collisionBody.SetAwake(true);
				collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			}
			//on left and top
			else if(rightData == "RIGHT_ON" && topData == "TOP"){
				if(platformEnemyType == 1){
					direction.Set(300, -300);
				}
				else{
					direction.Set(-300, -300);
				}
				collisionBody.SetAwake(true);
				collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			}
			//on left and bottom
			else if(rightData == "RIGHT_ON" && topData == "TOP_ON"){
				if(platformEnemyType == 1){
					direction.Set(-300, -300);
				}
				else{
					direction.Set(300, -300);
				}
				collisionBody.SetAwake(true);
				collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			}
			
			/**Hurt yourself*/
			for (var i:uint = 1; i <= collisionBody.GetFixtureList().GetUserData().length; i++) {
				//pistol/machine gun damage
				if(collisionBody.GetFixtureList().GetUserData()[i] == 1){
					platformEnemyHealth--;
				}
					//shotgun damage
				else if(collisionBody.GetFixtureList().GetUserData()[i] == 2){
					platformEnemyHealth-=2;	
				}
			}
			//empty array of damage
			collisionBody.GetFixtureList().GetUserData().splice(1);
			
			/**Kill yourself*/
			if(platformEnemyHealth <= 0){				
				//don't collide with anything
				var deadFilter:b2FilterData = new b2FilterData();
				deadFilter.maskBits = 4;
				
				collisionBody.GetFixtureList().SetFilterData(deadFilter);
				bottomSensor.GetFixtureList().SetFilterData(deadFilter);
				rightSensor.GetFixtureList().SetFilterData(deadFilter);
				leftSensor.GetFixtureList().SetFilterData(deadFilter);
				topSensor.GetFixtureList().SetFilterData(deadFilter);

				collisionBody.GetFixtureList().GetUserData()[0] = "DEAD";
				
				platformEnemyClip.gotoAndStop("death");	
				
				if(platformEnemyClip.dead){
					
					//create random drop
					if(Math.random() > 0.9){
						//health
						if(Math.random() > 0.7 && Player.playerHealth < 6){
							var healthDrop:ItemDrop = new ItemDrop(collisionBody.GetPosition().x, collisionBody.GetPosition().y, 1.5, 1.5, 1);
						}
						else{
							var randomDrop: Number = Math.random();
							//pistol ammo
							if(randomDrop < 0.6){
								var pistolDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 1.5,1.5, 2);	
							}
								//shotgun ammo
							else if(randomDrop > 0.6 && randomDrop < 0.8){
								var shotgunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2.5,2.5, 3);	
							}
								//machinegun ammo
							else if(randomDrop > 0.8 && randomDrop < 1){
								var machinegunDrop:ItemDrop = new ItemDrop(Math.random()*190 + 40, Math.random()*-90, 2,2, 4);	
							}
						}
					}
					
					//destroy yourself
					destroyAll();
				}
			}
		}
		
		/**Child remove [called by destroy()]*/
		public override function childRemove():void{
			//remove body's components
			world_Sprite.DestroyBody(bottomSensor);
			world_Sprite.DestroyBody(rightSensor);
			world_Sprite.DestroyBody(leftSensor);
			world_Sprite.DestroyBody(topSensor);
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			platformEnemy_Width = width;
		}
		
		public function set height(height:Number):void{
			platformEnemy_Height = height;
		}
		
	}
}