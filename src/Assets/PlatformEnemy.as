/**
 * Code to make platformEnemy
 */
package Assets {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
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
		
		/**Constructor*/
		public function PlatformEnemy(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			platformEnemy_Width = width;
			platformEnemy_Height = height;
			platformEnemy_LinearDamping = 1;
			platformEnemyHealth = 2;
			
			platformEnemyFixture = new b2FixtureDef();
			
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
			platformEnemyFixture.filter.categoryBits = 6;
			
			//Box2D collision shape
			var platformEnemyCollision:b2BodyDef = new b2BodyDef();
			platformEnemyCollision.position.Set(position.x + platformEnemy_Width/4, position.y + platformEnemy_Height/4);
			platformEnemyCollision.type = b2Body.b2_dynamicBody;
			platformEnemyCollision.linearDamping = platformEnemy_LinearDamping;
			
			collisionBody = world_Sprite.CreateBody(platformEnemyCollision);
			collisionBody.CreateFixture(platformEnemyFixture);
			super.body = collisionBody;
			
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
		
		/**Setters*/
		public function set width(width:Number):void{
			platformEnemy_Width = width;
		}
		
		public function set height(height:Number):void{
			platformEnemy_Height = height;
		}
		
	}
}