/**
 * Code to make easter egg
 */
package Assets {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Game.PlayerHUD;
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class EasterEgg extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
		//PROPERTIES
		private var position:Point;
		private var easterEggClip:MovieClip;
		private var easterEgg_Width:Number;
		private var easterEgg_Height:Number;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var easterEggFixture:b2FixtureDef;
		private var easterEggXDirection:Number;
		private var easterEggYDirection:Number;
		

		/**Constructor*/
		public function EasterEgg(xPos:Number, yPos:Number, width:Number, height:Number){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			easterEgg_Width = width;
			easterEgg_Height = height;
			
			easterEggFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes itemDrop*/
		public function make():void{
			//Box2D shape
			var easterEggShape:b2PolygonShape = new b2PolygonShape();
			
			easterEggShape.SetAsBox(easterEgg_Width/2, easterEgg_Height/2);
			
			//Box2D shape properties
			easterEggFixture.shape = easterEggShape;
			easterEggFixture.filter.categoryBits = 2;
			easterEggFixture.userData = new Array("NO_JUMP");

			//Box2D collision shape
			var easterEggCollision:b2BodyDef = new b2BodyDef();
			easterEggCollision.position.Set(position.x + easterEgg_Width/2, position.y + easterEgg_Height/2);
			easterEggCollision.type = b2Body.b2_dynamicBody;
			
			collisionBody = world_Sprite.CreateBody(easterEggCollision);
			collisionBody.CreateFixture(easterEggFixture);
			super.body = collisionBody;
			
			/**Sprite*/
			easterEggClip = new easter_egg();
			easterEggClip.width = easterEgg_Width*metricPixRatio;
			easterEggClip.height = easterEgg_Height*metricPixRatio;
			super.sprite = easterEggClip;
			Stage.sprites.addChild(easterEggClip);
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{

		}
		
		/**Setters*/
		public function set width(width:Number):void{
			easterEgg_Width = width;
		}
		
		public function set height(height:Number):void{
			easterEgg_Height = height;
		}
	}
}