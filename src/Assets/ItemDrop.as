/**
 * Code to make item drop
 */
package Assets {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import FlashGame.PlayerHUD;
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class ItemDrop extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
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
			itemDropFixture.userData = new Array("ITEM");
			itemDropFixture.filter.maskBits = 1;
			
			//Box2D collision shape
			var itemDropCollision:b2BodyDef = new b2BodyDef();
			itemDropCollision.position.Set(position.x + itemDrop_Width/2, position.y + itemDrop_Height/2);
			itemDropCollision.type = b2Body.b2_staticBody;
			
			collisionBody = world_Sprite.CreateBody(itemDropCollision);
			collisionBody.CreateFixture(itemDropFixture);
			super.body = collisionBody;
			
			/**Sprite*/
			//heart
			if(itemType == 1){
				itemDropClip = new heart();
				itemDropClip.gotoAndStop("idle");
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
			}
			//pistol ammo
			else if(itemType == 2){
				itemDropClip = new ammobox_pistol();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
				Stage.ammunitionCount++;
			}
			//shotgun ammo
			else if(itemType == 3){
				itemDropClip = new ammobox_shotgun();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
				Stage.ammunitionCount++;
			}
				//shotgun ammo
			else if(itemType == 4){
				itemDropClip = new ammobox_machinegun();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
				Stage.ammunitionCount++;
			}
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			//destroy yourself with any contact
			if(collisionBody.GetFixtureList().GetUserData()[0] == "DEAD"){
				if(itemType == 1 && Player.playerHealth < 6){
					Player.playerHealth++;
					PlayerHUD.heartRevive = true;
				}
				else if(itemType == 2){
					Weapon.pistolAmmo +=5;
					Stage.ammunitionCount--;
					if(!Weapon.holdingWeapon){
						Weapon.needWeapon = true;
						Weapon.weaponType = 1;
					}
				}
				else if(itemType == 3){
					Weapon.shotgunAmmo +=2;
					Stage.ammunitionCount--;
					if(!Weapon.holdingWeapon){
						Weapon.needWeapon = true;
						Weapon.weaponType = 2;
					}
				}
				else if(itemType == 4){
					Weapon.machinegunAmmo +=10;
					Stage.ammunitionCount--;
					if(!Weapon.holdingWeapon){
						Weapon.needWeapon = true;
						Weapon.weaponType = 3;
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