/**
 * Code to make item drop
 */
package Assets {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	import FlashGame.PlayerHUD;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class ItemDrop extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		private var metricPixRatio:Number = Stage.metricPixRatio;
		
		//PROPERTIES
		private var position:Point;
		private var itemDropClip:MovieClip;
		private var itemDrop_Width:Number;
		private var itemDrop_Height:Number;
		private var itemType:int;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var itemDropFixture:b2FixtureDef;
		private var itemDropXDirection:Number;
		private var itemDropYDirection:Number;
		
		/**Constructor*/
		public function ItemDrop(xPos:Number, yPos:Number, width:Number, height:Number, type:int){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			
			//initialize default private variables
			itemDrop_Width = width;
			itemDrop_Height = height;
			itemType = type;
			
			itemDropFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes itemDrop*/
		public function make():void{
			//Box2D shape
			var itemDropShape:b2PolygonShape = new b2PolygonShape();
			
			itemDropShape.SetAsBox(itemDrop_Width/2, itemDrop_Height/2);
			
			//Box2D shape properties
			itemDropFixture.shape = itemDropShape;
			itemDropFixture.isSensor = true;
			
			if(itemType == 1){
				itemDropFixture.userData = "HEART";
			}
			else{
				itemDropFixture.userData = "AMMO";
			}

			
			//Box2D collision shape
			var itemDropCollision:b2BodyDef = new b2BodyDef();
			itemDropCollision.position.Set(position.x + itemDrop_Width/2, position.y + itemDrop_Height/2);
			itemDropCollision.type = b2Body.b2_staticBody;
			
			collisionBody = world_Sprite.CreateBody(itemDropCollision);
			collisionBody.CreateFixture(itemDropFixture);
			super.body = collisionBody;
			
			//Sprite
			if(itemType == 1){
				itemDropClip = new heart();
				itemDropClip.gotoAndStop("idle");
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
			}
			else{
				itemDropClip = new ammobox();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
			}
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			//destroy yourself with any contact
			if(collisionBody.GetFixtureList().GetUserData() == "DEAD"){
				if(itemType == 1 && Player.playerHealth < 6){
					Player.playerHealth++;
					PlayerHUD.heartRevive = true;
				}
				else{
					Weapon.weaponAmmo +=5;
					if(!Weapon.holdingWeapon){
						Weapon.needWeapon = true;
					}
				}
				destroyAll();
			}
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			itemDrop_Width = width;
		}
		
		public function set height(height:Number):void{
			itemDrop_Height = height;
		}
	}
}