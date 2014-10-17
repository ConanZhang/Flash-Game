/**
 * Code to make weapon
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
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class Weapon extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
		//ANIMATION STATES
		public static var   STATE   	:int;
		public static const LEFT    	:int = 0;
		public static const RIGHT	  	:int = 1;
		
		public var leftFire:Boolean;
		public var rightFire:Boolean;
		
		//PROPERTIES
		private var position:Point;
		public var weaponClip:MovieClip;
		public static var weaponType:int;
		public static var pistolAmmo:int;
		public static var shotgunAmmo:int;
		public static var machinegunAmmo:int;
		public static var holdingWeapon:Boolean;
		public static var needWeapon:Boolean;
		public static var changeWeapon:Boolean;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var weaponFixture:b2FixtureDef;
		
		/**Constructor*/
		public function Weapon(xPos:Number, yPos:Number, type:int){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			weaponType = type;
			
			//initialize default private variables
			pistolAmmo = 10;
			shotgunAmmo = 2;
			machinegunAmmo = 15;
			holdingWeapon = true;
			needWeapon = false;
			changeWeapon = false;
			
			STATE = RIGHT;
			leftFire = false;
			rightFire = false;
			
			weaponFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Weapon*/
		public function make():void{
			//Box2D shape
			var weaponShape:b2PolygonShape = new b2PolygonShape();
			weaponShape.SetAsBox(0.1, 0.1);
			
			//Box2D shape properties
			weaponFixture.shape = weaponShape;
			weaponFixture.filter.maskBits = 0;
			weaponFixture.isSensor = true;
			weaponFixture.userData = new Array("WEAPON");
			
			//Box2D collision shape
			var weaponCollision:b2BodyDef = new b2BodyDef();
			weaponCollision.position.Set(position.x, position.y );
			
			collisionBody = world_Sprite.CreateBody(weaponCollision);
			collisionBody.CreateFixture(weaponFixture);
			super.body = collisionBody;
			
			//Sprite
			if(weaponType == 1){
				weaponClip = new pistol();
				weaponClip.gotoAndStop("pistol_right");
				weaponClip.width = 2*metricPixRatio;
				weaponClip.height = 1*metricPixRatio;
				super.sprite = weaponClip;
				Stage.sprites.addChild(weaponClip);
			}
			else if(weaponType == 2){
				weaponClip = new shotgun();
				weaponClip.gotoAndStop("shotgun_right");
				weaponClip.width = 3*metricPixRatio;
				weaponClip.height =2*metricPixRatio;
				super.sprite = weaponClip;
				Stage.sprites.addChild(weaponClip);
			}
			else if(weaponType == 3){
				weaponClip = new machinegun();
				weaponClip.gotoAndStop("machinegun_right");
				weaponClip.width = 3*metricPixRatio;
				weaponClip.height =2*metricPixRatio;
				super.sprite = weaponClip;
				Stage.sprites.addChild(weaponClip);
			}
		}
		
		/**Child Update [called by Object's update]*/
		public override function childUpdate():void{
			if(needWeapon){
				//add correct sprite when got ammo when holding nothing
				if(weaponType == 1 && pistolAmmo > 0){
					weaponClip = new pistol();
					weaponClip.gotoAndStop("pistol_right");
					weaponClip.width = 2*metricPixRatio;
					weaponClip.height = 1*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}
				else if(weaponType == 2 && shotgunAmmo > 0){
					weaponClip = new shotgun();
					weaponClip.gotoAndStop("shotgun_right");
					weaponClip.width = 3*metricPixRatio;
					weaponClip.height =2*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}	
				else if(weaponType == 3 && machinegunAmmo > 0){
					weaponClip = new machinegun();
					weaponClip.gotoAndStop("machinegun_right");
					weaponClip.width = 3*metricPixRatio;
					weaponClip.height =2*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}	
				holdingWeapon = true;
				needWeapon = false;
			}
			
			//update weapon sprite if necessary
			if(changeWeapon){
				if(weaponClip != null){
					destroySprite();
				}
				Stage.machineFire = false;
				//switch to pistol
				if(weaponType == 1 && pistolAmmo > 0){
					weaponClip = new pistol();
					weaponClip.gotoAndStop("pistol_right");
					weaponClip.width = 2*metricPixRatio;
					weaponClip.height = 1*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}
				//switch to shotgun
				else if(weaponType == 2 && shotgunAmmo > 0){
					weaponClip = new shotgun();
					weaponClip.gotoAndStop("shotgun_right");
					weaponClip.width = 3*metricPixRatio;
					weaponClip.height =2*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}
				//switch to machinegun
				else if(weaponType == 3 && machinegunAmmo > 0){
					weaponClip = new machinegun();
					weaponClip.gotoAndStop("machinegun_right");
					weaponClip.width = 3*metricPixRatio;
					weaponClip.height =2*metricPixRatio;
					super.sprite = weaponClip;
					Stage.sprites.addChild(weaponClip);
				}
				else{
					holdingWeapon = false;
				}
				
				changeWeapon = false;
			}
			
			
			collisionBody.SetPosition( Stage.playerBody.GetPosition() );
			weaponClip.rotation = Stage.weaponRotation*180/Math.PI;
			
			//match rotation
			if(weaponClip.rotation > -90 && weaponClip.rotation  < 90 && !leftFire){
				STATE = RIGHT;
			}
			else if(!rightFire){
				STATE = LEFT;
			}

			//shooting pistol
			if(weaponType == 1){
				if(STATE == RIGHT && !rightFire){
					weaponClip.gotoAndStop("pistol_right");
				}
				else if(STATE == LEFT && !leftFire){
					weaponClip.gotoAndStop("pistol_left");
				}
				else if(rightFire){
					weaponClip.gotoAndStop("pistol_right_fire");
					
					if(weaponClip.endFire){
						rightFire = false;
					}
				}
				else if(leftFire){
					weaponClip.gotoAndStop("pistol_left_fire");
									
					if(weaponClip.endFire){
						leftFire = false;
					}
				}
				
				//check state of weapon BEFORE removing it if necessary
				if(pistolAmmo == 0 && holdingWeapon){
					if(shotgunAmmo > 0){
						weaponType = 2;
						changeWeapon = true;
					}
					else if(machinegunAmmo > 0){
						weaponType = 3;
						changeWeapon = true;
					}
					//no weapon
					else{
						weaponType = 0;
						changeWeapon = true;
						rightFire = false;
						leftFire = false;
						weaponClip.endFire = true;
					}
				}
			}
			//shooting shotgun
			else if(weaponType == 2){
				if(STATE == RIGHT && !rightFire){
					weaponClip.gotoAndStop("shotgun_right");
				}
				else if(STATE == LEFT && !leftFire){
					weaponClip.gotoAndStop("shotgun_left");
				}
				else if(rightFire){
					weaponClip.gotoAndStop("shotgun_right_fire");

					if(weaponClip.endFire){
						rightFire = false;
					}
				}
				else if(leftFire){
					weaponClip.gotoAndStop("shotgun_left_fire");	
					
					if(weaponClip.endFire){
						leftFire = false;
					}
				}
				
				//check state of weapon BEFORE removing it if necessary
				if(shotgunAmmo == 0 && holdingWeapon){
					if(machinegunAmmo > 0){
						weaponType = 3;
						changeWeapon = true;
					}
					else if(pistolAmmo > 0){
						weaponType = 1;
						changeWeapon = true;
					}
					//no weapon
					else{
						weaponType = 0;
						changeWeapon = true;
						rightFire = false;
						leftFire = false;
						weaponClip.endFire = true;
					}
				}
			}
			//shooting machine gun
			else if(weaponType == 3){
				if(STATE == RIGHT && !rightFire){
					weaponClip.gotoAndStop("machinegun_right");
				}
				else if(STATE == LEFT && !leftFire){
					weaponClip.gotoAndStop("machinegun_left");
				}
				else if(rightFire){
					weaponClip.gotoAndStop("machinegun_right_fire");
				}
				else if(leftFire){
					weaponClip.gotoAndStop("machinegun_left_fire");
								
				}
				
				//check state of weapon BEFORE removing it if necessary
				if(machinegunAmmo <= 0 && holdingWeapon){
					if(shotgunAmmo > 0){
						weaponType = 2;
						changeWeapon = true;
					}
					else if(pistolAmmo > 0){
						weaponType = 1;
						changeWeapon = true;
					}
					//no weapon
					else{
						weaponType = 0;
						changeWeapon = true;
						rightFire = false;
						leftFire = false;
					}
				}
			}
			
			//kill yourself if player is dead
			if(Player.playerClip.dead && holdingWeapon){
				destroyAll();
			}
			//just remove body if there is no sprite
			else if(Player.playerClip.dead && !holdingWeapon){
				destroyBody();
			}
		}
	}
}