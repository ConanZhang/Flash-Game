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
		
		/**Constructor DOES NOTHING*/
		public function Objects(){}
		
		/**Returns the sprite's height/2*/
		public function halfHeight():Number{
			return _sprite.height/2;
		}
		
		/**Update your state*/
		public function update():void{
			//only update sprites that visually change
			if(_body.IsActive() ){
				updateSprite();
			}
			
			//unique updates for different children
			childUpdate();
		}
		
		/**Update sprites location and angle*/
		private function updateSprite():void{
			_sprite.x = _body.GetPosition().x * Stage.metricPixRatio;
			_sprite.y = _body.GetPosition().y * Stage.metricPixRatio;
		}
		
		/**Overwritten by child for it's own update*/
		public function childUpdate():void{
			
		}
		
		/**Remove yourself if necessary*/
		public function destroy():void{
			//child's specific functions it needs to do when removed
			childRemove();
			//remove sprite
			_sprite.parent.removeChild(_sprite);
			//remove Box2D body
			Stage.world.DestroyBody(_body);
		}
		
		/**Overwritten by child for it's own remove*/
		public function childRemove():void{
			
		}
		
		/**Sets player*/
		public function setPlayer():void{
			Stage.player = _body;
		}
		
		/**Sets body*/
		public function set body(bodyP:b2Body):void{
			_body = bodyP;
			_body.SetUserData(this);
		}
		
		/**Set sprite*/
		public function set sprite(spriteP:DisplayObject):void{
			_sprite = spriteP;
			updateSprite();
		}
	}
}