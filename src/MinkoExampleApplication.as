package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.group.StyleGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.type.controller.ArcBallController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Sprite
	{
		private var _viewport			: Viewport			= new Viewport();
		private var _camera				: Camera			= new Camera();
		private var _cameraController	: ArcBallController	= null;
		private var _scene				: StyleGroup		= new StyleGroup();
		
		private var _cursor				: Point				= new Point();
		
		protected function get viewport() : Viewport
		{
			return _viewport;
		}
		
		protected function get scene() : StyleGroup
		{
			return _scene;
		}
		
		protected function get camera() : Camera
		{
			return _camera;
		}

		protected function get cameraController() : ArcBallController
		{
			return _cameraController;
		}
		
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
			
			camera.lookAt.set(0., 0., 0.);
			camera.position.set(0., 0., -5.);
			
			var cameraGroup : TransformGroup = new TransformGroup(
				_camera
			);
			
			_cameraController = new ArcBallController(cameraGroup);
			_cameraController.bindDefaultControls(stage);
			
			_scene.addChild(cameraGroup);
			
			initializeScene();
			
			stage.frameRate = 30;
			stage.addChild(_viewport);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
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
		
		protected function mouseMoveHandler(event : MouseEvent) : void
		{
			// nothing
		}
		
		protected function mouseWheelHandler(event : MouseEvent) : void
		{
			// nothing
		}
		
		protected function keyDownHandler(event : KeyboardEvent) : void
		{
			// nothing
		}
	}
}