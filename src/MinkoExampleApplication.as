package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.node.camera.TargetCamera;
	import aerys.minko.scene.node.group.Group;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Sprite
	{
		private var _viewport	: Viewport		= new Viewport();
		private var _camera		: TargetCamera	= new TargetCamera();
		private var _scene		: Group			= new Group(_camera);
		
		private var _cursor		: Point			= new Point();
		
		protected function get viewport() 	: Viewport		{ return _viewport; }
		protected function get scene() 		: Group			{ return _scene; }
		protected function get camera() 	: TargetCamera	{ return _camera; }
		
		public function MinkoExampleApplication()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(event : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			
			camera.distance = 5.;
			initializeScene();
			
			stage.frameRate = 30;
			stage.addChild(_viewport);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		protected function initializeScene() : void
		{
			// nothing
		}
		
		protected function enterFrameHandler(event : Event) : void
		{
			_viewport.render(_scene);
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void
		{
			if (event.buttonDown)
			{
				_camera.rotation.x -= (event.stageY - _cursor.y) * 0.01;
				_camera.rotation.y -= (event.stageX - _cursor.x) * 0.01;
			}
			
			_cursor.x = event.stageX;
			_cursor.y = event.stageY;
		}
	}
}