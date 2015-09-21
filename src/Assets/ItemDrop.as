/**
 * Code to make item drop
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
		
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		private var player:Player;
		private var weapon:Weapon;
		
		private var arena:Stage;
		
		/**Constructor*/
		public function ItemDrop(_arena:Stage, xPos:Number, yPos:Number, width:Number, height:Number, type:int, _settings:SharedObject, _HUD:PlayerHUD, _player:Player, _weapon:Weapon){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			arena = _arena;
			
			//initialize default private variables
			itemDrop_Width = width;
			itemDrop_Height = height;
			itemType = type;
			HUD = _HUD;
			player = _player;
			weapon = _weapon;
			
			settings = _settings;
			
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
				arena.ammunitionCount++;
			}
			//shotgun ammo
			else if(itemType == 3){
				itemDropClip = new ammobox_shotgun();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
				arena.ammunitionCount++;
			}
				//shotgun ammo
			else if(itemType == 4){
				itemDropClip = new ammobox_machinegun();
				itemDropClip.width = itemDrop_Width*metricPixRatio;
				itemDropClip.height = itemDrop_Height*metricPixRatio;
				super.sprite = itemDropClip;
				Stage.sprites.addChild(itemDropClip);
				arena.ammunitionCount++;
			}
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			//destroy yourself with any contact
			if(collisionBody.GetFixtureList().GetUserData()[0] == "DEAD"){
				if(itemType == 1 && player.playerHealth < 6){
					player.playerHealth++;
					HUD.heartRevive = true;
					
					var lifeUp:Sound = new LifeUp;
					if(HUD.slowMotion && HUD.slowAmount > 0){
						lifeUp.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
					}
					else{
						lifeUp.play(0, 0, new SoundTransform(settings.data.effectsVolume));
					}					}
				else if(itemType == 2){
					weapon.pistolAmmo +=5;
					arena.ammunitionCount--;

					var pistolReload:Sound = new PistolReload;
					if(HUD.slowMotion && HUD.slowAmount > 0){
						pistolReload.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
					}
					else{
						pistolReload.play(0, 0, new SoundTransform(settings.data.effectsVolume));
					}						
					if(!weapon.holdingWeapon){
						weapon.needWeapon = true;
						weapon.weaponType = 1;
					}
				}
				else if(itemType == 3){
					weapon.shotgunAmmo +=2;
					arena.ammunitionCount--;
					
					var shotgunReload:Sound = new ShotgunReload;
					if(HUD.slowMotion && HUD.slowAmount > 0){
						shotgunReload.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
					}
					else{
						shotgunReload.play(0, 0, new SoundTransform(settings.data.effectsVolume));
					}						
					if(!weapon.holdingWeapon){
						weapon.needWeapon = true;
						weapon.weaponType = 2;
					}
				}
				else if(itemType == 4){
					weapon.machinegunAmmo +=10;
					arena.ammunitionCount--;
					
					var machinegunReload:Sound = new MachineGunReload;
					if(HUD.slowMotion && HUD.slowAmount > 0){
						machinegunReload.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
					}
					else{
						machinegunReload.play(0, 0, new SoundTransform(settings.data.effectsVolume));
					}						
					if(!weapon.holdingWeapon){
						weapon.needWeapon = true;
						weapon.weaponType = 3;
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