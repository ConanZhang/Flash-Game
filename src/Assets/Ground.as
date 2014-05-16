/**
 * Code to make ground
 */
package Assets {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.*;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Ground extends Objects{
		
		//gather all the variables you need in this class
		private var _m_sprite:Sprite = Stage.sprites;
		private var _m_world:b2World = Stage.world;
		private var _m2p:Number = Stage.metricPixRatio;
		private var _location:Point;
		private var _clip:Sprite;
		private var _body:b2Body;
		private var _width:Number = 10;
		private var _height:Number = 2;
		private var _friction:Number = 1;
		private var _density:Number = 0;// static bodies require zero density
		public var fixtureDef:b2FixtureDef = new b2FixtureDef();
		
		public function Ground(locx:int,locy:int){
			_location = new Point(locx,locy);
		}
		
		public function set Width(width:Number):void{
			_width = width;
		}
		
		public function set Height(height:Number):void{
			_height = height;
		}
		
		public function set friction(friction:Number):void{
			_friction = friction;
		}
		
		public function set density(density:Number):void{
			_density = density;
		}
		
		public function create():void{
			var polyDef:b2PolygonShape;
			polyDef = new b2PolygonShape();
			polyDef.SetAsBox(_width/2,_height/2);
			
			fixtureDef.shape = polyDef;
			
			fixtureDef.friction = _friction;
			fixtureDef.density = _density;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(_location.x+_width/2, _location.y+_height/2);	
			
			_body = _m_world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
			super.body = _body;
			
//			_clip = new PhysGround();
//			_clip.width = _width * _m2p;
//			_clip.height = _height * _m2p;
//			super.sprites = _clip;
			
			Stage.sprites.addChild(_clip);
		}
	}
}