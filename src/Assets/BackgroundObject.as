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
			
			if(backgroundObjectType == "cloud1"){
				backgroundObjectClip = new background_cloud1();
			}
			else if(backgroundObjectType =="cloud2"){
				backgroundObjectClip = new background_cloud2();
			}
			else if(backgroundObjectType == "cloud3"){
				backgroundObjectClip = new background_cloud3();
			}
			else if(backgroundObjectType == "cloud4"){
				backgroundObjectClip = new background_cloud4();
			}
			else if(backgroundObjectType == "cloud5"){
				backgroundObjectClip = new background_cloud5();
			}
			else if(backgroundObjectType == "cloud6"){
				backgroundObjectClip = new background_cloud6();
			}
			else if(backgroundObjectType == "cloud7"){
				backgroundObjectClip = new background_cloud7();
			}
			else if(backgroundObjectType == "cloud8"){
				backgroundObjectClip = new background_cloud8();
			}
			else if(backgroundObjectType == "cloud9"){
				backgroundObjectClip = new background_cloud5();
			}
			else if(backgroundObjectType == "cloud10"){
				backgroundObjectClip = new background_cloud5();
			}
			else if(backgroundObjectType == "grass1"){
				backgroundObjectClip = new background_grass1();
			}
			else if(backgroundObjectType == "grass2"){
				backgroundObjectClip = new background_grass2();
			}
			else if(backgroundObjectType == "grass3"){
				backgroundObjectClip = new background_grass3();
			}
			else if(backgroundObjectType == "tree1"){
				backgroundObjectClip = new background_tree1();
			}
			else if(backgroundObjectType == "tree2"){
				backgroundObjectClip = new background_tree2();
			}
			else if(backgroundObjectType == "tree3"){
				backgroundObjectClip = new background_tree3();
			}
			else if(backgroundObjectType == "tree4"){
				backgroundObjectClip = new background_tree4();
			}
			else if(backgroundObjectType == "tree5"){
				backgroundObjectClip = new background_tree5();
			}
			else if(backgroundObjectType == "tutorialP"){
				backgroundObjectClip = new TutorialP();
			}
			else if(backgroundObjectType == "tutorialAD"){
				backgroundObjectClip = new TutorialAD();
			}
			else if(backgroundObjectType == "tutorialW"){
				backgroundObjectClip = new TutorialW();
			}
			else if(backgroundObjectType == "tutorialLongJump"){
				backgroundObjectClip = new TutorialLongJump();
			}
			else if(backgroundObjectType == "tutorialHover"){
				backgroundObjectClip = new TutorialHover();
			}
			else if(backgroundObjectType == "tutorialDoubleJump"){
				backgroundObjectClip = new TutorialDoubleJump();
			}
			else if(backgroundObjectType == "tutorialDoubleJumpHover"){
				backgroundObjectClip = new TutorialDoubleJumpHover();
			}
			else if(backgroundObjectType == "tutorialWallJump"){
				backgroundObjectClip = new TutorialWallJump();
			}
			else if(backgroundObjectType == "tutorialNoJump"){
				backgroundObjectClip = new TutorialNoJump();
			}
			else if(backgroundObjectType == "tutorialSingleWallJump"){
				backgroundObjectClip = new TutorialSingleWallJump();
			}
			else if(backgroundObjectType == "tutorialWallHug"){
				backgroundObjectClip = new TutorialWallHug();
			}
			else if(backgroundObjectType == "tutorialFalling"){
				backgroundObjectClip = new TutorialFalling();
			}
			else if(backgroundObjectType == "tutorialFastFall"){
				backgroundObjectClip = new TutorialFastFall();
			}
			else if(backgroundObjectType == "tutorialDoubleJump"){
				backgroundObjectClip = new TutorialDoubleJump();
			}
			else if(backgroundObjectType == "tutorialSpace"){
				backgroundObjectClip = new TutorialSpace();
			}
			else if(backgroundObjectType == "tutorialBar"){
				backgroundObjectClip = new TutorialBar();
			}
			else if(backgroundObjectType == "tutorialHealth"){
				backgroundObjectClip = new TutorialHealth();
			}
			else if(backgroundObjectType == "tutorialPistol"){
				backgroundObjectClip = new TutorialPistol();
			}
			else if(backgroundObjectType == "tutorialShotgun"){
				backgroundObjectClip = new TutorialShotgun();
			}
			else if(backgroundObjectType == "tutorialMachineGun"){
				backgroundObjectClip = new TutorialMachineGun();
			}
			else if(backgroundObjectType == "tutorialCycle"){
				backgroundObjectClip = new TutorialCycle();
			}
			else if(backgroundObjectType == "tutorialHeart"){
				backgroundObjectClip = new TutorialHeart();
			}
			else if(backgroundObjectType == "tutorialShoot"){
				backgroundObjectClip = new TutorialShoot();
			}
			else if(backgroundObjectType == "tutorialExit"){
				backgroundObjectClip = new TutorialExit();
			}


			backgroundObjectClip.stop();
			backgroundObjectClip.width = backgroundObject_Width*metricPixRatio;
			backgroundObjectClip.height = backgroundObject_Height*metricPixRatio;
			super.sprite = backgroundObjectClip;
			Stage.sprites.addChildAt(backgroundObjectClip, 0);
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