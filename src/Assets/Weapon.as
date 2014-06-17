/**
 * Code to make weapon
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
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Weapon extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//ANIMATION STATES
		public static var   STATE   	:int;
		public static const LEFT    	:int = 0;
		public static const RIGHT	  	:int = 1;
		
		public static var leftFire:Boolean;
		public static var rightFire:Boolean;
		
		//PROPERTIES
		private var position:Point;
		private var weaponClip:MovieClip;
		public static var weapon_Width:Number;
		private var weapon_Height:Number;
		public static var weaponType:String;
		public static var weaponAmmo:int;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var weaponFixture:b2FixtureDef;
		
		/**Constructor*/
		public function Weapon(xPos:Number, yPos:Number, width:Number, height:Number, type:String){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			weaponType = type;
			
			//initialize default private variables
			weapon_Width = width;
			weapon_Height = height;
			weaponAmmo = 50;
			
			STATE = RIGHT;
			leftFire = false;
			rightFire = false;
			
			weaponFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Ground*/
		public function make():void{
			//Box2D shape
			var weaponShape:b2PolygonShape = new b2PolygonShape();
			weaponShape.SetAsBox(weapon_Width/2, weapon_Height/2);
			
			//Box2D shape properties
			weaponFixture.shape = weaponShape;
			weaponFixture.filter.maskBits = 0x0000;
			
			//Box2D collision shape
			var weaponCollision:b2BodyDef = new b2BodyDef();
			weaponCollision.position.Set(position.x + weapon_Width/2, position.y + weapon_Height/2);
			
			collisionBody = world_Sprite.CreateBody(weaponCollision);
			collisionBody.CreateFixture(weaponFixture);
			super.body = collisionBody;
			
			//Sprite
			if(weaponType == "Pistol"){
				weaponClip = new pistol();
				weaponClip.gotoAndStop("pistol_right");
				weaponClip.width = weapon_Width*metricPixRatio;
				weaponClip.height = weapon_Height*metricPixRatio;
				super.sprite = weaponClip;
				Stage.sprites.addChild(weaponClip);
			}
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			collisionBody.SetPosition( Stage.player.GetPosition() );
			weaponClip.rotation = Stage.weaponRotation*180/Math.PI;
			
			//match rotation
			if(weaponClip.rotation > -90 && weaponClip.rotation  < 90){
				STATE = RIGHT;
			}
			else{
				STATE = LEFT;
			}

			//shooting
			if(STATE == RIGHT && !rightFire){
				weaponClip.gotoAndStop("pistol_right");
			}
			else if(STATE == LEFT && !leftFire){
				weaponClip.gotoAndStop("pistol_left");
			}
			else if(rightFire){
				weaponClip.gotoAndStop("pistol_right_fire");
				
				if(EndAnimation.endGunFire){
					EndAnimation.endGunFire = false;
					rightFire = false;
				}
			}
			else if(leftFire){
				weaponClip.gotoAndStop("pistol_left_fire");
				
				if(EndAnimation.endGunFire){
					EndAnimation.endGunFire = false;
					leftFire = false;
				}
			}
			
			//kill yourself if player is dead
			if(EndAnimation.endPlayerDeath){
				destroyAll();
			}
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			weapon_Width = width;
		}
		
		public function set height(height:Number):void{
			weapon_Height = height;
		}
	}
}