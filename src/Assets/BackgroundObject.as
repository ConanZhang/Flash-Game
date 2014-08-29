/**
 * Code to make backgroundObject
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
	import flash.geom.Point;
	
	public class BackgroundObject extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
		//PROPERTIES
		private var position:Point;
		private var backgroundObjectClip:MovieClip;
		private var backgroundObject_Width:Number;
		private var backgroundObject_Height:Number;
		private var backgroundObjectType:String;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var backgroundObjectFixture:b2FixtureDef;
		
		/**Constructor*/
		public function BackgroundObject(xPos:Number, yPos:Number, width:Number, height:Number, type:String){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			backgroundObjectType = type;
			
			//initialize default private variables
			backgroundObject_Width = width;
			backgroundObject_Height = height;
			
			backgroundObjectFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Platform*/
		public function make():void{
			//Box2D shape
			var backgroundObjectShape:b2PolygonShape = new b2PolygonShape();
			backgroundObjectShape.SetAsBox(0.1, 0.1);

			
			//Box2D shape properties
			backgroundObjectFixture.shape = backgroundObjectShape;
			backgroundObjectFixture.filter.maskBits = 0;
			backgroundObjectFixture.isSensor = true;
			
			//Box2D collision shape
			var backgroundObjectCollision:b2BodyDef = new b2BodyDef();
			backgroundObjectCollision.position.Set(position.x, position.y);
			
			collisionBody = world_Sprite.CreateBody(backgroundObjectCollision);
			collisionBody.CreateFixture(backgroundObjectFixture);
			super.body = collisionBody;
			
			//Sprite
			
			if(backgroundObjectType == "mountain"){
				backgroundObjectClip = new background_mountain();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "cloud1"){
				backgroundObjectClip = new background_cloud1();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType =="cloud2"){
				backgroundObjectClip = new background_cloud2();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "cloud3"){
				backgroundObjectClip = new background_cloud3();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "cloud4"){
				backgroundObjectClip = new background_cloud4();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "cloud5"){
				backgroundObjectClip = new background_cloud5();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "bird1"){
				backgroundObjectClip = new background_bird1();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "bird2"){
				backgroundObjectClip = new background_bird2();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			else if(backgroundObjectType == "bird3"){
				backgroundObjectClip = new background_bird3();
				backgroundObjectClip.stop();
				backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
				backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
				super.sprite = backgroundObjectClip;
				Stage.sprites.addChild(backgroundObjectClip);
			}
			
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			backgroundObject_Width = width;
		}
		
		public function set height(height:Number):void{
			backgroundObject_Height = height;
		}
	}
}