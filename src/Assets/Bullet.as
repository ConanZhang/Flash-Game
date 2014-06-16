/**
 * Code to make bullet
 */
package Assets {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Bullet extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var bulletClip:Sprite;
		private var bullet_Width:Number;
		private var bullet_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var bulletFixture:b2FixtureDef;
		private var bullet_Density:Number;
		private var bulletXDirection:Number;
		private var bulletYDirection:Number;
		
		/**Constructor*/
		public function Bullet(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			bullet_Width = width;
			bullet_Height = height;
			bullet_Density = 0;
			
			bulletFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Bullet*/
		public function make():void{
			//Box2D shape
			var bulletShape:b2PolygonShape = new b2PolygonShape();
			
			bulletShape.SetAsBox(bullet_Width/2, bullet_Height/2);

			//Box2D shape properties
			bulletFixture.shape = bulletShape;
			bulletFixture.density = bullet_Density;
			bulletFixture.filter.maskBits = 2;
			bulletFixture.userData = "BULLET";
			
			//Box2D collision shape
			var bulletCollision:b2BodyDef = new b2BodyDef();
			bulletCollision.position.Set(position.x + bullet_Width/2, position.y + bullet_Height/2);
			bulletCollision.type = b2Body.b2_dynamicBody;
			bulletCollision.fixedRotation = true;
			
			collisionBody = world_Sprite.CreateBody(bulletCollision);
			collisionBody.CreateFixture(bulletFixture);
			collisionBody.SetBullet(true);
			super.body = collisionBody;
									
			//Sprite
			bulletClip = new bullet();
			bulletClip.width = bullet_Width*metricPixRatio;
			bulletClip.height = bullet_Height*metricPixRatio;
			super.sprite = bulletClip;
			Stage.sprites.addChild(bulletClip);
			
			//initial velocity
			bulletXDirection = Math.cos(Stage.weaponRotation)*300;
			bulletYDirection = Math.sin(Stage.weaponRotation)*300;

			collisionBody.ApplyImpulse(new b2Vec2( bulletXDirection, bulletYDirection), collisionBody.GetPosition());
		}

		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			//destroy yourself with any contact
			if(collisionBody.GetFixtureList().GetUserData() == "DEAD"){
				destroyAll();
			}
			//shoot
			collisionBody.ApplyForce(new b2Vec2( bulletXDirection, bulletYDirection), collisionBody.GetPosition());
			collisionBody.ApplyForce(new b2Vec2( 0, -85 ), collisionBody.GetPosition());
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			bullet_Width = width;
		}
		
		public function set height(height:Number):void{
			bullet_Height = height;
		}
		
		public function set density(density:Number):void{
			bullet_Density = density;
		}
	}
}