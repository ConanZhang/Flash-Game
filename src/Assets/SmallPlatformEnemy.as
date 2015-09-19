/**
 * Code to make platformEnemy
 */
package Assets {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.SharedObject;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	import Game.PlayerHUD;
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class SmallPlatformEnemy extends Objects{
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
		private var platformEnemyDirection:int;
		private var avoiding:int;
		
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		private var player:Player;
		private var weapon:Weapon;
		private var arena:Stage;
		
		/**Constructor*/
		public function SmallPlatformEnemy(_arena:Stage, xPos:Number, yPos:Number, width:Number, height:Number, type:int, startingDirection:int,  _settings:SharedObject, _HUD:PlayerHUD, _player:Player, _weapon:Weapon){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			settings = _settings;
			arena = _arena;
			HUD = _HUD;
			player = _player;
			weapon = _weapon;
			
			//initialize default private variables
			platformEnemy_Width = width;
			platformEnemy_Height = height;
			platformEnemy_LinearDamping = 1;
			platformEnemyHealth = 1;
			platformEnemyType = type;
			platformEnemyDirection = startingDirection;

			platformEnemyFixture = new b2FixtureDef();
			platformEnemyJoints = new b2RevoluteJointDef();
			
			avoiding = 0;

			arena.smallPlatformCount++;

			make();
		}
		
		/**Makes FlyingEnemy*/
		public function make():void{
			//Box2D shape
			var platformEnemyShape:b2PolygonShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/3.5, platformEnemy_Height/3.5);
			
			//Box2D shape properties
			platformEnemyFixture.shape = platformEnemyShape;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("PLATFORM");
			platformEnemyFixture.filter.categoryBits = 16;
			platformEnemyFixture.filter.maskBits = 7;
			
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
			platformEnemyShape.SetAsBox(platformEnemy_Width/2, platformEnemy_Height/2.5);
			platformEnemyFixture.filter.categoryBits = 32;
			platformEnemyFixture.filter.maskBits = 2;
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("BOTTOM");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/2.75);
			bottomSensor = world_Sprite.CreateBody(platformEnemyCollision);
			bottomSensor.CreateFixture(platformEnemyFixture);
			
			/**Right Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/2.5, platformEnemy_Height/2);
			platformEnemyFixture.filter.categoryBits = 32;
			platformEnemyFixture.filter.maskBits = 2;
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("RIGHT");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/2.5, position.y + platformEnemy_Height/4);
			rightSensor = world_Sprite.CreateBody(platformEnemyCollision);
			rightSensor.CreateFixture(platformEnemyFixture);
			
			/**Left Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/2.5, platformEnemy_Height/2);
			platformEnemyFixture.filter.categoryBits = 32;
			platformEnemyFixture.filter.maskBits = 2;
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("LEFT");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/8, position.y + platformEnemy_Height/4);
			leftSensor = world_Sprite.CreateBody(platformEnemyCollision);
			leftSensor.CreateFixture(platformEnemyFixture);
			
			/**Top Sensor*/
			platformEnemyShape = new b2PolygonShape();
			platformEnemyShape.SetAsBox(platformEnemy_Width/2, platformEnemy_Height/2.5);
			platformEnemyFixture.filter.categoryBits = 32;
			platformEnemyFixture.filter.maskBits = 2;
			
			platformEnemyFixture.isSensor = true;
			platformEnemyFixture.userData = new Array("ENEMY");
			platformEnemyFixture.userData.push("TOP");
			
			platformEnemyFixture.shape = platformEnemyShape;
			
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/8);
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
			platformEnemyClip = new enemy_platform_small;
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
			
			/**Go around objects*/
			//moving top to bottom
			if(platformEnemyType == 1){
				if(bottomData == "BOTTOM_ON"){
					if(avoiding == 0){
						if(Math.random() > 0.5){
							direction.Set(10, 0);
							avoiding = 1;
						}
						else{
							direction.Set(-10, 0);
							avoiding = 2;
						}
					}
					else if(avoiding == 1){
						direction.Set(10, 0);
					}
					else{
						direction.Set(-10, 0);
					}
					
					collisionBody.SetLinearVelocity(direction);
				}
				else if(topData == "TOP_ON"){
					if(avoiding == 0){
						if(Math.random() > 0.5){
							direction.Set(10, 0);
							avoiding = 1;
						}
						else{
							direction.Set(-10, 0);
							avoiding = 2;
						}
					}
					else if(avoiding == 1){
						direction.Set(10, 0);
					}
					else{
						direction.Set(-10, 0);
					}
					
					collisionBody.SetLinearVelocity(direction);
				}
				else if(bottomData == "BOTTOM_S"){
					platformEnemyDirection = 2;
				}
				else if(topData == "TOP_S"){
					platformEnemyDirection = 1;
				}
				else if(bottomData == "BOTTOM" && topData == "TOP"){
					avoiding = 0;
				}
				
				//Move in main direction
				// move down
				if(platformEnemyDirection == 1){
					direction.Set(0, 70);
				}
					// move up
				else{
					direction.Set(0, -70);
				}
				
				collisionBody.ApplyForce(direction, collisionBody.GetPosition());
			}
				//moving left to right
			else if(platformEnemyType == 2){
				if(rightData == "RIGHT_ON"){
					if(avoiding == 0){
						if(Math.random() > 0.5){
							direction.Set(0, 10);
							avoiding = 1;
						}
						else{
							direction.Set(0, -10);
							avoiding = 2;
						}
					}
					else if(avoiding == 1){
						direction.Set(0, 10);
					}
					else{
						direction.Set(0, -10);
					}
					
					collisionBody.SetLinearVelocity(direction);
				}
				else if(leftData == "LEFT_ON"){
					if(avoiding == 0){
						if(Math.random() > 0.5){
							direction.Set(0, 10);
							avoiding = 1;
						}
						else{
							direction.Set(0, -10);
							avoiding = 2;
						}
					}
					else if(avoiding == 1){
						direction.Set(0, 10);
					}
					else{
						direction.Set(0, -10);
					}
					
					collisionBody.SetLinearVelocity(direction);
				}
				else if(rightData == "RIGHT_S"){
					platformEnemyDirection = 2;
				}
				else if(leftData == "LEFT_S"){
					platformEnemyDirection = 1;
				}
				else if(rightData == "RIGHT" && leftData == "LEFT"){
					avoiding = 0;
				}
				
				//Move in main direction
				// move right
				if(platformEnemyDirection == 1){
					direction.Set(70, 0);
				}
					// move left
				else{
					direction.Set(-70, 0);
				}
				
				collisionBody.ApplyForce(direction, collisionBody.GetPosition());
			}
			
			
			/**Oppose gravity*/
			direction.Set(0, -425);
			collisionBody.SetAwake(true);
			collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			
			/**Hurt yourself*/
			for (var i:uint = 2; i <= collisionBody.GetFixtureList().GetUserData().length; i++) {
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
			collisionBody.GetFixtureList().GetUserData().splice(2);
			
			/**Kill yourself*/
			if(platformEnemyHealth <= 0){				
				//don't collide with anything
				var deadFilter:b2FilterData = new b2FilterData();
				deadFilter.maskBits = 2;
				
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
						if(Math.random() > 0.7 && player.playerHealth < 6){
							var healthDrop:ItemDrop = new ItemDrop(arena, collisionBody.GetPosition().x, collisionBody.GetPosition().y, 1.5, 1.5, 1,  settings, HUD, player, weapon);
						}
						else{
							var randomDrop: Number = Math.random();
							//pistol ammo
							if(randomDrop < 0.6){
								var pistolDrop:ItemDrop = new ItemDrop(arena, collisionBody.GetPosition().x, collisionBody.GetPosition().y, 1.5,1.5, 2, settings, HUD, player, weapon);	
							}
								//shotgun ammo
							else if(randomDrop > 0.6 && randomDrop < 0.8){
								var shotgunDrop:ItemDrop = new ItemDrop(arena, collisionBody.GetPosition().x, collisionBody.GetPosition().y, 2.5,2.5, 3,  settings, HUD, player, weapon);	
							}
								//machinegun ammo
							else if(randomDrop > 0.8 && randomDrop < 1){
								var machinegunDrop:ItemDrop = new ItemDrop(arena, collisionBody.GetPosition().x, collisionBody.GetPosition().y, 2,2, 4, settings, HUD, player, weapon);	
							}
						}
					}
					arena.smallPlatformCount--;

					//destroy yourself
					destroyAll();
				}
			}
			
			//fallen to far so reset body
			if(collisionBody.GetPosition().y > 50){
				collisionBody.SetPosition(new b2Vec2(Math.random()*190 + 40, -500));
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