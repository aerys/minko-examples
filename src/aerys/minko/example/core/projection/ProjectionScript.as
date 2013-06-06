package aerys.minko.example.core.projection
{
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.type.math.Vector4;
	
	import flash.display.DisplayObject;
	
	public class ProjectionScript extends AbstractScriptController
	{
		private var _sprite			: DisplayObject;
		
		private var _screenPosition	: Vector4;
		
		public function ProjectionScript(sprite : DisplayObject)
		{
			super();
			
			_sprite = sprite;
		}
		
		override protected function update(target : ISceneNode) : void
		{
			var camera : Camera = scene.activeCamera as Camera;
		
			_screenPosition = target.getLocalToWorldTransform().transformVector(Vector4.ZERO, _screenPosition);
			_screenPosition = camera.getWorldToLocalTransform().projectVector(_screenPosition, _screenPosition);
			
			var w : Number = viewport.width * .5;
			var h : Number = viewport.height * .5;
			
			_sprite.x = w + _screenPosition.x * w;
			_sprite.y = h + _screenPosition.y * -h;
		}
	}
}