package aerys.minko.example.core.projection
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.type.math.Vector4;
	
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
			
			var screenPoint : flash.geom.Point = camera.project(target.getLocalToWorldTransform().getTranslation());
			
			_sprite.x = screenPoint.x;
			_sprite.y = screenPoint.y;
		}
	}
}