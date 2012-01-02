package aerys.minko.example.core.controller
{
	import aerys.minko.scene.node.ITransformableScene;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;

	public class FPSController
	{
		private static const TMP_VECTOR4	: Vector4	= new Vector4();
		
		private var _target		: ITransformableScene	= null;
		
		private var _ghostMode	: Boolean				= false;
		
		public function FPSController(target : ITransformableScene)
		{
			_target = target;
		}
		
		private function bindDefaultControls(dispatcher : IEventDispatcher) : void
		{
			dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			dispatcher.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function keyDownHandler(event : KeyboardEvent) : void
		{
			
		}
		
		private function keyUpHandler(event : KeyboardEvent) : void
		{
			
		}
		
		public function walk(distance : Number) : void
		{
			var transform	: Matrix4x4	= _target.transform;
			var rotation	: Vector4 	= _target.transform.getRotation(TMP_VECTOR4);

			transform.appendTranslation(
				Math.cos(rotation.y) * Math.cos(rotation.x) * distance,
				Math.sin(rotation.x) * distance,
				Math.sin(rotation.y) * Math.cos(rotation.x) * distance
			);
		}
		
		public function straffe(distance : Number, vertical : Boolean = false) : void
		{
			var rotation	: Vector4 	= _target.transform.getRotation(TMP_VECTOR4);
			
			_target.transform.appendTranslation(
				Math.cos(rotation.y + Math.PI / 2) * -distance,
				0.,
				Math.sin(rotation.y + Math.PI / 2) * -distance
			);
		}
		
		public function turn(angle : Number) : void
		{
			_target.transform.prependRotation(angle, ConstVector4.Y_AXIS);
		}
	}
}