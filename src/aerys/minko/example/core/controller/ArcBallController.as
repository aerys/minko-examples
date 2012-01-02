package aerys.minko.example.core.controller
{
	import aerys.minko.scene.node.ITransformableScene;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ArcBallController
	{
		private var _target			: ITransformableScene	= null;
		
		private var _tracking		: Boolean				= false;
		private var _x				: Number				= 0.;
		private var _y				: Number				= 0.;
		
		private var _sensitivity	: Number				= 0.01;
		private var _lockedOnPoles	: Boolean				= true;
		private var _invertX		: Boolean				= false;
		private var _invertY		: Boolean				= false;
		
		private var _rotationX		: Number				= 0.;
		private var _rotationY		: Number				= 0.;

		public function get target() : ITransformableScene
		{
			return _target;
		}

		public function get mouseSensitivity() : Number
		{
			return _sensitivity;
		}
		
		public function get lockedOnPoles() : Boolean
		{
			return _lockedOnPoles;
		}
		
		public function get invertX() : Boolean
		{
			return _invertX;
		}
		
		public function get invertY() : Boolean
		{
			return _invertY;
		}
		
		public function set mouseSensitivity(value : Number)	: void
		{
			_sensitivity = value;
		}
		
		public function set lockedOnPoles(value : Boolean)	: void
		{
			_lockedOnPoles = value;
		}
		
		public function set invertX(value : Boolean) : void
		{
			_invertX = value;
		}
		
		public function set invertY(value : Boolean) : void
		{
			_invertY = value;
		}
		
		public function ArcBallController(target	: ITransformableScene)
		{
			_target = target;
		}
		
		public function bindDefaultControls(dispatcher : IEventDispatcher) : void
		{
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			dispatcher.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatcher.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler); 
		}
		
		private function mouseDownHandler(event : MouseEvent) : void
		{
			_tracking = true;
		}
		
		private function mouseUpHandler(event : MouseEvent) : void
		{
			_tracking = false;
		}
		
		public function rotateX(angle : Number) : void
		{
			var rotX 	: Number	= _rotationX + angle;
			
			if (_lockedOnPoles)
			{
				if (rotX > Math.PI * .5)
					rotX = Math.PI * .5;
				if (rotX < -Math.PI * .5)
					rotX = -Math.PI * .5;
				
				angle = rotX - _rotationX;
			}
			
			_rotationX = rotX;
			
			if (angle != 0.)
				_target.transform.prependRotation(angle, ConstVector4.X_AXIS);
		}
		
		public function rotateY(angle : Number) : void
		{
			_target.transform.appendRotation(angle, ConstVector4.Y_AXIS);
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void
		{
			if (_tracking)
			{
				rotateX((event.localY - _y) * _sensitivity * (_invertX ? -1 : 1));
				rotateY((event.localX - _x) * _sensitivity * (_invertY ? -1 : 1));
			}
			
			_x = event.localX;
			_y = event.localY;
		}
	}
}