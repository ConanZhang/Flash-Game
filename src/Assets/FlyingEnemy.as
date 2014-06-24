/**
 * Code to make flyingEnemy
 */
package Assets {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
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
		private var flyingEnemy_LinearDamping:Number;
		private var flyingEnemyHealth:int;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var flyingEnemyFixture:b2FixtureDef;
		
		/**Constructor*/
		public function FlyingEnemy(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			flyingEnemy_Width = width;
			flyingEnemy_Height = height;
			flyingEnemy_LinearDamping = 1;
			flyingEnemyHealth = 2;
			
			flyingEnemyFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes FlyingEnemy*/
		public function make():void{
			//Box2D shape
			var flyingEnemyShape:b2PolygonShape = new b2PolygonShape();
			flyingEnemyShape.SetAsBox(flyingEnemy_Width/2, flyingEnemy_Height/3);
			
			//Box2D shape properties
			flyingEnemyFixture.shape = flyingEnemyShape;
			flyingEnemyFixture.userData = "ENEMY";
			flyingEnemyFixture.filter.categoryBits = 6;
			
			//Box2D collision shape
			var flyingEnemyCollision:b2BodyDef = new b2BodyDef();
			flyingEnemyCollision.position.Set(position.x + flyingEnemy_Width/2, position.y + flyingEnemy_Height/2);
			flyingEnemyCollision.type = b2Body.b2_dynamicBody;
			flyingEnemyCollision.linearDamping = flyingEnemy_LinearDamping;
			
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
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			var direction:b2Vec2 = new b2Vec2();
			   
			/**Follow player*/
			//get direction and magnitude to player
			direction = b2Math.SubtractVV(Stage.player.GetPosition() , collisionBody.GetPosition());
			
			direction.Normalize();
			
			//limit speed
			if(collisionBody.GetLinearVelocity().x < 20 &&
					collisionBody.GetLinearVelocity().x > -20 &&
						collisionBody.GetLinearVelocity().y < 20 &&
							collisionBody.GetLinearVelocity().y > -20){
				direction.Multiply(45);
			}

			//follow
			collisionBody.SetAwake(true);
			collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			
			/**Oppose gravity*/
			direction.Set(0, -85);
			collisionBody.SetAwake(true);
			collisionBody.ApplyForce(direction, collisionBody.GetPosition() );
			
			/**Hurt yourself*/
			//destroy yourself with any contact
			if(collisionBody.GetFixtureList().GetUserData() == "DAMAGE"){				
				if(flyingEnemyHealth > 0){
					flyingEnemyHealth--;
				}

				collisionBody.GetFixtureList().SetUserData("ENEMY");
			}
			
			/**Kill yourself*/
			if(flyingEnemyHealth <= 0){				
				//don't collide with anything
				var deadFilter:b2FilterData = new b2FilterData();
				deadFilter.maskBits = 4;
				
				collisionBody.GetFixtureList().SetFilterData(deadFilter);
				collisionBody.GetFixtureList().SetUserData("DEAD");
				
				flyingEnemyClip.gotoAndStop("death");	

				if(EndAnimation.endEnemyDeath){
					EndAnimation.endEnemyDeath = false;
					
					//create random drop
					if(Math.random() > 0.9){
						if(Math.random() > 0.7){
							var healthDrop:ItemDrop = new ItemDrop(collisionBody.GetPosition().x, collisionBody.GetPosition().y, 1.5, 1.5, 1);
						}
						else{
							var ammoDrop:ItemDrop = new ItemDrop(collisionBody.GetPosition().x, collisionBody.GetPosition().y, 1.5,1.5, 2);
						}
					}
		
					//destroy yourself
					destroyAll();
				}
			}
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			flyingEnemy_Width = width;
		}
		
		public function set height(height:Number):void{
			flyingEnemy_Height = height;
		}
		
	}
}