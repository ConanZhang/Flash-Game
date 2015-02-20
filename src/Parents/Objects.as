/**
 * Parent class to all objects that will collide
 */
package Parents
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	public class Objects extends EventDispatcher
	{
		//Box2D body
		private var _body:b2Body;
		//sprite on Box2D body
		private var _sprite:DisplayObject;
		//constant to determine how much a pixel is in metric units
		public const metricPixRatio: uint = 20;
		
		/**Constructor DOES NOTHING*/
		public function Objects(){}
		
		/**Returns the sprite's height/2*/
		public function halfHeight():Number{
			return _sprite.height/2;
		}
		
		/**Update your state*/
		public function update():void{
			//only update sprites that are moving
			if(_body.IsAwake() ){
				updateSprite();
			}
			
			//unique updates for different children
			childUpdate();
		}
		
		/**Update sprites location and angle*/
		private function updateSprite():void{
			_sprite.x = _body.GetPosition().x * metricPixRatio;
			_sprite.y = _body.GetPosition().y * metricPixRatio;
		}
		
		/**Overwritten by child for it's own update*/
		public function childUpdate():void{}
		
		/**Total removal*/
		public function destroyAll():void{
			//child's specific functions it needs to do when removed
			childRemove();
			
			//remove Box2D body
			Stage.world.DestroyBody(_body);
			
			//remove sprite
			_sprite.parent.removeChild(_sprite);
		}
		
		/**Overwritten by child for it's own remove*/
		public function childRemove():void{}
		
		/**Remove collision body*/
		public function destroyBody():void{
			//child's specific functions it needs to do when removed
			childRemove();

			//remove Box2D body
			Stage.world.DestroyBody(_body);
		}
	
		/**Remove sprite*/
		public function destroySprite():void{
			//remove sprite
			_sprite.parent.removeChild(_sprite);
		}
		
		/**Set sprite*/
		public function set sprite(spriteP:DisplayObject):void{
			_sprite = spriteP;
			updateSprite();
		}
		
		/**Get sprite*/
		public function get sprite():DisplayObject{
			return _sprite;
		}
		
		/**Set and get body*/
		public function set body(bodyP:b2Body):void{
			_body = bodyP;
			_body.SetUserData(this);
		}
		
		public function get body():b2Body{
			return _body;
		}
		
	}
}